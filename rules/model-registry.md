---
doc_type: registry
authority: reference
owner: Alfonso Cruz
scope: Current non-Chinese model list with prices and capability scores
last_updated: 2026-07-31
update_trigger: new top-10 model appears / price change >20% / snapshot >30 days old
---

# Model Registry

Reference data for model selection. Governance rules live in
rules/approved-ai-tools.md. This file contains only current
prices, scores, and availability.

## Current price-capped tiers (active policy)

| Tier | Model | Intelligence | In $/MTok | Out $/MTok | TPS | Source |
|------|-------|-------------|-----------|------------|-----|--------|
| Subagent/reads | claude-haiku-4-5 | — | — | — | — | approved-ai-tools.md |
| Subagent/reads | gemini-2.5-flash-lite | — | $0.03 blended | — | 0.37s TTFT | artificialanalysis.ai |
| Daily (free) | Codex 5.3 | ~44 | $0 Cursor sub | $0 | — | Cursor subscription |
| Daily (free) | Grok 4.5 | ~44 | $0 Cursor sub | $0 | 80–112 | Cursor subscription |
| Hard | claude-sonnet-5 | ~43 | $2→$3* | $10→$15* | TBD | platform.claude.com |
| Very hard | claude-opus-4-8 | 56 | $5 | $25 | ~62 | platform.claude.com |
| Ultra-hard | UNASSIGNED (Fable 5 unavailable) | — | — | — | — | approved-ai-tools.md |

* Sonnet 5 steps up 2026-09-01. Budget at $3/$15, not $2/$10.
  Ultra-hard tier is currently unassigned in active policy.
  Fable 5 moved to usage-credits-only on 2026-07-20 and is unavailable
  under current price-cap enforcement. See approved-ai-tools.md.

Reference-only pricing snapshot (not active tiers) — GPT-5.6 update (2026-07-30):
- Sol: $5.00 input / $30.00 output per 1M tokens (unchanged)
- Sol Fast mode: 2x Sol price, 2.5x lower latency, same intelligence
- Terra: $2.00 input / $12.00 output (was $2.50 / $15.00, -20%;
  cut attributed to Sol inference optimizations)
- Luna: $0.20 input / $1.20 output (was $1.00 / $6.00, -80%;
  cut attributed to Sol inference optimizations)
- Luna note: input is now cheaper than Claude Haiku 4.5
  ($1.00 input / $5.00 output)
- Reported driver: Sol self-optimizing inference kernels (Triton/Gluon),
  speculative decoding, and KV-cache tuning
- Status: GPT-5.6 Sol pricing item CLOSED (was pending)
Source: [source-latentspace-ainews-2026-07-30]
        [source-openai-gpt-5-6-efficiency-2026]

Reference model status updates (not active tiers):
- Laguna S 2.1 (poolside): CANDIDATE (API-only). Local deployment is
  NOT VIABLE on RTX 4070: smallest quant (Q4_K_M) is 75.2 GB versus
  12 GB VRAM. MoE architecture keeps all 118B parameters resident even
  when only 8B parameters are active during inference.
- Claude Fable 5: UNAVAILABLE under current price-cap policy.
  Enforcement remains no payment method on file and usage credits
  disabled. One-time $100 credit offer expired.
- Claude Opus 5 (released 2026-07-24): pricing matches Opus 4.8;
  Fast mode available at 2x base cost. Leads the Artificial Analysis
  intelligence leaderboard (above Fable 5). Least prompt-injectable
  Anthropic model to date per internal evals and red-teaming. Not
  trained on cyber exploitation tasks; improved vulnerability finding
  is a side-effect of general capability gains but remains
  substantially behind Mythos 5 on exploitation. Described as
  "thoughtful and proactive" with a relentless-proactive behavior
  pattern (same class as Fable 5, per release post anecdote).

## TODO — dynamic selection protocol (future state, not active)

When ready to activate dynamic model selection:
- Run model-selection-protocol.md (to be created)
- Replace the static tier table above with a lookup procedure
- Update daily-navigation.md SESSION START accordingly

Do not activate until explicitly decided. Current policy is
price-capped tiers above. No deviation.

## PROHIBITED models (Chinese origin — API endpoint ban)

These models are prohibited because data sent to their APIs
is legally accessible to Chinese authorities under China's
National Intelligence Law (2017) and Data Security Law (2021).

| Model | Provider | Index | Reason |
|-------|----------|-------|--------|
| GLM-5.2 | Z AI / Zhipu AI | 51 | Chinese API endpoint. §14.6.9. EXCEPTION: local open-weight use permitted for incident response only under §14.6.9 incident response exception conditions. API endpoint (Z[.]ai / api[.]z[.]ai) remains prohibited unconditionally. |
| MiniMax-M3 | MiniMax | 44 | Chinese API endpoint. §14.6.9 |
| DeepSeek V4 Pro | DeepSeek | 44 | Chinese API endpoint. §14.6.9 |
| Kimi K3 | MoonshotAI | 57 | Chinese API endpoint. §14.6.9 |
| Any Z[.]ai / api[.]z[.]ai endpoint | Zhipu AI | — | Chinese API endpoint. §14.6.9 |

NOTE on Chinese-origin weights on non-Chinese infrastructure:
Cursor Composer 2.5 (built on Kimi K2.5 base) runs on US
infrastructure. Data does not route to China. Prohibition remains
active for standard engineering workflows. For incident response
only, see §14.6.9 local open-weight exception conditions.
See approved-ai-tools.md for current status.

## Snapshot update procedure

When update_trigger fires, run this in Cursor with web search enabled
and no private context loaded:

  Read rules/model-registry.md.
  Fetch https://artificialanalysis.ai/models — extract top 20 by
  Intelligence Index: name, provider, score, in/out price, TPS.
  Cross-check prices at https://openrouter.ai/models.
  Apply Chinese API endpoint filter (see PROHIBITED table above).
  Update the current price-capped tiers table with fresh data.
  Update last_updated date.
  Flag any price change >20% with [PRICE CHANGED].
  Add any new top-10 non-Chinese model not currently listed.
  One commit. pre-commit must pass.
