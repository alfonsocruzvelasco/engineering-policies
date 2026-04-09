# Contributing

## Purpose
This repository is authoritative policy infrastructure. Changes must be deliberate, reviewable, and internally consistent.

## Contribution Workflow
1. Create a scoped branch for one policy change set.
2. Update the minimum set of files required to keep policy links and authority model coherent.
3. Run:
   - `pre-commit install` (first time only)
   - `pre-commit run --all-files`
4. If behavior or governance changed, update `CHANGELOG.md`.
5. Open a PR with:
   - problem statement,
   - policy rationale,
   - verification output.

## Authoring Rules
- Keep documents close to source-of-truth policy files in `rules/`.
- Preserve section structure and stable anchors where possible.
- Prefer additive, explicit updates over silent rewrites.
- Keep filenames lowercase with hyphens unless tool conventions require otherwise.
- Add cross-references when introducing new policy concepts.

## Security and AI Constraints
- Use approved AI tools only (`rules/approved-ai-tools.md`).
- Never include secrets or sensitive credentials.
- Treat AI output as draft material and verify before commit.
- Record exceptions in `rules/security-exceptions.md` when applicable.

## Maintenance

- Prefer **one authoritative explanation** per topic; extend `rules/system/concept-index.md` when adding cross-cutting concepts instead of duplicating long sections.
- Update **`CHANGELOG.md`** when governance, enforcement, or authority boundaries change.
- Keep **dates and registry rows** (for example in `rules/approved-ai-tools.md`, `rules/security-exceptions.md`) aligned with the review cadence stated in those files.

## Forking or adopting this corpus

Placeholder contacts (for example `*@organization.com`), personal paths in `README.md`, and tool approval rows are **templates**. Replace them for your environment. See **Navigation, adoption, and maintenance** in `README.md`.

## Local-Only Git Note
By default, maintain changes locally unless an explicit push/release action is requested.
