# Naming Policy for ML/CV Engineers
> A production-grade, career-defining reference. Version 1.1.

---

## 0. Why This Document Exists

A name is a compressed specification. When it fails, it costs time in code review, introduces bugs, and signals to senior engineers that the author does not yet think in systems. This document encodes the standards that separate portfolio code from prototype code — specifically in Python, C++, and CUDA/PyTorch-heavy ML and computer vision work, including the database and API layers that production CV systems require.

**Priority order when rules conflict:**

1. Correctness — a name must not mislead
2. Comprehension speed — minimize mental parsing time
3. Change tolerance — survives refactors and scope growth
4. Searchability — grep-able, discussion-friendly
5. Consistency — one pattern per concept, always

---

## 1. Cognitive Framework — Feitelson's Three-Step Model

All naming decisions flow through this pipeline. Most bad names fail at Step 1 or Step 2, never reaching Step 3.

### Step 1 — Select Concepts: What is it?

Encode **business/domain intent**, not storage mechanics.

```python
# BAD — encodes storage
data_list: list
array_float: np.ndarray
flag: bool

# GOOD — encodes purpose
detection_batch: list[Detection]
depth_map: np.ndarray          # float32, HxW, meters
is_keyframe: bool
```

**ML/CV-specific**: the most common Step 1 failure is naming tensors after their type or shape instead of their semantic role.

```python
# BAD
x: torch.Tensor
feat: torch.Tensor

# GOOD
rgb_frame: torch.Tensor        # (B, 3, H, W) uint8
point_cloud: torch.Tensor      # (N, 3) float32, camera frame
bev_features: torch.Tensor     # (B, C, H, W) bird's-eye view
```

### Step 2 — Choose Words: How do I describe it?

One term per concept. Establish and honour a **ubiquitous language** for the domain.

```python
# BAD — synonyms for the same operation scattered across the codebase
def fetch_frame():    ...
def get_frame():      ...
def retrieve_frame(): ...
def load_frame():     ...

# GOOD — one canonical verb, used consistently
def read_frame():     ...      # disk/stream I/O — always read_*
def fetch_detections(): ...    # network I/O  — always fetch_*
def load_weights():   ...      # model artefact — always load_*
```

**Approved verb vocabulary for ML/CV work:**

| Verb | Semantics |
|------|-----------|
| `read_` | disk or stream I/O |
| `fetch_` | network or API call |
| `load_` | deserialise model artefacts into memory |
| `build_` | construct a complex object from parts |
| `create_` | instantiate a new object |
| `compute_` | CPU-only numeric operation |
| `run_` / `infer_` | forward pass through a model |
| `postprocess_` | decode/filter model output |
| `preprocess_` | prepare data before model input |
| `convert_` | change representation (e.g. xyxy → xywh) |
| `filter_` | reduce a collection by predicate |
| `merge_` | combine two objects/collections |
| `visualise_` | render to display/file |
| `validate_` | check correctness; raises or returns bool |
| `benchmark_` | measure time/memory |
| `insert_` | write a new row to a database table |
| `update_` | modify an existing database row |
| `delete_` | remove a row from a database table |
| `query_` | read from database with filtering/joins |
| `upsert_` | insert-or-update a database row |
| `migrate_` | apply a schema migration |

### Step 3 — Construct: How do I format it?

Apply language-specific casing. For Python (the primary ML language):

```
variables, functions, methods: snake_case
classes, dataclasses, namedtuples: PascalCase
constants, global config: UPPER_SNAKE_CASE
private members: _single_leading_underscore
name-mangled internals: __double_leading_underscore
type aliases: PascalCase
```

---

## 2. Universal Golden Rules

These apply regardless of language, scope, or deadline pressure.

### G1 — Intent over type

```python
# BAD
userList, flag, sName

# GOOD
active_trackers, is_keyframe, detector_name
```

### G2 — Pronounceable names

If you cannot say it in a standup, rename it.

```python
# BAD
genymdhms
crtsfrm

# GOOD
generation_timestamp
current_stereo_frame
```

### G3 — Searchable names

Avoid names that are impossible to `grep` without false positives.

```python
# BAD
e, data, obj, tmp

# GOOD
calibration_error, lidar_scan, bev_object, temp_depth_buffer
```

### G4 — Scope-length rule

| Scope | Name length | Example |
|-------|-------------|---------|
| Loop counter, ≤ 5 lines | Single letter OK | `for i in range(n)` |
| Local variable, single function | Short but meaningful | `iou` |
| Module / class attribute | Fully descriptive | `nms_iou_threshold` |
| Public API / parameter | Maximally explicit | `confidence_threshold: float` |

### G5 — One concept, one term

Pick one. Never mix.

```python
# BAD — three names for the same concept
customer, client, user  # unless they are genuinely distinct domain entities
```

### G6 — Booleans read like questions

