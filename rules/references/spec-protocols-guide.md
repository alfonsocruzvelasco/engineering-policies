# Comprehensive Guide to Specification Protocols for AI-Augmented Engineering

**Author**: Alfonso (ML Engineer, Robotics Perception)
**Date**: January 30, 2026
**Purpose**: Consolidated reference for production-grade specification-driven development workflows

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Model Context Protocol (MCP)](#model-context-protocol-mcp)
3. [GitHub Spec Kit](#github-spec-kit)
4. [OpenSpec](#openspec)
5. [Comparison Matrix](#comparison-matrix)
6. [Best Practices for ML/CV Engineering](#best-practices-for-mlcv-engineering)
7. [Integration Patterns](#integration-patterns)
8. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
9. [Production Checklist](#production-checklist)

---

## Executive Summary

### The Core Problem

AI coding agents are powerful but **unreliable when requirements live in chat history**. Without structured specifications, you get:
- Hallucinations that drift from requirements
- Scope creep without explicit boundaries
- Undocumented architectural decisions
- Irreproducible results

### The Solution: Spec-Driven Development (SDD)

**Specifications become executable artifacts** that both humans and AI can verify against. Instead of:

```
"Build a pedestrian detector" → [black box AI coding] → Hope it works
```

You get:

```
SPEC (source of truth) → PLAN (technical design) → TASKS (atomic units) → VERIFY → Ship
```

### Three Major Protocols

| Protocol | Focus | Best For | Key Strength |
|----------|-------|----------|--------------|
| **MCP** | Standardized AI-context integration | Tool/data connectivity | Universal AI interop |
| **Spec Kit** | 0→1 feature development | New projects/features | GitHub-native, 4-stage workflow |
| **OpenSpec** | Brownfield evolution | Existing codebases | Change proposal tracking |

---

## Model Context Protocol (MCP)

> **Comprehensive Reference:** For complete MCP ecosystem documentation (protocol architecture, MCP-UI framework, development patterns, official servers, production considerations), see `mcp-ecosystem-notes.md`.

### What It Is

**MCP is an open protocol for standardized integration between LLM applications and external data sources/tools.**

Think of it as the **Language Server Protocol for AI assistants** — a universal contract for how AI tools access context.

### Architecture

```
┌─────────────┐
│   HOST      │  ← LLM Application (Claude.ai, Cursor, etc.)
│  (Client)   │
└──────┬──────┘
       │ JSON-RPC 2.0
       │ over stdio/HTTP
┌──────┴──────┐
│   SERVER    │  ← Context Provider (MCP Server)
│  (Service)  │
└──────┬──────┘
       │
  ┌────┴─────┬────────┬─────────┐
  │Resources │ Tools  │ Prompts │
  └──────────┴────────┴─────────┘
```

### Core Concepts

#### 1. **Resources**
Context and data for AI to use:
- File contents
- Database schemas
- API documentation
- System state

Example:
```json
{
  "uri": "file:///project/README.md",
  "name": "Project README",
  "mimeType": "text/markdown"
}
```

#### 2. **Tools**
Functions AI can execute:
```json
{
  "name": "run_tests",
  "description": "Execute test suite",
  "inputSchema": {
    "type": "object",
    "properties": {
      "test_path": {"type": "string"}
    }
  }
}
```

#### 3. **Prompts**
Templated workflows:
```json
{
  "name": "review_pr",
  "description": "Review pull request",
  "arguments": [
    {"name": "pr_number", "required": true}
  ]
}
```

### MCP for ML/CV Engineers

**Critical Use Cases:**

1. **Dataset Management**
   ```typescript
   // MCP Server exposing dataset metadata
   server.resource("dataset://coco/2017/train", {
     name: "COCO 2017 Training Set",
     metadata: {
       samples: 118287,
       classes: 80,
       format: "COCO JSON"
     }
   })
   ```

2. **Model Registry Integration**
   ```typescript
   server.tool("fetch_model_weights", {
     description: "Download trained model checkpoint",
     schema: {
       model_id: "string",
       version: "string"
     }
   })
   ```

3. **Experiment Tracking**
   ```typescript
   server.resource("experiment://run-2024-01-30", {
     metrics: {mAP: 0.742, latency_ms: 38},
     hyperparams: {lr: 0.001, batch_size: 16}
   })
   ```

### Security Best Practices (Critical for Production)

**From MCP Spec Section 2.5.2:**

1. **User Consent is Mandatory**
   - Explicit approval for data access
   - Clear UI for authorization
   - No silent data transmission

2. **Tool Execution Sandboxing**
   ```python
   # WRONG - Unconstrained tool execution
   def run_command(cmd: str):
       os.system(cmd)  # ❌ Arbitrary code execution

   # RIGHT - Constrained execution
   ALLOWED_COMMANDS = {"pytest", "mypy", "black"}
   def run_command(cmd: str):
       if cmd.split()[0] not in ALLOWED_COMMANDS:
           raise SecurityError("Command not allowed")
       subprocess.run(cmd, shell=False)  # ✅ Explicit whitelist
   ```

3. **LLM Sampling Controls**
   - User approves sampling requests
   - Prompts are visible before execution
   - Results can be filtered

### MCP vs Direct API Integration

| Aspect | MCP | Direct API |
|--------|-----|-----------|
| Standardization | ✅ Universal protocol | ❌ Custom per service |
| Tool Discovery | ✅ Automatic | ❌ Manual registration |
| Type Safety | ✅ JSON Schema | ⚠️ Varies |
| Security | ✅ Built-in consent | ❌ Roll your own |

### Quick Start

```bash
# Install MCP SDK
npm install @modelcontextprotocol/sdk

# Create server (TypeScript)
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server({
  name: "ml-pipeline",
  version: "1.0.0"
});

server.setRequestHandler("resources/list", async () => ({
  resources: [{
    uri: "dataset://coco",
    name: "COCO Dataset Metadata"
  }]
}));

const transport = new StdioServerTransport();
await server.connect(transport);
```

### When to Use MCP

✅ **Use MCP when:**
- Building reusable AI tools for your organization
- Integrating with multiple AI assistants (Claude, Copilot, etc.)
- Exposing complex data sources (databases, APIs, filesystems)
- Need security and audit trails for AI actions

❌ **Don't use MCP for:**
- Simple scripts (overkill)
- Prototypes (adds complexity)
- Single-tool integrations (direct API is simpler)

---

## GitHub Spec Kit

### Philosophy

**Spec Kit transforms AI from "code generator" to "implementation partner" by making the spec the source of truth.**

Traditional: Code → Tests → Docs (afterthought)
Spec Kit: **Spec → Plan → Tasks → Verify → Code**

### The 4-Stage Workflow

```
┌──────────────────────────────────────────────────────────┐
│ STAGE 1: SPECIFY (What & Why)                            │
│ Output: .specify/specs/001-feature/spec.md               │
│ ├─ User stories                                          │
│ ├─ Acceptance criteria                                   │
│ └─ Success metrics                                       │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ STAGE 2: PLAN (How)                                      │
│ Output: .specify/specs/001-feature/plan.md               │
│ ├─ Tech stack choices                                    │
│ ├─ Architecture diagrams                                 │
│ ├─ Data model                                            │
│ └─ API contracts                                         │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ STAGE 3: TASKS (Breakdown)                               │
│ Output: .specify/specs/001-feature/tasks.md              │
│ ├─ Atomic implementation units                           │
│ ├─ Dependency ordering                                   │
│ └─ Verification checkpoints                              │
└──────────────────────────────────────────────────────────┘
                         ↓
┌──────────────────────────────────────────────────────────┐
│ STAGE 4: IMPLEMENT (Execute & Verify)                    │
│ AI agent works through tasks.md sequentially             │
│ ├─ Code generation                                       │
│ ├─ Test execution                                        │
│ └─ Acceptance validation                                 │
└──────────────────────────────────────────────────────────┘
```

### Directory Structure

```
project/
├── .specify/
│   ├── memory/
│   │   └── constitution.md      # Project principles
│   ├── specs/
│   │   └── 001-feature-name/
│   │       ├── spec.md           # Requirements
│   │       ├── plan.md           # Technical design
│   │       ├── tasks.md          # Implementation checklist
│   │       ├── data-model.md     # Schema
│   │       └── contracts/
│   │           └── api-spec.json # OpenAPI/etc
│   ├── scripts/
│   │   ├── create-new-feature.sh
│   │   └── setup-plan.sh
│   └── templates/
│       ├── spec-template.md
│       ├── plan-template.md
│       └── tasks-template.md
└── src/
    └── [your code]
```

### Constitution Pattern (Critical)

**`.specify/memory/constitution.md`** = Project DNA that AI must respect

```markdown
# Project Constitution

## Engineering Principles
1. **Testability First**: Every feature must have unit tests before PR
2. **Performance Budgets**: API responses < 200ms, UI renders < 16ms
3. **Security by Default**: No secrets in code, all inputs validated

## Architecture Constraints
- Microservices communicate via gRPC only
- PostgreSQL for transactional data, Redis for cache
- No ORM - use raw SQL with prepared statements

## Code Standards
- TypeScript strict mode mandatory
- Max function complexity: 10 cyclomatic
- Test coverage: minimum 80%

## Prohibited Patterns
- ❌ Global state
- ❌ Synchronous I/O in request handlers
- ❌ Direct database access from controllers
```

**Why This Matters:**
Without a constitution, AI will make "reasonable" decisions that violate your org standards. This doc is the **anti-hallucination firewall**.

### ML/CV Spec Example

```markdown
# Spec: Real-Time Pedestrian Detection

## Purpose
Detect pedestrians in urban traffic scenes for ADAS warning system.

## Requirements

### Requirement: Detection Accuracy
The system SHALL achieve mAP@0.5 ≥ 0.75 on the internal validation set.

#### Scenario: Nighttime detection
- **WHEN** processing images with < 10 lux illumination
- **THEN** detection recall ≥ 0.70 for pedestrians > 1m tall
- **AND** false positive rate ≤ 0.05 per frame

### Requirement: Inference Latency
The system SHALL process 1920×1080 RGB images in ≤ 40ms on RTX 4070.

#### Scenario: Batch inference
- **WHEN** batch_size = 8
- **THEN** throughput ≥ 150 fps
- **AND** GPU memory usage ≤ 6GB

## Non-Requirements
- ❌ Tracking across frames (separate feature)
- ❌ Pose estimation (out of scope)
- ❌ Real-time training (inference only)
```

### CLI Commands

```bash
# Initialize project
specify init my-ml-pipeline --ai claude

# Navigate to project
cd my-ml-pipeline

# Create constitution
/speckit.constitution Create principles for ML model development

# Create spec
/speckit.specify Build a YOLOv8 pedestrian detector with custom dataset

# Generate technical plan
/speckit.plan Use PyTorch 2.0, TensorRT for inference, COCO format annotations

# Break into tasks
/speckit.tasks

# Implement
/speckit.implement
```

### Best Practices for Spec Kit

1. **Start with Constitution**
   - Define non-negotiables before any feature work
   - Update when architectural decisions change
   - Version control this file rigorously

2. **Spec Clarity Checkpoints**
   - Run `/speckit.clarify` before planning
   - Ask AI to validate Review & Acceptance Checklist
   - Iterate until all ambiguities resolved

3. **Plan Validation**
   - Review `research.md` for tech stack accuracy
   - Cross-check against constitution
   - Ask AI: "Does this plan violate any project principles?"

4. **Task Granularity**
   - Each task = 1 file or 1 function maximum
   - Test tasks must be < 50 lines
   - Verify tasks are independently executable

---

## OpenSpec

### Philosophy

**OpenSpec solves the brownfield problem: how to evolve existing systems without chaos.**

Key Insight: **Separate current truth from proposed changes**

```
openspec/
├── specs/              ← What IS built (source of truth)
├── changes/            ← What SHOULD change (proposals)
└── changes/archive/    ← What WAS changed (history)
```

### The 3-Command Workflow

```
1. /openspec:proposal    → Draft change in changes/feature-name/
2. /openspec:apply       → Implement tasks, update code
3. /openspec:archive     → Merge approved deltas back into specs/
```

### Core Concepts

#### 1. **Specs** (Ground Truth)

```
openspec/specs/auth/spec.md
```
```markdown
# Authentication Specification

## Requirements

### Requirement: JWT Authentication
The system SHALL issue JWT tokens on successful login.

#### Scenario: Valid credentials
- **WHEN** user submits valid email + password
- **THEN** return JWT with 24h expiration
- **AND** include user_id in token payload
```

#### 2. **Changes** (Proposals)

```
openspec/changes/add-2fa/
├── proposal.md          # Why and what
├── tasks.md             # Implementation checklist
├── design.md            # Technical decisions (optional)
└── specs/
    └── auth/
        └── spec.md      # DELTA showing changes
```

**Delta Format:**

```markdown
# Auth Spec Delta

## ADDED Requirements

### Requirement: Two-Factor Authentication
The system MUST require a second factor during login.

#### Scenario: OTP verification
- **WHEN** user enters valid OTP from authenticator app
- **THEN** login succeeds and JWT is issued

## MODIFIED Requirements

### Requirement: JWT Authentication
The system SHALL issue JWT tokens on successful login **after 2FA verification**.

#### Scenario: Valid credentials
- **WHEN** user submits valid email + password
- **THEN** return OTP challenge
- **AND** do not issue JWT until OTP verified
```

#### 3. **Archive** (History)

After merging:
```
openspec/changes/archive/2026-01-30-add-2fa/
└── [same structure as active change]
```

And specs/ updated:
```diff
# openspec/specs/auth/spec.md

## Requirements

### Requirement: JWT Authentication
- The system SHALL issue JWT tokens on successful login
+ The system SHALL issue JWT tokens on successful login after 2FA verification

+ ### Requirement: Two-Factor Authentication
+ The system MUST require a second factor during login
```

### Delta Operations Reference

| Operation | When to Use | Example |
|-----------|-------------|---------|
| `ADDED` | New capability | Adding 2FA to existing auth |
| `MODIFIED` | Changed behavior | Update JWT expiration from 24h to 1h |
| `REMOVED` | Deprecated feature | Removing legacy password reset flow |
| `RENAMED` | Name change only | "User Auth" → "Identity Management" |

**Critical Rule:**
- **MODIFIED** must include the **complete** updated requirement text
- Don't paste partial deltas — the archiver replaces the entire requirement block

### CLI Commands

```bash
# List active changes
openspec list

# List all specs
openspec list --specs

# View change details
openspec show add-2fa

# Validate spec format
openspec validate add-2fa --strict

# Archive completed change (interactive)
openspec archive add-2fa

# Archive (non-interactive)
openspec archive add-2fa --yes

# Update agent instructions after tool switch
openspec update
```

### Example Workflow

```bash
# 1. Create proposal
$ openspec init  # One-time setup
$ # Ask AI: "Create OpenSpec proposal for adding role-based access control"

# AI generates:
# openspec/changes/add-rbac/
# ├── proposal.md
# ├── tasks.md
# └── specs/auth/spec.md (ADDED Requirements)

# 2. Review and refine
$ openspec show add-rbac
$ openspec validate add-rbac --strict

# Ask AI to clarify any ambiguities

# 3. Implement
$ # Ask AI: "Apply the add-rbac change"
# AI works through tasks.md sequentially

# 4. Archive
$ openspec archive add-rbac --yes
# Merges deltas into openspec/specs/auth/spec.md
# Moves change to openspec/changes/archive/2026-01-30-add-rbac/
```

### Best Practices for OpenSpec

1. **Change Naming Convention**
   - Use kebab-case: `add-feature`, `update-api`, `remove-legacy`
   - Verb-led prefixes: `add-`, `update-`, `remove-`, `refactor-`
   - Keep unique (append `-2` if collision)

2. **Spec Format Compliance**
   ```markdown
   # Correct
   ### Requirement: Feature Name
   The system SHALL do X.

   #### Scenario: Success case
   - **WHEN** condition
   - **THEN** outcome

   # Wrong
   **Scenario: Success case**  ❌ (uses bold, not header)
   - Scenario: Success case   ❌ (bullet, not header)
   ```

3. **Delta Authoring**
   - For `MODIFIED`: Copy existing requirement → Edit → Paste complete text
   - Always include at least one `#### Scenario:`
   - Use SHALL/MUST for normative requirements

4. **Validation Workflow**
   ```bash
   # Always run before sharing proposal
   openspec validate add-feature --strict

   # Debug delta parsing issues
   openspec show add-feature --json --deltas-only | jq '.deltas'
   ```

---

## Comparison Matrix

| Feature | MCP | Spec Kit | OpenSpec |
|---------|-----|----------|----------|
| **Primary Purpose** | AI tool integration | Greenfield features | Brownfield evolution |
| **Scope** | Platform-level protocol | Project workflow | Change management |
| **Learning Curve** | Medium (protocol details) | Low (guided workflow) | Low (3 commands) |
| **Best For** | Tool builders | New projects/features | Existing codebases |
| **State Management** | Stateless (per-request) | Git branch per feature | Explicit proposal tracking |
| **Change Tracking** | N/A | Implicit (Git) | Explicit (delta format) |
| **Multi-Spec Updates** | N/A | One spec per feature | Multiple specs per change |
| **Verification** | N/A (external) | `/speckit.analyze` | `openspec validate --strict` |
| **Architecture** | Client-Server (JSON-RPC) | File-based templates | File-based deltas |
| **Security Model** | User consent gates | N/A | N/A |
| **API Keys Required** | No | No | No |
| **Installation** | SDK + Server impl | `uvx specify init` | `npm i -g @fission-ai/openspec` |

### When to Use Each

```
┌─────────────────────────────────────────────────────┐
│ Building AI tools that need context?                │
│ → Use MCP to expose datasets/APIs/tools             │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│ Starting a new project or major feature (0→1)?      │
│ → Use Spec Kit for structured workflow              │
└─────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────┐
│ Evolving existing system with multiple specs (1→N)? │
│ → Use OpenSpec for explicit change tracking         │
└─────────────────────────────────────────────────────┘
```

**Can you use multiple?**
Yes! Common pattern:
1. MCP servers expose your ML datasets/models
2. Spec Kit for new model architectures
3. OpenSpec for updating existing training pipelines

---

## Best Practices for ML/CV Engineering

### 1. **Spec Format for ML Systems**

```markdown
# Model Training Specification

## Requirements

### Requirement: Training Convergence
The training process SHALL achieve validation loss < 0.15 within 50 epochs.

#### Scenario: Baseline convergence
- **WHEN** training YOLOv8-n on COCO subset (10k images)
- **THEN** validation mAP@0.5 ≥ 0.45 by epoch 30
- **AND** loss curve shows no divergence

### Requirement: Hardware Efficiency
The training process SHALL utilize ≥ 90% GPU during batch processing.

#### Scenario: Multi-GPU training
- **WHEN** using 4x RTX 4090 with DDP
- **THEN** aggregate GPU utilization ≥ 90%
- **AND** batch processing time ≤ 200ms per step
```

### 2. **Data Contracts as Specs**

```markdown
### Requirement: Input Data Schema
The model SHALL accept RGB images conforming to:

#### Scenario: Valid input
- **WHEN** image is provided as input
- **THEN** format = JPEG or PNG
- **AND** dimensions = 640×640 (±10% scaling allowed)
- **AND** color space = sRGB
- **AND** bit depth = 8 bits per channel

### Requirement: Output Format
The model SHALL output detections as:

#### Scenario: Detection output
- **WHEN** inference completes
- **THEN** return JSON array of detections
- **AND** each detection contains:
  - `class_id`: int (0-79 for COCO)
  - `confidence`: float (0.0-1.0)
  - `bbox`: [x_min, y_min, x_max, y_max] (normalized 0-1)
```

### 3. **Performance Budgets**

```markdown
### Requirement: Inference Latency Budget
The inference pipeline SHALL meet latency constraints:

| Component | Max Latency | Hardware |
|-----------|-------------|----------|
| Preprocessing | 5ms | CPU (8 cores) |
| Model forward pass | 15ms | GPU (RTX 4070) |
| NMS postprocessing | 3ms | CPU |
| **TOTAL BUDGET** | **25ms** | **Mixed** |

#### Scenario: Latency validation
- **WHEN** processing 1920×1080 RGB image
- **THEN** end-to-end latency ≤ 25ms (p95)
- **AND** jitter ≤ 5ms (p99 - p50)
```

### 4. **Experiment Reproducibility Specs**

```markdown
### Requirement: Training Reproducibility
The training process SHALL be reproducible given identical inputs.

#### Scenario: Deterministic training
- **WHEN** same:
  - Random seed (42)
  - Dataset split (train/val indices)
  - Hyperparameters (lr=0.001, batch=16)
  - Hardware (single RTX 4090)
- **THEN** final validation mAP varies by < 0.005
- **AND** loss curves match within 5% at each epoch
```

---

## Integration Patterns

### Pattern 1: MCP + Spec Kit

**Use Case:** Building a model training system with dataset access

```typescript
// MCP Server exposes datasets
server.resource("dataset://coco-2017-train", {
  name: "COCO 2017 Training",
  metadata: {
    samples: 118287,
    annotations: "COCO JSON format",
    storage: "s3://ml-datasets/coco/2017/train"
  }
})

server.tool("validate_dataset", {
  description: "Validate dataset integrity",
  schema: {
    dataset_uri: "string"
  }
})
```

Then in Spec Kit:

```markdown
# Spec: Train YOLOv8 on COCO

## Requirements

### Requirement: Dataset Validation
The training pipeline SHALL validate dataset before training.

#### Scenario: Pre-training validation
- **WHEN** training job starts
- **THEN** call MCP tool `validate_dataset("dataset://coco-2017-train")`
- **AND** halt training if validation fails
```

### Pattern 2: OpenSpec + CI/CD

**Use Case:** Deploying model updates with explicit approval

```yaml
# .github/workflows/deploy-model.yml
name: Deploy Model Update

on:
  pull_request:
    paths:
      - 'openspec/changes/*/specs/**'

jobs:
  validate-spec:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm install -g @fission-ai/openspec
      - run: openspec validate --strict

  benchmark-model:
    needs: validate-spec
    runs-on: [self-hosted, gpu]
    steps:
      - name: Run inference benchmark
        run: |
          # Extract spec requirements
          REQUIRED_MAP=$(grep "mAP@0.5" openspec/changes/*/specs/detection/spec.md | cut -d'≥' -f2)

          # Run model evaluation
          python eval.py --output metrics.json

          # Validate against spec
          python validate_metrics.py metrics.json $REQUIRED_MAP
```

### Pattern 3: Spec Kit Constitution + OpenSpec Proposals

**Use Case:** Maintaining consistency across features

```markdown
# .specify/memory/constitution.md

## Model Development Principles
1. All models MUST pass latency budget validation
2. Training convergence MUST be documented in spec
3. Dataset provenance MUST be tracked in MCP resources

---

# openspec/changes/add-night-detection/proposal.md

## Why
Current detector performs poorly in low-light conditions (recall < 0.60 at night).

## What Changes
- Add night-specific data augmentation
- Retrain model with balanced day/night samples
- Update inference preprocessing for low-light

## Compliance Check
✅ Latency budget: No change (still 25ms)
✅ Convergence: Spec includes night-specific metrics
✅ Dataset: Registered as MCP resource `dataset://coco-night-aug`
```

---

## Anti-Patterns to Avoid

### ❌ 1. Skipping Spec Validation

```bash
# WRONG - Trusting AI without validation
$ # AI creates proposal
$ # Immediately start coding  ← ❌ No validation!

# RIGHT - Always validate
$ openspec validate add-feature --strict
$ # Fix issues
$ openspec show add-feature  # Review before implementation
```

### ❌ 2. Vague Requirements

```markdown
# WRONG
### Requirement: Good Performance
The model should be fast.

# RIGHT
### Requirement: Inference Latency
The model SHALL process 1920×1080 images in ≤ 40ms on RTX 4070 (p95).

#### Scenario: Batch inference
- **WHEN** batch_size = 8
- **THEN** throughput ≥ 150 fps
```

### ❌ 3. Ignoring Constitution

```python
# Constitution says: "No global state"

# WRONG - AI violates constitution
model = load_model("yolo.pt")  # Global variable ❌

def detect(image):
    return model(image)

# RIGHT - Flagged in review
# "This violates constitution rule #3. Refactor to dependency injection."
```

### ❌ 4. Mixing Spec Layers

```markdown
# WRONG - Technical details in business spec
### Requirement: User Authentication
The system SHALL use bcrypt with cost=12 to hash passwords  ← ❌ Implementation detail

# RIGHT - Tech details in plan.md
### Requirement: User Authentication
The system SHALL securely store user credentials.

# plan.md:
Password hashing: bcrypt, cost=12, salt rounds=10
```

### ❌ 5. Skipping Clarification Phase

```bash
# WRONG
/speckit.specify Build an object detector
/speckit.plan Use PyTorch  ← ❌ Ambiguous spec!

# RIGHT
/speckit.specify Build an object detector
/speckit.clarify  ← Ask AI to identify gaps
# AI: "Which objects? Indoor/outdoor? Real-time requirement?"
# Refine spec based on answers
/speckit.plan Use PyTorch 2.0, YOLOv8, COCO classes
```

---

## Production Checklist

### Before Writing Code

- [ ] **Constitution exists** and reflects current engineering standards
- [ ] **Spec has acceptance criteria** with measurable thresholds
- [ ] **All ambiguities clarified** (ran `/speckit.clarify` or equivalent)
- [ ] **Validation passed** (`openspec validate --strict` or spec checklist reviewed)
- [ ] **Tech stack approved** (matches constitution constraints)

### During Implementation

- [ ] **Tasks are atomic** (each task = 1 file or function)
- [ ] **AI follows task order** (no skipping ahead)
- [ ] **Checkpoints validated** after each task block
- [ ] **Performance metrics tracked** (if spec defines budgets)
- [ ] **Security boundaries respected** (MCP consent gates, input validation)

### Before Merging

- [ ] **All tasks checked off** in tasks.md
- [ ] **Acceptance tests passing** (matches spec scenarios)
- [ ] **No spec drift** (implementation matches current spec version)
- [ ] **Archive complete** (for OpenSpec: `openspec archive --yes` run)
- [ ] **Documentation updated** (if constitution or shared patterns changed)

---

## Appendix: Quick Reference Tables

### Spec Format Cheat Sheet

| Element | Format | Example |
|---------|--------|---------|
| Requirement Header | `### Requirement: Name` | `### Requirement: User Login` |
| Scenario Header | `#### Scenario: Case` | `#### Scenario: Valid credentials` |
| Condition | `**WHEN**` | `**WHEN** user enters email` |
| Outcome | `**THEN**` | `**THEN** return JWT token` |
| Additional | `**AND**` | `**AND** log audit event` |
| Normative | SHALL/MUST | `The system SHALL validate...` |

### Command Quick Reference

```bash
# Spec Kit
specify init <project> --ai claude
/speckit.constitution
/speckit.specify <requirements>
/speckit.clarify
/speckit.plan <tech-stack>
/speckit.tasks
/speckit.implement

# OpenSpec
npm i -g @fission-ai/openspec
openspec init
openspec list
openspec show <change>
openspec validate <change> --strict
openspec archive <change> --yes

# MCP
npm i @modelcontextprotocol/sdk
# Implement server → Configure client → Test tools
```

---

## References

1. **MCP Specification**: https://modelcontextprotocol.io/specification/2025-06-18
2. **Spec Kit GitHub**: https://github.com/github/spec-kit
3. **OpenSpec GitHub**: https://github.com/Fission-AI/OpenSpec
4. **Spec Kit Blog Post**: https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/
5. **OpenSpec Dev.to Guide**: https://dev.to/webdeveloperhyper/how-to-make-ai-follow-your-instructions-more-for-free-openspec-2c85

---

**Last Updated**: January 30, 2026
**Maintained By**: Alfonso (@mleng_robotics)
**License**: MIT (for code examples)
