# Cursor model selection: practical default

## Goal

Avoid wasting time in Cursor's model/effort picker while keeping control over cost and reasoning depth.

## Default setup

Use this as the normal configuration:

> **GPT-5.3 Codex + Medium effort + Fast OFF + Auto OFF**
>
> Update (2026-09-23): stable default is **GPT-5.3 Codex + Medium effort + Fast OFF + Auto OFF**.
> Keep Grok 4.6 as compatibility fallback.

This should handle ordinary coding work without making model selection a decision every time.

## Escalation rule

Only change the default when the task justifies it:

- **Medium** → normal implementation, refactors, tests, routine debugging.
- **High** → difficult architecture, stubborn bugs, ambiguous multi-step work.
- **Fast** → only when latency matters enough to justify the higher price.
- **Auto** → only when I explicitly prefer Cursor to choose for me.

## Task routing — when to stay on GPT-5.3 Codex vs switch to Grok 4.7

### Switch to Grok 4.7 when the task earns it

- **CUDA kernel work** — use Grok 4.7 first; if behavior regresses or
  compatibility issues appear, fall back to Grok 4.6, which was trained explicitly
  on kernel optimization. Use it for CUDA implementations,
  kernel debugging, memory hierarchy reasoning, and
  performance tuning. This is a confirmed training edge,
  not a marketing claim.

- **Long agent tasks with multi-file scope** — use Grok 4.7 for
  long-running multi-file sessions. Keep Grok 4.6 as a tested fallback
  when routing needs compatibility with prior workflows.
  Use this class for implementations that require
  holding architectural context across multiple files
  simultaneously, or for agent sessions that run many
  sequential tool calls without losing the thread.

- **Stubborn bugs after Medium has already failed** — escalate
  to Grok 4.7 High only after Medium on the current model
  has demonstrably failed, not preemptively. The failure must
  be observed, not anticipated.

### Return to GPT-5.3 Codex after escalation

After switching to Grok 4.7 for a hard task, return to the
stable GPT-5.3 Codex Medium default when the harder model is
no longer needed.

- **Mechanical follow-up** — use GPT-5.3 Codex Medium for
  reformatting, renaming, moving code, or applying a pattern
  already established during the harder part of the task.

- **Documentation generation** — use GPT-5.3 Codex Medium for
  code already written, reviewed, and understood when no
  additional architectural reasoning is required.

- **Quick one-shot lookups** — stay on GPT-5.3 Codex Medium
  for syntax checks, format questions, simple references, and
  other single-turn work that does not justify escalation.

### Rule

Grok 4.7 credits spent on mechanical work are credits
unavailable for kernel and architectural work. Route
deliberately. The session budget is fixed; the allocation
is yours to control.

The principle is:

> **Start with one stable default. Escalate deliberately. Do not choose from scratch for every prompt.**

## Financial guardrail

Authority: `rules/approved-ai-tools.md` SPEND FREEZE. This
section does not create a second spend policy.

- Included-usage accounting is not incremental billing.
  GPT-5.3 Codex uses Cursor's Other Models included-usage pool.
  Grok 4.7 and Grok 4.6 use Cursor's Cursor Models included-usage
  pool. All consume included/prepaid plan allowance according
  to Cursor's current accounting; none is permanently free.
- Auto OFF is not the hard billing cap. It keeps routing
  and included-usage consumption predictable.
- On-Demand Usage Disabled is the fail-closed billing
  control. Fixed and Unlimited on-demand modes are
  prohibited during the freeze. If included usage is
  exhausted, stop/throttle/wait for reset. Never enable
  paid overage to finish a task.
- Cursor Cloud Agents are FROZEN. They currently bill at
  selected-model API pricing with a separate spend-limit
  surface and require an explicit owner freeze lift.
- The account-owner Cursor notice states that, effective
  2026-08-24, Auto pricing/accounting will depend on the
  model each request is routed to. That future vendor
  change is not a freeze lift.
  Under this policy, Auto remains OFF unless the owner
  explicitly chooses otherwise.

Sources: Cursor Models & Pricing; Cursor Cloud Agents
billing documentation; account-owner Cursor email announcing
the 2026-08-24 Auto pricing change.

## Why not Auto by default?

Auto reduces selection friction by giving Cursor control over model choice. That is useful when I do not care which model handles the task.

But if I want predictable model choice, reasoning effort, and cost, **Auto solves the UX problem by removing the granularity I wanted to preserve**.

The account-owner Cursor notice states that, effective
2026-08-24, Auto pricing/accounting will depend on the model
each request is routed to. This future vendor change does not
lift the SPEND FREEZE and does not make Auto the policy
default.

## Fast mode

Keep **Fast OFF** by default.

For Grok-class Cursor models, Fast is typically priced higher than standard mode. Use it when response latency is genuinely valuable, not as the everyday setting.

## Switching without fighting the picker

Use:

> **Ctrl + /** → cycle between AI models

Cursor documents this shortcut and allows Cursor keybindings to be remapped.

The picker should therefore be an exception, not part of every interaction.

## What I would not try to optimize

Do not build a complicated model-routing ritual around every task.

The useful hierarchy is simply:

> **Normal work → Medium**
> **Hard work → High**
> **Need speed → Fast**
> **Do not care which model → Auto**

If Cursor later changes its model UX, keep the principle and update the specific model/settings.

## Where this knowledge belongs

This is an operational Cursor preference, not an Obsidian knowledge-management system.

- **Cursor/repository configuration** → executable agent behavior and project constraints.
- **Obsidian** → durable cross-project lessons, such as *why* this escalation policy works.

## Sources

Checked 2026-09-23:

- Cursor Cloud Agents billing documentation
- Cursor Keyboard Shortcuts: https://cursor.com/docs/reference/keyboard-shortcuts
- Cursor docs — Grok 4.7: https://cursor.com/docs/models/grok-4-7
- Cursor Models & Pricing: https://cursor.com/docs/models-and-pricing
- Cursor docs — Claude Opus 5.5 (Other Models pool): https://prod.cursor.com/docs/models/claude-opus-5-5
- Account-owner Cursor email announcing the 2026-08-24 Auto pricing change
