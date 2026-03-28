---
doc_type: reference-index
authority: supporting
owner: Alfonso Cruz
scope: Security, AI safety, and eval references
---

# Security & Eval References Index

Use this when you need **supporting evidence** or deeper context for security and evaluation policies.

## AI Security & Code Safety

- `open-claw-security-policy.md` — OpenClaw agent risk and prohibition rationale.
- `integration-guide.md` — Integration guide for prohibited AI tools policy.
- `integration-reliability-ai-systems.md` — Integration reliability for AI systems.
- `ceros-claude-code-visibility-control-reference.md` — Ceros trust layer: visibility + runtime MCP/tool governance + cryptographically signed audit evidence.
- `ai-flaws-bedrock-langsmith-sglang-visibility-rce-exfil-reference.md` — Bedrock sandbox DNS egress escape + LangSmith URL/token safety + SGLang safe deserialization/broker RCE hardening reference.
- `cloudflare-ai-sandboxing.pdf` — Dynamic Workers isolate sandboxing, outbound filtering, and credential injection for AI-generated code execution.
- `sandboxing-ai-agents-100x-faster.pdf` — Dynamic Worker Loader (open beta): V8 isolate sandbox (100x faster, 10-100x less memory than containers), globalOutbound HTTP filtering, credential injection, battle-hardened security (auto-patched V8, second-layer sandbox, MPK, Spectre defenses).
- `owasp-top-10-for-llms-coverage-matrix.pdf` — OWASP Top 10 for LLMs coverage matrix.
- `secure-code-v-2-0.pdf` — Secure code generation practices v2.
- `security-vulnerabilities-in-ai-generated-code.pdf` — Security vulnerabilities in AI-generated code.
- `a-qualitative-study-on-security-practices-and-concerns.pdf` — Qualitative study on developer security practices.
- `the-dark-side-of-llms.pdf` — LLM risks, dark patterns, and adversarial concerns.

## Agentic Risks & Behavior

- `agents-of-chaos.pdf` — Agentic failure modes in deployed systems.
- `ai-pr-communication-notes.md` — PR communication, acceptance, and structure.
- `a-rational-analysis-of-the-effects-of-sycophantic-ai.pdf` — Sycophantic AI and hypothesis stress tests.

## Benchmarks & Evaluation

- `ai-mutation-testing-debugging-reference.md` — Mutation-based evaluation.
- `ai-systems-architecture.md` — Evals as runtime infrastructure.
- `rag-vs-rerag-technical-reference.md` — Evaluation trade-offs for retrieval systems.
- `mutation-testing-via-iterative-large-language-model-driven-scientific-debugging.pdf` — Mutation testing via iterative LLM-driven scientific debugging.
- `mutation-guided-llm-based-test-generation-at-meta.pdf` — Mutation-guided LLM test generation at Meta.
- `saving-swe-bench-a-benchmark-mutation-approach-for-realistic-agent-evaluation.pdf` — SWE-bench mutation approach for realistic agent evaluation.
- `swe-ci-evaluating-agent-capabilities.pdf` — SWE-CI benchmark for long-term agent maintenance.
- `harness-engineering.pdf` — Engineering harness design and verification patterns.
- `fairest-agent-comparison.md` — Fair agent comparison metrics (Pareto frontier analysis, accuracy/latency/cost).
