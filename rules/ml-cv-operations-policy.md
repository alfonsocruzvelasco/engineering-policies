# ML/CV Operations Policy

**Status:** Authoritative
**Last updated:** 2026-02-02
**Purpose:** ML/CV-specific operations that complement the comprehensive MLOps Policy

---

## ML/CV Operations

This section covers ML/CV-specific operations that complement the comprehensive [MLOps Policy](mlops-policy.md). See MLOps Policy for experiment tracking, model serving, monitoring, hyperparameter tuning, distributed training, model optimization, deployment patterns, and lifecycle management.

### 15.1 Model Evaluation Frameworks

#### Evaluation Metrics Selection (Per Task Type)

**Classification:**
- Accuracy, Precision, Recall, F1-score
- ROC-AUC, PR-AUC
- Confusion matrix
- Per-class metrics (for imbalanced datasets)

**Object Detection:**
- mAP (mean Average Precision) at IoU thresholds (0.5, 0.75, 0.5:0.95)
- Precision-Recall curves
- Per-class AP
- Detection latency (FPS)

**Semantic Segmentation:**
- IoU (Intersection over Union) per class
- mIoU (mean IoU)
- Pixel accuracy
- Frequency-weighted IoU

**Keypoint Detection:**
- PCK (Percentage of Correct Keypoints)
- OKS (Object Keypoint Similarity)
- mAP (for keypoint detection)

#### Cross-Validation Strategies

**K-Fold Cross-Validation:**
- Use for: Small datasets, hyperparameter tuning
- K = 5 or 10 (standard)
- Stratified K-fold for imbalanced datasets

**Time-Series Cross-Validation:**
- Use for: Temporal data (video, time-series)
- Forward chaining (train on past, validate on future)
- No shuffling (preserve temporal order)

**Group K-Fold:**
- Use for: Grouped data (same subject in multiple images)
- Ensures same group not in train and validation

#### Test Set Construction

**Holdout policy:**
- Test set: 10-20% of data (never used for training/validation)
- Test set: Fixed, never changed
- Test set: Representative of production distribution
- Test set: Includes edge cases and failure modes

**Test set validation:**
- Test set used only for final evaluation
- No hyperparameter tuning on test set
- No model selection on test set
- Report test metrics only after final model selection

#### Evaluation on Edge Cases

**Edge case categories:**
- **Occlusion:** Partially visible objects
- **Scale variation:** Very small or very large objects
- **Lighting conditions:** Low light, overexposure, shadows
- **Viewpoint variation:** Unusual angles, rotations
- **Background clutter:** Complex backgrounds
- **Adversarial examples:** Intentional perturbations

**Evaluation protocol:**
- Create edge case test set
- Evaluate model on edge cases separately
- Report edge case performance
- Use edge cases to guide improvements

#### Model Calibration & Uncertainty Quantification

**Calibration:**
- Well-calibrated models: predicted probability matches true probability
- Use calibration plots to assess
- Apply temperature scaling or Platt scaling if needed

**Uncertainty quantification:**
- Predictive uncertainty (aleatoric + epistemic)
- Use for: High-stakes decisions, safety-critical applications
- Methods: Ensemble, Monte Carlo dropout, Bayesian neural networks

#### Fairness & Bias Evaluation

**Bias evaluation:**
- Evaluate performance across subgroups (demographics, regions, etc.)
- Check for disparate impact
- Use fairness metrics (equalized odds, demographic parity)

**Bias mitigation:**
- Pre-processing: Balance training data
- In-processing: Add fairness constraints to training
- Post-processing: Adjust predictions for fairness

#### Evaluation Automation & CI Integration

**Automated evaluation:**
- Run evaluation on every model training
- Compare against baseline metrics
- Fail CI if metrics below threshold
- Generate evaluation reports automatically

