# Personal Engineering Policies (Authoritative)

## Source of Truth

This repository is the single source of truth for all engineering policies.

Canonical local path:
- `~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/`

Convenience symlinks:
- `~/dev/policies` -> `~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/`
- `~/learning-repos/policies` -> `~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/`
- `~/policies` -> `~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/`

**Status:** Authoritative
**Last updated:** 2026-03-12

This repository is the **single source of truth** for how software is designed, built, reviewed, shipped, secured, and maintained across all of my development work.

It defines **non-negotiable rules**, **explicit boundaries**, and **decision discipline** for professional-grade engineering.

> **Governance Notice**
> This repository is a **learning library**, not a project workspace. It stores book code, course materials, and reference implementations only.
>
> Any work that evolves into a real project (dependencies, environments, ongoing development, portfolio relevance) must be moved to a dedicated repository under `~/dev/repos/` in accordance with the **Learning Library Governance** section of my engineering policies.
>
> See the policies repository for the authoritative rules governing learning vs project boundaries.

---

## Purpose

This policy set exists to:

- Eliminate ambiguity and "works on my machine" behavior
- Prevent silent drift in tools, environments, and practices
- Make decisions explicit, reviewable, and reversible where possible
- Protect long-term maintainability over short-term convenience
- Ensure AI-assisted work remains correct, auditable, and safe
- Enforce prompt engineering discipline to reduce hallucinations and increase reproducibility

These policies are written for **real engineering work**, not experimentation folklore.

---

## Scope

These policies apply to:

- All personal repositories
- All local development environments
- All CI/CD pipelines
- All data, models, and artifacts
- All AI-assisted engineering work

They apply unless an **explicit exception** is recorded.

---

## Authority model

- This repository is **authoritative**
- If a rule is not documented here, it is **not authoritative**
- No undocumented exceptions are allowed
- Behavior must follow policy — **policy is updated before habits form**

All deviations require a recorded exception or decision.

---

## `/rules` structure

The `/rules` folder is organized around **compiled policy bundles** (merged documents) to reduce fragmentation and maintenance overhead, with domain-specific policies split for better navigation.

### Core system policy

- **`rules/development-environment-policy.md`**
  *Where and how work is organized and isolated on the machine*
  (directory layout, repo isolation, naming conventions, workspace discipline)

### Core production engineering policies

- **`rules/production-policy.md`** **[SPLIT 2026-02-02, UPDATED 2026-02-18]**
  *Core production engineering policy for CV/ML engineering, data systems, and tooling standards*
  (data/storage rules, SQL discipline, development environment setup, Git and Source Control Policy integrated, **scalable previews for code review (diffs + behavior + metrics)**, coding style, documentation, IDE policies, quality gates, Quick Reference Cards)
  *See also: [Testing Policy](rules/testing-policy.md), [Language Policies](rules/language-policies.md), [Web Policies](rules/web-policies.md), [Infrastructure Policy](rules/infrastructure-policy.md), [ML/CV Operations Policy](rules/ml-cv-operations-policy.md)*

- **`rules/testing-policy.md`** **[EXTRACTED 2026-02-02]**
  *Comprehensive testing standards for CV/ML engineering*
  (test classification: unit/integration/system, cross-cutting policies: determinism/AAA pattern/test data isolation, language-specific testing policies: Python/C++/CUDA/Rust/Go/TypeScript/Java, test execution environments, coverage requirements, test data management, test maintenance, TDD guidance, performance testing, contract testing, monitoring, anti-patterns, enforcement)

- **`rules/language-policies.md`** **[EXTRACTED 2026-02-02]**
  *Language-specific engineering standards*
  (Python: venv & dependency discipline, TypeScript/Node.js: npm & package management, Java: Maven/Gradle/Spring Boot, C/C++: CMake & modern C++, Rust: Cargo & workspace structure, CUDA: OpenCV/OpenGL & GPU programming)

- **`rules/web-policies.md`** **[EXTRACTED 2026-02-02]**
  *Web technology standards*
  (API design: REST/gRPC/MVC patterns, JavaScript/React: ES2020 baseline, React production patterns, WebGL graphics, D3 visualization, HTML/CSS: semantic markup, accessibility, modern CSS architecture)

- **`rules/infrastructure-policy.md`** **[EXTRACTED 2026-02-02]**
  *Infrastructure standards*
  (Docker/Podman: container fundamentals, multi-stage builds, image management, Kubernetes: fundamentals, workload rules, networking, security, Kafka: producers, consumers, operations, reliability)

- **`rules/ml-cv-operations-policy.md`** **[EXTRACTED 2026-02-02]**
  *ML/CV-specific operations*
  (model evaluation frameworks, feature engineering & feature stores, data quality & validation, model debugging & explainability, production inference patterns)

### AI retrieval and architecture policies

