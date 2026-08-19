---
doc_type: registry
authority: reference
owner: Alfonso Cruz
scope: Current non-Chinese model list with prices and capability scores
last_updated: 2026-08-19
update_trigger: new top-10 model appears / price change >20% / snapshot >30 days old
---

# Model Registry

Reference data for model selection. Governance rules live in
rules/approved-ai-tools.md. This file contains only current
prices, scores, and availability.

## Current price-capped tiers (active policy)

spend-freeze: active (2026-08-14). Paid/API rows below are
frozen for new agent-initiated sessions. See
approved-ai-tools.md SPEND FREEZE (authority). Agents cannot
lift this freeze. Cursor On-Demand Usage MUST remain
Disabled. Included-usage rows consume prepaid/included
Cursor plan usage; they are freeze-allowed only while that
control stays Disabled. List rates in model notes are vendor
accounting references, not authorization to incur additional
billed spend. A pricing, routing, quota, model-pool, or Auto
change is not a freeze lift.

| Tier | Model | Intelligence | In $/MTok | Out $/MTok | TPS | Source |
|------|-------|-------------|-----------|------------|-----|--------|
| Subagent/reads | claude-haiku-4-5 | — | — | — | — | approved-ai-tools.md (frozen) |
| Subagent/reads | gemini-2.5-flash-lite | — | $0.03 blended | — | 0.37s TTFT | artificialanalysis.ai (frozen) |
| Daily (included-usage, freeze-allowed) | Codex 5.3 | ~44 | — | — | — | Cursor plan usage; pool membership and $0 price not asserted |
| Daily (included-usage, freeze-allowed) | Grok 4.6 | ~44 | — | — | 80–112 | Cursor Models pool; included usage; rates in notes |
| Historical (superseded) | Grok 4.5 | ~44 | — | — | 80–112 | historical Cursor Models pool; included usage |
| Hard (frozen) | claude-sonnet-5 | ~43 | $2 | $10 | TBD | platform.claude.com |
| Very hard (frozen) | claude-opus-4-8 | 56 | $5 | $25 | ~62 | platform.claude.com |
| Ultra-hard | UNASSIGNED (Fable 5 unavailable) | — | — | — | — | approved-ai-tools.md |

Grok 4.5:
Status: SUPERSEDED by Grok 4.6 (2026-08-12).
Retained for historical reference only. Do not
route new tasks to Grok 4.5.

- Grok 4.6 (xAI / SpaceXAI)
  Released: 2026-08-12
  Status: APPROVED — within price-cap
  API model string: grok-4.6
  Supersedes: Grok 4.5 (grok-4.5) — same 1.5T V9 foundation,
  improved SFT and RL. Not a parameter-count upgrade.
  Pricing (confirmed 2026-08-12):
    Standard (below 200K prompt tokens):
      Input:  $2.00/M
      Output: $6.00/M
      Cached: $0.50/M
    Long-context band (200K+ tokens):
      Input:  $4.00/M (doubles)
      Output: $12.00/M (doubles)
      NOTE: xAI applies the higher rate to ALL tokens in the
      request once the 200K threshold is crossed — not just
      the overflow. A 201K-token prompt costs $4/M on all
      201K tokens, not just the last 1K. Budget accordingly
      for long-context agent runs.
    Fast variant: 2x standard price, lower latency.
  Benchmarks (confirmed, Artificial Analysis, 2026-08-12):
    Intelligence Index: 61 — matches GPT-5.6 Sol Max
    Terminal-Bench v2.1: 88.4% — strong; comparable to
      frontier peers, not lagging
    GDPval-AA v2 Elo: 1753 (confirmed)
    AA-Briefcase: competitive agentic knowledge-work
      performance at materially lower cost than frontier
      peers (AA evaluation, 2026-08-12)
    Strength: knowledge work, coding, long-running agents
    ELO (xAI claim): 1753 — LMSYS/AA community verification
      pending
  [latent-space-ainews-grok46-2026-08-13]
  Access: xAI API, Cursor (all plans), OpenRouter, Vercel,
    Cloudflare, Grok Build. 2x Cursor usage during
    launch week promo (ends ~2026-08-19).
  Cursor billing: currently draws from Cursor's included
    Cursor Models pool. Freeze-allowed while On-Demand
    Usage remains Disabled. Not permanently free. The
    xAI list rates above are external model/API reference
    data. They do not define Cursor account authorization
    and do not authorize additional billed spend under the
    active SPEND FREEZE.
  Cursor context: 256K tokens (official Cursor documentation,
    checked 2026-08-19).
  Chinese model ban: not applicable — xAI/SpaceXAI is a US
    company (Elon Musk / SpaceX entity)
  Local deployment: NOT available — API only
  Fast variant: available, use only when latency justifies
    2x price per inference control plane rule (rule 14)
  Inference control plane note: the 200K long-context
    pricing cliff is the primary cost risk for this model.
    Agent runs with large context accumulation (multi-turn,
    long SKILL.md files, large codebases) should be
    monitored for prompt size. Prefer context pruning and
    prompt caching over crossing the 200K threshold on
    routine runs.
  Upcoming: Grok 4.7 (2.1T parameters) expected within
    weeks of 4.6 release. Reassess at that point.
  Reassessment trigger: Grok 4.7 release; October 2026
    Cursor/SpaceXAI checkpoint.
  [grok-4-6-release-2026-08-12]
