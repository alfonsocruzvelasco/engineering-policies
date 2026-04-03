---
doc_type: policy
authority: authoritative
owner: Alfonso Cruz
scope: Claude Code Web (browser / cloud coding agent) — role, allow/deny contexts, security model, workflow
---

# Claude Code Web — Usage Policy

**Status:** Authoritative
**Last updated:** 2026-04-02

**Relationship to other policies:** This product is **not** the same security posture as **local** Claude Code (CLI). It is subject to [`security-policy.md`](security-policy.md) §14 (external AI) and must align with [`approved-ai-tools.md`](approved-ai-tools.md) where applicable. **Stricter wins.**

---

## 1. What it is

**Claude Code Web** = cloud-based coding agent that:

- Runs in the browser
- Executes in a **remote** sandbox
- Is **asynchronous** (can run while you are away)
- Integrates with GitHub (and similar)

---

## 2. Role in the toolbox

**Not** the primary tool.

Use as:

- Delegated worker
- Async execution engine
- Experimentation environment

**Mental model:** Local Claude Code = control + precision. Claude Code Web = delegation + convenience.

---

## 3. When to use (allowed)

### 3.1 Async tasks

- Long refactors
- Codebase exploration
- Documentation generation
- Repetitive transformations

### 3.2 Low-risk repositories

- Public repositories
- Throwaway projects
- Non-sensitive experiments

### 3.3 Exploration

- Understanding unfamiliar codebases
- Generating drafts
- Testing ideas quickly

---

## 4. When not to use (forbidden)

- **ML/CV core projects** (production pipelines, proprietary models, sensitive data paths)
- Anything involving:
  - API keys
  - Tokens
  - Credentials
  - Non-public datasets or PII
- System-level code that affects host or org-wide trust
- Infrastructure configs (IAM, CI secrets, cluster definitions, network policy)

If in doubt, **do not connect the repo or paste context** — use local tooling or air-gapped flows instead.

---

## 5. Security model

**Assumption:** Remote execution = **loss of full control**.

Implications:

- Code and context **leave** the local machine
- Execution environment is **not** fully transparent to you
- Vendor logs, retention, and subprocess behavior apply — treat as **potential exposure**

Align with [`security-policy.md`](security-policy.md) §14 data-sharing rules before any use.

---

## 6. Workflow

1. **Define** the task clearly (scope, success criteria, files in/out).
2. **Delegate** to Claude Code Web on an **allowed** repository only.
3. **Wait** for async completion; do not treat partial logs as proof of correctness.
4. **Review** output **locally** — never trust blindly; validate changes; read diffs line-by-line.
5. **Integrate** manually only after verification (tests, security review per repo policy).

---

## 7. Key rules

- Never treat cloud agent output as **source of truth**
- Always review before merge or deploy
- Never expose sensitive data, secrets, or proprietary datasets
- Use only for **bounded** tasks on **low-risk** repos

---

## 8. One-line rule

**Use it as a worker, not as a brain.**
