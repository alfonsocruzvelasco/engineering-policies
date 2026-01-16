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

---

### Core policy (operating system)

- [0) Operating System (Start Here)](#0-operating-system-start-here)
  - [0.1) Token Strategy](#01-token-strategy-for-current-subscriptions)
  - [0.2) CV/ML Execution Mode](#02-cvml-execution-mode)
  - [0.3) Agentic Architecture (Skills & MCP)](#03-agentic-architecture-skills--mcp)
    - [0.3.1 MCP Overview (Cursor-Specific)](#031-mcp-overview-cursor-specific)
    - [0.3.2 MCP Setup in Cursor](#032-mcp-setup-in-cursor)
    - [0.3.3 Common MCP Servers for Cursor](#033-common-mcp-servers-for-cursor)
    - [0.3.4 MCP Usage Patterns](#034-mcp-usage-patterns)
    - [0.3.5 MCP Best Practices](#035-mcp-best-practices)
    - [0.3.6 MCP Troubleshooting](#036-mcp-troubleshooting)
    - [0.3.7 MCP Integration with Skills](#037-mcp-integration-with-skills)
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

### 0.3.1 MCP Overview (Cursor-Specific)

**What is MCP in Cursor?**

MCP (Model Context Protocol) is Cursor's native protocol for connecting AI agents to external tools and data sources. Instead of pasting large files, copying database results, or manually fetching API data, MCP servers provide structured, on-demand access to these resources.

**Why use MCP?**

- **Token efficiency:** Avoid pasting large files/data into chat (saves 50-90% tokens on data-heavy tasks)
- **Real-time data:** Access live databases, APIs, and Git state without manual steps
- **Structured access:** Tools expose clean interfaces (queries, commands) instead of raw dumps
- **Security:** Controlled access scopes per MCP server (no accidental secret exposure)
- **Reproducibility:** MCP calls are explicit and traceable in conversation history

**Core principle:** If data exists in a structured system (DB, Git, API), use MCP to access it. Never paste when MCP can retrieve.

### 0.3.2 MCP Setup in Cursor

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

### 0.3.3 Common MCP Servers for Cursor

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

### 0.3.4 MCP Usage Patterns

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

### 0.3.5 MCP Best Practices

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

### 0.3.6 MCP Troubleshooting

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

### 0.3.7 MCP Integration with Skills

**Combined workflow:**
1. **Skills** define reusable procedures (e.g., "How to verify a 3D bounding box")
2. **MCP** provides data access (e.g., read dataset, query database)
3. **Together:** Skills use MCP to fetch data, then apply procedures

**Example:**
```
Skill: "Verify dataset integrity"
  → Uses Filesystem MCP to read dataset manifest
  → Uses Postgres MCP to query metadata
  → Applies verification rules
  → Returns structured report
```

**Rule:** Skills should prefer MCP over manual data access whenever possible.

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
