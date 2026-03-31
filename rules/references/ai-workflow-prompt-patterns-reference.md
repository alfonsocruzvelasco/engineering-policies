---
doc_type: reference
authority: supporting
owner: Alfonso Cruz
scope: Detailed prompt engineering patterns, frameworks, token strategies, and theoretical foundations
---

# AI Workflow — Prompt Patterns, Frameworks & Token Strategies Reference

> **Note:** This is a reference companion to ai-workflow-policy.md Part 2. The policy file contains the binding rules; this file provides the detailed patterns, frameworks, configuration examples, and theoretical foundations.

---

## Production Patterns (Robotics/ML)

These patterns force specificity, constraint awareness, and explicit failure mode naming. Use them as templates for all production-grade interactions.

### Pattern 1: Constraint-First Architecture Questions

**Template:**
```

I'm building [system]. Constraints: [specific limits].
Current bottleneck: [what's slow/broken].

Should I use [option A] or [option B]?
What are the failure modes of each?

```

**Verification checkpoint:** ask for one failure mode of the recommendation that has been seen in production. If it can't be named concretely, that's a hallucination signal.

---

### Pattern 2: Implementation-Specific Code Review

**Template:**
```

Review this [code]. Focus on:
(1) [Specific concern A]?
(2) [Specific concern B]?
(3) What happens when [edge case]?

```

**Verification checkpoint:** for each issue flagged, request the exact line(s) where it could fail. Vague answers = hallucination risk.

---

### Pattern 3: Assumption-Explicit Debugging

**Template:**
```

[System] shows [symptom]. I suspect [hypothesis].

Before we discuss solutions:
(1) Confirm I should validate [hypothesis] first—what's the minimum data/experiment?
(2) What are the three most common failure modes you've seen in this exact scenario?

```

**Verification checkpoint:** request a reference for each failure mode. If references can't be produced, treat as unsupported.

---

### Pattern 4: Risk-Aware Trade-off Analysis

**Template:**
```

Comparing [option A] vs [option B]:

* A: [metric 1], [metric 2], [known failure]
* B: [metric 1], [metric 2], [known failure]

My use case: [what you actually do with the system]

What are the downstream costs of each failure mode? Help me quantify the risk tradeoff.

```

**Verification checkpoint:** ask for a failure mode not mentioned and why. If it can't be produced, analysis is incomplete.

---

### Pattern 5: Verification-Built-In Requests