**CI integration example:**
```yaml
# .github/workflows/evaluate-model.yml
- name: Evaluate model
  run: |
    python scripts/evaluate.py --model checkpoint.pt --test-set data/test/
    python scripts/check_metrics.py --min-mAP 0.85
```

---

### 15.2 Feature Engineering & Feature Stores

#### Feature Engineering Best Practices

**Feature types:**
- **Numerical:** Continuous values (normalize, scale)
- **Categorical:** Discrete values (one-hot, embedding)
- **Temporal:** Time-based features (hour, day, season)
- **Text:** NLP features (TF-IDF, embeddings)
- **Image:** CV features (HOG, SIFT, deep features)

**Feature engineering principles:**
- Domain knowledge guides feature creation
- Feature importance analysis (identify useful features)
- Feature selection (remove redundant features)
- Feature scaling (normalize for distance-based models)

#### Feature Store Architecture

**Feature store components:**
- **Offline store:** Historical features (for training)
- **Online store:** Real-time features (for inference)
- **Feature registry:** Feature definitions and metadata
- **Feature serving API:** Low-latency feature retrieval

**Feature store tools:**
- **Feast:** Open-source, cloud-native
- **Tecton:** Enterprise, managed service
- **Custom:** SQL + Redis/cache for simple cases

#### Feature Versioning & Lineage

**Feature versioning:**
- Version features when logic changes
- Track feature transformations
- Maintain backward compatibility when possible

**Feature lineage:**
- Track: Raw data → Feature → Model
- Document feature dependencies
- Enable feature impact analysis

#### Online vs Offline Feature Serving

**Offline features (training):**
- Batch computation
- Historical data
- Used for: Model training, batch inference

**Online features (inference):**
- Real-time computation
- Low-latency serving (< 10ms)
- Used for: Real-time inference, user-facing applications

#### Feature Validation & Quality Checks

**Feature validation:**
- Schema validation (types, ranges)
- Missing value checks
- Outlier detection
- Distribution checks

**Feature quality metrics:**
- Missing value percentage
- Outlier percentage
- Distribution drift (PSI, KS test)
- Feature importance (model-based)

#### Feature Monitoring

**Monitor:**
- Feature distribution drift
- Missing value rates
- Outlier rates
- Feature serving latency
- Feature computation errors

**Alerting:**
- Distribution drift > threshold → Alert
- Missing value rate > threshold → Alert
- Serving latency > SLA → Alert

---

### 15.3 Data Quality & Validation

#### Data Validation Frameworks

**Great Expectations (recommended):**
- Declarative data validation
- Profiling and documentation
- Integration with data pipelines
- Automated validation reports

**Pandera:**
- Schema validation for pandas
- Type checking
- Statistical validation
- Good for: Python data pipelines

**Custom validation:**
- SQL checks for data quality
- Python scripts for complex validation
- CI integration for automated checks

#### Data Quality Metrics

**Completeness:**
- Missing value percentage
- Required fields present
- Data coverage (temporal, spatial)

**Accuracy:**
- Label accuracy (if labeled data)
- Value correctness (range checks, format checks)
- Cross-field validation

**Consistency:**
- Format consistency
- Naming consistency
- Value consistency across sources

**Timeliness:**
- Data freshness (last update time)
- Data latency (time to availability)

#### Data Schema Validation

**Schema definition:**
- Define expected schema (types, ranges, formats)
- Validate against schema
- Fail fast on schema violations

**Schema evolution:**
- Version schemas
- Handle backward compatibility
- Document schema changes

#### Data Profiling & Anomaly Detection

**Data profiling:**
- Statistical summaries (mean, std, min, max)
- Distribution analysis
- Correlation analysis
- Missing value analysis

**Anomaly detection:**
- Statistical outliers (Z-score, IQR)
- Unusual patterns
- Distribution shifts
- Data quality degradation

#### Label Quality Validation

**Label validation:**
- Inter-annotator agreement (for human labels)
- Label consistency checks
- Label distribution analysis
- Label error detection

