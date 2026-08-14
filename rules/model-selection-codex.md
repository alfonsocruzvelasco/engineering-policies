---
name: model-selection-codex
description: Viable non-Chinese Codex backend models with
  constraints applied — pricing, bans, license status,
  escalation rules, and registry gaps. Read before
  configuring any Codex backend session.
sources: [chat]
---

# Codex model selection: full possibility space

## Constraints applied

- Chinese model ban: Alibaba (Qwen), DeepSeek, Moonshot
  (Kimi), MiniMax, ByteDance — excluded regardless of
  pricing.
- Price cap: no usage credits enabled, no new payment
  methods. Effective ceiling ~$5/M input.
- License review: non-Apache 2.0 models require review
  before portfolio-public or production use.
- Data policy: free tiers that train on your data are
  excluded for portfolio code. Paid tiers only.

## All viable options by cost tier

### Tier 1 — Ultra-cheap (under $0.50/M input)

Gemini 2.5 Flash-Lite (Google): $0.10/$0.40
  — Lowest cost. Routing and classification only.
    Not for complex agent tasks.

Devstral Small 2 (Mistral): $0.10/$0.30
  — Agentic coding, small variant. Apache 2.0 weights.

Mistral Small 4 (Mistral): $0.15/$0.60
  — General-purpose, multimodal, function calling.
    Apache 2.0.

GPT-5.6 Luna (OpenAI): $0.20/$1.20
  — Cheapest capable OpenAI model. Confirmed. Needs
    registry entry.

Gemini 3.5 Flash-Lite (Google): $0.30/$2.50
  — Workhorse tier. Better reasoning than 2.5 Flash-Lite.

Mistral Codestral (Mistral): $0.30/$0.90
  — Code-specialized. FIM support, 256K context.
    Purpose-built for IDE and Codex workflows.
    8-12x cheaper than Claude Sonnet 5 on coding tasks.

Devstral 2 (Mistral): $0.40/$2.00
  — Agentic coding. Multi-step autonomous engineering.

### Tier 2 — Mid-range ($0.50–$2.00/M input)

Mistral Large 3 (Mistral): $0.50/$1.50
  — Frontier Mistral quality. 75% cheaper than Large 2.
    Strong on coding. Needs registry entry.

Gemini 3.6 Flash (Google): $1.50/$7.50
  — Latest Flash. Beats 3.1 Pro on coding at lower cost.
    Needs registry entry.

Gemini 3.1 Pro (Google): $2.00/$12.00
  — Flagship Google. 1M context. 200K+ pricing doubles.
    Needs registry entry.

GPT-5.6 Terra (OpenAI): $2.00/$12.00
  — Mid-tier OpenAI. 20% cut from prior pricing.
    In handover, not yet in registry.

Claude Sonnet 5 (Anthropic): $2.00/$10.00
  — Permanent pricing. Strong coding. In registry.

Grok 4.6 (SpaceXAI): $2.00/$6.00
  — Default for Codex. 88.4% Terminal-Bench v2.1.
    Kernel optimization training. In registry.
    Long-context cliff at 200K (rate doubles on all
    tokens in the request once threshold is crossed).

Muse Spark 1.2 (Meta): $1.25/$4.25
  — Standard tier. Open weights pending. In registry
    as CANDIDATE.

### Tier 3 — Premium (near price cap)

Claude Opus 5 (Anthropic): same as Opus 4.8
  — Reserve for hard architecture decisions only.

GPT-5.6 Sol (OpenAI): $5.00/$30.00
  — At price cap ceiling. Not for routine use.
    In handover, not yet in registry.

### Excluded — data sharing

Muse Spark 1.2 Contributor (Meta): $0.10/$0.20
  — Meta uses your data. NOT approved for portfolio code.

### Pending — do not use until resolved

Nemotron 3.5 Lightning: OpenMDW-1.1 license review
  required before any portfolio-public use.
Muse Glimmer: API pricing unconfirmed.
MAI-Thinking-1: Foundry only, not publicly available.

## Default

Grok 4.6 — standard effort.
Same principle as cursor-model-selection: stable default,
do not choose per prompt, escalate deliberately.

## Escalation rules

Mechanical completions, reformatting, boilerplate:
  → GPT-5.6 Luna ($0.20/$1.20) or Mistral Codestral
    ($0.30/$0.90)

CUDA kernels, long multi-file agent tasks:
  → Grok 4.6 (default)

Agentic code review with structured critique:
  → Mistral Codestral or Devstral 2

Ambiguous architecture, multi-step reasoning:
  → Grok 4.6 High or Claude Sonnet 5

Hard architecture with no clear path:
  → Claude Opus 5 (at price cap — justify the spend)

## Long-context pricing cliff

Grok 4.6 and Gemini Pro models double their rate once a
single request exceeds 200K tokens. The higher rate
applies to ALL tokens in that request, not just the
overflow. Keep Codex sessions pruned below 200K tokens
on these models. GPT-5.6 Luna and Mistral models do not
have the same cliff structure.

## Chinese model ban — for reference

Excluded regardless of price: DeepSeek V4 Pro
($0.435/$0.87), DeepSeek V4 Flash ($0.14/$0.27),
Qwen3.8-Max, Kimi K3, MiniMax H3. The pricing advantage
is real. The ban is unconditional.

## Registry gaps — action required

The following models are confirmed viable, non-Chinese,
within price cap, and missing from model-registry.md.
Add them at next registry update:

1. GPT-5.6 Luna ($0.20/$1.20) — in handover, not written
2. GPT-5.6 Terra ($2/$12) — in handover, not written
3. GPT-5.6 Sol ($5/$30) — in handover, not written
4. Gemini 3.6 Flash ($1.50/$7.50) — not in registry
5. Gemini 3.1 Pro ($2/$12) — not in registry
6. Gemini 2.5 Flash-Lite ($0.10/$0.40) — not in registry
7. Mistral Codestral ($0.30/$0.90) — not in registry
8. Mistral Large 3 ($0.50/$1.50) — not in registry
9. Devstral 2 ($0.40/$2.00) — not in registry
10. Devstral Small 2 ($0.10/$0.30) — not in registry

## Sources

Verified 2026-08-14:
- xAI Grok: https://x.ai/api
- OpenAI: https://platform.openai.com/docs/pricing
- Google Gemini: https://ai.google.dev/pricing
- Mistral: https://mistral.ai/pricing
- Anthropic: https://www.anthropic.com/pricing
- GPT-5.6 pricing: engineering-policies handover 2026-08-14
[codex-model-selection-2026-08-14]