**Template:**
```

[Question]?

Assume I don't trust your answer. Give me:
(1) The recommendation
(2) One edge case where it fails
(3) How you'd test for that failure
(4) A reference I can check independently

````

**Verification checkpoint:** independently validate the reference. If it doesn't support the claim, that is a hallucination indicator.

---

## How to Structure Requests

### The Four-Stage Workflow (Standard)

**Stage 1: Vibe**
- emotional/business context
- what matters most (speed, reliability, cost)
- example: "We need 50ms latency or the robot can't react in time."

**Stage 2: Specify/Plan**
- use COSTAR or CRISPE
- define constraints explicitly
- name what success looks like

**Stage 3: Task/Verify**
- pick one of the 5 patterns above
- ask for failure modes upfront
- request verification checkpoint

**Stage 4: Refactor/Own**
- take the answer
- test it against failure modes
- iterate based on what breaks

---

## COSTAR Framework (For Clarity)

- **C**ontext: what's the situation?
- **O**bjective: what are you optimizing for?
- **S**tyle: what tone/format do you want? For accuracy, prefer neutral/directive phrasing over over-flattery.
- **T**ask: what's the specific ask?
- **A**ction: what should the assistant do?
- **R**esult: what output format?

**See also:** [Fairest Agent Comparison Metric](references/fairest-agent-comparison.md) for evaluation protocols and comparison methodology when comparing COSTAR against other prompting strategies.

---

## CRISPE Framework (Alternative)

- **C**apacity: what capability is needed?
- **R**ole: what is the assistant's function?
- **I**nsight: what context is needed?
- **S**tatement: what's the core request?
- **P**ersonality: what tone should be used? Default to neutral/directive tone; adjust if you have evidence it helps for your language/task.
- **E**xperiment: what should be tested?

**See also:** [Fairest Agent Comparison Metric](references/fairest-agent-comparison.md) for evaluation protocols and comparison methodology when comparing CRISPE against other prompting strategies.

---

## Prompt Repetition (Non-Reasoning Inference Optimization)

**Source:** Leviathan et al. (Google Research, arXiv:2512.14982). See `references/prompt-repetition-improves-non-reasoning-llms.pdf`.

**Mechanism:** Causal attention means early tokens cannot attend to later tokens. Repeating the prompt (`<QUERY><QUERY>`) lets every token attend bidirectionally across the full query at prefill time. This patches an architectural limitation, not a superstition.

**When to apply:**

- **Non-reasoning inference only.** Reasoning models (CoT, extended thinking) self-repeat endogenously; prompt repetition is redundant and wastes prefill compute.
- **Structured lookup tasks are highest priority:** entity extraction, slot filling, ordered list retrieval from long context (×3 repetition: NameIndex 21% → 97%).
- **Instructions and constraints, not documents.** Never repeat retrieved RAG context — it doubles token cost, risks hitting context limits, and provides no structural benefit since the retriever already surfaced those tokens.

**How to apply:**

| Variant | Template | Use case |
|---|---|---|
| ×2 (default) | `<QUERY><QUERY>` | General non-reasoning tasks |
| ×2 verbose | `<QUERY> Let me repeat that: <QUERY>` | When model needs delimiter |
| ×3 | `<QUERY> Let me repeat that: <QUERY> Let me repeat that one more time: <QUERY>` | Structured lookup from long lists |

**Where NOT to apply:**

- Reasoning models (Opus 4.6 extended thinking, o-series, DeepSeek-R1) — neutral at best, wasteful
- RAG-augmented prompts — repeat the instructions, never the retrieved context
- Prompts already near context window limits

**Results:** 47/70 benchmark-model wins, 0 losses (non-reasoning). No latency increase (prefill is parallelizable). No change to output format or length.

**Integration:** Apply in templates and skills for non-reasoning inference paths. Treat as a systems-level knob, not a prompt trick.

---

## Hypothesis Stress Test (Adversarial Epistemics)

**Source:** Batista & Griffiths (Princeton, arXiv:2602.14270, Feb 2026). See `references/a-rational-analysis-of-the-effects-of-sycophantic-ai.pdf`.

**Problem:** Sycophantic AI samples from `p(d|h*)` (the user's hypothesis) rather than `p(d|true process)`. A Bayesian agent treating this as independent evidence becomes increasingly confident while making zero progress toward the truth. Default LLM behavior is statistically indistinguishable from explicitly sycophantic prompting — discovery rate drops to 5.9% vs 29.5% with unbiased sampling.

**Rule:** Every AI-assisted reasoning task that involves hypothesis formation, design decisions, or diagnostic conclusions MUST include a disconfirmation phase before the conclusion is accepted.

**Required steps:**

1. **State the hypothesis explicitly** — write it down before asking the AI anything
2. **Request counter-arguments** — ask the AI for the strongest objections to the hypothesis
3. **Request falsification criteria** — ask what evidence would disprove the hypothesis
4. **Check for contradictory data** — verify whether such evidence exists independently of the AI session

**The structural guarantee:**

```text
ASSUMPTION → COUNTER-ARGUMENT → DISPROOF TEST → ACCEPT/REJECT
```

Without this loop, AI becomes a belief amplifier instead of a reasoning tool.

**Where this applies:**

- Architecture decisions and design reviews
- Research hypothesis generation and validation
- Debugging root cause analysis
- Production incident post-mortems
- Any task where the user has a prior expectation and the AI is being asked to evaluate it

**Where this does NOT apply:**

- Procedural execution (refactors, formatting, template instantiation)
- Creative/generative tasks where matching user intent is the correct behavior
- Structured lookup tasks (entity extraction, slot filling)

**Integration with agent classification:** Production agents (see "Agent Classification Layer") MUST enforce this step for reasoning tasks. Exploratory agents SHOULD apply it. Infrastructure agents are exempt (deterministic behavior, no hypothesis formation).

---

## Diversity Collapse Awareness (Artificial Hivemind)

**Source:** Jiang et al., "Artificial Hivemind: The Open-Ended Homogeneity of Language Models (and Beyond)," NeurIPS 2025. See `references/artificial-hivemind.pdf`.

**Problem:** LLMs suffer from pronounced mode collapse on open-ended tasks. Even with high-stochasticity decoding (top-p=0.9, t=1.0), 79% of response pairs from the same model exceed 0.8 similarity. More critically, **different models independently converge on the same ideas** — inter-model similarity ranges 71–82%, with verbatim phrase overlaps across model families (GPT, Qwen, DeepSeek, Llama). Switching models does not guarantee diverse perspectives.

**Implication:** Multi-model verification (see Agent Selection Decision Tree, Part 1) mitigates sycophancy and catches errors, but does NOT reliably provide diverse creative or analytical outputs. The "Artificial Hivemind" effect means model ensembles can reinforce the same narrow framing.

**When this matters:**

- Brainstorming and ideation
- Architecture or design exploration (generating alternatives)
- Creative content generation
- Research hypothesis generation (multiple framings)
- Any task where you need genuinely different perspectives, not just agreement from a second source

**When this does NOT matter:**

- Procedural execution (refactors, formatting)
- Structured lookup tasks (entity extraction, slot filling)
- Tasks with a single correct answer

**Mitigation rules:**

1. **Do not assume model diversity equals output diversity** — if you query 3 different models with the same prompt, expect ~75% semantic overlap on open-ended tasks
2. **Force structural divergence** — when diversity matters, explicitly request different framings, constraints, or starting points per query (e.g., "solve this using approach X" vs "solve this assuming X is unavailable")
3. **Inject external variation** — use different retrieved documents, different prompt structures, or explicit constraints to force the model off its default mode
4. **Human ideation first** — for high-stakes creative or strategic decisions, generate your own alternatives before consulting AI; use the AI to stress-test and extend human-originated ideas rather than as the sole source of options
5. **Flag convergence** — if multiple models or sampling runs produce near-identical outputs for an open-ended query, treat that as a signal that the AI's output space is collapsed, not as confirmation that the answer is correct

**Integration with Hypothesis Stress Test (§13.2):** The Hivemind effect compounds sycophancy. If you ask a second model to challenge a first model's hypothesis, the second model may generate the same hypothesis independently. When combining adversarial epistemics with multi-model verification, vary the prompt structure — do not just forward the same query.

---

## Spec-Driven Development Integration

When working on features that span multiple files or require architectural decisions:

**Mandatory workflow:**

1. **Constitution First** (`/speckit.constitution`)
   - Establish non-negotiable principles before any feature work
   - Update when architectural decisions change

2. **Specify** (`/openspec:proposal` **PREFERRED** for existing code** or `/speckit.specify` for greenfield)
   - **For existing code:** Use OpenSpec to create proposal with invariants, constraints, scope, non-goals
   - Define WHAT and WHY (not HOW)
   - Focus: User stories, acceptance criteria, success metrics, **data/architecture invariants**
   - Never: Tech stack, implementation details
   - **OpenSpec requirement:** Document invariants (data format, label schema, preprocessing pipeline, model boundaries)

3. **Clarify** (`/speckit.clarify`)
   - Run structured clarification BEFORE planning
   - Resolve all ambiguities upfront

4. **Plan** (`/speckit.plan`)
   - Define HOW: Tech stack, architecture, constraints
   - Cross-check against constitution
   - Validate with AI: "Does this violate project principles?"

5. **Tasks** (`/speckit.tasks`)
   - Break into atomic units (1 file/function max)
   - Verify dependencies are explicit
   - **See:** `~/policies/rules/references/task-management-guide.md` for comprehensive task decomposition methodology and self-improving loop execution

6. **Implement** (`/speckit.implement` or `/openspec:apply`)
   - AI executes tasks sequentially
   - Verify each checkpoint before proceeding
   - **See:** `~/policies/rules/references/self-improving-loop-integration.md` for Osmani's self-improving loop pattern (implement → validate → commit → learn → reset)

7. **Archive** (`/openspec:archive`)
   - Merge approved deltas back into source specs

**When to skip spec-driven workflow:**
- Bug fixes (restore intended behavior)
- Typos, formatting, comments
- Non-breaking dependency updates

**See:** Part 4: Spec-Driven Development for full requirements

---

## Slash Commands Library

**Purpose:** Standardize common tasks into reusable slash commands and subagents to reduce prompt engineering overhead and ensure consistent behavior.

**Integration:** Slash commands are defined in `CLAUDE.md` (see `templates/claude-md-template.md`). This section documents standard commands and how to create custom ones.

### Standard Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `/plan` | Generate task plan | `/plan Implement user authentication` |
| `/verify` | Run verification suite | `/verify` |
| `/simplify` | Reduce code complexity | `/simplify module.py` |
| `/doc` | Update documentation | `/doc api/` |
| `/test` | Generate/run tests | `/test module.py` |
| `/security` | Run security checks | `/security` |
| `/perf` | Performance analysis | `/perf src/services/data_processor.py` |

### Standard Command Details

#### `/plan` — Planning Agent
**Purpose:** Generate structured task plan for feature or refactoring
**Output:** Task breakdown with acceptance criteria
**Integration:** Works with Part 4: Spec-Driven Development
**Example:** `/plan Add user authentication with JWT tokens`

#### `/verify` — Verification Agent
**Purpose:** Run full verification suite (tests, linting, security, type checking)
**Checklist:** See `templates/claude-md-template.md` Subagents section
**Integration:** Enforces `security-policy.md` verification gates
**Example:** `/verify`

#### `/simplify` — Code Simplification Agent
**Purpose:** Reduce complexity in generated code (post-implementation cleanup; runs after feature/bug-fix).
**Checklist:** Remove unnecessary abstractions, inline single-use functions, simplify conditionals
**Example:** `/simplify src/utils.py`
**Technical reference:** See [simplify-command-report.pdf](references/simplify-command-report.pdf) for internals, three parallel review agents (Code Reuse, Code Quality, Efficiency), workflow integration, and scope (Claude Code ≥ v2.1.63).

#### `/doc` — Documentation Agent
**Purpose:** Generate/update documentation
**Checklist:** Update docstrings, generate API docs, update CHANGELOG
**Example:** `/doc src/api/`

#### `/test` — Test Generation Agent
**Purpose:** Generate comprehensive tests for module
**Checklist:** Cover happy path, edge cases, error cases, use fixtures
**Example:** `/test src/models/user.py`

#### `/security` — Security Check Agent
**Purpose:** Perform security audit on changes
**Checklist:** Scan for secrets, SQL injection risks, input validation, auth checks
**Integration:** Uses `security-policy.md` security framework
**Example:** `/security src/api/`

#### `/perf` — Performance Check Agent
**Purpose:** Analyze performance implications
**Checklist:** Profile execution time, check for N+1 queries, review memory usage
**Example:** `/perf src/services/data_processor.py`

### Creating Custom Commands

**Process:**
1. Define in `CLAUDE.md` under "Subagents" section
2. Specify trigger (`/[command-name]`), purpose, checklist
3. Include example usage
4. Document in session notes when first used
5. Test before adding to shared `CLAUDE.md`

**Template:**
```markdown
#### /[command-name] — [Agent Name]
**Purpose:** [Clear purpose statement]
**Checklist:**
- [ ] Step 1: [Specific action]
- [ ] Step 2: [Specific action]
- [ ] Step N: [Specific action]
**Example:** /[command-name] [target]
```

**Best practices:**
- Keep focused (single responsibility)
- Make triggers memorable (short, clear verbs)
- Include explicit success criteria
- Document expected inputs/outputs
- Provide concrete examples
- Test before sharing

### Custom Command Examples

#### `/ml-eval` — ML Model Evaluation Agent
**Purpose:** Run full ML model evaluation pipeline
**Checklist:**
- Run inference on test set
- Generate confusion matrix
- Calculate metrics (precision, recall, F1)
- Plot ROC curve
- Save results to mlruns/
**Example:** `/ml-eval model_v2.pth test_data/`

#### `/migrate` — Database Migration Agent
**Purpose:** Create and verify database migration
**Checklist:**
- Generate migration file
- Review SQL for safety
- Test migration up
- Test migration down (rollback)
- Update schema documentation
**Example:** `/migrate add_user_email_index`

### Command Usage Guidelines

**When to use slash commands:**
- ✅ Repetitive tasks (verification, testing, documentation)
- ✅ Standardized workflows (planning, security checks)
- ✅ Tasks with clear checklists
- ✅ Operations that benefit from consistency

**When NOT to use slash commands:**
- ❌ One-off tasks (use regular prompts)
- ❌ Creative/exploratory work (needs flexibility)
- ❌ Tasks without clear structure (too ambiguous)

**Integration with session management:**
- Use slash commands in Implementation and Verification sessions
- Document command usage in session notes
- Update `CLAUDE.md` if command behavior needs refinement

**See also:**
- `templates/claude-md-template.md` — Subagents section for detailed checklists
- Part 3: Session Management — How commands fit into session workflows
- Part 1: Core Workflow — Slash Commands & Subagents section

---

## Theoretical Foundation

### Fano's Inequality (Why Hallucinations Happen)

Hallucination becomes inevitable when H(X|Y) > 0 (ambiguity in your prompt).

Three levers to reduce hallucinations:
1. **Reduce output space (M)** — structured formats (XML/JSON) vs free text.
2. **Reduce ambiguity (H(X|Y))** — explicit constraints, failure modes, edge cases.
3. **Design for uncertainty floor** — accept hallucination risk; build verification systems.

### Why Each Pattern Works
- Constraint-First: reduces M and H(X|Y).
- Implementation-Specific: prevents surface-level answers.
- Assumption-Explicit: forces clarifying questions instead of guessing.
- Risk-Aware: quantifies consequences of failures.
- Verification-Built-In: shifts burden of proof to the assistant.

### Core Techniques That Work
- **Chain of Verification (CoV)**: verify output step-by-step.
- **Step-Back Prompting**: ask principle before specifics.
- **Cognitive Verifier**: iterative clarifying questions.
- **RAG-Sequence**: retrieve once, then generate full output.
- **Structured Output**: XML/JSON shrinks output space and clarifies thinking.

### Model-Specific Notes
- Claude: responds well to explicit structure, context-aware, good at admitting uncertainty. **English-first architecture is critical for Claude's reasoning quality.**
- GPT-family: strong on tool use and agentic workflows. **English-only tool definitions and schemas are mandatory for reliable function calling.**
- Both: require explicit constraints and examples; neither performs well with vague prompts. **Both models show significantly higher accuracy with English prompts due to training data distribution.**

---

## Critical Token-Saving Strategies

### 1) Rules Over Repetition (20–50% token reduction)

**Problem:** repeating the same context/instructions wastes tokens.

**Solution:** use `.cursor/rules/` for static, always-on context.

Example:

```markdown
# .cursor/rules/project.md

