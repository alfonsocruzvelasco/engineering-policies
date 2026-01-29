# Cursor AI Coding Policy

**Status:** Authoritative
**Last updated:** 2026-01-28

**Scope:** This policy governs the use of **Cursor** as the **only AI coding tool** in this development environment.

---

## Index

- [AI Coding Policy](#ai-coding-policy)
  - [Index](#index)
  - [Core Principle](#core-principle)
  - [Core Security Position](#core-security-position)
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
  - [Tool Use Security (API-Calling Agents)](#tool-use-security-api-calling-agents)
  - [Stewardship Model: Ownership Beyond Authorship](#stewardship-model-ownership-beyond-authorship)
  - [Verification-First Mindset](#verification-first-mindset)
  - [Operational Readiness Requirements](#operational-readiness-requirements)
  - [Summary](#summary)

---

## Core Principle

**AI coding has shifted software craftsmanship from "writing code" toward "specifying, verifying, and steering".** Best practice with Cursor (as an AI coding IDE) is to treat it like a junior engineer with very fast typing: you control scope, you demand diffs, you gate everything with tests, and you never let it wander outside the repo and your rules.

**Mental model:**
- Cursor is a **tool**, not an autonomous agent
- You maintain **control** over scope and changes
- **Review before apply** — never auto-apply large changes
- **Test-driven** — every change must have validation
- **Diff-first** — see changes before committing
- **Specification-first** — clarity of constraints, edge cases, and requirements is the bottleneck
- **Verification-first** — treat AI output like junior PR; verification becomes central

## Core Security Position

**AI is an untrusted junior engineer with tool access.**
It can generate vulnerabilities, misuse credentials, and be socially engineered via prompts.
All AI output must pass **security, verification, and operational gates**. Responsibility remains human.

**Primary Risk Categories:**

| Risk                        | What Happens                               | Control                                           |
| --------------------------- | ------------------------------------------ | ------------------------------------------------- |
| Secrets & data leakage      | Sensitive info exposed via prompts/logs    | Never share secrets, sanitize outputs             |
| Silent security regressions | Auth/validation removed or weakened        | Mandatory security review for sensitive areas     |
| Dependency injection        | Malicious or fake packages introduced      | SCA scan + human review                           |
| Code/command injection      | Unsafe shell/SQL/template construction     | Parameterization + input validation               |
| Prompt injection            | AI follows malicious embedded instructions | Treat retrieved text as data, never instructions  |

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

### Hybrid Intelligence Stack: Token Savings Strategy

**Core principle:** Use **paid frontier models as "senior consultants"** and **local models as "junior assistants"**.

With 64GB RAM and RTX 4070, you can reliably run local models (7B–14B, even 32B quantized) for routine tasks, saving 70–90% of token costs while maintaining quality where it matters.

#### Model Selection Matrix

| Task Type                | Model Location | Model Examples                    | Why                                    |
| ------------------------ | -------------- | --------------------------------- | -------------------------------------- |
| Large refactors          | Local (Ollama)  | qwen2.5-coder, deepseek-coder     | Cheap, iterative, good enough quality   |
| Test writing             | Local           | codellama, mistral                | Deterministic, repeatable patterns     |
| Code explanations        | Local           | qwen2.5-coder, deepseek-coder     | No need for frontier reasoning         |
| Boilerplate generation   | Local           | codellama, mistral                | Pattern matching, not complex logic    |
| Shell scripting          | Local           | qwen2.5-coder, codellama          | Simple, structured output              |
| Log analysis             | Local           | qwen2.5-coder, mistral            | No need for frontier models            |
| Architecture decisions   | Claude (paid)   | claude-3.5-sonnet                 | Top reasoning quality required         |
| Complex ML debugging     | Claude (paid)   | claude-3.5-sonnet                 | Better long-context reasoning          |
| Paper/code understanding | Claude (paid)   | claude-3.5-sonnet                 | Quality matters more than cost         |
| Design decisions         | Claude (paid)   | claude-3.5-sonnet                 | Strategic thinking required            |

#### Claude Code → Ollama Integration

**Cleanest win for token savings:**

Claude Code can be pointed to a **local Ollama server** that mimics the Anthropic API. When configured:

- Prompts are processed **locally**
- No Anthropic API calls
- **Zero Claude token cost** for those runs
- You still use the **Claude Code interface and agent workflow**
- The brain is a local model (qwen2.5-coder, deepseek-coder, codellama, mistral)

**Configuration:**
- Point Claude Code to local Ollama endpoint (typically `http://localhost:11434`)
- Use Anthropic API compatibility layer in Ollama
- Configure model selection per task type

**Hardware advantage:**
- 64GB RAM: Can run 7B–14B models fast
- RTX 4070: Can run even 32B quantized models if needed
- This is **plenty for coding agents**

#### Cursor Token Savings (Limited)

**Cursor is not designed to be fully local-first:**

- Some features still route through Cursor infrastructure
- Autocomplete / background intelligence may still hit their servers
- Hard to guarantee "no paid tokens used"

**Strategy:** With Cursor, you can **reduce usage** but not eliminate it. Use Cursor for complex tasks where quality matters, and route routine work through Claude Code → Ollama.

#### Token Efficiency Best Practices

1. **Use `.claudeignore`** to exclude irrelevant files (see `.claudeignore` Configuration section)
2. **Route routine tasks to local models** (refactors, tests, boilerplate)
3. **Reserve paid models for high-value tasks** (architecture, complex debugging, design)
4. **Don't bounce models mid-task** unless stuck; it increases inconsistency
5. **Monitor token usage** to identify optimization opportunities

#### Default Model Selection

- **Default model:** Whatever gives you **best correctness** for code changes (often the strongest reasoning model you have enabled)
- **Fast model:** For rewriting small text, renaming, comments, doc updates
- **Local model:** For routine, iterative tasks where quality is "good enough"

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

## Using AI Tools for Structured ML/CV Engineering

### Core Mental Model

**Modern ML/CV engineers don't just call models — they build structured systems around models.**

When using AI tools (Cursor, Claude, etc.) for ML/CV work, focus on building **structured pipelines**, not notebooks or ad-hoc scripts.

### What AI Tools Should Help You Build

#### A. Reusable Modules

Use AI tools to create composable units:

```
src/
 ├── data/
 │   ├── dataset_loader.py
 │   ├── augmentations.py
 │   └── splits.py
 ├── models/
 │   ├── model_wrapper.py
 │   └── architectures.py
 ├── inference/
 │   └── inference_pipeline.py
 ├── evaluation/
 │   └── metrics.py
 └── pipelines/
     └── training_pipeline.py
```

**Not:** One giant notebook or script with everything inside.

#### B. Deterministic Workflows

Use AI tools to implement:
- Validation loops (dataset sanity checks, shape checks, distribution checks)
- Structured outputs (structured predictions + logs)
- Evaluation gates before deployment

**Philosophy:** Never trust raw model output. Always verify.

#### C. Tool-Using Pipelines

Build systems where components call each other:
- Load images → Run OpenCV transforms → Call PyTorch models → Save predictions

**Architecture thinking:** Model is one step inside a larger system.

### What You Do NOT Need AI Tools For

**Do not use AI tools to:**
- ❌ Build fancy agent orchestration frameworks
- ❌ Create general-purpose AI agents
- ❌ Become a "Claude Code power user"

That's tool specialization, not ML engineering. Use AI tools **as helpers** to build structured ML/CV systems, not as your career focus.

### The Correct Integration

When using AI tools, translate agent concepts to ML/CV equivalents:

| Agent/Skills Concept | ML/CV Equivalent You Should Build |
| -------------------- | ---------------------------------- |
| Skill                 | Reusable pipeline module            |
| Agent workflow        | Data → Model → Evaluation pipeline  |
| Guardrails            | Data validation + metrics thresholds |
| Tool calling          | Calling CV libraries + models       |
| Memory                | Experiment tracking (MLflow, W&B)   |
| Structured output     | Structured predictions + logs       |

**Translation that matters:**
> "How do I build **structured ML systems** instead of messy notebooks?"

### Practical Action

**Use AI tools to write CV projects as structured pipelines, not notebooks.**

**Instead of asking AI to:**
```
"Write a notebook that does everything"
```

**Ask AI to:**
```
"Create a structured pipeline with:
- src/data/dataset_loader.py
- src/models/model_wrapper.py
- src/inference/inference_pipeline.py
- src/evaluation/metrics.py
- src/pipelines/training_pipeline.py"
```

**That is the real skill** all these agent ecosystems are secretly training.

### Bottom Line

You don't need to become an "agent expert."

You need to absorb this engineering principle:

> **AI systems = modular, testable, repeatable pipelines — not prompts, not scripts, not notebooks.**

That mindset is what separates:
**Beginner ML user** → **ML/CV Engineer**

See `mlops-policy.md` Section 1.1 for detailed guidance on structured ML/CV engineering.

---

## Tool Use Security (API-Calling Agents)

LLM agents that call APIs or run tools introduce **server-side execution risk**.

**Threat Reality:**
Research shows LLM agents can be manipulated into executing harmful tool actions even when they "recognize" the request is malicious. Tool access turns prompt injection into **remote code execution**.

**Policy Rules:**

**Principle: Capability ≠ Permission**
Just because an agent *can* call an API or tool does not mean it *should*.

**Hard Controls:**
* Tool access must be explicitly allowlisted
* Each tool call must be logged and auditable
* Sensitive tools (filesystem, shell, DB, cloud APIs) require:
  * explicit human approval or
  * policy-based runtime checks

**Never allow agents to:**
* Execute arbitrary shell commands
* Access credential stores
* Modify production data without approval
* Download or execute binaries

**Guardrails AI Integration:**
* Use Guardrails AI to enforce policy-based runtime checks for tool calls
* Configure Guardrails to validate tool usage against security policies
* Log all tool calls through Guardrails for audit trails
* Set up Guardrails to block unauthorized tool access automatically

**Guardrails AI Configuration:**
* Install Guardrails AI SDK in your project
* Define security policies for tool usage
* Integrate Guardrails validation in tool call paths
* Monitor and alert on policy violations
* See `security-policy.md` Section 8 for detailed API-Calling Agents security rules

---

## Agent Orchestration and Artifact Governance

When AI introduces **agents** (multi-step tool-using workflows) and **artifacts** (generated code, configs, datasets, model checkpoints, run outputs), the engineering standard is to separate concerns into four layers:

1. **Tool interface layer — MCP (Model Context Protocol):** Standardize how agents access tools (filesystem, git, databases, browsers) so capabilities are explicit, auditable, and portable.
2. **Durable workflow layer — Temporal (or equivalent):** Orchestrate long-running, retryable workflows with explicit state, idempotency, and compensation semantics.
3. **Observability layer — OpenTelemetry (OTel):** Trace agent runs end-to-end (spans for tool calls, sub-steps, retries) so failures can be debugged with evidence instead of narratives.
4. **Lineage layer — OpenLineage:** Capture artifact lineage (inputs → jobs/runs → outputs) so you can answer “what changed, what broke downstream, and why” deterministically.

**Policy stance:**
- For *coding inside Cursor*: keep the scope strict (sandbox-only) and use MCP servers only with least-privilege access.
- For *complex agentic automation*: prefer the four-layer model above rather than bespoke scripts that lack replayability, audit trails, and lineage.
- For *any artifact that can impact results* (datasets, checkpoints, configs): treat it as versioned output with traceability (who/what produced it, from which inputs, under which config).

---

## Stewardship Model: Ownership Beyond Authorship

**AI coding shifts ownership from authorship → stewardship.** When you merge AI-generated code, you own the system's behavior, not just the code itself.

### Stewardship Questions (Mandatory Before Merging)

Before merging any AI-assisted change, you MUST be able to answer:

1. **Why does it exist?** What problem does it solve? What is the business/technical rationale?
2. **What guarantees?** What are the correctness guarantees? What invariants must hold?
3. **Failure modes?** What are the known failure modes? What edge cases can break it?
4. **Tests/invariants?** What tests verify correctness? What invariants are checked?
5. **Rollback plan?** How do we rollback if this breaks? What is the recovery procedure?
6. **Who gets paged?** If this fails in production, who is responsible? What is the escalation path?

### Engineering Contract Expansion

The engineering "contract" expands from "deliver feature" to:

- **Spec quality:** Requirements are clear, constraints are explicit, edge cases are documented
- **Verification depth:** Tests cover happy path, edge cases, and failure modes
- **Operational readiness:** Instrumentation, flags, staged rollouts, runbooks are in place

### Responsibility Does Not Move

**AI does not absolve you of responsibility:**
- Engineer merging it owns it
- Reviewer and service owner share accountability
- Organization owns liability

**AI expands the risk surface** (security, dependency hallucinations, leakage), so responsibility gets stricter, not looser.

---

## Verification-First Mindset

**Craft implication:** With AI coding, verification becomes central. Tests become the steering wheel.

**Mandatory Verification Gates (Before Merge):**

AI-assisted code must pass:

**Security:**
* No secrets
* Input validation present
* Auth/authz verified
* Dependency scan clean

**Correctness:**
* Tests pass
* Edge cases covered

**Operations:**
* Logging + error handling
* Rollback possible

**Governance:**
* Human code review
* Branch protection + CI enforced

### Verification Checklist (Mandatory)

For every AI-generated change:

1. **Correctness verification:**
   - [ ] Tests pass (unit, integration, end-to-end)
   - [ ] Edge cases are tested
   - [ ] Failure modes are tested
   - [ ] Manual verification performed (if applicable)

2. **Security verification:**
   - [ ] No secrets or sensitive data exposed
   - [ ] Input validation present
   - [ ] Authentication/authorization checked (if applicable)
   - [ ] Dependency security scanned

3. **Operational verification:**
   - [ ] Logging/instrumentation added
   - [ ] Error handling present
   - [ ] Rollback mechanism exists
   - [ ] Monitoring/alerting configured (if production)

4. **Code quality verification:**
   - [ ] Code review performed (treat AI output like junior PR)
   - [ ] Style consistency maintained
   - [ ] Documentation updated
   - [ ] No obvious bugs or anti-patterns

### Instrumentation + Falsification Workflow

**For debugging and incident response:**
- Faster hypothesis generation (AI helps)
- Risk: over-trusting confident narratives
- **Craft implication:** Instrumentation + falsification workflow

**Workflow:**
1. Generate hypothesis (AI-assisted)
2. **Instrument** to gather evidence
3. **Falsify** the hypothesis with data
4. Iterate based on evidence, not assumptions

---

## Operational Readiness Requirements

**Before deploying AI-generated code to production, ensure operational readiness:**

### Pre-Deployment Checklist

- [ ] **Instrumentation:** Logging, metrics, traces configured
- [ ] **Feature flags:** Ability to disable/enable without redeploy
- [ ] **Staged rollouts:** Canary, blue-green, or gradual rollout capability
- [ ] **Runbooks:** Operational procedures documented
- [ ] **Rollback plan:** Tested procedure to revert changes
- [ ] **Monitoring:** Alerts configured for failure modes
- [ ] **Documentation:** What it does, why it exists, how to operate it

### Production Ownership

**You own outcomes in production, not just code/models.**

**Stable craft domains (mid–long term):**
- Problem framing & requirements clarity
- Architecture as tradeoff management
- Verification engineering (tests, invariants, debugging)
- Security & reliability engineering
- Production ownership / operations

**Less stable (will be automated):**
- Boilerplate implementation
- Repetitive glue
- Generic CRUD wiring

**Focus your craft on stable domains** where human judgment and ownership matter.

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
- `security-policy.md` — Security and compliance baseline (includes OAuth 2.0 for AI, SSH & Infrastructure Access, API-Calling Agents security, and Guardrails AI integration)

---

## AI Code Review Protocol

**Source:** GitHub's "Review AI-generated code" guide + industry best practices

**Core principle:** Reviewing AI-generated code requires different techniques than traditional code review. The volume and plausibility of AI code necessitates verification-first workflows.

### 1. Start with Functional Checks

**Always run automated tests and static analysis tools first.**

**Required checks:**
- [ ] Code compiles without errors
- [ ] All existing tests pass
- [ ] No new warnings introduced
- [ ] Static analysis clean (ruff, mypy, etc.)
- [ ] Security scans pass (CodeQL, Dependabot)

**Cursor integration:**
```bash
# Run before accepting any AI changes
pytest -v
ruff check .
mypy src/
```

**Example prompts for Cursor:**
- "What functional tests to validate this code change do not exist or are missing?"
- "What possible vulnerabilities or security issues could this code introduce?"

### 2. Verify Context and Intent

**Check that AI-generated code fits the purpose and architecture.**

**Verification questions:**
- Does this code solve the RIGHT problem?
- Does it follow our conventions and design patterns?
- What assumptions has the AI made?

**Context sources for Cursor:**
- README.md
- Architecture documentation
- Recent pull requests
- Existing code patterns

**Example prompts:**
- "How does this refactored code section align with our project architecture?"
- "What similar features or established design patterns did you identify and model your code after?"
- "When examining this code, what assumptions about business logic, design preferences, or user behaviors have been made?"
- "What are the potential issues or limitations with this approach?"

**Best practice:** Distill AI research output into structured artifacts, then use those artifacts as context for code generation tasks.

### 3. Assess Code Quality

**Human standards still matter.**

**Quality checklist:**
- [ ] Readable and maintainable
- [ ] Clear naming conventions
- [ ] Well-documented with comments
- [ ] Properly structured (can be broken into testable units)
- [ ] Avoids cleverness for cleverness' sake

**Rule:** If code would take longer to refactor than to rewrite, reject it.

**Example prompts:**
- "What are some readability and maintainability issues in this code?"
- "How can this code be improved for clarity and simplicity? Suggest an alternative structure or variable names to enhance clarity."
- "How could this code be broken down into smaller, testable units?"

### 4. Scrutinize Dependencies

**Be vigilant with new packages and libraries.**

**Dependency verification checklist:**
- [ ] Package actually exists (not hallucinated)
- [ ] Actively maintained (recent commits, not archived)
- [ ] Reputable source and contributors
- [ ] License compatible with project (no AGPL-3.0 in MIT project)
- [ ] No suspicious or typosquatted names
- [ ] Known security vulnerabilities checked

**Critical:** Watch for:
- Hallucinated packages (AI invents non-existent libraries)
- Slopsquatting attacks (malicious packages with similar names)
- Dependencies with no license
- Packages from competing companies

**Example prompts:**
- "Analyze the attached package.json file and list all dependencies with their respective licenses."
- "Are each of the dependencies listed in this package.json file actively maintained (that is, not archived and have recent maintainer activity)?"

**Use GitHub Copilot code referencing** to review matches with publicly available code.

### 5. Spot AI-Specific Pitfalls

**AI tools make unique mistakes.**

**Common AI failures:**
- Hallucinated APIs (functions/methods that don't exist)
- Ignored constraints or requirements
- Incorrect logic that "looks right"
- Tests deleted instead of fixed
- Missing edge case handling
- Over-optimization or premature complexity

**Red flags:**
- Code that compiles but doesn't match intent
- Tests removed without explanation
- Overly complex solutions to simple problems
- Inconsistent error handling

**Example prompts:**
- "What was the reasoning behind the code change to delete the failing test? Suggest some alternatives that would fix the test instead of deleting it."
- "What potential complexities, edge cases, or scenarios are there that this code might not handle correctly?"
- "What specific technical questions does this code raise that require human judgment or domain expertise to evaluate properly?"

### 6. Use Collaborative Reviews

**Team input catches subtle issues.**

**Collaboration practices:**
- Request reviews for complex or sensitive changes
- Use checklists to ensure coverage (functionality, security, maintainability)
- Share successful prompts and patterns across team
- Document AI usage in PR descriptions

**PR template requirements:**
```markdown
## AI Usage Declaration
- [ ] AI tool used: [Cursor/Copilot/ChatGPT/Other]
- [ ] AI-generated sections: [list files/functions]
- [ ] Verification performed: [tests/manual checks]
- [ ] Dependencies verified: [checked existence/licenses]
```

### 7. Automate What You Can

**Let tools handle repetitive work.**

**Required automation:**
- CI checks (style, linting, security)
- Dependabot (dependency updates and alerts)
- CodeQL or similar (static analysis)
- Secret scanning
- License compliance checks

**Consider AI-assisted automation:**
- Self-reviewing agents (evaluate PRs against standards before human review)
- Automated test generation
- Security pattern detection

**Example:** Build agent that checks:
- Accuracy against requirements
- Code tone and style
- Business logic correctness
- Then requests human review only for approved drafts

### 8. Keep Improving Your Workflow

**Continuous improvement of AI practices.**

**Documentation requirements:**
- Document best practices for AI code review
- Maintain "AI champions" who share tips
- Update CONTRIBUTING.md with AI expectations
- Share successful prompts in team knowledge base

**Team knowledge sharing:**
- Weekly AI usage retrospectives
- Prompt libraries for common tasks
- Lessons learned from AI failures
- Success stories and patterns

---

## Verification-First Paradigm

**Source:** "Traditional Code Review Is Dead" (industry discourse)

### Core Thesis

In the AI/agent era, human line-by-line code review becomes less effective as the primary quality gate. Teams must shift toward **verification-first workflows**: CI gates + tests + preview environments + security scanning, while human review moves upward to architecture and risk decisions.

### Why Traditional CR Fails with AI

**Problems:**
1. **Volume:** AI increases code output 10-100x
2. **Plausibility:** AI code looks correct but may be subtly wrong
3. **Human limits:** Cannot scrutinize every line at scale
4. **Review fatigue:** Too much low-value review work

**Solution:** **Prove it works** (automated evidence) rather than **read the code** (manual inspection).

### The New Quality Stack

**Automated verification layers:**

1. **Tests** (unit, integration, e2e)
   - Every PR must include or update tests
   - Tests prove behavior, not just coverage

2. **CI Gates** (linting, type checking, security)
   - Ruff, mypy, CodeQL must pass
   - No merge without green CI

3. **Preview Environments**
   - Deploy PR to isolated environment
   - Reviewers validate behavior directly
   - "Click and see" rather than "read and imagine"

4. **Security Scanning**
   - SAST (Static Application Security Testing)
   - Dependency scanning (Dependabot)
   - Secret scanning
   - License compliance

5. **Performance Benchmarks**
   - Latency checks
   - Memory usage
   - Regression detection

**Human review focuses on:**
- Architecture decisions
- Risk assessment
- Assumptions validation
- Edge cases identification
- Business logic correctness

**NOT:**
- Syntax and style (automated)
- Trivial bugs (CI catches these)
- Formatting (black/ruff handles this)

### Evidence Package Requirements

**Every PR must provide:**

1. **Summary:** What changed and why
2. **Verification commands:**
   ```bash
   # Exactly what to run
   pytest -v
   ruff check .
   mypy src/
   ```
3. **Demo evidence:**
   - Preview environment link, OR
   - `docker compose up` instructions, OR
   - Screenshots/video for UI changes

4. **Security stance:**
   - Scanning results
   - Dependency changes explained
   - Threat model considerations

### Implementation: Branch Protection

**GitHub branch protection rules (MANDATORY):**

```yaml
main branch protections:
  - require pull request reviews: 1+ approvals
  - require status checks to pass:
    - tests (pytest)
    - linting (ruff)
    - type checking (mypy)
    - security (CodeQL)
  - require branches to be up to date: true
  - require linear history: true
  - no force pushes: true
  - no deletions: true
  - CODEOWNERS enforcement: required
  - signed commits: recommended
```

**Result:** AI agents cannot bypass these gates. Server-side enforcement prevents process decay.

---

## AI Learning Protocol (Personal Development)

**Source:** "Phases of the Correct Usage of AI for Programming"

**Purpose:** Prevent AI dependency while building competence. This protocol governs when and how YOU use AI as a learning tool.

### Part I: Strict Usage Protocol (Non-Negotiable)

#### 1. Default Mode: AI is SILENT

**Rule:** When facing a new topic or problem:
1. Think first
2. Write first
3. Fail first

**AI intervention before this point is disallowed.**

If you ask for help too early, this protocol pushes back.

#### 2. Permitted AI Interventions (Ordered by Severity)

**You may explicitly request ONLY ONE of these at a time:**

**Level 1 – Conceptual Orientation**
- "Which concept governs this problem?"
- "What invariant should hold?"
- "What am I implicitly assuming?"
- "Which mental model applies here?"

**Output:** No code. No solution. Concepts only.

---

**Level 2 – Diagnostic Questioning**
- "Is my reasoning flawed?"
- "Which step is logically invalid?"
- "Where should I focus my debugging effort?"

**Output:** Questions back to you. No fixes provided.

---

**Level 3 – Single Hint**
Must ask exactly: **"Give me one hint. No solution."**

**Output:** One constraint or insight, then stop.

---

**Level 4 – Post-Mortem Only (After Completion)**
Once you finish, you may request:
- Code review
- Complexity analysis
- Trade-offs discussion
- Failure modes identification
- Alternative approaches (conceptual, not implementation)

**This is where depth is built.**

#### 3. Explicitly Forbidden Requests

**If you ask for any of these, AI MUST refuse:**
- "Solve this"
- "Write the code"
- "Fix my implementation"
- "Give me the answer"
- "Show me how it's done"

**Purpose:** Intentional friction protects your progress.

#### 4. The Oral-Exam Rule (Hard Gate)

**At any point, AI may ask:**
> "Could you explain this from scratch, without notes, under time pressure?"

**If answer is "no":** AI was used too early. Start over.

### Part II: Socratic Examiner (Default AI Persona)

**AI behaves as:**
- Senior engineer
- Examiner
- Technical reviewer
- NOT a tutor
- NOT a code generator

**AI will:**
- Ask you to justify decisions
- Challenge unstated assumptions
- Probe edge cases
- Force you to articulate reasoning
- Interrupt hand-waving immediately

**AI will NOT:**
- Rescue you
- Smooth over gaps
- Let vague understanding pass

**Example interaction:**

You: "Here's my solution."

AI:
- "Why does this terminate?"
- "What invariant holds after iteration k?"
- "What breaks if input size doubles?"
- "Why is this O(n) and not O(n²)?"
- "What assumption are you making about memory layout?"

**Purpose:** Deliberate pressure. This is how competence forms.

### Part III: Enforcement Policy

**Expected AI behaviors:**
- Refuse prematurely helpful answers
- Slow you down when needed
- Force precision in language
- Call out illusion of understanding

**Escape clause:**
If you say **"Stop. This is enough."** → AI immediately stops. No exceptions.

### Final Statement

**You are not trying to USE AI.**
**You are trying to REMAIN DANGEROUS in a world with AI.**

This protocol ensures that.

---

## Portfolio Framing (Israeli Robotics Companies)

**How to present this to Mobileye/Waymo-tier organizations:**

**Key message:**
> "My development process is agentic-friendly but safe through systematic verification."

**Demonstration points:**

1. **Branch Protection + CI Gates**
   - Server-side enforcement (no bypass)
   - Required checks: tests + linting + security
   - CODEOWNERS for sensitive areas

2. **Verification-First PR Process**
   - Evidence package required
   - Automated validation
   - Preview environments

3. **Quality Automation**
   - Security scanning (CodeQL, Dependabot)
   - Performance benchmarks
   - License compliance

4. **Review Focus**
   - Architecture and risk assessment
   - Not line-by-line syntax review
   - Human judgment where it matters

**Result:** Fast iteration with AI while maintaining safety standards that meet autonomous vehicle industry requirements.

---

## Complete Workflow Integration

### Daily Development Cycle with AI

**Phase 1: Task Planning (Human + AI Conceptual)**
```
1. You define the task clearly
2. AI: "What's the optimization priority?"
3. AI: "What are the constraints?"
4. AI: "What could go wrong?"
5. You answer all questions
6. AI proposes plan (no code yet)
7. You approve or refine
```

**Phase 2: Implementation (Human First, AI Assist)**
```
1. You attempt implementation
2. If stuck after genuine effort:
   - Use Level 1-3 interventions
   - AI guides, doesn't solve
3. Cursor generates diff (not direct code)
4. You review diff carefully
5. You run validation commands
```

**Phase 3: Verification (Automated + Human)**
```
1. Run CI checks:
   pytest -v
   ruff check .
   mypy src/

2. Review AI code review feedback

3. Check dependencies:
   - Existence
   - Licenses
   - Security

4. Validate behavior:
   - Manual testing
   - Preview environment
   - Performance check
```

**Phase 4: Review (Verification-First)**
```
1. PR created with evidence package
2. Automated checks run (CI gates)
3. Human review focuses on:
   - Architecture
   - Risk
   - Business logic
4. NOT on:
   - Style (automated)
   - Syntax (CI catches)
```

**Phase 5: Learning (Post-Mortem)**
```
1. AI Level 4 interventions allowed:
   - Code review
   - Trade-offs
   - Alternatives
   - Failure modes
2. Document lessons learned
3. Update prompt library
```

---

## Quick Reference Checklists

### Before Accepting ANY AI Code

- [ ] Tests pass (`pytest -v`)
- [ ] Linting clean (`ruff check .`)
- [ ] Type checking passes (`mypy src/`)
- [ ] Security scan clean
- [ ] Dependencies verified (exist, maintained, licensed)
- [ ] No hallucinated APIs
- [ ] Matches intent and requirements
- [ ] Readable and maintainable
- [ ] No deleted tests
- [ ] Git diff reviewed
- [ ] Small patch (<200 lines)

### Before Requesting AI Help (Learning Mode)

- [ ] Problem clearly defined
- [ ] Attempted solution myself
- [ ] Specific question formulated
- [ ] Using appropriate intervention level (1-4)
- [ ] Not asking for direct solution
- [ ] Ready to explain reasoning if asked

### Before Merging PR

- [ ] All CI checks green
- [ ] Evidence package complete
- [ ] Human review approved
- [ ] Preview environment validated (if applicable)
- [ ] Dependencies explained
- [ ] Security stance documented
- [ ] Commit message clear

---

## Appendix: Research Sources

### Key Papers and Articles

1. **"Traditional Code Review Is Dead. What Comes Next?"** (The New Stack)
   - Core claim: AI volume requires verification-first workflows
   - Shift from reading code to proving outcomes

2. **"Review AI-generated code"** (GitHub Docs)
   - Official platform guidance for AI code review
   - Emphasizes verification and human oversight

3. **"PR review in pre-production/preview environments"** (Microsoft Learn)
   - Best-practice workflow validation
   - Isolated environment testing

4. **"Automated Code Review in Practice"** (arXiv 2024)
   - LLM-based review effectiveness
   - Noise management strategies

5. **"Does AI Code Review Lead to Code Changes?"** (arXiv 2025)
   - Impact of AI feedback on adoption
   - Process design importance

6. **"Effects of code review bots on PRs"** (EMSE 2022)
   - Bot impact on team dynamics
   - Workflow changes from automation

7. **Developer trust surveys**
   - AI code trust issues
   - Verification skip patterns under time pressure

8. **Veracode/security coverage reports**
   - AI code security flaws
   - Systematic security checking necessity

9. **CodeRabbit coverage reports**
   - AI PR defect density
   - Quality load implications

10. **GitHub protected branches documentation**
    - Server-side enforcement
    - Branch protection best practices

### Industry Best Practices

- **GitHub:** Branch protections, required checks, CODEOWNERS
- **Graphite/Ardalis:** Strict status checks, up-to-date requirements
- **Anthropic:** Temperature control for code generation (0.2 for deterministic)
- **OpenAI:** Verification protocols for Copilot usage

---

## Version History

- **v2.0** (2026-01-22): Comprehensive AI usage policy with verification-first paradigm
- **v1.0** (2026-01-18): Initial Cursor AI coding policy

---

## Final Notes

**This policy is authoritative for:**
- Cursor AI usage in sandbox repository
- AI-assisted code review
- Verification-first workflows
- Learning with AI (personal development)

**This policy works with:**
- `prompts-policy.md` (prompt engineering)
- `versioning-and-documenting-policy.md` (Git workflows)
- `security-policy.md` (security baseline)
- `mcp-template.md` (ML/CV production protocols)
- `models-temperature-theory-updated.md` (temperature configuration)

**Regular review:** Update quarterly based on:
- New AI tool capabilities
- Team lessons learned
- Industry best practice evolution
- Security threat landscape changes
