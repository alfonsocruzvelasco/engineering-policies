# Deferred: ML Model Benchmark Suite

**Status:** Ready to implement — deferred until first real CV workload
**Created:** 2026-04-05
**Review trigger:** When you have a real inference task to benchmark against

---

## What was designed

A self-contained benchmark suite for all approved AI models:

- **Local:** Gemma 4 E4B via Ollama, any other pulled Ollama models
- **API:** Claude (claude-sonnet-4-20250514), OpenAI (gpt-4o-mini), Z.ai GLM-5
- **Cloud GPU:** RunPod RTX 4090 — only if local p95 latency > 2000ms

**Hard budget cap:** $20/month combined cloud spend (RunPod + APIs).
Exit code 2 on cap hit. Warning at $18. Confirmation prompt before any
RunPod spend. No surprises.

---

## Hardware baseline (verify when you run this)

| Component | Current | Verify before running |
|---|---|---|
| GPU | RTX 4070, 12GB VRAM | `nvidia-smi` |
| CUDA | 12.9 | `nvcc --version` |
| Python | 3.11 | `python3 --version` |
| PyTorch | NOT installed | `pip install torch torchvision --index-url https://download.pytorch.org/whl/cu129` |
| Ollama | 0.14.2 | `ollama --version` |
| Gemma 4 E4B | NOT pulled | `ollama pull gemma4:e4b` |

---

## Pricing to re-verify before running

These change. Do not trust cached numbers — fetch live prices:

| Provider | Model | Price at design time | Verify at |
|---|---|---|---|
| RunPod | RTX 4090 | $0.34/hr community | https://www.runpod.io/gpu-pricing |
| Anthropic | claude-sonnet-4-20250514 | $3/$15 per 1M in/out | https://www.anthropic.com/pricing |
| OpenAI | gpt-4o-mini | $0.15/$0.60 per 1M in/out | https://openai.com/pricing |
| Z.ai | GLM-5 | estimated same as gpt-4o-mini | https://z.ai/docs |
| Cloudflare | gemma-4-26b-a4b-it | per-token | https://developers.cloudflare.com/workers-ai/ |

**Update `budget/spend_tracker.py` cost formulas before first run if prices changed.**

---

## Models to verify are still approved

Check `rules/approved-ai-tools.md` before implementing — the registry
may have changed:

- [ ] Gemma 4 E4B (self-hosted/Ollama) — added 2026-04-05
- [ ] Claude API (Anthropic) — approved 2026-02-01
- [ ] OpenAI API — approved 2026-02-01
- [ ] Z.ai GLM-5 — approved 2026-02-12 (short recertification: 2026-05-12)
- [ ] RunPod — not yet in approved-ai-tools.md (add before first cloud run)

**RunPod needs a policy entry before you spend any money there.**
Add it to `approved-ai-tools.md` under a new "Cloud GPU Rental" category
with the same data-handling constraints as self-hosted: no production data,
no credentials, sanitize inputs.

---

## Cursor prompt location