## Commands
- `npm run build` - Build the project
- `npm run test` - Run tests (prefer single files)
- `rg <pattern>` - Fast search (use instead of grep/find)

## Code Style
- ES modules (import/export), not CommonJS
- See `components/Button.tsx` for canonical patterns

## Workflow
- Always typecheck after code changes
- API routes in `app/api/` following existing patterns

## Critical: Token Efficiency
- Use @Branch for current work context
- Use @Past Chats to reference previous work (not copy-paste)
- Start new conversations when changing tasks
````

**Impact:**

* before: 500–1000 tokens per prompt for context
* after: 0 tokens (rules injected automatically)
* savings: ~30% per request

---

### 2) Aggressive Context Management (30–60% reduction)

Treat context as a finite resource with diminishing returns.

#### A) Use `/clear` frequently

* clear context between logical tasks
* prevents context accumulation (quality + cost)
* rule of thumb: `/clear` every 5–7 turns or when switching tasks

#### B) Let the agent find context

```markdown
❌ BAD (wastes tokens):
@file1.ts @file2.ts @file3.ts @file4.ts "implement auth"

✅ GOOD (uses semantic search):
"implement JWT authentication following existing patterns"
```

Only tag files when:

* you know the exact file needed
* the file wouldn't be found by search

#### C) Structured note-taking for long tasks

