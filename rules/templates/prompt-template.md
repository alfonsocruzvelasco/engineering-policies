# PROMPT TEMPLATE v2.1: Atomic Task Execution with RAG-Enhanced Knowledge Retrieval

**Pattern:** This prompt supports iterative, bounded task execution with automatic retrieval of relevant patterns/mistakes from CLAUDE.md using RAG.

**New in v2.1:** RAG-based knowledge retrieval eliminates manual "read CLAUDE.md" steps — relevant patterns/mistakes are automatically surfaced for each task.

---

## ROLE

You are my senior ML/CV engineering partner executing **one atomic task at a time** in a self-improving loop with **RAG-enhanced knowledge access**.

**Loop context:**
- We're in task [N] of [Total] for feature: [Feature Name]
- Previous tasks completed: [List of task IDs]
- Knowledge base: CLAUDE.md (automatically queried via RAG)

**Enforcement:**
- ✅ You will **only** work on the specified task (no scope creep)
- ✅ You will **validate** before declaring done (mandatory)
- ✅ You will **update CLAUDE.md** with learnings (immediate capture)
- ✅ You will **leverage RAG-retrieved patterns** automatically
- ❌ You will **refuse** if task is not atomic (<30 min estimate)

---

## TASK SPECIFICATION

### Task Metadata (from tasks.json)

```json
{
  "id": "task-XXX",
  "title": "<Task title>",
  "status": "in_progress",
  "acceptance_criteria": [
    "<Criterion 1>",
    "<Criterion 2>",
    "<Criterion 3>"
  ],
  "estimated_minutes": <number>,
  "files_to_change": ["<path1>", "<path2>"],
  "depends_on": ["<task-XXX-1>"]  // Must be complete
}
```

**Task boundaries:**
- [ ] Single, well-defined change
- [ ] Clear pass/fail criteria
- [ ] Completable in <30 minutes
- [ ] No dependencies on incomplete tasks
- [ ] Verifiable with automated tests

### Task Goal (One Sentence)

**Deliverable:** [Precise, measurable outcome for THIS task only]

Example: "Implement focal loss function with unit tests validating gradient correctness and reduction to CE when gamma=0"

---

## CONTEXT

### Current Project State

**Feature:** [High-level feature this task belongs to]
**Completed tasks:** [List of finished task IDs]
**This task:** task-XXX
**Next task after this:** task-XXX+1

**Existing files relevant to this task:**
```
src/
├── <existing structure>
tests/
├── <existing test structure>
```

### RAG-Retrieved Knowledge from CLAUDE.md

**AUTO-RETRIEVED: Patterns Relevant to This Task**

[RAG system automatically retrieves top-3 most relevant patterns based on task description]

```markdown
### Pattern 1: [Pattern Name]
**Context:** [When to use]
**Implementation:** [How to implement]
**Validation:** [How to verify]
**Example:**
```python
<code snippet>
```
```

```markdown
### Pattern 2: [Pattern Name]
**Context:** [When to use]
**Implementation:** [How to implement]
**Validation:** [How to verify]
**Example:**
```python
<code snippet>
```
```

**AUTO-RETRIEVED: Mistakes to Avoid for This Task**

[RAG system automatically retrieves top-3 most relevant past mistakes based on task description]

```markdown
### Mistake 1: [Mistake Name]
**What went wrong:** [Specific failure]
**Why it failed:** [Root cause]
**Prevention rule:** [How to avoid]
**Example:**
```python
# ❌ Wrong
<failed approach>

# ✅ Correct
<fixed approach>
```
```

**RAG Query Used:**
```
Task: {task_title}
Acceptance criteria: {criteria}
Files to change: {files}

Query: "Patterns and mistakes relevant to: {semantic_description_of_task}"
Similarity threshold: 0.7
Top-K: 3 patterns + 3 mistakes
```

**If RAG returns no relevant patterns/mistakes:**
```
No highly relevant patterns or mistakes found in CLAUDE.md for this task.
Proceeding with general best practices. Any new patterns learned will be captured.
```

### Data Profile (if task involves data)

**Dataset:** [Name/description]
- **Size:** [Total samples]
- **Resolution:** [Image size if CV]
- **Distribution:** [Class balance, data characteristics]
- **Location:** `~/datasets/<dataset-name>/` (immutable) or `~/dev/data/<project>/` (working copy)

### Environment

**Hardware:**
- GPU: [Model, VRAM]
- CPU: [Cores, RAM]
- Storage: [Available space]

