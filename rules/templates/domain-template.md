# Domain Template v1.0

**Purpose:** Define agent authority boundaries, legitimate skills, and verification requirements for a specific work domain.

**Not a prompt. Not a tutorial. A constitution.**

---

## Template Structure

Copy this template to `/domains/{domain-name}.md` and fill in each section.

Recommended starting domains:
- `execution.md` — Code implementation and refactoring
- `review.md` — Code review and quality gates
- `governance.md` — Policy enforcement and compliance
- `planning.md` — Task decomposition and specification
- `documentation.md` — README, CLAUDE.md, and artifact updates

---

```markdown
# {Domain Name}

**Domain:** {execution | review | governance | planning | documentation | deployment | testing | infrastructure}
**Status:** Authoritative
**Last updated:** YYYY-MM-DD

---

## Scope

### This domain governs:
- [Specific activities or artifacts this domain controls]
- [Files, directories, or systems within scope]
- [Roles or tools permitted to operate here]

**Examples:**
- Execution: Implementation of features, bug fixes, refactoring
- Review: Code quality checks, security gates, compliance validation
- Planning: Task decomposition, specification generation, architecture decisions

### This domain does NOT govern:
- [Activities explicitly outside scope]
- [Handoff points to other domains]

**Examples:**
- Execution does NOT govern: security policy definition (→ governance domain)
- Review does NOT govern: deciding what to build (→ planning domain)

---

## Authority

### Agents are ALLOWED to:
- [ ] Read files within scope
- [ ] Modify files within scope (with constraints below)
- [ ] Create new files within scope
- [ ] Execute commands within scope
- [ ] Call approved tools/APIs
- [ ] Query internal knowledge bases (CLAUDE.md, specs)
- [ ] Generate diffs for human review

### Agents are FORBIDDEN from:
- [ ] Modifying files outside scope
- [ ] Auto-applying changes without human approval
- [ ] Accessing credentials or secrets
- [ ] Making architectural decisions (unless planning domain)
- [ ] Bypassing verification gates
- [ ] Executing shell commands without explicit permission
- [ ] Accessing files outside repository sandbox
- [ ] Changing security-critical code without explicit request

**Hard boundaries:**
- Sandbox restriction: `${SANDBOX_ROOT:-~/dev/repos/github.com/${GH_USER}/sandbox-claude-code/}`
- No `~/.config` or system modifications
- No secrets in prompts, logs, or code

---

## Legitimate Skills

### Required skills for this domain:
1. **[Skill 1]:** [Why this skill is essential]
2. **[Skill 2]:** [Why this skill is essential]
3. **[Skill 3]:** [Why this skill is essential]

**Examples:**
- Execution domain: Python coding, pytest writing, git operations
- Review domain: Static analysis, security scanning, policy validation
- Planning domain: Task decomposition, spec generation, architecture design

### Skills NOT legitimate here:
- [Skills that belong in other domains]
- [Skills that require human judgment]

**Examples:**
- Execution: Security policy authoring (→ governance)
- Review: Feature prioritization (→ planning)

---

## Authoritative Documents

### Primary sources (must follow):
1. **[Policy name]:** `/path/to/policy.md` — [What it governs]
2. **[Template name]:** `/path/to/template.md` — [What it defines]
3. **[Knowledge base]:** `CLAUDE.md` — [Project-specific patterns]

**Examples:**
- Execution: `ai-workflow-policy.md`, `language-policies.md`, `CLAUDE.md`
- Review: `security-policy.md`, `testing-policy.md`, `production-policy.md`
- Planning: `ai-workflow-policy.md` (Part 4: Spec-Driven Development)

### Secondary sources (informative):
- [Supporting references]
- [Best practices guides]

---

## Verification Requirements

### Before any work is "done":
1. **[Check 1]:** [What must be validated] → [How to validate]
2. **[Check 2]:** [What must be validated] → [How to validate]
3. **[Check 3]:** [What must be validated] → [How to validate]

**Examples (Execution domain):**
1. **Tests pass:** All pytest tests green → `pytest tests/`
2. **Linting clean:** No flake8 errors → `flake8 src/`
3. **Diff reviewed:** Human approved changes → Manual review required
4. **CLAUDE.md updated:** Learnings captured → Check file updated

**Examples (Review domain):**
1. **Security scan:** No critical vulnerabilities → `bandit -r src/`
2. **Type checks:** No mypy errors → `mypy src/`
3. **Coverage maintained:** >80% coverage → `pytest --cov=src`

### Verification gates (mandatory):
- [ ] Automated checks must pass (tests, linters, type checkers)
- [ ] Security gates must pass (if applicable)
- [ ] Human review required (if modifying critical code)
- [ ] Documentation updated (CLAUDE.md, README, specs)
- [ ] Task marked complete in tracking system

### What "done" means:
- [Definition of done specific to this domain]
- [Handoff criteria to next domain]

**Examples:**
- Execution: Code committed, tests passing, CLAUDE.md updated → Ready for review
- Review: All gates passed, approval logged → Ready for merge
- Planning: Spec validated, tasks decomposed, acceptance criteria defined → Ready for execution

---

## @Handler Routing

### Handlers that invoke this domain:
- `@{handler-name}` — [What this handler does]

**Examples:**
- Execution: `@implement`, `@refactor`, `@bugfix`
- Review: `@review`, `@security-check`, `@quality-gate`
- Planning: `@plan`, `@spec`, `@decompose`

### Handoff to other domains:
- After completion → Route to `@{next-handler}`

**Examples:**
- Execution complete → `@review`
- Review approved → `@merge` (or human decision)
- Planning complete → `@implement`

---

## Integration Points

### Upstream dependencies:
- This domain receives work from: [{domain-name}]
- Input format: [What arrives from upstream]

**Examples:**
- Execution receives: Approved specs from planning domain
- Review receives: Completed code from execution domain

### Downstream handoffs:
- This domain sends work to: [{domain-name}]
- Output format: [What gets passed downstream]

**Examples:**
- Execution sends: Draft PR to review domain
- Review sends: Approved PR to merge (human decision)

---

## Domain-Specific Rules

### Critical constraints:
1. **[Constraint 1]:** [Why this is non-negotiable]
2. **[Constraint 2]:** [Why this is non-negotiable]

**Examples (Execution domain):**
1. **Max 200 lines per diff:** Keeps changes reviewable and reduces risk
2. **One task per session:** Prevents scope creep and context pollution
3. **Tests required:** No code without validation path

**Examples (Review domain):**
1. **No auto-approval:** Human must review all changes
2. **Security critical → Manual review:** Automated checks insufficient
3. **Failed gate → Blocks merge:** No exceptions without documented override

**Examples (Governance domain):**
1. **Policy changes require diff review:** No silent policy updates — same review discipline as code
2. **Cross-references must be valid:** Broken policy cross-references are bugs; CI should catch them
3. **Hypothesis Stress Test for reasoning:** All AI-assisted policy reasoning must include disconfirmation phase (see `ai-workflow-policy.md §13.2`)

### Anti-patterns to prevent:
- ❌ [Anti-pattern 1]: [Why it's harmful] → [Alternative approach]
- ❌ [Anti-pattern 2]: [Why it's harmful] → [Alternative approach]

**Examples (Execution domain):**
- ❌ Marathon coding sessions (>3 hours): Context pollution, diminishing returns → Use 90-minute rule
- ❌ Scope creep ("while we're at it..."): Delays completion, increases risk → Document for next task
- ❌ Skipping tests: Technical debt, regression risk → Require tests or repro command

**Examples (Review domain):**
- ❌ Rubber-stamping reviews: Misses issues, degrades quality → Use checklists, enforce gates
- ❌ Incomplete security scans: Vulnerabilities slip through → Mandate all gates before approval

**Examples (Governance domain):**
- ❌ Policy without enforcement mechanism: Becomes shelfware → Every rule needs a verification gate or CI check
- ❌ Accepting AI reasoning as evidence: Inflates confidence without truth convergence → Separate evidence from interpretation (`documentation-policy.md §6`)
- ❌ Importing external tooling conventions as general standards: Scope mismatch → Evaluate applicability to your actual stack first

---

## Success Metrics

### How to measure this domain is working:
- [Metric 1]: [Target or threshold]
- [Metric 2]: [Target or threshold]
- [Metric 3]: [Target or threshold]

**Examples (Execution domain):**
- Task completion rate: >80% of tasks complete on first attempt
- Diff size: <200 lines average
- Test coverage: Maintained or increased (never decreased)
- CLAUDE.md updates: 100% of tasks logged

**Examples (Review domain):**
- Gate pass rate: >90% of automated checks pass first time
- Security findings: <5 critical issues per quarter
- Review turnaround: <24 hours average

**Examples (Governance domain):**
- Cross-reference integrity: 0 broken internal links (CI-enforced)
- Policy staleness: <10% of policy documents past review cadence
- Retrieval policy compliance: Knowledge base ingestion rules followed (`ai-retrieval-policy.md §2`)

---

## Conflict Resolution

### When this domain conflicts with another:
1. [Principle for resolving conflicts]
2. [Escalation path if unresolved]

**General principles:**
- Security always wins over speed
- Human judgment overrides automation
- Documented policy overrides undocumented convention
- When in doubt → Ask human before proceeding

**Examples:**
- Execution vs Security: If faster implementation weakens security → Security wins
- Review vs Speed: If expediting bypasses gates → Gates win
- Planning vs Execution: If plan is ambiguous → Stop and clarify before implementing

---

## Maintenance

### Review frequency:
- [How often to review this domain definition]

**Recommended:** Quarterly or after major project learnings

### Update triggers:
- New anti-patterns discovered
- Tools or frameworks changed
- Policy conflicts identified
- Team feedback or incidents

### Version history:
- v1.0 (YYYY-MM-DD): Initial domain definition
- [Future versions logged here]

---

## References

**Policies:**
- [Link to relevant policy documents]

**Templates:**
- [Link to relevant templates]

**Guides:**
- [Link to supporting guides or documentation]

---

**End of template. Copy and adapt for each domain.**
```