**Label quality metrics:**
- Agreement rate (if multiple annotators)
- Label accuracy (if ground truth available)
- Label coverage (percentage of data labeled)

#### Data Versioning & Lineage

**Data versioning:**
- Version datasets (snapshots)
- Track data changes
- Maintain data history

**Data lineage:**
- Track: Source → Processing → Model
- Document transformations
- Enable impact analysis

#### Data Quality SLAs

**Define SLAs:**
- Completeness: > 95%
- Accuracy: > 99%
- Freshness: < 1 hour
- Latency: < 5 minutes

**Monitor SLAs:**
- Track metrics continuously
- Alert on SLA violations
- Report SLA compliance

---

### 15.4 Model Testing Strategies

#### Unit Tests for Model Components

**Test components:**
- Data loaders
- Preprocessing functions
- Postprocessing functions
- Loss functions
- Metrics calculations

**Example:**
```python
def test_preprocessing():
    input_image = np.random.rand(3, 224, 224)
    processed = preprocess_image(input_image)
    assert processed.shape == (1, 3, 224, 224)
    assert processed.dtype == np.float32
    assert 0 <= processed.min() and processed.max() <= 1
```

#### Integration Tests for Inference Pipelines

**Test full pipeline:**
- Input → Preprocessing → Model → Postprocessing → Output
- Test with sample inputs
- Validate output format and ranges

**Example:**
```python
def test_inference_pipeline():
    input_data = load_test_image()
    output = inference_pipeline(input_data)
    assert output is not None
    assert 'predictions' in output
    assert len(output['predictions']) > 0
```

#### Property-Based Testing for Models

**Test properties:**
- Invariance: Rotated input → same output (if rotation-invariant)
- Equivariance: Translated input → translated output (if translation-equivariant)
- Monotonicity: Larger input → larger output (if applicable)

**Example:**
```python
def test_rotation_invariance():
    image = load_test_image()
    rotated = rotate_image(image, 90)
    pred1 = model(image)
    pred2 = model(rotated)
    assert np.allclose(pred1, pred2, atol=1e-3)
```

#### Model Regression Testing

**Golden dataset testing:**
- Fixed test set with known outputs
- Compare predictions to golden outputs
- Fail if predictions change significantly

**Performance regression:**
- Track metrics over time
- Alert if metrics degrade
- Compare against baseline

#### Adversarial Robustness Testing

**Adversarial testing:**
- Generate adversarial examples
- Test model robustness
- Measure robustness metrics

**Adversarial defense:**
- Adversarial training
- Input preprocessing (denoising)
- Certified defenses (if applicable)

---

### 15.5 Data Pipeline Engineering

#### ETL/ELT Patterns for ML Data

**ETL (Extract, Transform, Load):**
- Extract from sources
- Transform (clean, validate, enrich)
- Load to destination (object storage, feature store)

**ELT (Extract, Load, Transform):**
- Extract and load raw data
- Transform in destination (SQL, Spark)
- Use for: Large-scale data processing

#### Data Pipeline Orchestration

**Orchestration tools:**
- **Airflow:** Mature, Python-based, good for complex DAGs
- **Prefect:** Modern, Python-native, good for ML workflows
- **Dagster:** Data-aware, good for data pipelines

**Pipeline patterns:**
- Linear pipelines (sequential steps)
- DAG pipelines (parallel steps, dependencies)
- Event-driven pipelines (triggered by events)

#### Data Pipeline Testing Strategies

**Test data pipelines:**
- Unit tests for transformations
- Integration tests for full pipeline
- Test with sample data
- Test error handling

**Pipeline validation:**
- Schema validation
- Data quality checks
- Output validation

#### Incremental Data Processing

**Incremental processing:**
- Process only new/changed data
- Use timestamps or change detection
- Reduce processing time and cost

**Incremental patterns:**
- Time-based (daily, hourly)
- Change-based (CDC - Change Data Capture)
- Event-based (triggered by events)