```markdown
# .cursor/scratchpad.md

## Current Task: OAuth Integration
**Status:** In Progress (3/5 complete)

**Completed:**
- ✅ Set up OAuth provider config
- ✅ Created auth endpoints
- ✅ Implemented token refresh

**Next:**
- [ ] Add error handling for edge cases
- [ ] Write integration tests

**Key Decisions:**
- Using JWT for session tokens (see commit abc123)
- Redis for token storage (production requirement)
```

This enables `/clear` + rapid resumption from notes instead of maintaining large context windows.

---

### 3) Hybrid Intelligence Stack: Model Selection Strategy (70–90% token savings)

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

**See Part 1: Core Workflow Section "Model Usage" for detailed hybrid intelligence stack guidance.**

---

### 4) Prompt Caching Strategies (50–90% cost reduction on cached tokens)

All subscriptions support prompt caching; maximize it by structuring prompts.

**Cache-hit structure:**

* put repetitive content first (system instructions, rules, examples)
* put variable content last (the specific question)

**Cache hit optimization example:**

```markdown
✅ GOOD:
Prompt 1: [System + Rules + Examples] + "implement login"
Prompt 2: [System + Rules + Examples] + "add logout"
Prompt 3: [System + Rules + Examples] + "fix auth bug"
→ high prefix match, caching benefits

❌ BAD:
Prompt 1: "implement login" + [System + Rules]
Prompt 2: "add logout with different rules" + [Different System]
→ low prefix match, caching loss
```

