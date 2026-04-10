# Folder Organisation for ML/CV Engineers
> A production-grade, career-defining reference. Version 1.1.

---

## 0. Why This Document Exists

Folder structure is architecture made visible. A senior engineer scanning a repo can tell within 30 seconds whether the author thinks in systems or in scripts. This document defines the standards for organizing ML and computer vision projects — from research experiments to production inference pipelines — so that structure communicates intent, onboarding takes minutes, and refactors do not cascade unpredictably.

**Core principles (in priority order):**

1. **Stable boundaries** — high-change code must not live next to low-change code
2. **Responsibility per directory** — every folder has one reason to exist
3. **Discoverability** — a new engineer finds anything in under 30 seconds
4. **Reproducibility** — the folder structure is the contract between code, data, and artefacts
5. **Portfolio signal** — the structure itself should communicate production-grade thinking

---

## 1. Top-Level Layout — Universal Project Root

Every project, regardless of size, starts with this skeleton. Add directories only when the responsibility genuinely exists; never pre-create empty folders.

```
project-root/
├── src/                    # All source code — importable package
├── tests/                  # Automated tests (mirrors src/ structure)
├── configs/                # Experiment and deployment configs
├── scripts/                # One-off entrypoints, CLI tools
├── docs/                   # Architecture decisions, API docs, guides
├── data/                   # Data manifest files and small fixtures only
│   └── README.md           # Explains data location policy (never commit raw data)
├── notebooks/              # Exploratory analysis — NEVER imported by src/
├── outputs/                # Generated artefacts — gitignored
│   ├── runs/               # Training runs
│   ├── checkpoints/        # Model weights
│   └── exports/            # ONNX, TensorRT engines
├── docker/                 # Dockerfiles and compose files
├── .github/                # CI/CD workflows
├── pyproject.toml          # Build system, linting, tool config
├── requirements.txt        # Pinned production dependencies
├── requirements-dev.txt    # Dev/test dependencies
├── Makefile                # Human-readable command interface
├── README.md
└── LICENSE
```

**Directory name rules:**
- Lowercase, `snake_case` — no exceptions
- Singular for code (`src`, `test`, `script`) — industry standard
- Plural is acceptable for data containers (`configs`, `docs`, `notebooks`, `outputs`)
- Never: `utils`, `misc`, `stuff`, `temp`, `old`, `backup`, `v2`, `new`

---

## 2. `src/` — The Production Package

`src/` is a proper Python package. Everything inside is importable. Nothing experimental belongs here.

### 2.1 Small-to-Medium ML/CV Project

```
src/
└── <project_name>/
    ├── __init__.py
    ├── data/               # Dataset loading, augmentation, transforms
    │   ├── __init__.py
    │   ├── dataset.py
    │   ├── transforms.py
    │   └── collate.py
    ├── models/             # Architecture definitions
    │   ├── __init__.py
    │   ├── backbone.py
    │   ├── neck.py
    │   ├── head.py
    │   └── detector.py     # Assembles backbone + neck + head
    ├── engine/             # Training and evaluation loops
    │   ├── __init__.py
    │   ├── trainer.py
    │   ├── evaluator.py
    │   └── callbacks.py
    ├── inference/          # Inference pipeline (separate from training)
    │   ├── __init__.py
    │   ├── predictor.py
    │   ├── preprocess.py
    │   └── postprocess.py
    ├── utils/              # ONLY narrow, stable, reusable utilities
    │   ├── __init__.py
    │   ├── bbox.py         # Bounding box format conversions
    │   ├── geometry.py     # Projections, rotations
    │   ├── visualise.py    # Drawing utilities
    │   └── metrics.py      # mAP, IoU, etc.
    └── types.py            # Shared dataclasses: Detection, Track, etc.
```