- Grok @Bot (xAI / SpaceXAI)
  Released: 2026-08-11 (early beta)
  Status: CANDIDATE — price-cap assessment pending;
    no credentials delegated until delegated identity policy
    (above) is satisfied
  Powered by: Grok 4.6
  Category: AI teammate / agent platform — signs in to
    external tools using delegated credentials, executes
    tasks, returns finished work. Not a coding agent;
    a knowledge-work and tool-use agent.
  AI-BOM requirement: any active Grok @Bot session must
    appear in the AI-BOM with credential scope and tool
    access listed. A session without an AI-BOM entry is
    a policy violation.
  Delegated identity policy applies: mandatory scoped
    credentials, independent revocation, audit trail
    isolation before activation. See agent-egress policy.
  Reassessment trigger: October 2026 checkpoint. Monitor
    pricing and beta-to-GA transition.
  [latent-space-ainews-grok46-2026-08-13]

* Pricing: PERMANENT at $2/M input, $10/M output.
  Confirmed 2026-08-10. Introductory period cancelled —
  price does not increase on 2026-09-01.
* OBSOLETE: 2026-08-31 (Sonnet 5 intro pricing ends).
  Superseded 2026-08-10 — Sonnet 5 pricing made
  permanent. No price change will occur.
* OBSOLETE: 2026-09-01 (Sonnet 5 -> $3/$15).
  Superseded 2026-08-10 — Sonnet 5 pricing made
  permanent. No price change will occur.
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
- Meta Muse Spark 1.2 / Muse Code (released 2026-08-05):
  CANDIDATE — UNAVAILABLE under current price-cap policy.
  Enforcement: no payment method added in the Meta AI developer
  portal and no usage credits enabled. Same posture as Fable 5.
  Do not activate until pricing is public, confirmed, and assessed
  against the price cap.
  Architecture notes: terminal coding agent (Muse Code) co-trained
  with its harness (same pattern as Claude Code / Sonnet 4.6);
  persistent async background agents (session-long, not per-task);
  append-only local event log (every model call, tool run, approval,
  and edit recorded, replay-exact and restart-safe after crash);
  long-horizon case study published at 1,000+ tool calls over 24
  hours (kernel optimization workflow).
  Positioning: direct competitor to Claude Code. Meta compares
  against Opus 5, GPT-5.6 Terra, Gemini 3.6 Flash, and Grok 4.5.
  Coding-focused update to Muse Spark 1.1 (July 2026).
  Chinese model ban: not applicable (Meta is a US company).
  Open source: PENDING — Zuckerberg announced 2026-08-10
  that Muse Spark 1.2 weights will be released publicly
  in the coming weeks under an open license. Update this
  entry when weights drop. On release: reassess local
  deployment viability (30B Glimmer variant fits 24 GB
  VRAM at 4-bit; full Spark 1.2 architecture is larger —
  verify VRAM requirement before changing local
  deployment status).
  Local deployment: NOT VIABLE (API only).
  Reassessment trigger: October 2026 checkpoint (same as
  Cursor/SpaceXAI). Conditions: (1) pricing confirmed and within
  price cap, and (2) open-source status resolved (weights
  released = higher priority).
  - Muse Spark 1.2 open weights release (expected
    2026-08-xx): reassess local deployment viability
    and open-source status immediately on release,
    do not wait for the October checkpoint.
