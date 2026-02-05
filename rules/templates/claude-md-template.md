# CLAUDE.md v2.1 — RAG-Optimized Self-Improving ML/CV Knowledge Base

**Purpose:** Capture project-specific patterns, mistakes, and learnings with **semantic keyword tagging** to enable RAG-powered retrieval during atomic tasks.

**Location:** Repository root (`CLAUDE.md`)
**Version Control:** Committed to git, mandatory updates after each task
**Pattern:** Supports Osmani's self-improving agent loop with **RAG enhancement**

**New in v2.1:**
- **Keyword tagging** for semantic search optimization
- **Structured metadata** for better RAG retrieval
- **Embedding-friendly format** for vector similarity
- **Quality metrics** for pattern/mistake relevance

---

## RAG Integration

### How This Knowledge Base is Used

**Traditional (v2.0):**
```
Task starts → Read CLAUDE.md manually → Apply patterns → Complete task
```

**RAG-Enhanced (v2.1):**
```
Task starts → RAG auto-queries CLAUDE.md → Top-3 patterns + mistakes → Apply → Complete
```

**RAG Configuration:**
- **Embedding model:** `sentence-transformers/all-mpnet-base-v2`
- **Vector DB:** Qdrant (local) or Chroma
- **Similarity threshold:** 0.7 (70% semantic match required)
- **Update frequency:** After each task completion + weekly full reindex

**RAG Indexing:**
- Each pattern/mistake is embedded separately
- Keywords enhance semantic similarity
- Metadata filters enable domain-specific search

---

## Self-Improving Loop Protocol

### The Atomic Task Cycle (RAG-Enhanced)

Every development session follows this loop:

```
1. PICK next atomic task from task list
2. RAG AUTO-RETRIEVES relevant patterns/mistakes from CLAUDE.md
3. IMPLEMENT the change (bounded scope, applying RAG patterns)
4. VALIDATE with automated checks
5. COMMIT if validation passes
6. UPDATE CLAUDE.md with learnings (include KEYWORDS for RAG)
7. TRIGGER RAG REINDEX (new knowledge now searchable)
8. RESET context (fresh start for next task)
9. REPEAT until feature complete
```

**Critical Rules:**
- ✅ Tasks must be **atomic** (completable in <30 min)
- ✅ Validation is **mandatory** (not optional)
- ✅ Knowledge capture happens **immediately** (not at end of session)
- ✅ **Keywords must be added** to every pattern/mistake (for RAG retrieval)
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
      "estimated_minutes": 20,
      "domain_tags": ["data", "validation", "temporal"]
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
      "estimated_minutes": 25,
      "domain_tags": ["loss", "class-imbalance", "optimization"]
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
- ✅ Task completed successfully → Add pattern **with keywords**
- ✅ Task failed validation → Add mistake **with keywords**
- ✅ Discovered workaround → Add solution pattern **with keywords**
- ✅ Integration gotcha encountered → Add warning **with keywords**
- ✅ Anti-pattern identified → Add prevention rule **with keywords**

**NOT end-of-day batch updates** — continuous learning loop requires immediate capture.

### Update Format (RAG-Optimized)

**For mistakes (immediate after task failure):**

```markdown
### [YYYY-MM-DD HH:MM] Mistake: [Task ID] - [Brief Title]

**Keywords:** [keyword1], [keyword2], [keyword3], [keyword4], [keyword5]
<!--
  Guidelines for keywords:
  - Include technical terms (e.g., "gradient", "memory leak", "CUDA")
  - Include domain tags (e.g., "training", "data-loading", "inference")
  - Include error types (e.g., "out-of-memory", "dimension-mismatch")
  - Include frameworks (e.g., "pytorch", "numpy", "opencv")
  - Use lowercase, hyphenated format
-->

**Task:** task-XXX ([link to task in tasks.json or description])
**Domain:** [data | model | training | inference | optimization | deployment]
**Severity:** [High | Medium | Low]
**Frequency:** [How often this mistake occurs: Common | Occasional | Rare]

**What went wrong:** [Specific failure - be precise]

**Why it failed:** [Root cause if known]

**Fix applied:** [Explicit correction made]

**Prevention rule:** [How to avoid this next time]

**Validation:** [Test that would have caught this]

**Related patterns:** [Links to related patterns if any]

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

**RAG Retrieval Stats:**
- Times retrieved: [Auto-populated by RAG system]
- Average similarity: [Auto-populated by RAG system]
- Last retrieved: [Auto-populated by RAG system]
```

