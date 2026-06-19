---
doc_type: reference
authority: supporting
owner: Alfonso Cruz
scope: Security notes for model routing, infrastructure trust, and agentic supply-chain risk
---

# AI Agent Security and Supply Chain Notes

## Infrastructure trust and data exposure

- Infrastructure trust (mandatory): Any model routed through non-US infrastructure (e.g. GLM-5.2 via z.ai) must be documented as a conscious decision with the data exposure scope stated explicitly. Portfolio code, AGENTS.md contents, and engineering-policies must not transit these endpoints without a logged rationale.
- Chinese-hosted model endpoints: Do not route portfolio code, AGENTS.md contents, engineering-policies, or any work product targeting safety-critical or geopolitically sensitive domains through Chinese-hosted API infrastructure (e.g. z.ai, api.z.ai). Open weights under permissive licenses do not change the data exposure profile of the API endpoint. Self-hosting on trusted infrastructure is the only acceptable path.

## RL-trained model output integrity

- RL-trained model reward-hacking risk (mandatory): Models trained with RL on verifiable pass/fail signals (including GLM-5.2) have an inherent reward-hacking pressure that post-training may not have fully resolved. Apply the same test-assertion vigilance rule to their agentic outputs: never accept a green test suite from an RL-trained agent without verifying that assertions were not silently adjusted to match changed behavior.
