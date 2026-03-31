---
doc_type: reference
authority: supporting
owner: Alfonso Cruz
scope: Enterprise and fleet security controls not actionable on a personal workstation
---

# Security — Enterprise Controls Reference

> **Note:** This is a reference companion to `security-policy.md`. The policy file contains the binding daily-practical rules; this file documents enterprise-scale and fleet-level controls that are important for organizational deployment but not directly actionable on an individual developer workstation.

---

## Runtime Trust Layer for Agent Governance (Visibility + Policy Enforcement)

When an agent (e.g., Claude Code) executes on a developer machine with MCP servers and tool access, security controls must operate where the action happens.

**Threat reality:** Network-edge monitoring and post-hoc logs often miss local execution that occurs before any outbound traffic is observable.

**Mandatory requirement (enterprise / fleet use):** Agentic execution must be mediated by a runtime trust layer that provides, at minimum:

1. **Pre-execution policy enforcement:** Evaluate MCP server allowlisting and tool-level policies *before* actions run, and block unauthorized tool calls / MCP connections at runtime.
2. **Real-time visibility into what executed:** Record tool definitions and the actual tool calls (arguments, outputs) as the agent runs.
3. **Device posture gating:** Require the target device to meet security posture conditions (for example, full-disk encryption enabled and endpoint protection running) before a session can start, and re-evaluate continuously during the session.
4. **Tamper-evident audit evidence:** Produce append-only, immutable activity logs with cryptographic signing where feasible, including user attribution, device context, and complete execution ancestry.

**Rationale reference:** See how Ceros provides visibility and runtime governance for Claude Code, including MCP allowlisting and cryptographically signed activity logs: [The Hacker News — How Ceros Gives Security Teams Visibility and Control in Claude Code](https://thehackernews.com/2026/03/how-ceros-gives-security-teams.html).

**Implementation guidance:** If a trust layer is not available, treat the scenario as ungoverned and default to compensating controls already required by the policy:
* strict MCP/tool allowlists
* sandboxed execution with least-privilege
* mandatory HITL for sensitive/destructive actions
* tamper-proof retention for audit logs

---

## Isolate-Based Sandbox Considerations (V8 Isolates / Dynamic Workers)

Isolate-based sandboxes are significantly lighter than containers (~ms startup, ~MB memory) and are viable for ephemeral per-request agent execution. However, they present a different attack surface:

* V8 security bugs are more common than typical hypervisor bugs; require **defense-in-depth** — a second-layer sandbox, hardware features (MPK), and Spectre mitigations — rather than relying on the isolate boundary alone.
* Demand that the sandbox provider deploys V8 security patches to production within hours (not weeks).
* Use `globalOutbound: null` (or equivalent) to fully block network egress by default; if the agent needs HTTP access, intercept via an outbound handler that enforces allowlists, rewrites requests, and injects credentials so the agent never sees secrets (credential injection pattern).
* Prefer TypeScript RPC interfaces over raw HTTP for agent-to-API communication; narrower typed interfaces are easier to audit and harder for the agent to abuse than unrestricted HTTP proxying.
* Treat each agent execution as a **disposable, one-off sandbox** — create a fresh isolate, run the code, return the result, destroy the isolate. Do not reuse isolates across tasks or users.

**Reference:** See `rules/references/sandboxing-ai-agents-100x-faster.pdf` for Cloudflare's Dynamic Worker Loader architecture, security hardening details, and credential injection patterns.

---

## CI/CD-to-Cloud OIDC Trust Chain Hardening

**Threat reference:** UNC6426 abused a GitHub→AWS OIDC trust to escalate from a stolen GitHub token to AWS AdministratorAccess in 72 hours. The overly permissive CloudFormation role allowed creating new IAM admin roles.

**OIDC-linked CI/CD roles MUST follow least-privilege:**

- CI/CD service account roles (GitHub Actions, GitLab CI) that authenticate to cloud via OIDC MUST NOT have `iam:CreateRole`, `iam:AttachRolePolicy`, or equivalent privileges. If CloudFormation/IaC requires IAM changes, use a separate, tightly scoped role with mandatory human approval.
- OIDC trust policies MUST restrict the `sub` claim to specific repositories and branches (e.g., `repo:org/repo:ref:refs/heads/main`). Never use wildcard repository matching.
- Roles assumed via OIDC MUST have a maximum session duration of 1 hour (or less).
- Monitor for anomalous IAM activity: new role creation, policy attachment, cross-account assume-role calls. Alert within 15 minutes.
- Remove standing privileges for high-risk actions (IAM admin, S3 bucket deletion, RDS termination). Require elevated approval workflows for destructive operations.

**GitHub-specific:**

- Use fine-grained PATs with specific repository permissions and short expiration (maximum 7 days for automation, 24 hours preferred).
- Disable classic PATs in organization settings where possible.
- Audit OIDC trust relationships quarterly — remove any trust that is no longer in active use.

---

## Logging and Audit Expectations

**MANDATORY Logging Requirements:**

1. **Interaction Logging:**
   * All prompts sent to external AI models MUST be logged (with secrets redacted)
   * All AI-generated code and responses MUST be logged
   * Timestamps, user identifiers, and session identifiers MUST be recorded
   * Model identifiers (Claude, GPT-5.2, Gemini, etc.) MUST be logged

2. **Access Logging:**
   * All API calls to external AI services MUST be logged
   * Token usage, cost, and rate limit information MUST be tracked
   * Failed authentication attempts MUST be logged and alerted
   * Unusual usage patterns (excessive API calls, large prompts) MUST trigger alerts

3. **Code Generation Logging:**
   * All AI-generated code MUST be attributed to the AI model and user
   * Git commits containing AI-generated code MUST include metadata indicating AI assistance
   * Code review comments and security findings MUST be logged
   * All verification gate results (tests, scans, reviews) MUST be logged

4. **Audit Trail Requirements:**
   * All logs MUST be retained for a minimum of 90 days
   * Logs MUST be tamper-proof (append-only, cryptographically signed where feasible)
   * Logs MUST be searchable and queryable for forensic analysis
   * Access to audit logs MUST be restricted and logged

5. **Compliance and Reporting:**
   * Regular audits MUST be conducted to verify compliance with this policy
   * Security incidents involving external AI models MUST be documented and reported
   * Usage statistics and cost attribution MUST be tracked and reported
   * Policy violations MUST be logged, investigated, and remediated

**Log Retention and Access:**
* Logs MUST be stored in centralized, access-controlled systems
* Log access MUST require authentication and authorization
* Log access MUST be audited (who accessed what logs, when, and why)
* Logs containing sensitive information MUST be encrypted at rest and in transit
