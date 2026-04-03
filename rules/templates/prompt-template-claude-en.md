# Prompt template — Claude (Hard Constraint Mode, ML/CV)

**Version:** v3 (platform override)

> Base: prompt-template.md (v3) — GSD phases, forbidden list, and golden rule are identical

**Canonical execution:** Task Card, Spec–Plan–Patch–Verify, and verification checkpoints are defined in `prompt-template.md` (v3); they are not duplicated here. This file adds the ML/CV Hard Constraint overlay and YOLO example only.

---

## 🎯 OBJECTIVE

<Define in 1 line exactly what you want to build, fix, or understand>

---

## 🔒 CONSTRAINTS (NON-NEGOTIABLE)

* Language/framework: <Python 3.x / PyTorch / OpenCV / ONNX / etc.>
* Environment: <local GPU / GCP / Docker / TensorRT / etc.>
* Interface contract: <input shape, output format, latency budget, throughput target>
* Code standard: production-grade (error handling, logging, typed, tested)

---

## 🚫 FORBIDDEN

* Toy implementations without error handling or logging
* Hardcoded paths, magic numbers, or implicit global state
* Pickle serialization for model artifacts
* Skipping type hints or docstrings on public interfaces
* Proposing architecture changes without profiling data

---

## 🧱 WORKING METHOD

* Socratic first — ask guiding questions, do not hand me the solution
* Rebuild from scratch (do not patch previous versions unless explicitly asked)
* Spec → Plan → Execute → Verify — in that order, no skipping
* Max 3 tasks per plan; one surgical commit per task

---

## ✔️ MANDATORY VALIDATION

Before responding, verify:

* Does the solution meet ALL constraints?
* Is the code portfolio-ready? (Would it pass a robotics/CV company review?)
* Are there unresolved design decisions or hidden assumptions?

If NOT:

→ DO NOT respond with a partial solution
→ Rework internally until it fully complies

---

## 📦 OUTPUT

<Exact deliverable: script / module / benchmark results / architecture sketch / test suite>

Include:
- Inline comments explaining non-obvious decisions
- One-paragraph justification of key design choices
- Clear next action at the end

---

# 🎯 REAL EXAMPLE (CV inference pipeline)

## 🎯 OBJECTIVE

Build a production-ready YOLOv8 inference module with TensorRT export

## 🔒 CONSTRAINTS

* Python 3.11, PyTorch 2.x, TensorRT 8.x
* Input: BGR uint8 frames from OpenCV, batch size 1
* Output: List[Detection] with (bbox_xyxy, conf, class_id)
* Latency: < 20ms per frame on T4 GPU
* No pickle; export via ONNX → TensorRT .engine

## 🚫 FORBIDDEN

* Using `.pt` weights directly in production path
* Skipping FP16 precision analysis
* Any global model state
* Hardcoded image size

## 🧱 WORKING METHOD

* Socratic: explain your preprocessing choices before I see code
* Spec first: define Detection dataclass and interface contract
* One module per responsibility (preprocess / infer / postprocess)

## ✔️ VALIDATION

* Latency benchmark included (torch.cuda.Event timing)
* Unit tests for pre/post processing
* README section: "Why TensorRT over pure ONNX Runtime?"

## 📦 OUTPUT

Single self-contained Python module + pytest file + benchmark script

---

# 🧠 KEY (why this works for ML/CV)

This turns your prompt into:

> **a technical specification with measurable exit criteria**

Which:
* forces you to define the interface before the implementation
* makes design decisions explicit and reviewable
* kills scope creep at the prompt level
* produces portfolio-grade artifacts, not demos

---

# ⚠️ GOLDEN RULE

If something fails constraints:

👉 Don't explain
👉 Don't argue

Write:

> **"Does not meet constraints. Rebuild from scratch."**

And if a design decision is vague:

> **"Ambiguous constraint. State the tradeoff and pick one."**
