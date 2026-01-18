# Cursor AI Coding Policy

**Status:** Authoritative
**Last updated:** 2026-01-18

**Scope:** This policy governs the use of **Cursor** as the **only AI coding tool** in this development environment.

---

## Index

- [AI Coding Policy](#ai-coding-policy)
  - [Index](#index)
  - [Core Principle](#core-principle)
  - [Sandbox Restriction](#sandbox-restriction)
  - [Hard Rules (Non-Negotiable)](#hard-rules-non-negotiable)
  - [Daily Workflow](#daily-workflow)
    - [Task Card Prompt Template](#task-card-prompt-template)
    - [Review-Before-Apply Workflow](#review-before-apply-workflow)
  - [Cursor Modes](#cursor-modes)
  - [Guardrails](#guardrails)
    - [Repo-Level Rules File](#repo-level-rules-file)
  - [Model Usage](#model-usage)
  - [Git Discipline](#git-discipline)
  - [MCP (Model Context Protocol)](#mcp-model-context-protocol)
  - [Summary](#summary)

---

## Core Principle

**Best practice with Cursor (as an AI coding IDE) is to treat it like a junior engineer with very fast typing:** you control scope, you demand diffs, you gate everything with tests, and you never let it wander outside the repo and your rules.

**Mental model:**
- Cursor is a **tool**, not an autonomous agent
- You maintain **control** over scope and changes
- **Review before apply** — never auto-apply large changes
- **Test-driven** — every change must have validation
- **Diff-first** — see changes before committing

---

## Sandbox Restriction

**Hard boundary:** Cursor is restricted to the **only sandbox** in the system:

```
/home/alfonso/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/
```

**Rules:**
- Cursor MUST NOT access files outside this sandbox
- No `~/.config` changes
- No system changes
- No random scripts outside the repo
- All work happens within the sandbox directory

**Enforcement:** This is a non-negotiable boundary. Any attempt to access files outside the sandbox must be rejected.

---

## Hard Rules (Non-Negotiable)

1. **One task per prompt.** No "while you're at it…".
2. **Diff-first.** Require "plan → diff → apply". Never "rewrite the project".
3. **Small patches.** Max ~200 lines changed per iteration.
4. **Tests or a repro command every time.** If no tests exist, require a minimal repro command.
5. **No new dependencies unless explicitly requested.**
6. **Never touch files outside the repo.** (No `~/.config`, no system changes, no random scripts.)

---

## Daily Workflow

### Task Card Prompt Template

Use English for reliability. Paste this template for each task:

```text
Task: <one sentence>

Context:
- Repo: /home/alfonso/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code
- Constraints: small change, no new deps, no refactors unless asked, follow existing style.
- Definition of done: <specific observable outcome>

Process:
1) Ask 2–5 clarifying questions if needed.
2) Propose a short plan (bullets).
3) Produce a unified diff only.
4) Tell me exact commands to run to validate.
Do not modify files outside the repo.
```

### Review-Before-Apply Workflow

**You apply changes only after review:**

1. Cursor proposes a diff
2. **You review the diff quickly**
3. **You run the validation commands**
4. Only then: iterate or approve

This prevents "AI churn" and maintains control.

---

## Cursor Modes

**Use the right mode for the task:**

- **Ask/Chat:** Architecture, design decisions, prompt shaping, "what to do next"
- **Edit:** Small surgical edits in one file
- **Agent:** Only when you have a tight task card + you can review diffs. Otherwise it will roam.

**Default:** Use **Ask + Edit** for most work. Use Agent only when scoped tightly.

---

## Guardrails

### Repo-Level Rules File

In the repo root, keep one authoritative file that Cursor must follow:

- `AI_RULES.md` or `.cursorrules`

**Content should be short and enforceable:**

- Scope boundaries (sandbox restriction)
- Style + formatting (black/ruff if Python, etc.)
- No refactors unless requested
- Diff-first workflow
- Test command requirements

Cursor respects these much better than repeating rules each time.

**Example `.cursorrules`:**

```markdown
# Cursor Rules for Sandbox

## Scope
- Work only within this repo: /home/alfonso/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/
- Never access files outside this directory

## Workflow
- Always propose diffs before applying
- Max 200 lines changed per iteration
- Include test command or repro steps

## Style
- Follow existing code style
- No refactors unless explicitly requested
- No new dependencies without approval
```

### .claudeignore Configuration

**Purpose:** Exclude files and directories from Claude Code's context to reduce token usage and prevent irrelevant files from being included.

**Location:** Create `.claudeignore` in the sandbox repo root:
```
/home/alfonso/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/.claudeignore
```

**Configuration rules:**

1. **Always exclude:**
   - Build artifacts (`dist/`, `build/`, `__pycache__/`, `*.pyc`, `*.pyo`, `*.pyd`)
   - Dependencies (`node_modules/`, `.venv/`, `venv/`, `env/`)
   - IDE files (`.vscode/`, `.idea/`, `*.swp`, `*.swo`, `*~`)
   - Git metadata (`.git/`, `.gitignore`)
   - Large data files (`*.csv`, `*.json` > 1MB, `*.parquet`, `*.h5`, `*.pkl` > 10MB)
   - Logs (`*.log`, `logs/`)
   - Temporary files (`tmp/`, `temp/`, `*.tmp`)

2. **Exclude for token efficiency:**
   - Large generated files (auto-generated code, minified assets)
   - Test fixtures with large datasets
   - Documentation builds (`docs/_build/`, `site/`)

3. **Never exclude:**
   - Source code (`.py`, `.ts`, `.js`, `.cpp`, `.h`, etc.)
   - Configuration files (`pyproject.toml`, `package.json`, `CMakeLists.txt`)
   - Tests (`test_*.py`, `*.test.ts`, `*.spec.ts`)
   - Documentation (`README.md`, `docs/`)

**Example `.claudeignore`:**

```gitignore
# Build artifacts
dist/
build/
__pycache__/
*.pyc
*.pyo
*.pyd
*.so
*.dylib
*.dll

# Dependencies
node_modules/
.venv/
venv/
env/
.python-version

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Git
.git/
.gitignore

# Large data files (exclude if > 1MB)
*.csv
*.parquet
*.h5
*.pkl
*.hdf5

# Logs and temporary files
*.log
logs/
tmp/
temp/
*.tmp

# Generated files
*.min.js
*.min.css
site/
docs/_build/
```

**Best practices:**
- Review `.claudeignore` periodically to ensure it's not excluding needed files
- Use patterns, not individual files
- Document why specific patterns are excluded
- Keep `.claudeignore` in version control

### Cursor Configuration Best Practices

**Cursor settings file:** `.cursor/settings.json` (in sandbox repo root)

**Required settings for strict policy compliance:**

```json
{
  "cursor.ai.model": "claude-3.5-sonnet",
  "cursor.ai.maxTokens": 8000,
  "cursor.ai.temperature": 0.1,
  "cursor.ai.enableCodebaseIndexing": true,
  "cursor.ai.codebaseIndexingMaxFiles": 1000,
  "cursor.ai.excludeFromIndexing": [
    "**/node_modules/**",
    "**/.venv/**",
    "**/dist/**",
    "**/build/**",
    "**/__pycache__/**",
    "**/*.pyc",
    "**/*.log",
    "**/tmp/**",
    "**/temp/**"
  ],
  "cursor.ai.enableMCP": true,
  "cursor.ai.mcpServers": {
    "filesystem": {
      "enabled": true,
      "restrictToSandbox": true,
      "sandboxPath": "/home/alfonso/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/"
    }
  },
  "cursor.ai.autoApply": false,
  "cursor.ai.requireReview": true,
  "cursor.ai.maxDiffLines": 200,
  "cursor.ai.enableContextRules": true,
  "cursor.ai.contextRulesPath": ".cursorrules"
}
```

**Key configuration principles:**

1. **Model selection:**
   - Use Claude 3.5 Sonnet for code changes (best correctness)
   - Use faster models only for text/comment updates
   - Don't switch models mid-task

2. **Token management:**
   - Set reasonable `maxTokens` (8000 default)
   - Enable codebase indexing for better context
   - Exclude large/generated files from indexing

3. **Sandbox enforcement:**
   - Enable MCP filesystem server
   - Restrict filesystem access to sandbox path only
   - Never allow full system access

4. **Workflow control:**
   - `autoApply: false` — always require manual review
   - `requireReview: true` — enforce review-before-apply
   - `maxDiffLines: 200` — enforce small patch policy

5. **Context management:**
   - Enable context rules (`.cursorrules`)
   - Use `.claudeignore` to exclude irrelevant files
   - Limit codebase indexing to relevant files

**Cursor workspace settings (`.vscode/settings.json`):**

```json
{
  "cursor.ai.enable": true,
  "cursor.ai.sandboxPath": "/home/alfonso/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/",
  "cursor.ai.strictMode": true,
  "files.exclude": {
    "**/__pycache__": true,
    "**/*.pyc": true,
    "**/node_modules": true,
    "**/.venv": true
  },
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/.venv/**": true,
    "**/dist/**": true,
    "**/build/**": true
  }
}
```

**Enforcement checklist:**
- [ ] `.claudeignore` exists in sandbox repo root
- [ ] `.cursor/settings.json` configured with strict settings
- [ ] `.vscode/settings.json` includes sandbox path restriction
- [ ] `autoApply: false` and `requireReview: true` set
- [ ] MCP filesystem server restricted to sandbox path
- [ ] Codebase indexing excludes build artifacts and dependencies

---

## Model Usage

**Simple policy:**

- **Default model:** Whatever gives you **best correctness** for code changes (often the strongest reasoning model you have enabled)
- **Fast model:** For rewriting small text, renaming, comments, doc updates

**Rule:** Don't bounce models mid-task unless you're stuck; it increases inconsistency.

---

## Git Discipline

**For every AI change:**

1. `git status` clean before starting
2. Make change
3. Review diff: `git diff`
4. Run validation command
5. Commit with a specific message

**If Cursor produces a big change:** Discard it immediately:

```bash
git restore .  # if you haven't committed
```

**Never commit without:**
- Reviewing the diff
- Running validation commands
- Confirming the change is scoped and correct

---

## MCP (Model Context Protocol)

**MCP = Model Context Protocol**

MCP servers in Cursor provide structured access to tools (Databases, Git, APIs, browsers) rather than pasting data.

**When to use MCP:**
- Accessing files > 50 lines (use Filesystem MCP)
- Querying databases (use Postgres MCP)
- Reading Git history (use Git MCP)
- Fetching web content (use Browser MCP)

**Configuration:** See `prompts-policy.md` for detailed MCP setup and usage patterns.

**Security:** MCP servers must be restricted to necessary directories/files. Never allow full system access.

---

## Summary

**Key principles:**
1. Cursor is a **junior engineer with very fast typing** — you control scope
2. **Sandbox only:** `/home/alfonso/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/`
3. **Diff-first:** Always review before applying
4. **Small patches:** Max ~200 lines per iteration
5. **Test-driven:** Every change must have validation
6. **One task per prompt:** No scope creep

**Workflow:**
1. Use task card template
2. Cursor proposes plan + diff
3. You review and validate
4. Apply only after approval
5. Commit with clear message

This discipline prevents time waste and maintains code quality.

---

**Related policies:**
- `prompts-policy.md` — Detailed prompt engineering and MCP usage
- `versioning-and-documenting-policy.md` — Git, source control, and versioning policies
- `security-policy.md` — Security and compliance baseline
