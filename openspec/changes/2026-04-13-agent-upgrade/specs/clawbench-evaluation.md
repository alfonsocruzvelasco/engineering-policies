# clawbench-evaluation

**Source:** `rules/references/clawbench.pdf`

**Adopt for agent eval and debugging:**

1. Score **end-to-end workflow completion** (tools, termination, artifacts)—not answer polish or single-turn quality alone.
2. Classify regressions with the **failure-taxonomy** in `rules/references/ai-mutation-testing-debugging-reference.md` (`wrong-tool-selection`, `invalid-tool-use`, `dead-loop`, `partial-completion`, `hallucinated-action`).
3. Every agent-harness change ships **measurable success criteria on a real workflow** per `rules/ai-workflow-policy.md` Reliability Surface MUST; agents state criteria and failure modes before edits per root `AGENTS.md` (`agent-workflow-changes`).
