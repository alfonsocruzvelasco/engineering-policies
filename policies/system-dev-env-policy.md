# Unified Development Environment Policy

**Status:** Authoritative
**Last updated:** 2026-01-07
**Supersedes:** All previous standalone IDE or workspace documents

---

## Engineering Tooling & Workflow Policies

This system environment policy is complemented by the authoritative policy set in:

- `~/admin/policies/README.md`

This document governs *how code is written, built, reviewed, and shipped*.
The system environment policy governs *where and how those tools execute*.

Canonical location for all policies:
- `~/admin/policies/`

---

## Table of Contents

1. [Goals & Principles](#goals--principles)
2. [Global Naming Conventions](#global-naming-conventions)
3. [Top-Level Directory Structure](#top-level-directory-structure)
4. [~/dev Workspace Organization](#dev-workspace-organization)
5. [~/learning Directory](#learning-directory)
6. [Language & Framework Standards](#language--framework-standards)
7. [IDE Roles & Discipline](#ide-roles--discipline)
8. [IDE Setup & Configuration](#ide-setup--configuration)
9. [Universal Pre-Flight Checks](#universal-pre-flight-checks)
10. [Naming Policy (Cross-Language)](#naming-policy-cross-language)
11. [Tooling & Build Policy](#tooling--build-policy)
12. [Python Formatter & Linter Standard](#python-formatter--linter-standard)
13. [IDE Pre-Flight Checklists](#ide-pre-flight-checklists)
14. [Cleanup Rules](#cleanup-rules)
15. [Final Mental Model](#final-mental-model)
16. [Testing Strategy & Policy](#16-testing-strategy--policy)
17. [MCP Policies](#mcp-policies)

---

## Goals & Principles

### Primary Goals

* Keep `$HOME` **clean, predictable, and auditable**
* Enforce **one source of truth** for source code
* Eliminate duplicated repos, IDE pollution, and hidden state
* Separate **authoritative work** from **learning and scratch**
* Make the system maintainable by *future you*

### Explicit Non-Goals

This policy does **not**:

* Reorganize tool-managed dotdirs (`.config`, `.cache`)
* Optimize disk usage
* Replace backups

It enforces **clarity of intent**, not micromanagement.

### AI Integration Discipline (New Rule)

AI tooling must match the platform and have first-class support.  
Unsupported, experimental, or reverse-engineered integrations are not allowed.

**Implications**

* No unofficial desktop builds, wrappers, or Wine/AppImage hacks
* No community “bridges” that depend on unsupported clients
* Tools must have at least one of:
  - official Linux support, or
  - stable, documented API/CLI

**Specific consequence (documented):**

Claude Desktop is not installed on this system and currently has **no official Linux build**.  
Therefore:

> No planning or automation workflows may depend on Claude Desktop or MCP-based plugins until official Linux support exists.

If automation is required, prefer tools with real APIs (Todoist, ClickUp, Notion, Linear, etc.) and document the decision before implementation.

This rule exists to prevent wasted time, brittle setups, and tool-driven chaos — execution discipline comes first.

---

## Global Naming Conventions

**Non-Negotiable Across All Files and Directories**

### Files and Directories

* **lowercase only**
* **hyphens (`-`) as separators**
* **no spaces, no accents**
* **boring and explicit**

Examples:
```
ml-pipeline-v1
computer-vision
docker-compose.yaml
```

### Dates

Always use ISO format:
```
YYYY-MM-DD
```

Examples:
```
backup-2025-12-14.log
opt-2025-04-13/
```

### Underscores (`_`)

Allowed **only** when required by tools or standards:
```
pyproject.toml
XDG_CACHE_HOME
__init__.py
```

---

## Top-Level Directory Structure

Each directory has **one meaning only**.

| Directory      | Purpose                                                           |
| -------------- | ----------------------------------------------------------------- |
| `~/admin`      | Personal admin, legal, paperwork                                  |
| `~/ai`         | AI / ML notes, notebooks, research (NO tools)                     |
| `~/apps`       | Manually installed user apps                                      |
| `~/archive`    | Cold storage                                                      |
| `~/backup`     | Backup scripts, manifests, logs                                   |
| `~/bin`        | User scripts on `$PATH`                                           |
| `~/datasets`   | Immutable datasets                                                |
| `~/test-data`  | Larger or disposable local test inputs (never committed to repos) |
| `~/dev`        | **Development tooling, environments, and ALL repos**              |
| `~/docker`     | Docker / Compose stacks                                           |
| `~/Documents`  | Human documents                                                   |
| `~/Downloads`  | Ephemeral downloads                                               |
| `~/go`         | Go workspace (standard layout)                                    |
| `~/learning`   | **Non-authoritative learning & scratch (NO repos)**               |
| `~/Templates`  | Templates                                                         |
| `~/tmp_backup` | Temporary safety net                                              |
| `~/vpn`        | VPN configs                                                       |

---

## ~/dev Workspace Organization

`~/dev` contains **everything that makes you a developer**, and **nothing else**.

> Nothing under `~/dev` is considered final deliverable output.

### Canonical Layout

```
~/dev/
├── repos/                 # SINGLE source of truth for all git repos
│   └── github.com/
│       ├── alfonsocruzvelasco/   # your repos (write access)
│       └── upstream/             # third-party repos (read-only)
├── build/                 # all build output (never committed)
├── data/                  # datasets (never committed)
├── models/                # model binaries (never committed)
├── venvs/                 # Python virtual environments
├── devruns/               # executions / experiments (not repos)
└── ide/                   # IDE runtime state
    ├── jetbrains/
    │   ├── clion/
    │   ├── pycharm/
    │   ├── idea/
    │   └── datagrip/
    ├── vscode/
    └── cursor/
```

### Non-Negotiable Rules

1. **All Git repositories live in `~/dev/repos`**
2. **No repository lives anywhere else**
3. **No IDE creates its own copy of a repo**
4. **No build output inside repos**
5. **No datasets or model binaries in Git**
6. **IDE metadata is always ignored**
7. **AI usage is restricted by IDE role**

This single rule set eliminates:

* duplicate clones
* diverging branches
* mismatched environments
* "which copy is real?" disasters

### 🧪 Temporary Exception — Git Training Repos in `~/learning`

For a limited training period, **a small number of Git repositories is allowed under `~/learning`** strictly for practicing Git and IDE workflows.

**Rules for training repos:**

* They must be explicitly non-authoritative (practice only).
* They must have a remote on GitHub.
* Their location and purpose must be documented here.
* Once they become “real work”, they **must be moved** to `~/dev/repos/...`.

Current allowed training repos:

1. Java Git practice  
   * Local: `/home/alfonso/learning/java/data-structures-and-algorithms-in-java-6thed-source-code`  
   * Remote: `https://github.com/alfonsocruzvelasco/data-structures-and-algorithms-in-java-6thed-source-code`

2. Python Git practice  
   * Local: `/home/alfonso/learning/python/ml-structures-and-algorithms`  
   * Remote: `https://github.com/alfonsocruzvelasco/ml-structures-and-algorithms`

No other Git repos are allowed under `~/learning` unless they are explicitly added to this list.

---

## ~/learning Directory

`~/learning` is **non-authoritative by default**.

### Primary purpose

It may contain:

* throwaway exercises
* small scripts
* class material drafts
* algorithm practice
* exploratory code you may delete tomorrow

### Default rules

* **No `.git/` directories** (no repositories)  
* **No expectation of long-term maintenance**

If you care about something and it becomes “real work”, it must move to:

> `~/dev/repos/...` (authoritative code)  
> plus optional data / build dirs as defined elsewhere in this policy.

### Exception — Git training repos (documented)

The only allowed `.git/` directories under `~/learning` are **explicitly documented** under “Temporary Exception — Git Training Repos in `~/learning`”.

These repos are:

* for Git + IDE practice only,
* not considered authoritative,
* candidates to be **migrated later** to `~/dev/repos/github.com/alfonsocruzvelasco/...` once stabilized.

---

## Language & Framework Standards

This section defines **tooling, build, and environment discipline** per language/framework.
It is designed to prevent drift, hidden state, IDE coupling, and "works on my machine" failures.

### C

**Primary IDE:** CLion

**Build system:** CMake

**Build output:** always out-of-tree:
```
~/dev/build/<repo-name>/
```

**Rules**

* Repos live only in `~/dev/repos/...`
* Never generate build artifacts in the repo working tree
* Prefer explicit compiler toolchains (system `gcc`/`clang`) and capture them in `CMakePresets.json`
* Use `compile_commands.json` for tooling/analysis if needed; keep it generated in the build directory

**Tooling enforcement (clang-format + clang-tidy)**

CLion ships with built-in **clang-tidy** and **clang-format**. No extra plugins are installed.

**Repo-authoritative config (mandatory)**

Each C/C++ repository must include at the repo root:

- `.clang-tidy`   (lint/static analysis policy)
- `.clang-format` (formatting policy)

**Enforcement rules**

- CLion must be configured to **prefer `.clang-tidy` over IDE settings**
- Do not configure checks in CLion UI. The repo is the source of truth
- Formatting must be applied via `.clang-format` (never by ad-hoc IDE code style tweaks)
- CI (if present) must run clang-tidy and clang-format checks using the repo files

#### C standard baseline (authoritative)

All C work in this environment follows a single standard:

> Default C standard: **C17**

**Requirements:**

* New C projects must pass `-std=c17` to the compiler (via CMake or equivalent)
* Older C90/C99 code may be read and maintained, but new code and refactors should target C17 unless there is a documented constraint
* Treat warnings as errors where feasible: `-Wall -Wextra -Werror` for your own code

---

### C++

Same IDE/build rules as C, plus language-specific policy.

* **Language standard (non-negotiable):**
All new C++ projects must set:
```
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
```
* Code must be written in **modern C++17 style** (RAII, smart pointers, move semantics, `std::optional`, `std::variant`, range-based for, etc.)
* Treat warnings as errors for your code where feasible (`-Wall -Wextra -Werror` or equivalent)
* Prefer deterministic dependencies (vendored or pinned) over "whatever is on the OS today"
* Naming conventions are enforced via clang-tidy (`readability-identifier-naming`) through the repo's `.clang-tidy`
* Legacy C++11/14 code may be read and maintained, but new modules, libraries, and refactors must target C++17 unless explicitly documented otherwise

### OpenCV + CUDA

**OpenCV (Open Source Computer Vision Library)** is a C++-centric computer vision toolkit.
**CUDA (Compute Unified Device Architecture)** is NVIDIA's GPU compute platform.

**Canonical approach**

* Keep OpenCV and CUDA dependencies **out of the repo**
* Prefer containerized builds/runs when GPU dependencies are involved
* Never store model binaries, large assets, or build products in Git

**Where things go**

* Build outputs: `~/dev/build/<repo-name>/`
* Datasets (immutable): `~/datasets/`
* Small disposable samples: `~/test-data/`
* Model artifacts: `~/dev/models/`

**CUDA toolkit and driver policy**

* GPU: NVIDIA RTX 4070 (Ada Lovelace, compute capability 8.9 — fully supported by CUDA 12.x and 13.x)
* Default CUDA toolkit line: **CUDA 12.x**, using the latest stable minor that matches the installed NVIDIA driver or container image
* CUDA 13.x is allowed only when:

  * the driver branch supports it, and
  * the toolchain (PyTorch, nvidia/cuda images) has explicit support

**Rules**

* Prefer NVIDIA’s long-term support (LTS) driver branches where available; match them with CUDA 12.x or 13.x as documented by NVIDIA
* For Python workloads, prefer prebuilt PyTorch wheels or official Docker images that bundle CUDA (no manual Toolkit installation into the OS unless there is a clear reason)
* Pin versions in:

  * container image tags (`nvidia/cuda:12.6.0-cudnn-runtime-ubuntuXX.YY` or similar)
  * environment files (`requirements.txt`, `pyproject.toml` with specific `torch` builds)
* Make GPU visibility explicit (document required driver/runtime, device selection, `CUDA_VISIBLE_DEVICES`)
* If OpenCV must be compiled:

  * treat it as a separate pinned build artifact
  * document the exact version and CMake flags
  * do not treat “whatever is on the system” as canonical

---

### Python 3 + PyTorch

**Python venv (virtual environment)** discipline is mandatory.

**PyTorch** is the primary deep learning framework.

**Virtual environments (venvs)**

* Every project has exactly one venv in:

  ```text
  ~/dev/venvs/<project-name>/
  ```

* The venv is created manually and bound explicitly in PyCharm
* Tools and dependencies are installed only inside that venv

**Packaging and tooling**

* Use `pyproject.toml` as the single configuration surface
* Formatter: `black`
* Linter/imports: `ruff`
* Do not "fix" formatting by changing editor settings; fix the interpreter binding

**Data and artifacts**

* Datasets: `~/datasets/` (immutable)
* Run outputs/experiments: `~/dev/devruns/<project-name>/`
* Model binaries: `~/dev/models/<project-name>/`

**Virtual environment operations**

Creation:

```bash
python3 -m venv ~/dev/venvs/<project-name>
```

Activation:

```bash
source ~/dev/venvs/<project-name>/bin/activate
```

Verification:

```bash
python -c "import sys; print(sys.executable)"
```

Expected:

```text
/home/<user>/dev/venvs/<project-name>/bin/python
```

Deletion:

```bash
rm -rf ~/dev/venvs/<project-name>
```

**Important:** Selecting a Python interpreter in VS Code or Cursor **does NOT activate it in the terminal**. The integrated terminal keeps using **system Python** until the venv is activated manually.

**Required habit (always):**
```bash
source ~/dev/venvs/<project>/bin/activate
```

Warning: system Python must never be used for project execution.

### Python version management (pyenv + venvs)

System Python belongs to Fedora.  
Development Python is user-scoped and isolated.
System Python is never modified.

---

#### Python runtimes (pyenv)

Python language versions are managed by **pyenv**.
They live here:

```text
~/.pyenv/versions/

```

This directory is tool-owned and NOT reorganized or moved.

No `sudo` installs, no overrides of system Python.

---

#### Virtual environments (per project)

Project environments live here:

```text
~/dev/venvs/<project-name>/
```

Create using a pyenv Python:

```bash
pyenv shell 3.11.9
python -m venv ~/dev/venvs/<project-name>
```

Activate:

```bash
source ~/dev/venvs/<project-name>/bin/activate
pip install --upgrade pip
deactivate
```

---

#### Approved Python versions

At most two active versions:

* 3.11.x — stable baseline
* 3.13.x — forward-looking

Projects pin the runtime:

```
pyenv local 3.11.9
```

This writes `.python-version` to the repo.

---

#### Non-negotiable rules

1. Do not touch system Python.
2. pyenv owns `~/.pyenv`.
3. One venv per project under `~/dev/venvs/`.
4. Never put venvs inside repositories.
5. Serious repos include `.python-version`.

#### PyTorch version baseline

* Default line: **PyTorch 2.x**, using the latest stable 2.x release suitable for the project and GPU
* The exact `torch` (and `torchvision`, `torchaudio`) versions must be pinned in `pyproject.toml` or `requirements.txt`
* Only one major line per project (no mixing PyTorch 1.x and 2.x)
* Choose the CUDA-enabled wheel matching the chosen CUDA line (for example, `cu118`, `cu121`, `cu126`) according to the official PyTorch install matrix

### Python Scientific Stack & Jupyter (NumPy / SciPy / pandas / Matplotlib)

**Scope:** interactive / numerical work with NumPy, SciPy, pandas, Matplotlib and Jupyter notebooks.

#### Global rules

* Jupyter kernels **always** come from a project venv under:
  ```text
  ~/dev/venvs/<project-name>/

* System Python is **never** used for Jupyter.
* Notebooks are **exploratory**, not the main source of truth:

  * Authoritative code lives in `.py` modules inside the repo.
  * Notebooks may call into that code, not replace it.

#### Standard scientific stack per project

Inside the project venv:

```bash
source ~/dev/venvs/<project-name>/bin/activate
python -m pip install --upgrade pip
python -m pip install \
  numpy \
  scipy \
  pandas \
  matplotlib \
  jupyterlab \
  ipykernel
```

All of this is **per-project**, never global.

#### Jupyter kernel registration (CLI)

Each project venv that needs notebooks gets its own kernel:

```bash
source ~/dev/venvs/<project-name>/bin/activate
python -m ipykernel install --user --name "<project-name>" --display-name "Python 3.11 (<project-name>)"
```

**Rules:**

* Kernel name = venv name = `<project-name>`.
* If the project is deleted, its kernel should be removed:

  ```bash
  jupyter kernelspec uninstall "<project-name>"
  ```

#### Notebook location & Git policy

* Authoritative repos: notebooks live **in the repo**, under a clear folder:

  ```text
  <repo>/
    notebooks/
  ```

* For one-off experiments not tied to a repo:

  ```text
  ~/dev/devruns/<project-name>/notebooks/
  ```

* Notebooks are committed **only** if they are part of the project’s documentation or experiments you want to keep.

* Heavy outputs (images, CSVs, etc.) go to:

  ```text
  ~/dev/devruns/<project-name>/artifacts/
  ```

  and are git-ignored.

#### Jupyter usage in PyCharm

* Project interpreter:
  `File → Settings → Python → Python Interpreter` → select:

  ```text
  ~/dev/venvs/<project-name>/bin/python
  ```
* Jupyter server:
  `Settings → Jupyter → Jupyter Servers`:

  * Use **IDE-Managed Server**
  * Execution mode: **IPyKernel**
* Notebook kernel selection:

  * Open `.ipynb`
  * Kernel selector (top-right): choose
    **Python 3.11 (<project-name>)**

If the kernel list doesn’t show `<project-name>`, register it with `ipykernel` as above.

#### Relationship with `~/learning`

* Training / book notebooks (like *Math for Programmers*) may live under:

  ```text
  ~/learning/python/<book-or-course>/
  ```

  using a dedicated venv in `~/dev/venvs/<book-or-course>/`.
* These are **non-authoritative** by design and follow the same venv + kernel rules, but are **never** the main source of production code.

---

## Node.js / npm / TypeScript

**Goal:** single, reproducible Node toolchain for ML APIs, backend utilities, and dev tooling — without conflicts with system Node, and with full reproducibility across machines and time.

### Node management (`nvm` — mandatory)

Node is managed **only** via `nvm` (Node Version Manager).

Do **NOT**:

* install Node from the OS (`dnf install nodejs`)
* download Node manually
* install project tools globally (`npm -g`)

Location:

```text
~/.nvm
```

### Canonical Node runtime model

**Node version is defined per repository.**
The repository (and CI) is the **source of truth**, not the global environment.

Accepted mechanisms (one required per repo):

* `.nvmrc`
* `.node-version`
* Volta configuration

Local development **MUST match the repo-pinned version**.

### Default Node line (for new personal projects)

For **new personal repositories** (unless there is a strong reason not to):

* **Default Node line:** **Node 24 LTS** (active LTS)

Install and set your personal default once:

```bash
nvm install 24
nvm alias default 24
nvm use 24
```

For such projects, the repository **must** include:

```text
.nvmrc
24
```

### Mandatory workflow inside any Node project

Before using `npm`, `pnpm`, `yarn`, or `corepack`:

```bash
nvm use
node -v
npm -v
```

Expected:

* Node version **matches the repo’s pinned version**
* If it does not, the environment is **INVALID** and must be fixed before continuing

> **Important:**
> If a repository pins Node 18 or 20, that is valid.
> You adapt your local Node via `nvm`; you do **not** override the repo.

### Project layout

All Node / TypeScript repositories live **only** in:

```text
~/dev/repos/<area>/<project-name>/
```

Dependencies are **local**:

* `node_modules/` lives inside the repo
* `node_modules/` is always git-ignored
* no project dependency is installed globally

### Package managers

Prefer the package manager **declared by the repository** (lockfile-driven).

Enable once globally:

```bash
corepack enable
```

Rules:

* Never install package managers globally with `npm -g`
* For third-party repos: **respect their lockfile and tool**
* For personal repos: prefer **pnpm** via corepack and commit `pnpm-lock.yaml`

### TypeScript policy

TypeScript is **per-project**, never global:

```bash
npm install --save-dev typescript @types/node
```

Every TypeScript project **must** include a committed `tsconfig.json`.

Build output:

* preferred: `~/dev/build/<project-name>/`
* if the toolchain enforces `dist/` or `build/`, they **MUST** be git-ignored

### Node.js project hygiene

*(Dependencies, size, performance)*

**Goal:** keep Node/TypeScript projects lean, reproducible, and fast — without dependency bloat.

#### Dependency discipline

* Dependencies are treated like code.
* A dependency is added only if it removes real, non-trivial effort.
* Avoid “kitchen-sink” libraries.
* Avoid duplicated responsibility (one HTTP lib, one validation lib, etc.).

Classification:

* Runtime libraries → `dependencies`
* Tooling (TypeScript, ESLint, tests, nodemon, etc.) → `devDependencies`

#### Lockfiles and reproducibility

* Lockfiles are **always committed**:

  * `pnpm-lock.yaml`
  * `package-lock.json`
* Installs **must respect the existing lockfile**
* Avoid open-ended ranges (`*`, `>=`) — they break determinism

#### `node_modules` policy

* `node_modules` is **expected to be large** — this is acceptable
* It is disposable and never tracked
* It must be:

  * git-ignored
  * excluded from backups and sync
  * safe to delete and regenerate at any time

#### Build and cache directories

Build artifacts and caches are **never committed**.

Common directories to ignore:

* `node_modules`
* `dist`
* `build`
* `.next`
* `.turbo`
* `.cache`

All are regenerable and must not pollute history.

#### Runtime vs development footprint

For ML APIs and backend utilities:

* Runtime dependencies must be minimal
* Prefer:

  * built-in `fetch` (Node 18+/24)
  * `undici` if needed
  * optional `dotenv`
  * optional lightweight validation (e.g. `zod`)
* Logging must be lightweight and intentional
* Tooling **never** required at runtime

#### No global CLIs

* Project tools are **not** installed globally (`npm -g` forbidden)
* Tools run via:

  * local binaries
  * project scripts
* One-off helpers may be used via:

  * `npx`
  * `corepack dlx`
* Nothing persistent is installed globally

#### Repository focus and performance

* Repositories remain small and intentional
* Only source code, tests, and configuration are tracked
* Large directories are ignored so:

  * editors stay fast
  * watchers don’t choke
  * CI stays predictable

**End goal:** deterministic installs, fast workflows, stable builds — today and years from now.

---

### Java + Spring + Maven

**Spring** is the primary Java application framework.
**Maven** is the build and dependency tool.

#### Java runtime baseline

Long-term support (LTS) releases matter. Current LTS landscape includes Java 17, 21, and 25. Java 25 is latest LTS; Java 21 and 17 remain widely used and supported.

**Policy:**

* Default JDK for new projects: **Java 21 LTS**
* Java 17 LTS: allowed for legacy codebases or when the upstream stack requires it
* Java 25 LTS: allowed for new greenfield projects only after verifying framework and library support; decision must be documented in the repo `README.md`

**Rules:**

* System-wide JDKs should not be “mystery installs” — prefer well-known distros (e.g., Temurin, Corretto, or similar) and document the chosen distribution/version in the project `README.md`
* All IDEs must point to the same JDK for a given project
* No mixing multiple major JDKs inside a single project

#### Spring Boot / Spring Framework versions

The Spring ecosystem is moving to Spring Framework 6.x/7.x and Spring Boot 3.x/4.x with Java 17+ baselines.

**Policy:**

* Default for new server-side projects:

  * **Spring Boot 3.x** on **Spring Framework 6.2+**, targeting Java 21
* Spring Boot 4 / Spring Framework 7:

  * Allowed for new greenfield projects once the stack is verified on Java 21 or 25
  * Decision must be documented (supported dependencies, container images, CI runners)
* Spring 5.x is considered legacy and supported only for reading or minimal maintenance, not for new work

#### Build output

* Never commit `target/`
* Prefer deterministic builds: `mvn -q -DskipTests=false test` as baseline

#### Rules

* Keep all configuration in-repo:

  * `pom.xml`
  * `application.yml` / `application.properties`

* Externalize secrets via environment variables or externalized config; never commit secrets

* Use container stacks in `~/docker/` for dependencies (PostgreSQL, Redis, etc.):

  ```text
  ~/docker/<stack-name>/
  ```

* `pom.xml` is authoritative; IDE configuration must follow it
* Prefer Maven Wrapper when present:
  ```text
  mvnw
  .mvn/
  ```
* Do not rely on machine-specific Maven installs
* Databases, queues, and services run via Docker stacks under:
  ```
  ~/docker/<stack-name>/
  ```

---

## IDE Roles & Discipline

### CLion — C / C++

* Precision, debugging, refactors
* External build dirs only: `~/dev/build/<repo>`
* Tooling is repo-authoritative:
  - `.clang-format` required
  - `.clang-tidy` required
  - CLion configured to prefer `.clang-tidy` over IDE settings
* **No AI**

### PyCharm — Python

* Run, debug, test
* venvs in `~/dev/venvs/<project>`
* AI-light only

### IntelliJ IDEA — JVM

* Gradle/Maven projects
* AI only for trivial boilerplate

### DataGrip — Databases

* **No AI**
* Reasoning happens outside the IDE

### VS Code — Utility

* Markdown, YAML, JSON, inspections
* Never duplicates Cursor
* **Utility knife**, not a thinking engine

### Cursor — **Only AI-First IDE**

* All reasoning, refactors, design work
* One task per session
* Clean `git status` before and after

---

## IDE Setup & Configuration

### 1. CLion — C / C++ (AI-free by design)

**Open an existing project**

1. **File → Open**
2. Select:
   ```
   ~/dev/repos/github.com/.../<repo>
   ```
3. Confirm `CMakeLists.txt` is at root

**Configure (once)**

* Toolchain:
  * Compiler: GCC or Clang
  * Debugger: GDB / LLDB
  * Generator: Ninja
* CMake profiles:
  * Debug → `~/dev/build/<repo>/Debug`
  * Release → `~/dev/build/<repo>/Release`
* C++ standard:

Ensure project contains:

```
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
```

If not enforced → fix before real work.

Rules:

* No AI plug-ins
* No build output in repo

### 2. PyCharm — Python Execution IDE (AI-light)

**Open an existing project**

1. **Open folder**:
   ```text
   ~/dev/repos/github.com/.../<repo>
   ```

**Python environments**

* venvs live in:
  ```text
  ~/dev/venvs/<project>
  ```
* Select interpreter explicitly
* Never create `.venv/` inside repo unless policy allows (ignored)

**AI policy**

* Minimal or disabled
* No architecture or reasoning
* Use Cursor or ChatGPT instead

PyCharm is for **running, debugging, testing**.

### 3. IntelliJ IDEA — JVM Projects (AI-light)

**Open an existing project**

* Open repo root under `~/dev/repos/...`
* Let IntelliJ import Gradle / Maven normally

**Rules**

* Build output stays external (default Gradle behavior is OK)
* `.idea/` ignored
* AI only for:
  * trivial boilerplate
  * repetitive code

Architecture decisions happen **outside IntelliJ**.

### 4. DataGrip — Databases (NO AI)

**Open**

* No repo opening needed
* Connect to databases directly

**Rules**

* No AI assistants
* No SQL generation via LLM inside IDE
* If you need reasoning:
  * ChatGPT Plus (conceptual)
  * Claude Pro (long SQL / schema analysis)

DataGrip already *understands* the database better than an LLM.

### 5. VS Code — Utility / Sandbox IDE

**Open**

* Open folders, not files
* Can open:
  * repos
  * `~/dev/devruns`
  * config folders

**Use cases**

* Markdown
* JSON / YAML
* quick inspections
* light scripting

**AI policy**

* If enabled at all: **lightweight only**
* Never duplicate Cursor's role

VS Code is a **utility knife**, not a thinking engine.

### 6. Cursor — The Only AI-First IDE

**Open**

* Open **repos** under:
  ```text
  ~/dev/repos/...
  ```
* Open **execution workspaces** under:
  ```text
  ~/dev/devruns/...
  ```

**Rules (strict)**

* One scoped task per session
* Clean `git status` before agentic edits
* Review diffs before accepting
* Commit before and after major changes

**AI discipline**

* Reasoning + refactors → Cursor
* Long documents → Claude Pro
* Conceptual thinking → ChatGPT Plus
* Second opinion → Gemini Pro

Cursor is the **only IDE allowed to host "thinking AI"**.

### 7. New Project Creation (Any Language)

1. Create repo under:
   ```text
   ~/dev/repos/github.com/alfonsocruzvelasco/<repo>
   ```
2. Initialize Git
3. Write `.gitignore`
4. Write minimal `README.md`
5. Decide:
   * build dir (`~/dev/build/...`)
   * data dir (`~/dev/data/...`)
   * venv (`~/dev/venvs/...`)
6. Only then open the IDE

---

## Universal Pre-Flight Checks

### Every Repo (Before Opening Any IDE)

```bash
git status
git remote -v
git branch --show-current
```

Verify:

* `.gitignore` exists and excludes:
  * build dirs
  * IDE metadata
  * venvs
  * caches
* `origin` points where you expect
* working tree is clean

If anything is unexpected → **stop**.

### C/C++ Repos Specifically

Before real work begins:

```bash
ls -a | egrep '^\.(clang-tidy|clang-format)$'
```

If missing → **stop and add them**.

---

## Naming Policy (Cross-Language)

### Universal Principles

1. **Names encode intent, not implementation**
   * Prefer *domain nouns/verbs*: `computeSignalPower`, `trackDetections`, `estimatePose`

2. **Consistency beats cleverness**
   * Pick the convention per language and apply it everywhere

3. **Short names are reserved**
   * `i, j, k` only for indices
   * `_` prefix only for "intentionally unused"

4. **No ambiguous abbreviations**
   * If you abbreviate, it must be standard and obvious (`id`, `url`, `fps`)

5. **Boolean names read as predicates**
   * `isValid`, `hasDetections`, `shouldRetry`

### Java Naming Checklist (Checkstyle-aligned)

* **Packages**: `lowercase.with.dots`
  Example: `com.alfonso.perception.tracking`
* **Classes / Interfaces / Enums**: `UpperCamelCase`
  Example: `KalmanTracker`, `DetectionSource`
* **Methods**: `lowerCamelCase` (verb-first)
  Example: `updateTrack`, `computeResiduals`
* **Variables / fields**: `lowerCamelCase`
  Example: `frameIndex`, `totalPower`
* **Constants**: `UPPER_SNAKE_CASE`
  Example: `MAX_FRAMES`, `DEFAULT_TIMEOUT_MS`
* **Generics**: `T`, `E`, `K`, `V` are acceptable (standard Java idiom)

Discipline rule: If a name is unclear, **rename first**, refactor second.

### JavaScript Naming Checklist (ESLint-aligned)

* **Files**: `kebab-case.js` for modules, or `lowerCamelCase.js` if you prefer internal consistency
  For learning units: `naming_sanity.pass.js` and `*.fail.js` are fine
* **Functions**: `lowerCamelCase` (verb-first)
  Example: `computeSignalPower()`
* **Classes**: `UpperCamelCase`
  Example: `TrackManager`
* **Constants**: `UPPER_SNAKE_CASE`
  Example: `DEFAULT_BATCH_SIZE`
* **Booleans**: `is/has/should` prefixes
  Example: `isReady`, `hasError`, `shouldRefit`
* **Avoid single-letter params** except `i/j/k` as indices

Enforced rules:
* `eqeqeq` as **error**
* `camelcase` + `id-length` as **warnings**

### Python Naming Checklist (ruff-aligned)

* Modules / packages: `snake_case.py`, packages `snake_case/`
* Functions / variables: `snake_case` — `compute_signal_power`
* Classes: `UpperCamelCase` — `KalmanTracker`
* Constants: `UPPER_SNAKE_CASE` — `MAX_FRAMES`
* Private/internal: leading underscore `_internal_helper`
* Booleans: `is_/has_/should_` prefixes — `is_valid`, `has_detections`

Python is PEP 8 land; ruff can enforce this without you fighting it.

---

## Tooling & Build Policy

**This section defines mandatory, repo-first rules for Python (pip/venvs), Node/npm, CMake, and Java/Spring.**
**IDE settings must never override repository configuration.**

### Python — pip & Virtual Environments

**Principles**

* Python environments are **tooling**, not project artefacts
* The repository defines dependencies; the environment is external

**Rules (mandatory)**

* One virtual environment per project
* Virtual environments live **only** in:
  ```text
  ~/dev/venvs/<project-name>/
  ```
* No `.venv/` directories inside repositories
* `pip` is executed **only inside the active venv**
* All dependencies are declared in `pyproject.toml`
* No global Python package installations

**Verification (before installing or running)**

```bash
python -c "import sys; print(sys.executable)"
```

Expected output:
```
/home/<user>/dev/venvs/<project-name>/bin/python
```

### JavaScript / TypeScript — npm

**Principles**

* Dependencies are project-local
* Lockfiles guarantee reproducibility
* No global tooling assumptions

**Rules (mandatory)**

* `node_modules/` is **never committed**
* `package-lock.json` **must be committed**
* `npm install` is allowed only inside a project directory
* Global npm packages must not be relied upon for project workflows
* Use project scripts:
  ```bash
  npm run <script>
  ```

**Scope clarification**

* Authoritative work: `~/dev/repos/...`
* Learning / experiments: `~/learning/...`
  (`node_modules/` allowed there by definition)

### C / C++ — CMake

**Principles**

* Repositories contain **source only**
* All builds are out-of-tree
* Build configuration is explicit and reproducible

**Rules (mandatory)**

* All CMake builds are out-of-tree under:
  ```text
  ~/dev/build/<repo-name>/<profile>/
  ```
  (e.g. `Debug`, `Release`)
* No build artefacts inside repositories
* `CMakePresets.json` is the preferred, authoritative build contract
* `compile_commands.json`, if generated, lives in the build directory
* IDEs must respect repo CMake configuration

#### C++17 standard (C++ projects only)

For C++ repositories, the language standard is enforced in CMake:

* Top-level `CMakeLists.txt` **must** contain:

```cmake
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
```

---

### C / C++ — Linting & Formatting (CLion)

**Principles**

* The repository is the source of truth
* No IDE-local inspection drift

**Rules (mandatory)**

* Each C/C++ repo must contain:
  ```text
  .clang-tidy
  .clang-format
  ```
* CLion must be configured to **prefer `.clang-tidy` over IDE settings**
* No configuration of clang-tidy checks via IDE UI
* Formatting is enforced exclusively via `.clang-format`
* Naming conventions are enforced via clang-tidy (`readability-identifier-naming`)

### Non-Negotiable Rule

> Repositories must not rely on IDE-local configuration.
> Tooling, linting, formatting, and builds are controlled **only** by files committed to the repository.

---

## Python Formatter & Linter Standard

### Global Decision (Locked)

You will use **one Python standard** everywhere:

> **Formatter:** `black`  
> **Linter:** `ruff`  
> **Import sorting:** `ruff` (replaces isort)

This is the current **industry default** for serious Python work.

**Why this pair (brief, factual):**

* `black`: zero configuration, deterministic output
* `ruff`: extremely fast, replaces flake8 + isort + many plugins
* Both are widely supported in **all your IDEs**
* Minimal cognitive load

No alternatives will be introduced.

### Where Configuration Lives (Policy-Compliant)

#### 1. Tooling Lives in the venv (Never Global)

For each Python project:
```text
~/dev/venvs/<project>/
```

Install tools **inside the venv only**.

#### 2. Configuration Lives in the Repo (Tracked)

At repo root:
```
pyproject.toml
```

This is the **only** config file needed.

### Step 1 — Install Tools (Per Project)

Inside the project venv:

```bash
source ~/dev/venvs/<project>/bin/activate
python -m pip install black ruff
```

Nothing global. Nothing hidden.

### Step 2 — Canonical `pyproject.toml`

Create or edit **once** at repo root:

```toml
[tool.black]
line-length = 88
target-version = ["py313"]
skip-string-normalization = false

[tool.ruff]
line-length = 88
target-version = "py313"
select = [
  "E",  # pycodestyle errors
  "F",  # pyflakes
  "I",  # imports (replaces isort)
  "B",  # bugbear
]
ignore = [
  "E203",  # black compatibility
  "E266",
  "E501",
]
fix = true
```

**Alternative minimal configuration (discipline-first):**

```toml
[tool.ruff]
line-length = 120
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "B", "I", "N"]
ignore = []

[tool.ruff.lint.flake8-unused-arguments]
ignore-variadic-names = true
```

Meaning:
* `E`, `F`: core correctness
* `B`: bugbear (common footguns)
* `I`: import order
* `N`: naming convention checks

This file is **shared by all IDEs**.

### Step 3 — IDE Integration (Minimal, Correct)

#### Cursor

* Uses the same Python extension behavior as VS Code
* Automatically picks up:
  * `black` for formatting
  * `ruff` for diagnostics
* No extra plugins required

**Action:** none (Cursor already respects this)

#### VS Code

Install **only**:
* Python extension (official)

Settings (user or workspace):

```json
{
  "python.formatting.provider": "black",
  "editor.formatOnSave": true,
  "python.linting.enabled": true
}
```

No flake8. No isort.

#### PyCharm / IntelliJ

Settings → Python:

* Formatter:
  * Enable **Black**
  * Use interpreter from `~/dev/venvs/<project>`

* Inspections:

  * Disable noisy built-in style checks if necessary
  * Let `ruff` handle linting

PyCharm will automatically read `pyproject.toml`.

#### CLion / DataGrip

* **No Python formatting needed**
* Nothing to configure

### Step 4 — Daily Usage (Important)

* You **never** think about formatting
* You **never** argue with the formatter
* You **never** run multiple tools

Your habits:

```bash
# optional manual run
black .
ruff check .
```

Or for fixes:

```bash
ruff check . --fix
```

But in practice:
* format-on-save
* lint-on-type

### What This Prevents (By Design)

* style debates
* IDE-specific formatting drift
* "works in my editor" issues
* reformat noise in Git diffs

### Final Lock-In Rule

> If code formatting becomes visible, the setup is wrong.

You are now aligned with:
* Cursor
* PyCharm
* VS Code
* CI (later, trivially)

---

## IDE Pre-Flight Checklists

### 1. Cursor — AI-First IDE

**Before working**

* [ ] Folder opened under `~/dev/repos/...` or `~/dev/devruns/...`
* [ ] `git status` is clean (or changes are intentional)
* [ ] Correct model selected
* [ ] Task is scoped (one refactor / one fix / one feature)

**During work**

* [ ] No long documents pasted beyond what the model can reasonably handle
* [ ] No mixed tasks in one chat
* [ ] Review diffs before accepting agent changes

**Before closing**

* [ ] Commit or discard changes
* [ ] No generated files inside repo

---

### 2. CLion — C / C++ (No AI)

**Before working**

* [ ] Repo opened from `~/dev/repos/...`
* [ ] Build directory is external:

  ```text
  ~/dev/build/<repo>/Debug or Release
  ```
* [ ] Correct CMake profile selected

**During work**

* [ ] No AI plugins installed
* [ ] Debug / refactor using CLion tools only

**Before closing**

* [ ] Build artifacts stay outside repo
* [ ] `git status` clean

---

### 3. PyCharm — Python Execution IDE (AI-Light)

**Before working**

* [ ] Repo opened from `~/dev/repos/...`
* [ ] Interpreter points to:
  ```text
  ~/dev/venvs/<project>/bin/python
  ```
* [ ] No `.venv/` created inside repo (unless explicitly allowed)

**During work**

* [ ] Use PyCharm for running, debugging, tests
* [ ] No architecture reasoning in-IDE

**Before closing**

* [ ] venv unchanged
* [ ] No cache or temp files in repo

---

### 4. IntelliJ IDEA — JVM Projects (AI-Light)

**Before working**

* [ ] Repo opened from `~/dev/repos/...`
* [ ] Build system imported cleanly (Gradle / Maven)
* [ ] `.idea/` ignored by Git
* [ ] JDK version matches project policy (default Java 21; legacy projects explicitly documented)

**During work**

* [ ] AI (if enabled) used only for trivial boilerplate
* [ ] No design decisions delegated to IDE AI

**Before closing**

* [ ] Build output untouched in repo
* [ ] `git status` clean

---

### 5. DataGrip — Databases (NO AI)

**Before working**

* [ ] Connected to correct database
* [ ] Correct schema selected

**During work**

* [ ] SQL written manually
* [ ] Execution plans inspected natively
* [ ] If reasoning needed → switch to ChatGPT / Claude (outside IDE)

**Before closing**

* [ ] No credentials committed anywhere
* [ ] No AI usage inside DataGrip

---

### 6. VS Code — Utility / Sandbox

**Before working**

* [ ] Folder opened intentionally (repo / devruns / config)
* [ ] Not duplicating Cursor's role

**During work**

* [ ] Markdown, JSON, YAML, small scripts only
* [ ] AI (if enabled) used sparingly

**Before closing**

* [ ] No hidden state created
* [ ] No expectations of "project intelligence"

---

### 7. Cross-IDE Final Check (Always)

Before switching IDEs or ending a session:

* [ ] `git status` clean (or committed)
* [ ] No build / cache files inside repos
* [ ] AI usage respected the role separation
* [ ] Nothing "temporary" accidentally became permanent

---

## Cleanup Rules

When in doubt, ask:

> "Will I need this in 6 months?"

* No → delete
* Maybe → archive
* Yes → move to the correct place

---

## Final Mental Model

**Memorize This:**

* **Repos** → `~/dev/repos`
* **Tools & envs** → `~/dev`
* **Learning scratch** → `~/learning`
* **Thinking AI** → Cursor only

**Key Principles:**

* **Builds** → `~/dev/build`
* **Data** → `~/dev/data`
* **Models** → `~/dev/models`
* **Runs** → `~/dev/devruns`
* **Conceptual AI** → ChatGPT / Claude / Gemini outside IDEs

**Mental Shortcut:**

> **If the IDE already understands the code → no AI.**  
> **If the IDE does not understand the code → Cursor or external AI.**

If you follow this document, **you cannot drift**.

**This policy is binding unless a technical exception is explicitly documented.**

---

## 16. Testing Strategy & Policy

**Status:** Authoritative
**Scope:** All languages and stacks defined in this document

---

### 16.1 Goals

* Make tests **first-class citizens**, not optional extras
* Keep a clear separation between **unit**, **integration**, and **system/end-to-end (E2E)** tests
* Align tests with the existing layout:

  * Code: `~/dev/repos/...`
  * Small fixtures: inside repo under `tests/fixtures/`
  * Heavy / large test data: `~/test-data/<project>/...`
* Ensure tests are **repeatable, hermetic, and fast by default**

---

### 16.2 Test Taxonomy (Definitions)

From your point of view as a developer:

**Unit Tests**

* Test a **single function/class/module** in isolation
* No network, no real DB, no filesystem side effects (unless that is the unit)
* Use **mocks/stubs/fakes** at boundaries (DB, APIs, file I/O, GPU, etc.)
* Must be **fast** (milliseconds), safe to run on every save / commit

**Integration Tests**

* Test the interaction between a **small number of real components**:

  * service + real DB (container)
  * module + real file I/O
  * HTTP client + local test server
* Use **real implementations**, minimal mocking
* Slower than unit tests but still suitable for **per-feature runs**

**System / End-to-End (E2E) Tests**

* Test **full flows** from the outside:

  * API → DB → queue → model → response
* Use real infrastructure (Docker stack, local services)
* Slower, fewer, focused on **critical paths** (happy path + key failure modes)
* Run on demand and in CI, not on every tiny edit

---

### 16.3 Directory & Naming Conventions

**Universal rules**

* Tests live **inside the repo**, never in `~/dev/devruns`

* Each repo has a top-level `tests/` directory (or language-standard equivalent)

* Test names must express intent, not mechanics:

  * Good: `test_rejects_invalid_token`, `test_tracks_are_sorted_by_timestamp`
  * Bad: `test_function1`, `test_case_a`

* Heavy fixtures (large images, CSVs, model checkpoints) go to:

  ```text
  ~/test-data/<project>/...
  ```

  and are referenced via config/env vars, not committed to Git.

#### Language-specific layout

**Python (pytest)**

* Canonical test runner: **pytest**

* Layout:

  ```text
  <repo>/
    src/                  # or package root
    tests/
      unit/
      integration/
      e2e/
      fixtures/
  ```

* File naming:

  * Tests: `test_*.py`
  * Helper modules: `conftest.py`, `helpers.py`

* Markers (mandatory):

  ```python
  import pytest

  @pytest.mark.unit
  def test_something(): ...

  @pytest.mark.integration
  def test_something_with_db(): ...

  @pytest.mark.e2e
  def test_full_pipeline(): ...
  ```

**C / C++ (GoogleTest)**

* Canonical framework: **GoogleTest** (gtest)

* Layout:

  ```text
  <repo>/
    src/
    include/
    tests/
      unit/
      integration/
      e2e/
  ```

* CMake must register tests with **CTest**:

  ```cmake
  enable_testing()

  add_executable(myproject_unit tests/unit/test_something.cpp)
  target_link_libraries(myproject_unit PRIVATE myproject gtest_main)

  add_test(NAME myproject_unit COMMAND myproject_unit)
  ```

* Running all tests:

  ```bash
  cmake --build <build-dir> --target test
  ctest --output-on-failure
  ```

**Java / Spring (JUnit 5)**

* Canonical framework: **JUnit 5**

* Layout:

  ```text
  <repo>/
    src/
      main/java/...
      test/java/...
  ```

* Package structure:

  * Unit tests mirror main packages: `...service`, `...controller`, etc.
  * Integration tests under a clear subpackage, e.g. `.it` or `.integration`
  * E2E tests under `.e2e` where applicable

* Naming:

  * Classes: `XyzServiceTest`, `XyzControllerIT`, `OrderFlowE2ETest`

* Maven profiles (recommended):

  * Default profile: unit tests
  * Separate profile for integration/E2E (e.g. requires Docker stack):

    ```xml
    <profiles>
      <profile>
        <id>integration</id>
        <properties>
          <groups>integration</groups>
        </properties>
      </profile>
    </profiles>
    ```

**Node.js / TypeScript (Vitest)**

* Canonical framework: **Vitest**

* Layout:

  ```text
  <repo>/
    src/
    tests/
      unit/
      integration/
      e2e/
  ```

* Naming:

  * Files: `*.test.ts` or `*.spec.ts`
  * Commands in `package.json`:

    ```json
    {
      "scripts": {
        "test": "vitest run",
        "test:unit": "vitest run tests/unit",
        "test:integration": "vitest run tests/integration",
        "test:e2e": "vitest run tests/e2e"
      }
    }
    ```

---

### 16.4 When to Write Which Tests

**Non-negotiable rules**

1. **Every non-trivial module gets unit tests**

   * Business logic, utilities, algorithms, model-wrapping code → unit tests required.
   * “Trivial” = getters/setters, pure data carriers, or glue that will be exercised via higher-level tests.

2. **Any code that touches external systems must have integration tests**

   * DB repositories, HTTP clients, message queues, filesystem pipelines.
   * Integration tests use **real** Dockerized services (Postgres/MySQL/Redis/etc.) from `~/docker/...`.

3. **Critical flows must have at least one E2E test**

   * Example for CV/ML:

     * “Receive image → preprocess → run model → postprocess → return JSON response”

4. **Bug fix rule**

   * Every bug that reaches you must:

     * be reproduced by a failing test first
     * then be fixed with that test passing

5. **Performance-sensitive code**

   * If you optimize something (e.g., a CUDA kernel, a data pipeline), you must:

     * keep unit tests for correctness
     * add a simple performance regression check where feasible (even if just as a benchmark, not in the main test suite)

---

### 16.5 Test Execution Discipline

**Local workflow**

Before any significant commit (feature, refactor, or merge):

```bash
# Minimal:
# 1) unit tests always
# 2) integration tests if you touched boundaries
# 3) e2e if you touched flows

# Python
pytest -m "unit"
pytest -m "integration"   # if relevant
pytest -m "e2e"           # if relevant

# C/C++
cmake --build <build-dir> --target test
ctest --output-on-failure

# Java
mvn test                  # unit
mvn verify -Pintegration  # integration/e2e if needed

# Node/TS
npm run test:unit
npm run test:integration  # if relevant
npm run test:e2e          # if relevant
```

**Pre-Flight Extension**

Extend “Universal Pre-Flight Checks” with:

* [ ] **Tests**:

  * For normal commits: all unit tests passing
  * For risky refactors or releases: unit + integration + critical E2E passing

If tests are red → **no commit, no push**.

---

### 16.6 Test Data & Determinism

**Small fixtures**

* Store inside repo under `tests/fixtures/`:

  * small example images
  * tiny CSV/JSON snippets
  * toy models (KB/MB)

**Large / heavy fixtures**

* Store under:

  ```text
  ~/test-data/<project>/
  ```

* Never commit to Git

* Access via configuration:

  * env var: `TEST_DATA_ROOT=~/test-data/<project>`
  * config file: `tests/config.yaml` with paths

**Randomness**

* All tests that use randomness must:

  * set a fixed seed
  * or inject a PRNG (pseudo random number generator) with deterministic seed
* Example:

  ```python
  import numpy as np
  np.random.seed(42)
  ```

This guarantees reproducible results across runs and machines.

---

### 16.7 Relationship with `~/learning`

* Code under `~/learning` **may** have tests, but:

  * They are optional, exploratory, and non-authoritative
  * They do **not** define standards
* Only tests under `~/dev/repos/...` are **binding** and must follow this policy.

---

---

## 17. MCP Policies

**Status:** Authoritative  
**Scope:** MCP (Model Context Protocol) servers used by Cursor

This section governs how MCP servers are introduced, configured, and used so that they remain controlled tools, not hidden system state.

### 17.1 Principles

* MCP servers are **tools**, not toys.
* MCP capabilities are **workspace-scoped**, never system-global.
* All MCP usage must be:
  * **auditable** (config lives in files),
  * **reversible** (easy to disable/remove),
  * **minimal** (only servers that solve a real problem).

Cursor remains the **only AI-first IDE** allowed to host MCP servers.

### 17.2 Allowed locations & isolation

1. **Learning sandbox (default location)**

   * All new MCP servers must first be evaluated under:

     ```text
     ~/learning/tools/<tool-name>-playground/
     ```

   * Example current sandboxes:

     * `~/learning/tools/serena-playground`
     * `~/learning/tools/mcp-servers` (Serena + Firecrawl)

   * These sandboxes are **non-authoritative**; they may be deleted at any time.

2. **~/dev (authoritative projects)**

   * No MCP configuration is allowed under `~/dev` **by default**.
   * An MCP server may be enabled for a specific repo **only after**:
     * it has been tested in `~/learning/tools/...`, and
     * a short rationale is written in the repo’s `README.md` under a “Tooling / MCP” section.

3. **System level**

   * No global MCP configuration files.
   * No MCP servers installed as system services or background daemons.

### 17.3 Configuration & secrets

1. MCP configuration is always stored in **workspace-local** Cursor config:

   ```text
   <workspace>/.cursor/mcp.json
   ```

2. `.cursor/` directories must be **git-ignored** in all sandboxes and repos:

   ```gitignore
   .cursor/
   ```

3. Secrets (API keys, tokens) are provided only via the `env` field of `mcp.json`:

   ```json
   "firecrawl": {
     "command": "npx",
     "args": ["-y", "firecrawl-mcp"],
     "env": {
       "FIRECRAWL_API_KEY": "fc_..."
     }
   }
   ```

   * No secrets in tracked files.
   * No MCP-related keys exported globally in shell profiles (`.bashrc`, `.zshrc`, etc.).

4. When a key is accidentally exposed (screenshots, logs, chats):

   * Regenerate the key in the provider dashboard.
   * Update the value in `.cursor/mcp.json`.
   * Delete the old key.

#### MCP secret scope restriction (mandatory)

Even though `.cursor/mcp.json` is git-ignored:

- MCP configuration files MUST NOT contain:
  * long-lived credentials
  * production API keys
  * non-rotatable secrets

- Secrets used by MCP servers MUST be:
  * short-lived
  * minimally scoped
  * rotatable
  * non-production whenever possible

- `.cursor/mcp.json` is a tool configuration file, **not a secret vault**.

### 17.4 Approved MCP servers (current)

Only the following non-built-in MCP servers are approved:

1. **Serena**

   * Purpose: project-aware code tooling (file find, structured edits, navigation).
   * Installation: launched via `uvx` inside Cursor, configured only in workspace-local `.cursor/mcp.json`.
   * File access:
     * Allowed to read and edit files **inside the opened workspace**.
     * Edits must go through Cursor’s diff/approval UI.
   * Default mode:
     * Prefer Serena tools that operate on **explicit instructions** and single files.
     * For large refactors, require a clean `git status` before and after.

2. **Firecrawl**

   * Purpose: fetch and structure external web documents for analysis (docs, blog posts, references).
   * Installation: `npx -y firecrawl-mcp` configured only in workspace-local `.cursor/mcp.json`.
   * File access:
     * Must not write or modify local files; used purely as a **read-only data source**.
   * Network:
     * Used only for documentation / research URLs relevant to current work.
     * Not used for arbitrary browsing or scraping unrelated sites.

Any additional MCP server must be explicitly added to this section before use.

### 17.5 MCP introduction workflow (from idea → usage)

1. **Motivation first**

   * Identify a concrete need (e.g. “fetch structured docs”, “project-aware edits”).
   * If vanilla Cursor + existing tools can solve it, **no new MCP** is added.

2. **Sandbox evaluation**

   * Create a dedicated sandbox:

     ```bash
     mkdir -p ~/learning/tools/<tool-name>-playground
     cd ~/learning/tools/<tool-name>-playground
     git init
     echo ".cursor/" > .gitignore
     ```

   * Add MCP config in `.cursor/mcp.json`.
   * Test:
     * connection (green status in Cursor),
     * minimal safe actions (no filesystem surprises),
     * behaviour on errors.

3. **Decision**

   * If the server proves useful **and** predictable, it may be added to the **Approved MCP servers** list (Section 17.4).
   * Otherwise, its config is removed and the sandbox may be deleted.

4. **Graduation to `~/dev` (optional, later)**

   * Only after:
     * multiple successful uses in `~/learning`,
     * clear utility for a specific project,
     * explicit note in that project’s `README.md` describing:
       * which MCP server is used,
       * for what tasks,
       * where its config lives.
+
### 17.6 Safety rules during MCP usage

* MCP servers must **never**:
  * create or modify files outside the opened workspace root.
* change Git configuration (remotes, branches, hooks).
* edit binary artifacts, datasets, or model files.

* Before accepting MCP-generated edits in Cursor:
* `git status` must be clean **before** starting.
* Review the diff carefully.
* Commit or discard; do not leave large unreviewed MCP changes.

* For Firecrawl specifically:
* Treat its outputs as **factual but untrusted** — verify important technical details in primary sources.
* Do not paste long scraped outputs directly into tracked files; summarise and integrate manually.

---
*End of Unified Development Environment Policy*
