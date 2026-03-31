# PRD Template — Minimal Product Requirements Document

**Status:** Authoritative
**Purpose:** Mandatory pre-coding artifact for any work estimated at >2 hours. Prevents drift, forces clarity, enables issue decomposition.

**Rule:** No coding without a PRD for anything >2 hours of work.

---

## PRD — \<project-name\>

### Goal

What problem does this solve? (1–2 sentences)

### Input / Output

What goes in? What comes out?

### Constraints

- Performance?
- Data?
- Environment?
- Time budget?

### Core Functionality

Bullet list of MUST-have features.

### Non-Goals

What we explicitly ignore. (Prevents scope creep.)

### Success Criteria

How do we know it works? (Observable, testable.)

---

## Issue Decomposition (After PRD)

Break the PRD into vertical slices (tracer bullets). Each issue cuts through ALL layers end-to-end — not a horizontal slice of one layer.

Each issue must:

- Be executable in <2–4 hours
- Produce something testable
- Not depend on unclear steps
- Be independently verifiable (demoable or testable on its own)
- Be classified as **AFK** or **HITL** (see below)

**Slice classification:**

| Type | Meaning | Preference |
|------|---------|------------|
| **AFK** | Can be implemented and merged without human interaction | Preferred — maximizes parallel autonomous execution |
| **HITL** | Requires human decision, design review, or approval before proceeding | Use when architectural choices or trade-offs need human judgment |

```text
BAD:
- build model pipeline

GOOD:
- load dataset and validate schema
- implement baseline model
- add training loop with checkpointing
- evaluate metrics and log results
```

### Issue Template

```markdown
## Parent PRD

<link or title>

## Type

AFK / HITL

## What to Build

Concise description of this vertical slice. Describe end-to-end behavior, not layer-by-layer implementation.

## Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked By

- None / #issue-number
```

---

## Extended PRD (Use When Needed)

For larger projects, add these sections:

### User Stories

Numbered list. Format: "As a \<role\>, I want \<action\>, so that \<outcome\>."

### Implementation Decisions

Architectural decisions, schema changes, API contracts, module interfaces. No file paths or code snippets (they go stale).

### Testing Decisions

What makes a good test for this project, which modules get tested, prior art for tests.

---

## Decision Rule

```text
If the problem is unclear → write (PRD)
If the work is unclear   → split (issues)
If both are clear        → code
```

---

## References

- [write-a-prd skill](https://github.com/mattpocock/skills/tree/main/write-a-prd) — PRD creation through user interview and module design (Pocock)
- [prd-to-issues skill](https://github.com/mattpocock/skills/tree/main/prd-to-issues) — Vertical-slice issue decomposition from PRD (Pocock)
- `ai-workflow-policy.md` Part 4 — Spec-driven development (OpenSpec/Spec Kit for ML/CV)
