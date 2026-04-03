# Prompt template — ChatGPT (Hard Constraint Mode)

**Version:** v3 (platform override)

> Base: prompt-template.md (v3) — GSD phases, forbidden list, and golden rule are identical

**Canonical execution:** Task Card, Spec–Plan–Patch–Verify, and verification checkpoints are defined in `prompt-template.md` (v3); they are not duplicated here. This file adds the Hard Constraint overlay and example only.

---

## 🎯 OBJECTIVE

<Define in 1 line exactly what you want to obtain>

---

## 🔒 CONSTRAINTS (NON-NEGOTIABLE)

* <Constraint 1>
* <Constraint 2>
* <Constraint 3>
* <Constraint 4>

---

## 🚫 FORBIDDEN

* <What must NOT happen>
* <Typical mistakes to avoid>
* <Optimizations you do NOT want>

---

## 🧱 WORKING METHOD

* Rebuild from scratch (do not iterate on previous versions)
* Prioritize constraints over any other criteria
* Do not add unsolicited content

---

## ✔️ MANDATORY VALIDATION

Before responding, verify:

* Does it meet ALL constraints?
* Are there any deviations?

If NOT:

→ DO NOT respond with a partial solution
→ Rework internally until it complies

---

## 📦 OUTPUT

<Exact format you want>

---

# 🎯 REAL EXAMPLE (your LaTeX case)

## 🎯 OBJECTIVE

Generate a print-ready A4 LaTeX document

## 🔒 CONSTRAINTS

* EXACTLY 2 pages
* Strong indentation (≥ 3em)
* High readability (low density)
* Clear visual hierarchy

---

## 🚫 FORBIDDEN

* Compressing text to “make it fit”
* Aggressively reducing margins
* Ignoring indentation
* Reusing previous versions

---

## 🧱 WORKING METHOD

* Rebuild from scratch
* Do not optimize anything outside constraints

---

## ✔️ VALIDATION

If it does not meet everything → redo before responding

---

## 📦 OUTPUT

Complete, clean, compilable LaTeX code

---

# 🧠 KEY (why this works)

This turns your prompt into:

> **a technical specification, not a conversation**

Which:

* reduces deviations
* eliminates useless iterations
* lowers token usage
* increases precision

---

# ⚠️ GOLDEN RULE

If something fails:

👉 don’t explain
👉 don’t argue

Just write:

> **“Does not meet constraints. Rebuild from scratch.”**
