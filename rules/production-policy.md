# Production Engineering Policy

**Status:** Authoritative
**Last updated:** 2026-01-19
**Purpose:** Daily reference for CV/ML engineering, data systems, and tooling standards
**Authority model:** Sections 1 (Data & Storage), 2 (SQL Databases), and 8 (Git and Source Control) are authoritative policy defined in this file.
All other sections are navigation pointers; their referenced standalone policy files are authoritative.
If this file conflicts with a referenced standalone policy, the standalone policy is authoritative.

---

## 📋 Complete Table of Contents

### 🚀 Getting Started
- [How to Use This Document](#how-to-use-this-document)
- [Production Ownership and Stewardship](#production-ownership-and-stewardship)
- [Quick Reference Cards](#quick-reference-cards)
  - [QRC-1: New Python Project](#qrc-1-new-python-project-setup)
  - [QRC-2: Dataset Snapshot](#qrc-2-dataset-snapshot-creation)
  - [QRC-3: SQL Schema for CV/ML](#qrc-3-sql-schema-for-cv-ml)
  - [QRC-4: Docker Multi-Stage Build](#qrc-4-docker-multi-stage-build)
  - [QRC-5: Git Commit Template](#qrc-5-git-commit-template)
  - [QRC-6: Kubernetes Deployment](#qrc-6-kubernetes-deployment)
  - [QRC-7: Pytest Setup](#qrc-7-pytest-setup)
  - [QRC-8: React Component](#qrc-8-react-component-pattern)
  - [QRC-9: TypeScript Project](#qrc-9-typescript-project-setup)
  - [QRC-10: Kafka Patterns](#qrc-10-kafka-patterns)

### 📊 1. Data & Storage
- [1.1 Core Principles](#1-1-core-principles)
- [1.2 Storage Systems](#1-2-storage-systems)
- [1.3 Raw Data Rules](#1-3-raw-data-rules)
- [1.4 Derived Data](#1-4-derived-data-rules)
- [1.5 Immutability](#1-5-immutability-policy)
- [1.6 Dataset Snapshots](#1-6-dataset-snapshot-policy)
- [1.7 Object Identity](#1-7-object-identity)
- [1.8 Formats](#1-8-formats-policy)
- [1.9 Retention](#1-9-retention-and-lifecycle)
- [1.10 Performance](#1-10-access-and-performance)
- [1.11 What Never Goes in SQL](#1-11-what-never-goes-in-sql)
- [1.12 Exceptions](#1-12-exceptions-process)

### 🗄️ 2. SQL Databases
- [2.1 SQL in CV/ML](#2-1-sql-in-cv-ml-architectures)
- [2.2 Schema Design](#2-2-schema-design-principles)
- [2.3 Normalization](#2-3-normalization)
- [2.4 Primary Keys](#2-4-primary-keys-and-identity)
- [2.5 Foreign Keys](#2-5-foreign-keys-and-constraints)
- [2.6 Indexes](#2-6-indexes-and-performance)
- [2.7 Query Patterns](#2-7-query-patterns)
- [2.8 Transactions](#2-8-transactions-and-isolation)
- [2.9 Migrations](#2-9-migrations-and-schema-evolution)
- [2.10 Security](#2-10-security)
- [2.11 Operations](#2-11-operations)
- [2.12 Engine-Specific](#2-12-engine-specific-guidance)
  - [MySQL](#engine-specific-rules-mysql)
  - [PostgreSQL](#engine-specific-rules-postgresql)
  - [SQLite](#engine-specific-rules-sqlite)

### 🐍 3. Python
- [Python](#python)

### 📘 4. TypeScript
- [TypeScript](#nodenpmtypescript)

### ⚛️ 5. React
- [React](#nodenpmtypescript)

### 🟢 6. Node.js
- [Node.js](#nodenpmtypescript)

### 🎨 7. CSS/HTML
- [CSS/HTML](#nodenpmtypescript)

### 🔧 8. Git and Source Control
- [Git and Source Control Policy](#5-git-and-source-control-policy)
  - [Core principles](#51-core-principles)
  - [Repository setup and hygiene](#52-repository-setup-and-hygiene)
  - [Branching model](#53-branching-model)
  - [Commit discipline](#54-commit-discipline)
  - [Pull Requests](#55-pull-requests-prs)
  - [Code review standards](#56-code-review-standards)
  - [Merging strategy](#57-merging-strategy)
  - [Pre-commit hooks](#511-pre-commit-hooks-mandatory)
  - [Operational checklists](#519-operational-checklists-daily-use)

### 🐙 9. GitHub
- [GitHub](#5-git-and-source-control-policy)

**Note:** GitHub-specific policies are covered in the Git workflow section. For versioning and release processes, see [Versioning and Release Policy](versioning-and-release-policy.md).

### 🧪 10. Testing
- [Testing Policy](#7-testing-policy) — See [Testing Policy](testing-policy.md) for comprehensive testing standards

### 📝 11. Documentation
- [Documentation](#8-documentation-policy)

### 🐳 12. Docker/Podman
- See [Infrastructure Policy](infrastructure-policy.md) for Docker/Podman, Kubernetes, and Kafka standards

### ☸️ 13. Kubernetes
- See [Infrastructure Policy](infrastructure-policy.md) for Docker/Podman, Kubernetes, and Kafka standards

### 📨 14. Kafka
- See [Infrastructure Policy](infrastructure-policy.md) for Docker/Podman, Kubernetes, and Kafka standards

### 🤖 15. ML/CV Operations
- See [ML/CV Operations Policy](ml-cv-operations-policy.md) for ML/CV-specific operations
- [15.1 Model Evaluation Frameworks](#151-model-evaluation-frameworks)
- [15.2 Feature Engineering & Feature Stores](#152-feature-engineering--feature-stores)
- [15.3 Data Quality & Validation](#153-data-quality--validation)
- [15.4 Model Testing Strategies](#154-model-testing-strategies)
- [15.5 Data Pipeline Engineering](#155-data-pipeline-engineering)
- [15.6 Production Debugging & Interpretability](#156-production-debugging--interpretability)
- [15.7 Data Collection & Annotation](#157-data-collection--annotation)
- [15.8 Performance Engineering](#158-performance-engineering)
- [15.9 Vector Databases for ML/CV](#159-vector-databases-for-mlcv)

**Note:** For comprehensive MLOps practices (experiment tracking, model serving, monitoring, hyperparameter tuning, distributed training, model optimization, deployment patterns, lifecycle management), see [MLOps Policy](mlops-policy.md).

### 📚 Appendices

**Note:** Appendices are not yet implemented in this document. They will be added in a future update.

---

## How to Use This Document

### Daily Reference
Use the comprehensive TOC to jump directly to any rule or guideline. All sections are clickable and cross-referenced.

### For Code Reviews
Reference specific rules by section number (e.g., "See Python §3.4.5" or "Violates SQL §2.7").

### For Project Setup
Start with the Quick Reference Cards, then follow the relevant Common Scenarios.

### For Learning
Work through sections progressively. Each includes:
- Core principles
- Practical examples
- Anti-patterns to avoid
- Cross-references to related topics

---

## Production Ownership and Stewardship

**Status:** Authoritative
**Last updated:** 2026-01-19

### Core Principle: Ownership Beyond Authorship

With AI-assisted development, ownership shifts from **authorship → stewardship**. You own outcomes in production, not just code/models.

### Stewardship Questions (Mandatory Before Production)

Before deploying any system to production, you MUST be able to answer:

1. **Why does it exist?** What problem does it solve? What is the business/technical rationale?
2. **What guarantees?** What are the correctness guarantees? What invariants must hold?
3. **Failure modes?** What are the known failure modes? What edge cases can break it?
4. **Tests/invariants?** What tests verify correctness? What invariants are checked?
5. **Rollback plan?** How do we rollback if this breaks? What is the recovery procedure?
6. **Who gets paged?** If this fails in production, who is responsible? What is the escalation path?

### Operational Readiness Requirements

**Before deploying to production, ensure:**

- [ ] **Instrumentation:** Logging, metrics, traces configured
- [ ] **Feature flags:** Ability to disable/enable without redeploy
- [ ] **Staged rollouts:** Canary, blue-green, or gradual rollout capability
- [ ] **Runbooks:** Operational procedures documented
- [ ] **Rollback plan:** Tested procedure to revert changes
- [ ] **Monitoring:** Alerts configured for failure modes
- [ ] **Documentation:** What it does, why it exists, how to operate it

### Engineering Contract Expansion

The engineering "contract" expands from "deliver feature" to:

- **Spec quality:** Requirements are clear, constraints are explicit, edge cases are documented
- **Verification depth:** Tests cover happy path, edge cases, and failure modes
- **Operational readiness:** Instrumentation, flags, staged rollouts, runbooks are in place

### Stable Craft Domains (Mid–Long Term)

Focus your craft on domains where human judgment and ownership matter:

- **Problem framing & requirements clarity** — AI accelerates drafts, but clarity of constraints is the bottleneck
- **Architecture as tradeoff management** — Choosing tradeoffs and documenting them
- **Verification engineering** — Tests, invariants, debugging; verification becomes central
- **Security & reliability engineering** — Shift-left security + AI-aware controls
- **Production ownership / operations** — You own outcomes in production

**Less stable (will be automated):**
- Boilerplate implementation
- Repetitive glue
- Generic CRUD wiring

### Responsibility Does Not Move

**AI does not absolve you of responsibility:**
- Engineer merging it owns it
- Reviewer and service owner share accountability
- Organization owns liability

**AI expands the risk surface** (security, dependency hallucinations, leakage), so responsibility gets stricter, not looser.

## Quick Reference Cards
<a id="quick-reference-cards"></a>

These cards provide ready-to-use code snippets and commands for common tasks.

---

### QRC-1: New Python Project Setup
<a id="qrc-1-new-python-project-setup"></a>

```bash
# Complete Python project initialization

# 1. Create directory structure
mkdir -p myproject/{src/myproject,tests,docs,configs,scripts,data}
cd myproject

# 2. Initialize Git
git init
git branch -M main

# 3. Create Python virtual environment
python3 -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 4. Create pyproject.toml
cat > pyproject.toml << 'EOF'
[build-system]
requires = ["setuptools>=65.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "myproject"
version = "0.1.0"
requires-python = ">=3.10"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov>=4.0",
    "black>=23.0",
    "ruff>=0.1.0",
    "mypy>=1.0",
]

[tool.black]
line-length = 100
target-version = ['py310']

[tool.ruff]
line-length = 100
select = ["E", "F", "I", "N", "W"]

[tool.mypy]
strict = true
warn_return_any = true
warn_unused_configs = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = ["--strict-markers", "--cov=src", "--cov-report=term-missing"]
EOF

# 5. Install in development mode
pip install -e ".[dev]"

# 6. Create basic .gitignore
cat > .gitignore << 'EOF'
__pycache__/
*.py[cod]
*$py.class
.venv/
venv/
.pytest_cache/
.coverage
.mypy_cache/
*.egg-info/
dist/
build/
EOF

# 7. Create README
cat > README.md << 'EOF'
# MyProject

## Installation
\`\`\`bash
pip install -e ".[dev]"
\`\`\`

## Running Tests
\`\`\`bash
pytest
\`\`\`
EOF

# 8. Initial commit
git add .
git commit -m "feat: initial project structure"
```

**See also:** [Python §3.1](#3-1-project-structure), [Git §8.2](#8-2-commit-standards), [Testing §10.2](#10-2-unit-testing)

---

### QRC-2: Dataset Snapshot Creation
<a id="qrc-2-dataset-snapshot-creation"></a>

```python
# Complete pattern for creating immutable dataset snapshots
import hashlib
import json
from pathlib import Path
from typing import List, Dict, Any
from dataclasses import dataclass, asdict
from datetime import datetime

@dataclass
class SampleReference:
    """Reference to a single data sample."""
    sample_id: str
    store: str  # "s3", "gcs", "azure"
    bucket: str
    key: str
    version: str
    content_hash: str  # SHA256
    size_bytes: int
    metadata: Dict[str, Any]

class DatasetSnapshot:
    """Immutable dataset snapshot with manifest."""

    def __init__(self, dataset_id: str, version: str, description: str = ""):
        self.dataset_id = dataset_id
        self.version = version
        self.description = description
        self.samples: List[SampleReference] = []
        self.created_at = datetime.now().isoformat()

    def add_sample(self, sample: SampleReference) -> None:
        """Add sample to snapshot."""
        self.samples.append(sample)

    def compute_manifest_hash(self) -> str:
        """Compute SHA256 hash of manifest."""
        sorted_samples = sorted(
            [asdict(s) for s in self.samples],
            key=lambda x: x['sample_id']
        )
        manifest_json = json.dumps(sorted_samples, sort_keys=True)
        return hashlib.sha256(manifest_json.encode()).hexdigest()

    def save_manifest(self, output_path: Path) -> str:
        """Save manifest file and return hash."""
        manifest = {
            "dataset_id": self.dataset_id,
            "version": self.version,
            "created_at": self.created_at,
            "description": self.description,
            "sample_count": len(self.samples),
            "manifest_hash": self.compute_manifest_hash(),
            "samples": [asdict(s) for s in self.samples]
        }

        output_path.write_text(json.dumps(manifest, indent=2))
        return manifest["manifest_hash"]

# Usage example
snapshot = DatasetSnapshot(
    dataset_id="urban_driving_v1",
    version="2026.01.0",
    description="Urban driving scenarios - January 2026"
)

# Add samples
snapshot.add_sample(SampleReference(
    sample_id="frame_00001",
    store="s3",
    bucket="cv-training-data",
    key="urban/2026-01/camera/00001.jpg",
    version="v1",
    content_hash="sha256:a3b2c1d4e5f6...",
    size_bytes=1048576,
    metadata={"timestamp": "2026-01-13T10:30:00Z", "weather": "clear"}
))

# Save manifest
manifest_path = Path("manifests/urban_driving_v1_2026.01.0.json")
manifest_hash = snapshot.save_manifest(manifest_path)
print(f"Snapshot created: {manifest_hash}")
```

**See also:** [Data §1.6](#1-6-dataset-snapshot-policy), [Data §1.7](#1-7-object-identity), [Python §3.10](#3-10-mlcv-specific-rules)

---

### QRC-3: SQL Schema for CV/ML
<a id="qrc-3-sql-schema-pattern-for-cvml"></a>

```sql
-- Complete SQL schema pattern for CV/ML metadata management
-- This schema stores references to objects in S3/GCS, not the objects themselves

-- Dataset table: tracks dataset versions and snapshots
CREATE TABLE datasets (
    dataset_id VARCHAR(255) PRIMARY KEY,
    version VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    manifest_hash VARCHAR(64) NOT NULL,  -- SHA256 of manifest
    sample_count INTEGER NOT NULL,
    UNIQUE(dataset_id, version)
);

-- Samples table: references to individual data samples in object storage
CREATE TABLE samples (
    sample_id VARCHAR(255) PRIMARY KEY,
    dataset_id VARCHAR(255) NOT NULL,
    dataset_version VARCHAR(50) NOT NULL,
    store VARCHAR(20) NOT NULL,  -- 's3', 'gcs', 'azure'
    bucket VARCHAR(255) NOT NULL,
    object_key VARCHAR(1024) NOT NULL,
    object_version VARCHAR(100),
    content_hash VARCHAR(64) NOT NULL,  -- SHA256
    size_bytes BIGINT NOT NULL,
    metadata JSONB,  -- PostgreSQL: JSONB, MySQL: JSON, SQLite: TEXT
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dataset_id, dataset_version) REFERENCES datasets(dataset_id, version) ON DELETE RESTRICT,
    INDEX idx_dataset (dataset_id, dataset_version),
    INDEX idx_content_hash (content_hash)
);

-- Experiments table: tracks ML training/evaluation runs
CREATE TABLE experiments (
    experiment_id VARCHAR(255) PRIMARY KEY,
    dataset_id VARCHAR(255) NOT NULL,
    dataset_version VARCHAR(50) NOT NULL,
    model_name VARCHAR(255),
    hyperparameters JSONB,
    metrics JSONB,
    status VARCHAR(50) NOT NULL,  -- 'running', 'completed', 'failed'
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY (dataset_id, dataset_version) REFERENCES datasets(dataset_id, version) ON DELETE RESTRICT,
    INDEX idx_dataset (dataset_id, dataset_version),
    INDEX idx_status (status)
);

-- Model checkpoints: references to model artifacts in object storage
CREATE TABLE model_checkpoints (
    checkpoint_id VARCHAR(255) PRIMARY KEY,
    experiment_id VARCHAR(255) NOT NULL,
    epoch INTEGER,
    store VARCHAR(20) NOT NULL,
    bucket VARCHAR(255) NOT NULL,
    object_key VARCHAR(1024) NOT NULL,
    content_hash VARCHAR(64) NOT NULL,
    size_bytes BIGINT NOT NULL,
    metrics JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (experiment_id) REFERENCES experiments(experiment_id) ON DELETE CASCADE,
    INDEX idx_experiment (experiment_id)
);
```

**See also:** [SQL §2.2](#2-2-schema-design-principles), [SQL §2.4](#2-4-primary-keys-and-identity), [Data §1.7](#1-7-object-identity)

---

### QRC-4: Docker Multi-Stage Build
<a id="qrc-4-docker-multi-stage-build"></a>

```dockerfile
# Complete multi-stage Dockerfile pattern for Python ML/CV applications
# Stage 1: Build dependencies
FROM python:3.11-slim AS builder

WORKDIR /build

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Install dependencies (if using poetry)
RUN pip install --no-cache-dir poetry && \
    poetry export --without-hashes -f requirements.txt -o requirements.txt && \
    pip install --user --no-cache-dir -r requirements.txt

# Stage 2: Runtime image
FROM python:3.11-slim AS runtime

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /root/.local /home/appuser/.local

# Copy application code
COPY --chown=appuser:appuser src/ ./src/
COPY --chown=appuser:appuser configs/ ./configs/
COPY --chown=appuser:appuser scripts/ ./scripts/

# Set PATH for user-installed packages
ENV PATH=/home/appuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1

# Default command
CMD ["python", "-m", "src.main"]
```

**See also:** [Docker §12.2](#12-2-dockerfile-standards), [Docker §12.4](#12-4-security)

---

### QRC-5: Git Commit Template
<a id="qrc-5-git-commit-template"></a>

```bash
# Complete Git commit workflow with conventional commits

# 1. Configure commit template
cat > ~/.gitmessage << 'EOF'
# <type>(<scope>): <subject>
#
# <body>
#
# <footer>
#
# Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build
# Scope: optional, component/module name
# Subject: imperative mood, no period, max 50 chars
# Body: what and why, wrap at 72 chars
# Footer: breaking changes, issue references
EOF

git config --global commit.template ~/.gitmessage

# 2. Example commits
git commit -m "feat(cv): add YOLO object detection pipeline

- Implement YOLOv8 inference wrapper
- Add confidence threshold filtering
- Support batch processing for video streams

Closes #123"

git commit -m "fix(data): correct dataset manifest hash calculation

The hash was computed before sorting samples, causing
non-deterministic hashes. Now samples are sorted by ID
before hashing.

Fixes #456"

git commit -m "docs: update SQL schema documentation

Add examples for experiment tracking tables."

# 3. Pre-commit hook to enforce format
cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash
commit_msg=$(cat "$1")
if ! echo "$commit_msg" | grep -qE '^(feat|fix|docs|style|refactor|test|chore|perf|ci|build)(\(.+\))?: .{1,50}$'; then
    echo "Error: Commit message must follow Conventional Commits format"
    echo "Format: <type>(<scope>): <subject>"
    exit 1
fi
EOF
chmod +x .git/hooks/commit-msg
```

**See also:** [Git §8.2](#8-2-commit-standards)

---

### QRC-6: Kubernetes Deployment
<a id="qrc-6-kubernetes-deployment"></a>

```yaml
# Complete Kubernetes deployment pattern for ML/CV services
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cv-inference-service
  namespace: production
  labels:
    app: cv-inference
    version: v1.2.0
spec:
  replicas: 3
  selector:
    matchLabels:
      app: cv-inference
  template:
    metadata:
      labels:
        app: cv-inference
        version: v1.2.0
    spec:
      serviceAccountName: cv-inference-sa
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
      containers:
      - name: inference
        image: registry.example.com/cv-inference:v1.2.0
        imagePullPolicy: Always
        ports:
        - containerPort: 8000
          name: http
          protocol: TCP
        env:
        - name: MODEL_PATH
          value: "/models/yolo-v8.pt"
        - name: LOG_LEVEL
          value: "INFO"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: cv-inference-secrets
              key: database-url
        resources:
          requests:
            memory: "2Gi"
            cpu: "1000m"
            nvidia.com/gpu: 1  # GPU request
          limits:
            memory: "4Gi"
            cpu: "2000m"
            nvidia.com/gpu: 1
        volumeMounts:
        - name: model-storage
          mountPath: /models
          readOnly: true
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 10
          periodSeconds: 5
          timeoutSeconds: 3
          failureThreshold: 3
      volumes:
      - name: model-storage
        persistentVolumeClaim:
          claimName: model-pvc
      nodeSelector:
        accelerator: nvidia-tesla-v100
      tolerations:
      - key: "nvidia.com/gpu"
        operator: "Exists"
        effect: "NoSchedule"
---
apiVersion: v1
kind: Service
metadata:
  name: cv-inference-service
  namespace: production
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8000
    protocol: TCP
    name: http
  selector:
    app: cv-inference
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: cv-inference-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: cv-inference-service
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

**See also:** [Kubernetes §13.2](#13-2-workload-types), [Kubernetes §13.6](#13-6-resource-management)

---

### QRC-7: Pytest Setup
<a id="qrc-7-pytest-configuration"></a>

```python
# Complete pytest configuration for ML/CV projects
# File: pytest.ini or pyproject.toml

# pytest.ini
[pytest]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]

# Markers for test categorization
markers =
    unit: Unit tests (fast, isolated)
    integration: Integration tests (require external services)
    slow: Slow tests (skip in CI unless explicitly run)
    gpu: Tests requiring GPU
    cv: Computer vision specific tests
    ml: Machine learning specific tests
    data: Tests requiring data files

# Test discovery
norecursedirs = [".git", ".venv", "venv", "build", "dist", "*.egg-info"]

# Output options
addopts =
    --strict-markers
    --strict-config
    --verbose
    --tb=short
    --cov=src
    --cov-report=term-missing
    --cov-report=html:htmlcov
    --cov-report=xml
    --cov-fail-under=80
    -ra

# Coverage configuration
[tool.coverage.run]
source = ["src"]
omit = [
    "*/tests/*",
    "*/test_*",
    "*/__pycache__/*",
    "*/venv/*",
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
]

# Example test file structure
# tests/
#   ├── unit/
#   │   ├── test_data_processing.py
#   │   └── test_models.py
#   ├── integration/
#   │   ├── test_database.py
#   │   └── test_api.py
#   ├── fixtures/
#   │   └── conftest.py
#   └── data/
#       └── test_samples/

# conftest.py example
import pytest
import numpy as np
from pathlib import Path

@pytest.fixture
def sample_image():
    """Generate a test image."""
    return np.random.randint(0, 255, (640, 480, 3), dtype=np.uint8)

@pytest.fixture
def test_data_dir():
    """Path to test data directory."""
    return Path(__file__).parent / "data"

@pytest.fixture(scope="session")
def model_checkpoint(tmp_path_factory):
    """Create a mock model checkpoint for testing."""
    checkpoint_path = tmp_path_factory.mktemp("models") / "test_model.pt"
    # Create mock checkpoint
    checkpoint_path.touch()
    return checkpoint_path
```

**See also:** [Testing §10.2](#10-2-unit-testing), [Python §3.8](#3-8-testing-standards)

---

### QRC-8: React Component Pattern
<a id="qrc-8-react-component-pattern"></a>

```typescript
// Complete React component pattern for ML/CV visualization
// File: src/components/ModelInferenceView.tsx

import React, { useState, useCallback, useMemo } from 'react';
import { useQuery, useMutation } from '@tanstack/react-query';
import type { InferenceResult, ModelConfig } from '../types';

interface ModelInferenceViewProps {
  modelId: string;
  onResult?: (result: InferenceResult) => void;
}

export const ModelInferenceView: React.FC<ModelInferenceViewProps> = ({
  modelId,
  onResult,
}) => {
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [config, setConfig] = useState<ModelConfig>({
    confidenceThreshold: 0.5,
    nmsThreshold: 0.4,
  });

  // Fetch model metadata
  const { data: model, isLoading } = useQuery({
    queryKey: ['model', modelId],
    queryFn: async () => {
      const response = await fetch(`/api/models/${modelId}`);
      if (!response.ok) throw new Error('Failed to fetch model');
      return response.json();
    },
  });

  // Inference mutation
  const inferenceMutation = useMutation({
    mutationFn: async (file: File) => {
      const formData = new FormData();
      formData.append('image', file);
      formData.append('config', JSON.stringify(config));

      const response = await fetch(`/api/inference/${modelId}`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) throw new Error('Inference failed');
      return response.json() as Promise<InferenceResult>;
    },
    onSuccess: (result) => {
      onResult?.(result);
    },
  });

  const handleFileChange = useCallback(
    (event: React.ChangeEvent<HTMLInputElement>) => {
      const file = event.target.files?.[0];
      if (file) {
        setImageFile(file);
      }
    },
    []
  );

  const handleRunInference = useCallback(() => {
    if (imageFile) {
      inferenceMutation.mutate(imageFile);
    }
  }, [imageFile, inferenceMutation]);

  const imagePreview = useMemo(() => {
    if (!imageFile) return null;
    return URL.createObjectURL(imageFile);
  }, [imageFile]);

  if (isLoading) {
    return <div>Loading model...</div>;
  }

  return (
    <div className="model-inference-view">
      <h2>{model?.name || 'Model Inference'}</h2>

      <div className="config-panel">
        <label>
          Confidence Threshold:
          <input
            type="number"
            min="0"
            max="1"
            step="0.1"
            value={config.confidenceThreshold}
            onChange={(e) =>
              setConfig((prev) => ({
                ...prev,
                confidenceThreshold: parseFloat(e.target.value),
              }))
            }
          />
        </label>
      </div>

      <div className="upload-section">
        <input
          type="file"
          accept="image/*"
          onChange={handleFileChange}
        />
        {imagePreview && (
          <img src={imagePreview} alt="Preview" className="preview-image" />
        )}
      </div>

      <button
        onClick={handleRunInference}
        disabled={!imageFile || inferenceMutation.isPending}
      >
        {inferenceMutation.isPending ? 'Running...' : 'Run Inference'}
      </button>

      {inferenceMutation.isError && (
        <div className="error">
          Error: {inferenceMutation.error?.message}
        </div>
      )}

      {inferenceMutation.data && (
        <div className="results">
          <h3>Results</h3>
          <pre>{JSON.stringify(inferenceMutation.data, null, 2)}</pre>
        </div>
      )}
    </div>
  );
};
```

**See also:** [React §5.1](#5-1-component-architecture), [React §5.2](#5-2-state-management), [TypeScript §4.1](#4-1-project-setup)

---

### QRC-9: TypeScript Project Setup
<a id="qrc-9-typescript-project-setup"></a>

```bash
# Complete TypeScript project initialization for ML/CV frontend

# 1. Initialize project
mkdir -p myproject/{src,public,tests}
cd myproject

# 2. Initialize package.json
npm init -y

# 3. Install TypeScript and dependencies
npm install --save-dev \
  typescript@^5.0.0 \
  @types/node@^20.0.0 \
  ts-node@^10.0.0 \
  tsx@^4.0.0 \
  @typescript-eslint/parser@^6.0.0 \
  @typescript-eslint/eslint-plugin@^6.0.0 \
  eslint@^8.0.0 \
  prettier@^3.0.0 \
  vitest@^1.0.0 \
  @vitest/ui

# 4. Create tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "allowJs": false,
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "tests"]
}
EOF

# 5. Create .eslintrc.json
cat > .eslintrc.json << 'EOF'
{
  "parser": "@typescript-eslint/parser",
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking"
  ],
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "rules": {
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-unused-vars": "error"
  }
}
EOF

# 6. Create .prettierrc
cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
EOF

# 7. Update package.json scripts
cat >> package.json << 'EOF'
{
  "scripts": {
    "build": "tsc",
    "dev": "tsx watch src/index.ts",
    "lint": "eslint src --ext .ts",
    "format": "prettier --write \"src/**/*.ts\"",
    "test": "vitest",
    "test:ui": "vitest --ui"
  }
}
EOF
```

**See also:** [TypeScript §4.1](#4-1-project-setup), [TypeScript §4.7](#4-7-build-and-tooling)

---

### QRC-10: Kafka Patterns
<a id="qrc-10-kafka-patterns"></a>

```python
# Complete Kafka producer/consumer patterns for ML/CV pipelines
from confluent_kafka import Producer, Consumer, KafkaError
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroSerializer, AvroDeserializer
import json
from typing import Dict, Any
from dataclasses import dataclass

# 1. Schema definition (Avro)
INFERENCE_REQUEST_SCHEMA = {
    "type": "record",
    "name": "InferenceRequest",
    "fields": [
        {"name": "request_id", "type": "string"},
        {"name": "model_id", "type": "string"},
        {"name": "image_url", "type": "string"},
        {"name": "config", "type": {"type": "map", "values": "string"}},
        {"name": "timestamp", "type": "long"}
    ]
}

INFERENCE_RESULT_SCHEMA = {
    "type": "record",
    "name": "InferenceResult",
    "fields": [
        {"name": "request_id", "type": "string"},
        {"name": "model_id", "type": "string"},
        {"name": "detections", "type": {"type": "array", "items": "string"}},
        {"name": "processing_time_ms", "type": "long"},
        {"name": "timestamp", "type": "long"}
    ]
}

# 2. Producer pattern
class InferenceRequestProducer:
    def __init__(self, bootstrap_servers: str, schema_registry_url: str):
        self.producer = Producer({
            'bootstrap.servers': bootstrap_servers,
            'acks': 'all',  # Wait for all replicas
            'retries': 3,
            'max.in.flight.requests.per.connection': 1,  # Ensure ordering
            'enable.idempotence': True,
        })

        schema_registry = SchemaRegistryClient({'url': schema_registry_url})
        self.serializer = AvroSerializer(
            schema_registry,
            INFERENCE_REQUEST_SCHEMA
        )

    def send_request(self, topic: str, request: Dict[str, Any], key: str = None):
        """Send inference request to Kafka."""
        try:
            serialized = self.serializer(request, None)
            self.producer.produce(
                topic,
                key=key or request['request_id'],
                value=serialized,
                callback=self._delivery_callback
            )
            self.producer.poll(0)  # Trigger delivery
        except Exception as e:
            print(f"Error sending message: {e}")

    def flush(self, timeout: float = 10.0):
        """Flush pending messages."""
        self.producer.flush(timeout)

    @staticmethod
    def _delivery_callback(err, msg):
        if err:
            print(f"Message delivery failed: {err}")
        else:
            print(f"Message delivered to {msg.topic()} [{msg.partition()}]")

# 3. Consumer pattern
class InferenceResultConsumer:
    def __init__(self, bootstrap_servers: str, schema_registry_url: str,
                 group_id: str, topics: list[str]):
        self.consumer = Consumer({
            'bootstrap.servers': bootstrap_servers,
            'group.id': group_id,
            'auto.offset.reset': 'earliest',
            'enable.auto.commit': False,  # Manual commit for exactly-once
        })
        self.consumer.subscribe(topics)

        schema_registry = SchemaRegistryClient({'url': schema_registry_url})
        self.deserializer = AvroDeserializer(
            schema_registry,
            INFERENCE_RESULT_SCHEMA
        )

    def consume(self, timeout: float = 1.0):
        """Consume messages with error handling."""
        msg = self.consumer.poll(timeout)

        if msg is None:
            return None

        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                return None
            else:
                raise Exception(f"Consumer error: {msg.error()}")

        try:
            result = self.deserializer(msg.value(), None)
            # Process message
            self._process_result(result)
            # Commit offset after successful processing
            self.consumer.commit(msg)
            return result
        except Exception as e:
            print(f"Error processing message: {e}")
            # Handle poison message (send to DLQ, etc.)
            return None

    def _process_result(self, result: Dict[str, Any]):
        """Process inference result."""
        print(f"Received result for request {result['request_id']}")
        # Store in database, update UI, etc.

    def close(self):
        """Close consumer."""
        self.consumer.close()

# 4. Usage example
producer = InferenceRequestProducer(
    bootstrap_servers='localhost:9092',
    schema_registry_url='http://localhost:8081'
)

producer.send_request(
    topic='inference-requests',
    request={
        'request_id': 'req-123',
        'model_id': 'yolo-v8',
        'image_url': 's3://bucket/image.jpg',
        'config': {'confidence': '0.5', 'nms': '0.4'},
        'timestamp': 1705123456789
    },
    key='req-123'  # Key for partitioning
)
producer.flush()

consumer = InferenceResultConsumer(
    bootstrap_servers='localhost:9092',
    schema_registry_url='http://localhost:8081',
    group_id='result-processor',
    topics=['inference-results']
)

# Consume loop
while True:
    result = consumer.consume()
    if result:
        # Process result
        pass
```

**See also:** [Kafka §14.2](#14-2-producer-patterns), [Kafka §14.3](#14-3-consumer-patterns), [Kafka §14.4](#14-4-schema-management)

---

## 📊 1. Data & Storage

### Acronyms

* **CV** — Computer Vision
* **ML** — Machine Learning
* **SQL** — Structured Query Language
* **WORM** — Write Once, Read Many

---

### 1.1 Core Principles

**Object storage is the source of truth for large blobs**, including:

* Images, videos, point clouds, tensors, embeddings
* Model checkpoints and large binary artifacts

**SQL stores meaning**, including:

* Dataset membership, splits, labels, lineage, provenance, experiment metadata
* Object references (URIs), hashes, and versions — never inferred

**Key principle**:

> **Blobs live in object storage. Meaning, relationships, and history live in SQL.**

---

### 1.2 Storage Systems

Approved object storage classes:

* Cloud: S3 / GCS / Azure Blob
* Self-hosted: S3-compatible stores (e.g., MinIO)

Filesystems (POSIX) MAY be used for:

* Local development caches
* Ephemeral intermediates not used for training or evaluation baselines

---

### 1.3 Raw Data Rules

* Raw sensor logs are **append-only**.
* Raw data MUST be ingested into a **raw zone** with immutability controls.
* Any privacy/safety redactions MUST occur before promoting to curated datasets.

---

### 1.4 Derived Data Rules

Derived artifacts (frames, clips, sweeps, tensors, features) MUST:

* Be produced from an identified upstream source (lineage)
* Have deterministic build parameters recorded (code version + config + toolchain)
* Be stored as objects and referenced immutably

---

### 1.5 Immutability Policy

Once an object is referenced by any of:

* Dataset snapshot
* Experiment run
* Evaluation report
* Model registry entry

…it becomes **immutable**.

Implementation requirements:

* Use WORM-like retention/object lock where available
* Otherwise enforce immutability by convention: **never overwrite keys**; write new keys/versions only

---

### 1.6 Dataset Snapshot Policy

A dataset used for training/evaluation MUST be a snapshot defined by:

* A **manifest** (explicit list of sample IDs and object references)
* A version identifier (dataset version)
* A content hash of the manifest

Directory scanning MUST NOT define dataset membership.

---

### 1.7 Object Identity

Every stored object MUST be uniquely identified by:

* `(store, bucket, key, version/generation, content_hash)`

The database MUST store these fields (or an equivalent normalized schema).

---

### 1.8 Formats Policy

#### For training IO (streaming-friendly)

* WebDataset shards (tar) are RECOMMENDED for high-throughput GPU training.
* TFRecord is acceptable for TensorFlow-centric pipelines.

#### For analytics / indexing

* Parquet is RECOMMENDED for offline analytics and scenario mining.
* CSV is permitted only when schema-defined and validated.

---

### 1.9 Retention and Lifecycle

* Raw zone retention is defined by compliance and cost; default is long-lived.
* Curated and derived artifacts MUST have explicit lifecycle policies (TTL) unless they are part of a released baseline.
* Any deletion MUST be traceable and logged, with a reversible plan where feasible.

---

### 1.10 Access and Performance

* Training pipelines SHOULD use sharding, caching, and prefetching.
* Avoid small-object explosions; prefer shard files at predictable sizes.
* Always record IO performance metrics when scaling training.

---

### 1.11 What Never Goes in SQL

SQL databases MUST NOT store:

* Raw image/video payloads
* Large point clouds or tensors
* Model binaries

Store only references, hashes, and metadata.

---

### 1.12 Exceptions Process

Any deviation from this policy requires:

* A written justification in `exception-and-decision-log.md`
* Risk classification (Low/Medium/High)
* Mitigation steps and a sunset date

---

## 🗄️ 2. SQL Databases

This section defines professional, enforceable rules for working with **SQL as a language** and with the most common relational engines: **Standard SQL**, **MySQL**, **PostgreSQL**, and **SQLite**.

Scope: schema design, queries, migrations, performance, correctness, and operational safety — within modern data-intensive systems, including CV/ML engineering.

### 2.1 SQL in CV/ML Architectures

#### Context: SQL in modern CV/ML data architectures

In computer vision and machine learning systems, SQL is not used in isolation.
It operates as part of a layered data stack with clear responsibility boundaries.

### A) Object storage (dominant)

Primary storage for raw and derived data:

* Images
* Videos
* Point clouds
* Tensors
* Large binary artifacts

Common systems:

* Amazon S3
* Google Cloud Storage (GCS)
* Azure Blob Storage
* MinIO (on-prem / self-hosted)

Rules:

* Object storage is the **source of truth for large blobs**
* SQL databases must never store raw image/video payloads
* Objects are immutable once referenced by experiments or models

### B) Files + metadata formats

Columnar / record formats for datasets and analytics:

* Parquet
* CSV (controlled, schema-defined)
* TFRecord
* WebDataset

Used for:

* Training datasets
* Evaluation splits
* Feature snapshots
* Offline analytics

Rules:

* Files carry data
* SQL carries meaning
* File paths, hashes, and versions are referenced from SQL, never inferred

### C) Relational databases (SQL)

Authoritative system of record for structured metadata:

* Experiment metadata
* Model versions and lineage
* Annotations and labels
* Dataset splits
* Metrics, runs, and comparisons
* Auditability and joins across all of the above

Why SQL is mandatory here:

* Referential integrity
* Deterministic joins
* Schema evolution
* Reproducibility
* Auditing and traceability

Key principle:

> **Blobs live in object storage.
> Meaning, relationships, and history live in SQL.**

### 2.2 Schema Design Principles

#### Core principles (engine-agnostic)

1. SQL is a programming language. It is reviewed, tested, versioned, and reasoned about like any other code.
2. Correctness before cleverness. Readable, explicit queries beat compact or “smart” SQL.
3. Determinism is mandatory. Query results must not depend on undefined ordering, implicit casts, or engine quirks.
4. Schema is a contract. Tables, constraints, and indexes define guarantees—not suggestions.
5. The database is not a dumping ground. Data integrity lives in the database, not only in application code.

### 2.3 Normalization

#### Standard SQL discipline (portable subset)

6. Prefer Standard SQL features unless engine-specific behavior is required.
7. Avoid relying on undefined behavior, including:

   * SELECT without ORDER BY
   * GROUP BY with non-aggregated, non-grouped columns
   * implicit type coercions
8. Be explicit with JOINs:

   * always specify JOIN type (`INNER`, `LEFT`, etc.)
   * never rely on implicit joins.
9. Use explicit column lists:

   * no `SELECT *` in production code.
10. NULL semantics are understood and respected:

    * `NULL` ≠ `0`, `''`, or `FALSE`
    * comparisons with NULL use `IS NULL` / `IS NOT NULL`.

### 2.4 Primary Keys and Identity

#### Schema design rules (all engines)

11. Every table has a primary key. No exceptions, including join tables.
12. Primary keys are stable:

    * never overloaded with meaning
    * never reused.
13. Foreign keys are real constraints, not documentation:

    * enforce referential integrity in the database.
14. ON DELETE / ON UPDATE behavior is explicit:

    * no silent cascades without review.
15. Use appropriate data types:

    * no “everything is TEXT/VARCHAR” schemas.
16. Booleans are booleans, not integers or strings.
17. Timestamps include timezone policy (defined and documented).
18. Constraints are first-class:

    * `NOT NULL`
    * `UNIQUE`
    * `CHECK`
19. Do not encode business rules only in triggers unless formally justified and documented.

### 2.5 Foreign Keys and Constraints

#### Query writing standards

20. Queries are formatted and readable:

    * one clause per line
    * aligned JOINs and conditions.
21. Aliases are meaningful:

    * avoid single-letter aliases outside tiny scopes.
22. WHERE before performance:

    * correctness first, indexing second.
23. Avoid correlated subqueries unless measured and justified.
24. Prefer EXISTS over IN when semantics require existence checks.
25. Explicit ordering whenever order matters.
26. LIMIT without ORDER BY is forbidden in deterministic logic.
27. Date logic is explicit:

    * no reliance on engine default timezones.

### 2.6 Indexes and Performance

#### Indexing and performance discipline

28. Indexes exist for queries, not theory.
29. Every non-trivial query has an execution plan reviewed:

    * `EXPLAIN`, `EXPLAIN ANALYZE` (engine-specific).
30. Indexes match access patterns:

    * order of columns matters.
31. Avoid over-indexing:

    * write amplification and maintenance cost are real.
32. No function calls on indexed columns in WHERE clauses unless using functional indexes.
33. Pagination is index-aware:

    * OFFSET-heavy pagination is avoided at scale.
34. Performance changes require evidence, not intuition.

### 2.7 Query Patterns

#### Migrations and schema evolution

35. Schema changes are versioned:

    * migrations live in source control.
36. Migrations are forward-only in production.
37. Destructive changes are staged:

    * add column → backfill → switch reads → drop old column.
38. Migrations are idempotent or safely repeatable where tooling allows.
39. No manual production changes outside migrations.
40. Rollback strategy is documented (even if rollback is “restore from backup”).

### 2.8 Transactions and Isolation

#### Transactions and concurrency

41. Transactions are explicit for multi-step operations.
42. Isolation level is understood and chosen deliberately:

    * do not assume defaults are correct.
43. No long-running transactions holding locks without justification.
44. SELECT … FOR UPDATE is used intentionally, never casually.
45. Deadlocks are anticipated and handled in application logic where needed.

### 2.9 Migrations and Schema Evolution

#### Engine-specific rules — MySQL

46. InnoDB is mandatory (no MyISAM).
47. ONLY_FULL_GROUP_BY is enabled and treated as baseline correctness.
48. Character set and collation are explicit (`utf8mb4`).
49. AUTO_INCREMENT is not used as business logic.
50. Boolean columns use `BOOLEAN` / `TINYINT(1)` consistently, documented.
51. Date/time behavior is tested with timezone differences.
52. LIMIT without ORDER BY is forbidden (MySQL is especially permissive and dangerous here).

### 2.10 Security

#### Engine-specific rules — PostgreSQL

53. PostgreSQL is the reference engine for advanced SQL features when available.
54. Use native types:

    * `UUID`, `JSONB`, `ARRAY`, `ENUM` (with discipline).
55. CTEs (`WITH`) are used for clarity, not assumed to be free (materialization is understood).
56. Indexes types are chosen deliberately:

    * B-tree, GIN, GiST, BRIN as appropriate.
57. Extensions are documented (`pgcrypto`, `uuid-ossp`, etc.).
58. Explain plans are reviewed with ANALYZE, not guessed.

### 2.11 Operations

#### Engine-specific rules — SQLite

59. SQLite is not “toy SQL.” It is used intentionally for:

    * local apps
    * embedded systems
    * tests
    * small single-user tools.
60. Concurrency limitations are understood (writer locks).
61. Foreign keys are explicitly enabled (`PRAGMA foreign_keys = ON`).
62. Type affinity rules are respected (SQLite is flexible, not magical).
63. No assumptions of strict typing unless enforced by CHECK constraints.
64. Migrations are still required, even for local databases.

### 2.12 Engine-Specific Guidance

#### Security rules (SQL)

65. Parameterized queries only.
66. No string concatenation for SQL, ever.
67. Least-privilege database users:

    * read-only where possible
    * no superuser for apps.
68. No credentials in source control.
69. Audit logging for sensitive operations where required.
70. Encryption at rest and in transit is policy-driven and documented.

#### Testing and verification

71. Queries are testable artifacts:

    * unit tests for logic
    * integration tests against real engines where possible.
72. Test data is representative, not trivial.
73. Edge cases are tested:

    * NULLs
    * empty sets
    * boundary dates.
74. Performance-sensitive queries have regression tests or benchmarks.

#### Tooling and workflow

75. SQL formatting is standardized (formatter enforced).
76. Linting/static checks used where available.
77. Migrations run in CI against a clean database.
78. Local dev mirrors production engine behavior as closely as possible.
79. Explain plans are captured for critical queries in docs or PRs.

#### Common anti-patterns to ban

80. `SELECT *` in production queries.
81. Missing primary keys.
82. Relying on implicit ordering.
83. Application-only referential integrity.
84. Unbounded TEXT columns for structured data.
85. Silent schema drift.
86. Ad hoc indexes added “just in prod.”
87. Mixing SQL dialects without documentation.

#### Minimal "gold standard" checklist

88. Schema has PKs, FKs, constraints.
89. Queries are explicit, ordered, and readable.
90. Migrations are versioned and CI-enforced.
91. Indexes align with real queries.
92. Parameterized queries everywhere.
93. Engine-specific behavior is documented.
94. Performance changes backed by evidence.


---




**Status:** Authoritative
**Last updated:** 2026-01-16
Scope: local development, repo initialization, CI/CD readiness, production hygiene, and AI-assisted work
Note: CI authority (merge gating, bypass rules, enforcement) is defined in this policy's Git and Source Control section (Section 5). This section defines tooling + workflow conventions.

---


This file is the **single source of truth** merging:
1) **Project Bootstrap & Engineering Quality Policy**
2) **Engineering Tooling & Workflow Policies**

Nothing from either source has been removed; content is reorganized so it is easier to maintain as one document.

---



**Status:** Authoritative
**Last updated:** 2026-01-16
Applies to: **all new and existing projects** (unless explicitly overridden in that repo)
Scope: IDE setup, Git workflow, coding style, testing, documentation, automation (pre-commit/CI)

---

## 0) Purpose

This policy exists to eliminate “setup drift” and ensure that **every project is created and operated** with:
- consistent style and formatting
- deterministic tooling
- safe Git operations
- repeatable test and documentation workflows

It distinguishes:
- **Machine setup (one-time per workstation)**
- **Repo setup (repeatable per project)**

---

## 1) Engineering principles (non-negotiable)

1. **Automation over memory**
   - If it is not enforced by tooling (formatter/linter/hooks/CI), it is not a rule.

2. **Formatters are the source of truth**
   - Python: **Black**
   - JS/TS/HTML/CSS/YAML/Markdown/JSON: **Prettier**
   - C/C++/CUDA: **clang-format**
   - Java: **google-java-format** (or IntelliJ “Google Style”)
   - SQL: DataGrip formatter (optionally `sqlfluff` for repo enforcement)

3. **Linting prevents bugs**
   - Python: **Ruff**
   - JS/TS: **ESLint**
   - Bash: **ShellCheck**
   - C/C++: **clang-tidy**
   - Java: Checkstyle/SonarLint (team-grade)

4. **Pre-commit is mandatory**
   - Every repo must have `.pre-commit-config.yaml`.
   - Every developer must run:
     ```bash
     pre-commit install
     ```
   - Pre-commit must be run before push/PR updates.

5. **Terminal is the source of truth**
   - IDE UIs are allowed for convenience.
   - Critical operations (rebase, conflict handling, destructive changes) default to CLI.

---

## 2) Machine setup (one-time per workstation)

### 2.1 System-level tools (required)
Install (as applicable):
- `git`
- `pre-commit`
- Python toolchain manager (your policy: **pyenv**)
- Node.js (for JS/TS projects)
- Java JDK (for IntelliJ/Spring/Maven)
- clang toolchain (for CLion/C++/CUDA)
- Docker (if used in the project)

### 2.2 IDE machine setup (required)

#### VS Code (Web / JS / TS / YAML / Markdown)
Install extensions:
- **Prettier – Code formatter** (`esbenp.prettier-vscode`) — official
- **ESLint** (`dbaeumer.vscode-eslint`) — official
- **EditorConfig for VS Code**
- **YAML** (Red Hat)
- **markdownlint**

#### JetBrains (global)
Enable:
- **Settings → Tools → Actions on Save**
  - ✅ Reformat code
  - ✅ Optimize imports

PyCharm:
- must format with Black using the **project interpreter** (venv)
- show whitespace enabled (recommended)

IntelliJ IDEA:
- install plugin: `google-java-format`
- (recommended) SonarLint

WebStorm:
- **Prettier:** Configuration mode = AUTOMATIC, Run on save = enabled
- **ESLint:** Fix on save = enabled
- **EditorConfig:** Support enabled (Settings → Editor → Code Style → Enable EditorConfig support)
- **Inspections:** ESLint enabled at WARNING level
- **Code Style:** Use project/EditorConfig settings (do not override with global defaults)
- show whitespace enabled (recommended)

CLion:
- enable `.clang-format`
- enable clang-tidy inspections

DataGrip:
- set SQL style: keyword UPPER, consistent indentation/alignment
- ensure dialect is correct per datasource

---

## 3) Repo initialization policy (NEW project)

### 3.1 Create repo structure
At repo root, create at minimum:
- `README.md`
- `.gitignore`
- `.editorconfig`
- `.pre-commit-config.yaml`
- `docs/` (for non-trivial projects)
- `tests/` (when applicable)

Recommended:
- `src/` for production code
- `scripts/` for utility scripts

### 3.2 Initialize Git and first commit
```bash
git init -b main
git status
```

Add baseline files, then:
```bash
git add -A
git commit -m "chore: initialize repo"
```

Add remote and push:
```bash
git remote add origin <REMOTE_URL>
git push -u origin main
```

### 3.3 Pre-commit bootstrap (mandatory)
Install:
```bash
pre-commit install
pre-commit run --all-files
```

If hooks modify files:
- review diffs
- stage changes
- re-run `pre-commit` until clean

---

## 4) Repo opening policy (OLD project)

When opening an existing repo:
```bash
git status
git pull --ff-only
pre-commit install
```

Then run once:
```bash
pre-commit run --all-files
```

If it fails:
- fix issues
- commit a tooling-only change if needed

---

## 5) Git and Source Control Policy

**Note:** This section integrates comprehensive Git workflow and source control policies. For versioning and release processes, see [Versioning and Release Policy](versioning-and-release-policy.md).

### Acronyms

* **PR** — Pull Request
* **CI** — Continuous Integration
* **WIP** — Work In Progress
* **SemVer** — Semantic Versioning
* **EOL** — End Of Line (line endings)
* **CRLF** — Carriage Return  Line Feed (`\r\n`, common on Windows)
* **LF** — Line Feed (`\n`, common on Linux/macOS)

### 5.1 Core principles

1. **History is a shared asset.** It must be understandable, auditable, and reviewable.
2. **`main` is always releasable.** A broken `main` branch is a process failure.
3. **Small, focused changes.** One concern per commit and per PR.
4. **Automation over trust.** CI enforces rules; humans review intent and design.
5. **Reproducibility over convenience.** Releases must be traceable to source and CI artifacts.

### 5.2 Repository setup and hygiene

6. **One repository, one purpose.** Unrelated projects are not co-located.
7. **Standard root files (as applicable):**
   * `README.md`
   * `LICENSE`
   * `.gitignore`
   * `CODEOWNERS`
   * CI configuration
8. **No generated artifacts committed** (build outputs, caches, vendor folders).
9. **Secrets never enter Git.** Use secret managers; rotate immediately if leaked. See [Security Policy](security-policy.md) for detailed secrets handling.
10. **Large or binary files are avoided.**
    Git LFS MAY be used only with explicit justification and quotas. Object storage is preferred.

11. **Line endings are standardized (cross-platform).**
    * Repository canonical EOL is **LF**.
    * Windows contributors MUST use tooling that respects `.gitattributes` (see Windows section).
    * Add `.gitattributes` to every repo (minimum baseline shown below).

**Baseline `.gitattributes` (required):**
```gitattributes
# Canonical line endings
* text=auto eol=lf

# Common text formats
*.md   text eol=lf
*.txt  text eol=lf
*.yml  text eol=lf
*.yaml text eol=lf
*.json text eol=lf
*.toml text eol=lf

# Shell scripts must be LF (Windows CRLF breaks shebang)
*.sh   text eol=lf

# Batch/PowerShell are typically CRLF (keep native if you want)
*.bat  text eol=crlf
*.cmd  text eol=crlf
*.ps1  text eol=crlf

# Binary (never normalize)
*.png  binary
*.jpg  binary
*.jpeg binary
*.pdf  binary
*.zip  binary
```

### 5.3 Branching model

12. **Default model: trunk-based development.**

    * Short-lived feature branches.
    * Frequent merges into `main`.
13. **Long-lived branches are discouraged.**

    * Release branches MAY exist when operationally required.
    * Hotfix branches MAY exist for urgent fixes.
14. **Protected `main` branch:**

    * No direct pushes.
    * PR required.
    * CI must pass.
    * Required reviews enforced.
15. **Branch naming conventions:**

    * `feat/<short-desc>`
    * `fix/<short-desc>`
    * `chore/<short-desc>`
    * `docs/<short-desc>`
    * `release/<version>` (if used)
16. **Branches are short-lived** and deleted after merge.

### 5.4 Commit discipline

17. **Each commit is coherent and buildable.** No half-working commits.
18. **Commit messages are standardized** (Conventional Commits style):

    * `feat: …`
    * `fix: …`
    * `docs: …`
    * `chore: …`
    * `refactor: …`
    * `test: …`
19. **Imperative mood** in subject lines ("add", not "added").
20. **Explain why, not just what**, in the body when context matters.
21. **No local noise commits** (debug prints, accidental formatting), unless isolated and intentional.

### 5.5 Pull Requests (PRs)

22. **PR is the unit of collaboration.** All changes go through PRs.
23. **PR scope is limited** to one logical change.
24. **PR description MUST include:**

    * problem statement
    * solution approach
    * testing performed
    * risks or trade-offs (if any)
25. **PRs SHOULD:**

    * stay under ~400 lines changed unless justified
    * reference an issue or decision record when applicable
26. **WIP PRs are allowed** but MUST be clearly labeled and never merged.

### 5.6 Code review standards

#### 5.6.1 Mandatory Code Review (CR) enforcement for AI-assisted / agentic coding

Purpose: prevent "high-velocity wrong code" and ensure AI-generated changes are held to the same quality and security bar as human-authored code.

#### A) Governance rules (non-negotiable)

1. **Protected branches are mandatory.** `main` (and `release/*` where applicable) MUST be protected.
2. **PR-only merges.** Direct pushes to protected branches are forbidden.
3. **Human approvals required.** Every PR requires at least **2 approvals**.
4. **CODEOWNERS enforced.** Changes in owned paths require Code Owner approval.
5. **No self-approval of last push.** The last pusher to the PR branch MUST NOT be eligible to satisfy the approval requirement.
6. **No merge with unresolved conversations.** All review threads must be resolved.
7. **No merge without green CI.** Required checks must pass in **strict** mode (branch must be up-to-date).
8. **No force-pushes to protected branches.** Force pushes are blocked; branch deletions are restricted.
9. **Linear history enforced.** Use squash or rebase merges to keep `main` audit-friendly.

#### B) AI-specific requirements

1. **AI usage disclosure.** PR description MUST state whether AI assisted the change and what portions were generated.
2. **Verification proof.** PR description MUST include:
   * tests run (commands)
   * expected behavior and validation steps
   * any risk area (auth/authz, parsing, deserialization, IAM, networking)
3. **No AI-only approvals.** Automated approvals or "rubber stamp" reviews are prohibited.
4. **Security-sensitive changes require explicit review.** Auth/authz, crypto, deserialization, shell/process execution, and network boundaries require review by an explicitly trusted reviewer.

#### C) Implementation in GitHub (required configuration)

This policy MUST be enforced by GitHub **Rulesets** (preferred) or Branch Protection Rules:

- Require PR before merge
- Minimum **2 approvals**
- Dismiss stale approvals
- Require approval of most recent reviewable push
- Require Code Owner reviews
- Require conversation resolution
- Require status checks (strict)
- Block force pushes, restrict deletions
- Enforce linear history

Operational rule: **No tooling may bypass these gates**, including AI agents. Any bypass capability is treated as an exception and must be recorded in the Exception and Decision Log (see [Documentation Policy](documentation-policy.md)) with risk and sunset date.

27. **At least one qualified reviewer** is required for non-trivial changes.
28. Reviewers MUST verify:

    * correctness
    * meaningful tests
    * no secrets or sensitive data
    * consistency with data, security, and documentation policies
29. **Review intent and design**, not formatting (formatting is automated).
30. **Reject PRs that mix concerns** (feature  refactor  formatting).
31. **All review conversations are resolved** before merge.

### 5.7 Merging strategy

32. **Default merge strategy: squash merge** (clean, linear history).
33. **Rebase  merge** MAY be used when preserving commit structure is valuable.
34. **Merge commits** MAY be used for release branches if they improve traceability.
35. **Never rebase shared branches** once review has started.
36. **Delete branches after merge.**

### 5.8 History rewriting

37. **Allowed locally before sharing** (interactive rebase).
38. **Forbidden on protected branches.**
39. **Force-push is restricted, audited, and never used on `main`.**

### 5.9 Versioning and releases

40. **Semantic Versioning (SemVer) is mandatory** unless explicitly exempted. See [Versioning and Release Policy](versioning-and-release-policy.md) for details.
41. **Git tags:**

    * Annotated tags only.
    * Tags are immutable.
42. **Releases are produced by CI**, never from local machines.
43. **Release artifacts must be traceable** to:

    * Git commit
    * CI run
    * dependency versions
44. **Changelog is maintained**, either manually or generated from commits. See [Versioning and Release Policy](versioning-and-release-policy.md) for changelog requirements.
45. **Hotfix releases increment patch versions** and follow the same CI path.

### 5.10 CI/CD integration

46. **CI runs on every PR**, at minimum:

    * lint / format
    * build
    * tests
47. **CI success is required for merge.**
48. **Fail fast.** Cheap checks first, expensive checks later.
49. **CI environments are reproducible** (clean checkout, pinned toolchains).

### 5.11 Pre-commit hooks (mandatory)

50. **All repos MUST use `pre-commit`.**
    Rationale: prevent avoidable failures (formatting drift, hidden characters, CRLF, etc.) before CI.

51. **Hooks are part of the repo.**

    * `.pre-commit-config.yaml` is committed at repo root.
    * Running hooks locally is required before pushing.

52. **Hooks must be deterministic** and aligned with CI:

    * CI runs the same checks as hooks (or a strict superset).
    * Hook versions are pinned.

53. **Minimum baseline hooks (required for new repos):**

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: end-of-file-fixer
      - id: trailing-whitespace
      - id: mixed-line-ending
        args: [--fix=lf]
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: detect-private-key
      - id: fix-byte-order-marker
      - id: check-added-large-files
        args: [--maxkb=10240]  # 10 MB default cap unless exempted

  # Optional but strongly recommended for Python repos
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.9
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  # Required for repos containing Claude Code skills (SKILL.md files)
  # See ai-workflow-policy.md Section "Claude Code Skills Management" for details
  - repo: local
    hooks:
      - id: skills-lint
        name: skills-lint
        entry: skills-lint
        language: node
        types: [text]
        files: SKILL\.md$
        pass_filenames: true
```

**Note:** The `skills-lint` hook is only required for repositories containing Claude Code skills (`SKILL.md` files). See [AI Workflow Policy](ai-workflow-policy.md) Section "Claude Code Skills Management" for installation, configuration, and rationale.

54. **Installation and usage (developer workstation):**

```bash
# once per machine
python -m pip install --user pre-commit

# once per repo
pre-commit install
pre-commit run --all-files
```

55. **Policy enforcement:**

    * PRs that fail hooks in CI are rejected.
    * Exceptions require an entry in the exception log with rationale and expiry date.

### 5.12 Issues and planning

56. **Issues track work, not conversations.**
57. **Each PR references an issue** unless truly trivial.
58. **Labels are standardized** (bug, feature, tech-debt, security).
59. **Milestones reflect reality**, not aspiration.
60. **Issues are closed via PRs** with explicit linkage.

### 5.13 Documentation and discoverability

61. **README.md explains:**

    * purpose of the repository
    * how to build and test
    * contribution workflow
62. **CONTRIBUTING.md** is required for externally visible repos.
63. **ARCHITECTURE.md** (or equivalent) is required for non-trivial systems.

### 5.14 Security practices

64. **Branch protection rules enabled.**
65. **Dependency and secret scanning enabled.** See [Security Policy](security-policy.md) for detailed security practices.
66. **Least-privilege access enforced.**
67. **Security fixes handled discreetly** until coordinated disclosure.

### 5.15 Windows dependencies and cross-platform constraints

68. **Windows Git and PATH requirements**

    * Use a Git distribution that provides `git` and standard tooling reliably (Git for Windows is typical).
    * Ensure `git` is available in `PATH` in the shell you use for development.
    * Avoid mixing shells unpredictably (PowerShell vs CMD vs Git Bash) inside the same repo workflow.

69. **Python on Windows**

    * Prefer the official Python install that provides the `py` launcher.
    * Recommended invocations:

      * `py -m pip install pre-commit`
      * `py -m pre_commit run --all-files`
    * If using `pipx`, ensure `pipx` binaries are on `PATH`.

70. **CRLF/LF policy (non-negotiable)**

    * Repo canonical is **LF** via `.gitattributes`.
    * Windows developers MUST configure Git to avoid accidental CRLF churn:

```bash
git config --global core.autocrlf false
git config --global core.eol lf
```

* If a repo is already polluted with mixed endings, normalize once:

```bash
git rm --cached -r .
git reset --hard
```

(Only do this as an intentional, reviewed change in a dedicated PR.)

71. **Editors must respect `.gitattributes`**
* Enable "use editorconfig / git attributes" behavior when available.
* If an editor insists on CRLF for `.sh` or `.yml`, that editor config is non-compliant.

72. **Executable bit and scripts**

    * On Windows, Git may not preserve Unix executable bits reliably in all workflows.
    * In repos that rely on executable scripts:

      * Prefer invoking via interpreter explicitly (e.g., `bash scripts/foo.sh`, `python scripts/foo.py`) in documentation and CI.
      * Keep `.sh` as `LF` always (CRLF breaks shebang).

73. **Windows path length**

    * Avoid deep nesting and long filenames.
    * If required, Windows users should enable long paths in OS policy and Git:

```bash
git config --global core.longpaths true
```

74. **Prohibited Windows anti-patterns**

    * Committing files with mixed EOL without a deliberate reason.
    * Using tools that inject zero-width / non-breaking spaces into source files.
    * Editing shell scripts in editors that silently convert LF → CRLF.

### 5.16 Large repositories and monorepos (if applicable)

75. **Clear ownership per area** via CODEOWNERS.
76. **Avoid cross-cutting PRs** unless necessary.
77. **Tooling must support partial builds/tests** to keep CI fast.

### 5.17 Explicit anti-patterns (forbidden)

78. Direct commits to `main`.
79. Mega-PRs touching unrelated areas.
80. Commit messages like "fix stuff", "WIP".
81. Merging broken builds "to fix later".
82. Force-pushing shared branches.
83. Using issues as chat logs.

### 5.18 Gold-standard checklist

84. Protected `main`, PR-only merges, CI required.
85. Standardized commits and merge strategy.
86. Small, focused PRs with clear descriptions.
87. Pre-commit installed and enforced; CI mirrors hooks.
88. Line endings standardized via `.gitattributes` and checked by hooks.
89. Releases are reproducible and traceable to CI artifacts.

### 5.19 Operational checklists (daily use)

This section exists to reduce mistakes by making the "happy path" explicit.

#### 5.19.1 Create a new repository/project (local-first)

1. **Create repo directory and initialize Git**

   ```bash
   mkdir -p <repo-name> && cd <repo-name>
   git init -b main
   ```

2. **Add baseline repo hygiene (minimum)**

   - `README.md`
   - `.gitignore`
   - `.gitattributes` (LF canonical)
   - `.pre-commit-config.yaml`

3. **Install and run hooks (mandatory)**

   ```bash
   pre-commit install
   pre-commit run --all-files
   ```

4. **Stage and commit (one coherent commit)**

   ```bash
   git add -A
   git commit -m "chore: initialize repo with pre-commit hygiene"
   ```

5. **Create remote and set upstream**

   ```bash
   git remote add origin <REMOTE_URL>
   git push -u origin main
   ```

#### 5.19.2 Modify an existing repository/project (standard workflow)

1. **Sync and verify current branch**

   ```bash
   git status
   git branch --show-current
   git pull --ff-only
   ```

2. **Make changes (small and focused)**

   - Keep changes scoped.
   - Do not mix formatting/refactors with features unless intentional and isolated.

3. **Run hooks before committing (mandatory)**

   ```bash
   pre-commit run --all-files
   ```

4. **Stage intentionally and commit with a Conventional Commits message**

   ```bash
   git add -A
   git commit -m "<type>: <concise change summary>"
   ```

5. **Push**

   ```bash
   git push
   ```

#### 5.19.3 "Push safety" quick checks (must pass before every push)

1. `git status` is clean (no surprises).
2. Hooks passed: `pre-commit run --all-files`.
3. You are pushing the intended branch: `git branch --show-current`.
4. You are not pushing secrets/binaries unintentionally (verify `git diff --stat`).

#### 5.19.4 JetBrains IDE hygiene (PyCharm / IntelliJ / WebStorm) — prevent invisible characters

Purpose: ensure the IDE never introduces hidden diffs (CRLF, BOM, trailing whitespace, missing EOF newline).

##### A) Mandatory IDE settings (do once)

1) **Trailing whitespace + EOF newline**
* Settings → Editor → General → **On Save**
  * **Remove trailing spaces on:** `All`
  * **Keep trailing spaces on caret line:** `OFF`
  * **Remove trailing blank lines at the end of saved files:** `ON`
  * **Ensure every saved file ends with a line break:** `ON`

2) **Encoding (UTF‑8, no BOM)**
* Settings → Editor → **File Encodings**
  * **Global Encoding:** `UTF-8`
  * **Project Encoding:** `UTF-8` (explicit, not "system default")
  * **Default encoding for properties files:** `UTF-8`
  * **Create UTF-8 files:** `with NO BOM`
  * **Transparent native-to-ascii conversion:** `OFF`

3) **Line endings (LF canonical) + EditorConfig**
* Settings → Editor → **Code Style** → General
  * **Line separator:** `Unix and macOS (\n)`
  * **Detect and use existing file indents for editing:** `OFF`
  * **Enable EditorConfig support:** `ON`

Operational rule:
* If the status bar shows **CRLF**, convert to **LF**.
* If the status bar shows **UTF‑8 with BOM**, convert to **UTF‑8** (no BOM).

##### B) Repo hard lock (required)

Add `.editorconfig` at repo root (committed):

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false
```

Then normalize once:

```bash
pre-commit run --all-files
git add .editorconfig
git commit -m "chore: add editorconfig for canonical whitespace and LF"
```

##### C) Commit / push discipline (Terminal-first)

* Preferred workflow: use the **Terminal tool window inside JetBrains**.
* Commit and push via CLI so hooks run exactly as expected:

```bash
git status
git add -p
git commit -m "type(scope): summary"
git push
```

#### 5.19.5 Git inside IDEs (VS Code + JetBrains) — daily workflow

This section defines the **IDE user workflow** for Git operations.
Policy priority remains **Terminal-first** (IDE UI is acceptable for visibility, but CLI is the source of truth).

##### 5.19.5.1 Initial configuration (new project OR existing repo)

**A) New project (create locally, then publish remote)**

1) Open the repo folder in your IDE
   * VS Code: File → Open Folder
   * JetBrains: Open

2) Verify the repo is initialized and on `main`:

```bash
git init -b main
git status
git branch --show-current
```

3) Add baseline hygiene files (required by policy):
- `.gitignore`
- `.gitattributes` (LF canonical)
- `.editorconfig`
- `.pre-commit-config.yaml`
- `README.md`

4) Install hooks + validate once:

```bash
pre-commit install
pre-commit run --all-files
```

5) First commit:

```bash
git add -A
git commit -m "chore: initialize repo with hygiene + pre-commit"
```

6) Add remote + push:

```bash
git remote add origin <REMOTE_URL>
git push -u origin main
```

**B) Existing project (already has Git and remote)**

1) Open the repo root folder (must contain `.git/`).

2) Sync safely:

```bash
git status
git pull --ff-only
```

3) Ensure you have hooks installed (mandatory per repo):

```bash
pre-commit install
```

Operational note:
- If hooks are not installed, IDE commits may bypass them. Fix this immediately.

##### 5.19.5.2 Adding / deleting files and folders (tracking changes)

Git change intent is expressed by **staging**.

**Principles**
- You stage only what you want to commit.
- Unstaged changes are "not yet approved for commit".

**In IDEs**
- **VS Code**: Source Control view
  - **Stage** (plus icon) = include in next commit
  - **Unstage** (minus icon) = exclude from next commit
  - Deleted files appear as **D** — stage them to confirm deletion
- **JetBrains**: Commit tool window
  - Tick checkbox next to file = stage/include
  - Untick = exclude
  - Deletions show as removed — tick to include

**Terminal reference (source of truth)**
- Stage specific files:

```bash
git add <path>
```

- Stage *everything* (use deliberately):

```bash
git add -A
```

- Stage selectively (recommended):

```bash
git add -p
```

- Unstage:

```bash
git restore --staged <path>
```

- Discard local changes (destructive):

```bash
git restore <path>
git clean -fd   # removes untracked files/dirs
```

##### 5.19.5.3 `pre-commit` — initial setup and usage

**Initial setup (per machine)**

```bash
python -m pip install --user pre-commit
```

**Enable hooks (per repo, mandatory)**

```bash
pre-commit install
```

**Run hooks**
- Whole repo (before PRs / important pushes):

```bash
pre-commit run --all-files
```

- Only staged files (fast path):

```bash
pre-commit run
```

**If a hook modifies files**
1) Inspect diffs.
2) Stage the changes.
3) Re-run hooks (until clean).

##### 5.19.5.4 Stage → commit → push (happy path)

1) Check what changed:

```bash
git status
git diff
```

2) Stage intentionally:

```bash
git add -p
```

3) Commit (Conventional Commits):

```bash
git commit -m "feat: <summary>"
```

4) Push:

```bash
git push
```

**IDE workflow**
- It is acceptable to use IDE UI for commit message editing and viewing diffs.
- Still prefer **push via Terminal** to keep behavior identical everywhere.

##### 5.19.5.5 Pick up a remote branch (checkout / pull)

Typical goal: someone created a branch remotely and you want it locally.

```bash
git fetch --prune
git switch <branch>
```

If branch exists only remotely:

```bash
git fetch --prune
git switch -c <branch> --track origin/<branch>
```

Then sync:

```bash
git pull --ff-only
```

**IDE hints**
- VS Code: Source Control → `…` → Branch → Checkout to…
- JetBrains: Git widget (bottom right) → Remote Branches → Checkout

Operational rule:
- Always `fetch` before switching; avoid stale references.

##### 5.19.5.6 Merge conflicts (resolution protocol)

Conflicts MUST be resolved **carefully and deliberately**. Never "accept all" blindly.

**A) First response**
1) Stop and inspect:

```bash
git status
git diff
```

2) Identify conflicting files:

```bash
git diff --name-only --diff-filter=U
```

**B) Resolve**
- Preferred: resolve in IDE merge tool.
  - VS Code: "Resolve in Merge Editor"
  - JetBrains: 3-way merge tool

Rules:
- Preserve intent: compare both branches and the base.
- If unsure, abort merge and re-plan.

**C) Mark as resolved**
After editing:

```bash
git add <conflicted-files>
```

**D) Complete merge**
- If you are merging:

```bash
git commit
```

- If you were rebasing:

```bash
git rebase --continue
```

**E) Safety escapes**
- Abort merge:

```bash
git merge --abort
```

- Abort rebase:

```bash
git rebase --abort
```

**F) Final validation**
Run hooks and tests:

```bash
pre-commit run --all-files
# run project tests here
```

Then push.

##### 5.19.5.7 Professional daily operations (amend, fixup, stash, revert, rebase)

These operations are common in professional teams and prevent messy histories and risky "panic Git".

###### A) Rebase discipline: clean history without accidental merge commits

**Rules**
- On `main`: keep history linear; use fast-forward only.
- On feature branches: prefer rebase to keep your branch up to date.

**Commands**
- Update local refs first:

```bash
git fetch --prune
```

- On `main`:

```bash
git switch main
git pull --ff-only
```

- On feature branch (recommended):

```bash
git switch <feature-branch>
git pull --rebase
```

If conflicts happen during rebase:

```bash
git status
# fix conflicts
git add <files>
git rebase --continue
# or abort
git rebase --abort
```

Operational rule:
- Avoid IDE "Pull" actions that default to merge commits unless they are explicitly configured for rebase/ff-only.

###### B) Amend + fixup: keep commits clean

**Amend (edit last commit)**
Use this when you forgot a file, need to tweak message, or fix small issues *before pushing*.

```bash
git add -A
git commit --amend
```

**Fixup commits (best practice for PR polish)**
When you want to record progress but later auto-squash into a prior commit:

```bash
git commit --fixup <commit-hash>
git rebase -i --autosquash origin/main
```

IDE mapping:
- JetBrains has "Amend" and interactive rebase tooling built in.
- VS Code supports amend and interactive rebase via Source Control / Command Palette.

###### C) Stash: safe context switching

Use stash when you must switch branches but your working tree is not ready to commit.

```bash
git stash push -u -m "wip: <short note>"
git switch <other-branch>
```

Restore:

```bash
git stash list
git stash pop    # applies and drops
# or
git stash apply  # applies and keeps
```

If stash creates conflicts, resolve like normal conflicts, then stage + continue work.

###### D) Rename / move discipline

Preferred behavior:
- Perform file moves/renames **inside the IDE** to keep imports/references consistent.
- Confirm Git sees it as a rename (not delete + add):

```bash
git status
git diff --name-status
```

Then stage:

```bash
git add -A
```

###### E) Safe undo: revert (shared history safe)

**Never rewrite history that has already been pushed and shared**, unless you *know* it is safe.

Preferred safe undo on shared branches:

```bash
git revert <commit-hash>
git push
```

Avoid on pushed branches:
- `git reset --hard`
- force pushing (`--force`) unless explicitly required and coordinated

###### F) Commit signing (optional, but professional-grade)

If your team expects "Verified" commits, configure signing:
- GPG signing OR SSH commit signing (GitHub-supported)

Policy guidance:
- Enable if required by target employers/teams.
- If not required, don't block progress; it can be added later.

###### G) PR hygiene (IDE or CLI)

Before opening or updating a PR:
1) Sync your branch:

```bash
git fetch --prune
git pull --rebase
```

2) Validate quality gates:

```bash
pre-commit run --all-files
# run project tests here
```

3) Keep PRs small and coherent; avoid mixing unrelated changes.

---

## 6) Coding style policy (language standards)

### 6.1 Universal conventions
- LF line endings
- UTF-8
- final newline
- no trailing whitespace
- consistent indentation per language

Enforced by `.editorconfig`.

### 6.2 Python
Standard:
- PEP 8
- Black formatting
- Ruff linting
- type hints encouraged

For **Python projects**:

1) **Directory and file naming convention**
- **Directories:** `lowercase_with_underscores`
- **Code files that are imported/executed:** `lowercase_with_underscores`
- **No hyphens** in any path referenced by tooling (imports, scripts, configs)

2) **Reserved exceptions (must not rename)**
- Tool-standard filenames (e.g., `.gitignore`, `pyproject.toml`, `package.json`, lockfiles, etc.).

3) **Enforcement mechanism**
- **Not enforceable via `.editorconfig`.**
- Enforced via `pre-commit` + CI gate: *No hyphens in repo paths (except approved exceptions).*

### 6.3 JavaScript/TypeScript/HTML/CSS/YAML/Markdown/JSON
Standard:
- Prettier formatting
- ESLint linting
- strict TypeScript recommended for serious repos

### 6.4 Java
Standard:
- google-java-format
- IntelliJ optimize imports
- Checkstyle optional

### 6.5 C/C++/CUDA
Standard:
- clang-format
- clang-tidy
- warnings-as-errors in CI for serious repos

### 6.6 Bash
Standard:
- Google Shell Style conventions
- ShellCheck linting
- `set -euo pipefail` in scripts by default

### 6.7 SQL
Standard:
- explicit JOINs
- avoid `SELECT *` in production queries
- consistent formatting via DataGrip

---

## 7) Testing Policy

**See:** [Testing Policy](testing-policy.md) for comprehensive testing standards covering test classification, language-specific policies, CI/CD integration, coverage requirements, test data management, and enforcement.

---


### 8.1 Minimum documentation
Every repo must contain:
- `README.md` with:
  - purpose
  - prerequisites
  - setup instructions
  - how to run tests
  - how to format/lint

For non-trivial systems:
- `docs/architecture.md` (high-level)
- `docs/dev-notes.md` (practical notes)

### 8.2 Developer ergonomics
Add a “Quick start” section at the top of README with copy-paste commands.

---

## 9) IDE policies (repo-level settings)

### 9.1 VS Code workspace settings
Commit only team-safe settings at:
- `.vscode/settings.json`

Recommended baseline:
- format on save
- Prettier default formatter
- ESLint autofix on save
- indentation = 2 for web formats

### 9.2 PyCharm formatting enforcement
- Actions on Save: Reformat, Optimize imports, Run Black
- If “Run Black disabled”, install Black in the project interpreter:
  ```bash
  python -m pip install black
  ```

### 9.3 IntelliJ
- enable google-java-format
- Actions on Save: Reformat + Optimize imports

### 9.4 CLion
- enforce `.clang-format`
- clang-tidy enabled

### 9.5 WebStorm (JavaScript/TypeScript/Web projects)

**Initial configuration (one-time per project):**

1. **Prettier setup:**
   - Settings → Languages & Frameworks → JavaScript → Prettier
   - Configuration mode: **AUTOMATIC** (use `.prettierrc` or `prettier.config.js` in repo)
   - **Run on save:** ✅ enabled

2. **ESLint setup:**
   - Settings → Languages & Frameworks → JavaScript → Code Quality Tools → ESLint
   - **Automatic ESLint configuration:** enabled
   - **Fix on save:** ✅ enabled

3. **EditorConfig:**
   - Settings → Editor → Code Style → Enable EditorConfig support: ✅ enabled

4. **Inspections:**
   - Settings → Editor → Inspections
   - ESLint: enabled at **WARNING** level (enabled by default in Project Default profile)

5. **Actions on Save:**
   - Settings → Tools → Actions on Save
   - ✅ **Reformat code**
   - ✅ **Optimize imports**
   - **Run Prettier:** handled by Prettier "Run on save" setting

**Project default settings (via `.idea/` or default project configuration):**
- PrettierConfiguration: `mode: AUTOMATIC`, `runOnSave: true`
- EslintConfiguration: `fixOnSave: true`
- InspectionProjectProfileManager: ESLint enabled

**Repo-level settings (commit `.idea/` selectively):**
- Commit: `.idea/codeStyles/` (if custom code style needed)
- **Do NOT commit:** `.idea/workspace.xml`, `.idea/tasks.xml`, or user-specific settings
- **Do commit:** `.idea/inspectionProfiles/Project_Default.xml` (if ESLint/Prettier settings differ from default)

### 9.6 DataGrip
- configure SQL formatting and dialects
- avoid noisy formatting commits unless needed

---

## 10) Quality gates (what must pass)

Before push / PR:
```bash
pre-commit run --all-files
# run tests
```

CI must run:
- pre-commit hooks
- tests
- build

---

## 11) Standard bootstrap checklist (copy/paste)

**NEW repo**
1) create repo + files: `.editorconfig`, `.pre-commit-config.yaml`, README
2) `git init -b main`
3) `pre-commit install`
4) `pre-commit run --all-files`
5) first commit + push

**OLD repo**
1) `git pull --ff-only`
2) `pre-commit install`
3) `pre-commit run --all-files`
4) run tests

---

End of policy.


---

# Part B — Engineering Tooling & Workflow Policies (merged)

# Engineering Tooling & Workflow Policies

> Authoritative, enforceable conventions for professional software teams
> Scope: local development, CI/CD, production readiness, and AI-assisted work
> CI authority (merge gating, bypass rules, enforcement) is defined exclusively in
This policy's Git and Source Control section (Section 5). This document describes tooling and workflow,
not merge authority.


**Last updated:** 2026-01-16

---

## Index

**Language-Specific Policies:**
- See [Language Policies](language-policies.md) for Python, TypeScript/Node.js, Java, C/C++, Rust, and CUDA standards

**Web Technologies:**
- See [Web Policies](web-policies.md) for API design (REST/gRPC), JavaScript/React, and HTML/CSS standards

**Infrastructure:**
- See [Infrastructure Policy](infrastructure-policy.md) for Docker/Podman, Kubernetes, and Kafka standards

**ML/CV Operations:**
- See [ML/CV Operations Policy](ml-cv-operations-policy.md) for ML/CV-specific operations

---
