# Task Management Guide — Osmani Self-Improving Loop

**Purpose:** Systematic approach to breaking down features into atomic tasks and executing them in a continuous improvement loop.

---

## Overview: The Self-Improving Development Loop

```
Feature Spec
    ↓
Break into Atomic Tasks (tasks.json)
    ↓
┌──────────────────────────────────┐
│   SELF-IMPROVING LOOP            │
│                                   │
│  1. Pick next task               │
│  2. Implement (bounded change)   │
│  3. Validate (automated checks)  │
│  4. Commit (if validation passes)│
│  5. Learn (update CLAUDE.md)     │
│  6. Reset context                │
│                                   │
│  Repeat until feature complete   │
└──────────────────────────────────┘
    ↓
Feature Complete
    ↓
Accumulated Knowledge in CLAUDE.md
```

**Key Principle:** Each loop iteration improves both the codebase AND the knowledge base.

---

## Task Decomposition: Feature → Atomic Tasks

### What Makes a Task "Atomic"?

**Definition:** An atomic task is:
- ✅ **Completable in <30 minutes** (single focused work session)
- ✅ **Single, well-defined change** (one commit)
- ✅ **Independently verifiable** (clear pass/fail criteria)
- ✅ **No dependencies on incomplete work** (can start immediately)
- ✅ **Bounded scope** (touch 1-3 files max)

**Anti-patterns (not atomic):**
- ❌ "Build complete training pipeline" (too large, multiple tasks)
- ❌ "Improve model accuracy" (vague, no clear completion)
- ❌ "Refactor everything" (unbounded scope)
- ❌ "Add logging and fix bug and optimize" (multiple concerns)

### Decomposition Process

**Step 1: Start with Feature Spec**

Example feature spec (from Spec Kit):
```markdown
## Feature: Defect Detection Pipeline

### Requirements
- SHALL load PCB images from dataset
- SHALL detect defects with mAP ≥ 0.75
- SHALL process 4096×4096 images
- SHALL handle 1:100 class imbalance
- SHALL be reproducible (seeded)
```

**Step 2: Identify Technical Components**

Break spec into technical subsystems:
1. Data pipeline (loading, splitting, augmentation)
2. Model architecture (backbone, head, loss)
3. Training loop (optimization, logging, checkpointing)
4. Validation (metrics, visualization)
5. Inference (export, optimization)

**Step 3: Break Components into Atomic Tasks**

For each component, create atomic tasks:

```json
{
  "feature": "defect-detection-pipeline",
  "tasks": [
    // Data Pipeline Component
    {
      "id": "task-001",
      "component": "data-pipeline",
      "title": "Implement dataset class for PCB images",
      "description": "Create PyTorch Dataset that loads images and labels from directory structure",
      "estimated_minutes": 20,
      "acceptance_criteria": [
        "Dataset __len__ and __getitem__ work correctly",
        "Loads images as tensors with correct shape",
        "pytest tests/test_dataset.py passes",
        "Visualize 16 samples successfully"
      ],
      "files_to_change": [
        "src/data/dataset.py",
        "tests/test_dataset.py"
      ],
      "depends_on": [],
      "status": "pending"
    },
    {
      "id": "task-002",
      "component": "data-pipeline",
      "title": "Implement train/val/test split preventing leakage",
      "description": "Split dataset by PCB board ID (not random) to prevent data leakage",
      "estimated_minutes": 25,
      "acceptance_criteria": [
        "No board appears in multiple splits",
        "Split ratios are 70/15/15",
        "Reproducible with seed",
        "pytest tests/test_split.py passes"
      ],
      "files_to_change": [
        "src/data/split.py",
        "tests/test_split.py"
      ],
      "depends_on": ["task-001"],
      "status": "pending"
    },
    {
      "id": "task-003",
      "component": "data-pipeline",
      "title": "Add augmentation pipeline for industrial images",
      "description": "Albumentations pipeline with domain-appropriate augmentations (no color jitter for defects)",
      "estimated_minutes": 30,
      "acceptance_criteria": [
        "Augmentation preserves label validity",
        "Visualize augmented samples",
        "No augmentation leaks labels (e.g., cropping around defect)",
        "pytest tests/test_augmentation.py passes"
      ],
      "files_to_change": [
        "src/data/augmentation.py",
        "tests/test_augmentation.py"
      ],
      "depends_on": ["task-001"],
      "status": "pending"
    },

    // Model Architecture Component
    {
      "id": "task-004",
      "component": "model",
      "title": "Implement EfficientNet-B0 backbone with custom head",
      "description": "Load pretrained EfficientNet-B0, replace head for binary classification",
      "estimated_minutes": 20,
      "acceptance_criteria": [
        "Model forward pass works on sample batch",
        "Output shape correct (batch_size, num_classes)",
        "Pretrained weights load successfully",
        "pytest tests/test_model.py passes"
      ],
      "files_to_change": [
        "src/models/classifier.py",
        "tests/test_model.py"
      ],
      "depends_on": [],
      "status": "pending"
    },
    {
      "id": "task-005",
      "component": "model",
      "title": "Implement focal loss for class imbalance",
      "description": "Focal loss (gamma=2, alpha=0.25) to handle 1:100 imbalance",
      "estimated_minutes": 25,
      "acceptance_criteria": [
        "Focal loss reduces to CE when gamma=0",
        "Gradient is correct (verified with finite differences)",
        "Unit test validates against reference implementation",
        "pytest tests/test_losses.py passes"
      ],
      "files_to_change": [
        "src/losses/focal_loss.py",
        "tests/test_losses.py"
      ],
      "depends_on": [],
      "status": "pending"
    },

    // ... more tasks for training, validation, inference
  ]
}
```

