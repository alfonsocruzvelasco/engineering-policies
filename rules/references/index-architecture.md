---
doc_type: reference-index
authority: supporting
owner: Alfonso Cruz
scope: Architecture, tools, retrieval, and systems design references
---

# Architecture & Systems References Index

**Canonical navigation:** Full catalog of `rules/references/` files in this scope; `README.md` lists only these three indexes, not each file.

Use this when you need **architectural background** rather than normative policy.

## Core Architecture

- `ai-systems-architecture.md` — Deterministic → probabilistic shift; six pillars; verification runtime; agent patterns (AUTHORITATIVE architecture reference).
- `architecture-notes.md` — Meta-review + adversarial critique of AI systems architecture; caveats on MCP vs CLI benchmarks, MoE numbers, and managed ingestion.
- `ai-agent-platform-infrastructure.md` — Event-driven agents as messaging interface; MCP-as-event-layer execution model.
- `software-architecture-in-machine-to-machine-systems.md` — Architecture for robots/agents/IoT; survivability and control surfaces.
- `cloudflare-pay-per-crawl-notes.md` — Pay-per-crawl data access governance and training-data pricing shift.
- `gemini-integration-in-new-chrome.md` — Chrome + Gemini Nano hybrid AI runtime architecture (local-first, cloud fallback).
- `openspec-ml-cv-reference.md` — OpenSpec ML/CV specification reference.
- `spec-protocols-guide.md` — Spec-driven development protocols guide.
- `the-sdlc-is-dead-boris-tane.pdf` — SDLC evolution and agent-driven development shift.
- `think-deep-not-just-long.pdf` — Deep reasoning vs extended reasoning in LLMs.
- `omni-simplemem-autoresearch-2026.pdf` — OMNI-SIMPLEMEM: lifelong
  multimodal agent memory discovered via autonomous research pipeline
  (Liu et al., UNC/UCB/UCSC/Cisco, Apr 2026). Architecture: selective
  ingestion with novelty filtering, Multimodal Atomic Units (MAU —
  hot metadata + cold raw storage), pyramid retrieval (summaries →
  details → raw, token-budgeted), hybrid dense/sparse/graph search.
  Key finding: bug fixes (+175%), prompt engineering (+188%), and
  architectural changes (+44%) each exceeded all hyperparameter tuning
  combined — validates Spec–Plan–Patch–Verify over random search.
  Relevant for: multimodal CV pipelines, agent memory at scale,
  autoresearch methodology. arXiv:2604.01007.

## Model layer vs agent system (evaluation note)

Portable distinction when comparing **LLMs** and **coding/agent runtimes** (no product endorsement):

> **Model layer (LLM):** reasoning, generation, multimodal input, function calling. **Agent system layer (execution):** tool orchestration, shell/API/file access, persistent state, workflow engine, security boundary. Models are **components inside** agent systems; they reduce orchestration complexity via function calling and structured outputs but do not by themselves provide the execution environment, durable memory model, or organizational security posture of an agent runtime. **Confusing the two** yields invalid comparisons: a new model treated as a drop-in replacement for an entire harness, or a harness treated as a substitute for upgrading the underlying model. **Initial gate:** classify the candidate by layer before any bake-off (see `../approved-ai-tools.md` — Tool Evaluation Process, Initial Screening).

## Tools, MCP, and Agents

