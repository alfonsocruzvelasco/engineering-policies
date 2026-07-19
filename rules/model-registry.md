---
doc_type: registry
authority: reference
owner: Alfonso Cruz
scope: Current non-Chinese model list with prices and capability scores
last_updated: 2026-07-19
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
| Ultra-hard | claude-fable-5 | 60 | $10 | $50 | 60–69 | platform.claude.com |

* Sonnet 5 steps up 2026-09-01. Budget at $3/$15, not $2/$10.
  Ultra-hard (Fable 5) requires documented justification before use.

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
| GLM-5.2 | Z AI / Zhipu AI | 51 | Chinese API endpoint. §14.6.9 |
| MiniMax-M3 | MiniMax | 44 | Chinese API endpoint. §14.6.9 |
| DeepSeek V4 Pro | DeepSeek | 44 | Chinese API endpoint. §14.6.9 |
| Kimi K3 | MoonshotAI | 57 | Chinese API endpoint. §14.6.9 |
| Any Z[.]ai / api[.]z[.]ai endpoint | Zhipu AI | — | Chinese API endpoint. §14.6.9 |

NOTE on Chinese-origin weights on non-Chinese infrastructure:
Cursor Composer 2.5 (built on Kimi K2.5 base) runs on US
infrastructure. Data does not route to China. Prohibition is
principle-based, not threat-model-based. Documented as such.
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