```python
# BAD
valid, check, done, active

# GOOD
is_valid, has_been_processed, is_keyframe, should_skip_nms
```

Allowed prefixes: `is_`, `has_`, `can_`, `should_`, `needs_`, `was_`, `will_`

**Never name a boolean in the negative:**
```python
# BAD — requires double-negation to read
is_not_valid = True
if not is_not_valid: ...

# GOOD
is_valid = False
if not is_valid: ...
```

### G7 — Units and time semantics in numeric names

This is non-negotiable in robotics and AV work. Unitless numbers are latent bugs.

```python
# BAD
timeout = 30
distance = 5.0
freq = 10

# GOOD
timeout_s = 30           # seconds
detection_range_m = 5.0  # metres
lidar_freq_hz = 10       # hertz
```

**Standard suffixes:**

| Concept | Suffix | Example |
|---------|--------|---------|
| seconds | `_s` | `latency_s` |
| milliseconds | `_ms` | `inference_time_ms` |
| microseconds | `_us` | `kernel_time_us` |
| meters | `_m` | `max_range_m` |
| pixels | `_px` | `crop_size_px` |
| degrees | `_deg` | `fov_deg` |
| radians | `_rad` | `heading_rad` |
| hertz | `_hz` | `camera_hz` |
| bytes | `_bytes` | `buffer_size_bytes` |
| megabytes | `_mb` | `vram_budget_mb` |
| timestamp (unix) | `_at` or `_ts` | `captured_at`, `frame_ts` |

---

## 3. ML/CV Domain Conventions

### 3.1 Tensors — Shape and Semantics

Always encode the semantic role, optionally annotate shape in the docstring or comment.

```python
# Shape annotation convention: (dim1, dim2, ...) after name, in comment
rgb_frame: torch.Tensor        # (B, 3, H, W) — normalised float32
depth_map: torch.Tensor        # (B, 1, H, W) — float32 metres
bev_grid: torch.Tensor         # (B, C, H_bev, W_bev)
pred_boxes: torch.Tensor       # (B, N, 4) — xyxy, float32
gt_boxes: torch.Tensor         # (M, 4) — xyxy, float32
class_logits: torch.Tensor     # (B, N, num_classes) — pre-softmax
scores: torch.Tensor           # (B, N) — post-sigmoid [0, 1]
```

**Allowed single-letter or short exceptions (domain-standard):**

```python
# Machine learning mathematics — always acceptable
X: np.ndarray     # feature matrix (N, D)
y: np.ndarray     # label vector (N,)
K: np.ndarray     # kernel / covariance matrix
B, C, H, W        # Batch, Channels, Height, Width — in shape comments only
N                 # number of samples/points
D                 # feature dimension
```

### 3.2 Bounding Boxes — Format in the Name

The format must be explicit. Silent format confusion is one of the most common CV bugs.

```python
# GOOD — format encoded
bbox_xyxy: np.ndarray          # [x1, y1, x2, y2], absolute pixels
bbox_xywh: np.ndarray          # [cx, cy, w, h], absolute pixels
bbox_xyxy_norm: np.ndarray     # [x1, y1, x2, y2], normalised [0, 1]
bbox_3d_lwh: np.ndarray        # [l, w, h] in metres
```

**Coordinate frame must be resolvable from name or nearby comment:**
```python
pos_cam: np.ndarray            # 3D position in camera frame
pos_world: np.ndarray          # 3D position in world frame
pos_lidar: np.ndarray          # 3D position in lidar frame
```

### 3.3 Model and Pipeline Components

```python
# Classes
class YOLOv8Detector:          # Architecture name is part of the class
class PointPillarEncoder:
class BEVFusionBackbone:
class ByteTracker:

# Not
class Detector:                # Too generic — which one?
class Model:                   # Meaningless
class MyModel:                 # Never in production code
```

```python
# Functions — pipeline stage prefix
def preprocess_frame(frame: np.ndarray) -> torch.Tensor: ...
def run_detection(features: torch.Tensor) -> list[Detection]: ...
def postprocess_detections(raw_output: torch.Tensor, conf_thresh: float) -> list[Detection]: ...
def convert_xyxy_to_xywh(boxes: np.ndarray) -> np.ndarray: ...
def filter_by_confidence(dets: list[Detection], threshold: float) -> list[Detection]: ...
```

### 3.4 Dataclasses and Named Types

Use dataclasses or NamedTuples for all structured outputs. Never return raw tuples from public APIs.

```python
from dataclasses import dataclass, field
from typing import Optional

@dataclass
class Detection:
    bbox_xyxy: np.ndarray          # (4,) float32
    confidence: float              # [0.0, 1.0]
    class_id: int
    class_name: str
    track_id: Optional[int] = None

@dataclass
class CameraIntrinsics:
    fx: float
    fy: float
    cx: float
    cy: float
    width_px: int
    height_px: int
    distortion_coeffs: np.ndarray  # (5,) or (8,) depending on model
```

