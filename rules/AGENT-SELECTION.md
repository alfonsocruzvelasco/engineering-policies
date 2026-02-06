# Agent Selection Guide

**Status:** Authoritative
**Purpose:** Quick decision tree for selecting the right AI agent from 9+ available models
**Last updated:** 2026-02-06

---

## Quick Decision Tree

### Step 1: Policy/Architecture Decision?
**Is this task about policy reasoning, architecture decisions, or constraint enforcement?**

→ **YES:** Use **Opus 4.6**, **Opus 4.5**, or **Sonnet 4.5**
- Policy reasoning and constraint enforcement
- Architecture decisions and design reviews
- Long-term operating manuals and governance
- Safety-critical code reviews
- Long-form handovers and context continuity

→ **NO:** Continue to Step 2

---

### Step 2: Procedural/Implementation Work?
**Is this procedural execution, step-by-step implementation, or mechanical transformation?**

→ **YES:** Use **GPT-5.3 Codex** or **GPT-5.2 Codex**
- Procedural execution (step-by-step implementation)
- Refactors and mechanical transformations
- Template instantiation and structured output
- Deterministic step-by-step procedures
- Coding standards enforcement
- SOPs and runbooks execution

→ **NO:** Continue to Step 3

---

### Step 3: Creative/Exploratory?
**Is this creative work, exploration, or open-ended problem solving?**

→ **YES:** Use **Gemini 3 Pro** or **Composer 1**
- Creative problem solving
- Exploratory research
- Open-ended design work

→ **NO:** Continue to Step 4

---

### Step 4: Speed Priority?
**Is speed more important than quality for this task?**

→ **YES:** Use **Haiku 4.5**
- Fast responses needed
- Low-complexity tasks
- Routine operations

→ **NO:** Use **Opus 4.6** (default for high-quality work)

---

## Model Characteristics Matrix

| Model | Best For | Key Capability | Effort Parameter |
|-------|----------|---------------|------------------|
| **Opus 4.6** | Policy reasoning, architecture, governance | 1M token context, constraint obedience | `/effort=low/medium/high` |
| **Opus 4.5** | Policy reasoning, long context | Strong constraint adherence | `/effort=low/medium/high` |
| **Sonnet 4.5** | Architecture decisions, design reviews | High reasoning quality | Standard |
| **GPT-5.3 Codex** | Procedural execution, refactors | Step-by-step accuracy, 25% faster | N/A |
| **GPT-5.2 Codex** | Procedural execution | Mechanical transformation | N/A |
| **Gemini 3 Pro** | Creative/exploratory work | Open-ended problem solving | N/A |
| **Composer 1** | Creative work | Multi-modal capabilities | N/A |
| **Haiku 4.5** | Speed-critical tasks | Fast responses | N/A |
| **qwen3-coder (local)** | Routine coding, refactors | Local execution, zero API cost | N/A |

---

## Effort Parameter (Opus 4.6/4.5)

**When using Opus models, specify effort level:**

- **`/effort=low`**: Routine tasks, fast inference, lower cost (target: 80% accuracy)
- **`/effort=medium`**: Balanced quality/speed/cost (default)
- **`/effort=high`**: Complex/critical decisions, maximum quality

**Selection guidance:**
- Task complexity < threshold → `low`
- Task complexity < high threshold → `medium`
- Critical decisions or high complexity → `high`

---

## Common Task → Model Mappings

| Task Type | Recommended Model | Reason |
|-----------|-------------------|--------|
| "Should we adopt X architecture?" | Opus 4.6 | Policy reasoning, constraints |
| "Implement X using Y pattern" | GPT-5.3 Codex | Procedural execution |
| "Review this against our policies" | Opus 4.6 | Constraint checking |
| "Refactor module X to pattern Y" | GPT-5.3 Codex | Mechanical transformation |
| "Explain why we have rule X" | Opus 4.6 | Governance context |
| "Execute deployment checklist" | GPT-5.3 Codex | Step-by-step SOP |
| "Write unit tests for X" | GPT-5.3 Codex or qwen3-coder | Procedural, routine |
| "Design new feature architecture" | Opus 4.6 | Architecture decision |
| "Debug complex logic error" | Opus 4.6 | Deep reasoning required |
| "Format code, fix linting" | Haiku 4.5 or qwen3-coder | Speed, routine |

---

## Reference

**See also:**
- [Frontier Model Selection: Opus 4.6 vs GPT-5.3 Codex](ai-workflow-policy.md#frontier-model-selection-opus-46-vs-gpt-53-codex) for detailed capabilities
- [Opus 4.6 & GPT-5.3 Codex Policy Impact Analysis](references/opus-4.6-gpt-5.3-codex-policy-impact-analysis.md) for comprehensive analysis
- [Prompt Template](templates/prompt-template.md) for model-specific parameters in prompts

---

**Version:** 1.0
**Maintenance:** Update when new models are added or capabilities change
