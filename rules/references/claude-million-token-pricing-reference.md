# Claude 1M Context Pricing Shift (March 2026) — Policy Reference

**Status:** Reference
**Last updated:** 2026-03-20

## Source

- [The New Stack — Anthropic makes a pricing change that matters for Claude's longest prompts](https://thenewstack.io/claude-million-token-pricing/)

## What changed

Anthropic removed the long-context surcharge for Claude Opus 4.6 and Sonnet 4.6, making 1M-token context available at standard per-token rates (no premium tier trigger after ~200k tokens).

## Architecture implications

This changes the optimization target:

- **Before:** avoid long prompts primarily to avoid premium rate tiers.
- **Now:** choose architecture based on correctness, latency, determinism, governance, and operational complexity.

Large-context prompting is now easier to justify for bounded, high-coherence tasks (e.g., repo-wide reasoning, broad debugging context), but this does **not** remove the need for retrieval pipelines.

## Policy translation for this repository

1. Do not choose RAG only to avoid long-context surcharges.
2. Continue using RAG/retrieval when precision, authority control, and citation traceability matter.
3. Treat context strategy as an empirical decision:
   - compare single-pass large-context vs retrieval-first pipelines
   - measure quality, latency, token cost, and reproducibility
4. Keep context engineering discipline: "more context" is not automatically "better context."