### 3.5 Config and Hyperparameters

Use dataclasses or pydantic models. Never scatter raw floats through code.

```python
@dataclass
class DetectorConfig:
    model_path: Path
    input_size_px: tuple[int, int]     # (W, H)
    confidence_threshold: float        # [0.0, 1.0]
    nms_iou_threshold: float           # [0.0, 1.0]
    max_detections_per_frame: int
    device: str                        # "cuda:0", "cpu"
    fp16: bool = True

# NOT this
CONF = 0.5
IOU = 0.45
MAX_DET = 300
```

### 3.6 Metrics

```python
# Encode the metric name and what it measures
map_50: float              # mAP at IoU=0.50
map_50_95: float           # mAP at IoU=0.50:0.95 (COCO standard)
recall_at_100: float       # recall at 100 proposals
inference_time_ms: float
peak_vram_mb: float
fps: float                 # frames per second
```

---

## 4. Database Naming Conventions (PostgreSQL)

The authoritative SQL dialect for this codebase is **PostgreSQL**. All naming follows PostgreSQL conventions. These rules apply to DDL (table/column definitions), ORM models, repository classes, and raw SQL queries.

### 4.1 Tables — Plural Snake Case

Tables represent collections of entities. Name them in the plural.

```sql
-- GOOD
CREATE TABLE experiments (...);
CREATE TABLE training_runs (...);
CREATE TABLE detections (...);
CREATE TABLE camera_calibrations (...);
CREATE TABLE feature_vectors (...);

-- BAD
CREATE TABLE Experiment (...);    -- PascalCase
CREATE TABLE trainingRun (...);   -- camelCase
CREATE TABLE detection (...);     -- singular
CREATE TABLE tbl_detection (...); -- Hungarian prefix
```

### 4.2 Columns — Singular Snake Case

```sql
-- GOOD
id                  BIGSERIAL PRIMARY KEY,
experiment_id       BIGINT NOT NULL REFERENCES experiments(id),
run_name            TEXT NOT NULL,
model_arch          TEXT NOT NULL,       -- architecture name
dataset_name        TEXT NOT NULL,
started_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
finished_at         TIMESTAMPTZ,
map_50              FLOAT,               -- mAP at IoU=0.50
map_50_95           FLOAT,               -- mAP at IoU=0.50:0.95
inference_time_ms   FLOAT,
peak_vram_mb        FLOAT,
is_best             BOOLEAN NOT NULL DEFAULT FALSE,
config_json         JSONB,               -- full config snapshot

-- BAD
ID, experimentID, RunName, tMap50, bIsBest
```

**Column naming rules:**

| Rule | Example |
|------|---------|
| Primary key is always `id` | `id BIGSERIAL PRIMARY KEY` |
| Foreign keys follow `<table_singular>_id` | `experiment_id`, `run_id` |
| Timestamps end in `_at` | `created_at`, `started_at`, `deleted_at` |
| Booleans start with `is_` or `has_` | `is_best`, `has_converged` |
| Units encoded in column name | `inference_time_ms`, `peak_vram_mb` |
| JSON blobs end in `_json` or `_data` | `config_json`, `metadata_json` |
| Never abbreviate unless domain-standard | `map_50` ✓, `iou_thr` ✗ → `iou_threshold` |

### 4.3 Indexes — Descriptive, Not Auto-Named

```sql
-- GOOD — name encodes table + column(s) + type
CREATE INDEX idx_training_runs_experiment_id
    ON training_runs(experiment_id);

CREATE INDEX idx_detections_run_id_created_at
    ON detections(run_id, created_at DESC);

CREATE UNIQUE INDEX uq_experiments_name
    ON experiments(name);

-- BAD — opaque auto-name or positional
CREATE INDEX idx1 ON detections(run_id);
```

### 4.4 Migrations — Sequential and Descriptive

```
db/migrations/versions/
├── 0001_create_experiments_table.py
├── 0002_create_training_runs_table.py
├── 0003_add_map_50_95_to_runs.py
├── 0004_create_detections_table.py
└── 0005_add_feature_vectors_table.py
```

**Migration naming rule:** `<sequence>_<verb>_<subject>.py`

Valid verbs: `create_`, `add_`, `drop_`, `rename_`, `alter_`, `index_`

**Rules:**
- Never modify a committed migration — create a new one
- Migration names are permanent — they appear in logs and rollback histories
- One logical change per migration file

### 4.5 Repository Classes (Python)

Repository classes wrap database access. One class per domain entity.