- Meta Muse Glimmer (released 2026-08-10):
  CANDIDATE — UNAVAILABLE (price-cap policy pending
  pricing confirmation; no payment method added).
  License: Apache 2.0 (open weights, commercial use permitted).
  Architecture:
  - 30B parameters, distilled from Muse Spark via logit
    distillation + on-policy SFT + RL across general,
    reasoning, coding, and agentic domains.
  - Local/Local/Local/Global attention pattern, 2,048-token
    sliding window.
  - ~1.8B ViT-G/14 vision encoder, up to 4,096 visual tokens.
  - Context: 131,072+ tokens.
  - Knowledge cutoff: 2026-01-04.
  - Input: text + image. Output: text. No audio, no video
    (frames only).
  - DFlash block-level speculative decoding: 3.1x faster
    inference.
  Local deployment — NOT VIABLE on Alfonso's hardware:
  - 4-bit quantization: ~18 GB VRAM confirmed (not "under
    20 GB" as initially estimated).
  - Reliable agentic performance requires 24 GB VRAM
    (RTX 3090/4090 class minimum).
  - Alfonso's laptop GPU is well below this threshold.
  - Verdict: NOT VIABLE locally. API-only candidate.
    Same class as Laguna S 2.1.
  - Deployment ecosystem (for future hardware or remote
    inference): llama.cpp, Ollama, LM Studio, MLX,
    vLLM, SGLang, ExecuTorch, torchtitan — weights on
    HuggingFace (meta-models org).
  Benchmark position (Artificial Analysis, 2026-08-10):
  - Intelligence Index: 35.
  - Comparable peers: Qwen3.6-27B (38), Kimi K2.5 (36).
  - Strength: tool use — Tau3-Banking benchmark.
  - Weakness: hallucination and knowledge calibration
    notably below peers at this size.
  [latent-space-ainews-glimmer-2026-08-11]
  Chinese model ban: not applicable — Meta is a US company.
  Reassessment trigger: when API pricing is confirmed and
  within price cap. Same October 2026 checkpoint as
  Muse Spark 1.2 and Cursor/SpaceXAI.
- NVIDIA Nemotron 3.5 Lightning (released 2026-08-11):
  CANDIDATE — license review required before approval.
  License: OpenMDW-1.1 (NOT Apache 2.0 — verify terms before
  use in any commercial or portfolio-public context).
  Architecture:
  - 30B total parameters, 3.6B active (MoE).
  - 1M token context.
  - NVFP4 and BF16 weights available on Hugging Face.
  - Median serving throughput: ~670 tok/s (pre-release
    endpoint testing, Artificial Analysis).
  - Intelligence Index: 24 (Artificial Analysis)
    — comparable to gpt-oss-120b at a fraction of the size.
  Agentic profile — notable for size class:
  - GDPval-AA v2 Elo: 824.
  - Terminal-Bench v2.1: 24%.
  - Both are major jumps over Nemotron 3 Nano.
  - Harvey fine-tuned on Legal Agent Bench: 0% -> 8.3% on
    held-out tasks, beating Opus 4.6 and Nemotron 3 Ultra
    in that setup while cutting avg output from 90K -> 37K
    tokens. Validates agentic tool-use profile at this size.
  Ecosystem support: Together AI, Ollama, Baseten, vLLM,
  Perplexity API — broad day-one availability.
  Deployment pattern: positioned as a high-volume execution
  model paired with a stronger planning model via routing —
  aligns with inference control plane (rule 14) principle
  of routing deterministic/agentic runs to the most
  cost-efficient capable model.
  Chinese model ban: not applicable — NVIDIA is a US company.
  Local deployment update (2026-08-13):
    2-bit quantization (Unsloth): ~22 GB VRAM, confirmed
      to sustain long tool-use sessions
    Alfonso's laptop GPU: still below 22 GB threshold —
      NOT VIABLE locally on current hardware
    Gap is narrowing: reassess on next hardware upgrade or
      when running on a 24 GB VRAM machine (RTX 3090/4090
      class). At 2-bit quality is significantly degraded —
      evaluate task fit before deploying at this quantization.
  [latent-space-ainews-grok46-2026-08-13]
  Reassessment trigger: October 2026 checkpoint. Conditional
  on OpenMDW-1.1 license review — do not deploy in any
  portfolio-public or production context until license terms
  are verified. If OpenMDW-1.1 is found to be restrictive,
  downgrade status to UNAVAILABLE.
  [latent-space-ainews-reasoning-trace-2026-08-12]
- Microsoft MAI-Thinking-1
  Released: 2026-08-12
  Status: CANDIDATE — access restricted (Microsoft Foundry
    only, no public API pricing confirmed)
  Architecture: reasoning model, built from scratch at
    Microsoft (not a fine-tune of an existing frontier model)
  Access: Microsoft Azure Foundry; not publicly available
  Chinese model ban: not applicable — Microsoft is a US
    company
  Positioning: applied reasoning model with explicit focus
    on tool use — Microsoft team is soliciting tool-use
    feedback at launch, signaling this is the target use
    case rather than benchmark competition
  Reassessment trigger: when public API pricing is confirmed.
  [latent-space-ainews-grok46-2026-08-13]

## TODO — dynamic selection protocol (future state, not active)

When ready to activate dynamic model selection:
- Run model-selection-protocol.md (to be created)
- Replace the static tier table above with a lookup procedure
- Update daily-navigation.md SESSION START accordingly

Do not activate until explicitly decided. Current policy is
price-capped tiers above plus SPEND FREEZE. No deviation.

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