---

## Usage Examples

### Example 1: Execution Domain

```markdown
# Execution

**Domain:** execution
**Status:** Authoritative
**Last updated:** 2026-02-06

---

## Scope

### This domain governs:
- Implementation of features from approved specs
- Bug fixes for existing functionality
- Refactoring to improve code quality
- Writing tests for new and existing code

### This domain does NOT govern:
- Security policy enforcement (→ review domain)
- Feature prioritization (→ planning domain)
- Production deployment (→ deployment domain)

---

## Authority

### Agents are ALLOWED to:
- [x] Read files within repository sandbox
- [x] Modify files specified in task scope
- [x] Create new test files
- [x] Execute pytest, linters, type checkers
- [x] Generate diffs for human review
- [x] Query CLAUDE.md for project patterns

### Agents are FORBIDDEN from:
- [x] Auto-applying changes without human approval
- [x] Modifying security-critical code without explicit request
- [x] Accessing files outside `${SANDBOX_ROOT}`
- [x] Making architectural decisions (→ planning domain)
- [x] Bypassing test requirements
- [x] Committing to git without human approval

**Hard boundaries:**
- Sandbox: `~/dev/repos/github.com/alfonsocruzvelasco/sandbox-claude-code/`
- Max 200 lines per diff
- Tests required for all code changes

---

## Legitimate Skills

### Required skills:
1. **Python coding:** Implement features per spec
2. **Pytest writing:** Create tests for validation
3. **Git operations:** Create branches, generate diffs
4. **Linting compliance:** Follow flake8, black, mypy

### Skills NOT legitimate:
- Security policy definition (→ governance)
- Architecture decisions (→ planning)
- Production deployment (→ deployment)

---

## Authoritative Documents

### Primary sources:
1. **ai-workflow-policy.md:** Core workflow and verification requirements
2. **language-policies.md:** Python style and best practices
3. **CLAUDE.md:** Project-specific patterns and mistakes
4. **tasks.json:** Current task definitions and acceptance criteria

---

## Verification Requirements

### Before work is "done":
1. **Tests pass:** All pytest tests green → `pytest tests/`
2. **Linting clean:** No errors → `flake8 src/ && black --check src/ && mypy src/`
3. **Diff reviewed:** Human approved changes → Manual review required
4. **CLAUDE.md updated:** Patterns/mistakes captured → Check timestamp
5. **Task marked complete:** Status updated in tasks.json

### What "done" means:
- Code implements spec requirements
- All acceptance criteria met
- Tests passing
- Diff <200 lines
- Ready for review domain

---

## @Handler Routing

### Handlers that invoke this domain:
- `@implement` — Feature implementation from approved spec
- `@refactor` — Code quality improvements
- `@bugfix` — Fix existing issues

### Handoff to other domains:
- After completion → `@review`

---

## Domain-Specific Rules

### Critical constraints:
1. **Max 200 lines per diff:** Maintains reviewability
2. **One task per session:** Prevents scope creep
3. **Tests always required:** No code without validation
4. **Spec must exist:** No implementation without approved plan

### Anti-patterns:
- ❌ Scope creep ("while we're at it..."): Document separately
- ❌ Marathon sessions (>3 hours): Use 90-minute rule
- ❌ Skipping tests: Requires test or repro command

---

## Success Metrics

- Task completion rate: >80% first-attempt success
- Average diff size: <200 lines
- Test coverage: Maintained or improved
- CLAUDE.md updates: 100% task compliance

---

**End of Execution Domain**
```