```python
# GOOD — class name = entity + Repository
class ExperimentRepository:
    def insert_experiment(self, name: str, config: dict) -> int: ...
    def query_experiments(self, limit: int = 100) -> list[Experiment]: ...
    def fetch_experiment_by_id(self, experiment_id: int) -> Experiment: ...
    def update_experiment_status(self, experiment_id: int, status: str) -> None: ...
    def delete_experiment(self, experiment_id: int) -> None: ...

class TrainingRunRepository:
    def insert_run(self, experiment_id: int, run_name: str) -> int: ...
    def update_run_metrics(self, run_id: int, metrics: RunMetrics) -> None: ...
    def query_runs_by_experiment(self, experiment_id: int) -> list[TrainingRun]: ...
    def fetch_best_run(self, experiment_id: int) -> TrainingRun: ...

# BAD
class DB:                   # too generic
class ExperimentManager:    # "manager" is a noise word
class ExperimentHandler:    # "handler" is an HTTP concept, not DB
```

**Repository method verb rules:**

| Operation | Verb | Example |
|-----------|------|---------|
| Write new row | `insert_` | `insert_experiment()` |
| Read by ID | `fetch_` | `fetch_experiment_by_id()` |
| Read with filter | `query_` | `query_runs_by_experiment()` |
| Modify existing | `update_` | `update_run_metrics()` |
| Remove | `delete_` | `delete_experiment()` |
| Insert or update | `upsert_` | `upsert_calibration()` |

### 4.6 ORM Models (SQLAlchemy)

ORM model classes are singular PascalCase — they represent one row, not the table.

```python
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import BigInteger, Float, Text, Boolean, DateTime
from datetime import datetime

class Base(DeclarativeBase):
    pass

class Experiment(Base):
    __tablename__ = "experiments"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    name: Mapped[str] = mapped_column(Text, nullable=False, unique=True)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True))
    config_json: Mapped[dict] = mapped_column(JSONB)

class TrainingRun(Base):
    __tablename__ = "training_runs"

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    experiment_id: Mapped[int] = mapped_column(
        BigInteger, ForeignKey("experiments.id"), nullable=False
    )
    map_50: Mapped[float | None] = mapped_column(Float)
    inference_time_ms: Mapped[float | None] = mapped_column(Float)
    is_best: Mapped[bool] = mapped_column(Boolean, default=False)
```

**Rules:**
- ORM class name = singular of the table name (`Experiment` ↔ `experiments`)
- Column names in ORM match column names in DDL exactly
- Foreign key attributes follow `<entity>_id` pattern, matching the column name
- All timestamps are timezone-aware (`DateTime(timezone=True)`)

---

## 5. API Naming Conventions

Covers REST endpoints, gRPC services, Pydantic schemas, and external AI API clients. The standard applies to both inference APIs you **expose** and external APIs you **consume**.

### 5.1 REST Endpoints — Noun-Based, Versioned

```
# GOOD — resource-oriented, versioned, snake_case path segments
POST   /v1/detections                   # run inference, create detection result
GET    /v1/detections/{detection_id}    # fetch a specific result
GET    /v1/detections?run_id=42         # query results by run
DELETE /v1/detections/{detection_id}    # delete a result

POST   /v1/models/{model_id}/infer      # action on a resource
GET    /v1/health                       # health check
GET    /v1/ready                        # readiness probe (Kubernetes)
GET    /v1/metrics                      # Prometheus metrics

# BAD
POST   /runDetection                    # camelCase, verb-based
GET    /getDetections                   # verb prefix
POST   /detect                          # unversioned, ambiguous
POST   /api/v1/DoInference              # PascalCase
```

**URL naming rules:**

| Rule | Example |
|------|---------|
| Lowercase `snake_case` path segments | `/training_runs`, `/camera_calibrations` |
| Plural nouns for collections | `/detections`, `/experiments` |
| Singular noun for single resource | `/detections/{id}` |
| Always versioned (`/v1/`) | `/v1/detections` |
| Actions on resources use sub-paths | `/v1/models/{id}/infer` |
| Never verbs as top-level paths | `/run`, `/process`, `/execute` |

### 5.2 Pydantic Request/Response Schemas

```python
from pydantic import BaseModel, Field
from typing import Optional
import numpy as np

# Request schema — suffix: Request
class DetectionRequest(BaseModel):
    image_b64: str = Field(..., description="Base64-encoded BGR image")
    confidence_threshold: float = Field(
        default=0.25, ge=0.0, le=1.0,
        description="Minimum confidence score [0.0, 1.0]"
    )
    nms_iou_threshold: float = Field(
        default=0.45, ge=0.0, le=1.0,
        description="NMS IoU threshold [0.0, 1.0]"
    )
    max_detections: int = Field(
        default=300, ge=1, le=1000,
        description="Maximum number of detections to return"
    )

# Response schema — suffix: Response
class DetectionResponse(BaseModel):
    detections: list[DetectionItem]
    inference_time_ms: float
    model_version: str
    request_id: str

# Nested item schema — suffix: Item or the domain type name
class DetectionItem(BaseModel):
    bbox_xyxy: list[float]             # [x1, y1, x2, y2] absolute pixels
    confidence: float                  # [0.0, 1.0]
    class_id: int
    class_name: str
    track_id: Optional[int] = None

# Error schema — suffix: Error
class APIError(BaseModel):
    error_code: str                    # machine-readable: "INVALID_IMAGE"
    message: str                       # human-readable
    request_id: str
```