The full Cursor implementation prompt is in this conversation:
session 2026-04-05, message "Cursor prompt" (long message with ## Spec header).

Retrieve it from Claude project history before implementing.

---

## Pre-flight checklist (do these in order)

```bash
# 1. Verify GPU visible to Ollama
ollama ps

# 2. Pull Gemma 4 E4B
ollama pull gemma4:e4b

# 3. Check/create Python venv for sandbox repo
cd ~/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code
python3 -m venv .venv && source .venv/bin/activate

# 4. Install PyTorch
pip install torch torchvision \
  --index-url https://download.pytorch.org/whl/cu129

# 5. Create .env (never commit this)
touch .env
# Add: ANTHROPIC_API_KEY, OPENAI_API_KEY, ZAI_API_KEY, RUNPOD_API_KEY

# 6. Verify CUDA visible to PyTorch
python3 -c "import torch; print(torch.cuda.get_device_name(0))"
# Expected: NVIDIA GeForce RTX 4070

# 7. Open Cursor and paste the implementation prompt
cursor .
```

---

## Escalation decision rule (baked into the benchmark)

```
Local p95 latency < 2000ms  → LOCAL_OK, no cloud needed
Local p95 latency 2–5000ms  → LOCAL_MARGINAL, your call
Local p95 latency > 5000ms  → Prompt for RunPod escalation
                               (requires confirmation + budget check)
```

---

## What "ready" looks like

Run this when you have:
1. A real CV task (not a toy prompt) to use as the benchmark input
2. A latency requirement to validate against
3. PyTorch installed and verified on the RTX 4070
4. RunPod added to approved-ai-tools.md

Do not run it just to run it. The benchmark is only useful when
you have a real workload to calibrate against.

---

Three things to do before running this in Cursor:

**1.** Create a `.env` file in the sandbox root with your actual keys:
```
ANTHROPIC_API_KEY=...
OPENAI_API_KEY=...
ZAI_API_KEY=...
RUNPOD_API_KEY=...
```

**2.** Verify Ollama is installed: `ollama --version`

**3.** The RunPod client will need your RunPod template ID for Gemma 4 26B A4B — you'll set that up separately when/if you actually escalate. The benchmark will prompt you before spending anything there.

The budget guard is built and tested before any cloud code exists. That's the only order that guarantees the cap is real.

---

## Cursor prompt

Open Cursor in your sandbox repo (`sandbox-claude-code`), not the policies repo. Plan Mode first. Paste this:

```
## Context

Machine: Fedora Linux 41, AMD Ryzen 9 7900X, 64GB RAM,
NVIDIA RTX 4070 (12GB VRAM), CUDA 12.9, Python 3.11.
PyTorch not installed — install it as part of setup.
Working directory: ~/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/

## Objective

Build a self-contained ML benchmark suite that:
1. Measures latency and throughput for all approved AI models
2. Runs local models first; flags cloud escalation only if local is impractical
3. Enforces a HARD $20/month combined cloud spend cap (RunPod + APIs)
   — this cap is NON-NEGOTIABLE, no exceptions, no overrides

---

## Spec

### Models to benchmark

**Local inference (no cloud cost):**
- Gemma 4 E4B via Ollama (`ollama pull gemma4:e4b`)
- Any other Ollama models already pulled (enumerate at runtime)

**API models (token-billed — count against $20 cap):**
- Anthropic Claude (model: claude-sonnet-4-20250514)
  Auth: ANTHROPIC_API_KEY env var
- OpenAI (model: gpt-4o-mini for benchmarking — cheapest capable model)
  Auth: OPENAI_API_KEY env var
- Z.ai GLM-5 (OpenAI-compatible endpoint)
  Auth: ZAI_API_KEY env var, base URL: https://api.z.ai/v1

**Cloud GPU (second/minute-billed — counts against $20 cap):**
- RunPod: Gemma 4 26B A4B (only if E4B local latency > 2000ms p95)
  Auth: RUNPOD_API_KEY env var

---

### Budget enforcement (MANDATORY — implement this first)

Create `budget/spend_tracker.py`:

- Persistent spend store: `budget/spend_log.json`
  Schema: { "month": "YYYY-MM", "total_usd": float,
            "entries": [ {timestamp, provider, model,
                          tokens_or_seconds, cost_usd} ] }
- On every cloud call: check current month total BEFORE the call
- If (current_total + estimated_cost) >= $20.00:
  → ABORT the call
  → Print: "HARD CAP REACHED: $XX.XX of $20.00 used this month. Aborting."
  → Exit with code 2 (not 1 — distinguishable from other errors)
- If (current_total + estimated_cost) >= $18.00 (warning threshold):
  → Print warning but proceed
- After every successful cloud call: append to spend_log.json immediately
- Month resets automatically on calendar month boundary
- spend_log.json must be gitignored (contains cost data)
- Cost estimation formulas:
  - Anthropic claude-sonnet-4-20250514:
      input: $3.00/1M tokens, output: $15.00/1M tokens
  - OpenAI gpt-4o-mini:
      input: $0.15/1M tokens, output: $0.60/1M tokens
  - Z.ai GLM-5: estimate same as gpt-4o-mini until verified
  - RunPod RTX 4090: $0.34/hr = $0.000094/second
    Estimate: model_load_time(120s) + inference_time before calling

---

### Benchmark harness

Create `benchmark/run_benchmark.py`:

**Inputs (configurable via CLI args):**
- `--models`: comma-separated list, default=all
- `--prompt`: benchmark prompt, default= "Describe what you see in this
  image." with a standard test image (include a small test PNG in repo)
- `--runs`: number of runs per model, default=5
- `--output`: output file path, default=benchmark/results/YYYYMMDD_HHMMSS.json

**Metrics per model per run:**
- time_to_first_token_ms (TTFT)
- total_latency_ms
- tokens_per_second (throughput)
- input_tokens, output_tokens
- estimated_cost_usd (0.0 for local)
- gpu_vram_used_mb (local only, via pynvml)
- gpu_utilization_pct (local only, via pynvml)
- error (null or error message)

**Aggregated output per model:**
- p50, p95, p99 latency
- mean throughput (tokens/sec)
- total_cost_usd for the run
- practical_verdict: one of:
    "LOCAL_OK" — p95 latency < 2000ms
    "LOCAL_MARGINAL" — p95 latency 2000–5000ms
    "LOCAL_IMPRACTICAL" — p95 latency > 5000ms → flag for cloud escalation
    "CLOUD_OK" — cloud run succeeded
    "CLOUD_SKIPPED" — cap would be exceeded
    "API_OK" — API call succeeded within budget
    "API_SKIPPED" — cap would be exceeded

**Cloud escalation logic:**
- Only escalate to RunPod if local model returns LOCAL_IMPRACTICAL
- Before escalating: print estimated cost and ask for confirmation (y/n)
  "RunPod 4090 estimated cost for this benchmark: $X.XX
   Monthly spend so far: $X.XX / $20.00
   Proceed? [y/n]"
- If n: mark as CLOUD_SKIPPED, continue

---

### Setup script

Create `benchmark/setup.sh`:

```bash
#!/bin/bash
set -e

echo "=== Installing PyTorch (CUDA 12.9) ==="
pip install torch torchvision \
  --index-url https://download.pytorch.org/whl/cu129

echo "=== Installing benchmark dependencies ==="
pip install pynvml anthropic openai httpx rich pytest

echo "=== Checking Ollama ==="
ollama --version || echo "WARNING: Ollama not installed — local models unavailable"

echo "=== Pulling Gemma 4 E4B ==="
ollama pull gemma4:e4b || echo "WARNING: Pull failed — check Ollama"

echo "=== Creating directory structure ==="
mkdir -p benchmark/results budget
touch budget/spend_log.json
echo '{"month":"'$(date +%Y-%m)'","total_usd":0.0,"entries":[]}' \
  > budget/spend_log.json

echo "=== Setup complete ==="
```

---

### Output format

`benchmark/results/YYYYMMDD_HHMMSS.json`:
```json
{
  "run_date": "ISO timestamp",
  "machine": {
    "gpu": "RTX 4070",
    "vram_gb": 12,
    "cuda": "12.9",
    "ram_gb": 64
  },
  "budget": {
    "cap_usd": 20.00,
    "spent_this_month_usd": 0.00,
    "remaining_usd": 20.00
  },
  "models": [
    {
      "model_id": "gemma4:e4b",
      "provider": "local/ollama",
      "runs": [...],
      "aggregated": {...},
      "practical_verdict": "LOCAL_OK"
    }
  ]
}
```

---

### File structure

```
sandbox-claude-code/benchmark/
├── run_benchmark.py
├── setup.sh
├── test_image.png          ← include a small (< 50KB) test image
├── results/                ← gitignored
└── README.md

sandbox-claude-code/budget/
├── spend_tracker.py
├── spend_log.json          ← gitignored
└── __init__.py
```

---

### .gitignore additions

```
benchmark/results/
budget/spend_log.json
.env
```

---

### Tests

Create `benchmark/tests/test_budget.py`:
- Test: spend check blocks at $20.00
- Test: spend check warns at $18.00
- Test: monthly reset works correctly
- Test: spend_log.json appended correctly after mock cloud call
- Test: exit code 2 on hard cap hit

---

## Constraints (NON-NEGOTIABLE)

- Budget guard MUST be implemented and tested before any cloud call code
- spend_tracker.py MUST be imported by every cloud provider module —
  no cloud call without going through the tracker
- Hard cap exit code MUST be 2
- No API keys hardcoded anywhere — env vars only
- All cloud calls MUST be wrapped in try/except with cost rollback
  if the call fails after billing starts
- Code standard: typed, logged, error-handled
  (follows production-policy.md standards in policies repo)

---

## Execution order (tell Cursor to follow this exactly)

1. Create budget/spend_tracker.py + tests — verify tests pass
2. Create benchmark/setup.sh — run it
3. Create benchmark/run_benchmark.py (local models first)
4. Add API model clients (import spend_tracker before each)
5. Add RunPod client (import spend_tracker before)
6. Run full benchmark, save results
7. Print summary table to stdout

## Verification checklist

- [ ] pytest passes on budget tests before any cloud code exists
- [ ] setup.sh runs without errors
- [ ] Local Ollama benchmark produces results JSON
- [ ] $20 cap blocks cloud calls in tests
- [ ] No API keys in any file
- [ ] spend_log.json gitignored
