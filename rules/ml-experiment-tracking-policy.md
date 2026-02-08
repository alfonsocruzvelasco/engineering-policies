# ML Experiment Tracking Policy

## Purpose
Track ML/CV experiments during learning phase to build knowledge systematically and enable reproducibility.

## Core Principle
**Track enough to learn, not so much it slows you down.**

---

## Required for Every Experiment

### 1. Experiment Log Entry
Create or update `EXPERIMENTS.md` in your project root:

```markdown
## Experiment [NUMBER] - [SHORT_NAME] - [DATE]

**Goal:** What am I trying to learn/improve?

**Setup:**
- Model: [architecture name]
- Dataset: [name and size]
- Key params: [learning_rate, batch_size, epochs, etc.]

**Results:**
- Metric: [accuracy/loss/mAP/etc.]: [value]
- Training time: [duration]

**What I learned:** [One sentence takeaway]

**Code:** [git commit hash or tag]
```

### 2. Code Snapshots
When something works:
```bash
git add .
git commit -m "exp-[NUMBER]: [what worked]"
git tag exp-[NUMBER]-[short-name]
```

### 3. Dependencies Lock
Always have `requirements.txt` or `environment.yml`:
```bash
# At project start
pip freeze > requirements.txt

# Update when you add packages
pip freeze > requirements.txt
```

---

## Project Structure (Minimal)

```
project-name/
├── EXPERIMENTS.md          # Your learning log
├── README.md               # What this project does
├── requirements.txt        # Locked dependencies
├── data/                   # Data loading and preprocessing
│   └── dataset.py
├── models/                 # Model architectures
│   └── model.py
├── train.py               # Training script
├── evaluate.py            # Evaluation script
└── notebooks/             # Exploration (optional)
    └── explore.ipynb
```

---

## Quick Start Template

### EXPERIMENTS.md Template
```markdown
# Experiment Log - [PROJECT_NAME]

## Experiment 1 - Baseline - 2026-02-08

**Goal:** Establish baseline performance

**Setup:**
- Model: ResNet18 (pretrained=False)
- Dataset: CIFAR-10 (50k train, 10k test)
- Key params: lr=0.001, batch=64, epochs=10

**Results:**
- Test accuracy: 65.3%
- Training time: 15 min

**What I learned:** Random init is hard. Try pretrained next.

**Code:** `git tag exp-1-baseline`

---

## Experiment 2 - Pretrained - 2026-02-09

**Goal:** See if pretrained weights help

**Setup:**
- Model: ResNet18 (pretrained=True)
- Dataset: CIFAR-10 (same split)
- Key params: lr=0.0001, batch=64, epochs=10

**Results:**
- Test accuracy: 89.7%
- Training time: 12 min

**What I learned:** Pretrained weights give huge boost. Lower LR needed.

**Code:** `git tag exp-2-pretrained`
```

---

## Data Documentation (Required)

In your project README.md, include:

```markdown
## Dataset

**Source:** [URL or citation]

**Size:**
- Training: [N samples]
- Validation: [N samples]
- Test: [N samples]

**Preprocessing:**
- Resize to [WxH]
- Normalization: [mean/std values]
- Augmentation: [list techniques if any]

**Split Ratios:** [e.g., 80/10/10]

**Location:** `data/[dataset-name]/`
```

---

## Tools (Choose Your Level)

### Level 1: Just Starting (You are here)
- **Experiment log:** EXPERIMENTS.md file
- **Version control:** Git tags
- **Dependencies:** requirements.txt
- **Time investment:** 2 min per experiment

