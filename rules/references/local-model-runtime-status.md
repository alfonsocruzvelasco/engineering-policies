# Local Model Runtime Status (Machine Notes)

**Status:** Supporting reference (non-normative)
**Last updated:** 2026-04-09
**Purpose:** Capture locally validated model/runtime combinations on this machine.

> This document records **what runs locally**. It does **not** approve tools for
> organizational use. For approval/prohibition and security posture, see:
> `rules/approved-ai-tools.md`, `rules/security-policy.md`, and
> `rules/ai-tool-policy-quick-reference.md`.

---

## Successfully run local models

### Ollama

- **Gemma 4 E4B**
  - Working with OpenClaw
  - GPU acceleration confirmed (~5.9 GB VRAM)

### llama.cpp (manual GGUF)

- **Gemma 4 E2B**
  - Path: `~/dev/models/gemma-4-e2b-it-gguf/gemma-4-E2B-it-Q4_K_M.gguf`
  - Working: good speed on RTX 4070

- **Qwen2.5-Coder-7B-Instruct**
  - Path: `~/dev/models/qwen2.5-coder-7b/qwen2.5-coder-7b-instruct-q4_k_m.gguf`
  - Working: loads and runs well
  - Caveat: close previous sessions first, or VRAM OOM can happen

---

## Practical recommendation

- **Gemma 4 E4B + OpenClaw**: agent/general assistant usage
- **Qwen2.5-Coder-7B**: code help
- **Gemma 4 E2B (llama.cpp)**: lightweight fast local chat

RTX 4070 is handling this stack well.

---

## Security and policy note

`OpenClaw` appears in this file only as an **observed runtime pairing**.
Current policy still treats OpenClaw as prohibited for approved engineering
workflows unless an explicit, documented exception exists:

- `rules/security-policy.md` (external AI tool restrictions)
- `rules/approved-ai-tools.md` (approved registry)
- `rules/security-exceptions.md` (exception record, if granted)
