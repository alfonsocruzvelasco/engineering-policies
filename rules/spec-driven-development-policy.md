# Spec-Driven Development Policy

**Status:** Authoritative
**Last updated:** 2026-01-30

## Purpose

This policy mandates spec-driven development for all AI-augmented engineering work to prevent hallucinations, scope creep, and undocumented decisions.

## Core Principle

**Specifications are executable artifacts that both humans and AI verify against.**

Traditional: Code → Tests → Docs (afterthought)
Required: **Spec → Plan → Tasks → Verify → Code**

## Protocol Selection Matrix

| Scenario | Protocol | Rationale |
|----------|----------|-----------|
| New ML model architecture | **Spec Kit** | 0→1 greenfield with 4-stage workflow |
| Updating existing training pipeline | **OpenSpec** | Brownfield with explicit delta tracking |
| Exposing datasets/models to AI tools | **MCP** | Standardized context integration |

## Mandatory Checkpoints

### Before Writing Code
- [ ] Constitution exists and reflects current standards
- [ ] Spec has measurable acceptance criteria
- [ ] All ambiguities clarified via `/speckit.clarify`
- [ ] Validation passed (`openspec validate --strict`)
- [ ] Tech stack approved (matches constitution)

### During Implementation
- [ ] Tasks are atomic (1 file or function)
- [ ] AI follows task order (no skipping)
- [ ] Checkpoints validated after each block
- [ ] Performance metrics tracked (if spec defines budgets)

### Before Merging
- [ ] All tasks checked off in tasks.md
- [ ] Acceptance tests passing (matches spec scenarios)
- [ ] No spec drift (implementation matches spec)
- [ ] Archive complete (OpenSpec: `openspec archive --yes`)

## Integration with Existing Policies

This policy **supplements** (does not replace):
- `prompts-policy.md` - Governs how to interact with AI
- `production-policy.md` - Governs code quality standards
- `mlops-policy.md` - Governs ML experiment tracking

## References

See: `~/policies/references/spec-protocols-guide.md` for full protocol documentation
