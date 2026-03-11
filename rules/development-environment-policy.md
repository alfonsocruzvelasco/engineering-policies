# Development Environment Policy

**Status:** Authoritative
**Last updated:** 2026-03-11

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
- `policies/production-policy.md`
- `policies/ai-workflow-policy.md (Part 2: Prompt Engineering)` (MCP)

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
  - [Storage Layer: `/workspace` (RAID backing store)](#storage-layer-workspace-raid-backing-store)
    - [Non-negotiable rules](#non-negotiable-rules)
    - [Recommended symlink mapping (examples)](#recommended-symlink-mapping-examples)
    - [Forbidden examples (do not do this)](#forbidden-examples-do-not-do-this)
  - [~/dev Workspace Organization](#dev-workspace-organization)
    - [Canonical layout](#canonical-layout)
    - [Non-negotiable rules](#non-negotiable-rules-1)
  - [~/learning-repos Directory](#learning-repos-directory)
    - [Allowed contents](#allowed-contents)
    - [Default rule](#default-rule)
    - [Temporary exception: training repos](#temporary-exception-training-repos)
  - [Repository Isolation Rules](#repository-isolation-rules)
    - [What IS allowed inside repos](#what-is-allowed-inside-repos)
    - [What is NEVER allowed inside repos](#what-is-never-allowed-inside-repos)
  - [Artifact Boundaries](#artifact-boundaries)
    - [Infrastructure Services Rule](#infrastructure-services-rule)
    - [Spec-Driven Development Artifacts](#spec-driven-development-artifacts)
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

> Note: Any canonical `~/...` directory below may be implemented as a symlink to `/workspace/...` for RAID-backed storage.
> This does not change the directory’s meaning; it only changes where the bytes live.

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
| `~/learning-repos`   | Non-authoritative learning & scratch                 |
| `~/Templates`  | Templates                                            |
| `~/tmp_backup` | Temporary safety net                                 |
| `~/vpn`        | VPN configs                                          |


---

## Storage Layer: `/workspace` (RAID backing store)

This policy defines the **canonical meaning** of directories under `$HOME` (e.g., `~/dev`, `~/learning-repos`, `~/ai`).

Some canonical directories **may be implemented as symlinks** that point into `/workspace` to leverage RAID-backed storage.
This is a **physical storage detail only** and must **never introduce a second taxonomy**.

### Non-negotiable rules

1) **Semantics live in `$HOME`**
   The meaning of a path is determined by its canonical `$HOME` location (e.g., “models live in `~/dev/models/`”), even if it is symlinked to `/workspace`.

2) **No parallel `/workspace/*` taxonomy**
   Do **not** create or use directory meanings like `/workspace/dev`, `/workspace/learning-repos`, `/workspace/ml`, `/workspace/devops`, etc.
   If you need RAID backing for a canonical `$HOME` directory, do it by **symlinking the canonical directory** to a target under `/workspace`.

3) **Only symlink targets are allowed in `/workspace`**
   `/workspace` may contain only:
   - symlink targets for canonical `$HOME` directories (examples below)
   - minimal storage metadata if you explicitly want it there (e.g., a single architecture note)

4) **All workflows operate via canonical `$HOME` paths**
   Day-to-day commands, scripts, and mental model must use `~/dev/...`, `~/datasets/...`, `~/docker/...`, `~/ai/...`, etc.
   `/workspace` paths are treated as implementation detail.

### Recommended symlink mapping (examples)

Allowed mappings:

```text
~/ai       -> /workspace/ai          # notes/research (no tooling state)
~/datasets -> /workspace/datasets    # immutable datasets
~/docker   -> /workspace/containers  # docker/compose stacks
```

Optional (only if you decide to keep heavy artifacts on RAID):

```text
~/dev/models  -> /workspace/dev-models
~/dev/data    -> /workspace/dev-data
```

### Forbidden examples (do not do this)

```text
/workspace/dev/...
/workspace/learning-repos/...
/workspace/ml/...
/workspace/devops/...
```

These create duplicated semantics (“which copy is real?”) and violate:

> Each directory has one meaning only.

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

## ~/learning-repos Directory

<a id="learning-directory"></a>

`~/learning-repos` is **non-authoritative by default**.

### Allowed contents

* throwaway exercises
* algorithm practice
* exploratory scripts
* temporary notes

### Default rule

* **No `.git/` directories** in `~/learning-repos`
  unless explicitly documented as a temporary exception.

### Temporary exception: training repos

A limited number of training repos may exist under `~/learning-repos` strictly for Git/IDE practice.

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

### Infrastructure Services Rule

**All infrastructure services must run in containers, not as host-level installations.** This includes MLflow servers, orchestration systems (Airflow/Prefect), monitoring stacks (Prometheus/Grafana), message brokers (Kafka/Redpanda), databases, and model serving infrastructure. The host OS must remain a clean execution substrate. See `mlops-policy.md` Section 1 (Core Principles, principle #9) for full details.

### Spec-Driven Development Artifacts

```text
~/dev/repos/<project>/
├── .specify/              # Spec Kit artifacts (if using Spec Kit)
│   ├── memory/
│   │   └── constitution.md
│   ├── specs/
│   │   └── 001-feature/
│   │       ├── spec.md
│   │       ├── plan.md
│   │       └── tasks.md
│   └── templates/
│
├── openspec/              # OpenSpec artifacts (if using OpenSpec)
│   ├── specs/             # Current truth (what IS built)
│   ├── changes/           # Proposals (what SHOULD change)
│   └── changes/archive/   # History
```

**Rules:**
- Spec artifacts ARE committed to Git
- Constitution is versioned and binding
- Changes are atomic (one PR per change)
- Archive preserves decision history

**See:** `ai-workflow-policy.md (Part 4: Spec-Driven Development)` for full workflow

---

## Agent Context Governance (AGENTS.md Required)

Every repository that uses an AI coding agent — Claude Code, Codex, Goose, OpenHands, or any equivalent — **MUST include a root-level `AGENTS.md`**.

**Evidence basis:** Lulla et al. (ICSE JAWs 2026, arXiv:2601.20404) measured a **29% median runtime reduction** and **17% median output token reduction** across 124 PRs when AGENTS.md was present. This is not optional guidance — it is a measurable engineering constraint.

**Required content (minimum viable):**

| Section | Purpose |
|---|---|
| Project architecture overview | Component map, high-level structure |
| Directory map | Key folders, what lives where |
| Build & test commands | Exact commands the agent must use |
| Coding standards | Language-specific constraints, linting rules |
| Dependency management | Package manager, lock file requirements |
| Security constraints | Forbidden actions, secrets policy, network rules |
| Prohibited patterns | What the agent MUST NOT do |
| Deployment assumptions | Container, bare metal, GPU, CI runner |

**Size constraint:** <150 lines for production repos. Every line must be non-discoverable — if the agent can grep it from the codebase, delete it. See `ai-workflow-policy.md` "Shared Team Knowledge" for the research basis (Gloaguen et al.).

**Template:** `templates/agents-md-template.md`

**Enforcement:** Repositories without a root-level `AGENTS.md` are classified as **agent-unprepared**. Agent work in agent-unprepared repos is a non-professional workflow — higher cost, higher error rate, no constraint enforcement.

---

## Final Mental Model

Memorize:

* **Repos** → `~/dev/repos`
* **Envs + tooling state** → `~/dev`
* **Learning scratch** → `~/learning-repos`
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
