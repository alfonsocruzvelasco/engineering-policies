---
doc_type: policy
authority: authoritative
owner: Alfonso Cruz
scope: Model selection economics and documented upgrade criteria for new workflows
---

# Model Selection Cost Discipline

**Status:** Authoritative
**Last updated:** 2026-04-09

**Source:** [AWS Well-Architected Generative AI Lens](https://docs.aws.amazon.com/wellarchitected/latest/generative-ai-lens/welcome.html) (November 2025). Best practice **GENCOST01**.

**Authority:** This document sets **mandatory cost discipline for model selection** on new workflows. **Approved tools and model tiers** remain in [`approved-ai-tools.md`](approved-ai-tools.md). **Agent selection and model choice for sessions** remain in [`ai-workflow-policy.md`](ai-workflow-policy.md). **Experiment tracking and production ML operations** remain in [`ml-experiment-tracking-policy.md`](ml-experiment-tracking-policy.md) and [`mlops-policy.md`](mlops-policy.md). **Architecture decision records** should align with [`documentation-policy.md`](documentation-policy.md) where the project records decisions.

**Enforcement:** Binding for humans and agents. The architecture record may live in the repository’s ADR or spec process as long as the decision and quality threshold are documented before upgrade.

---

## Mandatory rules

1. **Model selection for any new workflow must include a cost-per-inference estimate** at expected volume. A smaller or cheaper model must be evaluated first. Upgrade to a larger model only when the smaller model demonstrably fails the quality threshold defined in the project spec. This decision must be documented in the workflow's architecture record.

---

## Quick links

| Topic | Where |
|------|--------|
| Approved tools and recertification | [`approved-ai-tools.md`](approved-ai-tools.md) |
| Agent / model selection | [`ai-workflow-policy.md`](ai-workflow-policy.md) |
| MLOps and eval posture | [`mlops-policy.md`](mlops-policy.md) |