**Schema naming rules:**

| Pattern | Suffix | Example |
|---------|--------|---------|
| Incoming request body | `Request` | `DetectionRequest` |
| Outgoing response body | `Response` | `DetectionResponse` |
| Nested item in a list | `Item` or domain name | `DetectionItem` |
| Error response | `Error` | `APIError`, `ValidationError` |
| Config for the API layer | `Config` | `APIConfig` |

**Field naming rules:**
- All fields `snake_case` — Pydantic serialises to camelCase for JSON clients if needed via `model_config`
- Boolean fields follow G6 (`is_`, `has_`, `should_`)
- Numeric fields encode units (`inference_time_ms`, `peak_vram_mb`)
- Never use `data`, `info`, `result` as a field name — name the concept

### 5.3 gRPC / Protobuf

```protobuf
// Package name: reverse-DNS, lowercase
syntax = "proto3";
package perception.v1;

// Service name: PascalCase, noun + "Service"
service DetectionService {
  // RPC methods: PascalCase verb + noun
  rpc RunDetection(DetectionRequest) returns (DetectionResponse);
  rpc StreamDetections(StreamRequest) returns (stream DetectionResponse);
  rpc GetModelInfo(ModelInfoRequest) returns (ModelInfoResponse);
}

// Message names: PascalCase
message DetectionRequest {
  bytes image_data = 1;              // snake_case field names
  float confidence_threshold = 2;
  float nms_iou_threshold = 3;
  int32 max_detections = 4;
}

message DetectionResponse {
  repeated DetectionItem detections = 1;
  float inference_time_ms = 2;
  string model_version = 3;
}

message DetectionItem {
  repeated float bbox_xyxy = 1;      // [x1, y1, x2, y2]
  float confidence = 2;
  int32 class_id = 3;
  string class_name = 4;
}

// Enums: PascalCase name, UPPER_SNAKE_CASE values
enum DetectionStatus {
  DETECTION_STATUS_UNSPECIFIED = 0;
  DETECTION_STATUS_OK = 1;
  DETECTION_STATUS_LOW_CONFIDENCE = 2;
  DETECTION_STATUS_NO_DETECTIONS = 3;
}
```

**Protobuf rules:**
- Package: `<domain>.<version>` — always versioned
- Service: `<Entity>Service` — noun, not verb
- RPC methods: `<Verb><Noun>` — `RunDetection`, `GetModel`, `StreamFrames`
- Message fields: `snake_case` — proto compiler generates language-idiomatic names
- Enum values: always prefixed with the enum name to avoid namespace collisions

### 5.4 External AI API Clients

When wrapping external AI APIs (Anthropic, OpenAI, Cloudflare Workers AI), client classes follow a consistent pattern:

```python
# Client class: <Provider>Client
class AnthropicClient:
    def __init__(self, api_key: str, model: str = "claude-sonnet-4-20250514"):
        ...

    def run_inference(self, prompt: str, max_tokens: int = 1000) -> str: ...
    def run_vision_inference(self, image_b64: str, prompt: str) -> str: ...

class CloudflareWorkersAIClient:
    def __init__(self, account_id: str, api_token: str):
        ...

    def run_inference(self, model: str, inputs: dict) -> dict: ...

class OllamaClient:
    def __init__(self, base_url: str = "http://localhost:11434"):
        ...

    def run_inference(self, model: str, prompt: str) -> str: ...
    def run_vision_inference(self, model: str, image_path: str, prompt: str) -> str: ...
```

**External client naming rules:**
- Class: `<Provider>Client` — never `<Provider>API`, `<Provider>Wrapper`, `<Provider>Helper`
- The primary inference method is always `run_inference()` — consistent across all clients
- Vision variant is always `run_vision_inference()` — consistent naming enables easy swapping
- Constructor takes only auth credentials and optional defaults — no business logic
- Raises typed exceptions: `InferenceError`, `RateLimitError`, `AuthenticationError`

### 5.5 HTTP Status Codes and Error Codes

```python
# Error codes: UPPER_SNAKE_CASE, domain-prefixed
ERROR_INVALID_IMAGE = "DETECTION_INVALID_IMAGE"
ERROR_MODEL_NOT_LOADED = "DETECTION_MODEL_NOT_LOADED"
ERROR_INFERENCE_TIMEOUT = "DETECTION_INFERENCE_TIMEOUT"
ERROR_BUDGET_EXCEEDED = "BUDGET_CAP_EXCEEDED"          # spend cap hit

# NOT this
ERROR_1 = "error_1"
ERR_IMG = "err_img"
```

