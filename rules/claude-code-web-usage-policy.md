---
doc_type: policy
authority: authoritative
owner: Alfonso Cruz
scope: Claude Cloud sessions and Remote Control — execution, control, data-flow, and security boundaries
---

# Claude Code Cloud Sessions / Remote Control — Usage Policy

**Status:** Authoritative
**Last updated:** 2026-09-27

**Relationship to other policies:** These surfaces are **not** the same security posture as standalone local Claude Code (CLI). They are subject to [`security-policy.md`](security-policy.md) §14 (external AI) and must align with [`approved-ai-tools.md`](approved-ai-tools.md) where applicable. **Stricter wins.**

---

## 1. What it is

This policy governs Claude Cloud sessions and Remote Control, whose
execution, control, persistence, and data-flow boundaries differ.

- **Cloud sessions** (`claude.ai/code`, `claude --cloud`):
  execution on Anthropic-managed cloud infrastructure (or designated
  org/self-hosted cloud environment where configured).
- **Remote Control** (`/remote-control`):
  remote/mobile control surface attached to a session executing on your
  local machine.
- **Shared warning:** a remote interface does not imply remote execution,
  and local execution does not imply local-only data handling.

---

## 2. Role in the toolbox

**Not** the primary tool.

Use as:

- Delegated worker
- Async execution engine
- Experimentation environment

**Mental model:** classify risk by execution surface dimensions, not a
single "local vs remote" label.

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

## 4. Surface-specific use restrictions

### 4.1 Cloud sessions (forbidden contexts)

For cloud sessions (`claude.ai/code`, `claude --cloud`), do not use for:

- **ML/CV core projects** (production pipelines, proprietary models, sensitive data paths)
- Anything involving:
  - API keys
  - Tokens
  - Credentials
  - Non-public datasets or PII
- System-level code that affects host or org-wide trust
- Infrastructure configs (IAM, CI secrets, cluster definitions, network policy)

If in doubt, **do not connect the repo or paste context** — use local tooling or air-gapped flows instead.

### 4.2 Remote Control (additional constraints)

Remote Control keeps execution/filesystem on your local machine, but the
control channel and active transcript/tool activity pass through Anthropic
and are stored under Anthropic's data policy while connected.

Therefore:

- Remote Control does **not** make a forbidden local task permissible.
- The underlying local Claude Code task must already be allowed by
  repository/security/tool policy.
- Local execution still does **not** imply local-only confidentiality or
  persistence.

**Claude Code Routines (research preview, April 2026):**
Scheduled, API-triggered, and webhook-triggered automations
that run on Anthropic cloud infrastructure — configured
once (prompt + repo + connectors) and executed without
local machine involvement. Subject to the same restrictions
as Cloud sessions: forbidden for ML/CV core workloads,
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

**Claude Code Dynamic Workflows (GA):**
Claude can dynamically write orchestration scripts
that execute tens to hundreds of parallel subagents
in a single session, with workflow-internal checks
before results are returned. Activated via: (1) asking
Claude to "Create a workflow" directly, or (2)
enabling the `ultracode` setting via the effort menu
(`ultracode` sets effort to xhigh and lets Claude decide
when to use a workflow for substantive tasks).

Currently available in Claude Code CLI/Desktop/VS Code
for Pro/Max/Team/Enterprise, and on additional Claude
platform surfaces.

Restrictions under this policy:
- Dynamic Workflows inherit the eligibility and security
  rules of the execution surface and underlying task;
  orchestration capability does not make an otherwise-
  forbidden task permissible.
- When run in a Cloud session, Section 4.1 restrictions apply.
- When used through Remote Control, the underlying local
  workflow must already be permitted and Section 5.4
  safeguards also apply.
- Dynamic workflows can consume substantially more
  usage than a typical Claude Code session. Scope
  tasks first, then evaluate usage with `/usage`
  and `ccusage` as needed.
- `ultracode` is a workflow/effort control, not an
  authorization mode and not auto-approval. Auto Mode
  and other permission/approval mechanisms remain
  separate controls.
- Active SPEND FREEZE remains binding: higher workflow
  usage does not authorize PAYG, extra usage, purchased
  credits, API billing fallback, or payment-method/
  subscription changes.
- Workflow-internal checking does not replace required
  repository validation gates and human review.
- GA lifecycle status does not weaken security controls.
Reference:
https://claude.com/blog/introducing-dynamic-workflows-in-claude-code
https://claude.com/blog/auto-mode-default-in-claude-code

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

Cloud sessions and Remote Control have different runtime boundaries and
must be evaluated separately.

### 5.1 Cloud sessions security posture

- Execution/filesystem is remote (Anthropic-managed cloud or configured
  cloud environment).
- Local-machine control over runtime is reduced relative to local CLI use.
- Code/context required by the task can be present in the remote environment.
- Environment network and credential controls are those enforced by the
  active cloud environment and platform policy.

### 5.2 Remote Control security posture

- Execution and filesystem access stay on the machine running Claude Code.
- The control channel transits Anthropic over TLS.
- While connected, messages/responses/tool activity transcript are stored
  on Anthropic servers under applicable data-usage policy.
- Therefore local execution does **not** imply local-only confidentiality
  or persistence.

Align with [`security-policy.md`](security-policy.md) §14 data-sharing rules before any use.

### 5.3 Execution-surface classification (mandatory)

Before use, classify the session on all six dimensions:

1. execution/filesystem location;
2. inference and data-egress destination;
3. transcript/session persistence;
4. network reach;
5. credential location/exposure;
6. control/interaction surface.

Do not infer trust from a single label ("web", "remote", or "local").

### 5.4 Remote Control operational safeguards (governed use)

- For `claude remote-control` server mode, enable sandboxing unless an
  explicitly reviewed exception requires otherwise.
- Do not run concurrent write-capable sessions against the same working
  tree; use worktree isolation (`--spawn worktree`) or equivalent.
- Do not enable automatic Remote Control startup merely for convenience;
  enable it only when intentionally required.
- Use Trusted Devices or equivalent stronger remote-device authentication
  where available and appropriate for material repository access.
- Remote Control must not bypass underlying repository/tool permissions,
  spend controls, secret handling, or data-handling policy.

---

## 6. Workflow

1. **Define** the task clearly (scope, success criteria, files in/out).
2. **Classify** the intended surface (Cloud session vs Remote Control) on
   the six dimensions in Section 5.3.
3. **Cloud sessions:** delegate only when Cloud-session allow/deny rules
   in Section 4.1 permit it.
4. **Remote Control:** start only from a locally permitted Claude Code
   workflow and apply Section 5.4 safeguards.
5. **Review** output before integration — never trust blindly; validate
   changes and read diffs line-by-line.
6. **Integrate** manually only after verification (tests, security review
   per repo policy).

---

## 7. Key rules

- Never treat agent output from either surface as **source of truth**
- Always review before merge or deploy
- Never expose sensitive data, secrets, or proprietary datasets contrary to the applicable data-handling policy
- Cloud sessions are limited to **bounded** tasks on **low-risk** repositories; Remote Control is limited to workflows already permitted for local Claude Code plus the safeguards in Section 5.4

---

## 8. One-line rule

**Use it as a worker, not as a brain.**
