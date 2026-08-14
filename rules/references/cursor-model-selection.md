# Cursor model selection: practical default

## Goal

Avoid wasting time in Cursor's model/effort picker while keeping control over cost and reasoning depth.

## Default setup

Use this as the normal configuration:

> **Grok 4.6 + Medium effort + Fast OFF + Auto OFF**

This should handle ordinary coding work without making model selection a decision every time.

## Escalation rule

Only change the default when the task justifies it:

- **Medium** → normal implementation, refactors, tests, routine debugging.
- **High** → difficult architecture, stubborn bugs, ambiguous multi-step work.
- **Fast** → only when latency matters enough to justify the higher price.
- **Auto** → only when I explicitly prefer Cursor to choose for me.

## Task routing — when to use Grok 4.6 vs switch away

### Use Grok 4.6 (stay on default)

- **CUDA kernel work** — xAI trained Grok 4.6 explicitly
  on kernel optimization. Use it for CUDA implementations,
  kernel debugging, memory hierarchy reasoning, and
  performance tuning. This is a confirmed training edge,
  not a marketing claim.

- **Long agent tasks with multi-file scope** — Terminal-Bench
  v2.1: 88.4%. Use Grok 4.6 for implementations that require
  holding architectural context across multiple files
  simultaneously, or for agent sessions that run many
  sequential tool calls without losing the thread.

- **Stubborn bugs after Medium has already failed** — escalate
  to Grok 4.6 High only after Medium on the current model
  has demonstrably failed, not preemptively. The failure must
  be observed, not anticipated.

### Switch to a lighter model (Ctrl + /)

- **Mechanical follow-up** — after Grok completes the hard
  part of a task, switch for reformatting, renaming, moving
  code, or applying a pattern Grok already demonstrated.

- **Documentation generation** — for code you have already
  written, reviewed, and understood. No architectural
  reasoning required; a cheaper model is sufficient.

- **Quick one-shot lookups** — single-turn questions that
  do not require multi-step reasoning or tool use. Syntax
  checks, format questions, simple references.

### Rule

Grok 4.6 credits spent on mechanical work are credits
unavailable for kernel and architectural work. Route
deliberately. The session budget is fixed; the allocation
is yours to control.

The principle is:

> **Start with one stable default. Escalate deliberately. Do not choose from scratch for every prompt.**

## Why not Auto by default?

Auto reduces selection friction by giving Cursor control over model choice. That is useful when I do not care which model handles the task.

But if I want predictable model choice, reasoning effort, and cost, **Auto solves the UX problem by removing the granularity I wanted to preserve**.

Cursor currently charges Auto Balance and Auto Intelligence according to the model actually used.

## Fast mode

Keep **Fast OFF** by default.

For Grok 4.5, Cursor currently lists the Fast variant at a substantially higher token price than the standard variant. Use it when response latency is genuinely valuable, not as the everyday setting.

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

Checked 2026-08-14:

- Cursor Models & Pricing: https://cursor.com/docs/models-and-pricing
- Cursor Keyboard Shortcuts: https://cursor.com/docs/reference/keyboard-shortcuts
- Cursor Blog — Introducing Grok 4.6: https://cursor.com/blog/grok-4-6
