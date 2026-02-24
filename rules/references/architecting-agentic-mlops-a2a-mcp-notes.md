# Architecting Agentic MLOps: A2A + MCP Layered Pattern

**Source:** InfoQ article (Kapoor, Girija, Arora); PDF: `rules/references/architecting-agentic-mlops-a2a-mcp.pdf`
**Context:** Multi-agent MLOps; orchestration vs execution decoupling

---

## TL;DR

- **A2A** = agent-to-agent **communication bus** (discovery, peer-to-peer tasks).
- **MCP** = **universal language for capabilities** (tools, resources, prompts).
- Layering them gives: **orchestration logic separate from execution logic** — add capabilities without changing core communication.
- Pattern applies beyond MLOps wherever dynamic collaboration and adaptable capabilities matter.

---

## Role of Each Protocol

| Protocol | Role |
|----------|------|
| **A2A** | Agent Cards for discovery; agents find and task specialists via standard web (JSON/JSON-RPC); Linux Foundation governance. |
| **MCP** | Tools (actions), Resources (structured data), Prompts; MCP server = central hub; agents discover and use tools without custom glue. |

Orchestrator uses **A2A** to discover and call specialist agents; specialists use **MCP** to discover and call tools. No hardcoded specialist list, no hardcoded tool list.

---

## MLOps Shape (Example)

- **Orchestrator agent:** High-level goal → TaskList → discover/call Validation agent, then Deployment agent via A2A.
- **Validation agent:** Exposes skills via Agent Card; uses MCP tools (`fetch_model`, `validate_churn_model`) to run checks.
- **Deployment agent:** Same idea; MCP tools for deploy.

Flow: Query → Orchestrator creates plan → A2A call to Validation → Validation uses MCP tools → result back → if OK, A2A call to Deployment → Deployment uses MCP tools → result back.

---

## Why This Matters for Policy

- **Decoupling:** Orchestration (who does what, in what order) is separate from execution (how each agent does its job). Aligns with IntentCUA-style plan/task separation and with "don’t build monolithic agent scripts" in ai-workflow-policy.
- **Extensibility:** New agents or new MCP tools can be added without changing Orchestrator or specialist code. Fits "add capabilities without changing core communication."
- **Single reference, no template duplication:** The article and PDF contain Agent Card examples, MCP server/client snippets, and Task/TaskList patterns. This note points to them; we do not duplicate those as repo templates to avoid maintaining two sources when A2A/MCP evolve.

---

## When to Use This Pattern

- Multi-step MLOps workflows (validate → deploy) with multiple specialist agents.
- Any domain where you want dynamic agent discovery and tool discovery without hardcoding.
- When you need a clear split between "orchestrator" (planning, delegation) and "specialists" (tool use, execution).

---

## References

- PDF: `rules/references/architecting-agentic-mlops-a2a-mcp.pdf`
- [A2A Samples (GitHub)](https://github.com/google-a2a/a2a-samples)
- MCP: `rules/references/mcp-ecosystem-notes.md`
- Agent orchestration: `rules/ai-workflow-policy.md` §Agent Orchestration and Artifact Governance

---

*Last updated: 2026-02-24*