**Step 4: Order Tasks by Dependencies**

Create dependency graph:
```
task-001 (dataset)
   ├──> task-002 (split)
   └──> task-003 (augmentation)
            └──> task-006 (dataloader)

task-004 (model)
task-005 (loss)
   └──> task-007 (training loop)
            └──> task-008 (logging)
                └──> task-009 (checkpointing)

task-010 (validation metrics)
task-011 (inference script)
task-012 (ONNX export)
```

**Step 5: Validate Task Granularity**

For each task, check:
- [ ] Can I complete this in one 30-minute session?
- [ ] Is the acceptance criteria clear and measurable?
- [ ] Can I write tests before implementation?
- [ ] Is the scope bounded (1-3 files)?
- [ ] Are dependencies clear and minimal?

If "No" to any → split into smaller tasks.

---

## Task List Format: tasks.json

### Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "feature": {
      "type": "string",
      "description": "High-level feature name"
    },
    "created": {
      "type": "string",
      "format": "date-time",
      "description": "ISO timestamp when task list created"
    },
    "tasks": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "string",
            "pattern": "^task-\\d{3}$",
            "description": "Unique task ID (task-001, task-002, ...)"
          },
          "component": {
            "type": "string",
            "description": "Technical component (data-pipeline, model, training, etc.)"
          },
          "title": {
            "type": "string",
            "description": "Brief task title (action + what)"
          },
          "description": {
            "type": "string",
            "description": "Detailed explanation of what to implement"
          },
          "estimated_minutes": {
            "type": "integer",
            "minimum": 5,
            "maximum": 30,
            "description": "Estimated completion time in minutes"
          },
          "acceptance_criteria": {
            "type": "array",
            "items": {
              "type": "string"
            },
            "minItems": 2,
            "description": "Measurable pass/fail criteria"
          },
          "files_to_change": {
            "type": "array",
            "items": {
              "type": "string"
            },
            "description": "Expected files to modify/create"
          },
          "depends_on": {
            "type": "array",
            "items": {
              "type": "string",
              "pattern": "^task-\\d{3}$"
            },
            "description": "List of prerequisite task IDs"
          },
          "status": {
            "type": "string",
            "enum": ["pending", "in_progress", "complete", "blocked"],
            "description": "Current task status"
          },
          "actual_minutes": {
            "type": "integer",
            "description": "Actual time spent (filled after completion)"
          },
          "commit_hash": {
            "type": "string",
            "description": "Git commit hash when task completed"
          }
        },
        "required": [
          "id",
          "title",
          "estimated_minutes",
          "acceptance_criteria",
          "files_to_change",
          "depends_on",
          "status"
        ]
      }
    }
  },
  "required": ["feature", "tasks"]
}
```

### Example tasks.json

```json
{
  "feature": "defect-detection-pipeline",
  "created": "2026-02-05T10:00:00Z",
  "tasks": [
    {
      "id": "task-001",
      "component": "data-pipeline",
      "title": "Implement dataset class for PCB images",
      "description": "Create PyTorch Dataset that loads images and labels from directory structure. Support transforms. Handle missing files gracefully.",
      "estimated_minutes": 20,
      "acceptance_criteria": [
        "Dataset __len__ returns correct count",
        "Dataset __getitem__ returns (image_tensor, label)",
        "Image shape is (3, H, W) after loading",
        "Labels are valid integers",
        "pytest tests/test_dataset.py passes with 100% coverage"
      ],
      "files_to_change": [
        "src/data/dataset.py",
        "tests/test_dataset.py"
      ],
      "depends_on": [],
      "status": "pending",
      "notes": "Reference pattern from CLAUDE.md: 'Safe Dataset Implementation'"
    },
    {
      "id": "task-002",
      "component": "data-pipeline",
      "title": "Implement stratified split preventing leakage",
      "description": "Split by board_id (not image_id) to prevent same board in train and val. Stratify by defect presence to maintain class balance.",
      "estimated_minutes": 25,
      "acceptance_criteria": [
        "No board_id appears in multiple splits",
        "Split ratios are 70/15/15 ±2%",
        "Defect ratio preserved in each split",
        "Reproducible with seed=42",
        "pytest tests/test_split.py passes"
      ],
      "files_to_change": [
        "src/data/split.py",
        "tests/test_split.py"
      ],
      "depends_on": ["task-001"],
      "status": "pending",
      "notes": "Avoid mistake from CLAUDE.md: 'Data Leakage in Group Split'"
    }
  ]
}
```

---

## Execution Workflow

### Session Start

```bash
# 1. Review task list
cat tasks.json | jq '.tasks[] | select(.status == "pending" and (.depends_on | all(. as $dep | any($dep == .tasks[].id and .tasks[].status == "complete"))))'