**Hard rules for `src/`:**
- Every subdirectory is a Python package (`__init__.py`)
- No notebook code, no `print` statements, no hardcoded paths
- No circular imports — the dependency graph must be a DAG
- `utils/` is a last resort, not a dumping ground. If `utils/` exceeds 5 files, refactor into named modules

### 2.2 AV Perception Pipeline (Production Scale)

For perception stacks where multiple subsystems live in the same repo:

```
src/
└── perception/
    ├── __init__.py
    ├── camera/
    │   ├── __init__.py
    │   ├── detector.py         # 2D object detection
    │   ├── depth_estimator.py  # Monocular or stereo depth
    │   └── segmentor.py        # Semantic segmentation
    ├── lidar/
    │   ├── __init__.py
    │   ├── pointcloud.py       # Preprocessing, voxelisation
    │   ├── detector_3d.py      # 3D object detection (PointPillars, etc.)
    │   └── ground_removal.py
    ├── fusion/
    │   ├── __init__.py
    │   ├── bev_fusion.py       # Camera + LiDAR BEV fusion
    │   └── late_fusion.py      # Box-level fusion
    ├── tracking/
    │   ├── __init__.py
    │   ├── tracker.py          # Multi-object tracker
    │   ├── kalman_filter.py
    │   └── association.py      # Hungarian algorithm, IoU matching
    ├── calibration/
    │   ├── __init__.py
    │   ├── intrinsics.py
    │   └── extrinsics.py
    └── types.py                # Detection, Track, PointCloud, etc.
```

### 2.3 Inference-Only Package (Deployed Service)

When the repo is an inference microservice, not a training repo:

```
src/
└── <service_name>/
    ├── __init__.py
    ├── api/                # REST/gRPC endpoint handlers
    │   ├── __init__.py
    │   ├── routes.py
    │   └── schemas.py      # Input/output Pydantic models
    ├── engine/             # Inference engine wrappers
    │   ├── __init__.py
    │   ├── trt_engine.py   # TensorRT
    │   ├── onnx_engine.py  # ONNXRuntime
    │   └── torch_engine.py # PyTorch (dev fallback)
    ├── pipeline/           # Pipeline stages
    │   ├── __init__.py
    │   ├── preprocess.py
    │   └── postprocess.py
    └── types.py
```

---

## 3. `tests/` — Test Structure

Tests mirror `src/` exactly. A test for `src/<pkg>/camera/detector.py` lives at `tests/camera/test_detector.py`. Never flatten tests into a single directory.

```
tests/
├── __init__.py
├── conftest.py             # Shared fixtures (pytest)
├── unit/                   # Pure unit tests, no I/O
│   ├── camera/
│   │   └── test_detector.py
│   ├── tracking/
│   │   └── test_kalman_filter.py
│   └── test_types.py
├── integration/            # Multi-component, may use fixtures/mocks
│   ├── test_camera_pipeline.py
│   └── test_tracker_integration.py
├── benchmarks/             # Latency and throughput tests
│   ├── test_inference_throughput.py
│   └── test_preprocess_latency.py
└── fixtures/               # Test data (small, version-controlled)
    ├── frames/
    │   └── test_frame_640x480.jpg
    └── detections/
        └── sample_detections.json
```

**Rules:**
- `unit/` must not touch disk, network, or GPU
- `integration/` may use mocked sensors or small fixture datasets
- `benchmarks/` are never run in standard CI — invoked manually or in nightly CI
- `fixtures/` contains only small, deterministic test data (< 1 MB total)

---

## 4. `configs/` — Experiment and Deployment Configuration

```
configs/
├── train/
│   ├── yolov8n_coco.yaml
│   ├── yolov8s_coco.yaml
│   └── pointpillars_kitti.yaml
├── inference/
│   ├── detector_t4_fp16.yaml
│   └── detector_jetson_int8.yaml
├── datasets/
│   ├── coco.yaml
│   └── kitti.yaml
└── base/
    └── default.yaml        # Base config; all others inherit from this
```

