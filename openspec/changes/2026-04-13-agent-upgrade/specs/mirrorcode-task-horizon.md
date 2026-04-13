# mirrorcode-task-horizon

**Source:** MirrorCode (Epoch AI / METR, April 2026)

- Agent capability is not bounded by token budget — it is bounded by spec precision and verification signal quality.
- The Pkl failure: the agent identified the correct architecture 192+ times and deferred it each time. More tokens would not have fixed an architectural decision the spec did not force.
- The gotree success: precise end-to-end tests made correctness unambiguous at every step. The agent could not submit until verification passed.
- Rule encoded in policy: no verification signal → task is invalid for agent execution.
- Implication for harness design: decompose long tasks into steps where each step has a testable output. The spec must force the correct architectural decision early, not leave it optional.
