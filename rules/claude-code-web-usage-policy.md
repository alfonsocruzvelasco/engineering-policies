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

**Claude Code Routines (research preview, April 2026):**
Scheduled, API-triggered, and webhook-triggered automations
that run on Anthropic cloud infrastructure — configured
once (prompt + repo + connectors) and executed without
local machine involvement. Subject to the same restrictions
as Claude Code Web: forbidden for ML/CV core workloads,
secrets, credentials, datasets, and infra configs.
Rationale: remote execution = loss of control; audit trail
behaviour under routine scheduling is not yet documented.
Daily limits apply (5/day Pro, 15/day Max, 25/day
Team/Enterprise); routine runs draw down subscription
limits identically to interactive sessions.
Re-evaluate for production use when research preview
designation is removed and session traceability meets the
standard in `ai-workflow-policy.md` Part 1 (agent session
traceability). Reference:
https://claude.com/blog/introducing-routines-in-claude-code

**Claude Code Dynamic Workflows (research preview,
May 28 2026):**
Claude dynamically writes orchestration scripts
that execute tens to hundreds of parallel subagents
in a single session, with built-in verification
before output is returned. Activated via: (1) asking
Claude to "Create a workflow" directly, or (2)
enabling the `ultracode` setting via the effort menu
(sets effort to xhigh, Claude decides when to invoke
a workflow automatically).

Available on: Claude Code CLI, Desktop, VS Code
extension — Max, Team, and Enterprise plans only.
Also available via Claude API, Amazon Bedrock,
Vertex AI, Microsoft Foundry.

Restrictions under this policy:
- Research preview — same restrictions as Claude
  Code Routines: forbidden for ML/CV core workloads,
  credentials, datasets, and infra configs
- **Spend cap risk:** Anthropic explicitly warns
  that dynamic workflows consume substantially more
  tokens than a typical Claude Code session.
  Tens to hundreds of parallel subagents will
  exhaust the $20/month Pro Agent SDK credit
  rapidly. Do NOT enable `ultracode` or invoke
  dynamic workflows without first scoping the task
  and estimating token cost via ccusage. Exit code
  2 on cap hit (see budget_guard.py spec).
- Do not enable auto-approve (`ultracode`) for
  any task touching credentials, production data,
  or infra configs — parallel subagents at xhigh
  effort with no human gate is outside the HITL
  policy
- Re-evaluate for production use when research
  preview designation is removed
Reference:
https://claude.com/blog/introducing-dynamic-workflows-in-claude-code

---

## Browser Agent and Web Summarization Policy (May 2026)

**AI browser-agent extensions are prohibited unless explicitly reviewed and approved.** ClaudeBleed (May 2026, partially unpatched) and ShadowPrompt (March 2026) demonstrate that AI browser extensions carry a systemic trust model failure class — unpatched vulnerabilities affecting Gmail, GitHub, Google Drive, and credential stores. Each new extension is an unreviewed attack surface until proven otherwise.

**Untrusted web summarization** (asking any AI assistant to summarize, browse, or retrieve content from pages you do not fully control) MUST follow all of the following conditions:

- Isolated browser profile — dedicated profile with no connection to your primary profile
- No browser sync — profile must not sync history, extensions, passwords, or settings to any account
- No private accounts — no Gmail, GitHub, Google Drive, or any authenticated service connected in that profile
- No AI connectors — no MCP servers, no browser extensions with AI integration active
- Temporary Chat — use Temporary Chat mode if available; no session persistence
- Pasted plain text only — copy the text content manually and paste it; never pass a live URL directly to an AI summarization feature
- Close the isolated profile entirely when done — do not leave it running in the background; session isolation only holds if the session ends

**Connected private data must never be combined with untrusted external content in the same chat or session.** A session that has access to Gmail, GitHub, or Google Drive must never also process content from untrusted external pages. Split into separate sessions — one for private data, one for external content.

Rationale: ChatGPhish (May 2026, unpatched) demonstrated that untrusted page content rendered inside a trusted AI assistant UI is indistinguishable from legitimate assistant output. ClaudeBleed demonstrated that any Chrome extension can hijack a trusted AI browser agent. The only reliable mitigation is isolation — profile, session, and data source separation.

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