**For successful patterns (after task passes validation):**

```markdown
### [YYYY-MM-DD HH:MM] Pattern: [Task ID] - [Pattern Name]

**Keywords:** [keyword1], [keyword2], [keyword3], [keyword4], [keyword5]
<!--
  Guidelines for keywords:
  - Include use cases (e.g., "memory-optimization", "batch-processing")
  - Include techniques (e.g., "gradient-checkpointing", "mixed-precision")
  - Include goals (e.g., "speed-up", "accuracy-improvement")
  - Include constraints (e.g., "low-memory", "real-time")
  - Use lowercase, hyphenated format
-->

**Task:** task-XXX ([link to task in tasks.json or description])
**Domain:** [data | model | training | inference | optimization | deployment]
**Applicability:** [When to use this pattern - be specific]
**Prerequisites:** [What must be in place before applying]

**Context:** [When to use this pattern]

**Implementation:** [How to implement it - step by step]

**Validation:** [How to verify it works]

**Benefits:** [Why this works better than alternatives]
**Trade-offs:** [What you give up by using this pattern]

**Related patterns:** [Links to related patterns if any]
**Supersedes:** [If this replaces an older pattern, link here]

**Example:**
```python
# Pattern: Use weighted sampler for imbalanced datasets
from torch.utils.data import WeightedRandomSampler

def create_balanced_sampler(dataset, class_counts):
    """
    Create weighted sampler to balance class distribution.

    Args:
        dataset: PyTorch Dataset with .targets attribute
        class_counts: List of sample counts per class

    Returns:
        WeightedRandomSampler instance
    """
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

**Performance impact:**
- Memory: [Increase/Decrease/Neutral]
- Speed: [Faster/Slower/Neutral]
- Accuracy: [Better/Worse/Neutral]

**RAG Retrieval Stats:**
- Times retrieved: [Auto-populated by RAG system]
- Average similarity: [Auto-populated by RAG system]
- Last retrieved: [Auto-populated by RAG system]
```

### Atomic Task Completion Template

After completing each task, append:

```markdown
---
## Task Completion: [YYYY-MM-DD HH:MM] - [Task ID]

**Task:** [Task title from tasks.json]
**Status:** ✅ Passed | ❌ Failed | 🔄 Needs iteration
**Duration:** [Actual minutes spent]

**RAG Retrieval Summary:**
- Patterns retrieved: [count]
- Mistakes retrieved: [count]
- Average similarity: [0.0-1.0]
- Applied patterns: [list IDs]
- Avoided mistakes: [list IDs]

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
**Keywords added to new patterns/mistakes:** [List keywords for verification]

**RAG Feedback:**
- Retrieved patterns helpful: [Yes/Partially/No]
- If No: [Explain why + suggest keyword improvements]

**Next task:** task-002 (ready to start, RAG will auto-retrieve)

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

**Keywords for RAG:** data-leakage, augmentation, preprocessing, dvc, versioning

