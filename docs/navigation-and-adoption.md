# Navigation, adoption, and maintenance

This repository is large by design. This guide addresses the usual failure modes: getting lost, copying it wholesale without adapting it, letting policies go stale, and applying full production discipline where a lighter path fits.

---

## 1) Navigation: avoid drowning

**Start here, not with random files:**

1. **`rules/system/concept-index.md`** — Maps a concept to the **authoritative** policy file. When two documents touch the same topic, the index points to what wins for governance.
2. **Root `README.md`** — Orientation and the `/rules` index (what each major file is for).
3. **Topic-specific policies** — Open only the file the concept index lists as authoritative for your question.

**If documents disagree:** Follow the authority model stated in `rules/production-policy.md` (standalone policies override navigation sections inside merged files when they conflict). For security versus other domains, **`rules/security-policy.md` wins** where it explicitly claims precedence (see also `rules/dependency-install-policy.md`).

---

## 2) Reading paths (by intent)

These are **suggested entry sequences**, not requirements.

| Intent | Start with | Then |
|--------|------------|------|
| ML/CV delivery and ops | `rules/mlops-policy.md`, `rules/ml-cv-operations-policy.md` | `rules/testing-policy.md`, `rules/production-policy.md` (data/SQL/Git sections as needed) |
| Experiments and learning phase | `rules/ml-experiment-tracking-policy.md` | `rules/mlops-policy.md` when you outgrow minimal tracking |
| AI-assisted coding workflow | `rules/ai-workflow-policy.md` | `rules/llm-usage-policy-hallucinations.md`, `rules/approved-ai-tools.md` |
| Security and dependencies | `rules/security-policy.md` §§9–9.4, §14 | `rules/dependency-install-policy.md`, `rules/language-policies.md` |
| Infra and containers | `rules/infrastructure-policy.md` | `rules/system/containers/` |

---

## 3) When you do not need the full corpus

**Learning-only or throwaway work** is governed elsewhere:

- `rules/system/learning-library-governance.md`
- `rules/system/learning-ai-usage-boundary.md`

Use those for repos under `~/learning-repos/` and similar. You are not expected to load every policy in this repo into a one-off tutorial or Kaggle-style notebook.

**Rule of thumb:** Full alignment with this corpus is for **durable, shared, or production-bound** work. For short experiments, take the minimum subset (often experiment tracking + security basics + dependency discipline).

---

## 4) Adopting or forking (portability)

This corpus includes **example org placeholders** (for example `security@organization.com` in several files), **personal canonical paths** in `README.md`, and **review dates** inside registries. If you fork or reuse it:

- Replace placeholder contacts and ownership with your team’s identifiers.
- Treat `~/dev/...` paths as **conventions**, not universal law; align with `rules/development-environment-policy.md` or rewrite the README block to match your layout.
- Re-read **`rules/approved-ai-tools.md`** and **`rules/security-exceptions.md`** in your context: approvals and tiers are organizational facts, not generic defaults.
- Keep **hooks and scripts** (for example `.pre-commit-config.yaml`, `rules/system/scripts/`) or explicitly drop them and document why.

---

## 5) Maintenance: keeping trust high

Stale policy is worse than no policy for teams that rely on it.

**Practices:**

- **Date meaningful edits** in policy headers or change logs where the repo already does so.
- **Record governance changes** in `CHANGELOG.md` when behavior, enforcement, or authority boundaries shift.
- **Revisit registry rows** (approved tools, exceptions) on the cadence those files state, not “when someone remembers.”
- **Prefer the concept index** when adding a new cross-cutting topic instead of duplicating full explanations in multiple policies.

**Depth varies:** Some files are comprehensive; others are pointers or merged bundles. That is intentional. Use `concept-index.md` to find the **authoritative** layer for a topic instead of assuming every file is equally detailed.

---

## 6) Reducing overlap over time

When you notice duplication:

1. Add or update a row in `rules/system/concept-index.md`.
2. Keep one **authoritative** explanation in the designated policy file.
3. Replace duplicate prose elsewhere with a short cross-link to the authoritative section.

This keeps the corpus maintainable without big-bang rewrites.
