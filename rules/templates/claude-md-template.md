# CLAUDE.md — Shared Team Knowledge

**Purpose:** This file captures project-specific patterns, common mistakes, and learnings to help Claude Code work more effectively on this project. Update it continuously as patterns emerge.

**Location:** Repository root (`CLAUDE.md`)
**Version Control:** Committed to git, updated as needed

---

## Update Protocol

### When to Update CLAUDE.md

**Immediate updates (within same session):**
- ✅ Claude makes a mistake that could recur
- ✅ New pattern discovered through debugging
- ✅ Successful workaround for known limitation
- ✅ Integration gotcha encountered
- ✅ Anti-pattern identified in code review

**Periodic updates (end of day/week):**
- Review session logs for repeated issues
- Consolidate similar mistakes into patterns
- Remove obsolete entries (no longer relevant)
- Update verification commands if they changed
- Sync with team about shared learnings

### Update Format

**For mistakes:**
```markdown
### [YYYY-MM-DD] Mistake: [Brief Title]
**What:** [What went wrong - be specific]
**Why:** [Root cause if known]
**Prevention:** [Explicit rule to follow next time]
**Example:** [Code snippet showing correct approach]
```

**For successful patterns:**
```markdown
### [YYYY-MM-DD] Pattern: [Pattern Name]
**Context:** [When to use this pattern]
**Implementation:** [How to implement it]
**Benefits:** [Why this works better]
**Example:** [Code snippet or command]
```

### Review Checklist
- [ ] Entry is specific and actionable (not vague)
- [ ] Prevention rule is clear and enforceable
- [ ] Example code is minimal and correct
- [ ] Date added for future audit trail
- [ ] Related to project patterns (not one-off issues)
- [ ] No sensitive data or credentials included

---

## Project-Specific Rules

### Scope & Boundaries
- [ ] Work only within this repository
- [ ] Never access files outside the repo
- [ ] Follow sandbox restrictions (if applicable)
- [ ] Respect `.claudeignore` exclusions

### Code Style & Patterns
- [ ] Preferred patterns: [list patterns]
  - Example: Use dataclasses for DTOs
  - Example: Prefer composition over inheritance
- [ ] Anti-patterns to avoid: [list anti-patterns]
  - Example: No global state
  - Example: Avoid deep nesting (max 3 levels)
- [ ] Formatting: [black/ruff/prettier/etc.]
- [ ] Naming conventions: [describe conventions]
  - Example: snake_case for functions, PascalCase for classes

### Architecture & Design
- [ ] Key architectural decisions: [list decisions]
- [ ] Module boundaries: [describe boundaries]
- [ ] Integration points: [list integrations]
- [ ] Dependencies: [critical dependencies]
  - Example: FastAPI for API endpoints
  - Example: SQLAlchemy for database ORM

---

## Common Mistakes & How to Avoid Them

### Example Mistake Format:
### [2026-01-15] Mistake: Import Cycles in Domain Layer
**What happened:** Claude created imports that caused circular dependencies
**Why it happened:** Added repository dependency directly in entity file
**How to avoid:** Always import repositories in service layer only, not in entities
**Example:**
```python
# ❌ Wrong: entity.py
from repositories import UserRepo  # Creates cycle

# ✅ Correct: entity.py
# No repository imports here

# ✅ Correct: service.py
from entities import User
from repositories import UserRepo
```
**Date added:** 2026-01-15

---

## Successful Patterns

### Example Pattern Format:
### [2026-01-20] Pattern: Dependency Injection via Constructor
**What it is:** Pass dependencies through constructor instead of global imports
**When to use:** For services, repositories, and controllers
**Benefits:** Easier testing, clearer dependencies, better modularity
**Example:**
```python
class UserService:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    def get_user(self, id: int) -> User:
        return self.user_repo.get(id)
```
**Date added:** 2026-01-20

---

## Subagents

### Definition
Reusable mini-agents that handle specific repetitive tasks. Trigger with `/[command]`.

### Standard Subagents

#### /simplify — Code Simplification Agent
**Purpose:** Reduce complexity in generated code
**Checklist:**
- [ ] Remove unnecessary abstractions
- [ ] Inline single-use functions (if < 5 lines)
- [ ] Eliminate redundant checks
- [ ] Simplify conditional logic
- [ ] Replace complex comprehensions with loops if clearer
**Example:** `/simplify src/utils.py`

#### /verify — Verification Agent
**Purpose:** Run full verification suite
**Checklist:**
- [ ] Run tests: `pytest -v`
- [ ] Run linting: `ruff check .`
- [ ] Run type checking: `mypy src/`
- [ ] Check security: `./scripts/security-check.sh`
- [ ] Verify imports resolve
- [ ] Confirm no TODOs or FIXME remain
- [ ] Check code coverage meets threshold
**Example:** `/verify`

#### /doc — Documentation Agent
**Purpose:** Generate/update documentation
**Checklist:**
- [ ] Update docstrings (Google style)
- [ ] Generate API docs if needed
- [ ] Update CHANGELOG.md
- [ ] Update README.md if API changed
- [ ] Check for broken links in docs
- [ ] Verify examples are working
**Example:** `/doc src/api/`