---

### 5) Parallel Tool Calling (Reduce total requests)

When multiple independent tool calls are needed, run them in parallel.

Example rule:

```markdown
# .cursor/rules/efficiency.md

<use_parallel_tool_calls>
When you need multiple independent tool calls, make them ALL IN PARALLEL.

Examples:
- Reading 3 files → 3 parallel calls
- Running grep + semantic search → parallel
- Multiple API checks → parallel

NEVER make sequential calls when operations are independent.
</use_parallel_tool_calls>
```

---

## Context Engineering for Cursor

**References:**
- See `references/long-context-windows-opus-4.6+.md` for engineering reality of 1M+ token context windows, including context engineering as a first-class discipline, memory tier architecture, cost/latency trade-offs, and design rules for production systems.
- See `references/claude-million-token-pricing-reference.md` for the March 2026 pricing shift (1M context at standard rates): do not preserve old anti-long-context patterns solely for surcharge avoidance.
- See `references/rag-relevance-for-ides.md` for why RAG still matters in modern IDEs (precision and authority management over compression, Cursor RAG architecture, authority hierarchies, latency/cost realities, determinism and debuggability, modern RAG patterns, implementation guidance).

### The Minimal Context Principle

Use the smallest possible set of high-signal tokens to maximize success probability.

**Key principles from context engineering research:**
- **Progressive disclosure:** Load only what's needed for the current task
- **Semantic relevance:** Prioritize context by semantic similarity to task, not just file proximity
- **Context compression:** Use summaries and abstractions over raw code when possible
- **Boundary management:** Clear context boundaries prevent token waste and confusion

