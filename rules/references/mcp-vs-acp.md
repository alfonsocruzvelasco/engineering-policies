# MCP vs ACP
**ML / CV Engineer Reference**
*Model Context Protocol · Autonomous Control Pattern*

---

## MCP — Model Context Protocol

> **Mental model:** "USB-C for models."

| | |
|---|---|
| **What it is** | A standard protocol that lets an LLM securely access external tools, data, and services via a structured interface. |
| **Purpose** | Decouple models from tools. Make tool access explicit, inspectable, and permissioned. |

### Key Properties

| Property | Detail |
|---|---|
| Tool discovery | Via schema — the model learns what's available at runtime. |
| I/O contracts | Strict input/output contracts; no ambiguity at the boundary. |
| Execution model | Stateless calls — the model does not own execution. |
| Control | Human or orchestration system remains in control at all times. |

### Typical Uses
- Retrieval (RAG — Retrieval-Augmented Generation)
- File systems
- Databases
- APIs
- Dev tools (code execution, linting, testing)

### Strengths & Limitations

| Strengths ✅ | Limitations ❌ |
|---|---|
| Safety — bounded, auditable actions | No autonomy — only acts when called |
| Auditability — full trace of every call | No long-term goals — stateless by design |
| Composability — mix tools freely | No planning loop — requires external orchestration |
| Infrastructure-friendly — no surprises | |

---

## ACP — Autonomous Control Pattern

> **Mental model:** "AI with a steering wheel and gas pedal."
>
> *(Name varies: Agentic Control Pattern, Autonomous Agent Protocol — the concept is consistent.)*

| | |
|---|---|
| **What it is** | An agent architecture (not a strict protocol) where an AI system sets subgoals, plans, executes actions, observes outcomes, and loops until termination. |
| **Purpose** | End-to-end task completion with minimal human intervention. |

### Key Properties

| Property | Detail |
|---|---|
| Persistent state | Memory that survives across steps — the agent can track progress. |
| Plan + execute | Autonomous planning loop: plan → act → observe → revise. |
| Self-triggered | Actions are initiated by the agent, not by an external caller. |
| Built on MCP | Often uses MCP tools under the hood for safe world-access. |

### Typical Uses
- Autonomous coding and dev agents
- Workflow automation (multi-step)
- Multi-step reasoning systems
- Robotics and embodied AI control loops
- Perception pipelines with agentic orchestration

### Strengths & Limitations

| Strengths ✅ | Limitations ❌ |
|---|---|
| Power — handles complex, multi-step tasks end-to-end | Risky — failure modes compound across steps |
| Flexibility — adapts to changing context mid-task | Hard to bound — scope can expand unpredictably |
| Reduced human overhead — minimal intervention needed | Debugging is difficult — state is implicit and distributed |
| | Low production readiness by default |

---

## MCP vs ACP — Side-by-Side

| Dimension | MCP | ACP |
|---|---|---|
| Level | Protocol | Architecture / Pattern |
| Autonomy | ❌ None | ✅ High |
| Control | Human / orchestration system | Agent-driven |
| State | Stateless | Stateful (persistent memory) |
| Safety | High | Medium → Low (by default) |
| Debuggability | High | Low |
| Production readiness | High | Conditional |
| ML systems fit | Excellent | Dangerous unless tightly constrained |

### ⚠️ Correct Relationship (important)

**MCP is a building block. ACP is a system built on top of blocks like MCP. They are not competitors.**

- **MCP answers:** *"How does a model safely touch the world?"*
- **ACP answers:** *"Should the model decide what to do next?"*

### One-line takeaway (memorize this)

> **MCP gives models hands. ACP gives them a will.**

---

## ML/CV Engineer Guidance

### Correct Priority Order

| Priority | Area | Detail |
|---|---|---|
| 1️⃣ | **Core ML/CV skills** *(non-negotiable)* | Data → features → models → eval · Training/inference pipelines · Latency, memory, throughput · Failure modes & debugging · Deployment & monitoring |
| 2️⃣ | **MCP-level integration** *(important)* | How models call tools · Retrieval (RAG) · Structured I/O · Contracts & schemas · Safety & observability |
| 3️⃣ | **ACP** *(optional, edge cases)* | Relevant only when: building agent products · orchestrating multi-step tasks · CV is one component in a larger autonomous loop |

### Strong Opinion — Default Posture

**Default to MCP.** Add ACP only when:
- Tasks are well-bounded
- Failure cost is low
- Actions are reversible
- Observability is strong

**In safety-critical or production ML/CV systems:**

> **MCP first. ACP last. Sometimes never.**

### Why ACP Is Not Central to ML/CV

| | |
|---|---|
| ❌ Control complexity | ACP adds orchestration complexity without improving model signal quality. |
| ❌ Failure amplification | ACP amplifies failure modes — errors compound across the loop. |
| ❌ Testing & debugging | ACP is hard to test, debug, and bound in production. |
| ❌ Focus drift | ACP shifts attention away from model quality — the actual job. |

*Most production CV systems are: reactive, event-driven, bounded, and human-in-the-loop. ACP fights that.*

### When ACP Does Make Sense for You

Care about ACP only if you are moving toward:
- Robotics / embodied AI
- Multi-agent perception systems
- Autonomous pipelines with low human oversight

*Even then: ACP is a thin control layer on top of solid ML — not the core skill.*

### Final Verdict on ACP for ML/CV

- ❌ Not essential
- ❌ Not a hiring differentiator
- ⚠️ Easy to overinvest in
- ✅ Useful only at the edges (robotics, multi-agent, embodied AI)

👉 **If you have limited time: invest in models, data, systems, latency — not ACP.**

---

## Interview-Grade Answer

*Memorize this:*

> "For ML/CV engineers, ACP isn't a core competency. Most real systems require bounded, inspectable behavior, so we rely on MCP-style tool access and explicit orchestration. ACP is useful in niche agentic systems, but it increases risk and isn't appropriate by default."

— *Senior ML/CV Engineer answer*

---

## Next Steps (Optional Deep Dives)

If relevant to your trajectory:
- Map MCP & ACP to your control-plane spine — where does each sit?
- Identify where ACP would break production invariants in your current systems.
- Explore how ACP sits deliberately off the critical path in safety-critical CV pipelines.

*These are optional — pursue only if moving toward agentic or embodied AI.*
