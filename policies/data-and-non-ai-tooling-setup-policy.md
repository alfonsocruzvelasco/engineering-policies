# Engineering Policies for production

**Status:** Authoritative
**Last updated:** 2026-01-18
**Purpose:** Daily reference for CV/ML engineering, data systems, and tooling standards

---

## 📋 Complete Table of Contents

### 🚀 Getting Started
- [How to Use This Document](#how-to-use-this-document)
- [Quick Reference Cards](#quick-reference-cards)
  - [QRC-1: New Python Project](#qrc-1-new-python-project-setup)
  - [QRC-2: Dataset Snapshot](#qrc-2-dataset-snapshot-creation)
  - [QRC-3: SQL Schema for CV/ML](#qrc-3-sql-schema-pattern-for-cvml)
  - [QRC-4: Docker Multi-Stage Build](#qrc-4-docker-multi-stage-build)
  - [QRC-5: Git Commits](#qrc-5-git-commit-template)
  - [QRC-6: Kubernetes Deployment](#qrc-6-kubernetes-deployment)
  - [QRC-7: Pytest Setup](#qrc-7-pytest-configuration)
  - [QRC-8: React Component](#qrc-8-react-component-pattern)
  - [QRC-9: TypeScript Project](#qrc-9-typescript-project-setup)
  - [QRC-10: Kafka Patterns](#qrc-10-kafka-patterns)
- [Decision Trees](#decision-trees)
  - [DT-1: Data Storage Selection](#dt-1-data-storage-decision-tree)
  - [DT-2: Testing Strategy](#dt-2-testing-strategy-selection)
  - [DT-3: Docker vs Podman](#dt-3-docker-vs-podman)
  - [DT-4: SQL Engine Selection](#dt-4-sql-engine-selection)
- [Common Scenarios](#common-scenarios)
  - [Scenario 1: New CV/ML Project](#scenario-1-new-cvml-project)
  - [Scenario 2: Dataset Migration](#scenario-2-dataset-migration)
  - [Scenario 3: Kafka Pipeline](#scenario-3-kafka-pipeline)

### 📊 1. Data & Storage
- [1.1 Core Principles](#11-core-principles)
- [1.2 Storage Systems](#12-storage-systems)
- [1.3 Raw Data Rules](#13-raw-data-rules)
- [1.4 Derived Data](#14-derived-data-rules)
- [1.5 Immutability](#15-immutability-policy)
- [1.6 Dataset Snapshots](#16-dataset-snapshot-policy)
- [1.7 Object Identity](#17-object-identity)
- [1.8 Formats](#18-formats-policy)
- [1.9 Retention](#19-retention-and-lifecycle)
- [1.10 Performance](#110-access-and-performance)
- [1.11 What Never Goes in SQL](#111-what-never-goes-in-sql)
- [1.12 Exceptions](#112-exceptions-process)

### 🗄️ 2. SQL Databases
- [2.1 SQL in CV/ML](#21-sql-in-cvml-architectures)
- [2.2 Schema Design](#22-schema-design-principles)
- [2.3 Normalization](#23-normalization)
- [2.4 Primary Keys](#24-primary-keys-and-identity)
- [2.5 Foreign Keys](#25-foreign-keys-and-constraints)
- [2.6 Indexes](#26-indexes-and-performance)
- [2.7 Query Patterns](#27-query-patterns)
- [2.8 Transactions](#28-transactions-and-isolation)
- [2.9 Migrations](#29-migrations-and-schema-evolution)
- [2.10 Security](#210-sql-security)
- [2.11 Operations](#211-operational-rules)
- [2.12 Engine-Specific](#212-engine-specific-guidance)
  - [MySQL](#2121-mysql)
  - [PostgreSQL](#2122-postgresql)
  - [SQLite](#2123-sqlite)

### 🐍 3. Python
- [3.1 Project Structure](#31-project-structure)
- [3.2 Environment Management](#32-environment-management)
- [3.3 Dependencies](#33-dependency-management)
- [3.4 Code Style](#34-code-style-and-formatting)
- [3.5 Type Hints](#35-type-hints-and-validation)
- [3.6 Error Handling](#36-error-handling)
- [3.7 Logging](#37-logging-and-debugging)
- [3.8 Testing](#38-testing-standards)
- [3.9 Performance](#39-performance-and-optimization)
- [3.10 ML/CV Specific](#310-mlcv-specific-rules)
- [3.11 Anti-Patterns](#311-anti-patterns-to-avoid)

### 📘 4. TypeScript
- [4.1 Project Setup](#41-project-setup)
- [4.2 Type System](#42-type-system-discipline)
- [4.3 Organization](#43-code-organization)
- [4.4 Error Handling](#44-error-handling)
- [4.5 Async](#45-async-patterns)
- [4.6 Testing](#46-testing)
- [4.7 Tooling](#47-build-and-tooling)

### ⚛️ 5. React
- [5.1 Components](#51-component-architecture)
- [5.2 State](#52-state-management)
- [5.3 Hooks](#53-hooks-rules)
- [5.4 Performance](#54-performance)
- [5.5 Testing](#55-testing)
- [5.6 Accessibility](#56-accessibility)

### 🟢 6. Node.js
- [6.1 Structure](#61-project-structure)
- [6.2 Dependencies](#62-dependencies)
- [6.3 Errors](#63-error-handling)
- [6.4 Async](#64-async-patterns)
- [6.5 Security](#65-security)
- [6.6 Performance](#66-performance)

### 🎨 7. CSS/HTML
- [7.1 HTML Semantics](#71-html-semantic-structure)
- [7.2 CSS Architecture](#72-css-architecture)
- [7.3 Layout](#73-layout-systems)
- [7.4 Design Tokens](#74-design-tokens)
- [7.5 Typography](#75-typography)
- [7.6 Accessibility](#76-accessibility)
- [7.7 Naming](#77-naming-conventions)
- [7.8 Responsive](#78-responsiveness-and-media)
- [7.9 Performance](#79-performance)
- [7.10 Forms/UI](#710-forms-and-ui-states)

### 🔧 8. Git
- [8.1 Branching](#81-branching-strategy)
- [8.2 Commits](#82-commit-standards)
- [8.3 Merge/Rebase](#83-merge-and-rebase)
- [8.4 Repo Structure](#84-repository-structure)
- [8.5 Hygiene](#85-git-hygiene)

### 🐙 9. GitHub
- [9.1 Pull Requests](#91-pull-request-workflow)
- [9.2 Code Review](#92-code-review-standards)
- [9.3 Issues](#93-issue-management)
- [9.4 Branch Protection](#94-branch-protection)
- [9.5 CI/CD](#95-cicd-integration)

### 🧪 10. Testing
- [10.1 Testing Pyramid](#101-testing-pyramid)
- [10.2 Unit Tests](#102-unit-testing)
- [10.3 Integration](#103-integration-testing)
- [10.4 E2E](#104-end-to-end-testing)
- [10.5 Test Data](#105-test-data-management)
- [10.6 Coverage](#106-coverage-and-quality-gates)

### 📝 11. Documentation
- [11.1 README](#111-readme-requirements)
- [11.2 API Docs](#112-api-documentation)
- [11.3 Comments](#113-code-comments)
- [11.4 Architecture](#114-architecture-docs)
- [11.5 Runbooks](#115-runbooks-and-playbooks)

### 🐳 12. Docker/Podman
- [12.1 Principles](#121-container-principles)
- [12.2 Dockerfiles](#122-dockerfile-standards)
- [12.3 Images](#123-image-management)
- [12.4 Security](#124-security)
- [12.5 Podman-Specific](#125-podman-specific-rules)

### ☸️ 13. Kubernetes
- [13.1 Manifests](#131-manifest-management)
- [13.2 Workloads](#132-workload-types)
- [13.3 Configuration](#133-configuration)
- [13.4 Networking](#134-networking-and-security)
- [13.5 Observability](#135-observability)
- [13.6 Resources](#136-resource-management)

### 📨 14. Kafka
- [14.1 Topics](#141-topic-management)
- [14.2 Producers](#142-producer-patterns)
- [14.3 Consumers](#143-consumer-patterns)
- [14.4 Schemas](#144-schema-management)
- [14.5 Operations](#145-operations-and-monitoring)

### 📚 Appendices
- [Appendix A: Acronyms](#appendix-a-acronyms-and-glossary)
- [Appendix B: Decision Matrix](#appendix-b-technology-decision-matrix)
- [Appendix C: Checklists](#appendix-c-compliance-checklists)
- [Appendix D: Exception Log Template](#appendix-d-exception-and-decision-log-template)
- [Appendix E: Enforcement](#appendix-e-enforcement-and-automation)

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

**See also:** [Python §3.1](#31-project-structure), [Git §8.2](#82-commit-standards), [Testing §10.2](#102-unit-testing)

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

**See also:** [Data §1.6](#16-dataset-snapshot-policy), [Data §1.7](#17-object-identity), [Python §3.10](#310-mlcv-specific-rules)

---

---

# Unified Engineering Policies — Data/Artifacts/SQL + Projects/Tooling Setup

**Status:** Authoritative
**Last updated:** 2026-01-16

---

## Table of contents (clickable)

- [Document 1 — Data, Artifacts, and SQL Policy](#document-1--data-artifacts-and-sql-policy)

- [Document 2 — Projects and Tooling Setup Policy](#document-2--projects-and-tooling-setup-policy)


---

## Document 1 — Data, Artifacts, and SQL Policy
<a id="document-1--data-artifacts-and-sql-policy"></a>


# Data, Artifacts, and SQL Policy (CV/ML)

**Status:** Authoritative
**Last updated:** 2026-01-16

This policy defines how **data and heavy artifacts** are stored, referenced, versioned, and made reproducible for CV/ML work, and how **SQL systems** are used as the authoritative metadata layer in that stack.

---

## Acronyms

* **CV** — Computer Vision
* **ML** — Machine Learning
* **SQL** — Structured Query Language
* **WORM** — Write Once, Read Many

---

## Part A — Data and artifacts policy

### 1) Core principle

**Object storage is the source of truth for large blobs**, including:

* Images, videos, point clouds, tensors, embeddings
* Model checkpoints and large binary artifacts

**SQL stores meaning**, including:

* Dataset membership, splits, labels, lineage, provenance, experiment metadata
* Object references (URIs), hashes, and versions — never inferred

**Key principle**:

> **Blobs live in object storage. Meaning, relationships, and history live in SQL.**

---

### 2) Storage systems

Approved object storage classes:

* Cloud: S3 / GCS / Azure Blob
* Self-hosted: S3-compatible stores (e.g., MinIO)

Filesystems (POSIX) MAY be used for:

* Local development caches
* Ephemeral intermediates not used for training or evaluation baselines

---

### 3) Rules for raw data

* Raw sensor logs are **append-only**.
* Raw data MUST be ingested into a **raw zone** with immutability controls.
* Any privacy/safety redactions MUST occur before promoting to curated datasets.

---

### 4) Rules for derived data

Derived artifacts (frames, clips, sweeps, tensors, features) MUST:

* Be produced from an identified upstream source (lineage)
* Have deterministic build parameters recorded (code version + config + toolchain)
* Be stored as objects and referenced immutably

---

### 5) Immutability policy

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

### 6) Dataset snapshot policy

A dataset used for training/evaluation MUST be a snapshot defined by:

* A **manifest** (explicit list of sample IDs and object references)
* A version identifier (dataset version)
* A content hash of the manifest

Directory scanning MUST NOT define dataset membership.

---

### 7) Identity for objects

Every stored object MUST be uniquely identified by:

* `(store, bucket, key, version/generation, content_hash)`

The database MUST store these fields (or an equivalent normalized schema).

---

### 8) Formats policy

#### For training IO (streaming-friendly)

* WebDataset shards (tar) are RECOMMENDED for high-throughput GPU training.
* TFRecord is acceptable for TensorFlow-centric pipelines.

#### For analytics / indexing

* Parquet is RECOMMENDED for offline analytics and scenario mining.
* CSV is permitted only when schema-defined and validated.

---

### 9) Retention and lifecycle

* Raw zone retention is defined by compliance and cost; default is long-lived.
* Curated and derived artifacts MUST have explicit lifecycle policies (TTL) unless they are part of a released baseline.
* Any deletion MUST be traceable and logged, with a reversible plan where feasible.

---

### 10) Access and performance

* Training pipelines SHOULD use sharding, caching, and prefetching.
* Avoid small-object explosions; prefer shard files at predictable sizes.
* Always record IO performance metrics when scaling training.

---

### 11) What never goes in SQL

SQL databases MUST NOT store:

* Raw image/video payloads
* Large point clouds or tensors
* Model binaries

Store only references, hashes, and metadata.

---

### 12) Exceptions

Any deviation from this policy requires:

* A written justification in `exception-and-decision-log.md`
* Risk classification (Low/Medium/High)
* Mitigation steps and a sunset date

---

## Part B — SQL / MySQL / PostgreSQL / SQLite (within the CV/ML data stack)

<a id="sql"></a>

# SQL / MySQL / PostgreSQL / SQLite

This section defines professional, enforceable rules for working with **SQL as a language** and with the most common relational engines: **Standard SQL**, **MySQL**, **PostgreSQL**, and **SQLite**.

Scope: schema design, queries, migrations, performance, correctness, and operational safety — within modern data-intensive systems, including CV/ML engineering.

## 0) SQL in modern CV / ML data architectures (context)

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

## 1) Core principles (engine-agnostic)

1. SQL is a programming language. It is reviewed, tested, versioned, and reasoned about like any other code.
2. Correctness before cleverness. Readable, explicit queries beat compact or “smart” SQL.
3. Determinism is mandatory. Query results must not depend on undefined ordering, implicit casts, or engine quirks.
4. Schema is a contract. Tables, constraints, and indexes define guarantees—not suggestions.
5. The database is not a dumping ground. Data integrity lives in the database, not only in application code.

## 2) Standard SQL discipline (portable subset)

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

## 3) Schema design rules (all engines)

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

## 4) Query writing standards

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

## 5) Indexing and performance discipline

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

## 6) Migrations and schema evolution

35. Schema changes are versioned:

    * migrations live in source control.
36. Migrations are forward-only in production.
37. Destructive changes are staged:

    * add column → backfill → switch reads → drop old column.
38. Migrations are idempotent or safely repeatable where tooling allows.
39. No manual production changes outside migrations.
40. Rollback strategy is documented (even if rollback is “restore from backup”).

## 7) Transactions and concurrency

41. Transactions are explicit for multi-step operations.
42. Isolation level is understood and chosen deliberately:

    * do not assume defaults are correct.
43. No long-running transactions holding locks without justification.
44. SELECT … FOR UPDATE is used intentionally, never casually.
45. Deadlocks are anticipated and handled in application logic where needed.

## 8) Engine-specific rules — MySQL

46. InnoDB is mandatory (no MyISAM).
47. ONLY_FULL_GROUP_BY is enabled and treated as baseline correctness.
48. Character set and collation are explicit (`utf8mb4`).
49. AUTO_INCREMENT is not used as business logic.
50. Boolean columns use `BOOLEAN` / `TINYINT(1)` consistently, documented.
51. Date/time behavior is tested with timezone differences.
52. LIMIT without ORDER BY is forbidden (MySQL is especially permissive and dangerous here).

## 9) Engine-specific rules — PostgreSQL

53. PostgreSQL is the reference engine for advanced SQL features when available.
54. Use native types:

    * `UUID`, `JSONB`, `ARRAY`, `ENUM` (with discipline).
55. CTEs (`WITH`) are used for clarity, not assumed to be free (materialization is understood).
56. Indexes types are chosen deliberately:

    * B-tree, GIN, GiST, BRIN as appropriate.
57. Extensions are documented (`pgcrypto`, `uuid-ossp`, etc.).
58. Explain plans are reviewed with ANALYZE, not guessed.

## 10) Engine-specific rules — SQLite

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

## 11) Security rules (SQL)

65. Parameterized queries only.
66. No string concatenation for SQL, ever.
67. Least-privilege database users:

    * read-only where possible
    * no superuser for apps.
68. No credentials in source control.
69. Audit logging for sensitive operations where required.
70. Encryption at rest and in transit is policy-driven and documented.

## 12) Testing and verification

71. Queries are testable artifacts:

    * unit tests for logic
    * integration tests against real engines where possible.
72. Test data is representative, not trivial.
73. Edge cases are tested:

    * NULLs
    * empty sets
    * boundary dates.
74. Performance-sensitive queries have regression tests or benchmarks.

## 13) Tooling and workflow

75. SQL formatting is standardized (formatter enforced).
76. Linting/static checks used where available.
77. Migrations run in CI against a clean database.
78. Local dev mirrors production engine behavior as closely as possible.
79. Explain plans are captured for critical queries in docs or PRs.

## 14) Common anti-patterns to ban

80. `SELECT *` in production queries.
81. Missing primary keys.
82. Relying on implicit ordering.
83. Application-only referential integrity.
84. Unbounded TEXT columns for structured data.
85. Silent schema drift.
86. Ad hoc indexes added “just in prod.”
87. Mixing SQL dialects without documentation.

## 15) Minimal “gold standard” checklist

88. Schema has PKs, FKs, constraints.
89. Queries are explicit, ordered, and readable.
90. Migrations are versioned and CI-enforced.
91. Indexes align with real queries.
92. Parameterized queries everywhere.
93. Engine-specific behavior is documented.
94. Performance changes backed by evidence.


---

## Document 2 — Projects and Tooling Setup Policy
<a id="document-2--projects-and-tooling-setup-policy"></a>


# Engineering Tooling, Workflow, Bootstrap & Quality Policy

**Status:** Authoritative
**Last updated:** 2026-01-16
Scope: local development, repo initialization, CI/CD readiness, production hygiene, and AI-assisted work
Note: CI authority (merge gating, bypass rules, enforcement) is defined exclusively in `git-and-source-control-policy.md`. This policy defines tooling + workflow conventions.

---

## Document intent

This file is the **single source of truth** merging:
1) **Project Bootstrap & Engineering Quality Policy**
2) **Engineering Tooling & Workflow Policies**

Nothing from either source has been removed; content is reorganized so it is easier to maintain as one document.

---

## Table of contents (clickable)

- [Part A — Bootstrap & Quality (repo-first)](#part-a--project-bootstrap--engineering-quality-policy-merged)
  - [Purpose](#purpose)
  - [Engineering principles](#engineering-principles)
  - [Machine setup (one-time)](#machine-setup-one-time)
  - [Repo initialization (new project)](#repo-initialization-new-project)
  - [Repo opening (existing project)](#repo-opening-existing-project)
  - [Git workflow (daily operations)](#git-workflow-daily-operations)
  - [Coding style (language standards)](#coding-style-language-standards)
  - [Testing policy](#testing-policy)
  - [Documentation policy](#documentation-policy)
  - [IDE policies (repo-level settings)](#9-ide-policies-repo-level-settings)
    - [9.1 VS Code workspace settings](#91-vs-code-workspace-settings)
    - [9.2 PyCharm formatting enforcement](#92-pycharm-formatting-enforcement)
    - [9.3 IntelliJ](#93-intellij)
    - [9.4 CLion](#94-clion)
    - [9.5 WebStorm (JavaScript/TypeScript/Web projects)](#95-webstorm-javascripttypescriptweb-projects)
    - [9.6 DataGrip](#96-datagrip)
  - [Quality gates](#quality-gates)
  - [Standard bootstrap checklist](#standard-bootstrap-checklist)

- [Part B — Tooling & Workflow (language/tool deep policies)](#part-b--engineering-tooling--workflow-policies-merged)
  - [Python (.venv & dependency discipline)](#python-venv--dependency-discipline)
  - [Node.js / npm / TypeScript](#nodejs--npm--typescript)
  - [Java / Maven / Gradle / Spring Boot](#java--maven--gradle--spring-boot)
  - [C / C++ / CMake](#c--c--cmake)
  - [Rust / Cargo](#rust--cargo)
  - [CUDA / OpenCV / OpenGL](#cuda--opencv--opengl)
  - [API / REST / MVC / gRPC](#api--rest--mvc--grpc)
  - [Vanilla JavaScript / React / WebGL / D3](#vanilla-javascript--react--webgl--d3)
  - [HTML / CSS](#html--css)
  - [Docker / Podman / Kubernetes / Kafka](#docker--podman--kubernetes--kafka)

---


# Part A — Project Bootstrap & Engineering Quality Policy (merged)

# Project Bootstrap & Engineering Quality Policy

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

## 5) Git workflow policy (VS Code + JetBrains)

### 5.1 Change tracking: stage = approval
- Stage only what you intend to commit.
- Unstaged changes are not approved.

Recommended staging:
```bash
git add -p
```

Unstage:
```bash
git restore --staged <path>
```

### 5.2 Stage → commit → push
```bash
git status
git diff
git add -p
git commit -m "feat: <summary>"
git push
```

### 5.3 Branching standard
- `main` is always green and protected.
- Work happens on feature branches:
  - `feat/<topic>`
  - `fix/<topic>`
  - `chore/<topic>`

Create branch:
```bash
git switch -c feat/<topic>
```

### 5.4 Picking up remote branches
```bash
git fetch --prune
git switch -c <branch> --track origin/<branch>
```

### 5.5 Pull policy
- On `main`: **fast-forward only**
```bash
git pull --ff-only
```

- On feature branches: **rebase**
```bash
git pull --rebase
```

### 5.6 Amend / fixup (professional hygiene)
Amend last commit (before push):
```bash
git add -A
git commit --amend
```

Fixup workflow:
```bash
git commit --fixup <hash>
git rebase -i --autosquash origin/main
```

### 5.7 Merge conflicts protocol
1) Inspect:
```bash
git status
git diff --name-only --diff-filter=U
```

2) Resolve in IDE merge tool (preferred), then:
```bash
git add <files>
git commit
```

Abort if needed:
```bash
git merge --abort
git rebase --abort
```

### 5.8 Safe undo
Preferred for shared branches:
```bash
git revert <hash>
```

Avoid rewriting shared history:
- `git reset --hard`
- force push (`--force`) unless explicitly coordinated

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

## 7) Testing policy

### 7.1 Principles
- Tests are required for anything non-trivial.
- Every bug fix must include a regression test when feasible.
- Prefer small, fast unit tests + minimal integration tests.

### 7.2 Python
Tooling:
- `pytest`
- coverage optional (`pytest-cov`)

Rules:
- tests in `tests/`
- deterministic tests (no randomness unless seeded)

### 7.3 JavaScript/TypeScript
Tooling:
- `vitest` or `jest`
- `supertest` for API testing

Rules:
- unit tests for business logic
- integration tests for API boundaries

### 7.4 Java
Tooling:
- JUnit 5
- Mockito
- Spring Boot test slices

Rules:
- do not overmock
- integration tests for Kafka boundaries when relevant

### 7.5 C/C++
Tooling:
- GoogleTest (C++) or simple assertion-based harness (C)
- sanitize builds recommended (ASan/UBSan) for critical code

---

## 8) Documentation policy

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
`git-and-source-control-policy.md`. This document describes tooling and workflow,
not merge authority.


**Last updated:** 2026-01-16

---

## Index

1. [Python (.venv & dependency discipline)](#python)
2. [Node.js / npm / TypeScript](#nodenpmtypescript)
3. [Java / Maven / Gradle / Spring Boot](#javamavengradlespingspring-boot)
4. [C / C++ / CMake](#cccmake)
5. [Rust / Cargo](#rustcargo)
6. [CUDA / OpenCV / OpenGL](#cudaopencvopengl)
7. [API / REST / MVC / gRPC](#apirest)
8. [Vanilla JavaScript / React / WebGL / D3](#vanilla-javascript-es2020reactwebgld3)
9.  [HTML / CSS](#htmlcss)
10. [Docker / Podman / Kubernetes / Kafka](#dockerpodmankuberneteskafka)

---

# Python

## 0) Scope and intent

This section governs **Python application and library repositories** using virtual environments (`venv`) and modern dependency tooling.
It applies equally to local development, CI, and production builds.

## 1) Core principles

1. **Reproducibility over convenience.** Anyone must be able to recreate the exact environment from source control, not from a copied folder.
2. **Environments are disposable.** A venv is a build artifact; delete/recreate is normal.
3. **One project, one environment.** No shared “mega-venv” across unrelated repos.
4. **Pin what matters.** Lock dependencies for deterministic installs in CI and production.
5. **Keep secrets out.** No credentials inside venv configs, activation scripts, or `.env` files committed to Git.

## 2) Where the venv lives (and naming)

6. **Do not commit the venv.** Always ignore it in Git (`.venv/`, `venv/`, `.python-version` may be committed if you use pyenv; the interpreter itself never is).
7. **Virtual environment location is defined by `system-dev-env-policy.md`.**
8. In this environment:
   * Each project has exactly one venv.
   * All venvs live under:
     `~/dev/venvs/<project-name>/`
   * Virtual environments are **never** created inside repositories.

9. Repository-local `.venv/` directories are not used in this system.

## 3) Python version discipline

10. **Pin the Python version.** Use one of:

    * `pyproject.toml` classifiers / requires-python,
    * `.python-version` (pyenv),
    * CI matrix definition.
11. **CI is the source of truth** for supported versions; developers must match it locally.
12. **No system Python modification.** Never `sudo pip install ...` into system Python.
13. **Upgrade policy:** Python minor upgrades (3.11 → 3.12) are planned, tested in CI, then rolled out—not ad hoc.

## 4) Environment creation rules

14. **Create venv with the intended interpreter** (explicitly):

    * `python -m venv .venv` where `python` is already the correct version, or
    * `py -3.11 -m venv .venv` (Windows), or
    * `$(pyenv which python) -m venv .venv`.
15. **Immediately upgrade packaging tooling** inside the venv after creation (teams standardize this in bootstrap scripts):

    * `pip`, `setuptools`, `wheel` (or only `pip` if your tooling policy dictates).
16. **Never rely on “global site-packages”** (`--system-site-packages`) except for tightly controlled enterprise edge cases.

## 5) Dependency management and locking

17. **Single source of dependency truth** per repo. Avoid “requirements.txt plus random pip installs.”
18. **Use `pyproject.toml` as the canonical declaration** for modern projects (PEP 621). Treat ad-hoc `requirements.txt` as legacy unless your org standard is otherwise.
19. **Separate dependency categories**:

    * runtime / production
    * dev (lint, format, test)
    * optional extras (e.g., `gpu`, `docs`)
20. **Lock dependencies for deterministic installs** (one of):

    * `poetry.lock` (Poetry)
    * `uv.lock` (uv)
    * `requirements.lock` / `constraints.txt` (pip-tools / compiled lock)
21. **CI installs from the lock**, not from floating specifiers.
22. **Avoid unbounded ranges** (`requests>=2` without an upper bound is usually rejected in mature teams).
23. **No direct installs from random Git SHAs** unless justified and tracked; prefer released versions.
24. **Private indexes must be documented** (and authenticated via CI secrets), not baked into developer machines.

## 6) Installation workflow rules

25. **Bootstrap is scripted.** Provide `make setup`, `./scripts/bootstrap`, or similar. New devs should not “guess” commands.
26. **No manual `pip install` in day-to-day work** unless followed by updating the declared dependencies + lock.
27. **Editable installs for local packages** are the default for app repos (`pip install -e .`), so imports reflect current code.
28. **Install is idempotent.** Running setup twice should not break or drift.

## 7) Activation and command execution

29. **Activation is optional if tooling supports it**, but teams standardize execution:

    * `source .venv/bin/activate` (manual),
    * or `uv run ...`, `poetry run ...`, `pipenv run ...`,
    * or `python -m <tool>` inside the venv.
30. **Never run project tools with system python** (linters/tests must run in the project env).
31. **Document OS-specific activation commands** (Linux/macOS vs Windows PowerShell) in the README.

## 8) What must be in version control

32. **Must commit**:

    * `pyproject.toml` (or equivalent)
    * lock file (if your workflow uses one)
    * tool config (ruff/black/pytest/mypy, etc.)
    * bootstrap script / Makefile targets
33. **Must not commit**:

    * `.venv/`
    * `__pycache__/`, `.pytest_cache/`, `.ruff_cache/`, `.mypy_cache/`
    * local `.env` secrets
    * build outputs (`dist/`, `build/`)
34. **Use `.gitignore` as policy**, not suggestion. Keep it maintained.

## 9) Security and supply-chain rules

35. **Prefer hashes in locked requirements** where feasible (pip-tools `--generate-hashes`) for stronger integrity.
36. **Pin build backends and tooling** in CI when your org needs strict reproducibility.
37. **Scan dependencies** (SCA tooling) in CI; treat high-severity CVEs as build-breaking per policy.
38. **No `pip install` from untrusted sources** (random URLs). Approved indexes only.
39. **Avoid running `pip` as admin/root**; use least privilege.

## 10) Performance and ergonomics

40. **Use wheels whenever possible.** Ensure build deps are documented when native compilation is unavoidable.
41. **Cache downloads in CI** (pip/uv/poetry cache) but never cache the venv itself unless you fully understand the implications.
42. **Keep the env lean.** Remove unused dependencies; avoid “kitchen sink” dev extras.
43. **Use `pip check` (or equivalent) in CI** to detect broken dependency resolution.

## 11) Tooling integration (IDE + linters + tests)

44. **IDE must point to the project interpreter** (the venv Python). This is non-negotiable for consistent analysis.
45. **Pre-commit hooks run inside the venv context** (or via tool runners like `uv run`).
46. **Single formatting/linting stack** across the team (avoid “some use black, others yapf”).
47. **Tests must run the same way locally and in CI**, via a single command (`make test`, `pytest`, etc.), executed in the env.

## 12) CI/CD rules

48. **CI rebuilds env from scratch** (from lock) to prove reproducibility.
49. **Fail if lock is out of date** (e.g., dependency file changed but lock didn’t).
50. **Matrix test across supported Python versions** (at least the minimum and latest supported).
51. **Dependency drift is controlled**: scheduled lock refreshes with CI verification, not random upgrades.

## 13) Common anti-patterns to ban

52. Committing `.venv/` to Git.
53. Installing packages without updating dependency declarations/lock.
54. Mixing conda + venv in the same repo without a clear policy.
55. Depending on globally installed tooling (“it works on my machine”).
56. Letting developers choose arbitrary Python versions not covered by CI.
57. Using `.env` for secrets and committing it (even accidentally).

## 14) Minimal “gold standard” repo checklist

58. `.gitignore` includes `.venv/`.
59. `pyproject.toml` defines dependencies and `requires-python`.
60. Lock file present and used in CI.
61. `make setup` (or `./scripts/bootstrap`) creates venv + installs deps.
62. `make test`, `make lint`, `make format` run inside the env.
63. README has 5–10 lines that get a new developer running in minutes.

---

# Node/npm/Typescript

Below is the equivalent “professional-team grade” rule set for **Node.js + npm + TypeScript**. Written as enforceable conventions suitable for a repo policy and CI.

## 1) Core principles

1. **Reproducibility over convenience.** Anyone can clone, install, and run with identical results.
2. **Lockfile is authoritative.** Installs in CI must be deterministic.
3. **One project, one toolchain contract.** Node version, package manager, TypeScript version, and scripts are standardized.
4. **Build artifacts are disposable.** `dist/`, caches, and `node_modules/` are not sources of truth.
5. **No secrets in repo.** Never commit `.env` with credentials.

## 2) Node version discipline

6. **Pin Node.js version** and enforce it everywhere:

   * `.nvmrc` or `.node-version` (or Volta in `package.json`)
   * CI uses the same version.
7. **Define a support window** (e.g., “LTS only”). No random Node versions across dev machines.
8. **No global installs required** to build/test/lint. Everything runs via repo scripts.
9. **Upgrade Node intentionally** (scheduled, validated in CI, then rolled out).

## 3) Package manager policy (npm)

10. **Standardize on one package manager** per repo (here: npm). Do not mix npm/yarn/pnpm in the same codebase.
11. **Use npm CI installs in CI**:

    * CI must run `npm ci` (not `npm install`) for deterministic installs.
12. **Never edit lockfile manually.** It is generated by npm.
13. **Treat `package-lock.json` as mandatory.** Commit it, review it, keep it in sync.

## 4) `node_modules` and repo hygiene

14. **Never commit `node_modules/`.** Always `.gitignore` it.
15. **Build output is ignored** (e.g., `dist/`, `.tsbuildinfo`, coverage folders).
16. **Keep generated files out of source** unless they are explicitly required (rare).
17. **Avoid vendoring dependencies** (copy/pasting library code) unless legal/security reasons exist.

## 5) Dependency declaration and versioning

18. **Runtime deps go in `dependencies`.** Tooling/test/lint/build go in `devDependencies`.
19. **Use semver ranges deliberately:**

    * Prefer `^` for mature libraries when acceptable.
    * Pin exact versions for brittle toolchains if the team needs maximum reproducibility.
20. **No “floating latest”** patterns in scripts or docs.
21. **Avoid duplicate libraries** (one HTTP client, one test framework, one logger, etc.) unless you have a clear reason.
22. **Document private registries** and keep auth in CI secrets, not in code.

## 6) Install workflow rules

23. **Local install:** `npm install` only when intentionally changing dependencies.
24. **CI install:** always `npm ci`.
25. **If `package.json` changes, lockfile must change** in the same PR (CI should fail otherwise).
26. **No manual `npm install <pkg>` without updating the repo contract** (scripts/config/tsconfig as needed).

## 7) Scripts are the interface

27. **Everything runs through `npm run ...` scripts**:

    * `npm run build`, `test`, `lint`, `typecheck`, `format`, `dev`, etc.
28. **No “run this tool globally” instructions** in README.
29. **Scripts must be cross-platform** (avoid bash-only unless you explicitly target Linux only; otherwise use Node-based scripts).

## 8) TypeScript configuration discipline

30. **`tsconfig.json` is not personal.** One team-standard config, committed.
31. **Enable strictness by default** (`"strict": true`) for professional codebases, with explicit exceptions.
32. **Use consistent module settings** aligned with runtime:

    * Node ESM vs CJS is a deliberate decision; don’t mix casually.
33. **Separate configs when needed**:

    * `tsconfig.json` (base)
    * `tsconfig.build.json` (emit/build)
    * `tsconfig.test.json` (test tooling) if required
34. **Do not compile in-place.** Emit to `dist/` (or equivalent).
35. **Commit type boundaries**: public APIs should have stable types; avoid leaking internal types across packages.

## 9) Formatting, linting, and code quality

36. **Single formatting standard** (typically Prettier) and enforced via script + CI.
37. **Single lint standard** (typically ESLint) integrated with TypeScript.
38. **Typechecking is separate and required**:

    * `npm run typecheck` must run in CI.
39. **No “it compiles” without typechecking**. JS builds can pass while TS types fail—CI must catch it.
40. **Pre-commit hooks are allowed but not relied on**; CI is the enforcement point.

## 10) Testing rules

41. **Tests run via script** (`npm test`) and are CI-required.
42. **Test environment matches runtime assumptions** (Node version, ESM/CJS).
43. **Coverage is measured consistently** (if required), but do not block dev flow with overly strict thresholds unless intentional.
44. **No flaky tests tolerated**—quarantine or fix quickly.

## 11) Build and release discipline

45. **Define one build command** producing deterministic artifacts (`dist/`).
46. **Do not ship source TS** unless your distribution strategy explicitly requires it.
47. **Source maps policy is explicit** (enabled for debugging; controlled in production if needed).
48. **For libraries:** ensure `exports`/entry points in `package.json` are correct and tested.
49. **For apps:** environment config is documented and validated (fail fast if required vars missing).

## 12) Security and supply chain

50. **Run `npm audit` (or org’s scanner) in CI** with a defined policy for failures.
51. **No install scripts from untrusted packages** unless reviewed (postinstall hooks are a common risk).
52. **Pin critical dependencies** if you’ve had supply-chain incidents or strict compliance needs.
53. **Use provenance/attestations if your org requires it** (policy-driven).
54. **Never commit `.npmrc` with tokens.** Use environment/CI secret injection.

## 13) Monorepos and workspaces (if applicable)

55. **If using npm workspaces:** standardize workspace layout and ensure tooling supports it.
56. **One lockfile at root** and consistent scripts at root.
57. **Avoid cross-package relative imports**; use workspace package boundaries.

## 14) Common anti-patterns to ban

58. Committing `node_modules/` or `dist/`.
59. Using `npm install` in CI instead of `npm ci`.
60. Mixing npm with yarn/pnpm in one repo.
61. Allowing multiple Node versions without enforcement.
62. Skipping `typecheck` in CI.
63. Relying on globally installed TypeScript/ESLint/Prettier.
64. Leaving `any` everywhere instead of fixing types (allow exceptions, but track them).

## 15) Minimal “gold standard” checklist

65. Node version pinned (`.nvmrc` / `.node-version` / Volta) and CI matches.
66. `package-lock.json` committed; CI uses `npm ci`.
67. `npm run build`, `test`, `lint`, `typecheck` exist and pass in CI.
68. `tsconfig.json` is strict and emits to `dist/`.
69. `node_modules/`, `dist/`, caches ignored.
70. Secrets not in repo; `.env` ignored; example env file provided (`.env.example`).

---

# Java/Maven/Gradle/Spring/Spring Boot

Below is a professional-team rule set for **Java + Maven/Gradle + Spring + Spring Boot** (first mention: **Spring Boot** = Spring’s opinionated framework for building production-ready applications quickly).

## 1) Core principles

1. **Reproducible builds.** Same source must produce same artifact in CI and on any developer machine.
2. **Build tool is the contract.** Everything (compile/test/lint/package/run) is done via Maven/Gradle tasks, not IDE magic.
3. **Dependencies are explicit and controlled.** No “works on my machine” via transitive drift.
4. **Configuration is externalized.** Code is environment-agnostic; environment is configuration.
5. **Security is continuous.** Dependency scanning and patching are part of the normal workflow.

## 2) JDK version discipline

6. **Standardize one JDK major version** per repo (e.g., 17 or 21) and enforce it in:

   * build config (toolchains),
   * CI,
   * developer setup docs.
7. **Do not rely on system Java defaults.** Use a managed JDK (SDKMAN!/asdf/IDE-managed) and document the source.
8. **No ad hoc JDK upgrades.** Upgrade as a planned change with CI matrix testing when needed.
9. **Fail fast on wrong JDK.** Builds should error clearly if the wrong Java version is used.

## 3) Maven vs Gradle policy

10. **Choose one build tool per repo.** Do not keep both active.
11. **Use the wrapper always:**

* Maven Wrapper (`mvnw`, `.mvn/`)
* Gradle Wrapper (`gradlew`, `gradle/wrapper/`)

12. **Never require global Maven/Gradle installation.** CI and developers invoke wrapper scripts only.
13. **Wrapper version is reviewed and pinned** (committed), updated intentionally.

## 4) Repository and module structure

14. **Standard layout only.** Maven/Gradle conventional structure:

* `src/main/java`, `src/main/resources`
* `src/test/java`, `src/test/resources`

15. **Multi-module builds are explicit** (root aggregator), with clear module boundaries.
16. **One application entry point** per Spring Boot service (unless it’s a deliberate multi-app repo).
17. **Keep generated sources out of VCS** unless required (rare and justified).

## 5) Dependency management discipline

18. **Use Spring Boot dependency management** (BOM: Bill of Materials, first mention: **BOM** = a curated set of compatible dependency versions):

* For Maven: `spring-boot-starter-parent` or `dependencyManagement` importing Boot BOM.
* For Gradle: `io.spring.dependency-management` plugin or platform/BOM import.

19. **Do not pin versions already managed by the BOM** unless you are deliberately overriding (and document why).
20. **Ban duplicate/competing libraries** (multiple JSON libs, multiple HTTP clients) unless justified.
21. **Keep runtime vs test vs dev-only deps separated**:

* Maven scopes (`compile`, `runtime`, `test`, `provided`)
* Gradle configurations (`implementation`, `runtimeOnly`, `testImplementation`, `testRuntimeOnly`)

22. **No “latest” version specs** or dynamic ranges in production repos.
23. **Track and minimize transitive dependency surprises** (dependency tree checks as part of review/CI).

## 6) Build reproducibility and locking

24. **CI builds from scratch** with clean caches policy (cache dependencies, not outputs).
25. **Pin plugin versions** (Maven plugins / Gradle plugins) to avoid drift.
26. **Gradle dependency locking** is enabled for high-repro environments (when required by policy).
27. **No local jars in repo** as dependencies unless unavoidable; use a proper artifact repository (Nexus/Artifactory) or publish to an internal registry.

## 7) Spring Boot configuration rules

28. **Configuration externalized via `application.yml` / `application.properties`** plus environment overrides.
29. **No secrets in config files committed to VCS.** Use env vars or secret managers; commit `.example` templates.
30. **Use profiles intentionally** (first mention: **Profile** = named configuration set like `dev`, `test`, `prod`):

* `application-dev.yml`, `application-prod.yml`
* Avoid profile explosion; keep it manageable.

31. **Prefer constructor injection** over field injection.
32. **Avoid component-scanning ambiguity.** Keep package structure clean under a single base package.

## 8) API and architecture conventions (Spring)

33. **Clear layering** (typical):

* controller (web/API)
* service (business logic)
* repository (persistence)
* domain (entities/value objects)

34. **Controllers thin, services thick.** No business logic in controllers.
35. **Transactions at service layer** (`@Transactional`) with deliberate boundaries.
36. **DTOs at boundaries.** Do not expose JPA entities directly from controllers.
37. **Validation at boundaries** using Bean Validation (`@Valid`, constraints) consistently.
38. **Global error handling** via `@ControllerAdvice` with a stable error schema.

## 9) Persistence and migrations

39. **Database schema changes are versioned** (Flyway or Liquibase) and applied automatically in CI/test.
40. **No “manual SQL in prod.”** Migrations are the only path.
41. **Test with real DB when practical** (Testcontainers, first mention: **Testcontainers** = disposable Docker-based dependencies for tests) for integration coverage.
42. **JPA performance rules**: avoid N+1 queries, control fetch strategies, and measure with logs/profilers.

## 10) Testing standards

43. **JUnit 5 is standard** unless you have a legacy exception.
44. **Test pyramid enforced:**

* unit tests for business logic
* slice tests (`@WebMvcTest`, `@DataJpaTest`) for focused integration
* end-to-end integration tests for critical flows

45. **Spring Boot tests must be scoped**:

* avoid `@SpringBootTest` everywhere; it’s expensive.

46. **No flaky tests.** Quarantine or fix immediately.
47. **CI runs tests headlessly** with no IDE dependencies.

## 11) Code quality and formatting

48. **One formatter enforced** (Spotless, Checkstyle, Google Java Format, or equivalent) via build tasks + CI.
49. **Static analysis in CI** (e.g., SpotBugs, Error Prone) as policy dictates.
50. **No unchecked warnings ignored casually**; keep compiler warnings meaningful.
51. **Consistent logging** (SLF4J + Logback typical), no `System.out.println`.
52. **Structured logging** for services (JSON logs) if your runtime/observability stack expects it.

## 12) Spring Boot runtime and ops conventions

53. **Actuator enabled and secured** (first mention: **Actuator** = Spring Boot’s production endpoints for health/metrics):

* health, info, metrics endpoints
* restrict sensitive endpoints

54. **Health checks are meaningful** (DB connectivity, downstream dependencies where required).
55. **Metrics and tracing are standardized** (Micrometer, first mention: **Micrometer** = metrics facade used by Spring Boot).
56. **Graceful shutdown configured** and validated.
57. **External calls have timeouts and retries** (no infinite waits), with circuit breaking when required.

## 13) Packaging and deployment

58. **One artifact output** per service:

* Boot fat jar (common) or container image

59. **Versioning is automated** (CI sets version; do not hand-edit for releases unless policy requires).
60. **Build once, deploy many.** Same artifact promoted across environments.
61. **Container builds are deterministic** if used (no `latest` base images without pinning digest in strict orgs).

## 14) Security rules

62. **Dependency scanning in CI** (OWASP Dependency-Check, Snyk, etc.) with a defined failure policy.
63. **Keep Spring Boot patched** (Boot upgrades are the primary vehicle for patching the ecosystem).
64. **No deserialization risks** (avoid unsafe serialization; validate inputs).
65. **Secure defaults**: CSRF, CORS policies explicit; avoid permissive wildcard configs.
66. **Secrets via secret manager** (KMS/Vault/cloud secret stores); never in Git.

## 15) Common anti-patterns to ban

67. Building/running from the IDE without ensuring wrapper builds pass.
68. Committing `target/` or `build/`, `.classpath`, `.project`, `.idea/` (except curated run configs if your org allows).
69. Pinning random dependency versions that fight the Boot BOM.
70. Using field injection everywhere.
71. `@SpringBootTest` for every test.
72. Business logic in controllers.
73. No migrations / manual schema drift.
74. Missing timeouts on HTTP clients.
75. Actuator exposed publicly without controls.

## 16) Minimal “gold standard” checklist

76. JDK pinned and enforced via toolchains; CI matches.
77. Maven/Gradle wrapper committed and used everywhere.
78. Dependency management via Spring Boot BOM; plugins pinned.
79. `./mvnw test` or `./gradlew test` is the canonical command; CI runs it.
80. Migrations (Flyway/Liquibase) integrated; Testcontainers used for integration where appropriate.
81. Lint/format/static analysis tasks exist and are CI-enforced.
82. Actuator health/metrics configured and secured.

---

# C/C++/CMake

Below is a professional-team rule set for **C / C++ / CMake**. It is written as enforceable policy for repos and CI.

## 1) Core principles

1. **Out-of-source builds only.** Source tree stays clean; build outputs are disposable.
2. **One build definition.** CMake is the single source of truth; IDE project files are generated, not committed.
3. **Reproducibility is mandatory.** Same commit + same toolchain config yields the same artifacts in CI.
4. **Warnings are treated as defects.** Default posture is “clean build” on supported compilers.
5. **Cross-platform by design** (or explicitly constrained). If Linux-only, state it clearly.

## 2) Toolchain and language standards

6. **Pin language standards** in CMake:

   * `C_STANDARD` / `C_STANDARD_REQUIRED`
   * `CXX_STANDARD` / `CXX_STANDARD_REQUIRED`
   * avoid compiler-default standards.
7. **Define supported compilers and versions** (e.g., GCC/Clang/MSVC) and enforce in CI.
8. **No reliance on implicit flags** from developer machines. All required flags come from CMake targets.
9. **Prefer modern C++ target usage** (properties + `target_*` commands) over global flags.
10. **Use a toolchain file** for cross-compilation or non-default toolchains; do not “hand-set” compilers ad hoc.

## 3) Project layout and hygiene

11. **Canonical layout** (typical):

    * `include/` public headers
    * `src/` implementation
    * `tests/`
    * `cmake/` helper modules
    * `third_party/` only when unavoidable (prefer dependency managers)
12. **No generated files in source** (`compile_commands.json` may be generated into build dir, optionally symlinked).
13. **.gitignore must cover** `build/`, `out/`, `CMakeFiles/`, `CMakeCache.txt`, IDE folders, sanitizer logs, etc.
14. **One top-level CMakeLists.txt** that delegates to subdirectories cleanly.

## 4) CMake authoring rules (modern CMake)

15. **Minimum required CMake version** is explicit and justified (avoid overly old versions).
16. **Targets-first design**:

    * define `add_library()` / `add_executable()`
    * then use `target_sources()`, `target_include_directories()`, `target_compile_definitions()`, `target_compile_options()`, `target_link_libraries()`.
17. **No global `include_directories()` / `add_definitions()`** except in tightly controlled legacy cases.
18. **Use visibility correctly**:

    * `PRIVATE` for internal usage
    * `PUBLIC` for headers that consumers compile against
    * `INTERFACE` for header-only libs.
19. **Exported targets for libraries**: consumers link to targets, not raw include paths or flags.
20. **Avoid file globs for sources** (`file(GLOB ...)`) in serious builds; list sources explicitly (or generate lists intentionally) to avoid stale builds.

## 5) Build types and configuration

21. **Multi-config vs single-config is explicit**:

    * Visual Studio / Xcode are multi-config
    * Ninja/Make often single-config (`CMAKE_BUILD_TYPE`).
22. **Standard build types** supported: `Debug`, `Release`, optionally `RelWithDebInfo`.
23. **Default to `RelWithDebInfo` in CI packaging** if you want production performance plus symbols (policy decision).
24. **No “magic defaults.”** If a feature flag matters, expose it as a CMake option with clear docs.

## 6) Dependency management

25. **Prefer CMake-native dependency flows**:

    * `find_package()` with config packages
    * `FetchContent` for pinned source deps when acceptable
    * Conan/vcpkg when your org standardizes on them
26. **Dependencies are version-pinned** (tags/commits) for reproducibility.
27. **No vendored binaries** committed (unless compliance forces it).
28. **Link via imported targets** (e.g., `fmt::fmt`, `Boost::filesystem`) rather than raw `-l` flags.
29. **Keep dependency surface minimal**; avoid pulling huge frameworks for small needs.

## 7) Compiler warnings and hardening

30. **Warnings enabled aggressively** on each supported compiler.
31. **Warnings-as-errors in CI** (at least for project code) unless you have a formal exception mechanism.
32. **Security hardening flags** are standardized per platform (stack protector, fortify, etc.) where appropriate.
33. **No undefined behavior tolerated**: sanitize and fix rather than suppress.
34. **Treat signed/unsigned, narrowing, and lifetime warnings seriously**—these are common defect sources.

## 8) Debugging, sanitizers, and analysis

35. **Sanitizers are first-class build variants**:

    * AddressSanitizer (ASan), UndefinedBehaviorSanitizer (UBSan), ThreadSanitizer (TSan) where supported.
36. **Static analysis is part of CI** where practical:

    * clang-tidy for C/C++
    * cppcheck optionally (less authoritative than compiler/clang tools)
37. **Build must be able to generate `compile_commands.json`** (for clang tooling).
38. **Never merge sanitizer suppressions casually**; treat them as temporary and tracked.

## 9) Testing standards

39. **Tests are built and run via CTest** (`enable_testing()`, `add_test()`).
40. **One test framework** standardized (GoogleTest/Catch2/etc.), integrated via targets.
41. **Unit tests are hermetic** (don’t depend on developer filesystem state).
42. **Integration tests clearly separated** from unit tests and may require external deps (documented).
43. **CI runs tests on all supported platforms/compilers** (or explicitly scoped).

## 10) Formatting and style

44. **Formatting is automated**:

    * clang-format for C/C++
    * cmake-format optional for CMake
45. **Format is enforced in CI** (check mode) and/or pre-commit.
46. **No style debates in PRs.** Tool output is the standard.
47. **Consistent include ordering** and header guards / `#pragma once` (team standard, enforced).

## 11) Headers, ABI, and interface discipline

48. **Public headers are stable contracts.** Keep them minimal; avoid leaking implementation details.
49. **Use forward declarations** to reduce compile times where safe.
50. **Do not expose STL types across DLL boundaries on Windows** unless you fully control the toolchain/CRT policy.
51. **Control symbol visibility** for shared libraries (visibility presets) to keep ABI clean.
52. **Version and namespace public APIs** when the library is intended for external consumption.

## 12) Build performance and correctness

53. **Unity builds (jumbo) are optional** and off by default unless measured and proven beneficial.
54. **Precompiled headers (PCH)** are optional and policy-driven; only after measurement.
55. **Use Ninja in CI** (commonly) for speed and consistent output.
56. **Avoid unnecessary recompiles**: correct include usage, avoid huge headers in public APIs.

## 13) Packaging and install rules (for libraries)

57. **Use `install(TARGETS ...)` and export configs** so downstream users can `find_package()` your project.
58. **Provide a config package** (`<Project>Config.cmake`) for serious libraries.
59. **Do not hardcode absolute paths** into installed artifacts.
60. **Versioning of the package** is explicit.

## 14) CI/CD gate expectations

61. **CI stages typically include**:

    * configure
    * build
    * unit tests
    * sanitizers (at least ASan+UBSan on Linux)
    * static analysis (clang-tidy)
    * packaging (optional)
62. **CI is run in clean environments**; no reliance on developer caches beyond dependency caches.
63. **Artifacts are produced from CI** (not from dev machines) for releases.

## 15) Common anti-patterns to ban

64. In-source builds (generating `CMakeFiles/` next to `src/`).
65. Global compile flags sprinkled via `add_definitions()` and `include_directories()`.
66. Using `file(GLOB ...)` for sources in production builds without a clear regen mechanism.
67. Committing IDE-generated projects.
68. Pulling dependencies with unpinned `master/main`.
69. Turning off warnings instead of fixing code.
70. Tests that pass only on one developer machine.

## 16) Minimal “gold standard” checklist

71. `build/` (or `out/`) is the only build directory; fully ignored in Git.
72. `cmake -S . -B build -G Ninja` (or equivalent) works on a fresh machine.
73. Targets use `target_*` commands, with correct `PRIVATE/PUBLIC/INTERFACE`.
74. Warnings enabled; CI treats warnings as errors for project code.
75. `compile_commands.json` available; clang-tidy usable.
76. CTest runs unit tests in CI; sanitizers run at least on Linux.
77. clang-format enforced.

---

# Rust/Cargo

Below is a professional-team rule set for **Rust + Cargo** (first mention: **Cargo** = Rust’s official build system and package manager).

## 1) Core principles

1. **Reproducible builds.** Same commit builds the same way in CI and locally.
2. **One source of truth.** `Cargo.toml` + `Cargo.lock` (when applicable) define the build.
3. **Tooling is standardized.** Formatting, linting, tests, and docs are run the same way everywhere.
4. **Warnings are defects.** CI treats warnings seriously (often as errors).
5. **Small, reviewable changes.** Rust’s safety story depends on clear ownership and API boundaries.

## 2) Toolchain discipline (rustup)

6. **Pin the toolchain** with `rust-toolchain.toml` committed:

   * choose `stable` or a specific version (policy decision)
   * document exceptions if nightly is required.
7. **CI uses the same toolchain** (no “latest stable” drift unless you explicitly want that).
8. **No system Rust installs.** Use `rustup` as the standard.
9. **If nightly is required, pin the nightly date** and justify it (feature gates are not free).

## 3) Workspace and crate structure

10. **Use Cargo workspaces** for multi-crate repos; define members explicitly.
11. **Clear crate boundaries**:

    * library crates for reusable logic
    * binary crates for applications/CLI
12. **Avoid cyclic dependencies** across crates; refactor shared code into a core crate.
13. **Keep public API minimal**; prefer internal modules and re-export intentionally.
14. **Do not put “everything in one crate”** if it creates unreviewable modules; split by domain.

## 4) Dependencies and version control

15. **Declare dependencies with intent**:

    * `dependencies` for runtime
    * `dev-dependencies` for tests/bench
    * `build-dependencies` for build scripts.
16. **Avoid unnecessary features.** Enable crate features explicitly; do not accept default features blindly.
17. **Prefer semver-compatible ranges**, but do not allow uncontrolled drift in critical repos:

    * for libraries: keep `Cargo.toml` ranges reasonable
    * for applications: rely on lockfile for determinism.
18. **Avoid git/path dependencies** unless:

    * in a workspace, or
    * pinned to a commit and justified.
19. **Review transitive dependencies** for bloat and risk; keep the tree lean.

## 5) `Cargo.lock` policy

20. **Applications/binaries commit `Cargo.lock`.** This is the norm for reproducible deploys.
21. **Libraries may omit `Cargo.lock`** (common convention), unless your org mandates otherwise.
22. **CI verifies lockfile consistency**:

    * fail if `Cargo.toml` changes without lock updates where applicable.
23. **No hand-editing of `Cargo.lock`.** It is generated.

## 6) Build profiles and flags

24. **Use standard profiles** (`dev`, `release`) and only customize when measured.
25. **Avoid “mystery flags” in docs.** If a flag matters, encode it in:

    * `Cargo.toml` profiles, or
    * scripts (`just`, `make`, `cargo-*` aliases), or
    * CI config.
26. **For release artifacts**, ensure `release` builds are used and reproducible (no local-only toggles).
27. **Linker/tooling choices are explicit** when relevant (e.g., `lld`), documented, and consistent in CI.

## 7) Formatting and linting

28. **Formatting is enforced** with `rustfmt`:

    * `cargo fmt --check` in CI.
29. **Linting is enforced** with Clippy (first mention: **Clippy** = Rust’s official linter):

    * `cargo clippy -- -D warnings` (or equivalent policy).
30. **No style debates in PRs.** Tool output is the standard.
31. **Keep the lint baseline clean.** If you allow `#[allow(...)]`, require a reason and scope it narrowly.

## 8) Testing and quality gates

32. **Tests run in CI**:

    * `cargo test` (all crates, all features as policy dictates).
33. **Feature matrix is tested** if you publish a library (at least common feature combinations).
34. **Doctests and examples** should compile and run when they are part of your API contract.
35. **Use `cargo test --locked`** in CI to guarantee lockfile correctness.
36. **No flaky tests.** Quarantine or fix quickly.

## 9) Documentation and API stability

37. **Public APIs require docs** (`///`), especially for library crates.
38. **Fail docs in CI** for published libs:

    * `cargo doc` (and optionally `-D warnings` in rustdoc for serious crates).
39. **Semver discipline** for published crates:

    * breaking changes are major bumps
    * deprecate before removal when feasible.
40. **Keep examples minimal and correct**; they are part of the developer experience.

## 10) Error handling and observability

41. **Use structured error types** (e.g., `thiserror`, `anyhow` with clear boundaries).
42. **Avoid panics in library code** except for programmer errors; return `Result` for expected failure.
43. **Logging/tracing is standardized**:

    * prefer `tracing` for async/services when appropriate
    * keep log levels meaningful and consistent.
44. **No silent error swallowing.** Errors are propagated or logged with context.

## 11) Safety, `unsafe`, and concurrency

45. **`unsafe` is exceptional.** Require:

    * a documented safety invariant
    * the smallest possible scope
    * review by someone comfortable with unsafe Rust.
46. **Use safe abstractions first**; introduce `unsafe` only when profiling proves the need.
47. **Concurrency policy is explicit**:

    * async runtime choice (Tokio/async-std) is standardized per repo
    * avoid mixing runtimes casually.
48. **No data races by construction**—lean on ownership and synchronization primitives appropriately.

## 12) Supply chain and security

49. **Audit dependencies** (first mention: **cargo-audit** = tool that checks dependencies for known vulnerabilities):

    * run `cargo audit` (or org SCA tool) in CI with a defined fail policy.
50. **Review licenses** with `cargo-deny` where required (first mention: **cargo-deny** = checks licenses/advisories/bans).
51. **Ban known-bad crates** and duplicate versions if your org standardizes this.
52. **Avoid unmaintained crates** when practical; document exceptions.

## 13) Performance and profiling

53. **Measure before optimizing.** Use `criterion` for benchmarks when needed.
54. **Prefer algorithmic wins** over micro-optimizations.
55. **Control features for perf** (disable heavy default features you don’t need).
56. **Use release profiling tools** (`perf`, `pprof`, etc.) with symbols when required.

## 14) CI/CD conventions

57. **Canonical CI steps**:

    * `cargo fmt --check`
    * `cargo clippy -- -D warnings`
    * `cargo test --locked`
    * `cargo build --release --locked` (when producing artifacts)
58. **Cache Cargo registries** and `target/` intelligently, but never let cache hide reproducibility issues.
59. **Test on all supported platforms** (Linux/Windows/macOS) if you claim support.
60. **MSRV policy** (first mention: **MSRV** = Minimum Supported Rust Version) for libraries:

    * define MSRV explicitly
    * enforce in CI.

## 15) Common anti-patterns to ban

61. Unpinned toolchains (CI drift).
62. Committing “quick fixes” via broad `#[allow(clippy::all)]`.
63. Excessive crate features enabled “just in case.”
64. `unsafe` without safety comments/invariants.
65. Git dependencies pointing to branches instead of pinned commits.
66. Ignoring `Cargo.lock` policy (apps should commit it; CI should enforce).

## 16) Minimal “gold standard” checklist

67. `rust-toolchain.toml` pinned; CI matches.
68. `cargo fmt --check` and `cargo clippy -- -D warnings` in CI.
69. `cargo test --locked` in CI; lockfile policy followed.
70. Workspace layout clean; crate boundaries clear.
71. Dependency audit (cargo-audit / cargo-deny or org scanner) in CI.
72. Documented API + examples for public crates; semver discipline followed.

---

# CUDA/OpenCV/OpenGL

Below is a professional-team rule set for **CUDA + OpenCV + OpenGL** (first mention: **CUDA** = NVIDIA’s GPU computing platform; **OpenCV** = Open Source Computer Vision library; **OpenGL** = Open Graphics Library, a graphics API).

## 1) Core principles

1. **Determinism and reproducibility first.** Same commit + pinned toolchain must build and run the same in CI and on dev machines.
2. **Correctness before performance.** Performance work is gated by profiling evidence, not intuition.
3. **Clear boundaries.** Computer vision (OpenCV), compute (CUDA), and rendering (OpenGL) responsibilities are separated in code and build targets.
4. **Interop is explicit.** Any CUDA–OpenGL sharing is documented, isolated, and tested.

## 2) Toolchain and version discipline

5. **Pin GPU toolchain versions**:

   * CUDA Toolkit version (and driver minimum) is documented and enforced.
   * C++ standard and compiler versions are pinned (host compiler matters for NVCC).
6. **Single build system contract** (typically CMake): devs and CI build the same way, without IDE-only steps.
7. **No “works on my GPU” drift.** Define supported GPU architectures (first mention: **SM** = Streaming Multiprocessor capability like `sm_86`) and compile accordingly.
8. **Explicit GPU arch flags**: build must set `-gencode`/`CMAKE_CUDA_ARCHITECTURES` deliberately, not default.
9. **OpenCV version is pinned and consistent** across all machines (ABI stability matters). No “system OpenCV on one machine, custom build on another”.

## 3) Repository hygiene and build outputs

10. **Out-of-source builds only.** Build directories are disposable and ignored (`build/`, `out/`).
11. **No vendored binaries** (OpenCV libs, drivers, compiled artifacts) committed to Git.
12. **Third-party dependencies are managed** via a clear mechanism (package manager or pinned source build) and documented.

## 4) GPU/CPU API boundaries and ownership rules

13. **Explicit memory ownership**:

* Every buffer has a single owner and a documented lifetime.
* Define whether memory is on host (CPU), device (GPU), or shared.

14. **No hidden transfers.** Any host↔device copy is visible in code review (named functions/wrappers), measurable, and logged in profiling.
15. **RAII everywhere** (first mention: **RAII** = Resource Acquisition Is Initialization): GPU resources (device buffers, streams, events, GL objects) are released deterministically.
16. **No raw pointers crossing layers** without a clear contract (size, alignment, ownership, stream/context).

## 5) CUDA kernel and runtime best practices

17. **Kernel launch correctness is mandatory**:

* Check and handle `cudaGetLastError()` / `cudaPeekAtLastError()` in debug builds.
* Synchronization points are explicit and justified.

18. **No implicit synchronization surprises**:

* Avoid accidental device-wide syncs (e.g., careless `cudaDeviceSynchronize()`).
* Stream usage is intentional (first mention: **Stream** = CUDA command queue for async execution).

19. **Stable error-handling policy**:

* Wrap CUDA API calls in a single macro/function that logs file/line and error string.
* Fail fast in debug; controlled recovery only where needed.

20. **Memory access patterns are reviewed**:

* Coalesced global memory access where possible.
* Avoid bank conflicts in shared memory when relevant.

21. **Numerics policy is explicit**:

* float vs half vs int types are chosen intentionally.
* Use fast math only when validated against accuracy requirements.

22. **Avoid undefined behavior on GPU**: alignment, out-of-bounds, race conditions, and uninitialized memory are treated as critical defects.
23. **Kernels are benchmarked under realistic sizes**, not micro toy inputs.

## 6) Performance workflow (profiling-driven)

24. **Profile before optimizing** using Nsight tools (first mention: **Nsight Systems** = system-level GPU/CPU timeline; **Nsight Compute** = kernel-level profiling).
25. **Separate bottleneck identification**:

* CPU preprocessing (OpenCV)
* PCIe transfers (first mention: **PCIe** = CPU–GPU interconnect)
* GPU kernels (CUDA)
* Render pipeline (OpenGL)

26. **Performance changes must include evidence**:

* baseline vs after metrics (timings, throughput, GPU utilization)
* profiler snapshots or summaries

27. **Avoid premature micro-optimizations.** Prioritize removing transfers, reducing memory traffic, and improving algorithmic complexity.

## 7) OpenCV usage rules (production-grade)

28. **Build OpenCV consistently** (same compile flags, same modules enabled, same SIMD options).
29. **Treat `cv::Mat` lifetime carefully**:

* Avoid accidental deep copies.
* Be explicit when cloning vs referencing.

30. **Color space and layout are explicit**:

* BGR/RGB, YUV formats, alpha handling are documented at boundaries.

31. **Avoid hidden conversions** (types and channel counts) in hot paths.
32. **Threading policy is explicit**:

* OpenCV internal threading (TBB/OpenMP) is either enabled and controlled or disabled to avoid oversubscription with your own thread pools.

## 8) OpenGL usage rules (rendering correctness)

33. **Context management is disciplined**:

* Context creation is centralized.
* No OpenGL calls outside a valid context/thread.

34. **GL state is not “ambient.”** State changes are localized; do not rely on implicit global state across modules.
35. **Use debug layers in dev**:

* Enable GL debug output (first mention: **KHR_debug** = OpenGL debug extension) and fail fast on errors in debug builds.

36. **Resource lifecycle is explicit** (buffers, textures, shaders, programs, VAOs). No leaks tolerated.
37. **Shader compilation and validation** errors are surfaced clearly (build logs, runtime logs).

## 9) CUDA–OpenGL interoperability rules

38. **Interop is isolated behind a small API** (one module) with clear invariants.
39. **Registration and mapping discipline**:

* Register GL buffers/textures once when possible.
* Map/unmap per frame only when required, and measure it.

40. **Synchronization is explicit and minimal**:

* Avoid device-wide sync.
* Use events/fences appropriately (first mention: **Fence** = GPU synchronization primitive; in GL, `glFenceSync`).

41. **No undefined ownership while shared**:

* When CUDA has a mapped resource, GL does not touch it and vice versa.

42. **Validate interop on target drivers**: interop can be driver-sensitive; CI or release qualification must cover it.

## 10) Data layout and zero-copy rules

43. **Define canonical image buffer formats** across the pipeline (stride, alignment, pixel format).
44. **Prefer contiguous, aligned allocations** for predictable performance.
45. **Use pinned host memory only when justified** (first mention: **Pinned** = page-locked host memory for faster DMA), because it affects system memory behavior.
46. **Avoid “accidental zero-copy” assumptions.** Unified Memory (first mention: **UVM** = Unified Virtual Memory) is not a free win; if used, it is a deliberate policy with performance validation.

## 11) Testing and validation

47. **Golden tests for vision outputs**:

* deterministic test inputs
* tolerance-based assertions for floating point

48. **CPU/GPU parity tests** for core algorithms where feasible (same semantics).
49. **Stress and soak tests**:

* long-run GPU memory leak detection
* repeated context creation/destruction (OpenGL)

50. **Sanity checks in debug builds**:

* bounds checks where possible
* asserts for invariants (dimensions, strides, formats)

51. **Performance regression tests** on representative workloads (even a small benchmark suite) gated in CI where practical.

## 12) CI/CD and release discipline

52. **CI builds with pinned toolchain** (containerized builds strongly preferred).
53. **CI runs at least**:

* unit tests
* a minimal GPU smoke test on a GPU runner (if the project depends on GPU correctness)

54. **Artifact provenance is clear** (exact CUDA/OpenCV/OpenGL dependencies used).
55. **Driver/toolkit compatibility matrix is documented** and kept current.

## 13) Logging, telemetry, and diagnostics

56. **Structured logging around GPU steps**:

* timings for preprocess/transfer/kernel/postprocess/render
* key dimensions and formats

57. **Crash reports include GPU context**:

* driver version
* CUDA runtime version
* GPU model and SM capability

58. **Debug toggles exist** (compile-time and runtime) to enable heavy checks without impacting release builds.

## 14) Common anti-patterns to ban

59. Mixing OpenCV CPU ops and CUDA kernels with silent copies between them.
60. Calling OpenGL from random threads without context discipline.
61. Relying on “it’s fast on my GPU” without profiler evidence.
62. Global `cudaDeviceSynchronize()` sprinkled to “make it work.”
63. Unpinned CUDA/OpenCV versions causing ABI/runtime drift.
64. Interop code spread across the codebase instead of isolated.

---

<a id="apirest"></a>

# API / REST / MVC / gRPC

Below is a professional-team rule set for **API design and implementation**, covering **REST** (Representational State Transfer), **MVC** (Model–View–Controller), and **gRPC** (Google Remote Procedure Call). I’m treating “gRPV” as **gRPC**.

## 1) Core principles

1. **Contract-first**: the API contract is designed, reviewed, versioned, and tested as a primary artifact.
2. **Backwards compatibility by default**: breaking changes are exceptional and require explicit versioning.
3. **Security by default**: authentication and authorization are mandatory; “internal only” is never an excuse.
4. **Consistency beats cleverness**: naming, error formats, pagination, filtering, and auth patterns are uniform across endpoints.
5. **Observability is part of the API**: every request is traceable, measurable, and debuggable in production.

## 2) API styles: when and how to use REST vs gRPC

6. **REST** is the default for public/partner APIs and broad interoperability (browsers, mobile, third parties).
7. **gRPC** is preferred for service-to-service calls requiring strong typing, high throughput, streaming, or low latency.
8. If you expose both, **REST and gRPC must share the same domain model semantics** (don’t drift).
9. Define one **canonical source of truth** for schema:

   * REST: OpenAPI specification (first mention: **OpenAPI** = standard for describing HTTP APIs).
   * gRPC: `.proto` files (Protocol Buffers).
10. Do not design “hybrid endpoints” that behave like RPC over REST without a clear reason.

## 3) REST (Representational State Transfer) rules

### Resource modeling and naming

11. Model endpoints around **resources** (nouns), not actions (verbs).
12. Use consistent plural nouns: `/users`, `/orders`, `/payments`.
13. Use hierarchical paths only for true containment: `/users/{userId}/orders`.
14. Avoid deep nesting (usually max 2–3 levels).

### HTTP methods and semantics

15. GET is **safe** (no side effects) and **idempotent**.
16. POST creates or triggers non-idempotent operations.
17. PUT is full replacement and **idempotent**.
18. PATCH is partial update; define patch semantics clearly.
19. DELETE is idempotent where feasible.

### Status codes and content negotiation

20. Use status codes correctly:

* 200/201/204 for success
* 400 validation errors
* 401 unauthenticated
* 403 unauthorized
* 404 not found
* 409 conflict
* 429 rate limited
* 5xx server errors

21. Return `Location` on 201 where applicable.
22. Content-Type and Accept are respected; default to JSON.

### Pagination, filtering, sorting

23. Pagination is mandatory for list endpoints.
24. Choose one pagination strategy and standardize it:

* cursor-based preferred for large datasets

25. Filtering and sorting parameters are documented and validated.
26. Response must include metadata (next cursor, page size, total count if feasible and not expensive).

### Idempotency and retries

27. For POST endpoints that clients may retry, support **Idempotency-Key** headers when appropriate.
28. Document retry behavior; ensure retries cannot double-charge or double-create.

## 4) MVC (Model–View–Controller) rules for server applications

29. Controllers are **thin**: parse/validate input, call services, map to responses.
30. Business logic lives in **service/domain layer**, not controllers.
31. Persistence concerns live in **repositories/DAO** (Data Access Object; first mention: **DAO** = persistence abstraction).
32. Controllers must not leak internal domain entities directly; use DTOs (first mention: **DTO** = Data Transfer Object).
33. Centralize error handling (global exception handlers / middleware), not per-endpoint try/catch.

## 5) gRPC (Google Remote Procedure Call) rules

### `.proto` contract discipline

34. `.proto` files are versioned and reviewed like code.
35. Follow consistent package naming and service naming conventions.
36. Messages are designed for evolution: add fields; do not renumber existing field tags.

### API design

37. Prefer “resource-oriented” RPCs where it makes sense (Create/Get/List/Update/Delete patterns), even in gRPC.
38. Define timeouts and deadlines as mandatory client behavior; services must respect deadlines.
39. Use streaming only when it delivers clear value; document flow control and backpressure.

### Error model

40. Standardize error mapping using gRPC status codes (INVALID_ARGUMENT, NOT_FOUND, ALREADY_EXISTS, PERMISSION_DENIED, UNAUTHENTICATED, RESOURCE_EXHAUSTED, INTERNAL, UNAVAILABLE).
41. Include machine-readable error details (structured error metadata) consistently.

### Interop

42. If you expose REST alongside gRPC, consider a gateway; ensure the mapping is documented and tested.

## 6) Versioning strategy (REST and gRPC)

43. Define one versioning policy and enforce it:

* REST: URI version (`/v1/...`) or header-based versioning; pick one and standardize.
* gRPC: package versioning (`my.service.v1`) is common.

44. Backwards-compatible changes:

* adding optional fields
* adding endpoints/RPCs

45. Breaking changes require a new major version and migration plan.
46. Deprecation policy must include:

* deprecation announcement
* sunset date
* telemetry to detect remaining usage
* clear migration docs

## 8) Input validation and schema rules

58. Validate at the boundary (controllers/handlers).
59. Use a shared schema definition:

* OpenAPI schemas for REST
* `.proto` for gRPC

60. Reject unknown fields when strictness is required; otherwise document permissive behavior.
61. Normalize and validate identifiers, dates, currency, locale/timezone behavior.

## 9) Error handling and error contracts

62. Standardize error response format for REST (single envelope):

* `code` (machine)
* `message` (human)
* `details` (structured)
* `trace_id` (for support)

63. Never leak sensitive internal details in errors.
64. For gRPC, standardize mapping to status + structured details.
65. Document error codes and make them stable.

## 10) Observability and operational rules

66. Every request has a correlation/trace identifier (first mention: **Trace ID** = identifier linking logs/metrics/traces).
67. Logs are structured; PII (Personally Identifiable Information) is redacted (first mention: **PII** = data that can identify a person).
68. Metrics include:

* request rate
* latency (p50/p95/p99)
* error rates by code
* saturation signals (threads, queue depth)

69. Distributed tracing is enabled for service-to-service calls, including gRPC.
70. Health endpoints are meaningful (readiness vs liveness).

## 11) Performance, rate limiting, and resilience

71. Timeouts are mandatory end-to-end; no infinite waits.
72. Rate limiting and quotas are defined and enforced (429 / RESOURCE_EXHAUSTED).
73. Retries are bounded and use backoff; retries are safe only with idempotency.
74. Bulkheads/circuit breakers are applied for unstable dependencies.
75. Payload sizes are bounded; reject overly large requests.

## 12) Data and compatibility rules

76. Do not expose database schema directly as API shapes.
77. Avoid breaking JSON field renames; if needed, support both during migration.
78. Define canonical date/time formats (ISO 8601) and timezone semantics.
79. For gRPC, keep field tags stable forever.

## 13) Security hygiene

80. TLS everywhere (including internal traffic where feasible).
81. CORS (Cross-Origin Resource Sharing; first mention: **CORS** = browser cross-origin policy controls) is explicit and minimal.
82. Audit logging for sensitive actions is mandatory.
83. Least privilege for OAuth2 scopes and service credentials.
84. Regular dependency scanning and patching cadence.

## 14) “Gold standard” CI gate

85. Contract validation:

* OpenAPI lint + breaking change detection (REST)
* proto lint + compatibility checks (gRPC)

86. Unit tests + integration tests
87. AuthZ tests (authorization) for critical endpoints
88. Load/perf smoke test for hot paths
89. Static analysis + security scans

## 15) HTML-facing API rules (browser clients)

This subsection defines **how APIs are consumed from HTML-based clients** (plain HTML, server-rendered pages, or JS-enhanced UIs). These rules exist to prevent accidental contract violations caused by browser defaults.

### HTML forms and HTTP semantics

90. **HTML forms are limited to GET and POST.**
    PUT, PATCH, and DELETE **must not** be assumed available from native forms.
91. **Method overrides are explicit** when required:

* Use a hidden field (`_method=PUT`) **only if your server framework explicitly supports it**.
* Never rely on undocumented middleware behavior.

92. **GET forms are read-only**:

* No state changes
* Safe for reloads, back/forward navigation, and caching.

93. **POST forms are non-idempotent by default**:

* Protect with CSRF tokens
* Redirect after success (PRG pattern: Post → Redirect → Get).

### URL and routing discipline

94. **HTML links (`<a>`) always map to GET endpoints only.**
    No side effects behind links. Ever.

95. **URLs exposed to browsers are stable contracts**:

* No leaking internal IDs without intent
* No accidental coupling to database keys unless documented.

96. **Human-facing routes and API routes are distinct**:

* `/users/42` (HTML view)
* `/api/v1/users/42` (API resource)

Never mix both responsibilities in the same controller without a clear policy.

### Content negotiation and representation

97. **HTML clients negotiate explicitly**:

* Browser views expect `text/html`
* API clients expect `application/json`

Do not rely on User-Agent sniffing.

98. **Controllers must return one representation per endpoint** unless explicitly designed for negotiation.
Avoid “sometimes HTML, sometimes JSON” endpoints without a formal content-negotiation strategy.

### Validation and error feedback (HTML context)

99. **Validation errors for HTML clients are user-facing**:

* Field-level messages
* Non-technical language
* No stack traces or internal codes rendered in HTML.

100. **HTTP status codes still matter**, even with HTML:

* 400 for validation errors
* 401/403 for auth issues (with proper redirects)
* 404 for missing resources
* 500 rendered as generic error pages

HTML rendering does **not** relax correctness of HTTP semantics.

### Authentication and sessions (HTML vs API)

101. **HTML clients typically use sessions/cookies**, not OAuth tokens.

* Cookies must be `HttpOnly`, `Secure`, and SameSite-controlled.
* CSRF protection is mandatory.

102. **OAuth2 tokens are not stored in HTML or JS-accessible cookies** unless you fully understand the security implications.
103. **Never mix session-based auth and token-based auth implicitly** on the same endpoints.

### Progressive enhancement rule

104. **HTML-first must still work without JavaScript** for critical flows when feasible.
105. **JavaScript enhances HTML; it does not redefine the contract**:

* JS fetches call the same APIs documented for non-browser clients.
* No “secret endpoints” used only by frontend code.

### Caching and browser behavior

106. **Cache headers are explicit** for HTML responses:

* Prevent caching of authenticated pages unless intentional.
* Public pages declare cacheability deliberately.

107. **Redirects are intentional**:

* 302/303 after POST
* Avoid redirect chains that hide failures.

### HTML security rules

108. **All HTML output is escaped by default** (XSS prevention).
109. **Never inject raw API error messages into HTML** without sanitization.
110. **CORS rules do not protect HTML pages** — they protect APIs.
     Do not assume browser same-origin rules replace server-side authorization.

---

# Vanilla JavaScript (ES2020)/React/WebGL/D3
Below is a professional-team rule set for **Vanilla JavaScript** (using the most common modern baseline: **ES2020**), **React**, **WebGL**, and **D3** (first mention: **D3** = Data-Driven Documents, a visualization library).

## 1) Core principles

1. **One baseline, enforced.** Language/runtime targets are pinned and enforced in CI and tooling.
2. **Type safety is intentional.** If you use TypeScript, it is mandatory across the repo; if you don’t, you compensate with runtime validation and tests.
3. **Single source of truth for state and data flow.** No ad hoc shared mutable state.
4. **Performance is measured.** Profiling evidence is required for perf-driven changes.
5. **Accessibility and UX are non-negotiable** for user-facing apps.

## 2) Vanilla JavaScript baseline (ES2020) rules

### Language/runtime targeting

6. **Baseline: ES2020** unless your user base requires older browsers. This is the default “modern web” compromise.
7. **Target is explicit** via build tooling (Babel/TS compiler settings) and documented.
8. **No mixing module systems.** Pick and enforce **ES Modules** (first mention: **ESM** = ECMAScript Modules) for modern code.

### Code style and hygiene

9. **Strict mode by default** (ESM implies strict).
10. **No global variables.** Everything is module-scoped.
11. **Prefer `const`, then `let`; avoid `var`.**
12. **Prefer pure functions** and immutable patterns in shared logic.
13. **Avoid hidden coercions.** Use strict equality (`===`), explicit parsing, explicit null handling.
14. **Error handling is explicit**: don’t swallow errors in async flows.

### Tooling gates

15. **Formatter and linter are mandatory** (Prettier + ESLint typical) and enforced in CI.
16. **No “style debates” in PRs.** Tool output is the standard.

## 3) React rules (production-grade)

### Architecture and component discipline

17. **Components are small and composable.** One component = one responsibility.
18. **Separate “container” vs “presentational” concerns** where it reduces complexity.
19. **Business logic does not live in JSX.** Extract logic to hooks or service modules.
20. **Side effects are isolated** (useEffect used sparingly, with clear dependency reasoning).

### State management

21. **Prefer local state first**, then lift state only when necessary.
22. **Avoid prop drilling beyond a few levels**; use context intentionally.
23. **Global state is explicit** (a dedicated store pattern) and justified; no ad hoc module singletons.
24. **Server state is managed as server state** (caching, invalidation, retries) rather than shoved into local/global state.

### Rendering performance

25. **Avoid premature memoization.** Use `memo`, `useMemo`, `useCallback` only with evidence.
26. **Keys are stable and meaningful** (never array index if the list can reorder).
27. **Virtualize large lists** when needed; measure first.

### Testing

28. **Test behavior, not implementation details.** Prefer user-level interactions.
29. **Critical flows have integration tests** (routing, auth, data fetch, error states).

### Accessibility and UX

30. **Accessibility (a11y) is mandatory** (first mention: **a11y** = accessibility):

* semantic HTML first
* keyboard navigation
* focus management
* ARIA only when needed

31. **Loading/empty/error states** are treated as first-class UI states.

## 4) WebGL rules (graphics correctness + maintainability)

(First mention: **WebGL** = browser graphics API based on OpenGL ES.)

### Context and state discipline

32. **Context creation is centralized.** No scattered context management.
33. **No “ambient global GL state.”** State changes are localized and tracked.
34. **Use WebGL debug tooling in dev** (error checks, shader logs); remove overhead in production.

### Resource lifecycle

35. **Explicit lifecycle for GPU resources** (buffers, textures, shaders, programs):

* create
* use
* delete on teardown

36. **No leaks tolerated.** Long-lived apps must clean up on route changes/unmounts.

### Data and performance

37. **Minimize CPU↔GPU transfers.** Upload once, reuse buffers, batch updates.
38. **Avoid per-frame allocations** in render loops.
39. **Shaders are versioned and tested** (compile/link logs surfaced).
40. **Precision and color space are explicit** (gamma, linear/sRGB decisions documented).

### Integration with React

41. **WebGL is isolated behind a component boundary**:

* React owns lifecycle
* WebGL module owns rendering and resources

42. **Use refs for imperative rendering**; avoid tying rendering to React re-renders.

## 5) D3 rules (visualization discipline)

(First mention: **D3** = Data-Driven Documents.)

### Separation of concerns

43. **D3 for math/layout/scales**, not for owning your entire DOM if you are using React.
44. If using React, prefer:

* D3 scales, axes calculations, layouts
* React renders DOM/SVG

45. If using D3 for DOM manipulation, keep it in an isolated subtree and don’t let React compete for the same nodes.

### Data joins and updates

46. **Data join is explicit and stable**:

* stable keys for joins
* update/enter/exit flows are handled intentionally

47. **Animations are deliberate** and must not harm performance/accessibility.

### Performance and correctness

48. **Avoid re-computing scales/layout each render** unless data changed materially.
49. **Prefer SVG for small/medium datasets**, Canvas/WebGL for very large datasets; choose deliberately and document.
50. **Axis formatting, tick density, and labels** are consistent and readable.

## 6) Interop rules: React + WebGL + D3 in one codebase

51. **Single owner per DOM subtree**: either React or D3 imperative code, never both on the same nodes.
52. **Rendering loops (WebGL) are not React state loops.** Use a requestAnimationFrame loop managed via refs.
53. **Data flow is unidirectional**:

* props/state → visualization input
* visualization emits events (hover/select) via callbacks

54. **Debounce/throttle high-frequency events** (mouse move, zoom) and measure impact.

## 7) Security and robustness

55. **Never interpolate untrusted content into HTML** (XSS controls).
56. **Validate external data** at boundaries; don’t assume API payload shape.
57. **Content Security Policy (CSP)** is considered early if you embed shaders or dynamic code (first mention: **CSP** = Content Security Policy).

## 8) CI and “gold standard” gates

58. **Lint + format** on every PR.
59. **Typecheck** if TypeScript is in use (otherwise stronger test coverage + runtime validation).
60. **Unit + integration tests** on core flows.
61. **Bundle/build check** with the pinned targets (ES2020 baseline).
62. **Performance smoke checks** for critical render paths (WebGL/D3-heavy pages), at least via automated benchmarks or manual profiling checklist.
63. **Accessibility checks** (automated where possible, manual for key flows).

## 9) Common anti-patterns to ban

64. Mixing React rendering with D3 DOM mutation on the same elements.
65. Using React state updates on every animation frame for WebGL.
66. Shader compilation errors hidden in console noise (must be surfaced clearly).
67. Unstable list keys causing re-mount storms.
68. Overuse of `useEffect` with unclear dependencies.
69. Per-frame allocations in hot rendering loops.
70. “Works in Chrome” without baseline browser testing.

---

# HTML/CSS

Below is a professional-team rule set for **HTML + CSS**.

## 1) Core principles

1. **Semantic first.** Use HTML to express meaning and structure; CSS handles presentation.
2. **Accessibility is mandatory.** Every UI is keyboard- and screen-reader-usable.
3. **Consistency over creativity.** A shared design system and naming conventions beat ad hoc styling.
4. **Responsive by default.** Layouts must work across target breakpoints and input types.
5. **Maintainability first.** CSS is authored to scale: predictable specificity, minimal overrides, no fragile hacks.

## 2) HTML semantics and structure rules

6. **Use semantic elements** (`header`, `nav`, `main`, `section`, `article`, `footer`) rather than div soup.
7. **Exactly one `<main>` per page/view.**
8. **Heading hierarchy is valid**:

   * one primary `h1` per page/view
   * do not skip heading levels casually.
9. **Landmarks are present and correct** (nav, main, complementary, contentinfo).
10. **Forms use real form semantics**:

* `label` is associated with inputs
* `fieldset/legend` for grouped inputs
* correct input types (`email`, `number`, `date`) when applicable.

11. **Buttons are buttons.** Use `<button>` for actions, `<a>` for navigation. No div-clickables.
12. **Avoid inline styles** except for narrowly justified cases (e.g., dynamic calculated styles in rare components).

## 3) Accessibility rules (a11y)

(First mention: **a11y** = accessibility.)
13. **Keyboard access**: all interactive elements must be reachable and operable with keyboard alone.
14. **Visible focus**: focus outlines are not removed; any customization keeps strong visibility.
15. **Alt text is meaningful**:

* decorative images: empty alt (`alt=""`)
* informative images: descriptive alt.

16. **ARIA is last resort**:

* prefer semantic HTML
* if using ARIA, it must be correct and tested.

17. **Accessible names for controls**:

* labels, `aria-label`, or `aria-labelledby` where needed.

18. **Color contrast meets WCAG** targets; do not encode meaning only by color.
19. **Motion is respectful**:

* honor `prefers-reduced-motion`
* avoid aggressive animations.

## 4) CSS architecture rules

20. **Pick one CSS strategy and enforce it** (e.g., BEM, CSS Modules, utility-first, design tokens). Do not mix casually.
21. **Component-scoped styles are preferred** for large apps to avoid global leakage.
22. **Global CSS is minimal**:

* resets/normalization
* typography base
* design tokens (CSS variables)
* layout primitives.

23. **Design tokens are the source of truth**:

* colors, spacing, typography, radii, shadows via CSS variables.

24. **Avoid high specificity**:

* do not rely on `!important` except as a documented escape hatch.

25. **No deep nesting** (if using preprocessors). Keep selectors shallow and predictable.

## 5) Naming and conventions

26. **Class naming is consistent**:

* if using BEM (Block__Element--Modifier), use it everywhere.
* if using CSS Modules, keep class names simple and local.

27. **No styling by IDs.** IDs are for semantics/JS hooks, not layout/styling.
28. **No styling by tag chains** as primary approach (`.card div ul li span`) is brittle.
29. **One responsibility per class** where possible; avoid “do-everything” utility soup unless you are explicitly utility-first.

## 6) Layout rules (modern CSS)

30. **Use Flexbox and Grid intentionally**:

* Flexbox for 1D layouts (row/column)
* Grid for 2D layouts.

31. **Avoid layout hacks**:

* no float-based layouts (except text flow)
* no table-based layouts.

32. **Responsive units are standard**:

* use `rem` for typography and spacing baseline
* use `%`, `fr`, `minmax()` for responsive layout.

33. **Mobile-first is preferred** unless the product strongly dictates otherwise.
34. **Avoid fixed heights** in content containers; prefer intrinsic sizing.
35. **Use `gap` instead of margin hacks** for spacing between flex/grid items.

## 7) Typography, spacing, and sizing

36. **Set a root font-size** and scale typography consistently.
37. **Use `line-height` intentionally**; avoid cramped defaults.
38. **Limit arbitrary spacing values**; prefer tokenized spacing steps.
39. **Don’t hardcode colors.** Use tokens/variables.

## 8) Responsiveness and media

40. **Breakpoints are standardized** (few, meaningful). No random per-component breakpoints.
41. **Images are responsive**:

* set max width constraints (`max-width: 100%`) where appropriate
* use `srcset/sizes` for performance when needed.

42. **Use `@media (prefers-reduced-motion)`** for animation-heavy UIs.
43. **Dark mode is explicit** if supported:

* `prefers-color-scheme` or a theme toggle
* tokens handle theme switching.

## 9) Performance rules

44. **Minimize CSS bundle size**:

* remove dead styles
* avoid huge global frameworks unless justified.

45. **Avoid expensive selectors** and overly broad rules (e.g., `* {}` used carelessly).
46. **Animations**:

* animate `transform` and `opacity` primarily
* avoid layout thrash (width/height/top/left) unless necessary.

47. **Avoid forced synchronous layout** patterns in JS/CSS interplay.

## 10) Forms and UI states

48. **All interactive states are designed**:

* default, hover, active, focus, disabled, error, loading.

49. **Validation styles** are consistent and accessible (text + icon + color, not color alone).
50. **Touch targets** meet minimum sizing guidelines; avoid tiny clickable areas.

## 11) Cross-browser and quality gates

51. **Define browser support policy** and test against it.
52. **Use Autoprefixer** (or equivalent) rather than hand-writing vendor prefixes.
53. **Normalize CSS** in a controlled way (reset/normalize is standardized).
54. **Linting and formatting are mandatory**:

* Stylelint for CSS
* Prettier formatting (or equivalent)

55. **No inline `style=` in markup** unless policy allows it for rare dynamic cases.

## 12) Common anti-patterns to ban

56. Divs used as buttons/links.
57. Removing focus outlines without a replacement.
58. `!important` everywhere to “fix” specificity issues.
59. Deep selector chains that break on minor DOM changes.
60. Hardcoded magic numbers for spacing/colors outside a token system.
61. Layout built with fixed pixel heights that clip content.
62. Unlabeled form controls.

## 13) Minimal “gold standard” checklist

63. Semantic HTML landmarks and heading structure correct.
64. Keyboard navigation works end-to-end; focus is visible.
65. Design tokens drive colors/spacing/typography.
66. Layout uses Flex/Grid with responsive units and standardized breakpoints.
67. Styles are scoped (or globally minimal) with predictable specificity.
68. Stylelint + formatter enforced in CI; Autoprefixer enabled.
69. Responsive images handled; motion respects user preferences.

---

# Docker/Podman/Kubernetes/Kafka

Below is a professional-team rule set for **Docker / Kubernetes / Podman / Kafka**, written as enforceable policy suitable for real production teams.

## 1) Core principles

1. **Reproducibility over convenience.** Images, manifests, and configs must build and deploy identically in CI and production.
2. **Immutability by default.** Containers are immutable artifacts; configuration and data are external.
3. **Declarative everything.** Desired state is described in version control, not applied manually.
4. **Security is continuous.** Least privilege, image scanning, and network controls are baseline, not add-ons.
5. **Observability is mandatory.** Every service is measurable, debuggable, and traceable.

## 2) Containers: Docker & Podman fundamentals

6. **One process per container** (one responsibility).
7. **Containers are stateless.** Persistent data lives in volumes or external services.
8. **No SSH into containers** as an operational strategy. Debug via logs, metrics, and ephemeral debug containers.
9. **Podman vs Docker is a runtime choice**, not a design change:

   * OCI-compliant images only
   * No Docker-specific hacks if Podman is supported.
10. **Rootless containers preferred** where possible (especially with Podman).

## 3) Dockerfile authoring rules

11. **Minimal base images**:

    * distroless / slim / alpine only when compatible
    * pin base image versions (no `latest`).
12. **Multi-stage builds** are mandatory for compiled languages.
13. **Explicit COPY lists.** No `COPY . .` without `.dockerignore`.
14. **No secrets in images**:

    * no `.env`
    * no tokens
    * no private keys.
15. **Non-root user** inside containers unless there is a documented exception.
16. **Deterministic builds**:

    * pinned package versions where feasible
    * reproducible dependency installs.
17. **Entrypoint vs CMD are intentional**:

    * ENTRYPOINT defines the executable
    * CMD defines defaults.
18. **Healthcheck defined** for long-running services.

## 4) Image management and registries

19. **Images are versioned and immutable** once pushed.
20. **Tags have meaning**:

    * semantic version or git SHA
    * never rely on mutable tags.
21. **Images are built in CI**, not on developer machines.
22. **Image scanning is mandatory** (CVEs, base image issues).
23. **Private registries are authenticated via CI secrets**, not developer machines.

## 5) Kubernetes fundamentals

24. **Kubernetes manifests are declarative** and stored in Git.
25. **No manual `kubectl apply` in production** outside break-glass procedures.
26. **Namespaces reflect environments or domains** (not everything in `default`).
27. **Everything runs as a Pod abstraction**, never directly as containers.
28. **Resource requests and limits are mandatory** for all workloads.
29. **Liveness and readiness probes are required** for long-running services.
30. **Graceful shutdown is implemented** (SIGTERM handling).

## 6) Kubernetes configuration discipline

31. **ConfigMaps for configuration**, **Secrets for secrets**.
32. **Secrets are not stored in Git in plaintext**.
33. **Environment variables vs files**: choose one pattern per service and standardize.
34. **No hardcoded service URLs**; use service discovery.
35. **Labels and annotations are consistent** (app, version, environment, owner).

## 7) Kubernetes workload rules

36. **Deployments for stateless services.**
37. **StatefulSets for stateful workloads** (databases, Kafka brokers).
38. **Jobs/CronJobs for batch work**, not Deployments.
39. **Horizontal Pod Autoscaler (HPA)** is configured where traffic varies.
40. **No single-replica production services** unless explicitly justified.

## 8) Networking and security

41. **NetworkPolicies are defined**; default-deny where feasible.
42. **Service-to-service traffic is explicit**, not implicit.
43. **Ingress rules are minimal and audited.**
44. **TLS everywhere** (internal and external) where feasible.
45. **RBAC is least-privilege**:

    * service accounts per workload
    * no cluster-admin defaults.
46. **No privileged containers** unless formally approved.

## 9) Podman-specific considerations

47. **OCI compatibility is required** (images must run under Docker and Podman).
48. **Rootless execution tested** in CI or staging.
49. **Systemd integration (podman generate systemd)** is used only for non-Kubernetes deployments.
50. **Do not rely on Docker socket semantics** (`/var/run/docker.sock`).

## 10) Kafka fundamentals

51. **Kafka is treated as critical infrastructure**, not a side component.
52. **Topics are versioned and managed declaratively** (IaC or admin tooling).
53. **Partitions, replication factor, and retention are explicit** and documented.
54. **No auto-topic creation in production.**
55. **Producers and consumers define ownership** of topics clearly.

## 11) Kafka producers

56. **Keys are intentional** (ordering and partitioning matter).
57. **Idempotent producers enabled** when supported.
58. **Retries and timeouts are configured explicitly.**
59. **No fire-and-forget sends** for critical data.
60. **Schemas are versioned** (Avro/Protobuf/JSON Schema) and backward-compatible.

## 12) Kafka consumers

61. **Consumer groups are explicit and stable.**
62. **Offset commit strategy is deliberate** (auto vs manual).
63. **At-least-once vs exactly-once semantics are documented.**
64. **Poison messages are handled** (DLQ, retries, backoff).
65. **Consumers are idempotent** where possible.

## 13) Kafka operations and reliability

66. **Monitoring is mandatory**:

    * broker health
    * consumer lag
    * disk usage
67. **Retention and compaction policies are reviewed regularly.**
68. **No schema breaking changes without coordination.**
69. **Backpressure and burst handling are tested.**
70. **Kafka upgrades are planned and tested** (never ad hoc).

## 14) Observability

71. **Structured logs** (JSON) for containers.
72. **Metrics exposed** (Prometheus-compatible where applicable).
73. **Tracing enabled** for request and message flows.
74. **Correlation IDs propagate** across HTTP, gRPC, and Kafka.
75. **Dashboards exist for critical services** before incidents happen.

## 15) CI/CD expectations

76. **CI builds images, runs tests, scans images.**
77. **CD deploys via GitOps or controlled pipelines**, not manual pushes.
78. **Rollback strategy is defined and tested.**
79. **Config drift detection is enabled.**
80. **No production deploys without passing CI gates.**

## 16) Common anti-patterns to ban

81. `latest` image tags in production.
82. Containers running as root without justification.
83. Manual edits to live Kubernetes resources.
84. Secrets baked into images or committed to Git.
85. Kafka topics created ad hoc by applications.
86. Consumers without lag monitoring.
87. Missing resource limits leading to noisy-neighbor failures.

## 17) Minimal “gold standard” checklist

88. Dockerfiles are multi-stage, non-root, scanned.
89. Images are built in CI and deployed immutably.
90. Kubernetes workloads have requests/limits, probes, and RBAC.
91. Kafka topics and schemas are versioned and monitored.
92. Logs, metrics, and traces are available for every service.
93. Rollbacks are fast and documented.
