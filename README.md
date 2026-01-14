# Personal Engineering Policies (Authoritative)

## Source of Truth

This repository is the single source of truth for all engineering policies.

Canonical local path:
- ~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/

Convenience symlinks:
- ~/dev/policies -> ~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/
- ~/learning/policies -> ~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/
- ~/policies -> ~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/

**Status:** Authoritative  
**Last updated:** 2026-01-13

This repository is the **single source of truth** for how software is designed, built, reviewed, shipped, secured, and maintained across all of my development work.

It defines **non-negotiable rules**, **explicit boundaries**, and **decision discipline** for professional-grade engineering.

---

## Purpose

This policy set exists to:

- Eliminate ambiguity and “works on my machine” behavior
- Prevent silent drift in tools, environments, and practices
- Make decisions explicit, reviewable, and reversible where possible
- Protect long-term maintainability over short-term convenience
- Ensure AI-assisted work remains correct, auditable, and safe
- Enforce prompt engineering discipline to reduce hallucinations and increase reproducibility

These policies are written for **real engineering work**, not experimentation folklore.

---

## Scope

These policies apply to:

- All personal repositories
- All local development environments
- All CI/CD pipelines
- All data, models, and artifacts
- All AI-assisted engineering work

They apply unless an **explicit exception** is recorded.

---

## Authority model

- This repository is **authoritative**
- If a rule is not documented here, it is **not authoritative**
- No undocumented exceptions are allowed
- Behavior must follow policy — **policy is updated before habits form**

All deviations require a recorded exception or decision.

---

## `/policies` structure (current)

The `/policies` folder is organized around **compiled policy bundles** (merged documents) to reduce fragmentation and maintenance overhead.

### Core system policies

- **`system-dev-env-policy.md`**  
  *Where and how things live and run*  
  (directory layout, workspaces, environment rules, IDE roles, MCP boundaries)

### Compiled engineering policy bundles

- **`data-projects-and-tooling-setup-policy.md`**  
  *Engineering tooling, project bootstrap, workflow quality gates + data/artifacts/SQL discipline*  
  (repo setup, CI hygiene, language toolchains, and the CV/ML data stack rules)

- **`versioning-security-and-documenting-policy.md`**  
  *Governance bundle*  
  (documentation discipline, exception/decision log process, Git/source control rules, security/secrets baseline, and versioning/release rules)

- **`ai-usage-policy.md`**  
  *AI usage boundaries + the single authoritative prompting reference*  
  (allowed/forbidden AI use, auditability, and comprehensive prompt engineering discipline)

---

## How to use this repository

Consult these policies when you:

- Start a new project
- Introduce a new tool, dependency, or workflow
- Change environment layout or build strategy
- Add AI into any part of engineering work
- Handle data, models, or production artifacts
- Feel unsure about “what is allowed”

Update these policies when:

- Reality changes in a durable way
- A rule proves insufficient or incorrect
- A new class of risk or failure appears

---

## Change discipline

Policies change deliberately, not casually.

Every meaningful change requires:

- a clear rationale
- an owner
- a date
- an entry in the exception/decision log (inside `versioning-security-and-documenting-policy.md`)

This repository is **infrastructure**, not documentation noise.

---

## Final rule

If behavior and policy diverge, **policy must be updated first** —  
never the other way around.
