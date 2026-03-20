---
doc_type: system
authority: supporting
owner: Alfonso Cruz
scope: Concept-to-authority lookup for policies and references
---

# Concept Index (Authority Lookup)

**Purpose:** Fast lookup from a concept to the **authoritative policy** and **supporting references**. This file is descriptive, not normative.

> **Rule:** When concepts overlap, defer to the file listed under **Authoritative policy**. Other documents are references only.

---

## AI Workflow & Prompting

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| AI-assisted development workflow (Cursor, agents, sessions) | `rules/ai-workflow-policy.md` | `rules/references/ai-systems-architecture.md`, `rules/references/architecture-notes.md` |
| Event-driven agent execution (Channels, async messaging interface) | `rules/ai-workflow-policy.md` | `rules/references/ai-agent-platform-infrastructure.md` |
| English-first prompts & multilingual strategy | `rules/ai-workflow-policy.md` (Part 2: Prompt Engineering) | `rules/references/a-fail-comparison-without-translationese.pdf`, `do-multilingual-language-models-think-better-in-english.pdf`, `do-multilingual-llms-think-in-english.pdf`, `do-all-languages-cost-the-same.pdf` |
| Prompt tone / politeness effects | `rules/ai-workflow-policy.md` (Prompt Operating Principles, COSTAR/CRISPE) | `rules/references/mind-your-tone.pdf`, `should-we-respect-llm.pdf` |
| Prompt engineering theory (temperature, structure, evals) | `rules/ai-workflow-policy.md` | `rules/references/prompt-engineering-theory.md` |
| Spec-driven development (OpenSpec, protocols) | `rules/ai-workflow-policy.md` Part 4 | `rules/references/spec-protocols-guide.md`, `openspec-ml-cv-reference.md` |

## Security & AI Tools

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| Secrets, IAM, infra access, API security | `rules/security-policy.md` | Cloud/provider docs as cited inside `security-policy.md` |
| AI-assisted coding security (tool use, OWASP LLM) | `rules/security-policy.md` Part 2 | `rules/references/ai-mutation-testing-debugging-reference.md`, `integration-reliability-ai-systems.md` |
| Prohibited AI tools & enforcement | `rules/security-policy.md` §14.6, `rules/approved-ai-tools.md` | `rules/ai-tool-policy-quick-reference.md`, `rules/references/integration-guide.md`, `rules/references/open-claw-security-policy.md` |
| OpenClaw / agentic endpoint risk | `rules/security-policy.md` §14.6 (prohibited) | `rules/references/open-claw-security-policy.md` |
| Runtime agent governance (visibility + signed audit logs) | `rules/security-policy.md` §8.1 | `rules/references/ceros-claude-code-visibility-control-reference.md` |
| Agent runtime egress hardening + observability URL safety + safe deserialization | `rules/security-policy.md` §§8.2-8.4 | `rules/references/ai-flaws-bedrock-langsmith-sglang-visibility-rce-exfil-reference.md` |

## Architecture & Retrieval

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| Deterministic → probabilistic architecture shift | `rules/references/ai-systems-architecture.md` (marked **Authoritative**) | `rules/references/architecture-notes.md`, `rules/references/opus-4.6-gpt-5.3-codex-policy-impact-analysis.md` |
| MCP vs CLI vs UTCP tool layers | `rules/ai-workflow-policy.md` (MCP section) | `rules/references/mcp-ecosystem-notes.md`, `rules/references/mcp-vs-acp.md`, `rules/references/architecture-notes.md` |
| Mixture of Experts (MoE) patterns | `rules/references/moe-notes.md` | `rules/references/ai-systems-architecture.md` |
| Retrieval / RAG architecture | `rules/ai-retrieval-policy.md` | `rules/references/vector-db-engineering-guide.md`, `rag-engineering-notes.md`, `rag-production-notes.md`, `rag-vs-rerag-technical-reference.md` |

## Production Engineering & MLOps

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| CV/ML production engineering baseline | `rules/production-policy.md` | Language/infra-specific policies referenced from it |
| Testing strategy across languages & layers | `rules/testing-policy.md` | `rules/references/ai-mutation-testing-debugging-reference.md` |
| MLOps, model lifecycle, harnesses | `rules/mlops-policy.md` | `rules/references/integration-reliability-ai-systems.md` |
| ML/CV experiment tracking (learning phase) | `rules/ml-experiment-tracking-policy.md` | Repo READMEs using `EXPERIMENTS.md` |

## Templates & Governance

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| Learning vs project repo governance | `rules/system/learning-library-governance.md` | `rules/system/learning-ai-usage-boundary.md` |
| Agent context files (`CLAUDE.md`, `AGENTS.md`) | `rules/ai-workflow-policy.md` (session priming + skills management) | `rules/references/agent-hq-orchestration-complete-notes.md`, `ai-pr-communication-notes.md`, `knowledge-priming-notes.md` |
| MCP integration for ML/CV systems | `rules/ai-workflow-policy.md` (MCP section), `rules/ai-retrieval-policy.md` | `rules/references/mcp-ecosystem-notes.md`, `sql-and-mcp-notes-ml-cv.md` |

---

> **How to extend this file**
> - Add a new row when you introduce a *new concept* or a *new authoritative policy*.
> - Prefer editing this index over duplicating explanations across multiple policies.
> - Keep row descriptions short; the policies and references hold the detail.

