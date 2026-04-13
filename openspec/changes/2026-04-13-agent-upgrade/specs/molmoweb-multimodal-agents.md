# molmoweb-multimodal-agents

**Source:** `rules/references/molmoweb.pdf`

**Adopt for multimodal / web / GUI agents:**

1. Require **visual or UI-grounded perception** where tasks depend on rendered state; do not treat prose descriptions as a substitute for what is on screen.
2. Design and review harnesses as a **perception → reasoning → action** loop with explicit re-observation after each action class.
3. Honor the **MUST** in `rules/ai-workflow-policy.md` (Verification Instruments): no text-only assumptions for screen/image/UI operation; document the observable representation.
4. Agents follow root `AGENTS.md` (`observable-state`) before planning browser or multimodal steps.
