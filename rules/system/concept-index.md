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
| Claude Code Web (browser / cloud agent) vs local Claude Code | `rules/claude-code-web-usage-policy.md` | `rules/security-policy.md` §14, `rules/approved-ai-tools.md` (Claude Code) |
| Event-driven agent execution (Channels, async messaging interface) | `rules/ai-workflow-policy.md` | `rules/references/ai-agent-platform-infrastructure.md` |
| Executable output and sandboxed code execution | `rules/ai-workflow-policy.md`, `rules/security-policy.md` §§8.2-8.4, §14.4 | `rules/references/code-mode-cloudflare.pdf`, `rules/references/cloudflare-ai-sandboxing.pdf`, `rules/references/sandboxing-ai-agents-100x-faster.pdf` |
| English-first prompts & multilingual strategy | `rules/ai-workflow-policy.md` (Part 2: Prompt Engineering) | `rules/references/a-fail-comparison-without-translationese.pdf`, `rules/references/do-multilingual-language-models-think-better-in-english.pdf`, `rules/references/do-multilingual-llms-think-in-english.pdf`, `rules/references/do-all-languages-cost-the-same.pdf` |
| Prompt tone / politeness effects | `rules/ai-workflow-policy.md` (Prompt Operating Principles, COSTAR/CRISPE) | `rules/references/mind-your-tone.pdf`, `rules/references/should-we-respect-llm.pdf` |
| Prompt engineering theory (temperature, structure, evals) | `rules/ai-workflow-policy.md` | `rules/references/prompt-engineering-theory.md`, `rules/references/ai-workflow-prompt-patterns-reference.md` |
| Token optimization, slash commands, and context engineering | `rules/ai-workflow-policy.md` (Part 2 summary) | `rules/references/ai-workflow-prompt-patterns-reference.md` |
| Skills management, agent delegation, and learning protocol | `rules/ai-workflow-policy.md` (Part 1 summary) | `rules/references/ai-workflow-agent-skills-reference.md` |
| PRD gate and issue decomposition (mandatory for >2h work) | `rules/ai-workflow-policy.md` Part 4 (PRD Gate) | `rules/templates/prd-template.md` |
| Design stress test (grill-me) and PRD-to-plan workflow | `rules/ai-workflow-policy.md` Part 4 (Design Stress Test) | [grill-me](https://github.com/mattpocock/skills/tree/main/grill-me), [prd-to-plan](https://github.com/mattpocock/skills/tree/main/prd-to-plan) |
| Context rot prevention and wave-based execution | `rules/ai-workflow-policy.md` Part 1 (Context Rot Prevention, Wave-Based Execution) | [GSD](https://github.com/gsd-build/get-shit-done) |
| Ubiquitous language (DDD glossary extraction) | `rules/ai-workflow-policy.md` Part 4 (Before Writing Code checklist) | [ubiquitous-language](https://github.com/mattpocock/skills/tree/main/ubiquitous-language) |
| Spec-driven development (OpenSpec, protocols) | `rules/ai-workflow-policy.md` Part 4 | `rules/references/spec-protocols-guide.md`, `rules/references/openspec-ml-cv-reference.md` |
| Hallucination posture (likelihood vs truth, CoT-as-proof, RAG as mitigation not guarantee) | `rules/llm-usage-policy-hallucinations.md` | `rules/ai-workflow-policy.md` §6, Hallucination & Consequence Test; `rules/ai-retrieval-policy.md`; `rules/references/a-survey-of-large-language-models.pdf` |

## Security & AI Tools

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| Secrets, IAM, infra access, API security | `rules/security-policy.md` | Cloud/provider docs as cited inside `security-policy.md` |
| OWASP cheat sheet alignment (npm; pip/PyPI equivalent controls) | `rules/security-policy.md` §9.3 | [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/index.html), [NPM Security](https://cheatsheetseries.owasp.org/cheatsheets/NPM_Security_Cheat_Sheet.html) |
| Dependency install discipline (checklist) | `rules/dependency-install-policy.md` | `rules/security-policy.md` §§9–9.4, `rules/language-policies.md` |
| Claude Code npm / fake "leaked source" repos (supply chain, typosquat names) | `rules/security-policy.md` §9.4 | [THN Apr 2026](https://thehackernews.com/2026/04/claude-code-tleaked-via-npm-packaging.html), `rules/references/open-claw-security-policy.md` (fake installer parallel), `rules/approved-ai-tools.md` (Claude Code) |
| AI-assisted coding security (tool use, OWASP LLM) | `rules/security-policy.md` Part 2 | `rules/references/ai-mutation-testing-debugging-reference.md`, `rules/references/integration-reliability-ai-systems.md` |
| Prohibited AI tools & enforcement | `rules/security-policy.md` §14.6, `rules/approved-ai-tools.md` | `rules/ai-tool-policy-quick-reference.md`, `rules/references/integration-guide.md`, `rules/references/open-claw-security-policy.md` |
| Claude subscription vs third-party harness billing (API / extra usage) | `rules/security-policy.md` §14.6, `rules/approved-ai-tools.md` (approval criteria) | Vendor communications (Anthropic, April 2026) |
| OpenClaw / agentic endpoint risk | `rules/security-policy.md` §14.6 (prohibited) | `rules/references/open-claw-security-policy.md` (incl. §10 vs Codex CLI — not interchangeable) |
| PreToolUse agent guardrail hooks (git, prompt injection, file deny-lists) | `rules/security-policy.md` §8.1.1 | [git-guardrails-claude-code](https://github.com/mattpocock/skills/tree/main/git-guardrails-claude-code), [GSD](https://github.com/gsd-build/get-shit-done) |
| Runtime agent governance (visibility + signed audit logs) | `rules/security-policy.md` §8.1 | `rules/references/ceros-claude-code-visibility-control-reference.md`, `rules/references/security-enterprise-controls-reference.md` |
| Enterprise security controls (trust layer, OIDC, logging) | `rules/security-policy.md` (summaries) | `rules/references/security-enterprise-controls-reference.md` |
| Agent runtime egress hardening + observability URL safety + safe deserialization | `rules/security-policy.md` §§8.2-8.4 | `rules/references/ai-flaws-bedrock-langsmith-sglang-visibility-rce-exfil-reference.md` |

## Architecture & Retrieval

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| Deterministic → probabilistic architecture shift | `rules/references/ai-systems-architecture.md` (marked **Authoritative**) | `rules/references/architecture-notes.md`, `rules/references/opus-4.6-gpt-5.3-codex-policy-impact-analysis.md` |
| MCP vs CLI vs UTCP tool layers | `rules/ai-workflow-policy.md` (MCP section) | `rules/references/mcp-ecosystem-notes.md`, `rules/references/mcp-vs-acp.md`, `rules/references/architecture-notes.md` |
| Mixture of Experts (MoE) patterns | `rules/references/moe-notes.md` | `rules/references/ai-systems-architecture.md` |
| Retrieval / RAG architecture | `rules/ai-retrieval-policy.md` | `rules/references/vector-db-engineering-guide.md`, `rules/references/rag-engineering-notes.md`, `rules/references/rag-production-notes.md`, `rules/references/rag-vs-rerag-technical-reference.md` |
| Long-context vs retrieval architecture (1M-token pricing shift) | `rules/ai-workflow-policy.md` (Opus 4.6 capabilities) | `rules/references/claude-million-token-pricing-reference.md`, `rules/references/long-context-windows-opus-4.6+.md` |
| Stochastic scheduling and token budget governance (pass@k, stopping rules, p-stabilization) | `rules/ai-workflow-policy.md` (Stochastic Scheduling principle, Agent Cost Budgeting) | `rules/references/stochastic-scheduling-ai-coding-agents.pdf` |
| Remote GPU Linux desktop via browser (WebRTC, optional) | — (supporting only) | `rules/references/selkies-remote-gpu-workstation.md`, [Selkies docs](https://selkies-project.github.io/selkies/) |

## Production Engineering & MLOps

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| CV/ML production engineering baseline | `rules/production-policy.md` | Language/infra-specific policies referenced from it |
| Testing strategy across languages & layers | `rules/testing-policy.md` | `rules/references/ai-mutation-testing-debugging-reference.md` |
| Deep modules and vertical-slice TDD | `rules/testing-policy.md` (§7.8 TDD Guidance) | [tdd](https://github.com/mattpocock/skills/tree/main/tdd), [improve-codebase-architecture](https://github.com/mattpocock/skills/tree/main/improve-codebase-architecture) |
| MLOps, model lifecycle, harnesses | `rules/mlops-policy.md` | `rules/references/integration-reliability-ai-systems.md` |
| LLM inference GPU selection / economics | `rules/mlops-policy.md` (inference, GPU, cost) | `rules/references/best-gpu-for-llms-2026.pdf` |
| ML/CV experiment tracking (learning phase) | `rules/ml-experiment-tracking-policy.md` | Repo READMEs using `EXPERIMENTS.md` |

## Templates & Governance

| Concept | Authoritative policy | Supporting references |
|--------|----------------------|-----------------------|
| Learning vs project repo governance | `rules/system/learning-library-governance.md` | `rules/system/learning-ai-usage-boundary.md` |
| Agent context files (`CLAUDE.md`, `AGENTS.md`) | `rules/ai-workflow-policy.md` (session priming + skills management) | `rules/references/agent-hq-orchestration-complete-notes.md`, `rules/references/ai-pr-communication-notes.md`, `rules/references/knowledge-priming-notes.md` |
| MCP integration for ML/CV systems | `rules/ai-workflow-policy.md` (MCP section), `rules/ai-retrieval-policy.md` | `rules/references/mcp-ecosystem-notes.md`, `rules/references/sql-and-mcp-notes-ml-cv.md` |

---

> **How to extend this file**
> - Add a new row when you introduce a *new concept* or a *new authoritative policy*.
> - Prefer editing this index over duplicating explanations across multiple policies.
> - Keep row descriptions short; the policies and references hold the detail.