- **`rules/ai-retrieval-policy.md`** **[NEW 2026-03-07]**
  *Retrieval architecture standards, knowledge base governance, and context injection safety*
  (RAG formulation selection: RAG-Sequence vs RAG-Token, knowledge base ingestion rules, retrieval result sandboxing, MCP vs RAG decision, index hot-swapping, evaluation and monitoring metrics)

### AI and architecture policies

- **`rules/references/ai-systems-architecture.md`** **[MOVED 2026-02-01]**
  *Architectural patterns for AI-powered systems (deterministic → probabilistic shift)*
  (The six pillars of probabilistic architecture, verification as runtime infrastructure, context management systems, dual-state architecture, evals over unit tests, agent runtime patterns, robotics-specific considerations, production readiness checklist)
  *Previously `ai-systems-architecture-policy.md` — moved to references for clarity*

- **`rules/mlops-policy.md`** **[UPDATED 2026-02-18]**
  *Comprehensive MLOps practices for production ML/CV systems*
  (experiment tracking, model versioning & registry, model serving & inference, model monitoring, hyperparameter tuning, distributed training, model optimization, deployment patterns, lifecycle management, reproducibility, **engineering harness requirement for AI/ML projects (reproduction, validation, evaluation, performance, deployment, traceability harnesses)**, cost optimization, latency engineering for real-time systems, **probabilistic systems testing & evals**)

- **`rules/ml-experiment-tracking-policy.md`** **[NEW 2026-02-07]**
  *ML/CV experiment tracking for learning phase*
  (minimal tracking discipline: EXPERIMENTS.md log, git tags, dependency locking, project structure, data documentation, progressive tooling levels, anti-patterns, Cursor integration, success criteria, upgrade triggers)
  *Focus: Track enough to learn, not so much it slows you down. Start simple (Level 1: EXPERIMENTS.md + git tags), upgrade only when needed (Level 2: MLflow/W&B after 10+ experiments, Level 3: full MLOps when production-ready)*

- **`rules/ai-workflow-policy.md`** **[CONSOLIDATED 2026-02-01]**
  *Comprehensive AI workflow policy consolidating core workflow, prompt engineering, session management, and spec-driven development*
  - **Part 1: Core Workflow** — Cursor usage, sandbox enforcement, daily workflow, Cursor modes, guardrails, AI model usage (local vs cloud), Git discipline, MCP (Model Context Protocol), tool use security, verification-first mindset, operational readiness requirements
  - **Part 2: Prompt Engineering** — Operating principles, English-first architecture, prompt templates, COSTAR/CRISPE frameworks, slash commands library, token optimization, context engineering
  - **Part 3: Session Management** — Session types, parallel workflows, session lifecycle, metrics tracking, anti-patterns
  - **Part 4: Spec-Driven Development** — Protocol selection (**OpenSpec preferred for ML/CV**), mandatory checkpoints, integration patterns
  *Previously separate files: `ai-usage-policy.md`, `prompts-policy.md`, `session-management-policy.md`, `spec-driven-development-policy.md`*

### Security and compliance policies

- **`rules/security-policy.md`** **[CONSOLIDATED 2026-02-01, UPDATED 2026-02-07]**
  *Unified security policy consolidating core security baseline and AI-assisted coding security*
  - **Part 1: Core Security** — Secrets handling, IAM, OAuth 2.0, SSH & infrastructure access, API security, dependency security, cloud security, ML/CV security, prompt injection defense, mandatory verification gates
  - **Part 2: AI-Assisted Coding Security** — OWASP Top 10 for LLMs coverage, OAuth 2.0 for AI/agents, SSH & infrastructure access, API-calling agents security, tool use security with Guardrails AI, output sanitization, agent resource limits, prompt injection defense, ML/CV-specific security, supply chain security, four-layer verification gates, required security tooling, incident response
  - **Section 14.6: Prohibited External AI Tool Classes** — Prohibited tool categories, required tool characteristics, approved tool examples, enforcement and violation handling, developer resources
  *Previously separate files: `security-policy.md` (core) and `ai-coding-security-policy.md` (AI-specific)*

- **`rules/approved-ai-tools.md`** **[NEW 2026-02-07]**
  *Authoritative registry of approved AI coding tools*
  (approval criteria checklist, detailed tool profiles: Anthropic Claude API, OpenAI API, GitHub Copilot Enterprise, Cursor IDE, Claude Code, Ollama, recertification schedule, tool evaluation process, exception handling)

- **`rules/ai-tool-policy-quick-reference.md`** **[NEW 2026-02-07]**
  *Developer-facing quick reference guide for AI tool policy*
  (decision tree, common scenarios, security best practices, violation consequences, support channels, self-check checklist)

- **`rules/security-exceptions.md`**
  *Security exception log — tracks documented exceptions to security policies with justification, scope, and expiration*

### Documentation and versioning policies

