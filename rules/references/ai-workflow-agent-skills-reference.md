---
doc_type: reference
authority: supporting
owner: Alfonso Cruz
scope: Agent skills management, learning protocols, delegation frameworks, scientific research workflows
---

# AI Workflow — Agent Skills, Learning & Delegation Reference

> **Note:** This is a reference companion to `ai-workflow-policy.md` Part 1. The policy file contains the binding rules; this file provides the detailed skills management guide, learning protocols, agent delegation frameworks, scientific research workflows, and portfolio framing.

---

## Claude Code Skills Management

**Purpose:** Enforce skill structure, token budget limits, and progressive disclosure architecture for Claude agent skills to prevent context bloat and maintain performance.

**Scope:** All `SKILL.md` files used with Claude Code (Claude.ai, Claude Desktop, Claude Code IDE, or API).

**Authoritative reference:** [The Complete Guide to Building Skills for Claude](references/the-complete-guide-to-building-skill-for-claude.pdf) (Anthropic, 2026). Skills are an open standard — portable across Claude.ai, Claude Code, and API without modification.

### Skill Categories

Anthropic identifies three standard categories:

| Category | Use for | Example |
|---|---|---|
| **Document & Asset Creation** | Consistent, high-quality output (docs, code, presentations) | `frontend-design`, `ml-cv-skills` |
| **Workflow Automation** | Multi-step processes with consistent methodology | `skill-creator`, `sprint-planning` |
| **MCP Enhancement** | Workflow guidance on top of MCP tool access | `sentry-code-review` |

When building a new skill, classify it into one of these categories. This determines whether it needs MCP integration or works standalone.

### YAML Frontmatter Requirements (Mandatory)

Every `SKILL.md` MUST begin with valid YAML frontmatter:

```yaml
---
name: skill-name-in-kebab-case
description: What it does. Use when user asks to [specific trigger phrases].
---
```

**Rules:**
- `name` (required): kebab-case only, must match folder name
- `description` (required): MUST include what + when (trigger conditions), under 1024 characters
- `license` (optional): MIT, Apache-2.0, etc.
- `metadata` (optional): author, version, mcp-server
- **Forbidden:** XML angle brackets (`<` `>`), names containing "claude" or "anthropic" (reserved)

Frontmatter appears in Claude's system prompt — this is Level 1 of progressive disclosure.

### Core Requirements

1. **Token Budget Enforcement (Mandatory)**
   - All `SKILL.md` files MUST pass `skills-lint` validation
   - Token budgets MUST be enforced per model (gpt-4, gpt-4o, gpt-5)
   - CI/CD pipelines MUST fail if any skill exceeds token budgets
   - Pre-commit hooks SHOULD run `skills-lint` to catch violations early

2. **Progressive Disclosure Structure (Mandatory)**
   - `SKILL.md` MUST remain lightweight: workflow + triggers + pointers
   - Detailed content MUST be moved to `/docs` subdirectories
   - Executable scripts MUST live in separate files (not embedded in `SKILL.md`)
   - `SKILL.md` SHOULD stay under ~500 lines per Claude's guidance

3. **Rationale:**
   - Claude's skills model depends on progressive disclosure: lightweight metadata always loaded; instructions loaded when triggered; deeper resources live as files/scripts
   - Token/size linting directly supports this architecture
   - Prevents "slow drift" past recommended limits
   - Context estate (token budget) is the primary constraint for Claude Code performance

### Skills-Lint Integration