# 2. Select next task (first unblocked pending task)
TASK_ID=$(cat tasks.json | jq -r '.tasks[] | select(.status == "pending" and (.depends_on | length == 0 or all(. as $dep | $dep | IN(.tasks[] | select(.status == "complete") | .id)))) | .id' | head -1)

# 3. Mark task in-progress
jq --arg id "$TASK_ID" '(.tasks[] | select(.id == $id) | .status) = "in_progress"' tasks.json > tasks.tmp && mv tasks.tmp tasks.json

# 4. Read relevant CLAUDE.md patterns
echo "Reviewing CLAUDE.md for relevant patterns..."
```

### Task Execution

Use **prompt-template-v2.md** with task details:

```markdown
**Task ID:** task-001
**Task Title:** Implement dataset class for PCB images

**Precise request:**
"Execute task-001 following the atomic task loop protocol. Apply 'Safe Dataset Implementation' pattern from CLAUDE.md. Implement with tests, validate completely, and capture learnings."
```

### Task Validation

```bash
# Run validation commands from acceptance criteria
pytest tests/test_dataset.py -v --cov=src/data/dataset.py --cov-report=term-missing

# Check all acceptance criteria
# - [ ] Dataset __len__ returns correct count → PASSED
# - [ ] Dataset __getitem__ returns (image_tensor, label) → PASSED
# - [ ] Image shape is (3, H, W) → PASSED
# - [ ] Labels are valid integers → PASSED
# - [ ] 100% coverage → PASSED
```

### Task Completion

```bash
# 1. Commit
git add src/data/dataset.py tests/test_dataset.py
git commit -m "feat(task-001): implement dataset class for PCB images

- PyTorch Dataset loads images from directory structure
- Handles transforms and missing files gracefully
- 100% test coverage with edge cases

Closes task-001"

# 2. Update tasks.json
COMMIT_HASH=$(git rev-parse HEAD)
jq --arg id "task-001" --arg hash "$COMMIT_HASH" --argjson minutes 18 '
  (.tasks[] | select(.id == $id) | .status) = "complete" |
  (.tasks[] | select(.id == $id) | .commit_hash) = $hash |
  (.tasks[] | select(.id == $id) | .actual_minutes) = $minutes
' tasks.json > tasks.tmp && mv tasks.tmp tasks.json

# 3. Update CLAUDE.md
cat >> CLAUDE.md << 'EOF'

---
## Task Completion: 2026-02-05 14:30 - task-001

**Task:** Implement dataset class for PCB images
**Status:** ✅ Passed
**Duration:** 18 minutes (estimated 20)
**Files changed:**
- `src/data/dataset.py` (+85 lines)
- `tests/test_dataset.py` (+45 lines)