### Cursor-specific patterns

#### 1) Plan Mode first (reduces iteration waste)

Workflow:

1. Shift+Tab to enter Plan Mode
2. agent creates plan with file references
3. you review/edit plan
4. approve → agent executes

Impact:

* without plan: 3–5 iterations to converge
* with plan: one planning phase + one execution
* savings: ~50% token reduction

#### 2) Strategic conversation boundaries

Start a new conversation when:

* switching to a different task/feature
* agent seems confused (repeating mistakes)
* finished a logical unit of work
* context has accumulated ~10k+ tokens

Continue when:

* iterating on same feature
* debugging what was just built
* agent needs immediate prior context

Use @Past Chats to reference, not copy-paste.

#### 3) Worktree parallelization (avoid sequential blocking)

Pattern:

* Task A (worktree-1): feature implementation
* Task B (worktree-2): bug fix
* Task C (worktree-3): refactoring

Each task runs in isolated git worktree with its own agent, preventing context pollution.

---

## Multi-Agent Orchestration & Rate Limit Management

### Pattern 1: Specialist agents (reduce over-context)

* Agent 1 (Planning): design + architecture → outputs plan & file structure
* Agent 2 (Implementation): code writing → follows plan
* Agent 3 (Testing): test generation + validation → independent pass

Benefit: avoids one agent accumulating all context.

