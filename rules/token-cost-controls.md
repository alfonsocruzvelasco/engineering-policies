---
doc_type: policy
authority: authoritative
owner: Alfonso Cruz
scope: Token economy, prompt sizing, response bounds, caching, and usage logging for LLM and agent workflows
---

# Token Cost Controls

**Status:** Authoritative
**Last updated:** 2026-04-09

**Source:** [AWS Well-Architected Generative AI Lens](https://docs.aws.amazon.com/wellarchitected/latest/generative-ai-lens/welcome.html) (November 2025). Best practices **GENCOST03**, **GENCOST05**.

**Authority:** This document sets **mandatory token and context economy rules** for model usage. **Workflow, verification, and agent discipline** remain in [`ai-workflow-policy.md`](ai-workflow-policy.md). **Approved tooling and registry posture** remain in [`approved-ai-tools.md`](approved-ai-tools.md). **Retrieval context budgets and injection rules** remain in [`ai-retrieval-policy.md`](ai-retrieval-policy.md). If anything here disagrees with `security-policy.md` on secrets, logging, or data handling, **`security-policy.md` wins**.

**Enforcement:** Binding for humans and agents. Concrete logging sinks and dashboards are **per repository** and must satisfy the fields listed below without logging prohibited content (secrets, unredacted PII).

---

## Mandatory rules

1. **Prompt token length must be minimised.** System prompts and context passed to any model must be audited for verbosity before deployment. Unnecessary words, redundant context, and over-specified instructions must be removed. Use a secondary LLM to compress prompts when the prompt exceeds 500 tokens and compression does not degrade output quality.

2. **Model response length must be bounded.** Every model call in automated or agentic workflows must set an explicit `max_tokens` parameter. Where the use case permits deterministic output (true/false, classification, structured keys), the prompt must instruct the model to return only the key, not a full explanation.

3. **Prompt caching must be evaluated** for any workflow where the same context block (system prompt, document, schema) is sent across multiple sequential calls. If the context block exceeds 1024 tokens and is reused more than once per session, caching must be enabled if the model supports it.

4. **Token usage must be logged** per session and per agent invocation. Logs must include: input tokens, output tokens, cached tokens (if applicable), model ID, and session or request ID.

---

## Quick links

| Topic | Where |
|------|--------|
| Agent workflow and verification | [`ai-workflow-policy.md`](ai-workflow-policy.md) |
| Retrieval token budget | [`ai-retrieval-policy.md`](ai-retrieval-policy.md) §3 |
| LLM hallucination posture | [`llm-usage-policy-hallucinations.md`](llm-usage-policy-hallucinations.md) |
