# Cursor AI Coding Policy

**Status:** Authoritative
**Last updated:** 2026-01-18

**Scope:** This policy governs the use of **Cursor** as the **only AI coding tool** in this development environment.

---

## Index

- [Cursor AI Coding Policy](#cursor-ai-coding-policy)
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
- `versioning-security-and-documenting-policy.md` — Git and security policies
