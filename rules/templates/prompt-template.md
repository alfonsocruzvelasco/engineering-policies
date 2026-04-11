# Prompt Template — v3 (Task Card)

**Status:** Authoritative
**Purpose:** Practical, low-friction task prompts for Cursor/Codex under a diff-first, review-first, non-autonomous workflow.

This template intentionally replaces the previous verbose template. Governance lives in policies and `.cursorrules`; this file is for *daily execution*.

---

## Core Principles (Do Not Repeat in Prompts)

* AI is advisory-only (no autonomy, no auto-apply)
* Diff-first, review required
* Verification required (tests or repro)
* Repo-scoped only

(These are enforced by settings and `.cursorrules`.)

---

## Task Card (Use This for Every Task)

**Atomic Task Principle:** Each task must be completable in <30 minutes. If larger, break into subtasks. A precise task contract saves more tokens than any model or parameter tweak.

```text
Task: <one clear sentence>

Repo:
- Path: <repo root path>
- Scope: ONLY this repo. No external files. No system/env changes. No new deps unless stated.
- Diff rules: diff-first, max 200 lines, no auto-apply, review required.

Definition of done:
- <1–3 observable checks> (tests or exact repro commands)

Stopping condition:
- Max attempts: 3 (if all fail → diagnose p_k trend, harden prompt, restart from clean context)
- Token budget: <budget or "default 500K">

Process (Spec–Plan–Patch–Verify):
1) Consult CLAUDE.md for relevant patterns/mistakes (if exists).
2) Ask up to 3 clarifying questions ONLY if blocked.
3) PLAN: Propose a short plan (3–6 bullets). Approve only the first bounded step.
4) PRE-ACTION: Complete **Pre-Action Verification (MANDATORY)** (see Verification Checkpoints)
   before any tool use, shell command, or patch. If any check = NO → STOP.
5) PATCH: Output a unified diff for that step only.
6) VERIFY: List exact validation commands. Write a checkpoint note if context is swelling.
7) STOP OR CONTINUE: If verification passes and next step has positive marginal value, continue
   from checkpoint. If 3 consecutive failures → stop, diagnose, harden prompt before retrying.
8) After final validation passes: capture learnings in CLAUDE.md, then reset context for next task.
```

## Verification Checkpoints (Mandatory)

### Pre-Action Verification (MANDATORY)

1. State:
   - What exists right now?
   - (files, inputs, environment)

2. Intent:
   - What exactly will be done?

3. Constraints:
   - What must NOT be violated?

4. Check:
   - Preconditions satisfied? (yes/no)

If any check = NO → STOP

### Policy Verification
Before starting: Verify no constraint violations in task request.
- Restate the task in your own words before executing. If the restatement diverges from the spec, stop and ask for clarification.
- Check: Does task violate scope, limits, or constraints?
- If violated → Stop, report violation, do not proceed.

### Phase Verification (After Each Step)
Required:
- All commands exit code == 0
- Expected files present
- No skipped steps
- No merged or reordered steps

If any check fails → Mark phase as FAILED, do not proceed.

### Final Acceptance Gate
Accept output ONLY if:
- Policy verification passed
- All phase verifications passed
- Output matches definition of done exactly

Otherwise: REJECT.

---

## Model-Specific Parameters (Optional)

### For Opus 4.6/4.5
Add: `/effort=low` (routine tasks) | `medium` (balanced) | `high` (complex/critical)

### For Codex Models (GPT-5.3 Codex, GPT-5.2 Codex)
Emphasis: "Produce unified diff only. No explanations unless requested."

### For Local Models (qwen3-coder, etc.)
Constraint: "Minimize token usage. Terse responses. Code only."

### Prompt Repetition (Non-Reasoning Paths Only)
When using non-reasoning inference (no CoT/extended thinking), repeat the task card to improve attention coverage. Do not repeat retrieved context or RAG documents. Highest value for structured lookup tasks (entity extraction, list retrieval). See `../references/ai-workflow-prompt-patterns-reference.md` (Prompt Repetition) and `../references/prompt-repetition-improves-non-reasoning-llms.pdf`.

### Epistemic Mode (Reasoning Tasks)

The assistant must NOT optimize for agreement with the user.

For any reasoning task (architecture decisions, hypothesis evaluation, research analysis, debugging root cause), include this directive in the prompt:

```text
Epistemic mode: ON
- Challenge my assumptions
- Surface contradictory evidence
- Highlight uncertainty explicitly
- Prefer falsification over confirmation
- If you agree with my hypothesis, explain what would change your mind
```

