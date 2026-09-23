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
- SPEND FREEZE (active, 2026-08-14): do not configure or
  escalate to billed Codex backends. Stay on freeze-allowed
  Cursor Grok 4.7 (or Grok 4.6 fallback) / Codex GPT-6 family
  included allowance until the freeze is lifted in
  approved-ai-tools.md. Agents cannot lift it. Cursor
  On-Demand Usage MUST remain Disabled. Auto OFF is routing
  control, not the billing cap.
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

Grok 4.7 (SpaceXAI/Cursor Models pool): included usage path
  — Preferred default for Cursor hard/demanding work.

Grok 4.6 (SpaceXAI/Cursor Models pool): included usage path
  — Compatibility fallback.

Muse Spark 1.2 (Meta): $1.25/$4.25
  — Standard tier. Open weights pending. In registry
    as CANDIDATE.

### Tier 3 — Premium (near price cap)

Claude Opus 5.5 (Anthropic): frontier Claude option.
  Use through human-explicit Claude Pro allowance in Claude Code.

GPT-6 Sol / GPT-6 Astra (OpenAI via Codex included allowance):
  — General/hardest Codex options in current active harness.

### Excluded — data sharing

Muse Spark 1.2 Contributor (Meta): $0.10/$0.20
  — Meta uses your data. NOT approved for portfolio code.

### Pending — do not use until resolved

Nemotron 3.5 Lightning: OpenMDW-1.1 license review
  required before any portfolio-public use.
Muse Glimmer: API pricing unconfirmed.
MAI-Thinking-1: Foundry only, not publicly available.

## Default

GPT-5.3 Codex Medium in Cursor is the stable day-to-day default.

Grok 4.7 is a deliberate Cursor escalation for demanding,
long-running, multi-file, CUDA/kernel, or stubborn debugging work.
Grok 4.6 remains the Cursor compatibility fallback.

Codex CLI is a separate included-allowance harness using
ChatGPT authentication and the GPT-6 Luna/Sol/Astra family.

Same principle as `cursor-model-selection.md`: keep one stable default,
escalate deliberately, and do not choose from scratch for every prompt.

## Escalation rules

SPEND FREEZE remains active. Do not configure billed backends,
PAYG, extra usage, API fallback, or Cursor On-Demand Usage.

Routine/mechanical Cursor work:
  → GPT-5.3 Codex Medium

Routine/mechanical Codex CLI work:
  → GPT-6 Luna

CUDA kernels, demanding long multi-file agent tasks:
  → Grok 4.7; Grok 4.6 compatibility fallback

Ambiguous architecture or stubborn debugging:
  → Grok 4.7 High or GPT-6 Sol

Hardest work / capability ceiling:
  → GPT-6 Astra or Claude Opus 5.5 via human-explicit Claude Code
    within existing Claude Pro included allowance

## Long-context pricing cliff

Current Cursor Grok 4.6 pricing distinguishes Standard and
Fast usage. Fast is more expensive. Do not assert that
Grok 4.6 doubles its rate once a request exceeds 200K
tokens: current official Cursor documentation (checked
2026-08-19) does not document that as Cursor Grok 4.6
pricing.

Any external/API long-context pricing rule must be
re-verified from current provider documentation before
paid API use. SPEND FREEZE: no billed backend may be
configured or used while the freeze is active.

Gemini 3.1 Pro in this file is already listed with 200K+
pricing that doubles (source: Google Gemini pricing,
verified 2026-08-14). If that model is used after freeze
lift, keep Codex sessions pruned below 200K tokens on it.
GPT-5.6 Luna and Mistral models do not have the same
cliff structure.

## Chinese model ban — for reference

Excluded regardless of price: DeepSeek V4 Pro
($0.435/$0.87), DeepSeek V4 Flash ($0.14/$0.27),
Qwen3.8-Max, Kimi K3, MiniMax H3. The pricing advantage
is real. The ban is unconditional.

## Registry gaps — action required

Review this file against `rules/model-registry.md` on each
registry refresh. Do not treat this file as billing
authorization.

## Sources

Verified 2026-09-23:
- xAI Grok: https://x.ai/api
- OpenAI: https://platform.openai.com/docs/pricing
- Google Gemini: https://ai.google.dev/pricing
- Mistral: https://mistral.ai/pricing
- Anthropic: https://www.anthropic.com/pricing
- OpenAI changelog: https://developers.openai.com/api/docs/changelog
- OpenAI help (Codex/ChatGPT allowance context): https://help.openai.com/en/articles/20001275/
- Anthropic Claude Code model configuration: https://support.claude.com/en/articles/11940350-claude-code-model-configuration
[codex-model-selection-2026-08-14]
