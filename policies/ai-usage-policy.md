# AI Constraint Usage Policies

**Status:** Authoritative
**Last updated:** 2026-01-16

## Index
<a id="index"></a>

### Daily use (most common)

1. [Token Strategy](#01-token-strategy-for-current-subscriptions)
2. [Standard Prompt Template](#4-standard-prompt-template-quick)
3. [Prompt-Quality Gate](#3-prompt-quality-gate-mandatory)
4. [CV/ML Execution Mode](#02-cvml-execution-mode)
5. [Verification-First Review](#04-verification-first-review-aiagent-era)

---

### Core policy (operating system)

- [0) Operating System (Start Here)](#0-operating-system-start-here)
  - [0.1) Token Strategy](#01-token-strategy-for-current-subscriptions)
  - [0.2) CV/ML Execution Mode](#02-cvml-execution-mode)
  - [0.3) Agentic Architecture (Skills & MCP)](#03-agentic-architecture-skills--mcp)
    - [0.3.1 Skills Overview (Cursor-Specific)](#031-skills-overview-cursor-specific)
    - [0.3.2 Skills Setup in Cursor](#032-skills-setup-in-cursor)
    - [0.3.3 Creating Skills](#033-creating-skills)
    - [0.3.4 Skills Best Practices](#034-skills-best-practices)
    - [0.3.5 Skills Examples](#035-skills-examples)
    - [0.3.6 Skills Integration with MCP](#036-skills-integration-with-mcp)
    - [0.3.7 MCP Overview (Cursor-Specific)](#037-mcp-overview-cursor-specific)
    - [0.3.8 MCP Setup in Cursor](#038-mcp-setup-in-cursor)
    - [0.3.9 Common MCP Servers for Cursor](#039-common-mcp-servers-for-cursor)
    - [0.3.10 MCP Usage Patterns](#0310-mcp-usage-patterns)
    - [0.3.11 MCP Best Practices](#0311-mcp-best-practices)
    - [0.3.12 MCP Troubleshooting](#0312-mcp-troubleshooting)
- [0.4) Verification-First Review (AI/Agent Era)](#04-verification-first-review-aiagent-era)
- [1) Operating Principles](#1-operating-principles)
- [2) Non-Negotiable Boundaries](#2-non-negotiable-boundaries)
- [3) Prompt-Quality Gate (Mandatory)](#3-prompt-quality-gate-mandatory)
- [4) Standard Prompt Template (Quick)](#4-standard-prompt-template-quick)

---

### Reference manual (separate file)

- **Prompt Policies:** `prompt_policies.md`


## 0) Operating System (Start Here)
From now on, the file **`prompts-policy.md`** is the **unique authoritative reference** for:
- how prompts must be structured
- anti-hallucination patterns
- grounding / citation discipline
- evaluation & iteration workflow

**Enforcement rule:** if a request is missing required prompt components (context, constraints, desired output, acceptance criteria, etc.), the assistant must *pause* and request a compliant prompt rewrite **following the guide**, before proceeding.

This policy defines *boundaries and operating rules*; the guide defines *prompting mechanics*.

---
## 0.1) Token Strategy for Current Subscriptions

**Purpose:** Minimize wasted tokens while maximizing output quality, utilizing specific model strengths for 2026 workflows.
1. **Cursor Pro first** for: code, repo navigation, refactors, diffs, tests, reading local files.
   **Rule:** do not paste large files into chat if Cursor can reference them directly.
2. **ChatGPT Plus** for: architecture, trade-offs, multi-step reasoning, project planning, “decision memos,” and risk analysis.
3. **Claude Pro** for: rewriting policy text, documentation clarity, tone consistency, and structured edits.
4. **Gemini Pro** for: broad exploration, quick comparisons, and second-opinion sanity checks (not the source of truth).

**Acronyms:** **CV** = Computer Vision, **ML** = Machine Learning, **LLM** = Large Language Model.

### 0.1.2 Context packs (copy/paste)

**Context Pack — Minimal (default)**
Use this for most requests to reduce repeated context and back-and-forth.

```
ROLE: Act as a senior engineering partner. Be direct and practical.
GOAL: <one sentence>
CONTEXT: <what exists already + links/paths>
ENV: Fedora 41, repos under ~/dev/repos/..., no venvs inside repos
CONSTRAINTS: One recommended path, no option menus, do not invent facts/paths, label risks
OUTPUT: Commands + minimal explanation
ACCEPTANCE: <how I verify success>
```

**Context Pack — CV/ML (add only when needed)**
Add this when work touches training, data, GPU, evaluation, or experiments.

```
CV = Computer Vision, ML = Machine Learning.
DATA: datasets under ~/datasets/..., never committed
RUNS: outputs under ~/dev/devruns/<project>/
MODELS: binaries under ~/dev/models/<project>/
EVAL: define metric(s) and baseline; measure before optimization
GPU: specify device, batch size, mixed precision, memory limits
CONTEXT BUDGET: <Single-turn | Chained | Multi-session>
VERIFICATION: <Isolated | Integrated>

```

### 0.1.3 “Ask once” intake (mandatory for complex work)

For any non-trivial task, provide (or the assistant must request) these in **one** message:
- Goal (single sentence)
- Inputs (paths, logs, links, snippets)
- Constraints (do-not-touch, time, style)
- Output format (commands / patch / checklist)
- Acceptance criteria (how you will verify)
- Risk tolerance (low/medium/high)

**Enforcement:** if these are missing and the task is complex, the assistant must pause and request a compliant prompt rewrite (per Section 3).

---
## 0.2) CV/ML Execution Mode

This section defines the default workflow for **CV** and **ML** tasks so you do not burn tokens on vague iterations.

### 0.2.1 Default deliverables (what “good” looks like)

For CV/ML work, the assistant should produce:
- a short plan (max 10 bullets)
- concrete commands / code diffs
- an evaluation step (metric + baseline + expected direction)
- a “stop point” after each irreversible change

### 0.2.2 Anti-token-burn rules (non-senior friendly)

- Prefer **small diffs** and **repeatable checklists** over large rewrites.
- Prefer “next 3 commands” over theory.
- Always include a rollback note when risk is medium/high.
- For performance: **measure first**, then optimize, then re-measure.

### 0.2.3 Model training checklist (minimum viable)

When asked to “improve” a model or pipeline, always request/confirm:
- dataset path and split definition
- baseline metric(s) and current value
- evaluation protocol (how measured)
- constraints (latency, memory, target hardware)
- reproducibility (seed, versions, commit hash)

---

## 0.3) Agentic Architecture (Skills & MCP)

**New for 2026:** We are moving from ad-hoc prompts to **reusable assets**.

1. **Skills (Procedural Knowledge):** Repeatable workflows (e.g., "How to verify a 3D bounding box") must be saved as `SKILL.md` files.

2. **MCP (Model Context Protocol):** Use MCP servers in Cursor to connect agents to tools (Databases, Git, APIs, browsers) rather than pasting data or manually retrieving context.

### 0.3.1 Skills Overview (Cursor-Specific)

**What are Skills in Cursor?**

Skills in Cursor are reusable procedural knowledge stored as markdown files. They encapsulate repeatable workflows, verification procedures, and domain-specific knowledge that agents can reference during conversations. Instead of repeatedly explaining how to perform a task, Skills provide standardized, version-controlled procedures.

**Why use Skills?**

- **Token efficiency:** Avoid repeating complex procedures in prompts (saves 30-70% tokens on procedural tasks)
- **Consistency:** Standardized workflows ensure the same approach across conversations
- **Maintainability:** Update procedures in one place (the Skill file), not in every prompt
- **Knowledge preservation:** Capture domain expertise that can be reused and improved over time
- **Agent capability:** Skills enable agents to follow complex multi-step procedures reliably

**Core principle:** If a workflow is repeated more than twice, create a Skill. Never re-explain procedures that exist in Skills.

### 0.3.2 Skills Setup in Cursor

**Location:** Skills are stored in `.cursor/skills/` directory at the repository root (or workspace root).

**Directory structure:**

```text
.cursor/
├── skills/
│   ├── verify-3d-bounding-box.md
│   ├── dataset-integrity-check.md
│   ├── api-authentication-flow.md
│   └── model-evaluation-protocol.md
└── rules/
    └── project.md
```

**File naming conventions:**
- Use lowercase with hyphens: `verify-3d-bounding-box.md`
- Be descriptive and action-oriented: `check-dataset-integrity.md` not `dataset.md`
- Use imperative mood: `verify-`, `check-`, `evaluate-`, `generate-`

**Activation:** Skills are automatically available in Cursor conversations when in a workspace that contains `.cursor/skills/` directory. Agents can reference Skills by name or automatically apply them when context matches.

### 0.3.3 Creating Skills

**When to create a Skill:**

Create a Skill when you have:
- ✅ A procedure repeated 2+ times
- ✅ A multi-step workflow with specific order
- ✅ Domain-specific knowledge (e.g., CV/ML evaluation protocols)
- ✅ Verification or validation procedures
- ✅ Standardized patterns (e.g., authentication flows)

**Do NOT create a Skill for:**
- ❌ One-off tasks or experiments
- ❌ Simple commands that don't need explanation
- ❌ Tasks that change too frequently to maintain

**Skill file structure:**

```markdown
# Skill Name: Brief Description

**Purpose:** What this skill accomplishes

**When to use:** Situations where this skill applies

**Prerequisites:**
- Required tools or dependencies
- Required data or context
- Required access/permissions

**Procedure:**
1. Step 1: Description
2. Step 2: Description
3. Step 3: Description

**Verification:**
- How to confirm the procedure worked
- Expected outputs or states

**Common issues:**
- Issue 1: Solution
- Issue 2: Solution

**Related skills:**
- Links to related Skills

**Last updated:** YYYY-MM-DD
```

**Example Skill:**

```markdown
# Verify 3D Bounding Box

**Purpose:** Verify that a 3D bounding box annotation is valid (coordinates, dimensions, format).

**When to use:** When working with 3D object detection data, before training or evaluation.

**Prerequisites:**
- 3D bounding box data (format: center_x, center_y, center_z, width, height, depth)
- Dataset metadata (coordinate system, units)

**Procedure:**
1. Check coordinate ranges match dataset bounds
2. Verify dimensions are positive
3. Validate format (numeric, correct number of values)
4. Check for outliers (dimensions > 3x mean or < 0.1x mean)
5. Verify rotation/quaternion if present (normalized)

**Verification:**
- All boxes pass validation
- Error report lists specific violations
- Statistics: count, mean dimensions, outliers

**Common issues:**
- Coordinate system mismatch: Check dataset metadata
- Negative dimensions: Usually indicates flipped coordinates

**Related skills:**
- Dataset integrity check
- Model evaluation protocol

**Last updated:** 2026-01-16
```

### 0.3.4 Skills Best Practices

**Naming and organization:**

1. **Be specific:** `verify-3d-bounding-box.md` not `verify-box.md`
2. **Group related Skills:** Use subdirectories for complex domains:
   ```text
   .cursor/skills/
   ├── cv/
   │   ├── verify-bounding-box-3d.md
   │   └── verify-segmentation-mask.md
   ├── ml/
   │   ├── evaluate-model.md
   │   └── dataset-split.md
   └── api/
       └── authentication-flow.md
   ```
3. **Keep Skills focused:** One procedure per Skill file
4. **Version control:** Commit Skills to Git (they're part of project knowledge)

**Writing Skills:**

1. **Be explicit:** Assume the agent knows nothing about the procedure
2. **Include examples:** Show expected inputs/outputs
3. **List edge cases:** Document common failures and solutions
4. **Keep them current:** Update Skills when procedures change
5. **Test them:** Verify Skills work by having agents use them

**Maintenance:**

- **Review quarterly:** Skills can become outdated as tools/processes evolve
- **Update dates:** Keep "Last updated" current for maintenance tracking
- **Remove obsolete Skills:** Delete Skills that are no longer relevant
- **Link related Skills:** Cross-reference to build knowledge networks

**Integration with prompts:**

Instead of:
```
❌ BAD: "Verify this bounding box [pastes procedure explanation]"
```

Use:
```
✅ GOOD: "Verify this bounding box using the verify-3d-bounding-box skill"
```

### 0.3.5 Skills Examples

**Common Skill categories:**

1. **Data validation:**
   - `verify-dataset-integrity.md`
   - `check-label-consistency.md`
   - `validate-data-split.md`

2. **Model evaluation:**
   - `evaluate-classification-model.md`
   - `compute-detection-metrics.md`
   - `compare-model-versions.md`

3. **Development workflows:**
   - `create-feature-branch.md`
   - `run-test-suite.md`
   - `prepare-pr-evidence.md`

4. **API/Integration:**
   - `setup-oauth-flow.md`
   - `test-api-endpoint.md`
   - `verify-webhook-signature.md`

5. **CV/ML specific:**
   - `verify-bounding-box-3d.md`
   - `validate-segmentation-mask.md`
   - `check-data-augmentation.md`

**Example: Dataset Integrity Check Skill**

```markdown
# Dataset Integrity Check

**Purpose:** Verify dataset is complete, consistent, and ready for training.

**When to use:** Before starting training runs or after dataset updates.

**Prerequisites:**
- Dataset path (root directory)
- Expected file structure (manifest or schema)

**Procedure:**
1. Check all required files exist (images, labels, metadata)
2. Verify file formats (images loadable, labels parseable)
3. Validate label consistency (all classes present, no orphans)
4. Check file integrity (no corrupt images, valid checksums)
5. Verify train/val/test splits (no overlap, coverage)

**Verification:**
- Report: missing files, corrupt files, inconsistencies
- Statistics: file counts, class distribution, split sizes
- All checks pass or actionable error list

**Common issues:**
- Missing label files: Check naming convention
- Corrupt images: Re-download or regenerate
- Split overlap: Regenerate splits

**Related skills:**
- Verify 3D bounding box
- Model evaluation protocol

**Last updated:** 2026-01-16
```

### 0.3.6 Skills Integration with MCP

**Combined workflow:**

Skills and MCP work together:
1. **Skills** define reusable procedures (what to do)
2. **MCP** provides data access (how to get inputs)
3. **Together:** Skills use MCP to fetch data, then apply procedures

**Example: Dataset Verification Workflow**

```
Skill: "Dataset Integrity Check"
  → Uses Filesystem MCP to read dataset manifest
  → Uses Postgres MCP to query metadata/statistics
  → Applies verification rules (from Skill)
  → Uses Filesystem MCP to write report
  → Returns structured validation results
```

**Pattern:**

1. **MCP fetches context:** Files, database queries, API responses
2. **Skill applies procedure:** Standardized workflow with the data
3. **MCP stores results:** Write outputs, update databases, create artifacts

**Rule:** Skills should prefer MCP over manual data access whenever possible. If a Skill needs data, it should specify which MCP server to use.

**Best practices:**

- **Skills reference MCP:** Document required MCP servers in Skill prerequisites
- **MCP-enabled Skills:** Design Skills to leverage MCP for data access
- **Reusable combinations:** Common Skill+MCP patterns can become higher-level Skills

### 0.3.7 MCP Overview (Cursor-Specific)

**What is MCP in Cursor?**

MCP (Model Context Protocol) is Cursor's native protocol for connecting AI agents to external tools and data sources. Instead of pasting large files, copying database results, or manually fetching API data, MCP servers provide structured, on-demand access to these resources.

**Why use MCP?**

- **Token efficiency:** Avoid pasting large files/data into chat (saves 50-90% tokens on data-heavy tasks)
- **Real-time data:** Access live databases, APIs, and Git state without manual steps
- **Structured access:** Tools expose clean interfaces (queries, commands) instead of raw dumps
- **Security:** Controlled access scopes per MCP server (no accidental secret exposure)
- **Reproducibility:** MCP calls are explicit and traceable in conversation history

**Core principle:** If data exists in a structured system (DB, Git, API), use MCP to access it. Never paste when MCP can retrieve.

### 0.3.8 MCP Setup in Cursor

**Configuration location:** `~/.cursor/mcp.json` (or Cursor Settings → Features → MCP)

**Basic configuration structure:**

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "ALLOWED_DIRECTORIES": ["/home/alfonso/dev/repos", "/home/alfonso/datasets"]
      }
    },
    "git": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-git"],
      "env": {
        "GIT_REPO_PATH": "/home/alfonso/dev/repos"
      }
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://localhost:5432/mydb"
      }
    },
    "browser": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-browser"]
    }
  }
}
```

**Security rules:**
- Never store secrets in `mcp.json` (use environment variables or Cursor's secret management)
- Restrict filesystem MCP to specific directories (never `~` or `/`)
- Use read-only database connections when possible
- Review MCP server permissions before enabling

### 0.3.9 Common MCP Servers for Cursor

**Essential servers (recommended setup):**

1. **Filesystem MCP** (`@modelcontextprotocol/server-filesystem`)
   - **Use case:** Read/write files without pasting content
   - **When to use:** Reading configs, logs, data files, writing generated code
   - **Token savings:** 70-90% on file-heavy tasks
   - **Example:** "Read the database config from `config/database.yml`" → MCP fetches, no paste needed

2. **Git MCP** (`@modelcontextprotocol/server-git`)
   - **Use case:** Query Git history, branches, diffs, commit info
   - **When to use:** Understanding code evolution, finding when bugs were introduced, reviewing PRs
   - **Token savings:** 60-80% on Git queries
   - **Example:** "Show me commits that touched `src/auth.py` in the last month" → MCP queries Git directly

3. **PostgreSQL MCP** (`@modelcontextprotocol/server-postgres`)
   - **Use case:** Query databases without exporting/pasting results
   - **When to use:** Data analysis, schema inspection, running queries for context
   - **Token savings:** 80-95% on database work
   - **Example:** "What tables exist in the production schema?" → MCP queries, returns structured results

4. **Browser MCP** (`@modelcontextprotocol/server-browser`)
   - **Use case:** Navigate web pages, extract content, interact with web apps
   - **When to use:** Testing web UIs, extracting docs from websites, verifying deployments
   - **Token savings:** 50-70% on web-related tasks
   - **Example:** "Check if the API docs at https://api.example.com/docs are up to date" → MCP navigates and extracts

**Optional servers (add as needed):**

- **SQLite MCP:** For local SQLite databases
- **GitHub MCP:** Direct GitHub API access (issues, PRs, repos)
- **Slack MCP:** Team communication integration
- **Custom MCP servers:** Build your own for project-specific tools

### 0.3.10 MCP Usage Patterns

**Pattern 1: File Access (Replace Pasting)**

❌ **Bad (token waste):**
```
User: Here's my config file [pastes 200 lines of YAML]
```

✅ **Good (MCP):**
```
User: Read the config from config/database.yml and suggest optimizations
→ Cursor uses filesystem MCP to read file
→ No tokens wasted on file content in prompt
```

**Pattern 2: Database Queries (Replace Exports)**

❌ **Bad (manual work):**
```
User: I exported the users table [pastes CSV], analyze this
```

✅ **Good (MCP):**
```
User: Query the users table for accounts created in the last week and analyze patterns
→ Cursor uses Postgres MCP to query
→ Returns structured results, no CSV paste
```

**Pattern 3: Git History (Replace Manual Git Commands)**

❌ **Bad (context switching):**
```
User: I ran `git log --oneline src/auth.py` [pastes output], when was this last changed?
```

✅ **Good (MCP):**
```
User: When was src/auth.py last modified and by whom?
→ Cursor uses Git MCP to query history
→ Returns structured commit info
```

**Pattern 4: Web Content (Replace Copy-Paste)**

❌ **Bad (manual extraction):**
```
User: I copied the API docs [pastes 500 lines], update my client code
```

✅ **Good (MCP):**
```
User: Navigate to https://api.example.com/docs and update the client to match the latest API
→ Cursor uses Browser MCP to fetch docs
→ Extracts relevant sections automatically
```

### 0.3.11 MCP Best Practices

**When to use MCP:**
- ✅ Accessing files > 50 lines
- ✅ Querying databases (any size)
- ✅ Reading Git history or diffs
- ✅ Fetching web content
- ✅ Accessing APIs with structured responses
- ✅ Reading logs or config files

**When NOT to use MCP:**
- ❌ Small snippets (< 20 lines) — paste is fine
- ❌ One-off data that doesn't exist in a system
- ❌ Secrets or sensitive data (use secure methods)
- ❌ Binary files (MCP may not handle well)

**Token optimization with MCP:**
1. **Prefer MCP over pasting** for any structured data source
2. **Use MCP queries** to filter data before it enters context
3. **Chain MCP calls** when multiple sources are needed (parallel when possible)
4. **Cache MCP results** in conversation when same data is referenced multiple times

**Security checklist:**
- [ ] MCP servers restricted to necessary directories/files
- [ ] Database connections use read-only credentials when possible
- [ ] No secrets in `mcp.json` (use env vars or Cursor secrets)
- [ ] Review MCP server permissions before enabling
- [ ] Audit MCP access logs periodically

### 0.3.12 MCP Troubleshooting

**Common issues:**

1. **MCP server not found**
   - **Fix:** Ensure `npx` is available and server package is published
   - **Check:** `npx -y @modelcontextprotocol/server-filesystem --help`

2. **Permission denied (filesystem)**
   - **Fix:** Adjust `ALLOWED_DIRECTORIES` in MCP config
   - **Check:** Ensure paths are absolute and accessible

3. **Database connection fails**
   - **Fix:** Verify connection string and credentials
   - **Check:** Test connection outside Cursor first

4. **MCP calls slow**
   - **Fix:** Use parallel MCP calls when possible
   - **Check:** Server may be rate-limited or network issues

**Verification:**
- Test MCP servers in Cursor's MCP panel (Settings → Features → MCP)
- Check Cursor logs for MCP errors
- Verify MCP tools appear in Cursor's tool list


## 0.4) Verification-First Review (AI/Agent Era)

**Problem:** AI/agents increase code volume and plausibility, making traditional line-by-line **CR** (Code Review) a weak primary quality gate.

**Policy:** In all repos, shift from "read every line" to **verification-first**:
- CI (Continuous Integration) gates are the first-class quality signal.
- Human review focuses on **architecture, security, and risk**, not syntax nitpicks.
- Every PR must provide **evidence**, not just explanation.

### 0.4.1 Mandatory PR evidence package

Every PR must include, in the description (or PR template fields):

1. **Intent**
   - What changed (1–5 bullets)
   - Why it changed (1–3 bullets)
2. **Verification commands (copy/paste runnable)**
   - `ruff check .`
   - `pytest -q`
   - `mypy .` or `pyright` (project standard)
   - any project-specific checks (e.g., `docker compose up`, `make test`)
3. **Result evidence**
   - Status checks green
   - Screenshots / short logs for UI or critical behavior changes
4. **Risk statement**
   - Risk: Low | Medium | High
   - Rollback plan (mandatory if Medium/High)
5. **AI disclosure (when applicable)**
   - Which parts were AI-assisted (brief, not verbose)

**Merge rule:** No evidence → no merge.

### 0.4.2 Preview environments (when applicable)

For web/API repos, prefer PR-specific preview environments (or containerized local preview):

- Reviewer verifies **behavior**, not just code.
- Merge is blocked unless preview passes.

### 0.4.3 Diff size discipline

Agents can generate huge diffs. To keep review/verification reliable:

- Prefer **small PRs** (single concern).
- If a PR is large, split into staged PRs:
  1) scaffolding + tests
  2) core implementation
  3) refactor/cleanup

### 0.4.4 Branch protection alignment

Enforce with GitHub Rulesets / Branch protection:

- no direct pushes to protected branches
- required approvals
- required checks (strict / up-to-date branch)
- no bypass unless explicitly justified and documented


## 1) Operating Principles

* **Reality-first:** Never invent facts, sources, file paths, or results.
* **Grounding by default:** Use retrieval (web/RAG/MCP) and cite sources.
* **Prefer refusal over fabrication:** If uncertain, say "I don't know."
* **Explicit Instruction Levels:** Respect the requested level (Minimal/Thorough/Comprehensive). Do not over-explain if "Minimal" is requested.
* **Reproducibility:** Commands, paths, and versions must be concrete.

---
## 2) Non-Negotiable Boundaries

The assistant must not:
* Fabricate citations or claim to have run commands it did not run.
* Modify or propose destructive system steps without risk labeling + prerequisites.
* Output security-sensitive exploit instructions.
* Present speculation as fact.
* **Stop early due to context limits:** For long tasks, the assistant must explicitly plan context compacting or chaining.

---
## 3) Prompt-Quality Gate (Mandatory)

Before answering, classify the prompt as:
1. **Compliant**: Proceed.
2. **Partially compliant**: Proceed *only* after asking for missing mandatory fields.
3. **Non-compliant**: Refuse to proceed until rewritten per the guide.

### Mandatory fields for most technical work

* **Goal:** What is the objective?
* **Instruction Level:** Minimal, Thorough, or Comprehensive? (Crucial for Claude 4.x).
* **Environment:** OS, language, versions.
* **Constraints:** Do-not-touch, time, style.
* **Output Format:** JSON, Diff, Checklist.
* **Success Criteria:** How to verify.

---
## 4) Standard Prompt Template (Quick)

Use this as the default skeleton (Updated 2026):

```
ROLE: [who you want the assistant to act as]
GOAL: [what you want]
INSTRUCTION LEVEL: [Minimal | Thorough | Comprehensive]
CONTEXT: [project background + what’s already done]
ENV: [OS, tools, versions]
CONSTRAINTS: [hard rules, what not to change]
INPUTS: [files/snippets/logs]
OUTPUT: [exact format]
ACCEPTANCE: [how to verify success]

```

---