**Rules:**
- Configs are data, not code — YAML or TOML only
- No Python logic in configs; use Hydra or simple dict-based resolution
- One config per experiment variant, named after the variant
- Never commit credentials, tokens, or absolute paths

---

## 5. `scripts/` — Entrypoints and CLI Tools

```
scripts/
├── train.py                # Training entrypoint
├── evaluate.py             # Evaluation entrypoint
├── export_onnx.py          # Model export to ONNX
├── export_trt.py           # TensorRT engine build
├── benchmark.py            # Latency / throughput benchmarking
├── visualise_predictions.py
└── prepare_dataset.py      # Data preparation / split
```

**Rules:**
- Scripts are not importable — they are entrypoints only
- A script has `if __name__ == "__main__"` at the bottom and calls into `src/`
- No business logic in scripts — all logic lives in `src/`
- Keep scripts short: parse args, call function, handle top-level errors

---

## 6. `notebooks/` — Exploratory Analysis

```
notebooks/
├── 01_data_exploration.ipynb
├── 02_augmentation_analysis.ipynb
├── 03_error_analysis.ipynb
├── 04_calibration_verification.ipynb
└── archive/                # Old notebooks (do not delete, do not import)
    └── ...
```

**Rules:**
- Notebooks are **never imported** by `src/` — no shared state between notebooks and production code
- Number them sequentially to show chronological intent
- When a notebook produces reusable code, extract it into `src/` before merging to main
- Clean outputs before committing (`nbstripout` in pre-commit hooks)
- No model training in notebooks beyond quick proof-of-concept

---

## 7. `outputs/` — Generated Artefacts (gitignored)

```
outputs/
├── runs/
│   └── yolov8n_coco_20250112_143022/
│       ├── config.yaml         # Copy of the config used
│       ├── metrics.json        # Final metrics
│       ├── events.tfevents.*   # TensorBoard logs
│       └── logs/
├── checkpoints/
│   ├── yolov8n_coco_e050.pt
│   ├── yolov8n_coco_e100.pt
│   └── yolov8n_coco_best.pt
└── exports/
    ├── yolov8n_fp16_t4.onnx
    └── yolov8n_fp16_t4.engine
```

**Rules:**
- Everything in `outputs/` is **gitignored**
- Run directories include a timestamped name and a copy of the config used — this is the reproducibility contract
- Model weights use the naming convention: `<arch>_<dataset>_<epoch or tag>.<ext>`
- Never commit `.pt`, `.onnx`, or `.engine` files to git — use DVC, S3, or HuggingFace Hub

---

## 8. `docker/` — Container Definitions

```
docker/
├── Dockerfile.train        # Training image (heavy: torch, cuda, etc.)
├── Dockerfile.inference    # Production inference image (lean: TRT, ONNX only)
├── Dockerfile.dev          # Development image (adds dev tools)
└── docker-compose.yml      # Local multi-service development
```

**Rules:**
- One Dockerfile per deployment target (training vs. inference are different images)
- Inference images must be as lean as possible — no training dependencies
- Pin all base image tags: `nvcr.io/nvidia/tensorrt:23.10-py3`, not `latest`

---

## 9. Project Types — Canonical Templates

### 9.1 Research/Prototype Repository

Optimised for iteration speed. Notebook-heavy.

```
project-root/
├── src/<project_name>/     # Core utilities and shared types only
├── experiments/            # One directory per experiment
│   ├── exp001_baseline/
│   │   ├── train.py
│   │   ├── config.yaml
│   │   └── README.md       # Hypothesis, result, conclusion
│   └── exp002_augmentation/
├── notebooks/
├── data/
├── outputs/
└── pyproject.toml
```

### 9.2 Training Repository (Pipeline to Artefact)

Optimised for repeatability and model quality tracking.

```
project-root/
├── src/<project_name>/
│   ├── data/
│   ├── models/
│   └── engine/
├── tests/
├── configs/
├── scripts/
│   ├── train.py
│   ├── evaluate.py
│   └── export_onnx.py
├── outputs/
└── docker/
    └── Dockerfile.train
```

