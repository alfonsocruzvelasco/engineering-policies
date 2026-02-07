# OpenSpec: Engineering Reference for ML/CV Teams

**Governance for AI-Assisted Development**

---

## 📌 ONE-LINE DEFINITION

> **OpenSpec is a lightweight, repo-native discipline for making intent, constraints, and decisions explicit so AI agents don't silently corrupt engineering work.**

**Repository:** https://github.com/Fission-AI/OpenSpec

---

## 📑 Table of Contents

1. [Core Concepts](#1-core-concepts)
2. [Mental Model](#2-mental-model)
3. [When to Use OpenSpec](#3-when-to-use-openspec)
4. [OpenSpec vs. Other Tools](#4-openspec-vs-other-tools)
5. [Structure & Components](#5-structure--components)
6. [ML/CV Specific Patterns](#6-mlcv-specific-patterns)
7. [Decision Trees](#7-decision-trees)
8. [Common Failure Modes](#8-common-failure-modes)
9. [Example Templates](#9-example-templates)

---

## 1. Core Concepts

### What OpenSpec Is

Governance for AI-assisted engineering that makes intent, constraints, and decisions explicit. Not a prompt format. Not magic. Just structured authority.

### What OpenSpec Is NOT

- ❌ A prompt format or template system
- ❌ A formal grammar (BNF, EBNF, etc.)
- ❌ A replacement for tests or CI/CD
- ❌ A coding standard or style guide
- ❌ An ML configuration system (like Hydra, Sacred)
- ❌ A specification language for parsers

### Why ML/CV Engineers Need It

ML/CV work is **high-risk for AI drift** because:

- Pipelines are multi-stage and stateful
- Data invariants matter more than code elegance
- Silent regressions are common
- "Looks correct" ≠ "is correct"
- Models, data, and code evolve independently

LLMs are **especially dangerous** here because they:

- Confidently refactor pipelines
- "Simplify" dataset logic
- Break reproducibility
- Invent preprocessing steps
- Violate assumptions you forgot to restate

**OpenSpec exists to lock down invariants that must not move.**

---

## 2. Mental Model

### Think: Architecture Decision Records for AI Agents

OpenSpec is like ADRs applied continuously throughout development:

```
Human intent
   ↓
OpenSpec (authoritative constraints)
   ↓
Prompts (execution requests)
   ↓
AI-generated code
```

**Key rule:** Prompts may ask. OpenSpec decides.

### Four Standardizations

#### 1. Authority

Where truth lives:

- Specs > prompts
- Specs > chat history
- Specs > "what the model thinks is best"

#### 2. Persistence

Intent survives across sessions, tools, and agents:

- Cursor today
- Claude tomorrow
- Local LLM next month

Same spec. Same constraints.

#### 3. Scope Control

Explicitly states:

- What may change
- What must not change
- What is out of scope

**Critical for ML pipelines.**

#### 4. Decision Memory

Why something is the way it is. This prevents:

- Repeated debates
- AI "improvements" that break assumptions
- Loss of hard-earned knowledge

---

## 3. When to Use OpenSpec

### ✅ High-Value Uses (Your Bread and Butter)

#### Dataset Invariants

```
"Image dimensions must not be altered"
"Label taxonomy is frozen"
"RGB channel order must remain unchanged"
```

#### Pipeline Contracts

```
"This normalization step is required because X"
"Augmentation must happen before batching"
```

#### Reproducibility Rules

```
"Random seeds: 42 for train, 123 for val"
"Shuffling behavior: deterministic, seeded per epoch"
"No non-deterministic operations in pipeline"
```

#### Performance Constraints

```
"Inference latency: < 50ms per image"
"Memory ceiling: 4GB VRAM"
"Batch size must remain 32 for reproducibility"
```

#### Non-Goals

```
"Do not refactor preprocessing even if it looks redundant"
"Do not modernize to latest PyTorch idioms"
"Leave legacy compatibility layer intact"
```

#### Architectural Boundaries

```
"Training code must not import inference code"
"Data loading isolated from model definitions"
```

### ❌ Low-Value Uses (Don't Waste Time)

Do **NOT** use OpenSpec for:

- Style nitpicks (use linters)
- Obvious code behavior
- What tests already enforce
- Temporary experiments

> **Remember: OpenSpec is for invariants, not preferences.**

---

## 4. OpenSpec vs. Other Tools

| Comparison | Key Difference |
|------------|----------------|
| **vs. Prompts** | Prompts are **imperative**. OpenSpec is **constitutional**. |
| **vs. Tests** | Tests detect violations **after the fact**. OpenSpec prevents violations **before generation**. |
| **vs. Documentation** | Docs **explain**. OpenSpec **constrains**. |
| **vs. BNF/Formal Specs** | BNF defines **syntax**. OpenSpec defines **intent and invariants**. Different layers. |
| **vs. Config Systems** | Hydra/Sacred manage **parameters**. OpenSpec governs **AI agent behavior** and decision-making. |

### Complementary Relationships

- **You still need tests.** OpenSpec reduces how often you rely on them to catch stupidity.
- **You still need docs.** OpenSpec is what AI agents must respect; docs are what humans read to understand.
- **You still need config.** OpenSpec constrains what AI can change; config files hold runtime values.

---

## 5. Structure & Components

### Minimal OpenSpec Structure

You do **NOT** need ceremony. A good OpenSpec for ML/CV typically contains:

| Section | Purpose |
|---------|---------|
| **Purpose** | Why this system exists |
| **Invariants** | What must not change *(most important)* |
| **Constraints** | Hardware, data, performance, reproducibility |
| **Scope** | What changes are allowed right now |
| **Non-goals** | Explicit "do not touch" |
| **Decision Log** | Why key choices were made (lightweight) |

**That's enough.**

---

## 6. ML/CV Specific Patterns

### Data Pipeline Invariants

```markdown
## Invariants

### Data Format
- Image dimensions: 224x224 (do not resize or crop)
- Color space: RGB (never convert to BGR)
- Pixel range: [0, 255] uint8

### Label Schema
- Classes: {0: 'cat', 1: 'dog', 2: 'bird'}
- Adding classes requires manual approval
- Changing class order breaks checkpoint compatibility
```

### Reproducibility Constraints

```markdown
## Constraints

### Reproducibility
- Random seed: 42 (global, do not change)
- torch.backends.cudnn.deterministic = True
- torch.backends.cudnn.benchmark = False
- DataLoader workers: 0 (non-deterministic if > 0)

WHY: Paper results must be exactly reproducible
```

### Model Architecture Boundaries

```markdown
## Non-Goals

### Do NOT Refactor
- Preprocessing pipeline (legacy compatibility)
- Model init weights (checkpoint SHA256 locked)
- Augmentation order (results differ even if 'equivalent')

### Do NOT Modernize
- torch.nn.functional → nn.Module conversion
- 'Legacy' batch norm behavior (frozen for reproducibility)
```

### Performance Budgets

```markdown
## Constraints

### Performance
- Inference latency: < 50ms @ batch_size=1
- Memory: < 4GB VRAM (GTX 1080 Ti requirement)
- Throughput: > 100 images/sec @ batch_size=32

WHY: Production deployment on edge devices
```

---

## 7. Decision Trees

### Should I Add This to OpenSpec?

```
START
  ↓
Is this a style preference?
  YES → Use linter/formatter
  NO ↓
Do tests already catch violations?
  YES → Leave it to tests
  NO ↓
Will breaking this cause silent failure?
  NO → Probably don't need OpenSpec
  YES ↓
Is this an invariant or architectural decision?
  YES → ADD TO OPENSPEC
```

### Where Does This Go in My Spec?

| If It's... | Put It In... |
|------------|--------------|
| Must NEVER change | **Invariants** |
| Hardware/performance limit | **Constraints** |
| Currently allowed to change | **Scope** |
| Must NOT be "improved" | **Non-goals** |
| Why we chose X over Y | **Decision Log** |

---

## 8. Common Failure Modes

### ⚠️ The #1 Mistake: Treating OpenSpec as a Mega-Prompt

**WRONG:** Pasting the entire spec into every prompt

This collapses authority back into chat and you lose everything OpenSpec gives you.

**RIGHT:** Specs live in the repo. Prompts reference them implicitly.

### Other Common Mistakes

#### Over-Specification

- **Problem:** Adding every minor detail to the spec
- **Result:** Spec becomes unreadable noise
- **Fix:** Only document what AI might break

#### Specification Without Enforcement

- **Problem:** Writing specs but never checking compliance
- **Result:** Specs drift, AI ignores them
- **Fix:** Periodic spec reviews + integration tests for invariants

#### Stale Specs

- **Problem:** Specs not updated when system evolves
- **Result:** AI follows outdated constraints
- **Fix:** Treat spec updates as part of architecture changes

#### Using OpenSpec for Preferences Instead of Invariants

- **Problem:** "Use 4 spaces for indentation" in OpenSpec
- **Result:** Cluttered spec, confusion about what matters
- **Fix:** Preferences → linter. Invariants → OpenSpec.

---

## 9. Example Templates

### Computer Vision Pipeline Spec

```markdown
# OpenSpec: Object Detection Pipeline

## Purpose
Real-time object detection for retail inventory

## Invariants

### Data Format
- Input: 640x640 RGB images
- DO NOT resize to other dimensions
- DO NOT convert color space
- Pixel range: [0, 255] uint8

### Label Schema
- 80 COCO classes (frozen)
- Class IDs match COCO exactly
- Adding classes breaks checkpoint compatibility

### Model Architecture
- YOLOv5s (DO NOT upgrade to v8)
- Pretrained weights SHA: abc123...
- Anchor boxes locked (changing breaks inference)

## Constraints

### Performance
- Latency: < 30ms @ batch_size=1 (Jetson Xavier)
- Memory: < 2GB VRAM
- FPS: > 30 (real-time requirement)

### Reproducibility
- Seed: 42 (global)
- cudnn.deterministic = True
- DataLoader workers = 0

## Scope
- May optimize: data loading, augmentation pipeline
- May add: logging, monitoring, profiling
- May refactor: training loop structure

## Non-Goals
- DO NOT refactor preprocessing (legacy compatibility)
- DO NOT upgrade PyTorch version (>1.10 breaks)
- DO NOT change augmentation order (non-commutative)
- DO NOT 'simplify' NMS logic (tuned for edge cases)

## Decision Log

### Why YOLOv5s not v8?
v8 has 2x memory footprint, exceeds Jetson limit

### Why 640x640?
Trade-off: accuracy vs speed. Tested 320/480/640/800.
640 hits mAP target with 30ms latency.
```

### Training Pipeline Spec

```markdown
# OpenSpec: ResNet50 Training Pipeline

## Purpose
Reproduce ImageNet baseline for internal benchmarking

## Invariants

### Training Config
- Epochs: 90
- Batch size: 256 (DO NOT change, affects BN stats)
- Optimizer: SGD (momentum=0.9, weight_decay=1e-4)
- LR schedule: step decay [30, 60, 80] epochs
- Initial LR: 0.1

### Data Augmentation (Order Matters)
1. RandomResizedCrop(224)
2. RandomHorizontalFlip()
3. ColorJitter(0.4, 0.4, 0.4)
4. ToTensor()
5. Normalize([0.485,0.456,0.406], [0.229,0.224,0.225])

DO NOT reorder (non-commutative)

## Constraints
- GPU: 4x V100 (32GB)
- PyTorch: 1.10 (DO NOT upgrade, see Decision Log)
- Mixed precision: OFF (reproducibility)

## Non-Goals
- DO NOT add: warmup, cosine LR, label smoothing
- DO NOT change: BN momentum (legacy compatibility)

## Decision Log

### Why PyTorch 1.10?
1.11+ changes BN default eps (1e-5 → 1e-6)
This breaks checkpoint compatibility with baselines
```

### Dataset Processing Spec

```markdown
# OpenSpec: Medical Image Dataset

## Purpose
CT scan preprocessing for lung nodule detection

## Invariants

### Data Format
- Input: DICOM files
- Output: 512x512x512 HU volumes
- Spacing: 1mm isotropic (DO NOT resample to other spacing)
- Window: [-1000, 400] HU (lung window, frozen)

### Preprocessing Pipeline (LOCKED)
1. Load DICOM → pydicom
2. Extract HU values (slope/intercept from metadata)
3. Resample to 1mm isotropic (linear interpolation ONLY)
4. Clip to [-1000, 400] HU
5. Normalize to [0, 1]

DO NOT modify order or methods

### Label Format
- Bounding boxes: [x, y, z, w, h, d] in mm coordinates
- Classes: {0: 'benign', 1: 'malignant'}
- Coordinate system: RAS (DO NOT convert to LPS)

## Constraints

### Medical Compliance
- HIPAA: All PHI must be stripped before processing
- Audit trail: Log all transformations
- Validation: Radiologist review required for label changes

### Performance
- Processing time: < 5 seconds per volume
- Memory: < 16GB RAM per worker

## Non-Goals
- DO NOT apply any smoothing/filtering (radiologist decision)
- DO NOT auto-adjust window (clinical standard frozen)
- DO NOT modify DICOM metadata

## Decision Log

### Why 1mm isotropic?
Clinical requirement. Nodules < 3mm must be detectable.
Coarser spacing misses small nodules.

### Why lung window [-1000, 400]?
Standard clinical practice. Other windows hide nodule texture.
```

---

## 🎯 Final Takeaway

> **OpenSpec is not about telling AI what to do.**
>
> **It's about telling AI what it is not allowed to break.**
>
> **That is exactly what elite ML/CV engineering requires.**

---

## 📚 Additional Resources

- **GitHub Repository:** https://github.com/Fission-AI/OpenSpec
- Example real ML pipeline spec
- Dataset versioning & reproducibility patterns
- AI failure case studies

---

## How Elite ML/CV Engineers Use OpenSpec

They use it to:

- ✅ Freeze dataset semantics before letting AI touch code
- ✅ Guard preprocessing logic
- ✅ Prevent "helpful" refactors
- ✅ Maintain long-running pipelines
- ✅ Enable safe delegation to AI
- ✅ Scale themselves without losing control

They **don't**:

- ❌ Paste specs into prompts
- ❌ Argue with models
- ❌ Hope the AI "gets it"

**They let the spec do the arguing.**

---

## Why OpenSpec Works Well with LLMs

LLMs are very **good** at:

- Following explicit constraints
- Respecting "authoritative documents"
- Aligning to written intent

They are very **bad** at:

- Remembering context
- Inferring invariants
- Knowing what must not change

**OpenSpec feeds them exactly what they need:**

- Clear authority
- Stable reference
- Explicit boundaries

---

## One Brutal Truth

If you are doing serious ML/CV work **without a spec discipline**, then:

- You are relying on memory
- You are relying on luck
- You are one refactor away from a silent regression

**OpenSpec doesn't make you smarter.**

**It makes your intent harder to violate.**
