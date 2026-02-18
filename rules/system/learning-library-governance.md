## 🔒 **Policy Addendum — Learning Library Governance**

Add this as a new section in your engineering policies repo.

### Learning Library Governance

This section defines how “learning library” repositories (book code, course material, reference implementations) must be handled to prevent scope drift and protect focus on production-grade engineering.

**1. Purpose**

Learning library repositories exist **only** to store:

* Book and course code examples
* Reference implementations
* Short exploratory experiments that are not yet real projects

They are **not** project workspaces.

---

**2. Graduation Rule (Anti-Sprawl Control)**

The moment any work requires one or more of the following, it must be moved to a proper project repository under `~/dev/repos/...`:

* Dependency management (pyproject.toml, package.json, requirements.txt, etc.)
* Long-term development or maintenance
* CI/CD, Docker, or environment configuration
* Structured datasets or experiment tracking
* Portfolio relevance

Learning repos are **temporary staging grounds**, not development homes.

---

**3. Focus Rule (Anti-Entropy Control)**

Every learning repository must maintain in its `README.md`:

* `current_track:` exactly **one** active learning focus
* `active_projects:` links to real project repos (not folders inside the learning repo)
* `next_up:` maximum **three** queued topics

This prevents passive accumulation and enforces deliberate learning progression.

---

**4. Structural Discipline**

Learning repositories must still follow core hygiene rules:

* Lowercase kebab-case naming
* No virtual environments inside
* No large datasets
* No long-running branches or feature development

They are reference libraries, not engineering systems.

---

**5. AI Usage Boundary**

Learning repositories are **learning-only corpora** with explicit AI usage boundaries.

**Key principles:**
- ✅ AI usage is **allowed by default** for tutoring, synthesis, and planning
- ✅ No proprietary or employer data
- ✅ No automated agents acting on production systems
- ✅ BYOAI-safe by design

**Critical distinction:**
> **Learning corpus ≠ production codebase**

This structure enforces separation between learning and production, preventing accidental policy violations.

**For detailed AI usage boundaries, see:**
- [`learning-ai-usage-boundary.md`](learning-ai-usage-boundary.md) — Complete AI usage policy for learning repositories
- [`ai-workflow-policy.md`](../ai-workflow-policy.md) — Production AI usage policies and sandbox restrictions
- [`security-policy.md`](../security-policy.md) — Security boundaries and prohibited tools

**Special attention:** The `4-ml-systems-mlops/ai-assisted-engineering` folder is for **learning about** AI-assisted engineering patterns, not **deploying** autonomous agents. Any agent deployment must occur in sandbox repositories with explicit boundaries.