**Model Training:**
- [ ] Always seed RNGs (torch, numpy, random) for reproducibility
- [ ] Log full config + git commit hash with every experiment
- [ ] Use gradient checkpointing for large models (OOM prevention)
- [ ] Implement early stopping (don't overtrain)

**Keywords for RAG:** reproducibility, seeding, gradient-checkpointing, early-stopping, experiment-tracking

**Validation:**
- [ ] Overfit single batch before full training (sanity check)
- [ ] Check gradient norms (detect vanishing/exploding)
- [ ] Visualize predictions on val set (catch bugs visually)
- [ ] Compare to baseline (random, simple model)

**Keywords for RAG:** overfitting-test, gradient-norms, visualization, baseline-comparison

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

**Keywords for RAG:** pytorch, nn-module, tensor-conversion, numpy-torch

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

**Keywords for RAG:** type-hints, type-annotations, mypy, static-typing

---

## Common Mistakes & How to Avoid Them

*(Auto-populated as tasks complete — examples below with RAG-optimized keywords)*

### [2026-02-05 14:23] Mistake: task-001 - Data Leakage in Temporal Split

**Keywords:** data-leakage, temporal-split, time-series, train-test-split, shuffling, chronological-order

**Task:** Implement dataset splitting for time-series defect detection
**Domain:** data
**Severity:** High
**Frequency:** Common

**What went wrong:** Used sklearn train_test_split on time-series data, causing future data to leak into training set

**Why it failed:** train_test_split shuffles randomly, but time-series requires chronological split

**Fix applied:** Implemented temporal split by sorting by timestamp and splitting without shuffle

**Prevention rule:** For time-series data, ALWAYS split chronologically (never shuffle)

**Validation:** Added test that verifies train timestamps < val timestamps < test timestamps

**Related patterns:** None (first occurrence)

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

**RAG Retrieval Stats:**
- Times retrieved: 0 (new entry)
- Average similarity: N/A
- Last retrieved: N/A

---

## Successful Patterns

*(Auto-populated as tasks complete — examples below with RAG-optimized keywords)*

### [2026-02-05 15:01] Pattern: task-002 - Gradient Checkpointing for Large ResNets

**Keywords:** gradient-checkpointing, memory-optimization, large-models, resnet, high-resolution, memory-time-tradeoff

**Task:** Reduce memory usage for 4096×4096 input images
**Domain:** training
**Applicability:** When training large models (ResNet50+) on high-res images that cause OOM
**Prerequisites:** PyTorch 1.6+, model must be nn.Module

**Context:** When training large models (ResNet50+) on high-res images

**Implementation:** Use torch.utils.checkpoint for memory-time tradeoff
1. Import `torch.utils.checkpoint as cp`
2. Wrap forward pass blocks in `cp.checkpoint()`
3. Verify gradient correctness with finite differences

**Validation:** Monitor GPU memory with nvidia-smi, verify gradient correctness with finite differences

**Benefits:** 40% memory reduction, enables larger batch sizes
**Trade-offs:** 20% slower training (recomputation during backward pass)

**Related patterns:** None yet
**Supersedes:** N/A

**Example:**
```python
import torch.utils.checkpoint as cp

class CheckpointedResNet(nn.Module):
    def __init__(self, base_model):
        super().__init__()
        self.layer1 = base_model.layer1
        self.layer2 = base_model.layer2
        self.layer3 = base_model.layer3
        self.layer4 = base_model.layer4
        self.fc = base_model.fc

    def forward(self, x):
        # Checkpoint each layer block
        x = cp.checkpoint(self.layer1, x)
        x = cp.checkpoint(self.layer2, x)
        x = cp.checkpoint(self.layer3, x)
        x = cp.checkpoint(self.layer4, x)
        x = torch.flatten(x, 1)
        return self.fc(x)

# Validation: Check memory usage
# Before: 15.2 GB
# After: 9.1 GB (40% reduction)
```

**Performance impact:**
- Memory: -40% (9.1 GB vs 15.2 GB)
- Speed: -20% slower (recomputation overhead)
- Accuracy: Neutral (mathematically equivalent)

**Date added:** 2026-02-05

**RAG Retrieval Stats:**
- Times retrieved: 0 (new entry)
- Average similarity: N/A
- Last retrieved: N/A

---

## Validation Protocol

### Mandatory Checks (Run Before Commit)

```bash
# Full validation sequence (run in order)

# 1. Type checking
mypy src/ --strict

# 2. Linting
ruff check src/ tests/ --fix

# 3. Formatting
black src/ tests/

# 4. Unit tests
pytest tests/unit/ -v --cov=src/ --cov-report=term-missing

# 5. Integration tests (if applicable)
pytest tests/integration/ -v

# 6. Security scan
bandit -r src/
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

**Keywords:** dataset-validation, data-quality, shape-consistency, class-distribution, visualization

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

**Keywords:** model-sanity-check, overfitting-test, single-batch, gradient-flow, learning-verification

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

## RAG-Specific Sections

### Keyword Guidelines

**Effective keywords for RAG retrieval:**

✅ **Good keywords:**
- Technical terms: `gradient-checkpointing`, `focal-loss`, `mixed-precision`
- Error types: `out-of-memory`, `cuda-error`, `dimension-mismatch`
- Domains: `data-loading`, `model-training`, `inference-optimization`
- Frameworks: `pytorch`, `opencv`, `wandb`, `dvc`
- Concepts: `class-imbalance`, `data-augmentation`, `temporal-validation`

❌ **Avoid:**
- Generic terms: `code`, `function`, `bug`, `fix`
- Vague descriptors: `thing`, `stuff`, `issue`
- Non-technical: `good`, `bad`, `works`, `broken`

**Keyword format:**
- Lowercase
- Hyphenated (not underscored or camelCase)
- 2-4 words max per keyword
- 5-10 keywords per pattern/mistake

### RAG Quality Metrics

**Track these to improve retrieval:**

```markdown
## RAG Performance Dashboard

**Last updated:** [YYYY-MM-DD]

### Retrieval Statistics
- Total patterns: [count]
- Total mistakes: [count]
- Average keywords per entry: [count]
- Embedding model: sentence-transformers/all-mpnet-base-v2
- Last full reindex: [YYYY-MM-DD HH:MM]

### Top Retrieved Patterns (Last 30 Days)
1. [Pattern name] - Retrieved [N] times, Avg similarity [0.XX]
2. [Pattern name] - Retrieved [N] times, Avg similarity [0.XX]
3. [Pattern name] - Retrieved [N] times, Avg similarity [0.XX]

### Top Retrieved Mistakes (Last 30 Days)
1. [Mistake name] - Retrieved [N] times, Avg similarity [0.XX]
2. [Mistake name] - Retrieved [N] times, Avg similarity [0.XX]
3. [Mistake name] - Retrieved [N] times, Avg similarity [0.XX]

### Underutilized Entries (Never Retrieved)
- [Entry name] - Keywords: [list] - Action: Improve keywords or archive
- [Entry name] - Keywords: [list] - Action: Improve keywords or archive

### False Positives (High Similarity, Low Applicability)
- [Entry name] - Retrieved with [similarity] for task [X] but not applicable
- Action: Refine keywords to reduce semantic overlap

### Keyword Coverage
- Most common keywords: [list top 10]
- Underrepresented domains: [list domains with <5 entries]
```

---

## Subagents (Slash Commands)

### Standard Subagents

#### /next-task — Task Selection Agent
**Purpose:** Pick next atomic task from tasks.json
**RAG Integration:** Auto-retrieves patterns/mistakes for selected task
**Checklist:**
- [ ] Read tasks.json
- [ ] Filter tasks with status="pending"
- [ ] Select highest priority incomplete task
- [ ] Verify dependencies completed
- [ ] **Trigger RAG query for task keywords**
- [ ] Display task ID, title, acceptance criteria
- [ ] Display RAG-retrieved patterns/mistakes
- [ ] Ask for confirmation before starting
**Example:** `/next-task`

#### /validate — Validation Agent
**Purpose:** Run full validation suite for current task
**RAG Integration:** Check if retrieved patterns suggest additional validation
**Checklist:**
- [ ] Identify files changed since last commit
- [ ] Run mypy on changed modules
- [ ] Run ruff on changed files
- [ ] Run tests for changed modules
- [ ] Check coverage ≥ 80% on new code
- [ ] Verify all acceptance criteria met
- [ ] **Check if RAG-retrieved patterns specify validation steps**
- [ ] Report pass/fail with specific failures
**Example:** `/validate`

#### /complete-task — Task Completion Agent
**Purpose:** Finalize task and update knowledge base
**RAG Integration:** Capture learnings with RAG-optimized keywords
**Checklist:**
- [ ] Run /validate to ensure passing
- [ ] Update tasks.json (status → "complete")
- [ ] Append task completion entry to CLAUDE.md
- [ ] Add patterns learned (if any) **with 5-10 keywords**
- [ ] Add mistakes encountered (if any) **with 5-10 keywords**
- [ ] **Trigger RAG reindex** (make new knowledge searchable)
- [ ] Commit with message: "feat(task-XXX): <title>"
- [ ] Reset context (clear working memory)
**Example:** `/complete-task task-001`

#### /debug-failure — Debugging Agent
**Purpose:** Systematic diagnosis when task fails validation
**RAG Integration:** Query similar past mistakes for solutions
**Checklist:**
- [ ] Identify which validation check failed
- [ ] Collect error logs/stack traces
- [ ] **Query RAG for similar mistakes** with error message keywords
- [ ] Check similar past mistakes in CLAUDE.md (via RAG)
- [ ] Propose hypothesis for failure
- [ ] Suggest minimal reproducer
- [ ] Provide fix or ask clarifying questions
**Example:** `/debug-failure`

#### /learn — Learning Capture Agent
**Purpose:** Extract and formalize patterns from successful task
**RAG Integration:** Generate keywords automatically from pattern description
**Checklist:**
- [ ] Analyze what worked well
- [ ] Identify reusable pattern
- [ ] Write pattern in standard format
- [ ] **Generate 5-10 keywords for RAG** (user reviews/edits)
- [ ] Add validation example
- [ ] Append to CLAUDE.md
- [ ] **Trigger RAG reindex**
- [ ] Tag with keywords for searchability
**Example:** `/learn "gradient checkpointing pattern"`

#### /rag-search — RAG Query Agent (New)
**Purpose:** Manual RAG search when auto-retrieval insufficient
**Checklist:**
- [ ] Accept user query
- [ ] Embed query with same model as CLAUDE.md
- [ ] Search vector DB with similarity threshold
- [ ] Return top-K patterns/mistakes with similarity scores
- [ ] Display full entries
- [ ] Ask if user wants to apply any
**Example:** `/rag-search "how to handle CUDA out of memory"`

#### /rag-stats — RAG Analytics Agent (New)
**Purpose:** Display RAG performance metrics
**Checklist:**
- [ ] Show retrieval statistics (top patterns, mistakes)
- [ ] Identify underutilized entries
- [ ] Suggest keyword improvements
- [ ] List false positives (high similarity but not applicable)
- [ ] Recommend patterns to archive
**Example:** `/rag-stats`

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
- [ ] **RAG index updated** (if CLAUDE.md changed outside session)
- [ ] Validation commands verified working

**RAG Status:**
- Total patterns indexed: [count]
- Total mistakes indexed: [count]
- Last reindex: [timestamp]
- Embedding model: sentence-transformers/all-mpnet-base-v2

**Ready to start loop with RAG-enhanced retrieval.**
```

### Atomic Task Loop Template (RAG-Enhanced)

```markdown
---
### Loop Iteration: [Task ID] - [HH:MM]

**1. PICK:** task-XXX selected from tasks.json

**2. RAG AUTO-RETRIEVAL:**
Retrieved patterns (similarity >0.7):
- [Pattern name] (similarity: 0.85)
- [Pattern name] (similarity: 0.78)

Retrieved mistakes (similarity >0.7):
- [Mistake name] (similarity: 0.82)
- [Mistake name] (similarity: 0.73)

**3. IMPLEMENT:**
   - Changed files: [list]
   - Key changes: [brief description]
   - Applied patterns: [list IDs]
   - Avoided mistakes: [list IDs]

**4. VALIDATE:**
```bash
$ pytest tests/test_module.py -v
... results ...
```

**5. RESULT:** ✅ Pass | ❌ Fail

**If Pass:**
- [x] Committed: `git commit -m "feat(task-XXX): <title>"`
- [x] Updated CLAUDE.md with patterns/mistakes **+ keywords**
- [x] **Triggered RAG reindex**
- [x] Updated tasks.json (status → complete)
- [x] Context reset (ready for next task)

**If Fail:**
- [ ] Analyzed failure with /debug-failure (queries RAG for similar mistakes)
- [ ] Applied fix
- [ ] Re-validated
- [ ] (Repeat until pass)

**Next:** task-XXX+1 (RAG will auto-retrieve for new task)
---
```

### Session End Template

```markdown
## Session End: [Feature Name] — [HH:MM]

**Tasks completed:** [task-001 ✓, task-002 ✓]
**Tasks remaining:** [task-003, task-004]
**Patterns added:** [count] **with RAG keywords**
**Mistakes captured:** [count] **with RAG keywords**

**RAG Performance This Session:**
- Patterns retrieved: [count]
- Mistakes retrieved: [count]
- Average similarity: [0.0-1.0]
- Helpful retrievals: [count/total]
- False positives: [count]

**Next session starts with:** task-003 (RAG ready)

**Learnings:**
- [Key insight 1]
- [Key insight 2]

**RAG Improvements Needed:**
- [e.g., "Add more keywords to pattern-XXX for better retrieval"]
- [e.g., "Lower similarity threshold for data-loading domain"]

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
- `~/policies/ai-workflow-policy.md` — Spec-driven development, MCP servers, **RAG integration**

**Key mappings:**
- Task artifacts → `~/dev/devruns/<project>/task-XXX/`
- Model checkpoints → `~/dev/models/<project>/`
- Datasets → `~/datasets/` (immutable, DVC-tracked)
- Validation logs → Committed to git in `validation-logs/`
- **RAG index → `~/.cache/rag/<project>/` (embeddings, vector DB)**

---

## Maintenance Rules

### Automatic Maintenance (Per Loop)
- Update tasks.json after every task completion
- Append to CLAUDE.md after every task (never batch)
- **Add keywords to every new pattern/mistake**
- **Trigger RAG reindex after CLAUDE.md update**
- Commit CLAUDE.md changes with task commits

### Periodic Maintenance (Weekly)
- **Monday:** Review last week's patterns, consolidate similar ones
- **Wednesday:** Run `/rag-stats` to check retrieval quality
- **Friday:** Archive completed tasks.json to `archive/tasks-YYYY-MM-DD.json`
- **Sunday:** Full RAG reindex + cleanup underutilized entries

### Monthly Maintenance
- Major cleanup — remove outdated patterns, update examples
- Improve keywords on frequently-retrieved but low-applicability entries
- Archive patterns older than 6 months to `CLAUDE_ARCHIVE.md`
- Regenerate embeddings if embedding model updated

### Archive Policy
When CLAUDE.md exceeds 2000 lines:
1. Move patterns older than 6 months to `CLAUDE_ARCHIVE.md`
2. Keep only high-frequency patterns (retrieved >5 times)
3. Link to archive at top of CLAUDE.md
4. **Maintain separate RAG index for archive** (searchable but lower priority)

---

## Final Mental Model

**Osmani's Loop + RAG Enhancement:**

```
Spec → Atomic Tasks → Loop Start
   ↓
Pick Task (bounded, <30min)
   ↓
RAG Auto-Retrieves Patterns/Mistakes ←─── CLAUDE.md (vector DB)
   ↓
Implement (apply RAG patterns)
   ↓
Validate (automated checks) ──────┐
   ↓                               │
Pass? ──No→ Debug (query RAG) → ──┘
   ↓ Yes
Commit (with message)
   ↓
Update CLAUDE.md (with keywords)
   ↓
RAG Reindex (new knowledge searchable)
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
4. **RAG-powered retrieval** surfaces relevant patterns automatically
5. **Keyword optimization** improves future retrievals
6. **Context reset** prevents confusion accumulation
7. **Iterative improvement** compounds over time via RAG

---

**Last updated:** [YYYY-MM-DD HH:MM]
**Maintained by:** [Your name]
**Loop iteration count:** [Total tasks completed]
**File version:** v2.1 (RAG-optimized self-improving loop)
**RAG index:** [Vector DB type, embedding model, last reindex timestamp]
