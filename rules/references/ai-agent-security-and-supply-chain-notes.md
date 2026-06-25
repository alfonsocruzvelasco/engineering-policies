---
doc_type: reference
authority: supporting
owner: Alfonso Cruz
scope: Security notes for model routing, infrastructure trust, and agentic supply-chain risk
---

# AI Agent Security and Supply Chain Notes

## Infrastructure trust and data exposure

- Infrastructure trust (mandatory): Chinese-hosted endpoints are prohibited without exception. See `security-policy.md` §14.6.9. Logged rationale does not constitute an exception.
- Chinese-hosted model endpoints are prohibited for all engineering work without exception or scope limitation. This is not restricted to safety-critical or geopolitically sensitive domains. Authority: `rules/security-policy.md` §14.6.9.
- Agent compartment identity (mandatory): In any multi-user or ambient agentic system, permissions and cost controls must be scoped at the compartment level — not at the session level and not inherited from the invoking user. An agent that acts asynchronously or without explicit invocation must operate under its own identity with explicitly scoped access per compartment. Ambient agents (those that act without being tagged) require the most restrictive compartment scope — treat ambient mode as always-on, not as a convenience feature. Token cost ceilings belong at the compartment level as a scope control, not only as a budget control.

## RL-trained model output integrity

- RL-trained model reward-hacking risk (mandatory): Models trained with RL on verifiable pass/fail signals (including GLM-5.2) have an inherent reward-hacking pressure that post-training may not have fully resolved. Apply the same test-assertion vigilance rule to their agentic outputs: never accept a green test suite from an RL-trained agent without verifying that assertions were not silently adjusted to match changed behavior.
