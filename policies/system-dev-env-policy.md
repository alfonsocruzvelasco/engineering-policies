# Development Environment Policy

**Status:** Authoritative
**Last updated:** 2026-01-16

---

## Purpose

This policy enforces:

1) **How files are organized on this machine**
   (so the OS + home directory stay clean and repositories stay reproducible)

2) **Strict isolation** between:
   - system state
   - development environments
   - datasets and heavy artifacts
   - Git repositories (what gets pushed)

3) **Naming conventions** (global, consistent, machine-wide)

This file governs **where and how things live and run**.

It explicitly does **NOT** govern:
- IDE setup instructions
- IDE pre-flight checklists
- formatter/linter configuration
- build tool policies
- testing strategy
- MCP / AI tooling servers

Those are governed by:
- `policies/data-and-non-ai-tooling-setup-policy.md`
- `policies/prompts-policy.md` (MCP)

---

## Table of Contents

- [Development Environment Policy](#development-environment-policy)
  - [Purpose](#purpose)
  - [Table of Contents](#table-of-contents)
  - [Goals \& Principles](#goals--principles)
    - [Primary goals](#primary-goals)
    - [Explicit non-goals](#explicit-non-goals)
    - [Principle: isolate what gets pushed](#principle-isolate-what-gets-pushed)
  - [Global Naming Conventions](#global-naming-conventions)
    - [Non-negotiable across files and directories](#non-negotiable-across-files-and-directories)
    - [Dates](#dates)
    - [Underscores (`_`) rule](#underscores-_-rule)
  - [Top-Level Directory Structure](#top-level-directory-structure)
  - [~/dev Workspace Organization](#dev-workspace-organization)
    - [Canonical layout](#canonical-layout)
    - [Non-negotiable rules](#non-negotiable-rules)
  - [~/learning Directory](#learning-directory)
    - [Allowed contents](#allowed-contents)
    - [Default rule](#default-rule)
    - [Temporary exception: training repos](#temporary-exception-training-repos)
  - [Repository Isolation Rules](#repository-isolation-rules)
    - [What IS allowed inside repos](#what-is-allowed-inside-repos)
    - [What is NEVER allowed inside repos](#what-is-never-allowed-inside-repos)
  - [Artifact Boundaries](#artifact-boundaries)
  - [Final Mental Model](#final-mental-model)
  - [Enforcement](#enforcement)

---

## Goals & Principles

### Primary goals

- Keep `$HOME` **clean, predictable, and auditable**
- Enforce **one source of truth** for Git repositories
- Eliminate duplicated repos, IDE pollution, and hidden state
- Separate **authoritative work** from **learning and scratch**
- Make the machine maintainable by “future you”

### Explicit non-goals

This policy does **not**:
- reorganize tool-managed dotdirs (`~/.config`, `~/.cache`)
- optimize disk usage
- replace backups

It enforces **clarity of intent**, not micromanagement.

### Principle: isolate what gets pushed

Everything that is pushed to GitHub must live inside:

> `~/dev/repos/...`

Everything else must live **outside** repos.

---

## Global Naming Conventions

### Non-negotiable across files and directories

- **lowercase only**
- **hyphens (`-`) as separators**
- **no spaces**
- **no accents**
- boring and explicit names

Examples:
```text
ml-pipeline-v1
computer-vision
docker-compose.yaml
````

### Dates

Always ISO format:

```text
YYYY-MM-DD
```

Examples:

```text
backup-2025-12-14.log
opt-2025-04-13/
```

### Underscores (`_`) rule

Allowed **only** when required by tools or standards:

```text
pyproject.toml
XDG_CACHE_HOME
__init__.py
```

---

## Top-Level Directory Structure

Each directory has **one meaning only**.

| Directory      | Purpose                                              |
| -------------- | ---------------------------------------------------- |
| `~/admin`      | Personal admin, legal, paperwork                     |
| `~/ai`         | AI/ML notes, research (no tooling state)             |
| `~/apps`       | Manually installed user apps                         |
| `~/archive`    | Cold storage                                         |
| `~/backup`     | Backup scripts, manifests, logs                      |
| `~/bin`        | User scripts on `$PATH`                              |
| `~/datasets`   | Immutable datasets                                   |
| `~/test-data`  | Large disposable local test inputs (never committed) |
| `~/dev`        | Development tooling, environments, and repositories  |
| `~/docker`     | Docker / Compose stacks                              |
| `~/Documents`  | Human documents                                      |
| `~/Downloads`  | Ephemeral downloads                                  |
| `~/go`         | Go workspace (standard layout)                       |
| `~/learning`   | Non-authoritative learning & scratch                 |
| `~/Templates`  | Templates                                            |
| `~/tmp_backup` | Temporary safety net                                 |
| `~/vpn`        | VPN configs                                          |

---

## ~/dev Workspace Organization

<a id="dev-workspace-organization"></a>

`~/dev` contains **everything that makes you a developer**, and **nothing else**.

> Nothing under `~/dev` is considered a final deliverable output.

### Canonical layout

```text
~/dev/
├── repos/                 # SINGLE source of truth for all git repos
│   └── github.com/
│       ├── alfonsocruzvelasco/   # your repos (write access)
│       └── upstream/             # third-party repos (read-only)
├── build/                 # build output (never committed)
├── data/                  # local datasets (never committed)
├── models/                # model binaries (never committed)
├── venvs/                 # Python virtual environments
├── devruns/               # executions / experiments (not repos)
└── ide/                   # IDE runtime state (never committed)
    ├── jetbrains/
    ├── vscode/
    └── cursor/
```

### Non-negotiable rules

1. **All Git repositories live in `~/dev/repos`**
2. **No repository lives anywhere else**
3. **No IDE creates its own copy of a repo**
4. **No build output inside repos**
5. **No datasets or model binaries in Git**
6. **IDE metadata is always ignored**
7. **Tool runtime state lives in `~/dev/ide/`**

This eliminates:

* duplicate clones
* diverging branches
* mismatched environments
* “which copy is real?” disasters

---

## ~/learning Directory

<a id="learning-directory"></a>

`~/learning` is **non-authoritative by default**.

### Allowed contents

* throwaway exercises
* algorithm practice
* exploratory scripts
* temporary notes

### Default rule

* **No `.git/` directories** in `~/learning`
  unless explicitly documented as a temporary exception.

### Temporary exception: training repos

A limited number of training repos may exist under `~/learning` strictly for Git/IDE practice.

If any repo becomes “real work”, it must be moved to:

> `~/dev/repos/github.com/...`

---

## Repository Isolation Rules

This is the core isolation model.

### What IS allowed inside repos

* tests
* small fixtures
* config files
* README / docs
* scripts intended to be committed

### What is NEVER allowed inside repos

* `node_modules/`
* build output (`dist/`, `build/`, `target/`, CMake build dirs)
* large datasets
* model checkpoints
* local run artifacts
* IDE runtime state
* virtual environments

These must live in:

* `~/dev/build/`
* `~/datasets/` or `~/dev/data/`
* `~/dev/models/`
* `~/dev/devruns/`
* `~/dev/venvs/`
* `~/dev/ide/`

---

## Artifact Boundaries

To protect repositories from pollution:

* **Datasets (immutable)** → `~/datasets/`
* **Disposable local test data** → `~/test-data/<project>/`
* **Model binaries** → `~/dev/models/<project>/`
* **Run outputs / experiments** → `~/dev/devruns/<project>/`
* **Build outputs** → `~/dev/build/<repo>/`

Repos contain only:

* references (paths, manifest files, scripts)
* never the heavy payload

---

## Final Mental Model

Memorize:

* **Repos** → `~/dev/repos`
* **Envs + tooling state** → `~/dev`
* **Learning scratch** → `~/learning`
* **Build output** → `~/dev/build`
* **Runs** → `~/dev/devruns`
* **Models** → `~/dev/models`
* **Datasets** → `~/datasets`

Shortcut:

> If it would break reproducibility or bloat Git, it does not belong in repos.

---

## Enforcement

This policy is binding.

If behavior diverges from this policy:

* update the policy first (if reality truly changed),
* otherwise fix behavior immediately.

No silent exceptions.