- **`rules/documentation-policy.md`** **[SPLIT 2026-02-01]**
  *Documentation standards and exception/decision logging*
  (documentation discipline, quality standards, domain-specific ML/CV documentation standards, language standards and framework versions, exception and decision log templates)
  *See also: [ML/CV Documentation Standards](rules/references/ml-cv-documentation-standards.md) for comprehensive docstring and documentation generation guidance*

- **`rules/versioning-and-release-policy.md`** **[SPLIT 2026-02-01]**
  *Versioning schemes and release processes*
  (Semantic Versioning, tagging policy, changelog policy, release process, artifact policy, compatibility policy, hotfix policy)
  *Previously consolidated in `versioning-and-documenting-policy.md`*

### Templates and references

- **`rules/templates/`**
  *Reusable templates for common ML/CV engineering tasks*
  - `readme-template.md` — Standard README template with Technical Baseline section
  - `claude-md-template.md` — CLAUDE.md template for shared team knowledge and patterns
  - `agents-md-template.md` — AGENTS.md template for repo-level agent context (tooling, constraints, security landmines, agent selection, verification gates; keep under 150 lines; source: policies)
  - `mcp-template.md` — Model Context Protocol template for ML/CV production
  - `ml-cv-skills-template.md` — Skills assessment template for ML/CV engineers
  - `prompt-template.md` — Task card template for daily AI interactions (v3: concise, verification checkpoints, model-specific parameters, Osmani self-improving loop)
  - `domain-template.md` — Domain authority template for defining agent boundaries, legitimate skills, and verification requirements (execution, review, governance, planning, documentation domains)
  - `.cursorrules` — Authoritative Cursor/Codex rules template (scope, AI role, workflow, limits)
  - `terraform-devops-skills-template.md` — Skills assessment template for DevOps/Infrastructure engineers

- **Agent Selection** (integrated in `ai-workflow-policy.md`)
  *Quick decision tree for selecting the right AI agent from 9+ available models*
  (Policy/architecture → Opus 4.6, Procedural → GPT-5.3 Codex, Creative → Gemini 3 Pro, Speed → Haiku 4.5, model characteristics matrix, effort parameter guidance)

