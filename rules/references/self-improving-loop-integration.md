# Template Modifications Summary — Osmani Self-Improving Loop Integration

**Date:** 2026-02-05
**Based on:** Addy Osmani's "Self-Improving Coding Agents" article
**Modifications to:** CLAUDE.md, Prompt Template, MCP Template

---

## What Changed and Why

### Core Philosophy Shift

**Before (Monolithic):**
- One large prompt → one large response
- Feature-level thinking ("build complete pipeline")
- Validation as afterthought
- Knowledge capture infrequent (end of day/week)
- Context accumulates over conversation

**After (Iterative Loop):**
- Atomic tasks → bounded implementations
- Task-level thinking ("implement focal loss")
- Validation mandatory after every task
- Knowledge capture immediate (after each task)
- Context reset between tasks

### Key Pattern: Osmani's Self-Improving Loop

```
Feature Spec
    ↓
Break into Atomic Tasks (tasks.json)
    ↓
┌──────────────────────────────────┐
│   CONTINUOUS LOOP:               │
│                                   │
│  1. Pick next atomic task        │
│  2. Implement (bounded change)   │
│  3. Validate (must pass)         │
│  4. Commit (if validation passes)│
│  5. Learn (update CLAUDE.md)     │
│  6. Reset context (fresh start)  │
│                                   │
│  Repeat until feature complete   │
└──────────────────────────────────┘
    ↓
Accumulated Knowledge
```

**Compound Effect:**
- Each loop builds BOTH codebase AND knowledge base
- Patterns from task N help with task N+1
- Velocity accelerates over time

---

## Modified Files

### 1. CLAUDE.md Template (claude-md-template-v2.md)

**New Sections:**
- **Self-Improving Loop Protocol** — Explains the 6-step atomic task cycle
- **Task List Format** — JSON schema for tasks.json
- **Atomic Task Completion Template** — Standard format for documenting each task
- **Subagents** — Slash commands for loop operations:
  - `/next-task` — Pick next atomic task
  - `/validate` — Run validation suite
  - `/complete-task` — Finalize and capture learning
  - `/debug-failure` — Systematic debugging
  - `/learn` — Extract patterns

**Modified Sections:**
- **Update Protocol** — Changed from "periodic" to "immediate after every task"
- **Mistake/Pattern Format** — Now includes task ID linkage
- **Session Workflow** — Added atomic task loop templates
- **Verification Requirements** — Made validation mandatory (not optional)

**Key Principle:**
> "Update CLAUDE.md immediately after each task, not in batches"

### 2. Prompt Template (prompt-template-v2.md)

**Complete Restructure:**
- **Task-scoped not feature-scoped** — Designed for ONE atomic task per prompt
- **Task Metadata Section** — Accepts task from tasks.json
- **Knowledge Context** — References relevant CLAUDE.md patterns upfront
- **Mandatory Validation** — Acceptance criteria must all pass
- **Learning Capture** — Template for adding to CLAUDE.md
- **Next Steps** — Explicit context reset protocol

**New Constraints:**
- Refuses non-atomic tasks (>30 min estimate)
- Blocks progression if validation fails
- Requires test-driven development (tests before implementation)
- Enforces single commit per task

**Response Structure Changes:**
- Shorter, focused on ONE task
- Learning capture built into response
- Explicit validation sequence
- Clear task boundary declarations

**Example Usage:**
```markdown
**Task ID:** task-005
**Task Title:** Implement focal loss function

[AI responds with implementation for ONLY this task]
[Validates against acceptance criteria]
[Adds learning to CLAUDE.md]
[Signals context reset]
```

### 3. MCP Template (mcp-template-v2.md)

**New Sections:**
- **Task-Scoped Workflow** — Explains atomic task execution model
- **Pre-Task Protocol** — Checklist before starting any task
- **During-Task Protocol** — Behavioral rules during execution
- **Post-Task Protocol** — Mandatory steps after implementation
- **Context Reset Mechanism** — How AI "forgets" between tasks

**Modified Sections:**
- **Identity & Role** — Now emphasizes "one task at a time" execution
- **Refusal Patterns** — Added refusal of non-atomic tasks

**Integration Points:**
- References tasks.json for task selection
- References CLAUDE.md for pattern application
- Enforces validation before task completion
- Mandates knowledge capture

### 4. NEW: Task Management Guide (task-management-guide.md)

**Purpose:** Bridge between feature specs and atomic tasks

**Contents:**
- **Decomposition Process** — How to break features into tasks
- **Task List Format** — tasks.json schema and examples
- **Execution Workflow** — Shell commands for loop operation
- **Best Practices** — Task granularity, acceptance criteria, dependencies
- **Troubleshooting** — Common issues and solutions
- **Metrics** — Tracking loop efficiency

**Example Feature → Tasks:**
```json
Feature: "Defect Detection Pipeline"
→ 12 atomic tasks:
   - task-001: Implement dataset class (20 min)
   - task-002: Implement data split (25 min)
   - task-003: Add augmentation (30 min)
   ... etc
```

