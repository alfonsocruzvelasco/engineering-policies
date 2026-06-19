---
doc_type: reference
authority: supporting
owner: Alfonso Cruz
scope: Model routing tiers, long-context configuration, and benchmark/cost tracking
---

# MSI Models and Configuration

## Tracked models

### GLM-5.2

- Provider: ZAI / Tsinghua (z.ai), Beijing. MIT license, open weights on HuggingFace.
- Architecture: 753B total / ~40B active (MoE). IndexShare reduces per-token FLOPs 2.9x at 1M context.
- Benchmarks: Terminal-Bench 2.1: 81.0 (Opus 4.8: 85.0), SWE-bench Pro: 62.1, FrontierSWE: 74.4 (Opus 4.8: 75.1), PostTrainBench: 34.3.
- Pricing: $1.40/$4.40 per 1M tokens direct API. $1.20/$3.20 via OpenRouter.
- STATUS: EXCLUDED FROM ROUTING. Reason: Chinese-hosted API endpoint (api.z.ai). Portfolio code targeting safety-critical AV systems must not transit this endpoint. Self-hosting only acceptable path.
