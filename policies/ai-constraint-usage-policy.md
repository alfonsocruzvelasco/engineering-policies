# AI Constraint Usage Policies

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
- [1) Operating Principles](#1-operating-principles)
- [2) Non-Negotiable Boundaries](#2-non-negotiable-boundaries)
- [3) Prompt-Quality Gate (Mandatory)](#3-prompt-quality-gate-mandatory)
- [4) Standard Prompt Template (Quick)](#4-standard-prompt-template-quick)

---

### Reference manual (separate file)

- **Prompt Policies:** `prompt_policies.md`


## 0) Operating System (Start Here)
From now on, the file **`comprehensive_prompt_engineering_guide.md`** is the **unique authoritative reference** for:
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

2. **MCP (Connectivity):** Use the Model Context Protocol to connect agents to tools (Databases, Git, APIs) rather than pasting data.

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

