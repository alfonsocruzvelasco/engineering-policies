---
doc_type: policy
authority: authoritative
owner: Alfonso Cruz
scope: Non-negotiable hallucination posture for LLM usage; complements ai-workflow-policy and ai-retrieval-policy
---

# LLM Usage Policy — Hallucinations

**Status:** Authoritative
**Last updated:** 2026-04-03

**Authority:** This document states the **non-negotiable hallucination posture** for LLM usage. **Operational checklists, verification gates, Fano-based ambiguity framing, and the Hallucination & Consequence Test** remain in [`ai-workflow-policy.md`](ai-workflow-policy.md) (§6 and Verification-First). **Retrieval architecture, RAG formulations, and ingestion rules** remain in [`ai-retrieval-policy.md`](ai-retrieval-policy.md). If anything here disagrees with those files on retrieval mechanics, **`ai-retrieval-policy.md` wins**; on workflow and verification procedure, **`ai-workflow-policy.md` wins**.

**Evidence (survey context):** Broader LLM behavior and limitations (including reasoning–computation alignment) are discussed in [`references/a-survey-of-large-language-models.pdf`](references/a-survey-of-large-language-models.pdf).

---

## 1. Core rule

LLMs optimize **likelihood**, not **truth**.

---

## 2. Non-negotiable assumption

Hallucinations are **inevitable**.

---

## 3. Forbidden usage

Never use LLMs for:

- factual claims without verification
- critical decisions
- system commands without validation
- security-sensitive operations
- **chain-of-thought (CoT), scratchpad, or “show your work” text as proof of correct reasoning or as an audit trail** — in CoT-style models, visible reasoning can be **disconnected from the computation path** that produced the answer; the model may emit plausible step-by-step text that **did not** drive the final output. Treating CoT as a substitute for independent verification is a **specific hallucination risk**.

---

## 4. Mandatory behavior

### 4.1 Always verify

- cross-check outputs
- confirm with external sources
- never trust first answer

---

### 4.2 Use LLMs for

- drafting
- brainstorming
- code scaffolding
- pattern recognition

NOT for:

- final truth
- authoritative answers

---

### 4.3 Treat outputs as hypotheses

LLM output = **candidate**, not **result**.

---

## 5. System design rules

- never place LLM in final decision loop
- always add validation layer
- prefer deterministic systems when possible
- **Retrieval grounding (RAG)** is a **mitigation layer**, not a solution — it can reduce hallucination frequency on factual queries but **does not** eliminate confabulation; the model can still invent or miscombine facts when retrieved context is ambiguous, incomplete, or mis-weighted. **Normative detail:** [`ai-retrieval-policy.md`](ai-retrieval-policy.md) (architecture selection, ingestion, sandboxing, evaluation). Treat RAG as **one** layer alongside tests, measurements, and external fact checks — not a substitute for them.

---

## 6. Key tradeoff

Higher fluency → higher risk of hallucination.

---

## 7. One-line rule

**If it matters, verify it.**

Everything else in this repository is operational detail around that anchor.