---

### Example 2: Review Domain

```markdown
# Review

**Domain:** review
**Status:** Authoritative
**Last updated:** 2026-02-06

---

## Scope

### This domain governs:
- Code quality verification
- Security gate enforcement
- Test coverage validation
- Policy compliance checking

### This domain does NOT govern:
- Feature implementation (→ execution domain)
- Deployment decisions (→ deployment domain)
- Policy authoring (→ governance domain)

---

## Authority

### Agents are ALLOWED to:
- [x] Run automated security scans (bandit, safety)
- [x] Execute linters and type checkers
- [x] Generate code quality reports
- [x] Flag policy violations
- [x] Block merges that fail gates

### Agents are FORBIDDEN from:
- [x] Approving changes (human-only decision)
- [x] Bypassing security gates
- [x] Modifying code under review
- [x] Making architectural recommendations (→ planning)

---

## Legitimate Skills

### Required skills:
1. **Security scanning:** Identify vulnerabilities via bandit, safety
2. **Static analysis:** Run mypy, flake8, pylint
3. **Policy validation:** Check against documented rules
4. **Coverage analysis:** Verify pytest coverage requirements

### Skills NOT legitimate:
- Code implementation (→ execution)
- Feature design (→ planning)

---

## Authoritative Documents

### Primary sources:
1. **security-policy.md:** Security requirements and gates
2. **testing-policy.md:** Test coverage and quality standards
3. **production-policy.md:** Production readiness criteria
4. **ai-workflow-policy.md:** Verification workflows

---

## Verification Requirements

### Before approval:
1. **Security scan:** No critical findings → `bandit -r src/ && safety check`
2. **Type checks:** Zero mypy errors → `mypy src/`
3. **Linting:** Clean flake8 output → `flake8 src/`
4. **Tests:** All passing, >80% coverage → `pytest --cov=src tests/`
5. **Manual review:** Human inspected critical changes

### What "done" means:
- All automated gates passed
- Human review documented
- Approval logged
- Ready for merge (or human override)

---

## @Handler Routing

### Handlers that invoke this domain:
- `@review` — Full code review workflow
- `@security-check` — Security-only validation
- `@quality-gate` — Quality metrics validation

### Handoff:
- Gates pass → Ready for merge (human decision)
- Gates fail → Return to `@implement` with feedback

---

## Domain-Specific Rules

### Critical constraints:
1. **No auto-approval:** Human must review all changes
2. **Security gates mandatory:** No bypass without documented exception
3. **Failed gate blocks merge:** Hard stop, no exceptions

### Anti-patterns:
- ❌ Rubber-stamping reviews: Use gate results, not blind approval
- ❌ Incomplete scans: Run full gate suite
- ❌ Skipping manual review on security-critical code

---

## Success Metrics

- Gate pass rate: >90% first-time
- Security findings: <5 critical/quarter
- Review turnaround: <24 hours
- Zero bypassed gates

---

**End of Review Domain**
```

