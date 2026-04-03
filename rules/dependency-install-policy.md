---
doc_type: policy
authority: authoritative
owner: Alfonso Cruz
scope: Mandatory discipline for installing npm and Python (pip/uv/Poetry) dependencies; normative detail in security-policy.md §9
---

# Dependency Install Policy

**Status:** Authoritative
**Last updated:** 2026-04-03

**Authority:** This file is the **short operational checklist**. **Normative expansion, OWASP alignment, and npm lifecycle-script rules** live in [`security-policy.md`](security-policy.md) §9 and §§9.3–9.4. **Language-specific package-manager rules** live in [`language-policies.md`](language-policies.md) (npm and Python sections). If anything here disagrees with `security-policy.md`, **`security-policy.md` wins**.

**Enforcement:** Policy is binding for humans and agents. **Technical enforcement** (CI failing on lockfile drift, `npm ci`, `pip-audit`, etc.) is **per repository** — this document does not replace CI configuration.

---

## Core rule

**Installing dependencies = executing code** (vendor install hooks, build backends, and malicious packages all run in your environment). There is no “safe passive download.”

---

## Mandatory rules

1. **Never install blindly** — Verify package name, registry, maintainer/repo, and that it is the intended artifact (typosquatting, **slopsquatting** on AI-suggested names). For **Claude Code–adjacent npm / fake-repo lures** (April 2026), see [`security-policy.md`](security-policy.md) §9.4 (named high-risk patterns and mandatory install channel).
2. **Never install freshly released versions by default** — Prefer versions that have been observable for a short period unless you are applying an **urgent security fix**. See [`security-policy.md`](security-policy.md) §9.3 (pip/PyPI); apply the same judgment for npm.
3. **Always pin versions** — Exact pins or semver ranges **as team standard**, with **no “floating latest”** in committed manifests. See [`security-policy.md`](security-policy.md) §9 and §9.3.
4. **Always use lockfiles** — Commit lock artifacts; CI installs from lock (`npm ci`, frozen Poetry/uv/pip-tools flows as applicable). See [`language-policies.md`](language-policies.md) (npm §§3–6, Python dependency sections).
5. **Isolate unknown or high-risk installs** — Use a **disposable virtual environment** or **container** for packages you do not yet trust; do not install untrusted or experimental dependencies into a **global** interpreter or production-like env. See [`security-policy.md`](security-policy.md) §9.3 (venv; never `sudo pip install`).

**Also mandatory (npm):** Block lifecycle scripts by default (`ignore-scripts` / §9.4). **Also mandatory:** SCA on dependency changes where the repo uses that stack (`npm audit`, `pip-audit` / `safety`) per [`security-policy.md`](security-policy.md) §9.3 and team CI policy.

---

## Agents

1. **Separate planning from execution** — Decide *what* to install and *why* in a spec/PR/issue; treat the actual install as a distinct, reviewable step. Aligns with Spec–Plan–Patch–Verify in [`ai-workflow-policy.md`](ai-workflow-policy.md) Part 1.
2. **No automatic execution without validation** — Do not let an agent run `npm install` / `pip install` without **human review** of the dependency delta (names, versions, lockfile diff) unless the repo’s automation explicitly allows it. Destructive or publishing commands remain HITL per [`security-policy.md`](security-policy.md).
3. **Restrict tools by default** — Least-privilege tool allowlists, PreToolUse guardrails where used, and deny-read for secrets. See [`security-policy.md`](security-policy.md) §§8, 8.1.1, and Part 2 agent controls.

---

## One-line rule

**What code is being executed, and with what permissions?** — Ask this before every install, publish, or agent-driven package command.

---

## Quick links

| Topic | Where |
|------|--------|
| OWASP npm + PyPI alignment | [`security-policy.md`](security-policy.md) §9.3 |
| npm postinstall / IDE supply chain; Claude Code npm / fake-repo lures | [`security-policy.md`](security-policy.md) §9.4 |
| Tokens, 2FA, OIDC publishing | [`security-policy.md`](security-policy.md) §9.5 |
| npm CI, lockfile, `ignore-scripts` | [`language-policies.md`](language-policies.md) (TypeScript/Node sections) |
| Python venv, lock, SCA | [`language-policies.md`](language-policies.md) (Python §9 and related) |
| Agent context constraints | [`templates/agents-md-template.md`](templates/agents-md-template.md) |
