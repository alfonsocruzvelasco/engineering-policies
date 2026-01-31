# Versioning and Documenting Policy

**Status:** Authoritative
**Last updated:** 2026-01-30

This document consolidates policies for documentation, exception tracking, Git/source control, and versioning/releases. Security policies have been moved to a separate [Security Policy](security-policy.md) document.

## Index

- [Documentation Policy](#documentation-policy)
  - [Language Standards and Framework Versions](#language-standards-and-framework-versions)
- [Exception and Decision Log](#exception-and-decision-log)
- [Git, Source Control, and Release Policy](#git-source-control-and-release-policy)
- [Versioning and Release Policy](#versioning-and-release-policy)

**Note:** Security policy has been moved to a separate document. See [Security Policy](security-policy.md) for all security-related policies.

---

# Documentation policy

<a id="documentation-policy"></a>


**Status:** Authoritative
**Last updated:** 2026-01-30

This policy ensures documentation is accurate, minimal, searchable, and maintained as a first-class artifact.

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
- `README.md` with: purpose, quickstart, environment, tests, key links, **Technical Baseline** (see [Language Standards and Framework Versions](#language-standards-and-framework-versions))
- `docs/` (or equivalent) for deeper guides
- `CHANGELOG.md` if the project has releases (see versioning policy)
- Contribution notes (`CONTRIBUTING.md`) if multiple contributors exist

## 3) Documentation structure

Use this hierarchy:
- **README**: entry point
- **Guides**: “how-to” steps, reproducible
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

## 6) Diagrams

- Use diagrams only when they reduce complexity.
- Diagrams MUST be editable text formats (e.g., Mermaid) or source-controlled assets.
- Do not embed opaque diagrams with no source.

## 7) Naming and style

- Filenames SHOULD be lowercase with hyphens.
- Use consistent section headers and avoid jargon without definition.

## 8) Ownership

Each major document SHOULD declare an owner (team or role) and a review cadence (e.g., quarterly for policies, monthly for runbooks).

## 9) Language Standards and Framework Versions

<a id="language-standards-and-framework-versions"></a>

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

## 10) Exceptions

If documentation lags by necessity, record the exception in `exception-and-decision-log.md` with a clear deadline to reconcile.


---

# Exception and decision log

<a id="exception-and-decision-log"></a>


**Status:** Authoritative
**Last updated:** 2026-01-16

This file records:
- **Exceptions**: deviations from policy (temporary or permanent)
- **Decisions**: significant choices that affect architecture, workflow, or long-term maintenance

## 1) Rules

- Every entry MUST be dated.
- Every entry MUST have an owner.
- Exceptions MUST include a sunset date (or explicit “permanent with justification”).
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


---

# Git, Source Control, and Release Policy

<a id="git-source-control-and-release-policy"></a>


**Status:** Authoritative
**Last updated:** 2026-01-16

This policy defines how code changes are authored, reviewed, merged, versioned, and released.
It applies to all repositories unless explicitly exempted in the exception log.

## Acronyms

* **PR** — Pull Request
* **CI** — Continuous Integration
* **WIP** — Work In Progress
* **SemVer** — Semantic Versioning
* **EOL** — End Of Line (line endings)
* **CRLF** — Carriage Return  Line Feed (`\r\n`, common on Windows)
* **LF** — Line Feed (`\n`, common on Linux/macOS)

## 1) Core principles

1. **History is a shared asset.** It must be understandable, auditable, and reviewable.
2. **`main` is always releasable.** A broken `main` branch is a process failure.
3. **Small, focused changes.** One concern per commit and per PR.
4. **Automation over trust.** CI enforces rules; humans review intent and design.
5. **Reproducibility over convenience.** Releases must be traceable to source and CI artifacts.

## 2) Repository setup and hygiene

6. **One repository, one purpose.** Unrelated projects are not co-located.
7. **Standard root files (as applicable):**
   * `README.md`
   * `LICENSE`
   * `.gitignore`
   * `CODEOWNERS`
   * CI configuration
8. **No generated artifacts committed** (build outputs, caches, vendor folders).
9. **Secrets never enter Git.** Use secret managers; rotate immediately if leaked. See [Security Policy](security-policy.md) for detailed secrets handling.
10. **Large or binary files are avoided.**
    Git LFS MAY be used only with explicit justification and quotas. Object storage is preferred.

11. **Line endings are standardized (cross-platform).**
    * Repository canonical EOL is **LF**.
    * Windows contributors MUST use tooling that respects `.gitattributes` (see Windows section).
    * Add `.gitattributes` to every repo (minimum baseline shown below).

**Baseline `.gitattributes` (required):**
```gitattributes
# Canonical line endings
* text=auto eol=lf

# Common text formats
*.md   text eol=lf
*.txt  text eol=lf
*.yml  text eol=lf
*.yaml text eol=lf
*.json text eol=lf
*.toml text eol=lf

# Shell scripts must be LF (Windows CRLF breaks shebang)
*.sh   text eol=lf

# Batch/PowerShell are typically CRLF (keep native if you want)
*.bat  text eol=crlf
*.cmd  text eol=crlf
*.ps1  text eol=crlf

# Binary (never normalize)
*.png  binary
*.jpg  binary
*.jpeg binary
*.pdf  binary
*.zip  binary
````

## 3) Branching model

12. **Default model: trunk-based development.**

    * Short-lived feature branches.
    * Frequent merges into `main`.
13. **Long-lived branches are discouraged.**

    * Release branches MAY exist when operationally required.
    * Hotfix branches MAY exist for urgent fixes.
14. **Protected `main` branch:**

    * No direct pushes.
    * PR required.
    * CI must pass.
    * Required reviews enforced.
15. **Branch naming conventions:**

    * `feat/<short-desc>`
    * `fix/<short-desc>`
    * `chore/<short-desc>`
    * `docs/<short-desc>`
    * `release/<version>` (if used)
16. **Branches are short-lived** and deleted after merge.

## 4) Commit discipline

17. **Each commit is coherent and buildable.** No half-working commits.
18. **Commit messages are standardized** (Conventional Commits style):

    * `feat: …`
    * `fix: …`
    * `docs: …`
    * `chore: …`
    * `refactor: …`
    * `test: …`
19. **Imperative mood** in subject lines (“add”, not “added”).
20. **Explain why, not just what**, in the body when context matters.
21. **No local noise commits** (debug prints, accidental formatting), unless isolated and intentional.

## 5) Pull Requests (PRs)

22. **PR is the unit of collaboration.** All changes go through PRs.
23. **PR scope is limited** to one logical change.
24. **PR description MUST include:**

    * problem statement
    * solution approach
    * testing performed
    * risks or trade-offs (if any)
25. **PRs SHOULD:**

    * stay under ~400 lines changed unless justified
    * reference an issue or decision record when applicable
26. **WIP PRs are allowed** but MUST be clearly labeled and never merged.

## 6) Code review standards

### 6.1 Mandatory Code Review (CR) enforcement for AI-assisted / agentic coding

Purpose: prevent "high-velocity wrong code" and ensure AI-generated changes are held to the same quality and security bar as human-authored code.

#### A) Governance rules (non-negotiable)

1. **Protected branches are mandatory.** `main` (and `release/*` where applicable) MUST be protected.
2. **PR-only merges.** Direct pushes to protected branches are forbidden.
3. **Human approvals required.** Every PR requires at least **2 approvals**.
4. **CODEOWNERS enforced.** Changes in owned paths require Code Owner approval.
5. **No self-approval of last push.** The last pusher to the PR branch MUST NOT be eligible to satisfy the approval requirement.
6. **No merge with unresolved conversations.** All review threads must be resolved.
7. **No merge without green CI.** Required checks must pass in **strict** mode (branch must be up-to-date).
8. **No force-pushes to protected branches.** Force pushes are blocked; branch deletions are restricted.
9. **Linear history enforced.** Use squash or rebase merges to keep `main` audit-friendly.

#### B) AI-specific requirements

1. **AI usage disclosure.** PR description MUST state whether AI assisted the change and what portions were generated.
2. **Verification proof.** PR description MUST include:
   * tests run (commands)
   * expected behavior and validation steps
   * any risk area (auth/authz, parsing, deserialization, IAM, networking)
3. **No AI-only approvals.** Automated approvals or "rubber stamp" reviews are prohibited.
4. **Security-sensitive changes require explicit review.** Auth/authz, crypto, deserialization, shell/process execution, and network boundaries require review by an explicitly trusted reviewer.

#### C) Implementation in GitHub (required configuration)

This policy MUST be enforced by GitHub **Rulesets** (preferred) or Branch Protection Rules:

- Require PR before merge
- Minimum **2 approvals**
- Dismiss stale approvals
- Require approval of most recent reviewable push
- Require Code Owner reviews
- Require conversation resolution
- Require status checks (strict)
- Block force pushes, restrict deletions
- Enforce linear history

Operational rule: **No tooling may bypass these gates**, including AI agents. Any bypass capability is treated as an exception and must be recorded in `exception-and-decision-log.md` with risk and sunset date.


27. **At least one qualified reviewer** is required for non-trivial changes.
28. Reviewers MUST verify:

    * correctness
    * meaningful tests
    * no secrets or sensitive data
    * consistency with data, security, and documentation policies
29. **Review intent and design**, not formatting (formatting is automated).
30. **Reject PRs that mix concerns** (feature  refactor  formatting).
31. **All review conversations are resolved** before merge.


Purpose: ensure AI assistants and coding agents cannot weaken review discipline.

**Definitions**
- **CR** — Code Review
- **AI-assisted change** — any code, config, docs, or tests proposed or modified with help from an AI tool (Copilot, Claude, Cursor, etc.)

**Hard rules**
1. **Protected branches MUST enforce PR-only merges.** No direct pushes to `main` or release branches.
2. **CR is mandatory.** Every PR requires human approval (minimum 2 approvals for non-trivial repos; minimum 1 for small personal repos).
3. **No self-approval of last push.** The last committer/pusher MUST NOT be the sole required approver.
4. **CODEOWNERS enforcement.** Sensitive paths MUST require approval from CODEOWNERS.
5. **No merge without green CI.** Required status checks MUST pass; strict mode enabled (branch up-to-date required).
6. **No merge with unresolved threads.** Review conversations MUST be resolved.
7. **Bypass controls are forbidden by default.** Ruleset bypass lists MUST be empty unless explicitly approved and logged.

**Operational enforcement (GitHub repository settings)**
- Use **Rulesets** (preferred) or **Branch protection rules** to enforce:
  - Require PR before merge
  - Required approvals (>= 2 recommended)
  - Dismiss stale approvals
  - Require approval of most recent push
  - Require an approval from someone other than the last pusher
  - Require CODEOWNERS review
  - Require conversation resolution
  - Require status checks (strict)
  - Require linear history
  - Block force pushes
  - Restrict deletions

**PR hygiene for AI-assisted changes**
- PR description MUST include:
  - what was generated/assisted
  - verification performed (tests, manual checks)
  - risk notes (security, auth, data handling)

**Security note**
AI tools do not bypass server-side merge protection. Only credentials with bypass rights (admins/apps explicitly granted bypass) can bypass rules. This is a governance failure and MUST be treated as a security incident.


## 7) Merging strategy

32. **Default merge strategy: squash merge** (clean, linear history).
33. **Rebase  merge** MAY be used when preserving commit structure is valuable.
34. **Merge commits** MAY be used for release branches if they improve traceability.
35. **Never rebase shared branches** once review has started.
36. **Delete branches after merge.**

## 8) History rewriting

37. **Allowed locally before sharing** (interactive rebase).
38. **Forbidden on protected branches.**
39. **Force-push is restricted, audited, and never used on `main`.**

## 9) Versioning and releases

40. **Semantic Versioning (SemVer) is mandatory** unless explicitly exempted.
41. **Git tags:**

    * Annotated tags only.
    * Tags are immutable.
42. **Releases are produced by CI**, never from local machines.
43. **Release artifacts must be traceable** to:

    * Git commit
    * CI run
    * dependency versions
44. **Changelog is maintained**, either manually or generated from commits.
45. **Hotfix releases increment patch versions** and follow the same CI path.

## 10) CI/CD integration

46. **CI runs on every PR**, at minimum:

    * lint / format
    * build
    * tests
47. **CI success is required for merge.**
48. **Fail fast.** Cheap checks first, expensive checks later.
49. **CI environments are reproducible** (clean checkout, pinned toolchains).

## 11) Pre-commit hooks (mandatory)

50. **All repos MUST use `pre-commit`.**
    Rationale: prevent avoidable failures (formatting drift, hidden characters, CRLF, etc.) before CI.

51. **Hooks are part of the repo.**

    * `.pre-commit-config.yaml` is committed at repo root.
    * Running hooks locally is required before pushing.

52. **Hooks must be deterministic** and aligned with CI:

    * CI runs the same checks as hooks (or a strict superset).
    * Hook versions are pinned.

53. **Minimum baseline hooks (required for new repos):**

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: end-of-file-fixer
      - id: trailing-whitespace
      - id: mixed-line-ending
        args: [--fix=lf]
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: detect-private-key
      - id: fix-byte-order-marker
      - id: check-added-large-files
        args: [--maxkb=10240]  # 10 MB default cap unless exempted

  # Optional but strongly recommended for Python repos
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.9
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
```

54. **Installation and usage (developer workstation):**

```bash
# once per machine
python -m pip install --user pre-commit

# once per repo
pre-commit install
pre-commit run --all-files
```

55. **Policy enforcement:**

    * PRs that fail hooks in CI are rejected.
    * Exceptions require an entry in the exception log with rationale and expiry date.

## 12) Issues and planning

56. **Issues track work, not conversations.**
57. **Each PR references an issue** unless truly trivial.
58. **Labels are standardized** (bug, feature, tech-debt, security).
59. **Milestones reflect reality**, not aspiration.
60. **Issues are closed via PRs** with explicit linkage.



## 13) Documentation and discoverability

61. **README.md explains:**

    * purpose of the repository
    * how to build and test
    * contribution workflow
62. **CONTRIBUTING.md** is required for externally visible repos.
63. **ARCHITECTURE.md** (or equivalent) is required for non-trivial systems.



## 14) Security practices

64. **Branch protection rules enabled.**
65. **Dependency and secret scanning enabled.** See [Security Policy](security-policy.md) for detailed security practices.
66. **Least-privilege access enforced.**
67. **Security fixes handled discreetly** until coordinated disclosure.



## 15) Windows dependencies and cross-platform constraints

68. **Windows Git and PATH requirements**

    * Use a Git distribution that provides `git` and standard tooling reliably (Git for Windows is typical).
    * Ensure `git` is available in `PATH` in the shell you use for development.
    * Avoid mixing shells unpredictably (PowerShell vs CMD vs Git Bash) inside the same repo workflow.

69. **Python on Windows**

    * Prefer the official Python install that provides the `py` launcher.
    * Recommended invocations:

      * `py -m pip install pre-commit`
      * `py -m pre_commit run --all-files`
    * If using `pipx`, ensure `pipx` binaries are on `PATH`.

70. **CRLF/LF policy (non-negotiable)**

    * Repo canonical is **LF** via `.gitattributes`.
    * Windows developers MUST configure Git to avoid accidental CRLF churn:

```bash
git config --global core.autocrlf false
git config --global core.eol lf
```

```
* If a repo is already polluted with mixed endings, normalize once:
```

```bash
git rm --cached -r .
git reset --hard
```

```
(Only do this as an intentional, reviewed change in a dedicated PR.)
```

71. **Editors must respect `.gitattributes`**
* Enable “use editorconfig / git attributes” behavior when available.
* If an editor insists on CRLF for `.sh` or `.yml`, that editor config is non-compliant.

72. **Executable bit and scripts**

    * On Windows, Git may not preserve Unix executable bits reliably in all workflows.
    * In repos that rely on executable scripts:

      * Prefer invoking via interpreter explicitly (e.g., `bash scripts/foo.sh`, `python scripts/foo.py`) in documentation and CI.
      * Keep `.sh` as `LF` always (CRLF breaks shebang).

73. **Windows path length**

    * Avoid deep nesting and long filenames.
    * If required, Windows users should enable long paths in OS policy and Git:

```bash
git config --global core.longpaths true
```

74. **Prohibited Windows anti-patterns**

    * Committing files with mixed EOL without a deliberate reason.
    * Using tools that inject zero-width / non-breaking spaces into source files.
    * Editing shell scripts in editors that silently convert LF → CRLF.



## 16) Large repositories and monorepos (if applicable)

75. **Clear ownership per area** via CODEOWNERS.
76. **Avoid cross-cutting PRs** unless necessary.
77. **Tooling must support partial builds/tests** to keep CI fast.



## 17) Explicit anti-patterns (forbidden)

78. Direct commits to `main`.
79. Mega-PRs touching unrelated areas.
80. Commit messages like “fix stuff”, “WIP”.
81. Merging broken builds “to fix later”.
82. Force-pushing shared branches.
83. Using issues as chat logs.



## 18) Gold-standard checklist

84. Protected `main`, PR-only merges, CI required.
85. Standardized commits and merge strategy.
86. Small, focused PRs with clear descriptions.
87. Pre-commit installed and enforced; CI mirrors hooks.
88. Line endings standardized via `.gitattributes` and checked by hooks.
89. Releases are reproducible and traceable to CI artifacts.

## 19) Operational checklists (daily use)

This section exists to reduce mistakes by making the “happy path” explicit.

### 19.1 Create a new repository/project (local-first)

1. **Create repo directory and initialize Git**

   ```bash
   mkdir -p <repo-name> && cd <repo-name>
   git init -b main
   ```

2. **Add baseline repo hygiene (minimum)**

   - `README.md`
   - `.gitignore`
   - `.gitattributes` (LF canonical)
   - `.pre-commit-config.yaml`

3. **Install and run hooks (mandatory)**

   ```bash
   pre-commit install
   pre-commit run --all-files
   ```

4. **Stage and commit (one coherent commit)**

   ```bash
   git add -A
   git commit -m "chore: initialize repo with pre-commit hygiene"
   ```

5. **Create remote and set upstream**

   ```bash
   git remote add origin <REMOTE_URL>
   git push -u origin main
   ```


### 19.2 Modify an existing repository/project (standard workflow)

1. **Sync and verify current branch**

   ```bash
   git status
   git branch --show-current
   git pull --ff-only
   ```

2. **Make changes (small and focused)**

   - Keep changes scoped.
   - Do not mix formatting/refactors with features unless intentional and isolated.

3. **Run hooks before committing (mandatory)**

   ```bash
   pre-commit run --all-files
   ```

4. **Stage intentionally and commit with a Conventional Commits message**

   ```bash
   git add -A
   git commit -m "<type>: <concise change summary>"
   ```

5. **Push**

   ```bash
   git push
   ```

### 19.3 “Push safety” quick checks (must pass before every push)

1. `git status` is clean (no surprises).
2. Hooks passed: `pre-commit run --all-files`.
3. You are pushing the intended branch: `git branch --show-current`.
4. You are not pushing secrets/binaries unintentionally (verify `git diff --stat`).

### 19.4 JetBrains IDE hygiene (PyCharm / IntelliJ / WebStorm) — prevent invisible characters

Purpose: ensure the IDE never introduces hidden diffs (CRLF, BOM, trailing whitespace, missing EOF newline).

#### A) Mandatory IDE settings (do once)

1) **Trailing whitespace + EOF newline**
* Settings → Editor → General → **On Save**
  * **Remove trailing spaces on:** `All`
  * **Keep trailing spaces on caret line:** `OFF`
  * **Remove trailing blank lines at the end of saved files:** `ON`
  * **Ensure every saved file ends with a line break:** `ON`

2) **Encoding (UTF‑8, no BOM)**
* Settings → Editor → **File Encodings**
  * **Global Encoding:** `UTF-8`
  * **Project Encoding:** `UTF-8` (explicit, not “system default”)
  * **Default encoding for properties files:** `UTF-8`
  * **Create UTF-8 files:** `with NO BOM`
  * **Transparent native-to-ascii conversion:** `OFF`

3) **Line endings (LF canonical) + EditorConfig**
* Settings → Editor → **Code Style** → General
  * **Line separator:** `Unix and macOS (\n)`
  * **Detect and use existing file indents for editing:** `OFF`
  * **Enable EditorConfig support:** `ON`

Operational rule:
* If the status bar shows **CRLF**, convert to **LF**.
* If the status bar shows **UTF‑8 with BOM**, convert to **UTF‑8** (no BOM).

#### B) Repo hard lock (required)

Add `.editorconfig` at repo root (committed):

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false
```

Then normalize once:

```bash
pre-commit run --all-files
git add .editorconfig
git commit -m "chore: add editorconfig for canonical whitespace and LF"
```

#### C) Commit / push discipline (Terminal-first)

* Preferred workflow: use the **Terminal tool window inside JetBrains**.
* Commit and push via CLI so hooks run exactly as expected:

```bash
git status
git add -p
git commit -m "type(scope): summary"
git push
```


### 19.5 Git inside IDEs (VS Code + JetBrains) — daily workflow

This section defines the **IDE user workflow** for Git operations.
Policy priority remains **Terminal-first** (IDE UI is acceptable for visibility, but CLI is the source of truth).

#### 19.5.1 Initial configuration (new project OR existing repo)

**A) New project (create locally, then publish remote)**

1) Open the repo folder in your IDE
   * VS Code: File → Open Folder
   * JetBrains: Open

2) Verify the repo is initialized and on `main`:

```bash
git init -b main
git status
git branch --show-current
```

3) Add baseline hygiene files (required by policy):
- `.gitignore`
- `.gitattributes` (LF canonical)
- `.editorconfig`
- `.pre-commit-config.yaml`
- `README.md`

4) Install hooks + validate once:

```bash
pre-commit install
pre-commit run --all-files
```

5) First commit:

```bash
git add -A
git commit -m "chore: initialize repo with hygiene + pre-commit"
```

6) Add remote + push:

```bash
git remote add origin <REMOTE_URL>
git push -u origin main
```

**B) Existing project (already has Git and remote)**

1) Open the repo root folder (must contain `.git/`).

2) Sync safely:

```bash
git status
git pull --ff-only
```

3) Ensure you have hooks installed (mandatory per repo):

```bash
pre-commit install
```

Operational note:
- If hooks are not installed, IDE commits may bypass them. Fix this immediately.

#### 19.5.2 Adding / deleting files and folders (tracking changes)

Git change intent is expressed by **staging**.

**Principles**
- You stage only what you want to commit.
- Unstaged changes are “not yet approved for commit”.

**In IDEs**
- **VS Code**: Source Control view
  - **Stage** (plus icon) = include in next commit
  - **Unstage** (minus icon) = exclude from next commit
  - Deleted files appear as **D** — stage them to confirm deletion
- **JetBrains**: Commit tool window
  - Tick checkbox next to file = stage/include
  - Untick = exclude
  - Deletions show as removed — tick to include

**Terminal reference (source of truth)**
- Stage specific files:

```bash
git add <path>
```

- Stage *everything* (use deliberately):

```bash
git add -A
```

- Stage selectively (recommended):

```bash
git add -p
```

- Unstage:

```bash
git restore --staged <path>
```

- Discard local changes (destructive):

```bash
git restore <path>
git clean -fd   # removes untracked files/dirs
```

#### 19.5.3 `pre-commit` — initial setup and usage

**Initial setup (per machine)**

```bash
python -m pip install --user pre-commit
```

**Enable hooks (per repo, mandatory)**

```bash
pre-commit install
```

**Run hooks**
- Whole repo (before PRs / important pushes):

```bash
pre-commit run --all-files
```

- Only staged files (fast path):

```bash
pre-commit run
```

**If a hook modifies files**
1) Inspect diffs.
2) Stage the changes.
3) Re-run hooks (until clean).

#### 19.5.4 Stage → commit → push (happy path)

1) Check what changed:

```bash
git status
git diff
```

2) Stage intentionally:

```bash
git add -p
```

3) Commit (Conventional Commits):

```bash
git commit -m "feat: <summary>"
```

4) Push:

```bash
git push
```

**IDE workflow**
- It is acceptable to use IDE UI for commit message editing and viewing diffs.
- Still prefer **push via Terminal** to keep behavior identical everywhere.

#### 19.5.5 Pick up a remote branch (checkout / pull)

Typical goal: someone created a branch remotely and you want it locally.

```bash
git fetch --prune
git switch <branch>
```

If branch exists only remotely:

```bash
git fetch --prune
git switch -c <branch> --track origin/<branch>
```

Then sync:

```bash
git pull --ff-only
```

**IDE hints**
- VS Code: Source Control → `…` → Branch → Checkout to…
- JetBrains: Git widget (bottom right) → Remote Branches → Checkout

Operational rule:
- Always `fetch` before switching; avoid stale references.

#### 19.5.6 Merge conflicts (resolution protocol)

Conflicts MUST be resolved **carefully and deliberately**. Never “accept all” blindly.

**A) First response**
1) Stop and inspect:

```bash
git status
git diff
```

2) Identify conflicting files:

```bash
git diff --name-only --diff-filter=U
```

**B) Resolve**
- Preferred: resolve in IDE merge tool.
  - VS Code: “Resolve in Merge Editor”
  - JetBrains: 3-way merge tool

Rules:
- Preserve intent: compare both branches and the base.
- If unsure, abort merge and re-plan.

**C) Mark as resolved**
After editing:

```bash
git add <conflicted-files>
```

**D) Complete merge**
- If you are merging:

```bash
git commit
```

- If you were rebasing:

```bash
git rebase --continue
```

**E) Safety escapes**
- Abort merge:

```bash
git merge --abort
```

- Abort rebase:

```bash
git rebase --abort
```

**F) Final validation**
Run hooks and tests:

```bash
pre-commit run --all-files
# run project tests here
```

Then push.

#### 19.5.7 Professional daily operations (amend, fixup, stash, revert, rebase)

These operations are common in professional teams and prevent messy histories and risky “panic Git”.

##### A) Rebase discipline: clean history without accidental merge commits

**Rules**
- On `main`: keep history linear; use fast-forward only.
- On feature branches: prefer rebase to keep your branch up to date.

**Commands**
- Update local refs first:

```bash
git fetch --prune
```

- On `main`:

```bash
git switch main
git pull --ff-only
```

- On feature branch (recommended):

```bash
git switch <feature-branch>
git pull --rebase
```

If conflicts happen during rebase:

```bash
git status
# fix conflicts
git add <files>
git rebase --continue
# or abort
git rebase --abort
```

Operational rule:
- Avoid IDE “Pull” actions that default to merge commits unless they are explicitly configured for rebase/ff-only.

##### B) Amend + fixup: keep commits clean

**Amend (edit last commit)**
Use this when you forgot a file, need to tweak message, or fix small issues *before pushing*.

```bash
git add -A
git commit --amend
```

**Fixup commits (best practice for PR polish)**
When you want to record progress but later auto-squash into a prior commit:

```bash
git commit --fixup <commit-hash>
git rebase -i --autosquash origin/main
```

IDE mapping:
- JetBrains has “Amend” and interactive rebase tooling built in.
- VS Code supports amend and interactive rebase via Source Control / Command Palette.

##### C) Stash: safe context switching

Use stash when you must switch branches but your working tree is not ready to commit.

```bash
git stash push -u -m "wip: <short note>"
git switch <other-branch>
```

Restore:

```bash
git stash list
git stash pop    # applies and drops
# or
git stash apply  # applies and keeps
```

If stash creates conflicts, resolve like normal conflicts, then stage + continue work.

##### D) Rename / move discipline

Preferred behavior:
- Perform file moves/renames **inside the IDE** to keep imports/references consistent.
- Confirm Git sees it as a rename (not delete + add):

```bash
git status
git diff --name-status
```

Then stage:

```bash
git add -A
```

##### E) Safe undo: revert (shared history safe)

**Never rewrite history that has already been pushed and shared**, unless you *know* it is safe.

Preferred safe undo on shared branches:

```bash
git revert <commit-hash>
git push
```

Avoid on pushed branches:
- `git reset --hard`
- force pushing (`--force`) unless explicitly required and coordinated

##### F) Commit signing (optional, but professional-grade)

If your team expects “Verified” commits, configure signing:
- GPG signing OR SSH commit signing (GitHub-supported)

Policy guidance:
- Enable if required by target employers/teams.
- If not required, don’t block progress; it can be added later.

##### G) PR hygiene (IDE or CLI)

Before opening or updating a PR:
1) Sync your branch:

```bash
git fetch --prune
git pull --rebase
```

2) Validate quality gates:

```bash
pre-commit run --all-files
# run project tests here
```

3) Keep PRs small and coherent; avoid mixing unrelated changes.


---

**Note:** Security policies have been moved to a separate document. See [Security Policy](security-policy.md) for:
- Secrets handling and storage
- Identity and access control (IAM)
- OAuth 2.0 and authentication
- Dependency and supply-chain security
- Cloud security baseline
- Data security (CV/ML context)
- AI coding hazards
- Code injection defenses
- API security best practices
- ML/CV engineering security best practices
- Incident response

---

# Versioning and release policy

<a id="versioning-and-release-policy"></a>


**Status:** Authoritative
**Last updated:** 2026-01-16

This policy defines how versions are assigned, how releases are produced, and how artifacts are published.

## 1) Core principle

Releases must be reproducible from:
- a Git commit
- a version tag
- a build pipeline that produces signed/traceable artifacts

### Acronyms
- **SemVer** = Semantic Versioning
- **CI** = Continuous Integration
- **CD** = Continuous Delivery

## 2) Versioning scheme

Default: **SemVer** (`MAJOR.MINOR.PATCH`)

- MAJOR: incompatible changes
- MINOR: backward-compatible features
- PATCH: backward-compatible fixes

Pre-releases MAY use:
- `-alpha.N`, `-beta.N`, `-rc.N`

## 3) Tagging policy

- Every release MUST have an annotated tag: `vMAJOR.MINOR.PATCH`
- Tags MUST point to a commit on the protected release path (`main` or release branch).

## 4) Changelog policy

- Maintain `CHANGELOG.md` using “Keep a Changelog” structure:
  - Added / Changed / Deprecated / Removed / Fixed / Security
- Every release MUST update the changelog.

## 5) Release process (standard)

A release MUST:
1. Ensure CI is green on the target commit
2. Update `CHANGELOG.md`
3. Bump version (single source of truth: `pyproject.toml` or equivalent)
4. Tag the release
5. Build artifacts in CI
6. Publish artifacts (package registry and/or object storage)
7. Record release metadata (artifact hashes, environment) in release notes

## 6) Artifact policy

Artifacts MUST be:
- content-addressed or integrity-checked (hash recorded)
- traceable to source commit and dataset snapshots where relevant

Model artifacts:
- MUST NOT be “latest”; they MUST be versioned and immutable once referenced.
- Store in object storage with hashes; store metadata in SQL or a registry.

## 7) Compatibility policy

Breaking changes MUST:
- be called out explicitly in the changelog
- include migration notes
- be versioned with MAJOR bump

## 8) Hotfix policy

Hotfix releases:
- MUST follow the same CI and tagging rules
- SHOULD be minimal diffs