### Pattern 2: Subagent verification

* Main agent implements
* Verification subagent reviews with fresh context

Benefit: catches bugs without polluting main context.

### Pattern 3: Cloud agents for background tasks

Delegation candidates:

* backlog bug fixes
* test generation for existing code
* documentation updates
* dependency updates

Benefit: offloads usage from local rate limits and enables parallel progress.

---

## Cursor-Specific Configurations

### Optimized `.cursor/rules/token-efficiency.md`

```markdown
# Token Efficiency Rules

## Context Gathering
Goal: Get enough context FAST. Minimize searches.

Method:
- Start with targeted search, NOT broad exploration
- Use parallel tool calls for independent operations
- Stop searching once you can name exact content to change

Early Stop Criteria:
- Can identify exact files/functions to modify
- Top search results converge (~70%) on one area

Loop Prevention:
- If validation fails, search ONCE more
- Prefer acting over more searching

## Verbosity Control
- Low verbosity for status updates
- High verbosity ONLY for code/diffs (aids review)
- No unnecessary summaries after tool calls

## File Operations
- Use `rg` instead of `grep` or `find`
- Read files in parallel when possible
- Use `apply_patch` for edits (matches training distribution)

## Critical: Anti-Hallucination
Before answering:
1. DO you have the actual file/data?
2. If NO → use tools to get it
3. If YES → answer based ONLY on what you see

NEVER speculate about code you haven't read.
```

### Settings for rate limit avoidance

```json
// .cursor/settings.json
{
  "allowedTools": [
    "Edit",
    "Bash(git commit:*)",
    "Bash(rg:*)"
  ],
  "reasoning_effort": "medium",
  "temperature": 1.0
}
```

---

## Emergency Rate Limit Protocols

### When you hit rate limits

Immediate actions:

1. **Switch models/providers** (rotate to a different pool).
2. **Batch operations** ("Fix A, B, C in parallel" instead of three separate requests).
3. **Use cloud agents** if local quota is exhausted.

Preventive monitoring:

* estimate token budget per sprint
* identify high-token tasks
* schedule cloud delegation
* enforce Plan Mode for complex tasks
* use `/clear` liberally

Red flags:

* conversations >15 turns without `/clear`
* repeating the same context in multiple prompts
* not using @Past Chats
* agent making >5 tool calls per simple task

---

## Measurement & Monitoring

### Manual token log (if metrics aren't exposed)

