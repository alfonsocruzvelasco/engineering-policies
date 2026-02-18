# Claude Code — Headless Mode

> **Canonical location:** `4-ml-systems-mlops/ai-assisted-engineering/claude-code-headless.md`
> **Frame:** Process & cognition — not tooling.

---

## One-sentence summary

Headless Claude is valuable because it lets humans slow down AI-assisted development without losing insight.

---

## What headless mode actually is (technical ground truth)

The `-p` / `--print` flag runs Claude Code non-interactively. Claude reads a prompt, processes it, writes to stdout, and exits. No interactive session. No prompt loop.

> **Note from official docs:** Anthropic now calls this the "CLI / Agent SDK" mode. "Headless mode" is the older name, but the `-p` flag and all behaviour are identical.

**Core syntax:**

```bash
# Ask a question — get an answer
claude -p "Explain the authentication flow in this codebase"

# Structured output
claude -p "List all TODO comments" --output-format json

# Real-time streaming
claude -p "Review recent changes" --output-format stream-json

# Pipe input in
git diff HEAD~5 | claude -p "Review these changes for regressions"

# Constrain tool access — read-only analysis, no writes
claude -p "Analyze codebase architecture" \
  --allowedTools "Read,Glob,Grep"

# Plan mode — read-only by design
claude --permission-mode plan -p "Analyze auth system for potential issues"

# Explicit disallow
claude -p "Review code" --disallowedTools "Write,Edit,Bash"
```

**Output formats:**

| Flag | Use |
|---|---|
| `text` (default) | Human-readable — good for reading output yourself |
| `json` | Structured — good for piping into scripts |
| `stream-json` | Newline-delimited JSON — good for real-time pipelines |

---

## Human point of view — why this matters

Headless mode forces a separation between **thinking** and **doing**.

It lets you say: *"Think. Explain. Plan. But do not act."*

That separation is rare and valuable. Most AI tools blur intention, execution, and responsibility into a single reactive loop. Headless mode breaks that loop deliberately.

---

## What it adds to the process (human-centric)

### 1 — Restores intentionality

Interactive agents encourage reactive iteration. You see output, you react, the agent acts. Headless mode restores deliberate intent.

You decide:
- when thinking happens
- when action is allowed
- when responsibility transfers to you

### 2 — Makes reasoning inspectable

Because output is explicit, textual, and capturable as an artifact, you can read it calmly, disagree with it, or discard it. No pressure to "accept and move on."

### 3 — Reinforces human authority

Headless mode says: AI may propose, AI may analyze, AI may plan — but AI may not execute unless you explicitly grant it. This matches the core stance: **the human is the final integrator.**

### 4 — Fits naturally into professional workflows

It behaves like a design review, a pre-mortem, or a second brain during planning — not like an autonomous developer, a background process, or a silent decision-maker.

---

## Relationship to other concepts

### With Rodney (verification)

```
Claude -p (headless)  →  reasoning & planning (output)
         |
    Human reviews
         |
    Rodney            →  reality check & verification
```

Human in the middle, always.

### With Martin Fowler's "middle loop"

```
Claude headless  =  thinking loop
Tests / Rodney   =  verification loop
```

Together they define a controlled middle loop where speed exists, but trust is earned incrementally.

---

## Permission model — the key levers

This is where human authority is technically enforced, not just philosophically asserted.

| Mode | What it does | When to use |
|---|---|---|
| `--allowedTools Read,Glob,Grep` | Read-only analysis | Understanding codebases, audits |
| `--permission-mode plan` | Read-only, explicit plan output | Architecture reviews, pre-mortems |
| `--permission-mode acceptEdits` | Auto-accepts file edits | Trusted batch refactors (with caution) |
| `--disallowedTools Write,Edit,Bash` | Blocks specific capabilities | Reviews where no changes should land |
| `--dangerously-skip-permissions` | No permission checks | CI containers only — never local |

The default (no flags) still asks for permission at each action. The flags are how you shift that dial.

---

## Decision rule — when to use headless vs interactive

**Use headless (`claude -p`) when:**
- You want a read-only analysis you'll evaluate before acting
- You're scripting a review step in CI (code review, security audit)
- You're generating a plan or architecture proposal to review before acting
- You want output as an artifact (JSON report, markdown doc, structured log)
- You're doing batch analysis across multiple files

**Use interactive mode when:**
- You're pairing on a problem in real time
- You're debugging and need conversational back-and-forth
- You want to explore a solution space before committing to a direction

**The tell:** if you'd want to read the output before deciding what to do next — use headless.

---

## What this is not

- Not about productivity
- Not about automation
- Not about replacing judgment
- Not about faster coding

It's about **clarity before commitment.**

---

## Practical patterns for your workflow

### Pattern 1 — Pre-commit inspection

```bash
git diff --staged | claude -p \
  "Review these staged changes. Flag anything unintentional, \
   that breaks naming conventions, or introduces side effects." \
  --allowedTools "Read,Grep"
```

You read the output. You decide whether to commit.

### Pattern 2 — Architecture pre-mortem

```bash
claude --permission-mode plan -p \
  "Analyze the current auth module. Identify failure modes, \
   coupling risks, and missing test coverage."
```

Output is a plan artifact. You review it in a design session before writing a line of code.

### Pattern 3 — Structured audit for CI

```bash
claude -p "Review src/ for security issues — SQL injection, \
           unvalidated input, exposed secrets." \
  --allowedTools "Read,Glob,Grep" \
  --output-format json > security-report.json
```

Runs in CI. Human reviews the report. Nothing executes without a human decision.

### Pattern 4 — Paired with Rodney

```bash
# Step 1 — Claude proposes
claude -p "Suggest a refactor plan for payment_processor.py" \
  --allowedTools "Read,Glob" > refactor-plan.md

# Step 2 — Human reviews refactor-plan.md

# Step 3 — Human implements (or approves Claude implementation)

# Step 4 — Rodney verifies
```

---

## Alignment with "tests are law"

Headless mode is the planning complement to test-driven development.

| TDD principle | Headless equivalent |
|---|---|
| Write the test before the code | Generate the plan before the action |
| Tests define expected behavior | Plan output defines expected change |
| Red → Green → Refactor | Inspect → Decide → Execute |
| Tests are the source of truth | Human review is the gate |

Tests don't lie. Neither does a read-only plan that hasn't touched your codebase yet.

---

## What to watch out for

- **Headless doesn't persist between sessions** — each `-p` invocation is stateless. Use `--resume <session-id>` if you need continuity across calls.
- **`--dangerously-skip-permissions` is for isolated CI containers only** — never run it locally.
- **Read-only is not the same as safe** — Claude can still read secrets or credentials. Scope `--allowedTools` carefully in CI.
- **Output format matters for piping** — `json` and `stream-json` are for programmatic use; `text` is for human reading.

---

## Sources

- [Claude Code official docs — Run programmatically](https://code.claude.com/docs/en/headless)
- Martin Fowler — "middle loop" concept in AI-assisted development
