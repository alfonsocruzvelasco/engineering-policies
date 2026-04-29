# Structured-Prompt-Driven Development (SPDD)

**Source:** Wei Zhang & Jessie Jie Xia, martinfowler.com, April 28 2026
**URL:** https://martinfowler.com/articles/structured-prompt-driven/

## What it is

A Thoughtworks engineering method that treats prompts as first-class
versioned delivery artifacts. Prompts are committed to version control,
reviewed, and kept in sync with the code they produced.

## The REASONS Canvas

A seven-part spec structure that guides a prompt from intent → design →
execution → governance:

- R — Requirements: what problem are we solving and what is the DoD?
- E — Entities: domain entities and relationships.
- A — Approach: strategy for meeting the requirements.
- S — Structure: where the change fits; components and dependencies.
- O — Operations: concrete, testable implementation steps.
- N — Norms: cross-cutting engineering standards (naming, observability,
  defensive coding).
- S — Safeguards: non-negotiable boundaries (invariants, performance
  limits, security rules).

## The gap this fills relative to existing policy

Existing policy (ai-workflow-policy.md) enforces spec-first execution
but has no explicit reverse sync step. SPDD adds two directional flows:

- requirements → prompt → code (logic corrections)
- code → prompt (refactoring sync via /spdd-sync)

This prevents prompt-code drift when refactoring happens after
generation.

## The one addition worth encoding

When refactoring AI-generated code, sync the change back to the spec
before closing the task. The spec must remain an accurate record of
the current code, not the code as it was first generated.

## Relationship to existing policy

- REASONS Canvas is a richer formalisation of the spec structure
  already in rules/templates/prompt-template.md.
- /spdd-sync discipline is not yet encoded in ai-workflow-policy.md.
- Three core skills (abstraction-first, alignment, iterative review)
  map to Part 4 of ai-workflow-policy.md pre-code checklist.

## Policy impact

One addition to ai-workflow-policy.md Spec–Plan–Patch–Verify loop:
after any refactoring step, sync changes back to the spec file before
committing. See cross-reference in ai-workflow-policy.md.
