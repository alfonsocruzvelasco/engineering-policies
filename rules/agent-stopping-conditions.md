---
doc_type: policy
authority: authoritative
owner: Alfonso Cruz
scope: Runtime bounds, timeouts, clean termination, and incident signaling for agentic workflows
---

# Agentic Workflow Stopping Conditions

**Status:** Authoritative
**Last updated:** 2026-04-09

**Source:** [AWS Well-Architected Generative AI Lens](https://docs.aws.amazon.com/wellarchitected/latest/generative-ai-lens/welcome.html) (November 2025). Best practice **GENREL03-BP02**.

**Authority:** This document sets **mandatory stopping conditions and timeout behavior** for agentic workflows. **Session management, reliability surface, and daily workflow** remain in [`ai-workflow-policy.md`](ai-workflow-policy.md) Part 1 and Part 3. **Token economy for prompts and responses** overlaps with [`token-cost-controls.md`](token-cost-controls.md). **Security controls for tools and agents** remain in [`security-policy.md`](security-policy.md). If anything here disagrees with `security-policy.md` on incident handling or disclosure, **`security-policy.md` wins**.

**Enforcement:** Binding for humans and agents. Timeout values and alerting integrations are **per repository** but must implement the behaviors below.

---

## Mandatory rules

1. **Every agentic workflow must define a maximum runtime threshold** before deployment. The threshold must account for model response time, tool execution time, and network latency, with margin for edge cases.

2. **A timeout mechanism must be implemented at the workflow level.** Timeouts must be set on: (a) the agent session itself, (b) any external tool or function the agent calls, (c) any asynchronous process the agent triggers.

3. **When a timeout fires, the agent must:** log the timeout event with session ID and elapsed time, terminate cleanly without leaving dangling external calls, and return a user-facing message that describes what happened and what the user can do next — without exposing internal system details.

4. **Token limits on model responses** may be used as a secondary stopping mechanism to prevent long-running generative loops.

5. **Repeated timeouts on the same workflow must trigger an alert.** Three or more timeouts on the same workflow within a 24-hour window must be logged as an incident requiring review.

---

## Quick links

| Topic | Where |
|------|--------|
| Session lifecycle and reliability | [`ai-workflow-policy.md`](ai-workflow-policy.md) Part 3 |
| Token bounds (primary/secondary) | [`token-cost-controls.md`](token-cost-controls.md) |
| Tool use and agent security | [`security-policy.md`](security-policy.md) Part 2 |