---

## Integration with Existing Infrastructure

### How domains fit with your stack:

```
Domain templates      → Define authority boundaries
.cursorrules         → Enforce behavior within domain
Task cards           → Define intent for domain work
@handlers            → Route work to appropriate domain
CLAUDE.md            → Capture domain-specific learnings
Policy docs          → Provide authoritative rules
```

**No overlap. Each layer has one job.**

---

## Recommended Starter Domains

Start with 3-5 domains maximum:

1. **execution.md**
   - Scope: Code implementation, refactoring, bug fixes
   - Authority: Modify code within task scope
   - Skills: Python, testing, git operations
   - Verification: Tests pass, diff reviewed

2. **review.md**
   - Scope: Quality gates, security checks, compliance
   - Authority: Run scans, flag violations, block merges
   - Skills: Static analysis, security scanning, policy validation
   - Verification: All gates passed, human approval logged

3. **planning.md**
   - Scope: Task decomposition, spec generation, architecture
   - Authority: Create specs, define tasks, make design decisions
   - Skills: Spec Kit, OpenSpec, architecture design
   - Verification: Spec validated, tasks atomic, criteria clear

4. **documentation.md** (optional)
   - Scope: README, CLAUDE.md, API docs, deployment guides
   - Authority: Update documentation files
   - Skills: Technical writing, markdown, API documentation
   - Verification: Docs accurate, up-to-date, complete