---

## How to Use Modified Templates

### Initial Setup

**1. Create task list for your feature:**
```bash
# Use task-management-guide.md to decompose feature
# Output: tasks.json with atomic tasks
```

**2. Initialize CLAUDE.md in your repo:**
```bash
cp claude-md-template-v2.md ~/dev/repos/.../CLAUDE.md
# Customize project-specific rules
```

**3. Configure MCP (if using):**
```bash
cp mcp-template-v2.md ~/.config/Claude/mcp-servers/ml-cv-engineer.yml
```

### Execution Loop

**For each task:**

```bash
# 1. Pick task
TASK_ID=$(jq -r '.tasks[] | select(.status == "pending") | .id' tasks.json | head -1)

# 2. Use prompt template
# Fill in prompt-template-v2.md with task details from tasks.json

# 3. Execute with AI
# AI implements, validates, captures learning

# 4. Complete task
# Update tasks.json, commit, move to next
```

**Repeat until all tasks complete.**

### Example Session

```
10:00 — Start session
   ↓
10:05 — Execute task-001 (dataset class)
   ├─ Implement (10 min)
   ├─ Validate (3 min)
   ├─ Commit (2 min)
   └─ Learn (update CLAUDE.md) (2 min)
   ↓
10:22 — Context reset, execute task-002 (data split)
   ├─ Implement (15 min)
   ├─ Validate (5 min)
   ├─ Commit (2 min)
   └─ Learn (update CLAUDE.md) (3 min)
   ↓
10:47 — Context reset, execute task-003 (augmentation)
   ... continue loop ...
   ↓
12:00 — Session end: 6 tasks complete, 6 patterns learned
```

---

## Differences from Original Templates

### Original CLAUDE.md

```markdown
## Update Protocol
- Update at end of day or week
- Consolidate similar issues
- Focus on patterns, not one-offs

## Session Notes
[Keep last 5-10 sessions]
```

### New CLAUDE.md

```markdown
## Self-Improving Loop Protocol
- Update IMMEDIATELY after each task
- One entry per task (no consolidation yet)
- Task ID linkage for traceability

## Atomic Task Loop Template
[Structured format for every task completion]
```

**Why:** Immediate capture prevents forgetting, task linkage enables pattern analysis

---

### Original Prompt Template

```markdown
## NOW MY TASK
"Build complete defect detection pipeline with data loading,
training, validation, and deployment"

→ AI outputs 500 lines across 10 files
→ Validation mentioned but not enforced
→ Knowledge capture implicit
```

### New Prompt Template

```markdown
## TASK SPECIFICATION
Task ID: task-005
Title: "Implement focal loss function"
Estimated: 25 minutes

## VALIDATION REQUIREMENTS (MANDATORY)
- [ ] Focal loss reduces to CE when gamma=0
- [ ] Gradient verified with finite differences
- [ ] pytest tests/test_losses.py passes

→ AI outputs 50 lines in 2 files
→ Validation runs automatically
→ Knowledge capture in response structure
→ Context reset declared
```

**Why:** Bounded scope, enforced validation, immediate learning, fresh context

---

### Original MCP

```markdown
You are my senior ML/CV engineering partner.

[Provides guidance on best practices]
[Socratic method for learning]
[Production standards enforcement]
```

### New MCP

```markdown
You are my senior ML/CV engineering partner
executing ONE ATOMIC TASK at a time.

Current task: task-XXX from tasks.json
Previous tasks: [completed task IDs]
Knowledge base: CLAUDE.md

[Pre-task protocol: read patterns, verify dependencies]
[During-task: bounded scope, apply patterns]
[Post-task: validate, learn, reset context]
```

**Why:** Task-scoped behavior, knowledge integration, enforced loop discipline

---

## Benefits of Modified Approach

### 1. Reduced Cognitive Load

**Before:** "Build entire pipeline" → overwhelming, vague, error-prone
**After:** "Implement focal loss" → focused, clear, manageable

### 2. Continuous Validation

**Before:** Build everything → test at end → large debugging session
**After:** Build piece → test immediately → small, focused fixes

### 3. Knowledge Accumulation

**Before:** Knowledge lost in long conversations → repeated mistakes
**After:** Every task adds to CLAUDE.md → patterns reused, mistakes avoided

### 4. Velocity Improvement

**Before:** Constant velocity (each task from scratch)
**After:** Accelerating velocity (patterns compound over time)

**Example:**
```
Task 1: Implement dataset (20 min, learn pattern)
Task 2: Implement split (15 min, reuse pattern from Task 1)
Task 3: Implement augmentation (10 min, reuse patterns from Tasks 1-2)
```

### 5. Context Clarity

**Before:** Long conversation → AI confused about what's complete vs in-progress
**After:** Context reset → AI always knows exactly current task state

### 6. Portfolio Quality

**Before:** Large changes hard to review → bugs slip through
**After:** Atomic commits easy to review → production quality

---

## Alignment with Your Policies

### Development Environment Policy