### 9.3 Inference Service (Production Deployment)

Optimised for reliability, latency, and operability.

```
project-root/
├── src/<service_name>/
│   ├── api/
│   ├── engine/
│   ├── pipeline/
│   └── types.py
├── tests/
│   ├── unit/
│   ├── integration/
│   └── benchmarks/
├── configs/
│   └── inference/
├── scripts/
│   ├── benchmark.py
│   └── export_trt.py
├── docker/
│   └── Dockerfile.inference
└── .github/
    └── workflows/
        ├── ci.yml
        └── benchmark.yml
```

### 9.4 Monorepo (Multi-Component AV Stack)

Used when camera, LiDAR, fusion, and tracking are co-developed.

```
project-root/
├── services/
│   ├── perception/         # Camera + LiDAR perception
│   ├── tracking/           # Multi-object tracking
│   └── fusion/             # Sensor fusion
├── libs/                   # Shared code used by multiple services
│   ├── types/              # Shared Detection, Track, etc.
│   ├── calibration/        # Camera/LiDAR calibration utilities
│   └── metrics/            # Shared evaluation metrics
├── tools/                  # Development tools, not production
│   ├── visualiser/
│   └── dataset_tools/
├── configs/
├── docker/
└── docs/
    └── adr/                # Architecture Decision Records
```

---

## 10. Specific Directory Contracts

### 10.1 The `utils/` Problem

`utils/` is a **code smell** when it grows beyond 3–5 tightly related functions. The correct response is to name the responsibility.

```
# BAD — utils/ grows without bound
utils/
├── utils.py         # 2,000-line file
├── helpers.py       # equally bad
└── common.py        # same

# GOOD — named responsibilities
utils/
├── bbox.py          # bounding box math only
├── geometry.py      # projective geometry only
├── visualise.py     # drawing / display only
└── metrics.py       # evaluation metrics only
```

If a single `utils/` file exceeds 200 lines, it needs to be split. The split is the feature.

### 10.2 `data/` Directory Policy

Raw data is **never** committed to git. The `data/` directory contains only:

```
data/
├── README.md               # WHERE data lives (S3 bucket, DVC remote, etc.)
├── download.sh             # Script to pull data from authoritative source
└── fixtures/               # Tiny test fixtures only (< 1 MB total)
    └── sample_frame.jpg
```

For large-scale datasets, use DVC (`dvc.yaml`) to version data manifests.

### 10.3 `docs/` Structure

```
docs/
├── architecture.md         # System design, component diagram
├── setup.md                # Getting started
├── training.md             # How to run a training job
├── deployment.md           # How to deploy inference
├── api.md                  # Public API reference
└── adr/                    # Architecture Decision Records
    ├── 001_use_trt_for_inference.md
    └── 002_bev_representation_choice.md
```

Architecture Decision Records (ADRs) are the most underused tool in ML engineering portfolios. They signal systems thinking.

---

## 11. `db/` — Database Migrations and Schema

Present only in repos that own a database schema. Not all ML/CV repos need this directory — add it only when the project manages its own PostgreSQL schema (experiment tracking, annotation stores, feature stores, inference logging).

```
db/
├── migrations/             # Alembic migration scripts (version-controlled)
│   ├── env.py
│   ├── script.py.mako
│   └── versions/
│       ├── 0001_create_experiments_table.py
│       ├── 0002_add_run_metadata.py
│       └── 0003_create_detections_table.py
├── schema/                 # Source-of-truth schema definitions
│   ├── experiments.sql     # DDL for experiments table
│   ├── runs.sql            # DDL for training runs
│   ├── detections.sql      # DDL for inference results
│   └── feature_store.sql   # DDL for feature vectors (if applicable)
├── seeds/                  # Test/development seed data
│   └── test_experiments.sql
└── README.md               # Connection policy, migration runbook
```