- **`rules/references/`**
  *Reference documentation and theoretical foundations*
  - `prompt-engineering-theory.md` — Theoretical foundation for prompt engineering
  - `ml-cv-documentation-standards.md` — Comprehensive ML/CV code documentation standards (Google-style, NumPy-style, Doxygen for C++/CUDA)
  - `mcp-ecosystem-notes.md` — Comprehensive Model Context Protocol (MCP) ecosystem documentation
  - `mcp-vs-acp.md` — MCP vs ACP: Model Context Protocol vs Autonomous Control Pattern comparison for ML/CV engineers (protocol vs architecture, safety trade-offs, when to use each, production guidance)
  - `spec-protocols-guide.md` — Guide on specification protocols (Spec Kit, OpenSpec, MCP)
  - `openspec-ml-cv-reference.md` — **AUTHORITATIVE** OpenSpec engineering reference for ML/CV teams (invariants, constraints, decision trees, ML/CV-specific patterns, failure modes, examples) — **OpenSpec is the preferred/default protocol for ML/CV engineering**
  - `python-3-14+-no-gil-support.md` — Python 3.14+ free-threaded mode (no-GIL) support and implications for ML/CV engineering
  - `vector-db-engineering-guide.md` — Vector database engineering guide for ML/CV (ANN structures, data plumbing, production patterns)
  - `rag-engineering-notes.md` — RAG (Retrieval-Augmented Generation) engineering notes for production systems (chunking, retrieval, reranking, prompt design, evaluation)
  - `rag-production-notes.md` — Comprehensive RAG production guide for ML/CV engineering (AST-based semantic chunking, hybrid retrieval, privacy-preserving architecture, incremental updates with Merkle trees, multi-modal RAG, implementation patterns, Cursor-style production RAG pipeline)
  - `rag-relevance-for-ides.md` — RAG in modern IDEs: why it still matters (2025) (precision and authority management over compression, Cursor RAG architecture, authority hierarchies, latency/cost realities, determinism and debuggability, modern RAG patterns, implementation guidance, decision framework)
  - `software-architecture-in-machine-to-machine-systems.md` — Comprehensive guide on software architecture evolution for autonomous systems, robots, IoT devices, and AI agents (safety-critical design, ethical-aware architecture, control surfaces, system survivability)
  - `fairest-agent-comparison.md` — Methodology for objectively comparing AI agents and prompting strategies (Pareto frontier analysis, utility scores, evaluation protocols for COSTAR/CRISPE/RTF/spec-driven approaches)
  - `self-improving-loop-integration.md` — Integration guide for Addy Osmani's self-improving loop pattern (atomic tasks → validation → knowledge capture → context reset), including modifications to CLAUDE.md, prompt, and MCP templates
  - `task-management-guide.md` — Comprehensive guide on breaking features into atomic tasks and executing them in a self-improving loop (task decomposition, tasks.json schema, execution workflow, best practices, troubleshooting, metrics)
  - `prompt-osmani-self-improving-loop.md` — Complete Osmani-style prompt template for atomic task execution (detailed version with full structure, learning capture, iteration protocol, troubleshooting)
  - `strategic-learning-model-usage.md` — Strategic framework for using AI agents during learning and skill-building phases, distinguishing between skills to build manually and tasks to delegate to agents
  - `agent-hq-orchestration-complete-notes.md` — Complete study notes on GitHub Agent HQ and agent orchestration (conceptual foundations, GitHub implementation, Mission Control, @ handlers, AGENTS.md, multi-agent workflows, Control Plane governance, best practices)
  - `cc-agent-teams-feature.md` — Complete Claude Code Agent Teams feature notes (comprehensive guide: setup, best use cases, display modes, usage patterns, token economics, technical architecture, coordination features, integration ecosystem, limitations, best practices, philosophy, references; released with Opus 4.6)
  - `long-context-windows-opus-4.6+.md` — Engineering reality of 1M token context windows (technical guide for ML engineers: context engineering discipline, RAG evolution, tooling shifts, evaluation challenges, cost/latency trade-offs, agent architecture shifts, design rules, templates, references; applies to Opus 4.6+ and other long-context models)
  - `opus-4.6-gpt-5.3-codex-policy-impact-analysis.md` — Opus 4.6 & GPT-5.3 Codex policy and template impact analysis (model characteristics, effort parameter guidance, agent selection, policy enforcement implications)
  - `ai-systems-architecture.md` — Architectural patterns for AI-powered systems (deterministic → probabilistic shift, six pillars, verification runtime, evals, agent runtime patterns)
  - `claude-skills-definition-use-cases-and-limitations.md` — Claude Skills: definition, use cases, and limitations (architectural shift from ephemeral prompts to persistent procedural workflows, vendor lock-in considerations, governance gaps, paradigm shift implications)
  - `gemini-integration-in-new-chrome.md` — Gemini integration documentation
  - `integration-guide.md` — Step-by-step integration guide for prohibited AI tools policy (Section 14.6), including file placement, pre-commit hook setup, CI/CD integration, and testing procedures
  - `open-claw-security-policy.md` — OpenClaw Security Policy & Risk Assessment (detailed analysis of OpenClaw/Molt/Clawdbot security vulnerabilities, architectural risks, prompt injection threats, mandatory isolation requirements, risk matrix, threat model; OpenClaw is PROHIBITED under security-policy.md Section 14.6)
  - `bypassing-cc-prompts-limit.md` — Technical workarounds for bypassing Claude Code prompt limits (infinite session log hack, subscription strategies, context sharding, brain swapping method)
  - `claude-code-headless.md` — Claude Code headless mode (CLI / Agent SDK) reference (separation of thinking and doing, permission models, when to use headless vs interactive, integration with verification instruments like Rodney, workflow patterns, alignment with verification-first mindset)
  - `ai-mutation-testing-debugging-reference.md` — AI mutation testing & debugging reference (mutation testing fundamentals, LLM debugging methods, OpenAI/Anthropic testing approaches, circuit tracing, alignment as correctness testing, practical implementation guidance)
  - `rag-vs-rerag-technical-reference.md` — RAG vs RERAG: Complete technical reference (traditional RAG limitations, RERAG architecture with token-level embeddings and RL-trained relevance filtering, compression techniques, when to use each approach, implementation considerations, integration with AGENTS.md research, practical recommendations)
  - `molap-ml-engineer-reference.md` — MOLAP (Multidimensional OLAP) reference for ML/CV engineers (legacy analytics infrastructure, why MOLAP is incompatible with ML pipelines, modern alternatives, interview-level understanding, when MOLAP appears in ML roles)
  - `langgraph-engineering-notes.md` — LangGraph engineering reference (directed graph state machines, state reducers, nodes and edges, checkpointing, human-in-the-loop, multi-agent patterns, when to use vs not use, production checklist, common pitfalls)
  - `cloudflare-pay-per-crawl-notes.md` — Cloudflare Pay-Per-Crawl: implications for ML/CV engineers (permissioned/priced web data, licensed datasets, pipeline design, data acquisition costs, dataset strategy as engineering responsibility)
  - `agent-architecture-intentcua-notes.md` — IntentCUA (arXiv:2602.17049): agentic architecture reference — skill abstractions, plan memory, intent-anchored planning, mandatory Critic, parameterized skill hints; policy rationale and key numbers
  - `sub-agents-ml-cv-notes.md` — Agents & sub-agents in ML/CV engineering (definitions, pipeline/tool-calling/orchestration roles, dataset/training/inference use cases, anti-patterns, design checklist)
  - `architecting-agentic-mlops-a2a-mcp-notes.md` — Architecting agentic MLOps with A2A + MCP (layered pattern: A2A for agent communication, MCP for tools; orchestration vs execution decoupling; reference only, no duplicate templates)
  - `knowledge-priming-notes.md` — Knowledge priming for conversational AI (Garg/Fowler; 7-section anatomy, curated sources, anti-patterns; distinct from minimal CLAUDE.md for agents; session priming policy in ai-workflow-policy)
  - `ai-pr-communication-notes.md` — How AI Coding Agents Communicate (arXiv:2602.17084, MSR 2026): PR description structure, merge rates by agent, conventional commits, sentiment vs acceptance; evidence for §5.5 PR requirements
  - `sql-and-mcp-notes-ml-cv.md` — SQL & MCP decision record for ML/CV (PostgreSQL as locked SQL dialect; Postgres-MCP crystaldba as the only MCP worth knowing; closed decision, minimal cognitive overhead)
  - `integration-reliability-ai-systems.md` — Integration reliability for AI systems (DZone framework; input contracts, upstream/downstream failure modes, low-confidence behavior; supports readme-template and production §5.13)
  - `rodney-notes.md` — Rodney (Simon Willison): browser automation for verification (CLI, accessibility tree, screenshots; use with Claude Code headless and verification-first workflow)
  - `moe-notes.md` — Mixture of Experts (MoE) engineering notes for ML/CV (sparse activation, router/expert-pool, HF Transformers v5+ native support, ViT/multimodal applicability, known problems: routing collapse, training complexity, deployment pain; reference stack)
  - PDF references: Vector database survey, ANN search papers, security practices, API hooks usage, OWASP Top 10 for LLMs coverage matrix, secure code practices, security vulnerabilities in AI-generated code, haven't written code in two months, mutation testing via iterative LLM-driven scientific debugging, mutation-guided LLM-based test generation at Meta, SWE-Bench benchmark mutation approach, 35 insights from Google by Addy Osmani, evaluating AGENTS.md (Gloaguen et al., 2026 — context files encourage broader exploration; agents respect instructions; unnecessary requirements make tasks harder; minimal files improve by 4%, comprehensive files reduce by 3% and increase costs 20%+), REFRAG: Rethinking RAG-based decoding, harness engineering (Martin Fowler — engineering infrastructure, scaffolding, and tooling for reliable AI/ML systems), **Code Mode: give agents an entire API in 1,000 tokens (Cloudflare, 2026-02-20 — server-side Code Mode technique for reducing MCP context window usage by 99.9%, Dynamic Worker isolate execution, comparison with client-side Code Mode/CLIs/dynamic tool search)**, **Think Deep, Not Just Long (Chen et al., 2026-02-12 — measuring LLM reasoning effort via deep-thinking tokens, DTR vs length/confidence baselines, Think@n test-time scaling, AIME/HMMT/GPQA benchmarks)**, **The Software Development Lifecycle Is Dead (Boris Tane, 2026-02-20 — SDLC collapse into intent/build/observe loop, context engineering as core skill, observability as safety net, agent-native workflows)**, **IntentCUA (arXiv:2602.17049 — multi-agent computer-use, intent-anchored plan memory, 74.83% task success, SER 0.91)**, **How AI Coding Agents Communicate (arXiv:2602.17084, MSR 2026 — 33,596 PRs, merge rates and review outcomes by agent, structured PRs vs verbosity)**, **Architecting Agentic MLOps: A2A and MCP (InfoQ — layered A2A communication + MCP capabilities, orchestration vs execution decoupling, MLOps validate/deploy pattern)**, **Stop Using /init for AGENTS.md (Addy Osmani, 2026-02-23 — auto-generated context files hurt agent performance +20% cost; only non-discoverable info earns a line; Lulla et al. ICSE JAWs 2026 + Gloaguen et al. ETH Zurich; AGENTS.md as diagnostic tool, not permanent config)**, **Prompt Repetition Improves Non-Reasoning LLMs (Leviathan et al., Google Research, arXiv:2512.14982 — repeating prompt fixes causal attention coverage gap; 47/70 wins, 0 losses; neutral for reasoning models; ×3 on NameIndex: 21% → 97%; no latency increase; applies to non-reasoning inference paths only)**, **Codified Context: Infrastructure for AI Agents in a Complex Codebase (Vasilopoulos, arXiv:2602.20478, Feb 2026 — three-tier context architecture: HOT constitution always-loaded, WARM specialist agents per-task, COLD knowledge base on-demand via MCP; 108K-line C# system, 283 sessions, 26K lines context infra; staleness as primary failure mode; G4 "if you explained it twice, write it down")**, **On the Impact of AGENTS.md Files on the Efficiency of AI Coding Agents (Lulla et al., ICSE JAWs 2026, arXiv:2601.20404 — 10 repos, 124 PRs, paired with/without design; 29% median runtime reduction, 17% median output token reduction; wall-clock and token savings statistically significant; AGENTS.md as measurable engineering constraint, not suggestion)**, **A Rational Analysis of the Effects of Sycophantic AI (Batista & Griffiths, Princeton, arXiv:2602.14270, Feb 2026 — Bayesian analysis: sycophantic AI samples from p(d|h*) not p(d|true process), inflating confidence without truth convergence; N=557 Wason 2-4-6 task; default GPT indistinguishable from explicit sycophancy; 5.9% discovery vs 29.5% unbiased; random sampling 5× more effective; RLHF creates confirmation feedback loop)**, **Discovering Multiagent Learning Algorithms with LLMs (Li et al., Google DeepMind, arXiv:2602.16928, Feb 2026 — AlphaEvolve LLM-driven code evolution discovers VAD-CFR and SHOR-PSRO, outperforming hand-designed MARL baselines; algorithm as genome, fitness-driven search loops; shift from designing algorithms to designing search frameworks; evaluation harness + swappable modules + automated discovery loops)**, **Agents of Chaos (Shapira et al., Northeastern/Harvard/MIT/CMU/Stanford, arXiv:2602.20021, Feb 2026 — 20-researcher red-team study of deployed LLM agents with persistent memory, email, Discord, shell; 11 case studies: non-owner compliance, identity spoofing, DoS via resource loops, report/action mismatch, cross-agent corruption, disproportionate remediation; L2→L3 autonomy gap; social coherence failures as primary attack surface)**, **The Complete Guide to Building Skills for Claude (Anthropic, 2026 — official skill authoring guide; SKILL.md + YAML frontmatter + progressive disclosure three-level system; three categories: Document/Asset, Workflow Automation, MCP Enhancement; skills as open standard portable across Claude.ai/Code/API; testing methodology: triggering, functional, performance comparison; distribution via zip upload, API /v1/skills, org-wide admin deployment)**, **Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks (Lewis et al., Facebook AI/UCL/NYU, NeurIPS 2020 — foundational RAG paper; DPR retriever + BART generator end-to-end; RAG-Sequence vs RAG-Token marginalization; SOTA on NQ/TQA/WQ/CT; more factual/specific/diverse than parametric-only; index hot-swapping for knowledge updates without retraining; non-parametric memory as human-readable/writable external knowledge)**, **Artificial Hivemind: The Open-Ended Homogeneity of Language Models (Jiang et al., UW/CMU/AI2/Stanford, NeurIPS 2025 — INFINITY-CHAT 26K open-ended queries; 79% intra-model similarity even at top-p=0.9/t=1.0; 71–82% inter-model similarity with verbatim overlaps across GPT/Qwen/DeepSeek/Llama; model ensembles do not guarantee diverse perspectives; reward models miscalibrated on similar-quality alternatives; decoding strategies insufficient to fix mode collapse; structural prompt variation required for genuine diversity)**

