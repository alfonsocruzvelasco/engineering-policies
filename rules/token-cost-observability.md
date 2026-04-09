---
doc_type: guidance
authority: guidance
owner: Alfonso Cruz
scope: Approved tooling options for token usage tracking and cost observability; teams select by context
---

# Token Cost Observability

**Status:** Implementation guidance
**Last updated:** 2026-04-09

**Authority:** This document is **implementation guidance**, not a hard policy mandate. Teams select tooling from **Section 2** based on context and record the choice in the project architecture record. **Mandatory token logging** for model usage is stated in [`token-cost-controls.md`](token-cost-controls.md). This guidance **extends** that posture with **USD cost** and a **curated tooling list**. If anything here disagrees with `security-policy.md` on secrets, data handling, or vendor use, **`security-policy.md` wins**.

---

## 1. Requirement

Every production AI workflow must instrument token usage. The following must be captured per generation:

- input tokens
- output tokens
- cached tokens (where applicable)
- model ID
- session or request ID
- USD cost (inferred or ingested)

This data must be queryable for cost attribution, budget alerting, and audit.

---

## 2. Approved tooling options

### Option A — Langfuse

| Attribute | Detail |
|-----------|--------|
| **What it is** | Open-source LLM observability platform (MIT licence, acquired by ClickHouse 2025). |
| **Primary strength** | Captures nested traces, session grouping, token usage per generation, cached token tracking, and cost inference from built-in tokenizers for OpenAI, Anthropic, and Google models. Integrates natively with LiteLLM — if LiteLLM is the gateway, Langfuse reads cost automatically from each response. Supports pricing tiers (e.g. Anthropic's 200K token threshold). Exposes a Metrics API for downstream billing and rate-limiting. |
| **When to use** | You want open-source, self-hosted control, or your stack includes LiteLLM. |
| **Self-hosting** | Self-hostable via Docker (free); cloud starts at $29/month. |

### Option B — LiteLLM (gateway-level tracking)

| Attribute | Detail |
|-----------|--------|
| **What it is** | Open-source proxy that aggregates multiple model providers under a unified API. |
| **Primary strength** | Built-in spend tracking per key, user, or team with daily summaries. Enforces hard budget limits that stop workflows when a spending threshold is hit — **the only option in this list that enforces rather than observes**. Works as a drop-in replacement for direct API calls. |
| **When to use** | You need hard budget enforcement, not just reporting, or you are routing across multiple model providers. |
| **Self-hosting** | Self-hostable; proxy is free, enterprise features are paid. |

### Option C — Helicone

| Attribute | Detail |
|-----------|--------|
| **What it is** | Proxy-based monitoring: route API calls through Helicone by changing the base URL — no SDK required. |
| **Primary strength** | Logs requests, responses, tokens, and costs without code changes. Does not require SDK integration or application changes. |
| **When to use** | You need immediate visibility with minimal setup and no instrumentation overhead. |
| **Self-hosting** | SaaS: free tier 10K requests/month; Pro $79/month. |

### Option D — Datadog LLM Observability

| Attribute | Detail |
|-----------|--------|
| **What it is** | Extension of Datadog's existing APM platform. |
| **Primary strength** | Correlates LLM token costs with infrastructure metrics (CPU, memory, latency) in a unified dashboard. |
| **When to use** | The team is already on Datadog and needs consolidated observability rather than a separate tool. |
| **Self-hosting** | Follows Datadog deployment model for your organisation (SaaS by default; hybrid options per Datadog offering). |

---

## 3. What is out of scope for this policy

This policy does not mandate a specific tool. It mandates what data must be captured (**Section 1**). Tool selection is an implementation decision documented in the project's architecture record.

This policy does not cover evaluation or quality scoring (hallucination detection, output quality metrics). That is a separate concern.

---

## 4. Enforcement gap note

None of the observability tools above (Langfuse, Helicone, Datadog) enforce spending limits — they track and report. Only LiteLLM enforces hard budget caps at the gateway level. If a workflow requires a hard spending limit, LiteLLM must be in the stack regardless of which observability tool is chosen.

---

## Quick links

| Topic | Where |
|------|--------|
| Mandatory token logging (policy) | [`token-cost-controls.md`](token-cost-controls.md) |
| Model selection cost discipline | [`model-cost-discipline.md`](model-cost-discipline.md) |
| Agent stopping conditions | [`agent-stopping-conditions.md`](agent-stopping-conditions.md) |