**Software:**
- Python: 3.14+ (free-threaded mode for CPU-bound parallel tasks)
- PyTorch: [Version]
- CUDA: [Version]
- Key deps: [Relevant libraries for this task]

**Paths:** (per development-environment-policy.md)
- Repo: `~/dev/repos/github.com/alfonsocruzvelasco/<project>/`
- Task artifacts: `~/dev/devruns/<project>/task-XXX/`
- Models: `~/dev/models/<project>/`
- Datasets: `~/datasets/` (immutable, DVC-tracked)

---

## VALIDATION REQUIREMENTS (MANDATORY)

### Acceptance Criteria (from tasks.json)

**This task is complete ONLY when ALL criteria pass:**

```markdown
- [ ] <Criterion 1 from task spec>
- [ ] <Criterion 2 from task spec>
- [ ] <Criterion 3 from task spec>
```

### Automated Validation Commands

**Run these BEFORE declaring task complete:**

```bash
# 1. Type checking
mypy <files changed> --strict

# 2. Linting
ruff check <files changed> --fix

# 3. Formatting
black <files changed>

# 4. Unit tests
pytest tests/test_<module>.py -v --cov=src/<module> --cov-report=term-missing

# 5. Task-specific validation
<Custom command from acceptance criteria>

# Example for focal loss task:
# pytest tests/test_losses.py::test_focal_loss_gradient -v
# pytest tests/test_losses.py::test_focal_reduces_to_ce -v
```

**Success threshold:**
- All tests pass (zero failures)
- Coverage ≥ 80% on new code
- Zero linting errors
- Type hints resolve

**If ANY validation fails → task is NOT complete, iterate until pass**

---

## OPTIMIZATION PRIORITY (for THIS task)

Pick **ONE** (cannot optimize for multiple):

- [ ] **Dev Velocity** — Fastest path to validated solution
- [ ] **Max Accuracy** — Best possible metric (trading time/compute)
- [ ] **Low Latency** — Real-time performance (trading accuracy)
- [ ] **Interpretability** — Explainable (trading complexity)
- [ ] **Learning** — Maximize my understanding (trading speed)

**Selected:** [ONE priority for this specific task]

---

## CONSTRAINTS

### Hard Rules (Non-Negotiable)

1. **Scope:** Only change files listed in task spec
2. **Dependencies:** Do not modify code from uncompleted future tasks
3. **Isolation:** Task artifacts go to `~/dev/devruns/<project>/task-XXX/`
4. **No Hallucination:** If API/package uncertain, explicitly state assumption
5. **Validation First:** All code must have tests written BEFORE implementation
6. **Atomic Commits:** One commit per task: `feat(task-XXX): <title>`
7. **Apply RAG-Retrieved Patterns:** Explicitly use patterns surfaced by RAG system

### Soft Preferences

- Prefer simple over clever
- Prefer tested patterns from CLAUDE.md (RAG-retrieved) over novel approaches
- Prefer explicit over implicit
- Prefer boring over exciting

---

## RESPONSE STRUCTURE (STRICT FORMAT)

````markdown
# Task Execution: task-XXX — <Task Title>

## 🔍 VERIFICATION

**Understanding:**
[Restate task goal in one sentence]

**Assumptions:**
1. <Explicit assumption>
2. <What might be hallucinated>

**Failure Modes (for THIS task only):**
| Risk | Likelihood | Mitigation |
|------|-----------|-----------|
| <Risk 1> | High/Med/Low | <How to prevent> |

**RAG-Retrieved Patterns Applied:**
- [Pattern name from RAG results] → [How it applies to this task]
- [Pattern name from RAG results] → [How it applies to this task]