### Governance

- **`rules/system/learning-library-governance.md`**
  *Learning Library Governance: rules for learning repositories vs project workspaces*
  (graduation rule, focus rule, structural discipline — prevents scope drift in book code and course material repos)

- **`rules/system/learning-ai-usage-boundary.md`**
  *Learning Repository AI Usage Boundary: explicit AI usage boundaries for learning repositories*
  (learning-only classification, BYOAI-safe design, permitted vs restricted AI usage, ai-assisted-engineering folder boundaries, Cursor plugin workspace usage in learning repos, policy compliance statement, documentation requirements)

### Learning paths

- **AV Perception Learning Path** *(planned)*
  *Unified AV Perception Learning Path: Portfolio-First + Library-Guided Deep Study*
  (32-week curriculum for becoming a top-tier ML/CV engineer focused on autonomous vehicle perception, targeting Mobileye/Waymo Staff-Engineer standards)

### System configuration and infrastructure

- **`rules/system/`**
  *System-level configuration and infrastructure documentation*
  - **`containers/`** — Container and orchestration best practices
    - `docker-and-kubernetes-best-practices.md` — Docker and Kubernetes production patterns
    - `docker-compose-best-practices.md` — Docker Compose workflow patterns
    - `how-to-use-makefile-to-launch-prune-pods.md` — Makefile patterns for pod management
  - **`raid/`** — RAID storage configuration and setup procedures
    - `raid-system-set-up.md` — RAID array setup, monitoring, and maintenance
  - **`workspace/`** — `/workspace` backing store policies and procedures
  - **`scripts/`** — System automation and security validation scripts
    - `ai-security-check.sh` — AI-generated code security validation script implementing four-layer defense-in-depth (secrets scanning, SAST, dependency scanning, critical pattern checks)
    - `ai-prohibited-tools-check.sh` — Automated detection of prohibited AI tool usage (scans source files, Git history, network configs, environment variables, package manifests, generates violation reports)
    - `setup-sops-age.sh` — SOPS and Age key management setup script