#### Data Pipeline Monitoring & Alerting

**Monitor:**
- Pipeline execution status
- Processing time
- Data quality metrics
- Error rates

**Alerting:**
- Pipeline failures → Immediate alert
- Processing time > threshold → Warning
- Data quality issues → Alert
- Data freshness issues → Alert

---

### 15.6 Production Debugging & Interpretability

#### Model Interpretability Tools

**SHAP (SHapley Additive exPlanations):**
- Feature importance for any model
- Local and global explanations
- Use for: Understanding model decisions

**LIME (Local Interpretable Model-agnostic Explanations):**
- Local explanations for individual predictions
- Model-agnostic
- Use for: Explaining specific predictions

**Grad-CAM (for CV):**
- Visual explanations for CNN predictions
- Highlights important image regions
- Use for: Understanding what model "sees"

**Example:**
```python
import shap
import torch

# Explain model predictions
explainer = shap.Explainer(model, background_data)
shap_values = explainer(input_data)
shap.plots.waterfall(shap_values[0])
```

#### Debugging Failed Predictions

**Error analysis workflow:**
1. Identify failed predictions (low confidence, wrong class)
2. Analyze failure patterns (common characteristics)
3. Visualize failures (show images, highlight issues)
4. Identify root causes (data quality, model limitations)
5. Propose fixes (data augmentation, model improvements)

**Error categories:**
- **False positives:** Model predicts positive but should be negative
- **False negatives:** Model predicts negative but should be positive
- **Low confidence:** Model uncertain about prediction
- **Edge cases:** Unusual inputs that model struggles with

#### Adversarial Example Detection & Defense

**Adversarial detection:**
- Detect adversarial inputs (out-of-distribution detection)
- Reject suspicious inputs
- Log adversarial attempts

**Adversarial defense:**
- Adversarial training (train on adversarial examples)
- Input preprocessing (denoising, smoothing)
- Certified defenses (if applicable)

#### Model Introspection Patterns

**Introspection techniques:**
- Activation visualization (what neurons fire)
- Attention visualization (what model attends to)
- Feature visualization (what features model learns)
- Gradient analysis (what influences predictions)

#### Explainability Requirements

**Regulatory requirements:**
- GDPR: Right to explanation
- Industry-specific regulations
- Compliance documentation

**User trust:**
- Explain predictions to users
- Build confidence in model decisions
- Handle model uncertainty transparently

#### Debugging Production Inference Issues

**Common issues:**
- **Latency spikes:** Investigate input size, model complexity, hardware
- **Memory errors:** Check batch size, model size, memory leaks
- **Accuracy degradation:** Check data drift, model version, preprocessing
- **Inconsistent results:** Check random seeds, model version, preprocessing

**Debugging workflow:**
1. Reproduce issue (capture inputs, outputs, logs)
2. Isolate cause (model, preprocessing, data, hardware)
3. Fix issue (update model, fix preprocessing, retrain)
4. Validate fix (test on production-like data)
5. Deploy fix (gradual rollout, monitor)

**See also:** [AI Mutation Testing & Debugging Reference](../references/ai-mutation-testing-debugging-reference.md) for LLM debugging methods, multi-LLM pipeline debugging, and Anthropic's circuit tracing tools for model interpretability.

---

---

### 15.9 Vector Databases for ML/CV

Vector databases are essential for similarity search, retrieval-augmented generation (RAG), and multi-modal ML/CV applications. This section provides a high-level overview; for comprehensive engineering guidance, see [Vector Database Engineering Guide](references/vector-db-engineering-guide.md).

#### When to Use Vector Databases

**Use cases:**
- **Image similarity search:** Find similar images in large datasets
- **Multi-modal retrieval:** Text-to-image, image-to-text search (CLIP-style)
- **Object detection indexing:** Store and search detected objects with metadata
- **Video frame retrieval:** Temporal similarity search in video datasets
- **Anomaly detection:** Identify outliers by distance from normal embeddings
- **RAG systems:** Retrieve relevant context for LLM prompts

