# CLAUDE.md v3.0 — Minimal Context File

**Tier:** HOT (always loaded at session start — project constitution per Vasilopoulos). See `../ai-workflow-policy.md` "Tiered Context Architecture" for HOT/WARM/COLD classification.

**Purpose:** Provide ONLY non-standard tooling requirements and hard constraints for coding agents.

**Research:** Gloaguen et al. (2026) found that comprehensive context files reduce agent performance by ~3% and increase costs by 20%+. Minimal developer-written files improve performance by ~4%. See `ai-workflow-policy.md` Section "Shared Team Knowledge: CLAUDE.md" for details.

**Critical Behavioral Finding:**
> **"Both LLM-generated and developer-provided context files encourage broader exploration (e.g., more thorough testing and file traversal), and coding agents tend to respect their instructions. Ultimately, we conclude that unnecessary requirements from context files make tasks harder, and human-written context files should describe only minimal requirements."** — Gloaguen et al. (2026)

**Implication:** Agents will follow instructions in context files, including unnecessary ones. Every requirement you add increases exploration, testing, and file traversal—which increases cost and can make tasks harder. **Only include requirements that are truly necessary.**

**Size limit:** <50 lines for learning projects, <150 lines for production projects with complex constraints.

**What to include:**
- Non-standard build/test commands (if different from defaults)
- Repository-specific constraints (e.g., "Never modify `core/legacy.py`")
- Hard requirements (e.g., "Must use Python 3.11+ for type hints")

**What NOT to include:**
- Repository overviews or directory structures (agents can discover these)
- Comprehensive pattern libraries (use separate LEARNING_LOG.md for personal notes)
- Workflow loops or session templates (agents already know standard workflows)
- RAG setup instructions (not needed for standard tooling)
- Common mistakes that apply to all projects (agents already know these)

---

## Example: Minimal CLAUDE.md for Learning Project

```markdown
# CLAUDE.md

## Testing
- Run tests: `pytest tests/ -v`
- Coverage requirement: ≥80% on new code

## Code Quality
- Pre-commit hooks configured (run before commit)
- Type hints required for all public functions

## Constraints
- Never modify `legacy/` directory (deprecated code)
- Always use `torch.float32` (not float64) for model weights

Total: 7 lines
```

---

## Example: Minimal CLAUDE.md for Production Project

```markdown
# CLAUDE.md

## Build & Test
- Build: `make build` (not `python setup.py install`)
- Test: `make test` (runs pytest + integration tests)
- Coverage: ≥90% required (enforced in CI)

## Non-Standard Tooling
- Use `ruff` instead of `black` for formatting
- Use `mypy --strict` (not permissive mode)
- Custom pre-commit hook: `scripts/custom-lint.sh`

## Hard Constraints
- Python 3.11+ required (uses `typing.Self`)
- Never modify `core/auth.py` without security review
- All database migrations must be reversible
- Model artifacts must be signed before deployment

## Repository-Specific Patterns
- Use `@dataclass` for all config objects (not dicts)
- All async functions must have timeout decorator

Total: ~30 lines
```

---

## When to Skip CLAUDE.md Entirely

**For standard tooling (recommended for learning projects):**
- Standard Python/ML/CV workflows (pytest, black, mypy)
- Standard Git workflows
- Standard CI/CD patterns

**Rationale:** Agents already know standard tooling. The 4% improvement from minimal context files applies primarily to non-standard requirements.

---

## Personal Learning Notes (Separate File)

**Use `LEARNING_LOG.md` for personal knowledge** (not for agents):

```markdown
# LEARNING_LOG.md (for YOU, not agents)

## 2026-02-16: Dataset splitting pattern
Learned that grouping by patient_id prevents data leakage.
See commit abc123.

## 2026-02-14: Focal loss implementation
Gamma=2 worked better than gamma=1 for my imbalanced dataset.
```

**Key difference:**
- `CLAUDE.md` = minimal requirements for agents (benefits: +4% performance)
- `LEARNING_LOG.md` = personal knowledge base (benefits: helps YOU, not agents)

---

**Last updated:** 2026-03-14
**Version:** 3.0 (minimal, research-based)
**Reference:** Gloaguen et al. (2026), "Evaluating AGENTS.md: Are Repository-Level Context Files Helpful for Coding Agents?" arXiv:2602.11988
