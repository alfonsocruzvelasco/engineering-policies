# Session Management Policy

**Status:** Authoritative
**Last updated:** 2026-02-01

---

## Purpose

Define discipline around Claude Code session management to maintain focused contexts, prevent context pollution, and enable effective parallel workflows. This policy operationalizes the workflow principles in `ai-usage-policy.md` with specific session lifecycle management.

**Core principle:** **Focused contexts win.** Each session should have a clear purpose, bounded scope, and defined exit criteria. Long, unfocused sessions lead to context pollution, wasted tokens, and reduced effectiveness.

---

## Index

- [Purpose](#purpose)
- [Session Types](#session-types)
- [Parallel Session Guidelines](#parallel-session-guidelines)
- [Session Lifecycle](#session-lifecycle)
- [Session Metrics](#session-metrics)
- [Anti-Patterns](#anti-patterns)
- [Integration with Other Policies](#integration-with-other-policies)

---

## Session Types

### 1. Planning Session

**Purpose:** Generate plans without implementation. Explore requirements, break down tasks, define scope and constraints.

**Characteristics:**
- **Max duration:** 30 minutes
- **Output:** Approved plan document (plan.md or tasks.md)
- **Exit criteria:** Plan reviewed, tasks defined, acceptance criteria clear
- **Context scope:** High-level architecture, requirements, constraints

**When to use:**
- Starting a new feature (>3 files)
- Architectural decisions needed
- Complex refactoring
- Integration tasks with multiple dependencies

**Workflow:**
1. Start session with planning request
2. Use Plan Mode or structured planning prompt
3. Generate task breakdown
4. Review and approve plan
5. Document plan in `plan.md` or `tasks.md`
6. End session (don't implement yet)

**Integration:** Works with `spec-driven-development-policy.md` — planning sessions generate specs before implementation.

---

### 2. Implementation Session

**Purpose:** Execute against approved plan. Write code, create tests, implement features.

**Characteristics:**
- **Max context:** 5 files, 500 lines changed per session
- **Max duration:** 90 minutes (target: <60 minutes)
- **Output:** Working code + tests + verification
- **Exit criteria:** All task checkpoints green, code reviewed, tests passing

**When to use:**
- Executing approved plan
- Implementing single feature or module
- Writing tests for existing code
- Small refactors (<500 lines)

**Workflow:**
1. Start session with plan reference
2. Implement tasks sequentially
3. Show diff after each task
4. Run verification after each major change
5. Update CLAUDE.md if mistakes found
6. End session when all tasks complete

**Scope boundaries:**
- **Stop and split if:** Context >5 files, changes >500 lines, scope creeps
- **Create new session for:** Different feature, different module, different concern

**Integration:** Follows `ai-usage-policy.md` diff-first workflow and verification gates.

---

### 3. Verification Session

**Purpose:** Review, test, security scan, and validate changes before merge.

**Characteristics:**
- **Max duration:** 20 minutes
- **Output:** Verification report (tests, security, quality checks)
- **Exit criteria:** All gates passed (tests, linting, security, type checking)

**When to use:**
- Before creating PR
- After implementation session completes
- When verification fails in implementation session
- Periodic quality checks

**Workflow:**
1. Start session with verification request
2. Run full test suite
3. Run security checks
4. Run linting and type checking
5. Review code quality
6. Generate verification report
7. End session with pass/fail status

**Verification checklist:**
- [ ] All tests pass
- [ ] No security findings
- [ ] Linting passes
- [ ] Type checking passes
- [ ] Code review completed
- [ ] Documentation updated

**Integration:** Enforces `ai-coding-security-policy.md` verification gates.

---

### 4. Debugging Session

**Purpose:** Investigate and fix issues. Root cause analysis and resolution.

**Characteristics:**
- **Max iterations:** 10 attempts
- **Max duration:** 60 minutes
- **Output:** Root cause + fix + prevention strategy
- **Exit criteria:** Issue reproduced, root cause identified, fix verified

**When to use:**
- Tests failing
- Production issues
- Unexpected behavior
- Performance problems

**Workflow:**
1. Start session with issue description
2. Reproduce issue
3. Investigate root cause
4. Implement fix
5. Verify fix resolves issue
6. Update CLAUDE.md with prevention strategy
7. End session

**Stop conditions:**
- **After 10 iterations:** Escalate, get help, or take different approach
- **If stuck:** Document findings, pause, resume with fresh context

**Integration:** Uses verification-first mindset from `ai-usage-policy.md`.

---

### 5. Refactoring Session

**Purpose:** Improve code structure without changing behavior. Clean up technical debt.

**Characteristics:**
- **Max context:** 3-5 files per session
- **Max duration:** 90 minutes
- **Output:** Refactored code + tests still passing
- **Exit criteria:** All tests pass, behavior unchanged, code improved

**When to use:**
- Code simplification
- Removing technical debt
- Improving maintainability
- Extracting patterns

**Workflow:**
1. Start session with refactoring goal
2. Write tests to capture current behavior
3. Refactor incrementally
4. Verify tests still pass after each change
5. Update documentation
6. End session

**Critical rule:** **Tests must pass before and after.** Refactoring without tests is dangerous.

---

## Parallel Session Guidelines

### When to Run Parallel Sessions

**Good use cases:**
- ✅ Feature A (branch: `feature-a`) + Feature B (branch: `feature-b`)
- ✅ Implementation (main session) + Verification (background session)
- ✅ Planning (architecture exploration) + Prototyping (spike)
- ✅ Different modules with no shared dependencies
- ✅ Independent bug fixes in different areas

**Bad use cases:**
- ❌ Same file in multiple sessions (merge conflicts)
- ❌ Overlapping dependency changes (coordination nightmare)
- ❌ Shared state without coordination (race conditions)
- ❌ Related features that need to work together (do sequentially)

**Decision rule:** If sessions can conflict, run sequentially. If truly independent, run in parallel.

---

### Session Coordination

#### File Ownership

**Each session "owns" specific files:**
- Document ownership in session start notes
- No concurrent edits to shared files
- If overlap needed, coordinate explicitly

**Example:**
```markdown
Session: User Authentication
Files owned:
- src/auth/__init__.py
- src/auth/models.py
- src/auth/service.py
- tests/auth/test_service.py
```

#### Branch Discipline

**One session per feature branch:**
- Create branch before starting session
- Work only in that branch during session
- Merge only after session completes
- No branch switching within session

**Exception:** Verification sessions can run on any branch, but don't modify code.

#### Communication

**Name sessions clearly:**
- Use descriptive terminal titles
- Log session purpose in first prompt
- Record session outcomes in CLAUDE.md
- Document file ownership in session notes

**Example terminal titles:**
- `[Planning] User Auth Feature`
- `[Impl] User Auth - Service Layer`
- `[Verify] User Auth PR #42`
- `[Debug] Login Failure Issue`

---

## Session Lifecycle

### 1. Session Start

**Required template:**

```markdown
## Session: [Name] — [Date]

**Type:** [Planning/Implementation/Verification/Debugging/Refactoring]
**Purpose:** [Clear goal for this session]
**Scope:** [Files/modules to change]
**Plan:** [Link to plan.md or inline steps]
**Files owned:** [List of files this session will modify]
**Expected duration:** [Estimate in minutes]
**Success criteria:** [What "done" looks like]
```

**Example:**

```markdown
## Session: User Authentication Service — 2026-02-01

**Type:** Implementation
**Purpose:** Implement user authentication service with JWT tokens
**Scope:**
- src/auth/service.py (new)
- src/auth/models.py (new)
- tests/auth/test_service.py (new)
**Plan:** See plan.md (tasks 1-3)
**Files owned:**
- src/auth/service.py
- src/auth/models.py
- tests/auth/test_service.py
**Expected duration:** 45 minutes
**Success criteria:**
- Service implements login/logout/refresh
- All tests pass
- Security checks pass
- Code reviewed
```

---

### 2. During Session

**Discipline checklist:**

- [ ] Check off tasks as completed
- [ ] Update CLAUDE.md immediately if mistakes found
- [ ] Verify after each major change (don't wait until end)
- [ ] Stop if scope creeps (start new session)
- [ ] Document decisions in session notes
- [ ] Keep context focused (don't wander)

**Scope creep detection:**
- **Stop if:** Adding unrelated features ("while we're at it...")
- **Stop if:** Context grows beyond 5 files
- **Stop if:** Changes exceed 500 lines
- **Stop if:** Session duration >90 minutes

**When to split:**
1. Identify what's out of scope
2. Document remaining work
3. End current session
4. Start new session with clear scope

---

### 3. Session End

**Required template:**

```markdown
## Session End: [Name] — [Date]

**Outcome:** [Success/Partial/Failed]
**Duration:** [Actual time spent]
**Completed:**
- [x] Task 1: [Description]
- [x] Task 2: [Description]
**Remaining:**
- [ ] Task 3: [Description] (defer to next session)
**Next steps:** [What needs to happen next]
**CLAUDE.md updates:**
- Added mistake: [Brief description]
- Added pattern: [Brief description]
**Metrics:**
- Files changed: [Number]
- Lines changed: [Number]
- Tests added: [Number]
- Verification: [Pass/Fail]
```

**Example:**

```markdown
## Session End: User Authentication Service — 2026-02-01

**Outcome:** Success
**Duration:** 52 minutes
**Completed:**
- [x] Task 1: Implement login method with JWT
- [x] Task 2: Implement logout method
- [x] Task 3: Write unit tests for service
**Remaining:**
- [ ] Task 4: Add refresh token logic (defer to next session)
**Next steps:**
- Create verification session for security review
- Implement refresh token in separate session
**CLAUDE.md updates:**
- Added pattern: JWT token validation using PyJWT
**Metrics:**
- Files changed: 3
- Lines changed: 287
- Tests added: 12
- Verification: Pass
```

**Critical requirement:** **Don't close session without updating CLAUDE.md** if mistakes or patterns were discovered.

---

## Session Metrics

### What to Track

**Per session:**
- Duration (start to end)
- Tasks completed
- Files changed
- Lines changed
- Context resets needed
- CLAUDE.md updates made
- Verification pass/fail

**Aggregate (weekly/monthly):**
- Average session duration
- Tasks per session
- Context resets per session
- CLAUDE.md updates per session
- Verification pass rate
- Session type distribution

### Target Metrics

**Session effectiveness:**
- ✅ Session duration: **<90 minutes** (target: <60 minutes)
- ✅ Tasks per session: **3-7** (sweet spot for focus)
- ✅ Context resets: **0-1** (should rarely need to reset)
- ✅ CLAUDE.md updates: **1-3** per session (capturing learnings)

**Quality metrics:**
- ✅ Verification pass rate: **>80%** on first try
- ✅ Same mistakes: **<10%** recurrence rate
- ✅ Scope creep: **<5%** of sessions

**Automation metrics:**
- ✅ Subagent usage: **>50%** of routine tasks
- ✅ Hook execution: **>70%** of code changes

### Metrics Collection

**Manual tracking:**
- Log in session end template
- Review weekly in CLAUDE.md
- Adjust strategies based on data

**Automated tracking (future):**
- Create `/metrics` subagent
- Log to `SESSION_METRICS.md`
- Generate weekly reports

---

## Anti-Patterns

### ❌ Marathon Sessions

**What:** Sessions >3 hours without break
**Why bad:** Context pollution, token waste, reduced effectiveness
**Fix:** Split into focused sessions. Use 90-minute rule.

### ❌ Context Pollution

**What:** Mixing unrelated tasks in one session
**Why bad:** Confuses AI, wastes tokens, reduces quality
**Fix:** One concern per session. Split if scope creeps.

### ❌ Infinite Loops

**What:** >10 iterations without progress
**Why bad:** Wasted time, frustration, no value
**Fix:** Stop after 10 attempts. Escalate, get help, or take different approach.

### ❌ Scope Creep

**What:** "While we're at it..." additions
**Why bad:** Breaks session boundaries, delays completion
**Fix:** Document for next session. Keep current session focused.

### ❌ Session Hopping

**What:** Starting new session mid-task
**Why bad:** Loses context, creates confusion
**Fix:** Complete or properly end current session first.

### ❌ No Session Boundaries

**What:** Working without clear start/end
**Why bad:** No accountability, no metrics, no learning capture
**Fix:** Always use session templates. Document start and end.

### ❌ Ignoring CLAUDE.md

**What:** Not updating shared knowledge
**Why bad:** Same mistakes repeat, no team learning
**Fix:** Make CLAUDE.md updates mandatory in session end.

### ❌ Parallel Conflicts

**What:** Multiple sessions editing same files
**Why bad:** Merge conflicts, wasted work
**Fix:** Document file ownership. Coordinate or run sequentially.

---

## Integration with Other Policies

### ai-usage-policy.md

**This policy operationalizes:**
- Parallel Workflows section → Session coordination guidelines
- Plan Mode First → Planning session type
- Verification Feedback Loops → Verification session type
- Shared Team Knowledge → CLAUDE.md updates in session lifecycle

**Cross-reference:** See `ai-usage-policy.md` for workflow principles. This policy provides the "how" for implementing those principles.

---

### spec-driven-development-policy.md

**Planning sessions generate:**
- Specs (Spec Kit or OpenSpec)
- Task breakdowns
- Acceptance criteria

**Implementation sessions execute:**
- Tasks from approved plans
- Against spec requirements
- With verification checkpoints

**Integration:** Session management enforces spec-driven workflow discipline.

---

### ai-coding-security-policy.md

**Verification sessions enforce:**
- Security gates (Section 11)
- Pre-commit checks (Section 11.1)
- Code review requirements (Section 11.2)
- CI/CD pipeline checks (Section 11.3)

**Security integration:** Every implementation session must be followed by verification session before merge.

---

### development-environment-policy.md

**Session artifacts:**
- Stored in `~/dev/repos/<project>/`
- Follow workspace organization rules
- Respect artifact boundaries

**Integration:** Session notes and plans are development artifacts, subject to environment policy.

---

## Quick Reference

### Session Type Decision Tree

```
Is this a new feature? → Planning Session
  ↓
Is plan approved? → Implementation Session
  ↓
Is code complete? → Verification Session
  ↓
All gates pass? → Done

If stuck → Debugging Session
If improving code → Refactoring Session
```

### Session Start Checklist

- [ ] Session type identified
- [ ] Purpose clearly defined
- [ ] Scope bounded (files/modules)
- [ ] Plan referenced or created
- [ ] Files owned documented
- [ ] Duration estimated
- [ ] Success criteria defined
- [ ] Session start template filled

### Session End Checklist

- [ ] Outcome documented
- [ ] Tasks completed listed
- [ ] Remaining work identified
- [ ] Next steps defined
- [ ] CLAUDE.md updated (if needed)
- [ ] Metrics recorded
- [ ] Session end template filled

---

## References

- `ai-usage-policy.md` — Core workflow principles
- `spec-driven-development-policy.md` — Spec-driven workflow
- `ai-coding-security-policy.md` — Verification gates
- `templates/claude-md-template.md` — CLAUDE.md structure
- `development-environment-policy.md` — Artifact organization

---

**Last updated:** 2026-02-01