**Rules:**
- Schema lives in `db/schema/` as DDL — it is the authoritative source, not ORM models
- Migrations are append-only and numbered sequentially — never modify a committed migration
- No application secrets in `db/` — connection strings live in `.env` only
- Seeds are for development and testing only — never run against production
- `db/README.md` must document: where the database lives, how to run migrations, rollback procedure

**Directory naming for database-related code inside `src/`:**

```
src/<project_name>/
├── db/                     # Database access layer
│   ├── __init__.py
│   ├── connection.py       # Connection pool management
│   ├── repositories/       # One repository class per domain entity
│   │   ├── __init__.py
│   │   ├── experiment_repository.py
│   │   ├── run_repository.py
│   │   └── detection_repository.py
│   └── models.py           # SQLAlchemy ORM models (if used)
```

---

## 12. `api/` — API Layer (Inference Services)

Present only in repos that expose an HTTP or gRPC interface. Applies to inference microservices and model-serving repos.

```
src/<service_name>/
├── api/
│   ├── __init__.py
│   ├── v1/                 # Versioned API — always version from day one
│   │   ├── __init__.py
│   │   ├── routes/
│   │   │   ├── __init__.py
│   │   │   ├── detection.py        # /v1/detect endpoint handlers
│   │   │   ├── health.py           # /v1/health, /v1/ready
│   │   │   └── metrics.py          # /v1/metrics (Prometheus)
│   │   └── schemas/
│   │       ├── __init__.py
│   │       ├── detection_request.py    # Input Pydantic models
│   │       ├── detection_response.py   # Output Pydantic models
│   │       └── error.py               # Error response models
│   ├── middleware/
│   │   ├── __init__.py
│   │   ├── auth.py             # API key / JWT validation
│   │   ├── rate_limit.py       # Request rate limiting
│   │   └── request_logger.py   # Structured request logging
│   └── app.py                  # FastAPI/Flask application factory
```

**Rules:**
- Always version the API from day one (`v1/`) — retrofitting versions is painful
- Request and response schemas live in `schemas/` as Pydantic models — never raw dicts
- Health and readiness endpoints are mandatory (`/health`, `/ready`) — required for Kubernetes probes
- Middleware is separated from route handlers — no auth logic in route functions
- No business logic in route handlers — handlers call into `src/<service_name>/pipeline/`

**gRPC services (when applicable):**

```
src/<service_name>/
├── api/
│   ├── proto/              # Protobuf definitions (source of truth)
│   │   └── detection.proto
│   ├── generated/          # Auto-generated gRPC stubs (do not edit)
│   │   ├── detection_pb2.py
│   │   └── detection_pb2_grpc.py
│   └── grpc_server.py      # gRPC server setup
```

**Rules for gRPC:**
- `.proto` files are the source of truth — generated files are never edited manually
- Generated files go in `generated/` — clearly separated from authored code
- Proto files are versioned with the repo — breaking changes require a new package version

---

## 13. Naming Directories — The Full Rule Set

| Rule | Rationale |
|------|-----------|
| Lowercase `snake_case` | Consistent across OS, git, Python imports |
| Singular for code dirs (`model`, `test`) | Mirrors Python convention (`models` module = `models/`) |
| Short and meaningful | Reduces cognitive load, improves tab-completion |
| No version numbers in directory names | Use git tags |
| No dates in directory names | Use git commits |
| No `old`, `backup`, `archive` in main branch | Delete or branch |
| No more than 3 levels deep for source code | Deep nesting = coupling; flatten and name |
| `__pycache__`, `.pytest_cache`, `outputs/` in `.gitignore` | Never commit generated artefacts |

---

## 14. `.gitignore` — The Minimum Set