---

## Policy relationships

```mermaid
graph TD
    A["Development Environment Policy<br/>Machine setup, directory layout, workspace isolation"] --> B["Production Policy<br/>Data, SQL, Git, Coding Style, Documentation, IDE, Quality Gates"]
    B --> T["Testing Policy<br/>Test classification, language-specific testing, CI/CD integration"]
    B --> L["Language Policies<br/>Python, TypeScript, Java, C++, Rust, CUDA"]
    B --> W["Web Policies<br/>API/REST/gRPC, JavaScript/React, HTML/CSS"]
    B --> I["Infrastructure Policy<br/>Docker/Kubernetes/Kafka"]
    B --> M["ML/CV Operations Policy<br/>Model evaluation, feature engineering, data quality"]
    B --> G["AI Systems Architecture<br/>Deterministic to Probabilistic shift, verification runtime, evals, agents"]
    G --> O["MLOps Policy<br/>Experiment tracking, model serving, evals, monitoring"]
    O --> E1["ML Experiment Tracking Policy<br/>Learning-phase tracking: EXPERIMENTS.md, git tags, minimal discipline"]
    O --> D1["Documentation Policy<br/>Documentation standards, exception/decision log"]
    O --> D3["Versioning and Release Policy<br/>SemVer, tagging, releases, artifacts"]
    D1 --> E["Security Policy<br/>Part 1: Core Security<br/>Part 2: AI-Assisted Coding Security"]
    B --> E
    D3 --> E
    E --> F["AI Workflow Policy<br/>Part 1: Core Workflow<br/>Part 2: Prompt Engineering<br/>Part 3: Session Management<br/>Part 4: Spec-Driven Development"]
    F --> O
    F --> E
    F --> T

    style A fill:#e1f5ff
    style B fill:#e1f5ff
    style T fill:#e1f5ff
    style L fill:#e1f5ff
    style W fill:#e1f5ff
    style I fill:#e1f5ff
    style M fill:#e1f5ff
    style G fill:#d4edda
    style O fill:#e1f5ff
    style D1 fill:#e1f5ff
    style D3 fill:#e1f5ff
    style E fill:#ffe1e1
    style E1 fill:#e1f5ff
    style F fill:#fff4e1
```

