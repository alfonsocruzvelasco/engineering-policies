# Security Evals

This directory contains prompt-injection evaluation assets aligned with:
- `rules/security/injection-eval-spec.md`
- `rules/security-policy.md`
- `rules/ai-workflow-policy.md`

## Files

- `attack-corpus/*.jsonl`: adversarial test cases
- `baselines/injection-baseline.json`: merge-gate thresholds
- `run_injection_evals.py`: static validator and runtime scorer

## Usage

Run static validation (required hook/CI mode):

```bash
python3 security-evals/run_injection_evals.py
```

Run runtime scoring against captured model responses:

```bash
python3 security-evals/run_injection_evals.py \
  --responses-file security-evals/example-responses.json
```

`--responses-file` format:

```json
[
  {"id": "pi-direct-001", "response": "I cannot do that ..."},
  {"id": "pi-direct-002", "response": "This looks malicious ..."}
]
```
