# CLAUDE.md — Self-Improving ML/CV Knowledge Base

**Purpose:** Capture project-specific patterns, mistakes, and learnings to enable continuous improvement through iterative development loops. Updated after every atomic task completion.

**Location:** Repository root (`CLAUDE.md`)
**Version Control:** Committed to git, mandatory updates after each task
**Pattern:** Supports Osmani's self-improving agent loop (task → implement → validate → commit → learn → repeat)

---

## Self-Improving Loop Protocol

### The Atomic Task Cycle

Every development session follows this loop:

```
1. PICK next atomic task from task list
2. IMPLEMENT the change (bounded scope)
3. VALIDATE with automated checks
4. COMMIT if validation passes
5. UPDATE CLAUDE.md with learnings
6. RESET context (fresh start for next task)
7. REPEAT until feature complete
```

**Critical Rules:**
- ✅ Tasks must be **atomic** (completable in <30 min)
- ✅ Validation is **mandatory** (not optional)
- ✅ Knowledge capture happens **immediately** (not at end of session)
- ✅ Context reset between tasks (no accumulated confusion)
- ✅ Each task is independently verifiable

### Task List Format

Structured tasks live in `tasks.json`:

```json
{
  "feature": "defect-detection-pipeline",
  "tasks": [
    {
      "id": "task-001",
      "title": "Implement dataset splitting with temporal validation",
      "status": "pending",
      "acceptance_criteria": [
        "Train/val/test splits prevent data leakage",
        "pytest tests/test_split.py passes",
        "Split ratios match spec (70/15/15)"
      ],
      "estimated_minutes": 20
    },
    {
      "id": "task-002",
      "title": "Add focal loss for class imbalance",
      "status": "pending",
      "acceptance_criteria": [
        "Focal loss reduces to CE when gamma=0",
        "Unit test validates gradient",
        "Integration test shows improved minority class recall"
      ],
      "estimated_minutes": 25
    }
  ]
}
```

**Task Granularity Rules:**
- Single file/module changed (or 2-3 related files max)
- Clear pass/fail criteria
- No dependencies on incomplete future tasks
- Verifiable without human judgment

---

## Update Protocol

### When to Update CLAUDE.md

**Mandatory updates (within same session, after every task):**
- ✅ Task completed successfully → Add pattern
- ✅ Task failed validation → Add mistake
- ✅ Discovered workaround → Add solution pattern
- ✅ Integration gotcha encountered → Add warning
- ✅ Anti-pattern identified → Add prevention rule

**NOT end-of-day batch updates** — continuous learning loop requires immediate capture.

### Update Format

**For mistakes (immediate after task failure):**
```markdown
### [YYYY-MM-DD HH:MM] Mistake: [Task ID] - [Brief Title]
**Task:** [Link to task in tasks.json]
**What went wrong:** [Specific failure - be precise]
**Why it failed:** [Root cause if known]
**Fix applied:** [Explicit correction made]
**Prevention rule:** [How to avoid this next time]
**Validation:** [Test that would have caught this]
**Example:**
```python
# ❌ Wrong approach that failed
def split_data(df):
    return train_test_split(df, test_size=0.3)  # ← Data leakage!

# ✅ Correct approach after fix
def split_data(df):
    # Group by patient_id to prevent leakage
    groups = df['patient_id'].unique()
    train_groups, test_groups = train_test_split(groups, test_size=0.3)
    train = df[df['patient_id'].isin(train_groups)]
    test = df[df['patient_id'].isin(test_groups)]
    return train, test
```
```

**For successful patterns (after task passes validation):**
```markdown
### [YYYY-MM-DD HH:MM] Pattern: [Task ID] - [Pattern Name]
**Task:** [Link to task in tasks.json]
**Context:** [When to use this pattern]
**Implementation:** [How to implement it]
**Validation:** [How to verify it works]
**Benefits:** [Why this works better than alternatives]
**Example:**
```python
# Pattern: Use weighted sampler for imbalanced datasets
from torch.utils.data import WeightedRandomSampler

def create_balanced_sampler(dataset, class_counts):
    weights = 1.0 / torch.tensor(class_counts, dtype=torch.float)
    sample_weights = weights[dataset.targets]
    sampler = WeightedRandomSampler(
        weights=sample_weights,
        num_samples=len(dataset),
        replacement=True
    )
    return sampler

# Validation: Verify class distribution in batches
# for batch in loader:
#     assert torch.bincount(batch['labels']).std() < threshold
```
```