5. **governance.md** (optional, for policy work)
   - Scope: Policy definition, rule enforcement, compliance
   - Authority: Author/update policy documents
   - Skills: Security best practices, compliance standards
   - Verification: Policy conflicts resolved, standards documented

**Don't create more until you've used these for 2+ weeks.**

---

## Anti-Patterns to Avoid

### ❌ Premature Taxonomy
Creating 15+ domains before using any → Start with 3-5, refine later

### ❌ Overlapping Scopes
Unclear boundaries between domains → Be precise about handoffs

### ❌ Tool-Specific Domains
Domains tied to Cursor, Claude, etc. → Define by work type, not tool

### ❌ Replacing Prompts
Using domains as elaborate prompts → Keep them declarative and stable

### ❌ Over-Engineering
Making domains 5+ pages → Keep to ½-1 page maximum

---

## Maintenance Protocol

### When to update domain:
- New anti-pattern discovered
- Tool/framework change affects authority
- Policy conflict identified
- Team feedback after incident

### Review frequency:
- Quarterly for active domains
- After major project post-mortem
- When onboarding new team members

### Version control:
- Commit domains to git
- Track changes in version history section
- Document rationale for major changes

---

## Success Criteria

You know domains are working when:

✅ **Ambiguity eliminated:** No "should I allow this?" questions
✅ **Drift prevented:** Agents stay within boundaries
✅ **Overreach blocked:** Clear forbidden actions
✅ **Consistency achieved:** Same rules across repos
✅ **Friction reduced:** Less emotional decision-making
✅ **Learning captured:** Domain-specific patterns in CLAUDE.md
✅ **Handoffs clear:** No confusion about "who does what"

---

## References

**Policies integrated:**
- `ai-workflow-policy.md` — Core workflow, session management, spec-driven development
- `security-policy.md` — Security boundaries and verification gates
- `development-environment-policy.md` — Workspace organization
- `testing-policy.md` — Test requirements and coverage

**Templates referenced:**
- `claude-md-template.md` — Knowledge base structure
- `mcp-template.md` — Tool integration patterns
- `.cursorrules` — Behavior enforcement
- `prompt-template.md` — Task card format

**Complementary guides:**
- `task-management-guide.md` — Atomic task decomposition
- `spec-protocols-guide.md` — Spec-driven workflow
- Agent HQ orchestration notes — Multi-agent coordination

---

**End of Domain Template Documentation**

**Last updated:** 2026-02-06
**Version:** 1.0
