# IntentCUA — Agent Architecture Reference (Policy-Relevant)

**Source:** arXiv:2602.17049 (IntentCUA)
**PDF:** `rules/references/intentcua.pdf`
**Date:** February 2026
**Cross-reference:** ai-workflow-policy.md §Agent Orchestration and Artifact Governance

---

## Summary

IntentCUA is a multi-agent computer-use framework achieving **74.83% task success** with a **Step Efficiency Ratio (SER) of 0.91** across 286 real-world desktop tasks, outperforming RL-based (UI-TARS-1.5) and trajectory-centric (UFO²) baselines. The key result: **structured intent abstraction + plan memory** beats raw trajectory replay.

---

## Key Numbers (Policy Rationale)

| Metric | IntentCUA | UFO² | UI-TARS-1.5 |
|--------|-----------|------|-------------|
| Task success | 74.83% | 51.2% | 38.8% |
| Step Efficiency Ratio | 0.91 | — | — |
| Latency (avg) | 1.46 min | 6.63 min | 9.82 min |
| Success at 30+ steps | >40% | <20% | <20% |

**Ablation (Table 1):**
- Removing **Skill Hints** alone: 74.83% → 62.51% (–12.32pp)
- **Plan memory** contribution: +7.87pp gain
- **Intent-anchored** planning vs step-level: keeps retrieval semantically coherent across heterogeneous environments

---

## Architectural Vocabulary

- **Planner / Plan-Optimizer / Critic** — Separation of concerns. Planner operates at **intent-group** level, not step level.
- **Intent groups (IG) and subgroups (SG)** — Keep retrieval coherent when context changes; step-level plans drift.
- **Critic gate** — Mandatory `{success, retryable, blocked}` signal after each plan unit; prevents cascading failures.
- **Skill hints** — Parameterized schemas (e.g. `<url>`, `<query>`), not copy-pasted traces; runtime-filled typed arguments prevent overfitting.

---

## Policy Implications

1. **Agents MUST store reusable skill abstractions, not raw trajectory traces.**
   Greedy trace replay adds +23.7pp success but drifts on long sequences; skill abstraction adds a further +8.2pp (Table 1).

2. **Long-horizon tasks (≥ 10 steps) REQUIRE plan memory with intent-anchored retrieval.**
   Without plan-memory reuse, agents re-synthesize from scratch and accumulate errors (+7.87pp from plan-memory alone).

3. **Planning MUST be intent-anchored, not step-anchored.**
   Step-level plans drift when context changes; IG/SG keep retrieval semantically coherent.

4. **Critic agent is mandatory for agentic stability, not optional.**
   Critic provides the gate after each plan unit; without it, local errors cascade into global re-planning.

5. **Skill hints MUST be parameterized schemas, not copy-pasted traces.**
   Runtime-filled typed arguments preserve reusable structure while avoiding overfitting to specific past inputs.

---

## Where This Lands in Policy

- **Primary:** ai-workflow-policy.md — Agent Orchestration and Artifact Governance (§Agentic architecture rules)
- **See also:** cc-agent-teams-feature.md, agent-hq-orchestration-complete-notes.md

---

**Last updated:** 2026-02-23