**Validation results:**
```bash
$ pytest tests/test_dataset.py -v --cov=src/data/dataset.py
test_dataset_len ✓
test_dataset_getitem ✓
test_dataset_transforms ✓
test_dataset_missing_file ✓
5 passed, coverage 100%
```

**Patterns applied:**
- Safe Dataset Implementation (from CLAUDE.md)
- Error handling for missing files

**Next task:** task-002 (ready to start)
EOF

# 4. Context reset (start fresh for next task)
# Clear working memory, review CLAUDE.md again
```

### Progress Monitoring

```bash
# View task completion status
jq -r '
  .tasks |
  group_by(.status) |
  map({status: .[0].status, count: length}) |
  .[]
' tasks.json

# Output:
# {"status": "complete", "count": 3}
# {"status": "in_progress", "count": 1}
# {"status": "pending", "count": 8}
# {"status": "blocked", "count": 0}

# View estimated vs actual time
jq -r '.tasks[] | select(.status == "complete") | "\(.id): estimated \(.estimated_minutes)min, actual \(.actual_minutes)min"' tasks.json
```

---

## Best Practices

### Task Granularity

**Too Large (Split Further):**
```json
{
  "id": "task-bad",
  "title": "Build complete training pipeline",
  "estimated_minutes": 120  // ← WAY too large
}
```

**Properly Atomic:**
```json
{
  "id": "task-007",
  "title": "Implement training loop (one epoch)",
  "estimated_minutes": 25
},
{
  "id": "task-008",
  "title": "Add logging to training loop",
  "estimated_minutes": 15
},
{
  "id": "task-009",
  "title": "Add checkpointing to training loop",
  "estimated_minutes": 20
}
```

### Acceptance Criteria

**Vague (Bad):**
```json
"acceptance_criteria": [
  "Model works",
  "Code is good"
]
```

**Measurable (Good):**
```json
"acceptance_criteria": [
  "Model forward pass succeeds on batch_size=16",
  "Output shape is (16, num_classes)",
  "pytest tests/test_model.py::test_forward passes",
  "Inference latency < 50ms on sample batch"
]
```

### Dependency Management

**Circular Dependencies (Bad):**
```json
{
  "id": "task-001",
  "depends_on": ["task-002"]  // ← Circular!
},
{
  "id": "task-002",
  "depends_on": ["task-001"]
}
```

**Clean DAG (Good):**
```json
{
  "id": "task-001",
  "depends_on": []
},
{
  "id": "task-002",
  "depends_on": ["task-001"]
},
{
  "id": "task-003",
  "depends_on": ["task-001", "task-002"]
}
```

---

## Troubleshooting

### Task Taking Longer Than Estimated

**If actual > 2x estimated:**
1. **Stop execution**
2. **Analyze why:**
   - Scope creep? (adding unplanned features)
   - Underestimated complexity? (task not truly atomic)
   - Blocked on external issue? (missing data, broken tools)
3. **Action:**
   - If scope creep → revert, stick to original task
   - If underestimated → split into sub-tasks, mark current blocked
   - If blocked → mark blocked, move to next task

**Update tasks.json:**
```json
{
  "id": "task-005",
  "status": "blocked",
  "blocked_reason": "Need clarification on alpha parameter for focal loss",
  "unblock_action": "Research focal loss paper, determine alpha from class ratio"
}
```

### Task Keeps Failing Validation

**If failing validation 3+ times:**
1. Use `/debug-failure` subagent
2. Check CLAUDE.md for similar past mistakes
3. Simplify approach (might be over-engineered)
4. Consider if task is truly atomic (might need split)

**Example split:**
```json
// Original (failing repeatedly)
{
  "id": "task-010",
  "title": "Implement and optimize focal loss",
  "status": "blocked"
}

// Split into atomic sub-tasks
{
  "id": "task-010-a",
  "title": "Implement basic focal loss (no optimization)",
  "estimated_minutes": 20
},
{
  "id": "task-010-b",
  "title": "Verify focal loss gradient correctness",
  "estimated_minutes": 15,
  "depends_on": ["task-010-a"]
},
{
  "id": "task-010-c",
  "title": "Optimize focal loss with JIT compilation",
  "estimated_minutes": 25,
  "depends_on": ["task-010-b"]
}
```

### Lost Context Mid-Task

**If you forget what you're doing:**
1. Read current task from tasks.json
2. Review CLAUDE.md for recent patterns
3. Check git diff to see what's changed
4. Review acceptance criteria

```bash
# Quick context recovery
echo "Current task:"
jq '.tasks[] | select(.status == "in_progress")' tasks.json