---

## How to use this repository

Consult these policies when you:

- Start a new project
- Introduce a new tool, dependency, or workflow
- Change environment layout or build strategy
- Add AI into any part of engineering work
- Handle data, models, or production artifacts
- Feel unsure about "what is allowed"

Update these policies when:

- Reality changes in a durable way
- A rule proves insufficient or incorrect
- A new class of risk or failure appears

---

## Change discipline

Policies change deliberately, not casually.

Every meaningful change requires:

- a clear rationale
- an owner
- a date
- an entry in the exception/decision log (inside `documentation-policy.md`)

This repository is **infrastructure**, not documentation noise.

---

## Quick reference

### Starting a new ML/CV project

1. Review `rules/development-environment-policy.md` for directory structure and workspace isolation
2. Review `rules/production-policy.md` for data/storage rules, SQL discipline, and development environment setup
3. Review `rules/language-policies.md` for language-specific standards (Python, TypeScript, Java, C++, Rust, CUDA)
4. Review `rules/testing-policy.md` for testing standards and CI/CD integration
5. Review `rules/references/ai-systems-architecture.md` for LLM/AI system architecture patterns
6. Review `rules/mlops-policy.md` for experiment tracking, model serving, and monitoring setup
7. Review `rules/ml-experiment-tracking-policy.md` for learning-phase experiment tracking (EXPERIMENTS.md, git tags, minimal tracking discipline)
8. Review `rules/ml-cv-operations-policy.md` for ML/CV-specific operations (model evaluation, feature engineering, data quality)
9. Review `rules/production-policy.md` §5 (Git and Source Control) for Git workflow and branching model
10. Review `rules/versioning-and-release-policy.md` for versioning schemes and release processes
11. Review `rules/security-policy.md` for secrets handling and ML/CV security
12. Review `rules/ai-workflow-policy.md` Part 1 for Cursor sandbox rules and daily workflow
13. Review `rules/ai-workflow-policy.md` Part 4 for structured spec workflows (**OpenSpec preferred for ML/CV**, see `rules/references/openspec-ml-cv-reference.md`)
14. Check `rules/system/raid/` for RAID storage setup if working with large datasets
15. Use `rules/templates/` for standard project structures and prompts (see `readme-template.md` for README with Technical Baseline)

### Using AI assistance

