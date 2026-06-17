# AI Tool Policy Quick Reference

Rebuilt: 2026-06-17

## Workflow

| Rule | Source file | Section |
| --- | --- | --- |
| Operating Contract required before non-trivial work | `rules/ai-workflow-policy.md` | `## Explicit Operating Contract (Mandatory)` |
| Stopping condition field required in Operating Contract | `rules/ai-workflow-policy.md` | `### 5. Stopping Condition` |
| Stopping condition format uses verifiable condition with separate evaluator | `rules/ai-workflow-policy.md` | `### 5. Stopping Condition` |
| OBSERVE is mandatory step 7 after every session (tokens/USD, latency/calls, incidents) | `rules/ai-workflow-policy.md` | `### Enforcement` |
| Context ceiling hard limit for subtasks | `rules/ai-workflow-policy.md` | `### Context Rot Prevention` |
| Manual compaction threshold | `rules/ai-workflow-policy.md` | `## Token Conservation` |

## Retrieval

| Rule | Source file | Section |
| --- | --- | --- |
| Retrieved context is untrusted until validated | `rules/ai-retrieval-policy.md` | `## 3) Retrieval Result Sandboxing` |
| Retrieved context hard cap is <= 40% of active window | `rules/ai-retrieval-policy.md` | `### Enforcement (Pre-Task Checklist, Mandatory)` |
| Index rebuild required on any source document change | `rules/ai-retrieval-policy.md` | `### Enforcement (Pre-Task Checklist, Mandatory)` |
| Retrieval controls are pre-task checklist controls, not post-hoc review | `rules/ai-retrieval-policy.md` | `### Enforcement (Pre-Task Checklist, Mandatory)` |
| Prompt injection risk from retrieval requires KB access and ingestion controls | `rules/ai-retrieval-policy.md` | `## 3) Retrieval Result Sandboxing` |

## Security

| Rule | Source file | Section |
| --- | --- | --- |
| Tool access must be explicitly allowlisted | `rules/security-policy.md` | `## 8) API-Calling Agents (Tool Use Security)` |
| Destructive operations require mandatory HITL authorization | `rules/security-policy.md` | `## 8) API-Calling Agents (Tool Use Security)` |
| Autonomous destructive operations are prohibited | `rules/security-policy.md` | `## 8) API-Calling Agents (Tool Use Security)` |
| Destructive-operation authorization gates are mandatory | `rules/security-policy.md` | `#### PI-6.3: Destructive Operation Authorization (Mandatory HITL)` |
| PreToolUse hooks enforce pre-execution safety gates | `rules/security-policy.md` | `## 8.1.1) PreToolUse Agent Guardrail Hooks` |

## Cost/Model

| Rule | Source file | Section |
| --- | --- | --- |
| New workflows require cost-per-inference estimate and cheaper-first evaluation | `rules/model-cost-discipline.md` | `## Mandatory rules` |
| Larger-model upgrade allowed only after quality-threshold failure | `rules/model-cost-discipline.md` | `## Mandatory rules` |
| Cheaper-first re-evaluation required at recertification for existing workflows | `rules/model-cost-discipline.md` | `## Mandatory rules` |
| Recertification cadence is quarterly or on model tier change | `rules/model-cost-discipline.md` | `## Mandatory rules` |
| Prompt and response token controls are mandatory | `rules/token-cost-controls.md` | `## Mandatory rules` |

## Agent Runtime

| Rule | Source file | Section |
| --- | --- | --- |
| Every workflow defines max runtime threshold before deployment | `rules/agent-stopping-conditions.md` | `## Mandatory rules` |
| Timeouts required at session/tool/async levels | `rules/agent-stopping-conditions.md` | `## Mandatory rules` |
| Three or more timeouts in 24h triggers incident review | `rules/agent-stopping-conditions.md` | `## Mandatory rules` |
| Agent APIs require distinct traffic class | `rules/agent-stopping-conditions.md` | `## Agent–microservices resilience (mandatory for agent-exposed APIs)` |
| Agent-tool idempotency default with documented non-idempotent POST exception | `rules/agent-stopping-conditions.md` | `## Agent–microservices resilience (mandatory for agent-exposed APIs)` |
| Undocumented non-idempotent agent tools are prohibited | `rules/agent-stopping-conditions.md` | `## Agent–microservices resilience (mandatory for agent-exposed APIs)` |
| Non-idempotent POST semantics cross-reference for agent-tool exception | `rules/web-policies.md` | `### HTTP methods and semantics` and `### HTML forms and HTTP semantics` |

## Verification

| Rule | Source file | Section |
| --- | --- | --- |
| LLM output is candidate, not result | `rules/llm-usage-policy-hallucinations.md` | `### 4.3 Treat outputs as hypotheses` |
| CoT/scratchpad cannot be used as proof or audit trail | `rules/llm-usage-policy-hallucinations.md` | `## 3. Forbidden usage` |
| Always-verify behavior is mandatory | `rules/llm-usage-policy-hallucinations.md` | `### 4.1 Always verify` |
| Verification checkpoints are mandatory before action | `rules/templates/prompt-template.md` | `## Verification Checkpoints (Mandatory)` |
| Verify-before-complete workflow requirement | `rules/ai-workflow-policy.md` | `## Core Principle` and `### Enforcement` |