**Counter-analysis block** (append to reasoning prompts):

```text
Before answering, analyze:
1. What assumption the user is making
2. Why it might be wrong
3. What evidence would disprove it
```

**Source:** Batista & Griffiths (Princeton, 2026) showed default LLM behavior is indistinguishable from explicit sycophancy — 5.9% discovery rate vs 29.5% with unbiased sampling. See `../references/ai-workflow-prompt-patterns-reference.md` (Hypothesis Stress Test) and `../references/a-rational-analysis-of-the-effects-of-sycophantic-ai.pdf`.

### Diversity Forcing (Open-Ended / Creative Tasks)

LLMs exhibit pronounced mode collapse on open-ended tasks — 79% intra-model similarity, 71–82% inter-model similarity, even with high-temperature sampling. Switching models does not guarantee diverse output. When the task requires genuinely different alternatives (brainstorming, design exploration, hypothesis generation), add this directive:

```text
Generate N alternatives that differ structurally, not just in phrasing.
Each alternative must use a different [approach / framing / assumption / starting constraint].
Do not produce variations of the same core idea.
```

For design/architecture exploration, bind each alternative to a different constraint:

```text
Option A: Optimize for [latency]
Option B: Optimize for [cost]
Option C: Optimize for [simplicity]
```

**Source:** Jiang et al., "Artificial Hivemind," NeurIPS 2025 — different models converge on the same ideas with verbatim overlap. See `../references/ai-workflow-prompt-patterns-reference.md` (Diversity Collapse Awareness) and `../references/artificial-hivemind.pdf`.

---

## Optional Add-ons (Use Only When Needed)

### Risks to Watch (for sensitive changes)

```text
Risks:
- <risk 1>
- <risk 2>
```

### Prior Knowledge (Osmani Loop)

```text
Before starting: Read CLAUDE.md for patterns/mistakes relevant to this task.
- Apply documented patterns
- Avoid documented mistakes
- If no relevant patterns found, proceed with best practices
- After task completion: Update CLAUDE.md with new patterns/mistakes learned
```

**Self-Improving Loop:**
1. Pick atomic task (<30 min)
2. Consult CLAUDE.md for patterns/mistakes
3. Implement with validation
4. Capture learnings in CLAUDE.md
5. Reset context for next task

---

## What This Template Explicitly Avoids

* No global system prompts
* No RAG configuration in prompts
* No architecture debates unless explicitly requested
* No multi-task bundling

---

## When to Write a PRD First

**Mandatory PRD gate:** If the work is estimated at >2 hours, write a PRD before coding. See `rules/templates/prd-template.md`.

```text
If the problem is unclear → write (PRD)
If the work is unclear   → split (issues)
If both are clear        → code (use Task Card above)
```

After the PRD, decompose into vertical-slice issues (<2–4h each, testable, no unclear deps), then use the Task Card for each issue.

## When to Use a Larger Spec

Escalate to a spec-driven prompt (OpenSpec/Spec Kit) when:

* The task spans many files/modules
* Behavior is production-critical
* A design decision is required
* Working on existing ML/CV code (use **OpenSpec** — see `rules/references/openspec-ml-cv-reference.md`)

**For ML/CV work on existing code:** **OpenSpec is mandatory** to prevent silent regressions and preserve data/architecture invariants. Use `/openspec:proposal` to create proposal before implementation.

Otherwise, **always** use the Task Card above.

---

## Self-Improving Loop (Osmani Pattern + Stochastic Stopping)

**Core principle:** Small, bounded tasks with validation and knowledge capture → compound productivity over time. Agents are stochastic — optimize for fewer bad turns, not maximum autonomy.

**Required after each task:**
- Validation passes → Update CLAUDE.md with learnings → Write checkpoint → Reset context → Next task
- Validation fails (attempt 1–2) → Prune context, apply verifier feedback as structured hint, retry
- Validation fails (attempt 3) → **STOP.** Diagnose: is *p_k* declining (context poisoning) or stationary (hard task)? Harden prompt or restructure task before retrying. Never retry into a poisoned context.

**Context reset:** Each task starts fresh. Put state in checkpoint files, not in the conversation. Accumulated context degrades success probability.

---

## Versioning

* v3 replaces v2.x entirely
* Integrates Osmani self-improving loop principles
* Future changes must keep this file ≤ 1 page