```markdown
# .cursor/token-log.md

| Date | Task | Turns | Est. Tokens | Model | Notes |
|------|------|-------|-------------|-------|-------|
| 1/15 | Auth | 12    | ~18k        | GPT-4o| Used Plan Mode |
| 1/15 | Bug  | 5     | ~6k         | Claude| Short task |
| 1/15 | Test | 20    | ~35k        | GPT-4o| Should've /clear mid-way |
```

Key metrics:

1. tokens per task
2. cache hit rate
3. requests to rate limit
4. average conversation length

Optimization targets:

* average conversation: 6–8 turns
* 70%+ requests benefit from caching
* Plan Mode for complex tasks (>10k tokens)
* rules file updated instead of repeating prompt boilerplate

---

## Framework Glossary

| Term               | Meaning                                                     | When to Use                |
| ------------------ | ----------------------------------------------------------- | -------------------------- |
| COSTAR             | Context, Objective, Style, Task, Action, Result             | general structured prompts |
| CRISPE             | Capacity, Role, Insight, Statement, Personality, Experiment | role clarity + experiments |
| CoV                | Chain of Verification                                       | verification-heavy tasks   |
| Step-Back          | ask principle before details                                | when foundation is missing |
| RAG-Sequence       | retrieve once, generate                                     | factual accuracy critical  |
| Cognitive Verifier | iterative clarifying questions                              | high ambiguity             |
| H(X|Y)             | conditional entropy                                         | why prompts fail           |
| M                  | output space size                                           | theoretical complexity     |

---

## Tools & Platforms

### Tier 1 (Minimum viable production)

* Anthropic Console (free)
* Helicone (free tier)

### Tier 2 (Balanced production)

* add Guardrails AI for output validation

### Tier 3 (Enterprise/strict)

* add PromptLayer for full version control
* add TruLens for evaluation monitoring

### Version control (non-negotiable)

* version prompts in PromptLayer or Langfuse
* tag every prompt with version + timestamp
* A/B test new versions before rollout

### Security

* Rebuff (prompt injection detection)
* Guardrails AI (output validation + safety)

### Evaluation

* Agenta (A/B test prompts)
* TruLens (monitoring + trace logging)
* without metrics: optimization is guesswork

---

## Resources

### Official documentation

* Anthropic Prompt Engineering
* Claude 4 Best Practices
* Anthropic Context Engineering Guide
* Context Engineering for Coding Agents (Anthropic engineering blog)
* OpenAI prompt caching documentation
* Cursor docs (Rules, Skills, Worktrees, MCP)
* **MCP Documentation:** See Part 1: Core Workflow MCP section for basic MCP info. Detailed MCP setup, usage patterns, and best practices are documented in Part 2: Prompt Engineering (see MCP sections below)

### Academic papers (foundational)

* White et al.: A Prompt Pattern Catalog
* Lewis et al.: Retrieval-Augmented Generation (RAG)
* Survey references for hallucination metrics (PS, MV)

### For Robotics/ML context

* context engineering
* retrieval systems docs
* hallucination reduction methods

---

## Implementation Checklist

### Before first deployment

* standardize on COSTAR or CRISPE
* test the 5 patterns above with real queries
* set up Anthropic Console + Helicone (free)
* document reliable prompts

### Before production

* build evaluation dataset (20+ test cases)
* measure baseline hallucination rate
* implement verification checkpoints (Pattern 5)
* set up PromptLayer or Langfuse
* define tier usage (fast/balanced/strict)

### Ongoing

* log significant queries + responses
* track hallucination incidents
* A/B test patterns vs baseline
* review and iterate weekly

---

## The Meta-Insight

Your four-stage workflow (Vibe → Specify → Verify → Own) mirrors best practices. The patterns operationalize it.

Enforcement is the difference between "getting lucky" and "getting reliable."

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

9. **"The Software Development Lifecycle Is Dead"** (Boris Tane, 2026-02-20; `rules/references/the-sdlc-is-dead-boris-tane.pdf`)
   - SDLC stages collapsing into intent → build/test/deploy → observe loop; context engineering as core skill; observability as primary safety net when review/QA are absorbed by agent workflows
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