### Level 2: Getting Serious (After 10+ experiments)
- **Experiment tracking:** [MLflow](https://mlflow.org/) or [Weights & Biases](https://wandb.ai/)
- **Data versioning:** [DVC](https://dvc.org/)
- **Time investment:** 5 min setup, 1 min per experiment

### Level 3: Production-Ready (When you have a job)
- Full MLOps pipeline
- Automated experiment tracking
- CI/CD integration

**Start at Level 1. Only move up when current level feels limiting.**

---

## What NOT to Track (Yet)

❌ **Don't track these until you need them:**
- Intermediate checkpoints (unless training crashes)
- Every single hyperparameter combination
- Detailed system metrics (GPU usage, etc.)
- Model artifacts for failed experiments
- Code for every minor tweak

**Why?** You'll spend more time on tracking infrastructure than learning ML/CV.

---

## Integration with Existing Workflow

### Before Starting New Experiment
```bash
# 1. Create experiment entry in EXPERIMENTS.md
# 2. Make sure dependencies are locked
pip freeze > requirements.txt
# 3. Commit current state
git add . && git commit -m "Starting exp-[N]"
```

### After Experiment Completes
```bash
# 1. Update EXPERIMENTS.md with results and learnings
# 2. Tag if it worked
git tag exp-[N]-[descriptive-name]
# 3. Commit
git add EXPERIMENTS.md && git commit -m "exp-[N] results"
```

### When Returning After Break
```bash
# 1. Read EXPERIMENTS.md to see what you tried
# 2. Checkout working experiment
git checkout exp-[N]-[name]
# 3. Reproduce results
pip install -r requirements.txt
python train.py
```

---

## Anti-Patterns to Avoid

### ❌ Perfectionism Trap
```markdown
## Bad: Over-detailed tracking
- GPU: NVIDIA RTX 3090
- CUDA: 11.8
- Driver: 525.105.17
- Batch size: 64
- Workers: 4
- Pin memory: True
- Shuffle: True
- Drop last: False
[... 50 more parameters ...]
```

```markdown
## Good: Essential tracking
- Model: ResNet50
- Dataset: ImageNet subset (10k images)
- lr=0.001, batch=64, epochs=20
- Test accuracy: 78.3%
```

### ❌ Inconsistency Trap
```markdown
## Bad: Random format each time
exp 1: tried resnet, got 85%
Experiment #2 (ResNet34): acc = 87.2%, took forever
3- vgg16: 82%
```

```markdown
## Good: Consistent format
## Experiment 1 - ResNet18 - 2026-02-08
Results: 85.0% accuracy

## Experiment 2 - ResNet34 - 2026-02-09
Results: 87.2% accuracy

## Experiment 3 - VGG16 - 2026-02-10
Results: 82.0% accuracy
```

### ❌ Tooling Trap
Spending 3 days setting up MLflow when you've only run 2 experiments.

**Rule:** Use EXPERIMENTS.md until you have 10+ experiments. Then evaluate tools.

---

## Success Criteria

You know this policy is working when:

✅ You can answer: "What did I try last week?"
✅ You can reproduce a result from 2 weeks ago
✅ You can see progress over time
✅ You're learning from failed experiments
✅ Tracking takes <5% of your experiment time

---

## When to Upgrade This Policy

Upgrade when you experience these pain points:

1. **"I have 50+ experiments and can't find anything"**
   → Add MLflow or W&B

2. **"I can't reproduce results from last month"**
   → Add data versioning (DVC)

3. **"I'm collaborating and we're overwriting each other"**
   → Add team experiment tracking system

4. **"I need to compare 20 models systematically"**
   → Add automated experiment framework

**Until then: Keep it simple.**

---

## Cursor Integration Instructions

**For Cursor AI to help you maintain this:**

1. **When starting new experiment:**
   - "Create experiment entry [N] in EXPERIMENTS.md for [model] on [dataset]"
   - Cursor will use the template format

2. **When recording results:**
   - "Update experiment [N] with results: [metrics]"
   - Cursor will fill in the results section

3. **When reviewing:**
   - "Show me all experiments with accuracy > 85%"
   - "What did I learn from experiments 5-10?"

4. **When reproducing:**
   - "Show me the setup for experiment [N]"
   - "Create requirements.txt for experiment [N]"

---

## Example: Complete First Experiment

```bash
# Starting out
mkdir my-cv-project && cd my-cv-project
git init

# Create structure
touch EXPERIMENTS.md README.md requirements.txt
mkdir -p data models

# First experiment entry (in EXPERIMENTS.md)
```

```markdown
# Experiment Log - Image Classification

## Experiment 1 - ResNet18-Baseline - 2026-02-08

**Goal:** Establish baseline on CIFAR-10

**Setup:**
- Model: ResNet18 (pretrained=False)
- Dataset: CIFAR-10 (60k images, 10 classes)
- Key params: lr=0.001, batch=64, epochs=10, optimizer=Adam

**Results:**
- Test accuracy: 65.3%
- Best val accuracy: 68.1% (epoch 8)
- Training time: 15 min on RTX 3080

**What I learned:**
Model converges but plateaus early. Need to try:
- Pretrained weights
- Learning rate scheduling
- Data augmentation

**Code:** `git tag exp-1-baseline`

**Next steps:** Try pretrained ResNet18 (exp-2)
```

```bash
# Lock dependencies
pip freeze > requirements.txt

# Commit
git add .
git commit -m "exp-1: baseline ResNet18 on CIFAR-10"
git tag exp-1-baseline
```

---

## Appendix: Recommended Experiment Numbering

**Simple sequential:** exp-1, exp-2, exp-3...

**With categories (when you have many):**
- exp-arch-1 (architecture experiments)
- exp-aug-1 (augmentation experiments)
- exp-opt-1 (optimizer experiments)

**For learning phase: Simple sequential is best.**

---

## Questions to Ask Yourself Monthly

1. Am I actually using EXPERIMENTS.md? (If no, simplify it)
2. Can I reproduce my best result? (If no, improve tracking)
3. Is tracking slowing me down? (If yes, remove detail)
4. Am I learning from failed experiments? (If no, track "what I learned" better)

**Adjust this policy based on your honest answers.**

---

## Final Reminder

**This policy exists to support your learning, not to create busywork.**

If you find yourself spending more time documenting than experimenting, you're doing it wrong.

**The goal: Build knowledge systematically while staying in flow.**

Track just enough. Build a lot.