#### /test — Test Generation Agent
**Purpose:** Generate comprehensive tests for module
**Checklist:**
- [ ] Create test file if missing
- [ ] Cover happy path cases
- [ ] Cover edge cases
- [ ] Cover error cases
- [ ] Use fixtures for setup
- [ ] Mock external dependencies
- [ ] Verify test independence (can run in any order)
**Example:** `/test src/models/user.py`

#### /security — Security Check Agent
**Purpose:** Perform security audit on changes
**Checklist:**
- [ ] Scan for hardcoded secrets
- [ ] Check for SQL injection risks
- [ ] Verify input validation
- [ ] Check authentication/authorization
- [ ] Review dependency vulnerabilities
- [ ] Confirm no sensitive data in logs
**Example:** `/security src/api/`

#### /perf — Performance Check Agent
**Purpose:** Analyze performance implications
**Checklist:**
- [ ] Profile code execution time
- [ ] Check for N+1 queries
- [ ] Verify async operations
- [ ] Review memory usage
- [ ] Check for unnecessary loops
- [ ] Optimize database queries
**Example:** `/perf src/services/data_processor.py`

### Creating Custom Subagents

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

**Best practices for custom subagents:**
- Keep focused (single responsibility)
- Make triggers memorable (short, clear verbs)
- Include explicit success criteria
- Document expected inputs/outputs
- Provide concrete examples
- Test before adding to shared CLAUDE.md

---

## Verification Requirements

### Required Checks (Before PR)
- [ ] Tests must pass: `pytest -v`
- [ ] Linting must pass: `ruff check .`
- [ ] Type checking must pass: `mypy src/`
- [ ] Security scan: `./scripts/security-check.sh`
- [ ] Performance benchmarks: `pytest benchmarks/ --benchmark-only`
- [ ] Code coverage: `pytest --cov=src --cov-report=term-missing` (min 80%)

### Verification Patterns

#### Pattern: API Endpoint Verification
**How to verify:**
1. Run server: `uvicorn app.main:app --reload`
2. Test endpoint: `curl -X POST http://localhost:8000/api/users -d '...'`
3. Check logs for errors
4. Verify database state
5. Run integration tests: `pytest tests/integration/`

#### Pattern: Database Migration Verification
**How to verify:**
1. Apply migration: `alembic upgrade head`
2. Check schema: `alembic current`
3. Verify data integrity: SQL queries
4. Test rollback: `alembic downgrade -1`
5. Reapply: `alembic upgrade head`

---

## Integration Points

### External Services
- [ ] Service A: [how to integrate, auth, rate limits, etc.]
- [ ] Service B: [how to integrate, auth, rate limits, etc.]

### Dependencies
- [ ] Critical dependency X: [version, usage notes, gotchas]
- [ ] Critical dependency Y: [version, usage notes, gotchas]

---

## Workflow Preferences

### Preferred Approaches

#### How we handle database access:
- Always use SQLAlchemy ORM
- Repository pattern for all queries
- No raw SQL unless performance-critical
- Use async session for async endpoints

#### How we structure services:
- One service per domain entity
- Services inject repositories
- Keep services stateless
- Use dependency injection

### Tools & Commands

**Common commands:**
```bash
# Development
make dev           # Start dev server
make test          # Run all tests
make lint          # Run linting
make format        # Format code

# Database
make migrate       # Run migrations
make rollback      # Rollback last migration
make seed          # Seed test data

# Deployment
make build         # Build Docker image
make deploy-dev    # Deploy to dev
```

**Custom slash commands:** (see Subagents section above)
- `/verify` — Run full verification suite
- `/simplify` — Reduce code complexity
- `/doc` — Update documentation
- `/test` — Generate tests
- `/security` — Security audit
- `/perf` — Performance analysis

---

## Session Notes

### Session Templates

**Session Start:**
```markdown
## Session: [Name] — [Date]
**Purpose:** [Goal for this session]
**Scope:** [Files/modules to change]
**Plan:** [Link to plan.md or inline steps]
**Expected duration:** [Estimate in minutes]
```

**Session End:**
```markdown
**Outcome:** [Success/Partial/Failed]
**Completed:**
- [x] Task 1
- [x] Task 2
**Remaining:**
- [ ] Task 3
**Next steps:** [What needs to happen next]
**CLAUDE.md updates:** [What mistakes/patterns were added]
```

### Recent Sessions

[Keep last 5-10 sessions here for context, then archive older ones]

---

## Notes & Maintenance

### Maintenance Rules
- Update this file whenever Claude makes a preventable mistake
- Keep entries concise and actionable (no walls of text)
- Remove outdated entries during weekly review
- Focus on patterns, not one-off issues
- Prioritize recent, frequently-occurring issues
- Archive old but useful patterns to separate doc

### Review Schedule
- **Daily:** Quick scan for new mistakes/patterns (5 min)
- **Weekly:** Consolidate similar entries (15 min)
- **Monthly:** Major cleanup and archival (30 min)

### Archive Policy
When CLAUDE.md exceeds 1000 lines:
1. Move old patterns to `CLAUDE_ARCHIVE.md`
2. Keep only last 6 months of entries
3. Keep frequently-referenced patterns
4. Link to archive in this file

---

**Last updated:** [YYYY-MM-DD]
**Maintained by:** [Team/Individual]
**File version:** v1.0