echo "Recent CLAUDE.md updates:"
tail -50 CLAUDE.md

echo "Current changes:"
git diff
```

---

## Integration with Spec-Driven Development

### Spec → Tasks Workflow

**1. Write Spec (Spec Kit or OpenSpec)**

```markdown
# Spec: Defect Detection Pipeline

## Requirements
- SHALL detect PCB defects with mAP ≥ 0.75
- SHALL handle 1:100 class imbalance
- SHALL process 4096×4096 images in <50ms
```

**2. Break into Tasks**

For each requirement, create tasks:

```json
// Requirement: "SHALL detect defects with mAP ≥ 0.75"
// → Tasks: model architecture, loss function, training loop, validation metrics

{
  "id": "task-004",
  "title": "Implement EfficientNet backbone",
  "spec_requirement": "SHALL detect defects with mAP ≥ 0.75",
  "rationale": "EfficientNet chosen for balance of accuracy and speed"
}
```

**3. Execute Tasks in Loop**

Each task validates against spec:

```python
# In test_model.py
def test_model_meets_spec():
    """Verify model architecture supports spec requirement."""
    model = create_model()
    # Spec: SHALL process 4096×4096 images
    sample = torch.randn(1, 3, 4096, 4096)
    output = model(sample)
    assert output.shape == (1, num_classes)
```

**4. Update Spec When Tasks Complete**

```markdown
# Spec: Defect Detection Pipeline

## Requirements
- SHALL detect PCB defects with mAP ≥ 0.75
  **Status:** ✅ Validated (task-010 complete, validation mAP=0.78)
```

---

## Metrics & Continuous Improvement

### Tracking Loop Efficiency

**After every session, calculate:**

```bash
# Accuracy: Estimated vs Actual Time
jq -r '
  .tasks[] |
  select(.status == "complete") |
  {
    id,
    estimated: .estimated_minutes,
    actual: .actual_minutes,
    accuracy: (1 - ((.actual_minutes - .estimated_minutes) | fabs) / .estimated_minutes)
  }
' tasks.json

# Velocity: Tasks Completed Per Session
# Track in session notes

# Learning Rate: Patterns Added Per Task
grep -c "### \[.*\] Pattern:" CLAUDE.md
```

### Continuous Improvement Signals

**Good signals:**
- Estimation accuracy improving (actual → estimated)
- Validation pass rate increasing (fewer iterations per task)
- Pattern reuse increasing (referencing CLAUDE.md more)
- Fewer mistakes on similar tasks

**Warning signals:**
- Estimation accuracy decreasing (tasks taking 2x+ estimate)
- Same mistakes recurring (not learning from CLAUDE.md)
- Validation passing but integration failing (tasks too isolated)
- Knowledge base growing but not being referenced

**Action when warning signals:**
1. Review task granularity (maybe too large/small)
2. Improve acceptance criteria (maybe not measurable enough)
3. Better pattern documentation (maybe not clear enough)
4. More frequent CLAUDE.md review (maybe forgetting patterns)

---

## Summary: The Loop in Practice

```
Monday 10:00am — Session Start
   ↓
Review tasks.json → 12 tasks pending
   ↓
Pick task-001 → "Implement dataset class"
   ↓
Execute (18 min) → Write code + tests
   ↓
Validate → pytest passes ✓
   ↓
Commit → feat(task-001): implement dataset
   ↓
Learn → Add "Safe Dataset Pattern" to CLAUDE.md
   ↓
Reset → Clear context, fresh state
   ↓
Pick task-002 → "Implement split function"
   ↓
Execute (22 min) → Apply pattern from CLAUDE.md
   ↓
Validate → pytest passes ✓
   ↓
Commit → feat(task-002): implement split
   ↓
Learn → Add "Avoid Data Leakage Mistake" to CLAUDE.md
   ↓
... repeat 4 more times ...
   ↓
Monday 2:00pm — Session End
   ↓
Result: 6 tasks complete, 6 patterns learned, knowledge compounding
```

**Key Insight:** Each loop iteration improves BOTH:
1. **Codebase** (features built)
2. **Knowledge base** (patterns captured)

Over time, velocity accelerates as patterns accumulate.

---

**Version:** 1.0
**Complements:** CLAUDE.md v2.0, prompt-template-v2.md
**Workflow:** Feature → tasks.json → Loop (pick → implement → validate → commit → learn → reset)