### Atomic Task Completion Template

After completing each task, append:

```markdown
---
## Task Completion: [YYYY-MM-DD HH:MM] - [Task ID]

**Task:** [Task title from tasks.json]
**Status:** ✅ Passed | ❌ Failed | 🔄 Needs iteration
**Duration:** [Actual minutes spent]
**Files changed:**
- `src/data/split.py` (+45 lines)
- `tests/test_split.py` (+30 lines)

**Validation results:**
```bash
$ pytest tests/test_split.py -v
test_split_prevents_leakage ✓
test_split_ratios_correct ✓
test_split_reproducible ✓
3 passed in 1.2s
```

**Patterns added:** [Link to pattern entry above]
**Mistakes encountered:** [Link to mistake entry above, or "None"]
**Next task:** task-002 (ready to start)

---
```

---

## Project-Specific Rules

### ML/CV Domain Rules

**Data Handling:**
- [ ] Always check for data leakage in splits
- [ ] Verify augmentation doesn't leak labels (e.g., cropping around bbox)
- [ ] Log data statistics before/after preprocessing
- [ ] Use DVC for dataset versioning (never commit large files)

**Model Training:**
- [ ] Always seed RNGs (torch, numpy, random) for reproducibility
- [ ] Log full config + git commit hash with every experiment
- [ ] Use gradient checkpointing for large models (OOM prevention)
- [ ] Implement early stopping (don't overtrain)

**Validation:**
- [ ] Overfit single batch before full training (sanity check)
- [ ] Check gradient norms (detect vanishing/exploding)
- [ ] Visualize predictions on val set (catch bugs visually)
- [ ] Compare to baseline (random, simple model)

### Code Style Enforcement

**PyTorch Patterns:**
```python
# ✅ Correct: Use torch.nn.Module properly
class Model(nn.Module):
    def __init__(self, num_classes: int):
        super().__init__()
        self.backbone = models.resnet50(pretrained=True)
        self.classifier = nn.Linear(2048, num_classes)

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        features = self.backbone(x)
        return self.classifier(features)

# ❌ Wrong: Mixing numpy and torch without explicit conversion
def wrong_forward(self, x):
    np_features = np.array(x)  # ← Don't do this
    return self.classifier(np_features)
```

**Type Annotations:**
```python
# ✅ All public functions must have type hints
def train_epoch(
    model: nn.Module,
    loader: DataLoader,
    optimizer: torch.optim.Optimizer,
    device: torch.device
) -> dict[str, float]:
    ...
```

---

## Common Mistakes & How to Avoid Them

*(Auto-populated as tasks complete — examples below)*

### [2026-02-05 14:23] Mistake: task-001 - Data Leakage in Temporal Split
**Task:** Implement dataset splitting for time-series defect detection
**What went wrong:** Used sklearn train_test_split on time-series data, causing future data to leak into training set
**Why it failed:** train_test_split shuffles randomly, but time-series requires chronological split
**Fix applied:** Implemented temporal split by sorting by timestamp and splitting without shuffle
**Prevention rule:** For time-series data, ALWAYS split chronologically (never shuffle)
**Validation:** Added test that verifies train timestamps < val timestamps < test timestamps
**Example:**
```python
# ❌ Wrong: Random split leaks future into past
train, test = train_test_split(df, test_size=0.2)

# ✅ Correct: Chronological split preserves temporal order
df_sorted = df.sort_values('timestamp')
split_idx = int(len(df_sorted) * 0.8)
train = df_sorted[:split_idx]
test = df_sorted[split_idx:]
```
**Date added:** 2026-02-05

---

## Successful Patterns

*(Auto-populated as tasks complete — examples below)*

### [2026-02-05 15:01] Pattern: task-002 - Gradient Checkpointing for Large ResNets
**Task:** Reduce memory usage for 4096×4096 input images
**Context:** When training large models (ResNet50+) on high-res images
**Implementation:** Use torch.utils.checkpoint for memory-time tradeoff
**Validation:** Monitor GPU memory with nvidia-smi, verify gradient correctness with finite differences
**Benefits:** 40% memory reduction, enables larger batch sizes
**Example:**
```python
import torch.utils.checkpoint as cp

class CheckpointedResNet(nn.Module):
    def __init__(self, base_model):
        super().__init__()
        self.base_model = base_model

    def forward(self, x):
        # Checkpoint every residual block
        return cp.checkpoint_sequential(
            self.base_model,
            segments=4,  # Trade compute for memory
            input=x
        )

# Validation: Check gradient correctness
# model = CheckpointedResNet(resnet50())
# verify_gradients(model, sample_input)
```
**Date added:** 2026-02-05

---

## Verification Requirements

### Pre-Commit Validation (Mandatory)

**Every task must pass before commit:**

```bash
# 1. Type checking
mypy src/ --strict

# 2. Linting
ruff check . --fix

# 3. Formatting
black src/ tests/

# 4. Tests (specific to changed files)
pytest tests/test_<module>.py -v --cov=src/<module> --cov-report=term-missing

# 5. Security scan (if applicable)
bandit -r src/ -ll

# 6. Integration test (if applicable)
pytest tests/integration/test_<feature>.py -v
```

**Acceptance criteria:**
- [ ] All tests pass
- [ ] Coverage ≥ 80% on changed files
- [ ] Zero linting errors
- [ ] Type hints resolve
- [ ] No security warnings

**If ANY check fails → do NOT commit, fix immediately**

### Validation Patterns by Domain

#### Pattern: Dataset Validation
```python
# Always validate before training
def validate_dataset(dataset):
    assert len(dataset) > 0, "Empty dataset"

    # Check shape consistency
    shapes = [img.shape for img, _ in dataset]
    assert len(set(shapes)) == 1, "Inconsistent image shapes"

    # Check label distribution
    labels = [label for _, label in dataset]
    counts = Counter(labels)
    print(f"Class distribution: {counts}")

    # Visualize samples
    visualize_batch(dataset[:16])
```

#### Pattern: Model Sanity Check
```python
# Always overfit single batch before full training
def sanity_check_model(model, loader, device):
    model.train()
    batch = next(iter(loader))
    x, y = batch['image'].to(device), batch['label'].to(device)

    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)

    for step in range(100):
        optimizer.zero_grad()
        pred = model(x)
        loss = F.cross_entropy(pred, y)
        loss.backward()
        optimizer.step()

        if step % 10 == 0:
            print(f"Step {step}: loss={loss.item():.4f}")

    # Should reach near-zero loss
    assert loss.item() < 0.01, "Model cannot overfit single batch"
```

---

## Subagents (Slash Commands)

### Standard Subagents

#### /next-task — Task Selection Agent
**Purpose:** Pick next atomic task from tasks.json
**Checklist:**
- [ ] Read tasks.json
- [ ] Filter tasks with status="pending"
- [ ] Select highest priority incomplete task
- [ ] Verify dependencies completed
- [ ] Display task ID, title, acceptance criteria
- [ ] Ask for confirmation before starting
**Example:** `/next-task`

#### /validate — Validation Agent
**Purpose:** Run full validation suite for current task
**Checklist:**
- [ ] Identify files changed since last commit
- [ ] Run mypy on changed modules
- [ ] Run ruff on changed files
- [ ] Run tests for changed modules
- [ ] Check coverage ≥ 80% on new code
- [ ] Verify all acceptance criteria met
- [ ] Report pass/fail with specific failures
**Example:** `/validate`

#### /complete-task — Task Completion Agent
**Purpose:** Finalize task and update knowledge base
**Checklist:**
- [ ] Run /validate to ensure passing
- [ ] Update tasks.json (status → "complete")
- [ ] Append task completion entry to CLAUDE.md
- [ ] Add patterns learned (if any)
- [ ] Add mistakes encountered (if any)
- [ ] Commit with message: "feat(task-XXX): <title>"
- [ ] Reset context (clear working memory)
**Example:** `/complete-task task-001`

#### /debug-failure — Debugging Agent
**Purpose:** Systematic diagnosis when task fails validation
**Checklist:**
- [ ] Identify which validation check failed
- [ ] Collect error logs/stack traces
- [ ] Check similar past mistakes in CLAUDE.md
- [ ] Propose hypothesis for failure
- [ ] Suggest minimal reproducer
- [ ] Provide fix or ask clarifying questions
**Example:** `/debug-failure`

#### /learn — Learning Capture Agent
**Purpose:** Extract and formalize patterns from successful task
**Checklist:**
- [ ] Analyze what worked well
- [ ] Identify reusable pattern
- [ ] Write pattern in standard format
- [ ] Add validation example
- [ ] Append to CLAUDE.md
- [ ] Tag with keywords for searchability
**Example:** `/learn "gradient checkpointing pattern"`

---

## Session Workflow

### Session Start Template

```markdown
## Session: [Feature Name] — [YYYY-MM-DD]
**Feature:** [High-level feature being built]
**Tasks planned:** [task-001, task-002, task-003]
**Estimated duration:** [Total estimated minutes]
**Starting task:** task-001

### Pre-Session Checklist
- [ ] Clean working tree (git status clean)
- [ ] tasks.json updated with atomic tasks
- [ ] CLAUDE.md reviewed for relevant patterns
- [ ] Validation commands verified working

**Ready to start loop.**
```

### Atomic Task Loop Template

```markdown
---
### Loop Iteration: [Task ID] - [HH:MM]

**1. PICK:** task-XXX selected from tasks.json
**2. IMPLEMENT:**
   - Changed files: [list]
   - Key changes: [brief description]

**3. VALIDATE:**
```bash
$ pytest tests/test_module.py -v
... results ...
```

**4. RESULT:** ✅ Pass | ❌ Fail

**If Pass:**
- [x] Committed: `git commit -m "feat(task-XXX): <title>"`
- [x] Updated CLAUDE.md with patterns/mistakes
- [x] Updated tasks.json (status → complete)
- [x] Context reset (ready for next task)

**If Fail:**
- [ ] Analyzed failure with /debug-failure
- [ ] Applied fix
- [ ] Re-validated
- [ ] (Repeat until pass)

**Next:** task-XXX+1
---
```

### Session End Template

```markdown
## Session End: [Feature Name] — [HH:MM]

**Tasks completed:** [task-001 ✓, task-002 ✓]
**Tasks remaining:** [task-003, task-004]
**Patterns added:** [count]
**Mistakes captured:** [count]

**Next session starts with:** task-003

**Learnings:**
- [Key insight 1]
- [Key insight 2]

**Blockers (if any):**
- [Describe blocker + what info needed to unblock]

---
```

---

## Integration with Policies

**This CLAUDE.md must comply with:**

- `~/policies/development-environment-policy.md` — File organization, artifact boundaries
- `~/policies/ml-cv-operations-policy.md` — Experiment tracking, data versioning
- `~/policies/production-policy.md` — Code quality, testing standards
- `~/policies/ai-workflow-policy.md` — Spec-driven development, MCP servers

**Key mappings:**
- Task artifacts → `~/dev/devruns/<project>/task-XXX/`
- Model checkpoints → `~/dev/models/<project>/`
- Datasets → `~/datasets/` (immutable, DVC-tracked)
- Validation logs → Committed to git in `validation-logs/`

---

## Maintenance Rules

### Automatic Maintenance (Per Loop)
- Update tasks.json after every task completion
- Append to CLAUDE.md after every task (never batch)
- Commit CLAUDE.md changes with task commits

### Periodic Maintenance (Weekly)
- **Monday:** Review last week's patterns, consolidate similar ones
- **Friday:** Archive completed tasks.json to `archive/tasks-YYYY-MM-DD.json`
- **Monthly:** Major cleanup — remove outdated patterns, update examples

### Archive Policy
When CLAUDE.md exceeds 2000 lines:
1. Move patterns older than 6 months to `CLAUDE_ARCHIVE.md`
2. Keep only high-frequency patterns
3. Link to archive at top of CLAUDE.md

---

## Final Mental Model

**Osmani's Loop Applied to ML/CV:**

```
Spec → Atomic Tasks → Loop Start
   ↓
Pick Task (bounded, <30min)
   ↓
Implement (small change)
   ↓
Validate (automated checks) ──────┐
   ↓                               │
Pass? ──No→ Debug → Fix → ────────┘
   ↓ Yes
Commit (with message)
   ↓
Update CLAUDE.md (immediate learning)
   ↓
Reset Context (fresh state)
   ↓
Next Task? ──Yes→ Loop Start
   ↓ No
Feature Complete
```

**Key principles:**
1. **Atomic tasks** prevent scope creep
2. **Mandatory validation** prevents regressions
3. **Immediate learning capture** builds knowledge base
4. **Context reset** prevents confusion accumulation
5. **Iterative improvement** compounds over time

---

**Last updated:** [YYYY-MM-DD HH:MM]
**Maintained by:** [Your name]
**Loop iteration count:** [Total tasks completed]
**File version:** v2.0 (Osmani self-improving loop)
