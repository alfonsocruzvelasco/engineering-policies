---
doc_type: reference
authority: supporting
owner: Alfonso Cruz
scope: Advisor strategy pattern — Opus as advisor, Sonnet/Haiku as executor, single API request
---

# Advisor Strategy — Claude API (April 2026)

**Source:** Anthropic (@claudeai), X post, April 9 2026. 1M views.

## What it is

A native API primitive that pairs a planning model with an execution model within a single API request.

- Executor (Sonnet or Haiku): runs every turn, handles main loop and tool calls
- Advisor (Opus): consulted on-demand when the executor hits a hard decision mid-run
- Shared context: advisor reads the same conversation history and tool history as the executor
- Mechanism: the executor invokes the advisor as a tool call; Opus returns advice; the executor continues — all within a single API request, no separate agent session

## Relationship to existing policy

This is a native API implementation of the planning/execution split already defined in ai-workflow-policy.md (Opus 4.6 for policy/architecture reasoning, Haiku 4.5 for speed). No new policy required.

## Token cost model

Different from a full Opus session. Opus is only invoked when the executor calls it explicitly. Budget planning must account for advisor call frequency, not a flat Opus-per-turn cost. Apply agent cost budgeting rules from ai-workflow-policy.md accordingly.

## Implementation

Add the advisor tool to the Messages API call. The executor calls it when it hits a decision requiring planning-level reasoning. No separate orchestrator or subagent thread required.

## Policy impact

None. Existing agent selection and cost budgeting rules apply without modification.

---
