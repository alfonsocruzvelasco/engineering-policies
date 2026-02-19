# LangGraph Engineering Notes
> Engineer reference · February 2026 · Based on LangGraph v0.6+

---

## 1. Mental Model

LangGraph models agent workflows as **directed graphs**. Everything is explicit:

- **State** — shared data structure (snapshot at any point in time)
- **Nodes** — functions that receive state, do work, return updated state
- **Edges** — routing logic; fixed or conditional

> Nodes and edges are just functions. They can contain an LLM, a tool call, or plain Python logic.

The key insight: you are building a **state machine**, not a chat loop. Every step is observable, debuggable, and resumable.

---

## 2. Core Primitives

### State

Define state as a `TypedDict` (or Pydantic model). Use `Annotated` to attach **reducer functions** that control how updates merge.

```python
from typing import Annotated
from typing_extensions import TypedDict
import operator

class State(TypedDict):
    messages: Annotated[list, operator.add]   # reducer: append
    result: str                                # reducer: last-write-wins (default)
```

**Reducers** are critical. Without them, parallel node updates can silently overwrite each other.

Use `Overwrite` to bypass a reducer when you explicitly need to replace a value:

```python
from langgraph.types import Overwrite

def reset_node(state: State):
    return {"messages": Overwrite(value=[])}
```

---

### Nodes

A node is any callable that takes `state` and returns a partial state dict.

```python
def my_node(state: State) -> dict:
    response = llm.invoke(state["messages"])
    return {"messages": [response]}
```

Nodes can also accept `config: RunnableConfig` as a second argument to read runtime metadata (thread ID, step number, etc.).

---

### Edges

**Fixed edge:**
```python
builder.add_edge("node_a", "node_b")
```

**Conditional edge (routing):**
```python
def route(state: State) -> str:
    if state["result"] == "done":
        return END
    return "retry_node"

builder.add_conditional_edges("node_a", route)
```

**Fan-out (parallel) with `Send`:**
```python
from langgraph.types import Send

def fan_out(state: OverallState):
    return [Send("process_item", {"item": x}) for x in state["items"]]

builder.add_conditional_edges(START, fan_out, ["process_item"])
```

Results are aggregated back via the reducer on the target state key.

---

## 3. Graph Lifecycle

```python
from langgraph.graph import StateGraph, START, END

builder = StateGraph(State)

builder.add_node("agent", agent_fn)
builder.add_node("tools", tool_fn)

builder.add_edge(START, "agent")
builder.add_conditional_edges("agent", should_continue, ["tools", END])
builder.add_edge("tools", "agent")

graph = builder.compile()          # validates structure; required before use
result = graph.invoke({"messages": []})
```

`compile()` is where you attach checkpointers and breakpoints. **You cannot run the graph without calling it.**

---

## 4. Persistence & Checkpointing

Every "super-step" (node execution) can be checkpointed automatically. A checkpoint is a complete snapshot of the graph state at that moment.

### Checkpointer options

| Environment | Checkpointer | Import |
|---|---|---|
| Dev / testing | `InMemorySaver` | `langgraph.checkpoint.memory` |
| Production | `PostgresSaver` | `langgraph.checkpoint.postgres` |
| Production (lite) | `SqliteSaver` | `langgraph.checkpoint.sqlite` |

Switching checkpointers requires changing **one line**. Graph logic is untouched.

```python
from langgraph.checkpoint.memory import InMemorySaver
# from langgraph.checkpoint.postgres import PostgresSaver  # prod

checkpointer = InMemorySaver()
graph = builder.compile(checkpointer=checkpointer)
```

### Thread IDs

Threads isolate state across sessions. Always pass a `thread_id` in the config:

```python
config = {"configurable": {"thread_id": "user-session-42"}}
graph.invoke({"messages": [...]}, config=config)
```

Different thread IDs = separate state histories. Same thread ID = continuation of the same session.

### Fault tolerance

If a node crashes, re-invoke with the same `thread_id`. LangGraph resumes from the last successful checkpoint — it does not re-run completed nodes.

---

## 5. Human-in-the-Loop

The mechanism is `interrupt()` inside a node. Execution pauses, serializes state, and waits for a `Command(resume=...)`.

**Requires a checkpointer.**

```python
from langgraph.types import interrupt, Command

def approval_node(state: State):
    decision = interrupt("Review this plan and approve or reject:")
    return {"approved": decision}
```

Resume from outside the graph:
```python
# First invocation — pauses at interrupt
graph.invoke(input, config=config)

# Human reviews, then resumes
graph.invoke(Command(resume="approved"), config=config)
```

### Placement strategy

Put `interrupt()` before irreversible actions (API calls, writes, sends). Treat it like a transaction boundary.

For complex flows, add two interrupt points: one before the agent acts, one after it proposes a plan. This transforms a fully autonomous workflow into a human-collaborative one without restructuring the graph.

---

## 6. Multi-Agent Patterns

### Supervisor pattern

A supervisor node routes requests to specialized subagents based on content analysis.

```python
def supervisor(state: State) -> str:
    topic = classify(state["messages"])
    return topic  # routes to "research_agent", "code_agent", etc.

builder.add_conditional_edges("supervisor", supervisor, ["research_agent", "code_agent"])
```