```gitignore
# Python
__pycache__/
*.pyc
*.pyo
.eggs/
dist/
build/
*.egg-info/

# ML artefacts — use DVC or object storage instead
outputs/
*.pt
*.pth
*.onnx
*.engine
*.trt
*.pkl

# Notebooks
.ipynb_checkpoints/

# Data
data/raw/
data/processed/

# Environment
.env
.venv/
venv/

# IDE
.vscode/
.idea/
*.swp

# Testing
.pytest_cache/
.coverage
htmlcov/

# Database
db/seeds/*.sql   # if seeds contain sensitive data
*.db
*.sqlite
```

---

## 15. The Makefile Interface

The `Makefile` at project root is the single command interface. A senior engineer should be able to operate the entire project from `make` commands without reading source code.

```makefile
.PHONY: install test lint train export benchmark db-migrate db-rollback

install:
	pip install -e ".[dev]"

test:
	pytest tests/unit/ -v

test-integration:
	pytest tests/integration/ -v

lint:
	ruff check src/ tests/
	mypy src/

train:
	python scripts/train.py --config configs/train/yolov8n_coco.yaml

evaluate:
	python scripts/evaluate.py --config configs/train/yolov8n_coco.yaml --checkpoint outputs/checkpoints/best.pt

export-onnx:
	python scripts/export_onnx.py --checkpoint outputs/checkpoints/best.pt

benchmark:
	python scripts/benchmark.py --engine outputs/exports/model_fp16_t4.engine

db-migrate:
	alembic upgrade head

db-rollback:
	alembic downgrade -1
```

---

## 16. Anti-Patterns — What to Never Do

### Flat structure

```
# BAD — everything at the top level
project/
├── detector.py
├── tracker.py
├── train.py
├── utils.py
├── helpers.py
├── dataset.py
├── model.py
└── config.py
```

A flat structure signals a script, not a system. It does not survive growth.

### Chronological directories

```
# BAD — dates or versions as directory names
experiments/
├── 2024_03_01_baseline/
├── 2024_03_05_aug/
└── 2024_03_final_v2_REAL_FINAL/
```

Use git commits and tags for history. Use named configs for variants.

### Nested `utils/`

```
# BAD — utils inside utils
src/
└── utils/
    └── utils/
        └── common_utils.py
```

### Training code mixed with inference code

```
# BAD
src/
├── model.py      # Contains both training loops and TRT export logic
└── detector.py   # Calls PyTorch, also calls TensorRT
```

Training and inference have different dependencies, different lifecycles, different deployment targets. They belong in separate modules.

### Notebooks importing from notebooks

```python
# BAD — in notebook 02
from notebook_01 import prepare_data  # This will break
```

If code is shared between notebooks, it belongs in `src/`.

### Database migrations mixed with application code

```
# BAD — migrations inside src/
src/
└── migrations/
    └── 0001_add_table.py   # Not importable, not a package
```

Migrations live in `db/migrations/`, not inside the Python package.

### API schemas as raw dicts

```python
# BAD — undocumented contract
@app.post("/detect")
def detect(request: dict) -> dict:
    return {"boxes": [...]}

# GOOD — explicit contract
@app.post("/v1/detect")
def detect(request: DetectionRequest) -> DetectionResponse:
    ...
```

---

## 17. Quick-Reference Card

### Top-level directories
`src/` → production code
`tests/` → mirrors src/
`configs/` → YAML only, no logic
`scripts/` → entrypoints, call into src/
`notebooks/` → exploration, never imported
`outputs/` → gitignored artefacts
`docker/` → one Dockerfile per target
`docs/` → ADRs, guides
`db/` → migrations + schema (when repo owns a DB)
`api/` → HTTP/gRPC layer lives inside src/<service>/api/

### Depth rule
Source code: max 3 levels deep. If you need a 4th level, you need a new package, not a subdirectory.

### The portfolio signal test
> **Can a senior AV/robotics engineer clone this repo, run `make test`, understand the architecture from the folder structure alone, and not find a single `utils.py` containing 2,000 lines?**
>
> If not — refactor before pushing.
