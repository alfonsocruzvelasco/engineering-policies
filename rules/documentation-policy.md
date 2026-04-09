# Documentation Policy

**Status:** Authoritative
**Last updated:** 2026-03-11

> *Inline `Last updated` footers under individual sections are subordinate revision markers. The file-level date above is the summary stamp for the document as a whole.*

This policy ensures documentation is accurate, minimal, searchable, and maintained as a first-class artifact.

**Note:** This policy was split from the consolidated `versioning-and-documenting-policy.md` for better organization. See also:
- [Production Policy](production-policy.md) Section 5 (Git and Source Control Policy) for Git workflow and repository management
- [Versioning and Release Policy](versioning-and-release-policy.md) for versioning schemes and release processes

---

## 1) Core principles

- Documentation MUST be **close to code** and updated with changes.
- Prefer **short, operational** writing: what to do, how to verify, how to rollback.
- Avoid duplication. One source of truth per topic.
- **Truth maintenance:** Documentation is treated as a tested artifact where possible. Polished but incorrect docs are worse than no docs. Documentation must be verifiable and maintainable.

### Acronyms
- **ADR** = Architecture Decision Record
- **PR** = Pull Request

## 2) Required documents per repository

Each engineering repository MUST have:
- `README.md` with: purpose, quickstart, environment, tests, key links, **Technical Baseline** (see [Language Standards and Framework Versions](#10-language-standards-and-framework-versions))
- `docs/` (or equivalent) for deeper guides
- `CHANGELOG.md` if the project has releases (see [Versioning and Release Policy](versioning-and-release-policy.md))
- Contribution notes (`CONTRIBUTING.md`) if multiple contributors exist

## 3) Documentation structure

Use this hierarchy:
- **README**: entry point
- **Guides**: "how-to" steps, reproducible
- **Reference**: API/config reference, stable facts
- **Decisions**: ADRs or decision log entries

## 4) Quality standards

Documentation MUST:
- Use accurate commands and paths
- Include verification steps ("how to confirm it worked")
- Include rollback steps for impactful changes
- State assumptions and constraints explicitly
- Avoid screenshots as the only source of truth (text must exist)
- **Be verifiable:** Where possible, documentation should be executable (scripts, tests, configs) or at least testable (commands that can be run to verify)
- **Be maintainable:** Documentation that becomes stale is a liability. Prefer executable documentation (code, scripts, configs) over prose when possible.

## 5) Update discipline

- Any PR that changes behavior MUST update relevant docs or justify why not.
- Broken docs are treated as bugs.
- **Truth maintenance discipline:** With AI-assisted documentation generation, the risk is polished but incorrect docs. Every documentation update must be verified:
  - Commands must be tested
  - Examples must be runnable
  - Code snippets must compile/execute
  - Links must be valid
- **Critical reading + reproducibility:** Documentation must enable reproducibility. If a reader cannot reproduce the documented behavior, the documentation is incorrect.

## 6) AI Output Structure (Evidence vs Interpretation)

AI-generated analysis, research summaries, and reasoning outputs MUST separate evidence from interpretation. AI reasoning is not evidence — it is model interpretation derived from evidence.

**Required structure for AI-assisted reasoning outputs:**

| Section | Content | Rule |
|---|---|---|
| **Evidence** | Sources, datasets, measurements, papers, code behavior | Must be independently verifiable |
| **Model Interpretation** | AI reasoning derived from evidence | Clearly labeled as AI-generated analysis |
| **Uncertainty** | What could make this conclusion wrong, confidence level, missing data | Must be explicit, never omitted |

**Why:** Sycophantic AI generates confirmatory samples that inflate confidence without improving truth (Batista & Griffiths, Princeton, 2026). Separating evidence from interpretation prevents treating AI reasoning as data. See `ai-workflow-policy.md §13.2`.

**Applies to:** Architecture decision records, research notes, debugging post-mortems, experiment analysis, any document where AI contributed to the reasoning chain. Does NOT apply to procedural outputs (code, configs, templates).

## 7) Diagrams

- Use diagrams only when they reduce complexity.
- Diagrams MUST be editable text formats (e.g., Mermaid) or source-controlled assets.
- Do not embed opaque diagrams with no source.

## 8) Naming and style

- Filenames SHOULD be lowercase with hyphens.
- Use consistent section headers and avoid jargon without definition.

## 9) Ownership

Each major document SHOULD declare an owner (team or role) and a review cadence (e.g., quarterly for policies, monthly for runbooks).

## 10) Domain-Specific Documentation Standards

For **Machine Learning and Computer Vision** projects, comprehensive documentation standards are available in `references/ml-cv-documentation-standards.md`. This reference covers:

- **Python docstring standards:** Google-style (industry standard) and NumPy-style (scientific/research contexts)
- **Type hints (PEP 484):** Best practices for ML/CV code with tensor shape documentation
- **C++/CUDA documentation:** Doxygen standards for performance-critical layers
- **Documentation generation tools:** Sphinx, MkDocs, pdoc configuration for ML/CV projects
- **Real-world examples:** Patterns from PyTorch, NumPy, Hugging Face, and other major ML/CV libraries
- **Tooling ecosystem:** Linters, validators, type checkers, and pre-commit hooks
- **Decision matrix:** When to use Google-style vs NumPy-style docstrings, when to use Doxygen

**Key principle:** Use the documentation system native to the language of the layer you're working in:
- **80% of ML/CV work** → Python docstrings (Google/NumPy style)
- **15% of ML/CV work** → Mixed Python/C++ (docstrings + Doxygen)
- **5% of ML/CV work** → Pure C++/CUDA (Doxygen)

See `references/ml-cv-documentation-standards.md` for complete guidelines, templates, and examples.

## 11) Language Standards and Framework Versions

**Status:** Authoritative
**Last updated:** 2026-01-30

### Core Principle

Language standards and critical framework versions MUST be documented **per-project** (in each repository), not globally in machine-level policies. This ensures reproducibility, prevents silent compiler drift, and maintains CI/local consistency.

### What to Document

#### 1. Language Standard (Mandatory)

Every repository MUST document the language standard it targets:

**Examples:**
- `C++: C++20 (ISO, no GNU extensions)`
- `Python: 3.11`
- `TypeScript: ES2022 target`
- `Rust: Edition 2021`

**Why:** Prevents silent compiler drift, CI vs local mismatch, and dependency incompatibility.

**Where:**
- `README.md` → **Technical Baseline** section (see template below)
- Build configuration files → **enforced in tooling** (`pyproject.toml`, `CMakeLists.txt`, `package.json`, `Cargo.toml`, etc.)

**Policy alignment:** Versions are operational facts, not prose. Documentation must be verifiable and close to code.

#### 2. Critical Framework/Runtime Versions (Only if they affect behavior)

Record **only versions that influence compatibility or reproducibility**:

**Good examples (major versions that affect behavior):**
- `CUDA Toolkit: 12.4`
- `PyTorch: 2.2`
- `TensorRT: 10.x`
- `OpenCV: 4.10`
- `Node: 20 LTS`
- `GCC: ≥14` (for C++20 support)

**Bad examples (too granular, belongs in lockfiles):**
- `numpy 2.1.3`
- `requests 2.31.0`
- `react 18.2.0`

**Rule:** If a version is in a lockfile (`poetry.lock`, `package-lock.json`, `Cargo.lock`), it does NOT belong in README. Only document versions that:
- Affect build compatibility
- Require specific runtime versions
- Impact reproducibility across environments
- Are referenced in build configuration

#### 3. Enforcement Requirement

**Everything listed in Technical Baseline MUST be enforced in build config**, not just written:

- Python version → `pyproject.toml` `requires-python` + `pyenv` or `Dockerfile`
- C++ standard → `CMakeLists.txt` `set(CMAKE_CXX_STANDARD 20)`
- TypeScript target → `tsconfig.json` `"target": "ES2022"`
- Node version → `.nvmrc` or `Dockerfile` `FROM node:20`

**Single source of truth:** Build configuration is authoritative. README summarizes and references it.

### What NOT to Do

Do **NOT**:
- Store global language preferences in machine-level policies (`~/policies/`)
- Hardcode versions in prose without tool enforcement
- Duplicate dependency lists outside lock/config files
- Document every transitive dependency version

**Rationale:** Policies enforce **single source of truth** and **verifiable documentation**. Versions must be enforceable, not decorative.

### README Template: Technical Baseline

Each repository README MUST include a **Technical Baseline** section:

```markdown
## Technical Baseline

| Component | Version | Notes |
|-----------|---------|-------|
| Python    | 3.11    | Managed via pyenv, enforced in `pyproject.toml` |
| C++       | C++20   | ISO mode, no GNU extensions. Enforced in `CMakeLists.txt` |
| Compiler  | GCC ≥14 | Must support C++20 fully |
| CUDA      | 12.4    | Required for GPU builds |
| PyTorch   | 2.2     | See `pyproject.toml` for exact version |
| Node      | 20 LTS  | See `.nvmrc` |
```

**Requirements:**
- Every version listed MUST be enforced in build configuration
- Include a "Notes" column explaining where it's enforced
- Keep it minimal — only critical versions
- Reference lockfiles for exact dependency versions

### Verification

To verify compliance:
1. Check that every version in Technical Baseline has a corresponding enforcement in build config
2. Run build/CI to confirm versions are actually enforced
3. Verify README and config files stay in sync (documentation drift is a bug)

## 12) Exceptions

If documentation lags by necessity, record the exception in the Exception and Decision Log (see below) with a clear deadline to reconcile.

---

# Exception and Decision Log

**Status:** Authoritative
**Last updated:** 2026-01-16

This section records:
- **Exceptions**: deviations from policy (temporary or permanent)
- **Decisions**: significant choices that affect architecture, workflow, or long-term maintenance

## 1) Rules

- Every entry MUST be dated.
- Every entry MUST have an owner.
- Exceptions MUST include a sunset date (or explicit "permanent with justification").
- Decisions MUST include alternatives considered and the rationale.

### Acronyms
- **ADR** = Architecture Decision Record
- **SLA** = Service Level Agreement

---

## Template: Decision (ADR-style)

**Date:** YYYY-MM-DD
**Type:** Decision
**Title:** <short, specific>
**Owner:** <name/role>

**Context:**
<what problem we are solving, constraints, assumptions>

**Decision:**
<what we will do>

**Rationale:**
<why this is the best trade-off>

**Consequences:**
- Positive:
- Negative:
- Follow-ups:

**Alternatives considered:**
- Option A:
- Option B:

---

## Template: Exception

**Date:** YYYY-MM-DD
**Type:** Exception
**Policy violated:** <document + section>
**Owner:** <name/role>
**Risk level:** Low / Medium / High
**Justification:** <why unavoidable>
**Mitigations:**
- <controls to reduce risk>

**Sunset date:** YYYY-MM-DD
**Rollback plan:** <how to return to compliance>

---

## Log entries

(Empty — add new entries below this line.)