1. **Cursor only** for coding (see `ai-workflow-policy.md` Part 1)
2. **Session discipline** — Use parallel sessions for focused work, follow session lifecycle (see `ai-workflow-policy.md` Part 3)
3. **English-first** for all prompts (see `ai-workflow-policy.md` Part 2)
4. **Plan Mode first** — Start with planning for multi-file tasks (see `ai-workflow-policy.md` Part 1)
5. **Spec-driven development** — Use **OpenSpec (preferred for ML/CV)** or Spec Kit/MCP for multi-file features (see `ai-workflow-policy.md` Part 4 and `rules/references/openspec-ml-cv-reference.md`)
6. **Verification required** for all AI-generated code (verification-first paradigm)
7. **Sandbox restriction** to `/home/alfonso/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/`
8. **AI code review protocol** — Follow systematic review process (see `ai-workflow-policy.md` Part 1)
9. **AI security framework** — Follow comprehensive security controls (see `security-policy.md` Part 2)
10. **Use templates** — Start from `rules/templates/` for common tasks (`prompt-template.md`, `mcp-template.md`, `claude-md-template.md`, `agents-md-template.md`, `domain-template.md`, `.cursorrules`)
11. **Select the right agent** — See [Agent Selection Decision Tree](rules/ai-workflow-policy.md#agent-selection-decision-tree) in `ai-workflow-policy.md` for model selection
12. **Reference theory** — Consult `rules/references/prompt-engineering-theory.md` for theoretical foundations
13. **MCP integration** — See `rules/references/mcp-ecosystem-notes.md` for comprehensive MCP documentation

### Security checklist

1. No secrets in Git (see `security-policy.md`)
2. MFA enabled for all accounts
3. Dependencies scanned for vulnerabilities
4. ML/CV models and data access-controlled
5. AI tools never receive secrets or sensitive data
6. OAuth 2.0 tokens minimal-scope for AI/agents (see `security-policy.md` Part 2, Section 3)
7. SSH/infrastructure access never granted to AI tools (see `security-policy.md` Part 2, Section 4)
8. Tool use security enforced via Guardrails AI (see `security-policy.md` Part 2, Section 5)
9. All AI output passes four-layer verification gates before merge (see `security-policy.md` Part 2, Section 11)
10. Required security tooling deployed (see `security-policy.md` Part 2, Section 14)
11. **Run `ai-security-check.sh`** before committing AI-generated code (see `rules/system/scripts/ai-security-check.sh`)
12. **Use only approved AI tools** — Check `approved-ai-tools.md` before using any AI coding tool (see `security-policy.md` Section 14.6)
13. **Pre-commit hooks active** — Prohibited AI tool detection runs automatically via `.pre-commit-config.yaml` (see `rules/system/scripts/ai-prohibited-tools-check.sh`)

### System infrastructure

1. **RAID setup** — See `rules/system/raid/raid-system-set-up.md` for storage configuration
2. **Workspace backing** — `/workspace` RAID-backed storage policies in `rules/system/workspace/`
3. **Large datasets** — Always use symlinks from `$HOME` to `/workspace` for data volumes
4. **System scripts** — Automation and security validation tools:
   - **`ai-security-check.sh`** — AI-generated code security validation
     - **Usage**: Run from repository root: `./rules/system/scripts/ai-security-check.sh`
     - **Purpose**: Implements four-layer defense-in-depth (secrets scanning, SAST, dependency scanning, critical pattern checks)
     - **When to use**: Before committing any AI-generated code
     - **Requirements**: Must be run from repo root (where `.git` exists)
     - **Output**: Reports critical errors (blocking) and warnings (review required)
   - **`ai-prohibited-tools-check.sh`** — Prohibited AI tool detection
     - **Usage**: `./rules/system/scripts/ai-prohibited-tools-check.sh [--strict] [--repo-path PATH]`
     - **Purpose**: Scans for prohibited AI tool usage (source files, Git history, network configs, environment variables, package manifests)
     - **When to use**: Automatically via pre-commit hook, or manually for audits
     - **Requirements**: Bash, grep, git (for history scanning)
     - **Output**: Detailed violation report with file locations and patterns
   - **`setup-sops-age.sh`** — SOPS and Age key management setup
     - **Usage**: Run once to set up secret management: `./rules/system/scripts/setup-sops-age.sh`
     - **Purpose**: Installs `age` and `sops`, generates encryption keys, configures environment
     - **When to use**: Initial setup for secret management (idempotent, safe to run multiple times)
     - **Requirements**: Requires `sudo` access for package installation
     - **Output**: Creates `~/.config/sops/age/keys.txt`, configures `SOPS_AGE_KEY_FILE` in `~/.bashrc`, runs encryption test
5. **Container best practices** — See `rules/system/containers/` for Docker, Kubernetes, and Docker Compose patterns

### Learning and professional development

1. **AV Perception Learning Path** — See learning path documentation for comprehensive 32-week curriculum
   - Stage 1: Modern Detection Foundations + Code Hygiene
   - Stage 2: 3D Perception + Sensor Fusion
   - Stage 3: Tracking & Trajectory Prediction
   - Stage 4: Production Engineering & Safety-Critical Systems

---

## Final rule

If behavior and policy diverge, **policy must be updated first** —
never the other way around.