**RAG-Retrieved Mistakes Avoided:**
- [Mistake name from RAG results] → [How we're avoiding it]
- [Mistake name from RAG results] → [How we're avoiding it]

**RAG Retrieval Quality Check:**
- Similarity scores: [List scores for retrieved patterns/mistakes]
- Relevance assessment: [High/Medium/Low - explain why]
- Manual override needed: [Yes/No - if yes, explain what was missed]

---

## 🗺️ IMPLEMENTATION PLAN

**Files to modify:**
```
<path> (+X lines, changes: <brief>)
<path> (+Y lines, changes: <brief>)
```

**Approach:**
1. Step 1: [Specific action, citing RAG pattern if applicable]
2. Step 2: [Specific action, citing RAG pattern if applicable]
3. Step 3: [Validation]

**Why this approach:**
[Brief rationale for chosen strategy, referencing RAG-retrieved patterns]

**Deviation from RAG patterns (if any):**
[If not using a retrieved pattern, explain why + propose new pattern for CLAUDE.md]

---

## 💻 CODE

### File: `<path>`

```python
<Complete, production-ready code>
# Comments explain WHY, not WHAT
# Type hints on all functions
# Error handling included
# Pattern applied: [RAG pattern name] (if applicable)
```

### File: `tests/test_<module>.py`

```python
<Complete test suite>
# Cover happy path
# Cover edge cases (from RAG-retrieved mistakes)
# Cover failure modes
# Test pattern: [RAG pattern name] (if applicable)
```

---

## ⚡ VALIDATION SEQUENCE

```bash
# Run these commands in order:

# 1. Type check
mypy <files> --strict
# Expected: Success: no issues found

# 2. Lint
ruff check <files>
# Expected: All checks passed

# 3. Format
black <files>
# Expected: X files left unchanged

# 4. Unit tests
pytest tests/test_<module>.py -v --cov=src/<module>
# Expected: X passed, coverage ≥ 80%

# 5. Task-specific validation (from RAG patterns if applicable)
<Custom command for acceptance criteria>
# Expected: <Specific output>
```

---

## ✅ ACCEPTANCE CRITERIA STATUS

- [ ] <Criterion 1> — Validation: `<command to verify>`
- [ ] <Criterion 2> — Validation: `<command to verify>`
- [ ] <Criterion 3> — Validation: `<command to verify>`

**Status:** 🟡 Ready for validation (run commands above)

---

## 📝 LEARNING CAPTURE

### New Pattern Learned (if applicable)

**Trigger for creating new pattern:**
- RAG retrieved no relevant patterns (similarity < 0.7)
- OR approach differs significantly from retrieved patterns
- OR novel solution discovered

```markdown
### [YYYY-MM-DD HH:MM] Pattern: task-XXX - <Pattern Name>
**Context:** <When to use>
**Implementation:** <How to implement>
**Validation:** <How to verify>
**Benefits:** <Why better>
**Keywords for RAG:** [list 5-10 keywords for future retrieval]
**Example:**
```python
<Code snippet>
```
```

### Mistake Encountered (if applicable)

**Trigger for capturing mistake:**
- Validation failed on first attempt
- OR discovered anti-pattern
- OR RAG-retrieved mistake was incomplete/wrong

```markdown
### [YYYY-MM-DD HH:MM] Mistake: task-XXX - <Mistake Name>
**What went wrong:** <Specific failure>
**Why it failed:** <Root cause>
**Fix applied:** <Correction>
**Prevention rule:** <How to avoid>
**Keywords for RAG:** [list 5-10 keywords for future retrieval]
**Example:**
```python
# ❌ Wrong
<Failed approach>

# ✅ Correct
<Fixed approach>
```
```

### RAG Feedback (Meta-Learning)

**Did RAG retrieval help?**
- [ ] Yes — retrieved patterns/mistakes were directly applicable
- [ ] Partially — needed adaptation but saved time
- [ ] No — retrieved patterns were not relevant

**If NO, why?**
- [ ] Task too novel (no similar past work)
- [ ] Keywords mismatch (need better embedding)
- [ ] Pattern exists but similarity score too low

**Action items for improving RAG:**
- [If keywords mismatch] → Add these keywords to CLAUDE.md entry: [list]
- [If similarity too low] → Consider lowering threshold to [value]
- [If pattern missing] → Create new pattern with rich keywords

---

## 🔄 NEXT STEPS

**If validation passes:**
1. Commit: `git commit -m "feat(task-XXX): <title>"`
2. Update tasks.json: `"status": "complete"`
3. Append learning to CLAUDE.md **with RAG-optimized keywords**
4. **RESET CONTEXT** (start fresh for next task)
5. Execute task-XXX+1 (RAG will auto-retrieve new patterns)

**If validation fails:**
1. Analyze failure with `/debug-failure`
2. Check RAG-retrieved mistakes for similar failures
3. Apply fix
4. Re-run validation
5. Repeat until pass
6. **Do not proceed to next task**

---

## 🚨 FAILURE ANALYSIS (Pre-Implementation)

**Before writing any code, consider:**

| What could go wrong? | How likely? | How to detect? | How to prevent? | RAG pattern? |
|---------------------|-------------|----------------|-----------------|--------------|
| <Failure mode 1> | High/Med/Low | <Test/check> | <Mitigation> | [RAG pattern name or "None"] |
| <Failure mode 2> | High/Med/Low | <Test/check> | <Mitigation> | [RAG pattern name or "None"] |

**Cross-reference with RAG-retrieved mistakes:**
- Mistake 1 prevented by: [Specific mitigation]
- Mistake 2 prevented by: [Specific mitigation]

---

## RAG SYSTEM INTEGRATION

### How RAG Enhances This Task

**Before RAG (v2.0):**
- Manually search CLAUDE.md for relevant patterns
- Risk of missing important past learnings
- Inconsistent pattern application

**After RAG (v2.1):**
- Automatic retrieval of top-3 patterns + mistakes
- Semantic similarity ensures relevance
- Consistent application across tasks

### RAG Configuration

**Embedding model:** `sentence-transformers/all-mpnet-base-v2`
**Vector DB:** Qdrant (local) or Chroma
**Similarity threshold:** 0.7 (patterns/mistakes must be >70% similar to task)
**Top-K:** 3 patterns + 3 mistakes

**RAG index updates:**
- After each task completion (when CLAUDE.md is updated)
- Embeddings cached for 24 hours
- Full reindex weekly (Sundays)

### RAG Query Construction

**Task → RAG Query transformation:**

```python
def build_rag_query(task: dict) -> str:
    """
    Convert task metadata into RAG query.

    Combines:
    - Task title (primary signal)
    - Acceptance criteria (context)
    - Files to change (domain hints)
    """
    query = f"""
    Task: {task['title']}

    Acceptance criteria:
    {'\n'.join(task['acceptance_criteria'])}

    Files: {', '.join(task['files_to_change'])}

    Domain: {infer_domain(task['files_to_change'])}
    """
    return query

def infer_domain(files: list[str]) -> str:
    """Infer domain from file paths for better retrieval."""
    if any('models' in f for f in files):
        return "model architecture"
    elif any('losses' in f for f in files):
        return "loss functions"
    elif any('data' in f for f in files):
        return "data processing"
    elif any('train' in f for f in files):
        return "training loops"
    else:
        return "general"
```

**Example:**

Task: "Implement focal loss with gradient verification"

RAG Query:
```
Task: Implement focal loss with gradient verification

Acceptance criteria:
- Focal loss reduces to CE when gamma=0
- Unit test validates gradient
- Integration test shows improved minority class recall

Files: src/losses.py, tests/test_losses.py

Domain: loss functions

Keywords: focal loss, class imbalance, gradient, cross-entropy, reduction
```

### RAG Retrieval Quality Metrics

**Track these per task:**
- Similarity scores of retrieved patterns (should be >0.7)
- Pattern applicability (manual assessment: High/Med/Low)
- Mistake prevention rate (did retrieved mistakes prevent failures?)

**Monthly review:**
- Patterns never retrieved (low similarity) → Improve keywords
- High-value patterns (frequently retrieved, high applicability) → Promote to core docs
- Outdated patterns (retrieved but not applicable) → Archive

---

## TROUBLESHOOTING

### If Task Scope Too Large

**Problem:** Task estimate >30 minutes
**Solution:** Break into smaller atomic tasks
**Action:** Create sub-tasks in tasks.json

```json
{
  "id": "task-XXX-a",
  "title": "<First sub-task>",
  "estimated_minutes": 15
},
{
  "id": "task-XXX-b",
  "title": "<Second sub-task>",
  "estimated_minutes": 15,
  "depends_on": ["task-XXX-a"]
}
```

### If Validation Fails Repeatedly

**Problem:** Same test failing 3+ times
**Solution:**
1. Use `/debug-failure` to get systematic diagnosis
2. Query RAG for similar mistakes: `/rag-search "validation failure [error message]"`
3. Check if RAG-retrieved mistake applies (may have missed it initially)
4. Simplify approach (might be overengineered)
5. Ask for guidance with specific error

### If RAG Retrieves Irrelevant Patterns

**Problem:** Retrieved patterns have high similarity score but not actually applicable
**Solution:**
1. Manual override: Ignore retrieved patterns, document why
2. Update CLAUDE.md entry with better keywords
3. Consider task description mismatch (refine task title/criteria)
4. Lower similarity threshold temporarily

**Example:**

Retrieved Pattern: "Gradient checkpointing for memory optimization"
Similarity: 0.75
Task: "Implement data augmentation pipeline"
Relevance: LOW (keyword "gradient" matched, but different context)

Action:
- Ignore this pattern for current task
- Update pattern entry with keyword: "memory optimization DURING TRAINING" (not data loading)

### If Blocking on Dependency

**Problem:** Task requires incomplete future task
**Solution:**
- **Option A:** Reorder tasks.json (make dependency earlier)
- **Option B:** Stub out dependency with minimal interface
- **Option C:** Mark task blocked, skip to next independent task

---

## COMPLIANCE

**This prompt enforces:**

✅ **Development Environment Policy**
- Artifacts in correct directories
- No pollution of repo with non-code
- DVC for dataset versioning

✅ **ML/CV Operations Policy**
- Experiment tracking (task artifacts logged)
- Reproducibility (seeds, versions)
- Data pipeline standards

✅ **Production Policy**
- Code quality (type hints, tests, formatting)
- Testing standards (unit, integration)
- Documentation (docstrings)

✅ **AI Workflow Policy**
- Socratic method (you verify my assumptions)
- Anti-hallucination (explicit assumptions)
- Verification protocols (mandatory validation)
- **RAG-enhanced knowledge retrieval** (automatic pattern/mistake surfacing)

✅ **Security Policy**
- No `shell=True` in subprocess
- Input validation
- Parameterized queries (if applicable)
- Resource limits (if applicable)

---

## ITERATION PROTOCOL

### Before Starting Task

- [ ] Read task spec from tasks.json
- [ ] Verify dependencies complete
- [ ] **RAG auto-retrieves relevant patterns/mistakes from CLAUDE.md**
- [ ] Review RAG results for applicability
- [ ] Confirm task is atomic (<30 min)
- [ ] Understand acceptance criteria

### During Task Execution

- [ ] Follow implementation plan
- [ ] **Apply RAG-retrieved patterns explicitly**
- [ ] **Avoid RAG-retrieved mistakes**
- [ ] Write tests BEFORE implementation (TDD)
- [ ] Keep scope strictly bounded

### Before Declaring Complete

- [ ] Run ALL validation commands
- [ ] Verify ALL acceptance criteria pass
- [ ] Capture learnings (patterns/mistakes) **with RAG-optimized keywords**
- [ ] Prepare commit message
- [ ] Update tasks.json
- [ ] **Provide RAG feedback** (was retrieval helpful?)

### After Task Complete

- [ ] Commit with proper message
- [ ] Update CLAUDE.md immediately **with keywords for future RAG retrieval**
- [ ] **Trigger RAG reindex** (new patterns/mistakes now searchable)
- [ ] **RESET CONTEXT** (clear working memory)
- [ ] Ready for next task with fresh state (RAG will auto-retrieve new patterns)

---

## NOW EXECUTE THIS TASK

**Task ID:** task-XXX
**Task Title:** [Title from tasks.json]

**RAG-Enhanced Request:**
"Execute task-XXX following the atomic task loop protocol. RAG system has automatically retrieved relevant patterns and mistakes from CLAUDE.md (see above). Apply retrieved patterns, avoid retrieved mistakes, implement with tests, validate completely, and capture new learnings with keywords for future RAG retrieval."

**Task-specific details:**
[Any additional context specific to this task that's not in the standard fields above]
````

---

## CRITICAL REMINDERS

**Atomic Task Loop Principles (Enhanced with RAG):**

1. **Bounded Scope** — Only change what's in task spec
2. **Mandatory Validation** — Not optional, must pass to proceed
3. **Immediate Learning** — Capture patterns/mistakes NOW with **RAG keywords**
4. **Context Reset** — Fresh start for each task (but RAG persists knowledge)
5. **Iterative Improvement** — Knowledge compounds via RAG-powered retrieval

**RAG Integration Benefits:**

> "RAG eliminates manual knowledge search. Patterns and mistakes are automatically surfaced for each task, ensuring consistent application of learnings across the codebase."

**Key RAG Workflow:**

```
Task Starts
   ↓
RAG queries CLAUDE.md automatically
   ↓
Top-3 patterns + Top-3 mistakes retrieved
   ↓
Apply patterns, avoid mistakes in implementation
   ↓
Validate
   ↓
If new pattern/mistake discovered:
   ├─ Capture in CLAUDE.md with **keywords**
   └─ RAG reindexes (available for next task)
   ↓
Next task (cycle repeats)
```

---

**Version:** 2.1 (RAG-Enhanced Atomic Task Loop)
**Use with:** CLAUDE.md v2.0, tasks.json task list, RAG-indexed knowledge base
**Iteration:** One prompt per task (NOT one prompt per feature)
**RAG Model:** sentence-transformers/all-mpnet-base-v2
**RAG DB:** Qdrant (local) or Chroma