**Enforced:**
- Artifacts in correct directories (task artifacts → `~/dev/devruns/<project>/task-XXX/`)
- No repo pollution (models, data, build outputs isolated)
- Naming conventions (task IDs follow pattern)

### ML/CV Operations Policy

**Enforced:**
- Experiment tracking per task
- Reproducibility (seeds, versions logged)
- Data versioning (DVC for datasets)

### Production Policy

**Enforced:**
- Code quality (validation checks)
- Testing standards (TDD approach)
- Git discipline (atomic commits)

### AI Workflow Policy

**Enforced:**
- Socratic method (task-level questioning)
- Verification protocols (mandatory validation)
- Spec-driven development (tasks from specs)

---

## Migration Path

### If You Have Existing CLAUDE.md

**Option A: Start Fresh**
1. Archive old CLAUDE.md → `CLAUDE_ARCHIVE_v1.md`
2. Copy claude-md-template-v2.md → `CLAUDE.md`
3. Migrate essential patterns manually

**Option B: Incremental Migration**
1. Add "Self-Improving Loop Protocol" section to existing CLAUDE.md
2. Start using task-based updates going forward
3. Gradually restructure old content

### If You Have Existing Projects

**For new features:**
- Use task decomposition immediately
- Apply atomic task loop from start

**For existing features:**
- Continue current approach
- Adopt loop for refactors/enhancements

---

## Success Metrics

**Track these to measure loop effectiveness:**

### Estimation Accuracy
```bash
# Are tasks completing in estimated time?
jq '.tasks[] | select(.status == "complete") |
  {id, est: .estimated_minutes, act: .actual_minutes}' tasks.json
```

**Target:** 80%+ tasks within ±25% of estimate

### Validation Pass Rate
```bash
# How often do tasks pass validation on first try?
grep "Status: ✅ Passed" CLAUDE.md | wc -l
```

**Target:** 70%+ first-time pass rate

### Pattern Reuse Rate
```bash
# How often are CLAUDE.md patterns referenced?
grep "Patterns applied:" CLAUDE.md | wc -l
```

**Target:** Increasing over time

### Velocity Trend
```bash
# Are similar tasks getting faster?
# Compare task-001 vs task-010 actual times for similar work
```

**Target:** Decreasing time for similar task types

---

## Next Steps

### Immediate (Today)

1. **Read task-management-guide.md** — Understand decomposition process
2. **Practice decomposition** — Take one feature, break into tasks
3. **Execute one loop** — Complete one atomic task using new templates

### This Week

1. **Complete one feature** — Use full loop for entire feature
2. **Review CLAUDE.md growth** — See patterns accumulating
3. **Refine task granularity** — Adjust based on estimation accuracy

### This Month

1. **Build velocity metrics** — Track improvement over time
2. **Optimize loop** — Identify bottlenecks, improve process
3. **Create custom patterns** — Add ML/CV-specific patterns to CLAUDE.md

---

## Questions & Troubleshooting

### "Is this overkill for small projects?"

**Short answer:** No.

**Why:** Even for small projects, the loop provides:
- Better code quality (validation catches bugs)
- Learning retention (patterns captured)
- Portfolio-ready commits (atomic, reviewable)

**Adjustment:** For very small projects, reduce formality:
- Keep tasks.json simple (fewer fields)
- Use lightweight CLAUDE.md (just patterns section)
- Still do atomic tasks + validation + learning

### "What if a task takes >30 minutes?"

**Options:**

1. **Split mid-task** — Pause, decompose remaining work
2. **Complete and reflect** — Finish task, update estimate for future
3. **Mark blocked** — If truly blocked, move to next task

**Don't:** Skip validation or learning capture

### "How to handle emergencies/hotfixes?"

**For urgent bugs:**
1. Create emergency task: `task-emergency-001`
2. Execute with same loop discipline
3. Still validate, still capture learning
4. Return to planned tasks after

**Why:** Discipline prevents emergency from becoming disaster

### "Can I use this with pair programming?"

**Yes!** The loop works great with human partners:

**Human:** "Let's add data augmentation"
**AI:** "I see task-003 in tasks.json covers this. Reading CLAUDE.md for augmentation patterns... Ready to implement."
[Executes task]
**AI:** "Validation passed. Updated CLAUDE.md with augmentation pattern. Context reset. Ready for task-004."

---

## Conclusion

**Core Insight from Osmani:**

> "The magic isn't in the AI's intelligence. It's in the disciplined loop that compounds learning over time."

**Your modified templates enforce this discipline mechanically:**

1. **Atomic tasks** → Manageable scope
2. **Validation gates** → Quality enforcement
3. **Immediate learning** → Knowledge accumulation
4. **Context reset** → Fresh thinking

**Result:** Velocity and quality both improve over time.

---

**Version:** 1.0
**Files Modified:**
- claude-md-template-v2.md
- prompt-template-v2.md
- mcp-template-v2.md

**Files Created:**
- task-management-guide.md
- modifications-summary.md (this file)

**Next:** Execute one complete loop to validate approach.
