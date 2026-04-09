# Deferred: Muse Spark — follow until public API

**Status:** Monitoring — no integration until a documented public API exists
**Created:** 2026-04-10
**Review trigger:** Vendor publishes stable public API docs (endpoints, auth, terms); then reassess policy and `approved-ai-tools.md`.

---

## Intent

Track **Muse Spark** from the sidelines: capture methodology and news, but **do not** treat it as an approved integration surface until there is a **public API** (not app-only, not undocumented reverse-engineering).

---

## Supporting material in-repo

- `rules/references/muse-spark-eval-methodology.pdf` — evaluation methodology reference (keep in sync if superseded).

---

## Checklist when a public API appears

- [ ] Read official API documentation and pricing.
- [ ] Map data-handling and retention to `rules/security-policy.md` (§14.6 and related).
- [ ] If use is intended: add or update entry in `rules/approved-ai-tools.md` with scope and constraints.
- [ ] If policy guidance is needed beyond tool approval: propose a normative policy change or reference in `rules/ai-workflow-policy.md` / concept index as appropriate.

---

## Notes

Until the items above are satisfied, Muse Spark remains **out of scope** for automated agents and production workflows except passive research and this deferred note.
