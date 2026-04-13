# graph-of-skills

**Source:** `rules/references/graph-of-skills.pdf`

**Adopt in agent runtimes and repos:**

1. Retrieve and rank **executable skills** (procedures + artifacts), not text-only matches.
2. Model skills as a **DAG**: retrieval and planning must respect prerequisites; forbid presenting skills/tools as an unordered flat list when dependencies exist—document edges explicitly.
3. Align implementation with `rules/ai-workflow-policy.md` (Claude Code Skills Management MUST) and `rules/references/ai-workflow-agent-skills-reference.md` (`skill-retrieval`, `dependency-aware-skill-selection`).