**Standard HTTP status mapping for ML/CV APIs:**

| Condition | Status | Error code pattern |
|-----------|--------|--------------------|
| Success | 200 | — |
| Invalid input (bad image, bad params) | 400 | `<DOMAIN>_INVALID_<FIELD>` |
| Auth failure | 401 | `AUTH_INVALID_KEY` |
| Budget cap hit | 402 | `BUDGET_CAP_EXCEEDED` |
| Model not loaded | 503 | `<DOMAIN>_MODEL_NOT_READY` |
| Inference timeout | 504 | `<DOMAIN>_INFERENCE_TIMEOUT` |

---

## 6. Anti-Patterns — The Forbidden List

### 6.1 Magic Numbers

```python
# BAD
if score > 0.45:
    detections = detections[:300]

# GOOD
NMS_IOU_THRESHOLD = 0.45
MAX_DETECTIONS = 300

if score > NMS_IOU_THRESHOLD:
    detections = detections[:MAX_DETECTIONS]
```

### 6.2 Disinformation

```python
# BAD — wrong container type in name
detection_list: dict[int, Detection]  # it's a dict!
bbox_array: list[float]               # it's a list!

# GOOD — name the concept, let type hints carry the type
detections_by_id: dict[int, Detection]
bbox_coords: list[float]
```

### 6.3 Noise Words

Words that add length but no meaning. Remove on sight.

```python
# BAD
the_frame, frame_object, data_info, variable_name, detection_data_record

# GOOD
frame, detection
```

### 6.4 Abbreviations That Are Not Universal

```python
# BAD
cfg, svc, mgr, util, proc, tmp, calc, obj, coord

# GOOD (only if universally understood in your sub-domain)
fps, iou, nms, bev, lidar, rgb, cam, bbox
```

### 6.5 Names That Lie

A name that does not match what the function does is a bug waiting to happen.

```python
# BAD — get_ implies pure/cheap; this hits a database
def get_calibration_matrix():
    return db.query("SELECT ...")

# GOOD
def fetch_calibration_matrix():
    return db.query("SELECT ...")

# BAD — validate_ should not mutate state
def validate_frame(frame):
    frame = preprocess(frame)  # side effect!
    return True

# GOOD — separate concerns
def preprocess_frame(frame): ...
def validate_frame_format(frame): ...
```

### 6.6 Hungarian Notation

Do not prefix type information into variable names. Use type hints instead.

```python
# BAD
strModelPath, intNumClasses, boolIsCuda, arrDetections

# GOOD
model_path: str
num_classes: int
use_cuda: bool
detections: list[Detection]
```

### 6.7 Unitless Database Columns

The same unit suffix rule that applies to Python variables applies to database columns.

```sql
-- BAD — unitless, ambiguous
timeout INTEGER,
distance FLOAT,
inference_time FLOAT,

-- GOOD — unit encoded
timeout_s INTEGER,
detection_range_m FLOAT,
inference_time_ms FLOAT,
```

### 6.8 Verb-Based REST Endpoints

```
# BAD — RPC-style, not resource-oriented
POST /runDetection
GET  /getExperiments
POST /processFrame

# GOOD — resource-oriented
POST /v1/detections
GET  /v1/experiments
POST /v1/frames/process   # if action is needed, sub-resource
```

---

## 7. Language-Specific Rules

### 7.1 Python (Primary ML Language — PEP 8 + Extensions)

```python
# Variables and functions — snake_case
detection_count = 0
def compute_iou(box_a: np.ndarray, box_b: np.ndarray) -> float: ...

# Classes — PascalCase
class DepthEstimator: ...
class KalmanFilter: ...

# Constants — UPPER_SNAKE_CASE
MAX_SEQUENCE_LENGTH = 512
DEFAULT_CONFIDENCE_THRESHOLD = 0.25
SUPPORTED_FORMATS = (".jpg", ".png", ".npy")

# Private members — single underscore
class Tracker:
    def __init__(self):
        self._track_buffer: list[Track] = []

    def _compute_cost_matrix(self) -> np.ndarray: ...

# Type aliases — PascalCase
BoundingBox = tuple[float, float, float, float]
FeatureMap = torch.Tensor
```

### 7.2 C++ (Inference Engines, TensorRT, CUDA Kernels)

Follow Google C++ Style Guide in ML/CV systems work.