### Subgraphs (modularity)

Compiled `StateGraph` instances can be used as nodes in a parent graph:

```python
subgraph = research_builder.compile()
parent_builder.add_node("research", subgraph)
```

This enables reuse, independent testing, and composable architectures.

### Map-Reduce

Fan out work with `Send`, aggregate via reducers:

```python
class OverallState(TypedDict):
    subjects: list[str]
    results: Annotated[list[str], operator.add]

def map_step(state: OverallState):
    return [Send("process", {"subject": s}) for s in state["subjects"]]
```

---

## 7. Recursion & Loop Control

LangGraph supports **cyclic graphs** (loops, iterative refinement). You control termination via:

1. Conditional edges that return `END`
2. `recursion_limit` in the config (default: 25)
3. Explicit step counters in state

```python
def route(state: State) -> str:
    if state["remaining_steps"] <= 2:
        return END
    return "agent"
```

Catch `GraphRecursionError` externally as a fallback:
```python
try:
    result = graph.invoke(input, {"recursion_limit": 10})
except GraphRecursionError:
    result = {"messages": ["Recursion limit exceeded — falling back."]}
```

---

## 8. Built-In Shortcuts

**`MessagesState`** — prebuilt state with `add_messages` reducer for conversation handling:
```python
from langgraph.graph import MessagesState
```

**`create_react_agent`** — prebuilt ReAct (Reasoning + Acting) agent:
```python
from langgraph.prebuilt import create_react_agent
agent = create_react_agent(llm, tools)
```

**`ToolNode`** — prebuilt node that executes tool calls from an LLM message:
```python
from langgraph.prebuilt import ToolNode
tool_node = ToolNode(tools)
```

Use these for standard patterns. Build custom nodes only when you need explicit control.

---

## 9. Streaming

LangGraph supports token-level and event-level streaming.

```python
for event in graph.stream(input, config=config):
    print(event)

# Token-level (LLM output only)
async for chunk in graph.astream(input, stream_mode="values"):
    print(chunk)
```

Use `astream` for async contexts (FastAPI, etc.).

---

## 10. Observability

LangGraph integrates natively with **LangSmith** for tracing with minimal setup. Every node invocation, state transition, and tool call is traced.

```python
import os
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_API_KEY"] = "..."
```

After that, every `graph.invoke()` is automatically traced. No instrumentation needed.

Alternatively, use **Langfuse** for open-source observability.

### What to instrument

- Token counts and costs per node
- Node latency (identify bottlenecks)
- State diffs between steps (catch silent overwrites)
- Recursion depth per run

---

## 11. Production Checklist

```
[ ] TypedDict state schema with explicit reducers
[ ] PostgresSaver or SqliteSaver checkpointer (not InMemorySaver)
[ ] Thread IDs assigned per user/session
[ ] interrupt() before all irreversible actions
[ ] recursion_limit set explicitly
[ ] GraphRecursionError caught and handled
[ ] LangSmith or Langfuse tracing enabled
[ ] Subgraphs tested independently
[ ] Async (ainvoke / astream) used in web service contexts
[ ] No business logic inside conditional edge functions (keep them routing-only)
```

---

## 12. Common Pitfalls

**State bleed in parallel execution.** If two nodes update the same key without a reducer, the last write wins silently. Always define reducers for keys that multiple nodes touch.

**Forgetting to compile.** `StateGraph` is a builder. You cannot call `invoke()` on it directly.

**InMemorySaver in production.** State is lost on process restart. Use a database-backed checkpointer.

**God nodes.** A node that does LLM call + tool execution + state cleanup + routing logic violates separation of concerns and is impossible to test. One responsibility per node.

**Mutable default state.** Python's mutable defaults (`[]`, `{}`) as state field defaults cause shared-state bugs across invocations. Always initialize state explicitly at invocation time.

**Missing thread_id.** Without a `thread_id`, checkpointing and human-in-the-loop won't work correctly. Make thread ID assignment part of your session initialization logic, not an afterthought.

---

## 13. When NOT to Use LangGraph

LangGraph adds complexity. Use it only when you need:

- Multi-step workflows with branching or cycles
- Persistent state across turns
- Human-in-the-loop checkpoints
- Multi-agent coordination

For single-turn tasks, simple tool use, or linear pipelines, `create_react_agent` or plain LangChain is sufficient. Don't over-engineer.

---

## 14. Quick Reference

```python
# Minimal working graph
from langgraph.graph import StateGraph, START, END
from langgraph.checkpoint.memory import InMemorySaver
from typing_extensions import TypedDict

class State(TypedDict):
    value: str

def my_node(state: State) -> dict:
    return {"value": state["value"] + "_processed"}

builder = StateGraph(State)
builder.add_node("my_node", my_node)
builder.add_edge(START, "my_node")
builder.add_edge("my_node", END)

graph = builder.compile(checkpointer=InMemorySaver())
result = graph.invoke({"value": "hello"}, config={"configurable": {"thread_id": "1"}})
# {"value": "hello_processed"}
```

---

*Sources: LangGraph official docs (docs.langchain.com), LangChain reference API, Towards Data Science LangGraph 101/201 series, LangGraph GitHub.*