- `mcp-ecosystem-notes.md` — Model Context Protocol ecosystem overview.
- `sql-and-mcp-notes-ml-cv.md` — SQL and MCP decision notes for ML/CV engineers.
- `mcp-vs-acp.md` — MCP (protocol) vs ACP (Autonomous Control Pattern) comparison.
- `claude-skills-definition-use-cases-and-limitations.md` — Claude Skills architecture.
- `cc-agent-teams-feature.md` — Claude Code Agent Teams architecture and token economics.
- `agent-orchestration.md` — Harness engineering, multi-agent coordination, security and token economics (supporting synthesis; binding controls remain in `ai-workflow-policy.md` and `security-policy.md`).
- `agent-hq-orchestration-complete-notes.md` — GitHub Agent HQ and orchestration patterns.
- `langgraph-engineering-notes.md` — LangGraph graphs, state, and multi-agent workflows.
- `api-hooks-usage-in-ai-agents.pdf` — API hooks usage patterns in AI agents.
- `artificial-hivemind.pdf` — Multi-agent swarm/hivemind coordination patterns.
- `code-mode-cloudflare.pdf` — Cloudflare Code Mode architecture and design.
- `cloudflare-ai-sandboxing.pdf` — Dynamic Workers / isolate-based sandboxing for AI-generated code with capability-scoped execution.
- `sandboxing-ai-agents-100x-faster.pdf` — Dynamic Worker Loader open beta: isolate-based sandboxing 100x faster than containers; Code Mode SDK, TypeScript tool APIs, credential injection, @cloudflare/codemode + worker-bundler + shell libraries.
- `codified-context-infrastructure-for-ai-agents-in-a-complex-codebase.pdf` — Agent context infrastructure for complex codebases.
- `context-engineering-for-coding-agents.pdf` — Context engineering techniques for coding agents.
- `context-rot.pdf` — Context degradation and staleness in AI systems.
- `intentcua.pdf` — IntentCUA architecture paper (structured intent + plan memory).
- `architecting-agentic-mlops-a2a-mcp.pdf` — Agentic MLOps A2A + MCP companion paper.
- `haven-t-written-code-in-two-months.pdf` — Agent-first development workflow reflections.
- `discovering-multiagent-learning-algorithms-with-llm.pdf` — Multi-agent algorithm discovery with LLMs.
- `agent-architecture-intentcua-notes.md` — IntentCUA agent architecture notes (structured intent + plan memory).
- `architecting-agentic-mlops-a2a-mcp-notes.md` — Agentic MLOps A2A + MCP companion notes.
- `claude-code-headless.md` — Headless Claude Code execution patterns.
- `rodney-notes.md` — Rodney CLI browser automation tool (Go + CDP).
- `sub-agents-ml-cv-notes.md` — Sub-agent patterns for ML/CV workflows.
- `simplify-command-report.pdf` — Claude Code `/simplify` skill internals and review agents.
- **[mattpocock/skills](https://github.com/mattpocock/skills)** (external) — Agent skills collection: PRD creation, issue decomposition, grill-me design interview, TDD, git guardrails, refactor planning, ubiquitous language, codebase architecture improvement.
- **[GSD (get-shit-done)](https://github.com/gsd-build/get-shit-done)** (external) — Context engineering, context rot prevention, wave-based parallel execution, XML task plans, atomic commits, PreToolUse guardrails, multi-agent orchestration, spec-driven development.
- **[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)** (external) — Osmani agent-skills: production SDLC skill pack for Claude Code; web-first but browser-testing and agent persona patterns are portable.
- `selkies-remote-gpu-workstation.md` — [Selkies](https://selkies-project.github.io/selkies/): remote GPU Linux desktop in the browser (WebRTC); optional vs SSH-only workflows; containers/Kubernetes; ML/CV GUI on remote compute.
- `cloudflare-agent-skills-discovery-rfc` — Cloudflare RFC (draft
  v0.1, 2026-01-17) for agent skill discovery via `.well-known` URIs:
  organisations publish skills at
  `https://example.com/.well-known/skills/index.json`; agents
  auto-discover and load capabilities without manual configuration.
  Three-level progressive loading: (1) index metadata ~100 tokens,
  (2) SKILL.md on activation <5k tokens, (3) referenced files
  on demand. Fills the gap between static AGENTS.md (repo context)
  and MCP (tool execution): cross-organisational runtime skill
  discovery. Status: draft — monitor for adoption before enforcing.
  Source: https://github.com/cloudflare/agent-skills-discovery-rfc
- `sema-code-semaclaw-harness-engineering` — Midea AIRC
  (arXiv:2604.11045 + arXiv:2604.11548, April 2026).
  Introduces "harness engineering" as the discipline of
  building infrastructure around a model to make it
  controllable, auditable, and production-reliable —
  as distinct from model capability. Provides the clearest
  published taxonomy of the four agent extension layers:
  (1) MCP Tools — action space, typed schema interface;
  (2) Subagents — reasoning scope, prompt interface;
  (3) Skills — capability/context, progressive injection;
  (4) Hooks — execution control, lifecycle callbacks.
  Each layer addresses a distinct engineering concern;
  conflating them produces systems that are harder to
  reason about and test. Note: papers reference OpenClaw
  extensively as the ecosystem reference architecture —
  OpenClaw remains prohibited under security-policy.md
  (credential harvesting, prompt injection vector);
  the architectural patterns described are separable
  from the tool.
  Sources: https://arxiv.org/abs/2604.11045
  https://arxiv.org/abs/2604.11548
- `the-agent-stack-bet.pdf` — **The Agent Stack Bet** (PDF).
  Provenance note only: a local copy was evaluated and is not usable
  as policy reference material under current controls, so no artifact
  is retained in `rules/references/`.

## Retrieval, Vector DBs, and RAG

- `vector-db-engineering-guide.md` — Vector DB engineering for ML/CV.
- `rag-engineering-notes.md` — RAG design and evaluation.
- `rag-production-notes.md` — Production RAG pipeline patterns.
- `rag-relevance-for-ides.md` — RAG in modern IDEs.
- `rag-vs-rerag-technical-reference.md` — RAG vs RERAG technical comparison.
- `a-comprehensive-survey-on-vector-database.pdf` — Comprehensive survey on vector database architectures.
- `efficient-and-robust-approximate-nearest-neighbor-search.pdf` — ANN search algorithms and structures.
- `refrag-regthinking-rag-based-decoding.pdf` — RERAG rethinking RAG-based decoding.
- `retrieval-augmented-generation-for-knowledge-intensive-nlp-tasks.pdf` — Original RAG paper (Lewis et al.).

## Performance & Model Architecture

- `opus-4.6-gpt-5.3-codex-policy-impact-analysis.md` — Model characteristics and policy impact.
- `python-3-14+-no-gil-support.md` — Free-threaded Python implications.
- `moe-notes.md` — Mixture-of-Experts implementation and pitfalls.
- `gemma-4-visual-guide.pdf` — Gemma 4 architecture reference (Grootendorst,
  Google DeepMind, Apr 2026): MoE 26B A4B (128 experts, 8 active + 1 shared 3×),
  dense 31B, E2B/E4B with Per-Layer Embeddings (flash offload); interleaved
  local/global attention (5:1), p-RoPE (p=0.25) on global layers, K=V global
  attention, GemmaVis ViT with 2D RoPE + variable aspect ratio + soft token
  budget. Conformer audio encoder (E2B/E4B only). Hardware envelope for this
  repo: E4B on RTX 4070 (12GB); 26B A4B via Cloudflare Workers AI.
- **[Google Gemma 4 26B A4B on Workers AI](https://developers.cloudflare.com/changelog/post/2026-04-04-gemma-4-26b-a4b-workers-ai/)** (external, 2026-04-04) — MoE (`@cf/google/gemma-4-26b-a4b-it`): 26B total parameters, ~4B active per forward pass, 256k context, vision, built-in thinking mode, function calling; Workers AI binding (`env.AI.run()`), REST (`/run`, `/v1/chat/completions`), [OpenAI-compatible endpoint](https://developers.cloudflare.com/workers-ai/configuration/open-ai-compatibility/). [Model page](https://developers.cloudflare.com/workers-ai/models/gemma-4-26b-a4b-it/). See `moe-notes.md` and `cloudflare-ai-sandboxing.pdf` for MoE and Workers isolate execution context.
- `accelerating-scientific-research-with-gemini.pdf` — Gemini for accelerating scientific research.
- `long-context-windows-opus-4.6+.md` — Long context windows for Opus 4.6+ (capabilities and constraints).
- `molap-ml-engineer-reference.md` — MOLAP analytics infrastructure context for ML/CV engineers.
- `claude-million-token-pricing-reference.md` — 1M context pricing shift (no long-context surcharge) and architecture implications.
- `stochastic-scheduling-ai-coding-agents.pdf` — Agents as bounded stochastic workers: pass@k geometric CDF, non-homogeneous Bernoulli model, optimal stopping, context poisoning, Spec–Plan–Patch–Verify protocol, token budget governance, reliability surface metrics.
- `best-gpu-for-llms-2026.pdf` — GPU selection and inference economics for LLM workloads (2026).

## Extracted Reference Companions

- `ai-workflow-prompt-patterns-reference.md` — Production patterns, COSTAR/CRISPE, slash commands, token-saving strategies, context engineering, theoretical foundations (extracted from `ai-workflow-policy.md` Part 2).
- `ai-workflow-agent-skills-reference.md` — Claude Code skills management, AI tools for ML/CV, agent delegation, scientific research workflows, learning protocol (extracted from `ai-workflow-policy.md` Part 1).