```cpp
// Variables — snake_case
int num_detections = 0;
float* depth_buffer = nullptr;

// Functions — snake_case
void preprocess_frame(const cv::Mat& frame, float* output);
std::vector<Detection> postprocess_output(const float* raw, int count);

// Classes — PascalCase
class TRTInferenceEngine { ... };
class PointCloudProcessor { ... };

// Constants — kPascalCase (Google style) or UPPER_SNAKE_CASE
constexpr int kMaxDetections = 300;
constexpr float kNmsIouThreshold = 0.45f;

// Private members — trailing underscore
class Detector {
 private:
  TRTInferenceEngine engine_;
  int input_height_;
  int input_width_;
};

// Namespaces — lowercase
namespace perception { ... }
namespace sensor_fusion { ... }
```

### 7.3 CUDA Kernels

```cuda
// Kernel functions — snake_case with _kernel suffix
__global__ void nms_kernel(const float* boxes, int* keep, int n);
__global__ void voxelize_kernel(const float* points, float* voxels, int num_points);

// Device functions — snake_case with _device suffix or _d prefix
__device__ float compute_iou_device(const float* box_a, const float* box_b);

// Host-side launcher functions — same as regular C++ functions
void launch_nms(const float* boxes, int* keep, int n, cudaStream_t stream);
```

### 7.4 SQL (PostgreSQL)

```sql
-- Table names: plural snake_case
CREATE TABLE training_runs (...);

-- Column names: singular snake_case with unit suffixes
inference_time_ms   FLOAT,
peak_vram_mb        FLOAT,
created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),

-- Index names: idx_<table>_<columns>
CREATE INDEX idx_training_runs_experiment_id ON training_runs(experiment_id);

-- Function names: snake_case verb
CREATE FUNCTION compute_run_duration(run_id BIGINT) RETURNS INTERVAL ...
CREATE FUNCTION insert_detection_batch(detections JSONB) RETURNS void ...
```

---

## 8. Encoding Conventions

Encoding errors are silent bugs. Apply these rules consistently
across code, configs, and database connections.

### 8.1 Files and source code

All text files — Python source, Markdown, YAML, TOML, JSON,
SQL scripts, config files, logs — MUST use **UTF-8**.

```python
# GOOD — explicit encoding on every file open
with open(path, "r", encoding="utf-8") as f:
    content = f.read()

with open(path, "w", encoding="utf-8") as f:
    f.write(content)

# BAD — relies on platform default (breaks on Windows)
with open(path, "r") as f:
    content = f.read()
```

**Rule:** Never rely on the platform default encoding.
Always specify `encoding="utf-8"` explicitly.

### 8.2 PostgreSQL (authoritative SQL dialect)

```sql
-- Server and client must both use UTF-8
-- Verify with:
SHOW server_encoding;   -- should return UTF8
SHOW client_encoding;   -- should return UTF8

-- Set in connection string if needed
postgresql://user:pass@host/db?client_encoding=UTF8
```

**Rule:** PostgreSQL server encoding MUST be `UTF8`.
Client encoding MUST match. Encode this in the connection
config, not in application code.

### 8.3 Linux filenames

```bash
# GOOD — lowercase with hyphens for filesystem files
ml-cv-roadmap.csv
training-run-2026-04-05.log

# BAD — spaces and uppercase
ML CV Roadmap.csv
Training Run.log
```

**Rule:** Linux filenames use lowercase with hyphens
(`kebab-case`). No spaces. No uppercase. This applies to
data files, logs, and exported artefacts — not Python
source files, which follow `snake_case.py`.

### 8.4 Out of scope

MySQL/MariaDB (`utf8mb4`) and Oracle (`AL32UTF8`) encoding
rules are not applicable — PostgreSQL is the only approved
SQL dialect (see `sql-and-mcp-notes-ml-cv.md`).

---

## 9. File Naming

| Language | Convention | Example |
|----------|-----------|---------|
| Python modules | `snake_case.py` | `depth_estimator.py` |
| Python tests | `test_<module>.py` | `test_depth_estimator.py` |
| C++ headers | `snake_case.h` | `trt_inference_engine.h` |
| C++ source | `snake_case.cpp` | `trt_inference_engine.cpp` |
| CUDA source | `snake_case.cu` | `nms_kernel.cu` |
| Config files | `snake_case.yaml` | `detector_config.yaml` |
| Notebooks | `snake_case.ipynb` | `bbox_format_analysis.ipynb` |
| Model checkpoints | `<arch>_<dataset>_<epoch>.pt` | `yolov8n_coco_e100.pt` |
| ONNX exports | `<arch>_<precision>_<hw>.onnx` | `yolov8n_fp16_t4.onnx` |
| TRT engines | `<arch>_<precision>_<hw>.engine` | `yolov8n_fp16_t4.engine` |
| SQL migrations | `<seq>_<verb>_<subject>.py` | `0003_add_map_50_to_runs.py` |
| Proto files | `snake_case.proto` | `detection_service.proto` |
| API route files | `snake_case.py` | `detection_routes.py` |

**Never:**
- Spaces in filenames
- Uppercase in Python module names
- Version numbers like `v2_final_new.py`
- Dates in source files (`model_2024_03.py`) — use git tags