#### Core Concepts

**Vector embeddings:**
- Dense float32 arrays (typically 128-2048 dimensions)
- Generated by embedding models (ResNet, CLIP, sentence transformers)
- Normalized for cosine similarity (L2-normalize before insertion)

**ANN (Approximate Nearest Neighbor) indices:**
- **HNSW (Hierarchical Navigable Small World):** High recall, fast search, memory-intensive
- **IVF (Inverted File Index):** Scalable to billions of vectors, requires training
- **PQ (Product Quantization):** 10x memory compression, ~10% recall loss
- **LSH (Locality Sensitive Hashing):** Fast updates, lower recall

**Metadata filtering:**
- Combine ANN search with metadata indices (inverted index, B-tree)
- Pre-filter vs post-filter strategies depend on selectivity
- Hybrid approach: filter → ANN search → re-rank

#### Production Patterns

**Index construction:**
```python
import faiss
import numpy as np

# HNSW index (high recall)
index = faiss.IndexHNSWFlat(768, 32)  # 768 dims, M=32
index.hnsw.efConstruction = 200
index.hnsw.ef = 100  # Query-time parameter

# Add vectors
embeddings = np.array([...], dtype=np.float32)
faiss.normalize_L2(embeddings)  # Normalize for cosine similarity
index.add(embeddings)
```

**Query pattern:**
```python
# Normalize query vector
query_emb = model.encode(query_image)
faiss.normalize_L2(query_emb)

# Search
distances, indices = index.search(query_emb.reshape(1, -1), k=10)

# Retrieve metadata
results = [metadata[idx] for idx in indices[0]]
```

**Filtering strategy:**
```python
# Pre-filter (if selective)
filtered_ids = metadata_index.query("class_label = 'dog'")  # 1M → 10K
results = ann_index.search(query_vec, filtered_ids, k=10)

# Post-filter (better recall)
candidates = ann_index.search(query_vec, k=1000)  # Over-fetch
results = [c for c in candidates if matches_filter(c)][:10]
```

#### Performance Considerations

**Recall vs latency tradeoff:**
- Higher `ef` (HNSW) or `nprobe` (IVF) → better recall, slower search
- Tune based on production requirements (target: 90-95% recall)

**Memory optimization:**
- Use PQ compression for large datasets (10x reduction, ~10% recall loss)
- Scalar quantization (int8) for 4x compression, ~2% recall loss

**Batch operations:**
- Always batch insertions (never one-by-one)
- Batch queries when possible (amortize overhead)

#### Monitoring

**Key metrics:**
- Query latency (p50, p95, p99)
- Recall (overlap with ground truth)
- Index size and memory usage
- Ingestion throughput

**Alerting:**
- Recall drops below threshold (e.g., <90%)
- Query latency exceeds SLA
- Index size growth rate

#### Common Pitfalls

1. **Normalization mismatch:** Forgetting to normalize both index and query vectors
2. **Insufficient training data (IVF):** Training on too few vectors for cluster count
3. **Ignoring metadata index design:** Storing everything in vector DB instead of separate index
4. **Over-fetching without re-ranking:** Returning raw ANN results without business logic
5. **Not monitoring recall:** ANN indices degrade over time (data drift, fragmentation)

**See also:**
- [Vector Database Engineering Guide](references/vector-db-engineering-guide.md) for comprehensive coverage of ANN structures, data plumbing, production patterns, and benchmarking strategies.
- [RAG Engineering Notes](references/rag-engineering-notes.md) for production RAG system design, chunking strategies, retrieval pipelines, reranking, and evaluation frameworks.

---

**See also:** [MLOps Policy](mlops-policy.md) for comprehensive MLOps practices including experiment tracking, model serving, monitoring, hyperparameter tuning, distributed training, model optimization, deployment patterns, lifecycle management, research methodology, and architecture design.