**Tool:** [`skills-lint`](https://haasstefan.github.io/skills-lint/) — Token budget linter for agent skill files

**Installation:**
```bash
npm install -g @haasstefan/skills-lint
```

**Usage:**
```bash
# Lint all skills in a directory
skills-lint .github/skills/

# Lint specific skill
skills-lint .github/skills/code-review/SKILL.md
```

**Output:** Reports token counts per model (gpt-4, gpt-4o, gpt-5) with warnings and errors based on configured thresholds.

### CI/CD Integration (Mandatory)

**All repositories containing Claude Code skills MUST:**

1. **Install `skills-lint` in CI:**
   ```yaml
   # .github/workflows/skills-lint.yml
   name: Skills Lint
   on:
     pull_request:
       paths:
         - '**/SKILL.md'
         - '.github/skills/**'
   jobs:
     lint:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v4
         - uses: actions/setup-node@v4
         - run: npm install -g @haasstefan/skills-lint
         - run: skills-lint .github/skills/ || exit 1
   ```

2. **Fail build on violations:**
   - Any `SKILL.md` exceeding token budget MUST block merge
   - Warnings SHOULD be reported but not block (configurable per team)
   - Errors MUST block merge

3. **Pre-commit hook (Recommended):**
   ```yaml
   # .pre-commit-config.yaml
   - repo: local
     hooks:
       - id: skills-lint
         name: skills-lint
         entry: skills-lint
         language: node
         types: [text]
         files: SKILL\.md$
   ```

### Progressive Disclosure Structure Requirements

**Three-level system (per Anthropic's official guide):**

| Level | What | When loaded | Content |
|---|---|---|---|
| **Level 1** | YAML frontmatter | Always (system prompt) | Skill name + description + triggers |
| **Level 2** | SKILL.md body | When Claude thinks skill is relevant | Full instructions and guidance |
| **Level 3** | Linked files | When Claude navigates to them | Detailed docs, scripts, assets |

**Required folder structure:**

```
skill-name/
├── SKILL.md              # Required — workflow + triggers + pointers (~500 lines max)
├── scripts/              # Optional — executable code (Python, Bash, etc.)
│   ├── setup.sh
│   └── validate.py
├── references/           # Optional — documentation loaded as needed
│   ├── api-guide.md
│   └── best-practices.md
└── assets/               # Optional — templates, fonts, icons used in output
    └── report-template.md
```

**Critical rules:**
- `SKILL.md` must be exactly `SKILL.md` (case-sensitive, no variations)
- Folder names must be kebab-case (`my-skill` not `My_Skill`)
- **No `README.md` inside the skill folder** — all documentation goes in `SKILL.md` or `references/`
- Repo-level README (for human visitors) is separate from the skill folder

**`SKILL.md` content guidelines:**

✅ **MUST include:**
- Skill metadata (name, version, description)
- Trigger conditions (when skill activates)
- Workflow overview (high-level steps)
- Pointers to detailed docs (`docs/`, `scripts/`, `references/`)

❌ **MUST NOT include:**
- Full code implementations (move to `scripts/`)
- Extensive examples (move to `docs/examples.md`)
- Detailed troubleshooting (move to `docs/troubleshooting.md`)
- Long reference lists (move to `references/`)

**Example structure:**

```markdown
# Skill Name

## Overview
Brief description of what this skill does.

## Triggers
- When user asks: "How do I..."
- When context contains: [patterns]

## Workflow
1. Step 1 (see `docs/architecture.md` for details)
2. Step 2 (see `scripts/setup.sh` for implementation)
3. Step 3 (see `docs/examples.md` for examples)

## References
- Architecture: `docs/architecture.md`
- Examples: `docs/examples.md`
- Scripts: `scripts/`
```

### What Skills-Lint Does NOT Cover

**Important:** `skills-lint` is NOT a replacement for:

1. **Correctness testing** — "Does the skill actually do the right thing?"
   - **Solution:** Use eval-style tests (see [OpenAI eval guidance](https://developers.openai.com/blog/eval-skills/))
   - **Integration:** Add skill correctness tests to CI/CD alongside `skills-lint`

2. **Semantic validation** — "Does the skill structure make sense?"
   - **Solution:** Manual review, peer review, or semantic analysis tools
   - **Integration:** Code review process for skill changes

3. **Security validation** — "Does the skill expose security risks?"
   - **Solution:** Security review (see [Security Policy](security-policy.md) Section 15.1.1)
   - **Integration:** Security scanning in CI/CD

**Best practice:** Combine `skills-lint` (token budget) + correctness tests (functionality) + security review (safety) for comprehensive skill validation.

### Skill Testing Requirements

Per Anthropic's guide, effective skill testing covers three areas:

1. **Triggering tests** — Does the skill load at the right times?
   - Test 10-20 queries that SHOULD trigger it (obvious + paraphrased)
   - Test queries that should NOT trigger it (unrelated topics)
   - If skill under-triggers: add more detail and trigger phrases to the `description`
   - If skill over-triggers: add negative triggers, narrow scope

2. **Functional tests** — Does the skill produce correct output?
   - Valid outputs generated for representative inputs
   - API/MCP calls succeed (if applicable)
   - Error handling works for common failure modes
   - Edge cases covered

3. **Performance comparison** — Does the skill improve results vs. baseline?
   - Compare same task with and without skill enabled
   - Track: message count, tool calls, token consumption, API error rate
   - Skill should reduce at least one of these without degrading others

**Iteration signals:**
- Under-triggering → revise `description` with more trigger phrases
- Over-triggering → add negative triggers, be more specific
- Inconsistent results → improve instructions, add validation scripts
- API failures → add error handling, check tool names

### Skill Distribution

| Surface | Method |
|---|---|
| Claude.ai | Settings > Capabilities > Skills > Upload (zipped skill folder) |
| Claude Code | Place skill folder in Claude Code skills directory |
| Organization-wide | Admin deploys workspace-wide (centralized management) |
| API | `/v1/skills` endpoint + `container.skills` parameter in Messages API |

**Do not distribute skills as `.skill` files.** The canonical format is a folder containing `SKILL.md` + optional subdirectories, zipped for upload.

### ML/CV Skills Setup

**For ML/CV engineering skills (see `templates/ml-cv-skills-template.md`):**

1. **Apply progressive disclosure:**
   - Keep `SKILL.md` as workflow + triggers + pointers
   - Move detailed patterns to `docs/patterns.md`
   - Move code templates to `scripts/templates/`
   - Move decision trees to `docs/decision-trees.md`

2. **Enforce token budgets:**
   - Run `skills-lint` before committing skill changes
   - Fail CI/CD if budgets exceeded
   - Split large skills into smaller, focused skills if needed

3. **Example ML/CV skill structure:**
   ```
   pytorch-cv-patterns/
   ├── SKILL.md                    # ~200 lines: triggers + workflow + pointers
   ├── docs/
   │   ├── architecture-selection.md
   │   ├── loss-functions.md
   │   └── dataloader-configs.md
   ├── scripts/
   │   ├── focal-loss.py
   │   └── dataloader-template.py
   └── references/
       └── onnx-export-guide.md
   ```

### References

- **Skills-lint:** [https://haasstefan.github.io/skills-lint/](https://haasstefan.github.io/skills-lint/)
- **Claude Skills Best Practices:** [https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- **Claude Skills Overview:** [https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- **Testing Agent Skills:** [https://developers.openai.com/blog/eval-skills/](https://developers.openai.com/blog/eval-skills/)
- **Skills Template:** `templates/ml-cv-skills-template.md`

**See also:** `templates/ml-cv-skills-template.md` for ML/CV-specific skill examples and structure.

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

That's tool specialization, not ML engineering. Use AI tools **as helpers** to build structured ML/CV systems, not as your career focus. When agentic automation is needed, the right alternative is **structured plan memory and intent-anchored retrieval** (see [agent-architecture-intentcua-notes.md](references/agent-architecture-intentcua-notes.md)), not ad-hoc orchestration.

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

## Strategic Agent Delegation for Skill Building

**Purpose:** This section provides a strategic framework for using AI agents during learning and skill-building phases, with specific focus on ML/CV engineering career development. It addresses the critical question: **"Which skills must I build manually, and which workflows can agents accelerate without creating dependencies that hinder growth?"**

**Core Principle:**
Agent delegation decisions must be driven by skill-building goals, not convenience. The objective is to build deep competency in core ML/CV engineering skills while using agents to accelerate non-core tasks that would otherwise consume time better spent on learning.

### The Core Tension

The critical question is not "which tasks should I delegate to agents?" but rather: **"Which skills do I need to build, and which workflows can agents accelerate without creating dependencies that hurt my growth?"**

### Strategic Framework for Agent Use

#### 1. Skills You MUST Build Manually (Minimize Agent Use)

For ML/CV engineering positions (e.g., companies like Mobileye), you need deep competency in:

* **Core CV algorithms implementation** (object detection, segmentation, tracking)
* **Debugging model failures** (understanding why predictions fail)
* **Performance optimization** (real-time inference, memory constraints)
* **Reading research papers → implementation**

**Agent rule here:** Use agents for *scaffolding and boilerplate*, never for *core logic*.

**Example:** Agent generates test harness → You implement the actual CV algorithm.

#### 2. High-Value Agent Delegation (Accelerate Without Dependency)

Based on SWE-bench (which tests agents on real GitHub issues), agents excel at:

**a) Repository infrastructure** (50%+ success rate on these)
* Setting up project structure per `development-environment-policy.md`
* Creating proper `.gitignore`, Docker configs, CI/CD scaffolding
* Boilerplate test files with proper fixtures

**b) Documentation and specifications**
* Converting rough notes → proper markdown specs (aligns with spec-driven workflow)
* Generating docstrings from code you wrote
* Creating API documentation

**c) Refactoring well-understood code**
* Breaking monolithic scripts into modules
* Applying consistent naming conventions (per policy requirements)
* Updating imports after restructuring

**d) Data pipeline boilerplate**
* Dataset loading scripts (structure only - you verify correctness)
* Basic preprocessing pipelines
* Logging and metrics collection setup

#### 3. Medium-Risk Agent Use (Use with Heavy Verification)

**Debugging assistance:**
* Agents can suggest hypotheses, but YOU must understand the root cause
* Let agents generate test cases to reproduce bugs
* Never blindly apply "fixes" without understanding them

**Implementation from specs:**
* If you have a detailed spec (per spec-driven approach), agents can scaffold implementation
* But YOU must review every line and understand the approach

#### 4. Current Skill-Building Priority

For ML/CV engineering career goals, focus manual effort on:

**Computer Vision fundamentals:**
```
~/dev/repos/github.com/alfonsocruzvelasco/cv-fundamentals/
├── object-detection/      # YOLO, R-CNN family (manual)
├── segmentation/          # U-Net, Mask R-CNN (manual)
├── tracking/              # Kalman filters, SORT (manual)
└── datasets/              # Agent: download scripts
                           # You: understanding data characteristics
```

**ML Engineering skills:**
```
~/dev/repos/github.com/alfonsocruzvelasco/mlops-practice/
├── model-optimization/    # Quantization, pruning (manual)
├── deployment/            # TensorRT, ONNX (manual concepts, agent scaffolding)
├── monitoring/            # Metric definitions (manual), collection code (agent)
└── infra/                 # Docker/k8s configs (agent with your review)
```

### Concrete Workflow Recommendation

#### Phase 1: Foundation (Now - 6 months)
**Agent allocation: 20% of tasks**

```
Learning Projects → Manual Implementation
├── Implement classic CV papers from scratch
├── Debug why models fail (manual only)
├── Optimize inference speed (manual profiling, agent logging)
└── Build test datasets (agent download, you analyze)
```

**Agent tasks:**
* Project setup per policies
* Test harness generation
* Documentation after you understand the code
* Refactoring after your manual implementation works

#### Phase 2: Portfolio Building (6-12 months)
**Agent allocation: 30% of tasks**

```
Portfolio Projects → Production Quality
├── Real-time object detection system (edge deployment)
├── Custom dataset annotation pipeline
├── Model compression case study
└── Multi-camera tracking system
```

**Agent tasks:**
* Infrastructure setup (Docker, deployment scripts)
* Data pipeline boilerplate
* Documentation and README
* CI/CD configuration
* Code organization/refactoring

**Manual tasks:**
* All core CV/ML algorithms
* Performance optimization
* Architecture decisions
* Debugging model behavior

### Budget Optimization

Given multiple AI tool subscriptions:

**Keep:**
* **Cursor Pro** - Primary coding environment, integrated workflow
* **Claude Pro** - Deep technical discussions, policy adherence, architecture review

**Evaluate:**
* **ChatGPT Plus vs Gemini Pro** - Pick ONE for quick lookups/explanations. Based on SWE-bench, Claude/GPT-4 tier models perform similarly (~45-50%). Test both for 1 month, keep the one that explains CV concepts better for your learning style.

**Savings:** ~$20/month → Invest in Weights & Biases or better GPU cloud credits

### Measuring Success

Per objective evaluation focus, track:

```python
# Weekly self-assessment
metrics = {
    'manual_implementation_hours': X,  # Should be >60% of coding time
    'agent_generated_loc': Y,          # Lines you reviewed and understood
    'concepts_deeply_understood': Z,   # CV algorithms you can implement from memory
    'production_ready_projects': N     # Portfolio pieces
}
```

**Red flag:** If `agent_generated_loc / total_loc > 0.5` in learning projects, you're building dependency, not skills.

---

## Scientific Research Workflows

**Reference:** See Google's "Accelerating Scientific Research with Gemini" whitepaper for comprehensive guidance on using AI agents for scientific research.

### When to Use AI for Scientific Research

**Appropriate tasks:**
- Literature review and synthesis
- Hypothesis generation and refinement
- Experimental design suggestions
- Data analysis interpretation
- Paper writing assistance (drafting, editing)
- Code generation for data analysis pipelines
- Visualization generation

**Inappropriate tasks:**
- Replacing domain expertise
- Making scientific claims without validation
- Bypassing peer review
- Generating experimental data
- Replacing statistical analysis with AI summaries

### Recommended Models for Scientific Research

**Primary:** **Gemini 3 Pro** or **Composer 1**
- Strong performance on scientific literature synthesis
- Good at exploratory problem solving
- Effective for hypothesis generation
- Multi-modal capabilities (papers, figures, data)

**Alternative:** **Opus 4.6** (for policy/compliance-heavy research)
- When research must align with strict governance
- When constraint checking is required
- For safety-critical research workflows

### Scientific Research Workflow Pattern

1. **Literature Review Phase**
   - Use Gemini 3 Pro to synthesize papers
   - Generate summaries and identify gaps
   - Create annotated bibliographies

2. **Hypothesis Generation**
   - Use Gemini 3 Pro for creative exploration
   - Generate multiple hypotheses
   - Evaluate feasibility

3. **Experimental Design**
   - Use Opus 4.6 for policy-compliant designs
   - Use GPT-5.3 Codex for procedural implementation
   - Generate code for data collection/analysis

4. **Analysis and Interpretation**
   - Use Gemini 3 Pro for exploratory analysis
   - Use Opus 4.6 for rigorous interpretation
   - Validate all AI-generated insights

5. **Writing and Documentation**
   - Use Gemini 3 Pro for drafting
   - Use GPT-5.3 Codex for structured sections
   - Always review and validate scientific claims

### Best Practices

- **Always validate:** AI-generated scientific insights must be verified
- **Maintain expertise:** AI augments, does not replace domain knowledge
- **Document AI usage:** Track which parts used AI assistance
- **Peer review:** All AI-assisted work must go through standard peer review
- **Reproducibility:** Ensure AI-generated code/analysis is reproducible

### Decision Framework

**Use agents for tasks that match this pattern:**

```
IF task is:
    - Repetitive (config files, boilerplate, project structure)
    - Well-specified (you know exactly what needs to happen)
    - Verifiable (you can review correctness quickly)
    - NOT core to CV/ML engineering skills
THEN: Delegate to agent
ELSE: Manual implementation
```

**Concrete task list for agent delegation:**
1. Repository setup per `development-environment-policy.md`
2. Docker/compose configurations (after you design the architecture)
3. Test file scaffolding (you write assertions)
4. Data loading boilerplate (you verify correctness)
5. Documentation generation (after you understand the code)
6. Refactoring working code to follow naming conventions
7. Creating issues/specs in spec-driven workflow
8. Updating imports after restructuring

**Never delegate to agents:**
1. Implementing CV algorithms (YOLO, R-CNN, trackers, etc.)
2. Debugging why your model predictions are wrong
3. Architecture decisions for ML systems
4. Performance optimization critical path
5. Understanding research papers
6. Designing experiments

**The meta-skill you're building:** Knowing when human intelligence is irreplaceable vs when automation accelerates. That's exactly what ML/CV engineering roles value.

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