---

## 10. Automated Enforcement

### Python

```toml
# pyproject.toml — Ruff (preferred) or Pylint
[tool.ruff]
select = ["E", "W", "N", "F"]
# N: pep8-naming plugin — enforces casing conventions

[tool.pylint.basic]
good-names = "i,j,k,x,y,z,X,y,K,B,C,H,W,N,D,id,db,fp,fn"
variable-rgx = "[a-z_][a-z0-9_]{1,40}$"
```

```bash
ruff check src/
mypy src/           # type checking catches disinformation bugs
```

### C++

```yaml
# .clang-tidy
Checks: "readability-identifier-naming"
CheckOptions:
  - key: readability-identifier-naming.VariableCase
    value: lower_case
  - key: readability-identifier-naming.FunctionCase
    value: lower_case
  - key: readability-identifier-naming.ClassCase
    value: CamelCase
  - key: readability-identifier-naming.PrivateMemberSuffix
    value: "_"
```

### SQL (PostgreSQL)

```bash
# pgTAP — schema naming tests
SELECT has_table('public', 'training_runs', 'training_runs table exists');
SELECT col_is_pk('public', 'training_runs', 'id', 'id is primary key');
SELECT has_column('public', 'training_runs', 'inference_time_ms', 'unit suffix present');
```

### REST API (Spectral — OpenAPI linting)

```yaml
# .spectral.yaml
rules:
  path-casing:
    description: "Paths must be snake_case"
    given: "$.paths"
    severity: error
    then:
      function: pattern
      functionOptions:
        match: "^(/v[0-9]+)?(/[a-z][a-z0-9_]*)*(/\{[a-z][a-z0-9_]*\})?$"
  operation-id-casing:
    description: "operationId must be snake_case"
    given: "$..operationId"
    severity: warn
    then:
      function: casing
      functionOptions:
        type: snake
```

### Linter suppression policy

Suppressions must be local, minimal, and explained with a comment.

```python
# BAD — blanket suppression
# ruff: noqa

# GOOD — targeted, with reason
iou = compute_iou(a, b)  # noqa: N806 — iou is a domain-standard abbreviation
```

---

## 11. Refactoring Strategy

### When to rename

Rename when the name is:
- Misleading (does not match what it does)
- Too generic (`data`, `info`, `tmp`) in a non-trivial scope
- Inconsistent with the rest of the codebase
- Missing unit suffix in a numerics-heavy module
- A database column that lacks a unit suffix in a metrics table

### How to rename safely

1. Use IDE rename (not find-and-replace): `F2` in VS Code / PyCharm
2. One rename per commit — no logic changes in the same diff
3. Run full test suite before committing
4. For public APIs: keep a deprecated alias for one release cycle
5. For database columns: write a migration — never rename by modifying past migrations

```python
# Deprecated alias pattern
def get_bounding_boxes(...):
    """Deprecated: use compute_detections() instead."""
    import warnings
    warnings.warn("get_bounding_boxes is deprecated, use compute_detections", DeprecationWarning)
    return compute_detections(...)
```

### Rename churn signal

If you rename the same entity repeatedly, you have a responsibility boundary problem — not a naming problem. Split the module before renaming again.

---

## 12. Quick-Reference Card

### Boolean prefixes
`is_`, `has_`, `can_`, `should_`, `needs_`, `was_`, `will_`

### Tensor naming pattern
`<semantic_role>: <type>  # (shape) dtype coordinate_frame`

### Bounding box format suffixes
`_xyxy`, `_xywh`, `_xyxy_norm`, `_3d_lwh`

### Unit suffixes
`_s`, `_ms`, `_us`, `_m`, `_px`, `_deg`, `_rad`, `_hz`, `_bytes`, `_mb`

### Verb vocabulary
`read_` = disk I/O | `fetch_` = network/DB read | `load_` = deserialise |
`compute_` = CPU math | `run_` = model forward pass |
`insert_` = DB write | `update_` = DB modify | `query_` = DB read with filter |
`upsert_` = DB insert-or-update | `delete_` = DB remove

### Database
Tables: plural `snake_case` | Columns: singular `snake_case` + unit suffix |
PKs: always `id` | FKs: `<entity>_id` | Timestamps: `_at` suffix |
Indexes: `idx_<table>_<columns>` | Migrations: `<seq>_<verb>_<subject>.py`

### REST API
Paths: lowercase `snake_case`, plural nouns, always versioned (`/v1/`) |
Schemas: `Request` / `Response` / `Item` / `Error` suffixes |
HTTP errors: `<DOMAIN>_<CONDITION>` error codes

### The golden test
> **Can a senior AV perception engineer read this name cold, understand what it is, in what unit, in what frame, and not be misled about what the code does — whether it is a Python variable, a database column, or an API field?**
>
> If not — rename before committing.
