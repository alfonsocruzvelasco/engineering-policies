# Unified AV Perception Learning Path
## Portfolio-First + Library-Guided Deep Study
**Target**: Mobileye, Waymo (Staff-Engineer code review standard)
**Foundation**: Published 2010 tracking researcher + rusty PyTorch + zero modern detection
**Differentiator**: Classical tracking rigor + production-grade modern ML + deployed systems

---

# EXECUTIVE SUMMARY

This path does **not** teach you ML. You already understand the math.

This path teaches you:
1. **How modern detection actually works** (YOLOv10, DETR) vs your 2010 intuitions
2. **How to code it properly** (CI/CD, testing, reproducibility—not notebooks)
3. **How to deploy it** (quantization, TensorRT, edge constraints)
4. **How to track things at 2024 scale** (neural embeddings + Kalman hybrid)
5. **How to prove it all works** (benchmarks, ablations, failure analysis)

**Timeline flexibility**: 4 stages, completion-driven (not calendar-driven). Can compress to 16 weeks or extend to 48+.

**Unique advantage**: You're not a generic ML engineer. You're a **classical tracking researcher with modern deep learning**. The path leverages this asymmetry.

---

# STAGE 1: Modern Detection Foundations + Code Hygiene
**Duration**: 6-8 weeks
**Goal**: Ship a production-grade detector (not a notebook)
**Prerequisite**: None

## Core Concepts to Understand
- Why YOLO is fundamentally different from Faster R-CNN (single-stage vs two-stage reasoning)
- How anchors work and why anchor-free detection (FCOS, YOLO v8+) matters
- Loss functions: IoU variants (IoU, GIoU, DIoU) and why focal loss handles class imbalance
- NMS: why it's a hack and what Soft-NMS / learning-based alternatives do
- CNN receptive fields: why you can't detect small objects without FPN

## Learning Resources (Directed, Not Random)

**Code Hygiene Foundation** (Days 1-7):
- Read: `Clean Code in Python 2nd Ed` (Chapters 1-4: descriptors, generators, type hints)
- Read: `High Performance Python 2nd Ed` (Chapter 6: profiling with cProfile/kernprof)
- *Why*: You cannot deploy to embedded vehicle hardware if you write inefficient Python. Profiling first, optimize second.

**Detection Architecture Deep Dives**:
- Read: YOLO v10 paper (understand end-to-end single-stage detection)
- Read: RF-DETR paper (Transformers in detection—mandatory for 2024)
- Read: Faster R-CNN paper (understand why two-stage still matters for accuracy)
- Study: `Math and Architectures of Deep Learning` (Focus on Receptive Field calculations, Conv math)

**Classical Refresh**:
- Skim: `Multiple View Geometry` chapter on camera models (you'll need this in Stage 2)

### Topic Relationship Map
```
CNN Backbone (ResNet50/VGG)
  ├─ Convolution & pooling
  ├─ Residual connections
  └─ Feature Pyramid Networks (FPN)
      ↓
Single-Stage Detectors (YOLO)
  ├─ Anchor design & matching (IoU thresholds)
  ├─ Focal loss (class imbalance)
  └─ NMS & post-processing
      ↓
Two-Stage Detectors (Faster R-CNN)
  ├─ Region Proposal Network (RPN)
  ├─ RoI pooling / RoIAlign
  └─ Multi-task loss (classification + regression)
      ↓
Transformer Detectors (DETR/RT-DETR)
  ├─ Query-based detection (set prediction)
  └─ Attention over spatial features
```

---

## MILESTONE PROJECT #1: Production YOLO Detector
**Constraint**: Build from scratch (no `ultralytics` pip install as black box)

### Repository Structure
```
yolo-production-detector/
├── src/
│   ├── backbone.py          (ResNet50 feature extractor)
│   ├── neck.py              (FPN for multi-scale features)
│   ├── head.py              (YOLO head: classification + regression)
│   ├── model.py             (end-to-end model assembly)
│   ├── losses.py            (focal loss, GIoU loss)
│   ├── dataset.py           (custom DataLoader, Albumentations augmentation)
│   ├── train.py             (training loop with validation, early stopping)
│   ├── eval.py              (mAP, precision, recall, F1 calculation)
│   └── inference.py         (batch inference pipeline)
├── configs/
│   └── yolo_config.yaml     (hyperparameters, reproducible)
├── tests/
│   ├── test_backbone.py     (forward pass shapes)
│   ├── test_losses.py       (loss values make sense)
│   ├── test_nms.py          (NMS correctness)
│   └── test_inference.py    (end-to-end pipeline)
├── .github/workflows/
│   └── ci.yml               (GitHub Actions: lint, test, overfit-check on push)
├── docker/
│   └── Dockerfile           (reproducible environment)
├── Makefile                 (make train, make eval, make clean)
├── requirements.txt
├── README.md                (exact steps to reproduce results)
└── notebooks/
    └── error_analysis.ipynb (which classes fail? Why?)
```

### Success Criteria (Verification Benchmarks)
- **mAP@0.5 ≥ 0.50** on held-out test set (COCO or custom AV dataset)
- **mAP@0.5:0.95 ≥ 0.30** (stricter metric)
- **Inference speed**: ≥10 FPS on single GPU (measure with PyTorch profiler)
- **Reproducibility**: Run `make clean && make train` from fresh clone → same results ±1%
- **Code coverage**: ≥80% unit test coverage
- **Error analysis**: Identify failure modes (small objects? occlusion? class imbalance?)

### What It Proves
- Understand modern detection architecture (not just "use PyTorch models")
- Can implement complex PyTorch ops correctly (anchors, IoU, NMS)
- Know detection metrics deeply (mAP, precision-recall, AP at different IoU thresholds)
- Can profile and optimize inference
- Ship production code (CI/CD, testing, reproducibility)

---

## MILESTONE PROJECT #2: Faster R-CNN from Scratch (Partial)
**Constraint**: Implement components yourself (not sklearn.neighbors for NMS)

### Repository Structure
```
faster-rcnn-production/
├── src/
│   ├── backbone.py              (ResNet50)
│   ├── rpn.py                   (Region Proposal Network)
│   ├── roi_pool.py              (RoIAlign with proper handling of scales)
│   ├── head.py                  (classification + bbox regression)
│   ├── model.py
│   ├── anchor_utils.py          (anchor generation, matching with IoU)
│   ├── losses.py                (RPN loss, detection loss)
│   └── inference.py
├── tests/
│   ├── test_rpn.py              (RPN generates ~2000 proposals)
│   ├── test_roi_align.py         (spatial correctness for all scales)
│   ├── test_anchor_matching.py  (anchor-to-GT matching)
│   └── test_end_to_end.py
├── Makefile
├── Dockerfile
└── README.md
```

### Success Criteria
- **RPN recalls >90%** of ground-truth objects (with NMS threshold tuned)
- **RoIAlign output shapes correct** for all FPN levels
- **Unit tests pass** for edge cases (tiny objects <8px, scale variance)
- **Converges to baseline** (within 5% of published Faster R-CNN on COCO)

### What It Proves
- Deep understanding of two-stage detection (not just "YOLO is faster")
- Can implement spatial operations (RoIAlign is non-trivial)
- Understand region proposal logic and why it matters
- Know the accuracy-speed tradeoff in detail

---

## STAGE 1 Milestone Gate
✅ **Must complete ALL before Stage 2:**
1. YOLO detector: mAP ≥ 0.50, code reproducible, CI/CD passing
2. Faster R-CNN: RPN recall >90%, all tests passing
3. **Write technical comparison**: "YOLO vs Faster R-CNN for AV Perception" (Medium post)
   - Include: architecture diagram, speed/accuracy tradeoff, when to use each
   - Honest failure analysis: which one fails on what?
4. **Reproduce published paper results** within 5% accuracy (pick one YOLO or Faster R-CNN paper)

---

# STAGE 2: 3D Perception + Sensor Fusion
**Duration**: 6-8 weeks
**Goal**: Escape 2D image plane; understand real-world AV constraints
**Prerequisite**: Stage 1 complete

## Core Concepts to Understand
- Camera calibration: intrinsic matrix K, distortion coefficients
- Coordinate frame transforms: Camera → Vehicle → World (4x4 homogeneous matrices)
- 3D bounding boxes: 8-corner representation vs center-based representation
- Depth estimation: monocular (no ground truth) vs stereo (dense) vs LiDAR (sparse)
- Uncertainty propagation: how errors compound through sensor fusion
- Point cloud processing: downsampling (voxelization), outlier removal, feature extraction

## Learning Resources (Directed)

**Multi-View Geometry** (Mandatory):
- Read: `Multiple View Geometry in Computer Vision` Chapters 2-4
  - Focus: Camera intrinsics/extrinsics, epipolar geometry, triangulation
- Read: `Camera Models and Fundamental Concepts in CV`
- *Why*: You will be asked to derive frame transforms on a whiteboard at Mobileye/Waymo

**3D Object Detection**:
- Read: KITTI dataset paper (understand benchmark, difficulty levels)
- Read: PointNet++ paper (3D deep learning on point clouds)
- Study: `CV for Autonomous Vehicles` PDF (context for why 3D matters)

**Classical State Estimation** (Refresh):
- Read: `Probabilistic Robotics` chapters on Kalman filtering
- *Why*: You'll implement Kalman filters in Stage 3; understand the math deeply

**Point Cloud Basics**:
- Skim: `PCL Tutorial` (Point Cloud Library concepts)
- *Why*: Understand 3D data structures before working with them

### Topic Relationship Map
```
Camera Intrinsics (K matrix)
  ↓
3D-to-2D projection (camera model)
  ↓
Coordinate Frame Transforms (4x4 homogeneous matrices)
  ├─ Camera frame → Vehicle frame → World frame
  ├─ Rotation matrices (SO(3)) vs full 6-DOF (SE(3))
  └─ Quaternions for robust rotation representation
      ↓
Multi-Sensor Fusion
  ├─ LiDAR-Camera alignment (extrinsic calibration)
  ├─ Point cloud projection onto image plane
  └─ Depth map generation (colorized LiDAR)
      ↓
3D Object Detection
  ├─ Bird's Eye View projection (top-down representation)
  ├─ 3D bounding box regression
  └─ Multi-modal detection (fusion at feature level vs late fusion)
      ↓
Uncertainty Estimation
  ├─ Aleatoric uncertainty (sensor noise)
  └─ Epistemic uncertainty (model confidence)
```

---

## MILESTONE PROJECT #3: LiDAR-Camera Fusion on KITTI
**Constraint**: No for-loops in projection logic (vectorize with NumPy)

### Repository Structure
```
lidar-camera-fusion/
├── src/
│   ├── calibration.py           (load KITTI calib files, build 4x4 matrices)
│   ├── projection.py            (3D→2D projection, vectorized NumPy)
│   ├── point_cloud_utils.py     (downsampling, outlier removal, coloring)
│   ├── kitti_loader.py          (image, LiDAR, calib loading)
│   ├── fusion.py                (end-to-end fusion pipeline)
│   └── visualize.py             (OpenCV/Open3D rendering)
├── tests/
│   ├── test_transforms.py       (matrix operations are correct)
│   ├── test_projection.py       (points project to correct pixel locations)
│   └── test_fusion.py           (end-to-end consistency)
├── notebooks/
│   └── analysis.ipynb           (visualize projections, debug failures)
├── Makefile
└── README.md
```

### Success Criteria
- **Perfect projection**: Project known LiDAR points → verify pixel coordinates match ground truth
- **No Python for-loops** in core projection (NumPy vectorized)
- **Visualization**: Output video with colored point cloud overlay on image
- **Robustness**: Handle edge cases (points behind camera, outside image bounds)
- **Performance**: Process KITTI sequence in real-time (>30 FPS)

### What It Proves
- Master coordinate frame transforms (critical for AV)
- Understand calibration and why it matters
- Can optimize numerical code (NumPy, not loops)
- Know how to handle 3D geometry in practice

---

## MILESTONE PROJECT #4: 3D Object Detection (KITTI)
**Constraint**: Implement from one modern paper (PointNet++ or BEV-based)

### Repository Structure
```
3d-object-detection-kitti/
├── src/
│   ├── kitti_loader.py          (camera, LiDAR, calib, labels)
│   ├── preprocessing.py         (coordinate transforms, normalization)
│   ├── model.py                 (3D detection network)
│   ├── losses.py                (3D IoU loss, corner regression)
│   ├── train.py
│   ├── eval.py                  (AP3D at different difficulty levels)
│   └── inference.py
├── fusion/
│   ├── camera_lidar_fusion.py   (feature-level or late fusion)
│   └── uncertainty.py           (confidence calibration)
├── visualization/
│   └── 3d_bboxes.py             (render 3D boxes in world frame)
├── tests/
│   └── test_metrics.py          (3D IoU calculation correctness)
├── Makefile
└── README.md
```

### Success Criteria
- **KITTI validation AP3D (moderate) ≥ 0.70** for cars
- **Inference speed**: ≥10 FPS on single GPU (real-time constraint)
- **Uncertainty calibration**: Model confidence correlates with error magnitude
- **Ablation study**: Show that LiDAR fusion improves detection by ≥10% vs camera-only

### What It Proves
- Can work with complex multi-modal data
- Understand 3D geometry deeply (8-corner bbox, IoU in 3D)
- Know how to evaluate on real AV benchmarks
- Understand sensor fusion philosophy

---

## MILESTONE PROJECT #5: Monocular Depth Estimation
**Constraint**: Self-supervised learning (no labeled depth ground truth in training)

### Repository Structure
```
monocular-depth-estimation/
├── src/
│   ├── dataset.py               (NYU Depth v2 or KITTI raw)
│   ├── encoder_decoder.py       (encoder-decoder network)
│   ├── losses.py                (photometric loss + depth smoothness)
│   ├── train.py
│   ├── eval.py                  (RMSE, REL, δ<1.25, etc.)
│   └── inference.py
├── analysis/
│   └── failure_cases.ipynb      (where does depth fail? night, reflections?)
├── Makefile
└── README.md
```

### Success Criteria
- **NYU Depth v2 RMSE < 0.60m**
- **Absolute Relative Error < 0.15**
- **Failure analysis**: Honest assessment of edge cases (reflections, dark scenes, transparent objects)

### What It Proves
- Understand self-supervised learning (no labels)
- Know alternative to LiDAR (cameras-only systems like Tesla)
- Can handle tasks where ground truth is expensive

---

## STAGE 2 Milestone Gate
✅ **Must complete ALL before Stage 3:**
1. LiDAR-Camera fusion: reproducible, no loops, real-time
2. 3D detection on KITTI: AP3D moderate ≥ 0.70
3. Monocular depth: RMSE < 0.60m
4. **Write technical report**: "Sensor Fusion for Robust Autonomous Driving Perception"
   - Include ablations (camera-only vs LiDAR-only vs fused)
   - Failure analysis (when does each modality fail?)
5. **Open-source contribution**: Submit bug fix or feature to established AV project (Detectron2, nuscenes-devkit, OpenPCDet)
   - Must be merged (not just PR)

---

# STAGE 3: Tracking & Trajectory Prediction (Your Specialization)
**Duration**: 8-10 weeks
**Goal**: Bridge your 2010 research to modern deep learning tracking
**Prerequisite**: Stage 2 complete

## Core Concepts to Understand
- Why classical Kalman filters still matter (interpretable, fast, low memory)
- Why neural embeddings matter (learn what "same object" means)
- Hungarian algorithm: optimal bipartite matching (review from 2010 work)
- Why transformers are changing tracking (temporal reasoning, long-range dependencies)
- Multi-modal trajectory prediction (multiple plausible futures)
- Track lifecycle management (initialization, confirmation, deletion)

## Learning Resources (Directed)

**Classical Tracking Foundations** (You know this, refresh only):
- Skim: `Probabilistic Robotics` Kalman filtering chapter
- Review: Hungarian algorithm complexity and correctness proof

**Modern Tracking Papers**:
- Read: Deep SORT paper ("Simple Online and Realtime Tracking with a Deep Association Metric")
- Read: ByteTrack paper (no explicit ReID features, associate everything)
- Read: MOTR or TrackFormer (Transformers for tracking)
- *Why*: These papers show how classical (Kalman) + modern (neural) converge

**Trajectory Prediction**:
- Read: Transformer Architecture Explained (understand attention mechanism)
- Read: Papers on social-LSTM, trajectory transformers
- Study: nuScenes prediction challenge (understand multimodality)

**MOT Benchmark Understanding**:
- Study: MOT20 / DanceTrack datasets and metrics (MOTA, MOTP, IDF1)

### Topic Relationship Map
```
Object Detection (Stage 2 output)
  ↓
Detection → Track Association
  ├─ Hungarian algorithm (optimal assignment)
  └─ Deep embeddings (learned association cost)
      ↓
Track State Estimation
  ├─ Kalman filter (motion model)
  └─ Neural state prediction (learned dynamics)
      ↓
Track Lifecycle Management
  ├─ Initialization (new detections → new tracks)
  ├─ Confirmation (N detections → confirmed track)
  └─ Deletion (M frames without detection → delete)
      ↓
Re-Identification (ReID)
  ├─ Train embeddings so same object is close
  └─ Use embeddings as association cost
      ↓
Trajectory Prediction
  ├─ Encoder (past trajectory → latent state)
  ├─ Decoder (latent → future trajectory)
  └─ Multimodal output (K possible futures with probabilities)
      ↓
Behavioral Intent
  ├─ Lane change prediction
  ├─ Turn prediction
  └─ Risk assessment
```

---

## MILESTONE PROJECT #6: Deep SORT + Custom ReID
**Constraint**: Implement Kalman filter yourself (not filterpy library)

### Repository Structure
```
deep-sort-production/
├── detection/
│   └── detector.py              (use Stage 1 YOLO detector)
├── tracking/
│   ├── kalman_filter.py         (custom implementation, not library)
│   ├── track.py                 (Track object, state management)
│   ├── matcher.py               (Hungarian algorithm + embeddings)
│   ├── tracker.py               (main tracking loop)
│   └── reid_network.py          (ResNet-based ReID feature extractor)
├── train/
│   ├── train_reid.py            (train ReID features on person/vehicle data)
│   └── reid_dataset.py          (triplet loss or contrastive loss)
├── evaluation/
│   ├── metrics.py               (implement MOTA, MOTP, IDF1 from scratch)
│   ├── analysis.py              (identify failure modes)
│   └── visualize.py             (video with track IDs and confidence)
├── tests/
│   ├── test_kalman.py           (velocity estimation accuracy)
│   ├── test_hungarian.py        (assignment correctness)
│   ├── test_track_lifecycle.py  (init, confirm, delete logic)
│   └── test_metrics.py          (metric calculation correctness)
├── Makefile
└── README.md
```

### Success Criteria
- **MOT20 test set**: MOTA > 0.55, ID switches < 5000
- **Kalman filter**: Unit tests verify velocity estimation within 2%
- **Hungarian matcher**: Assignment is optimal (verify on small cases by brute force)
- **Real-time**: >30 FPS on standard video
- **Ablation**: Show deep embeddings reduce ID switches by ≥15%

### What It Proves
- Master classical tracking (Kalman filter is non-trivial to implement correctly)
- Understand modern association (embeddings make matching learnable)
- Can implement optimal assignment algorithm
- Know MOT evaluation metrics deeply
- Your domain expertise (tracking) is updated to modern ML era

---

## MILESTONE PROJECT #7: Trajectory Prediction with Transformers
**Constraint**: Implement encoder-decoder transformer (not copy from Hugging Face)

### Repository Structure
```
trajectory-prediction-transformers/
├── data/
│   ├── nuscenes_loader.py       (load nuScenes prediction challenge data)
│   ├── preprocessing.py         (trajectory normalization, sampling)
│   └── augmentation.py          (temporal shifts, reflections)
├── src/
│   ├── transformer.py           (custom encoder-decoder transformer)
│   ├── model.py                 (full prediction pipeline)
│   ├── losses.py                (ADE, FDE, best-of-many loss)
│   ├── train.py
│   ├── eval.py                  (ADE, FDE, collision rate, diversity)
│   └── inference.py
├── analysis/
│   ├── failure_cases.ipynb      (when does prediction fail?)
│   ├── multimodality.ipynb      (do top-K predictions cover reality?)
│   └── attention_viz.ipynb      (visualize which agents influence prediction)
├── tests/
│   └── test_predictions.py      (collision rate < 5%)
├── Makefile
└── README.md
```

### Success Criteria
- **nuScenes prediction**: ADE < 1.0m, FDE < 2.0m (competitive with baselines)
- **Collision rate**: <5% in 3-second horizon
- **Multimodal diversity**: Top-5 predictions span plausible futures (not all identical)
- **Attention analysis**: Show that attention weights correlate with actual agent interactions

### What It Proves
- Understand temporal reasoning with transformers
- Can handle multimodal output (multiple futures, not single deterministic)
- Know how agents interact (attention over other trajectories)
- Critical for planning (predict what others will do)

---

## MILESTONE PROJECT #8: End-to-End Perception Stack
**Constraint**: Integrate Detection + Tracking + Prediction into unified pipeline

### Repository Structure
```
av-perception-stack/
├── detection/               (Stage 1 YOLO detector)
├── tracking/                (Stage 3 Deep SORT tracker)
├── prediction/              (Stage 3 trajectory predictor)
├── fusion/                  (Stage 2 sensor fusion)
├── integration/
│   ├── pipeline.py          (orchestrate detection → tracking → prediction)
│   ├── fusion.py            (multi-modal fusion at feature/decision level)
│   └── metrics.py           (end-to-end evaluation)
├── benchmarks/
│   ├── nuscenes_eval.py     (evaluate full stack on nuScenes)
│   ├── waymo_eval.py        (evaluate on Waymo open dataset)
│   ├── kitti_eval.py        (evaluate on KITTI)
│   └── results_table.py     (generate comparison table)
├── visualization/
│   ├── video_gen.py         (annotated output with predictions)
│   └── interactive_viz.py   (debug tool: show confidence, attention)
├── tests/
│   └── integration_tests.py (all components work together)
├── docker/
│   └── Dockerfile           (reproducible environment)
├── Makefile
└── README.md
```

### Success Criteria
- **nuScenes**: mAP ≥ 0.60, MOTA ≥ 0.55, ADE < 1.2m
- **Waymo open dataset**: Competitive performance on held-out test
- **KITTI**: 3D detection AP3D ≥ 0.70
- **Real-time**: >15 FPS on standard GPU with all components
- **Code review ready**: Modular, tested, documented

### What It Proves
- Can integrate multiple complex components
- Performance across diverse benchmarks
- Production-ready code (error handling, logging, profiling)
- Your full technical breadth

---

## STAGE 3 Milestone Gate
✅ **Must complete ALL before Stage 4:**
1. Deep SORT: MOT20 MOTA ≥ 0.55
2. Trajectory prediction: nuScenes ADE < 1.0m
3. End-to-end system: Evaluate on 3 datasets, produce results table
4. **Publish 2 technical blog posts**:
   - "From Classical Kalman Filters (2010) to Neural Tracking (2024): My Evolution as a Researcher"
   - "Multimodal Trajectory Prediction for Autonomous Vehicles: Why One Future Isn't Enough"
5. **Open-source contribution**: Already completed in Stage 2 gate

---

# STAGE 4: Production Engineering & Safety-Critical Systems
**Duration**: 6-8 weeks
**Goal**: Prove you can deploy to real embedded systems
**Prerequisite**: Stage 3 complete

## Core Concepts to Understand
- Quantization philosophy: int8 inference (3-5x speedup, <5% accuracy loss)
- Knowledge distillation: student network learns from teacher (model compression)
- Pruning: structured (remove filters) vs unstructured (remove weights)
- TensorRT: NVIDIA's inference optimizer (layer fusion, kernel selection, memory optimization)
- Uncertainty quantification: predict confidence, not just detection scores
- Adversarial robustness: test on corrupted inputs (rain, fog, motion blur)
- Safety certification: understand ISO 26262 concepts (fail-safe, fail-operational)

## Learning Resources (Directed)

**Quantization & Compression**:
- Read: `Quantization and Training of Neural Networks for Efficient Integer-Arithmetic Only Inference`
- Read: `Quantization-Int8-FP4 Guides` (practical conversion)
- Skim: `Pruning Strategies for Vision Models`

**Hardware Acceleration**:
- Read: `TensorRT Developer Guide` (layer fusion, optimization passes)
- Skim: `CUDA by Example` (understand memory coalescing, GPU architecture)
- *Why*: Know what TensorRT can and cannot do

**Deployment Infrastructure**:
- Read: `Docker Deep Dive` (containerize your models)
- Read: `gRPC Up and Running` (expose model as service)
- Skim: `Kubernetes Basics` (orchestration, auto-scaling)

**Safety & Robustness**:
- Read: `The Safety-Critical Systems Handbook` (understand certification mindset)
- Study: Uncertainty quantification papers (Bayesian approaches, ensemble methods)

### Topic Relationship Map
```
Trained Model (FP32)
  ↓
Quantization-Aware Training (QAT)
  ├─ Simulated int8 during training
  ├─ Calibration (find optimal scale factors)
  └─ Fine-tuning
      ↓
ONNX Export
  ├─ Device-agnostic intermediate representation
  └─ Version control for models
      ↓
TensorRT Compilation
  ├─ Layer fusion (Conv+ReLU → single kernel)
  ├─ Kernel selection (choose best for target GPU)
  ├─ Memory optimization (reduce intermediate buffers)
  └─ int8 inference with calibration
      ↓
Deployment & Serving
  ├─ Docker containerization
  ├─ gRPC API (expose model)
  └─ Load balancing & monitoring
      ↓
Uncertainty Estimation
  ├─ Aleatoric (sensor noise)
  └─ Epistemic (model uncertainty)
      ↓
Robustness Testing
  ├─ Weather/lighting variations (rain, fog, night)
  ├─ Sensor failures (camera blur, LiDAR dropout)
  └─ Adversarial examples
      ↓
Safety & Monitoring
  ├─ Confidence calibration (ECE < 0.05)
  ├─ Out-of-distribution detection
  ├─ Graceful degradation (what happens when uncertain?)
  └─ Performance monitoring (data drift detection)
```

---

## MILESTONE PROJECT #9: Production-Ready Perception Module
**Constraint**: Achieve <150ms end-to-end latency, <5% accuracy drop

### Repository Structure
```
av-perception-production/
├── src/
│   ├── detector.py              (quantized, production-ready)
│   ├── tracker.py               (production tracker)
│   ├── predictor.py             (production trajectory predictor)
│   └── pipeline.py              (unified interface, error handling)
├── optimization/
│   ├── quantize.py              (QAT, calibration, validation)
│   ├── prune.py                 (structured pruning, fine-tuning)
│   ├── distill.py               (knowledge distillation)
│   └── benchmark.py             (speed/accuracy tradeoff curves)
├── deployment/
│   ├── tensorrt_export.py       (ONNX → TensorRT engine)
│   ├── onnx_export.py           (PyTorch → ONNX)
│   ├── model_server.py          (gRPC service)
│   └── docker/
│       ├── Dockerfile           (reproducible build)
│       └── docker-compose.yml   (local testing)
├── safety/
│   ├── uncertainty.py           (confidence estimation, ECE calibration)
│   ├── adversarial.py          (test on corrupted inputs)
│   ├── sensor_degradation.py    (behavior when sensors fail)
│   └── validation.py            (safety metrics: collision rate, miss rate)
├── monitoring/
│   ├── metrics.py               (latency, throughput, accuracy drift)
│   ├── logging.py               (structured logging for debugging)
│   └── dashboards.py            (Prometheus/Grafana metrics)
├── ci_cd/
│   ├── .github/workflows/
│   │   ├── test.yml             (unit + integration tests)
│   │   ├── benchmark.yml        (latency benchmarks on PR)
│   │   └── safety.yml           (robustness tests)
│   ├── Makefile
│   └── setup.py
├── docs/
│   ├── ARCHITECTURE.md          (system design, data flow)
│   ├── DEPLOYMENT.md            (how to deploy, environment setup)
│   ├── PERFORMANCE.md           (benchmarks, latency breakdown, accuracy comparison)
│   └── SAFETY.md                (failure modes, uncertainty handling, guarantees)
├── tests/
│   ├── unit/
│   │   ├── test_quantization.py
│   │   ├── test_uncertainty.py
│   │   └── test_degradation.py
│   └── integration/
│       └── test_end_to_end.py
└── README.md
```

### Success Criteria
- **Quantization**: <5% accuracy drop vs FP32 (YOLO mAP 0.50 → 0.475 acceptable)
- **TensorRT speedup**: 3-5x faster than FP32 PyTorch
- **Latency**: <150ms end-to-end (detection + tracking + prediction)
- **Uncertainty calibration**: ECE < 0.05 (prediction confidence matches reality)
- **Adversarial robustness**: >80% accuracy under common corruptions (rain, fog, motion blur)
- **Test coverage**: 100% for safety-critical components
- **Reproducibility**: Docker `make build && make test` produces identical results

### What It Proves
- Can optimize models for embedded deployment
- Understand deployment constraints (latency, memory, power)
- Prioritize safety in AV contexts
- Code ready for production code review
- MLOps maturity (monitoring, CI/CD, reproducibility)

---

## MILESTONE PROJECT #10: Open-Source Contribution (Extended)
**Already completed in Stage 2, but now submit Stage 4 work:**

Target projects:
- **Detectron2**: Optimize inference, add int8 quantization support
- **nuScenes devkit**: Add uncertainty estimation helpers
- **OpenPCDet**: Contribute production deployment guide
- **MMCV/MMTracking**: Optimize tracker for real-time deployment
- **ByteTrack**: Add onnx export functionality

### Success Criteria
- PR merged in established project
- Code follows project standards
- Documentation is clear (reproducible contribution)

---

## MILESTONE PROJECT #11: Comprehensive Technical Report & Website
**Constraint**: Production-grade documentation + public portfolio

### Repository Structure
```
av-engineer-portfolio/
├── TECHNICAL_REPORT.md
│   ├── Executive summary (1 page)
│   ├── Problem statement & motivation (why AV perception?)
│   ├── Approach (detection → tracking → prediction → deployment)
│   ├── Experimental results
│   │   ├── Stage 1: Detection benchmarks (YOLO vs Faster R-CNN)
│   │   ├── Stage 2: 3D detection & fusion (KITTI, ablations)
│   │   ├── Stage 3: Tracking & prediction (MOT20, nuScenes)
│   │   └── Stage 4: Production optimization (latency, accuracy, robustness)
│   ├── Ablation studies (what matters most?)
│   ├── Failure analysis (honest assessment of limitations)
│   ├── Comparison to baselines (where do you stand?)
│   ├── Production considerations (deployment, monitoring)
│   └── Future work (next 6 months if hired)
├── figures/
│   ├── architecture_diagrams/
│   │   ├── detection_pipeline.png
│   │   ├── fusion_architecture.png
│   │   ├── tracking_state_machine.png
│   │   └── prediction_transformer.png
│   ├── results_tables/
│   │   ├── stage1_detection_comparison.xlsx
│   │   ├── stage2_3d_detection_ablations.xlsx
│   │   ├── stage3_tracking_metrics.xlsx
│   │   └── stage4_deployment_benchmarks.xlsx
│   ├── failure_cases/
│   │   ├── occlusion_handling.png
│   │   ├── weather_robustness.png
│   │   └── edge_cases.png
│   └── attention_viz/
│       └── tracking_association_attention.mp4
├── code_snippets/
│   └── key_implementations.py (reference implementations of critical components)
└── README.md (how to reproduce all results)
```

### What It Proves
- Can explain complex systems clearly
- Deep understanding of tradeoffs and design choices
- Research-level rigor comparable to PhD thesis
- Communication skills (critical for cross-functional teams at big tech)

---

## STAGE 4 Milestone Gate
✅ **Final Hiring-Ready Checklist:**

### Code Quality
- [ ] All 10 GitHub projects have: README, setup instructions, test suite, CI/CD
- [ ] Code style: black, isort, mypy (static typing)
- [ ] Performance benchmarks documented in each project
- [ ] Reproducibility: Docker files, exact dependency versions (requirements.txt pinned)

### Portfolio Presence
- [ ] Personal website linking to all projects
- [ ] 5+ technical blog posts published (Medium or personal blog)
- [ ] GitHub profile: clear bio, pinned projects, contribution history

### Technical Depth
- [ ] Can explain any project without notes
- [ ] Know failure modes of each component
- [ ] Understand speed/accuracy tradeoffs deeply
- [ ] Can derive key equations on whiteboard

### Safety & Rigor
- [ ] Each project has ablation studies
- [ ] Failure case analysis documented
- [ ] Uncertainty quantification implemented
- [ ] Robustness testing completed

### Mock Interviews
- [ ] 3+ mock interviews with engineers
- [ ] Can explain tracking evolution (classical → modern)
- [ ] Can defend design choices
- [ ] Can discuss what you'd do differently with more time

---

# COMPLETE TOPIC RELATIONSHIP MAP

```
PERCEPTION PIPELINE

┌─────────────────────────────────────────────────────────────┐
│                      INPUT: Video Stream                     │
└────────────────────────────┬────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────┐
│ STAGE 1: 2D OBJECT DETECTION (Image → Bounding Boxes)      │
├─────────────────────────────────────────────────────────────┤
│ CNN Backbone (ResNet, VGG)                                   │
│ ├─ Convolutions (local feature extraction)                  │
│ ├─ Pooling (spatial down-sampling)                          │
│ └─ Residual connections (gradient flow)                     │
│                                                              │
│ Feature Pyramid Networks (multi-scale)                       │
│ ├─ Lateral connections (merge scales)                       │
│ └─ Spatial context (combine local + global)                │
│                                                              │
│ YOLO Head (Single-Stage)                      ┌──────────┐  │
│ ├─ Anchor design (8:1 to 1:8 aspect ratios)   │ Speed    │  │
│ ├─ Focal loss (class imbalance)                │ > Acc    │  │
│ └─ NMS (remove duplicates)                     └──────────┘  │
│         OR                                                    │
│ Faster R-CNN Head (Two-Stage)              ┌──────────┐     │
│ ├─ Region Proposal Network                 │ Accuracy │     │
│ ├─ RoI Pooling / RoIAlign                  │ > Speed  │     │
│ └─ Multi-task loss (cls + reg)             └──────────┘     │
│         OR                                                    │
│ DETR (Transformer-based)              ┌──────────────────┐  │
│ ├─ Query-based set prediction          │ Flexible,        │  │
│ └─ Attention over spatial features     │ End-to-End       │  │
│                                        └──────────────────┘  │
└────────────────────────────┬────────────────────────────────┘
                             ↓
        Output: {(class, x, y, w, h, conf), ...}
                             ↓
┌─────────────────────────────────────────────────────────────┐
│ STAGE 2: 3D PERCEPTION & SENSOR FUSION                      │
├─────────────────────────────────────────────────────────────┤
│ Coordinate Frame Transforms                                  │
│ ├─ Camera intrinsics (K matrix)                             │
│ ├─ 3D → 2D projection                                       │
│ └─ Camera → Vehicle → World frames (SE(3))                 │
│                                                              │
│ LiDAR Processing                                             │
│ ├─ Point cloud downsampling (voxelization)                 │
│ ├─ Outlier removal (statistical filters)                    │
│ └─ Feature extraction (PointNet++, voxel grids)            │
│                                                              │
│ Multi-Modal Fusion                                           │
│ ├─ Feature-level fusion (early: concat features)           │
│ ├─ Decision-level fusion (late: combine predictions)        │
│ └─ Uncertainty propagation (how do errors compound?)       │
│                                                              │
│ 3D Bounding Box Regression                                  │
│ ├─ Bird's Eye View projection (top-down)                   │
│ ├─ 3D center (x, y, z) regression                          │
│ ├─ 8-corner box representation                             │
│ └─ 3D IoU metrics (AP3D@easy/moderate/hard)               │
│                                                              │
│ Depth Estimation (Monocular or Stereo)                     │
│ ├─ Self-supervised learning (no labeled depth)             │
│ └─ Photometric loss (pixel consistency across frames)      │
└────────────────────────────┬────────────────────────────────┘
                             ↓
   Output: {(class, 3D_bbox, depth, confidence), ...}
                             ↓
┌─────────────────────────────────────────────────────────────┐
│ STAGE 3: MULTI-OBJECT TRACKING & TRAJECTORY PREDICTION    │
├─────────────────────────────────────────────────────────────┤
│ Detection → Track Association                                │
│ ├─ Hungarian algorithm (optimal bipartite matching)         │
│ ├─ Association cost matrix                                  │
│ │   ├─ Geometric distance (IoU)                            │
│ │   ├─ Motion distance (Kalman prediction)                 │
│ │   └─ Appearance distance (deep embeddings)              │
│ └─ Detection confidence thresholding                        │
│                                                              │
│ Track State Estimation                                       │
│ ├─ Kalman Filter                                            │
│ │   ├─ State: (x, y, vx, vy) in 2D or 3D                 │
│ │   ├─ Motion model: constant velocity                    │
│ │   ├─ Predict: x_pred = A @ x_prev                       │
│ │   └─ Update: Kalman gain balances prediction vs obs     │
│ └─ Neural Motion Model (learned dynamics)                  │
│                                                              │
│ Track Lifecycle                                              │
│ ├─ NEW: Detection → Create candidate track                │
│ ├─ TENTATIVE: N confirmations → Activate track            │
│ ├─ CONFIRMED: Track is "mature"                           │
│ └─ DELETED: M frames without detection → Remove           │
│                                                              │
│ Re-Identification (ReID)                                     │
│ ├─ Train neural embedding: same object → close vectors     │
│ ├─ Triplet loss (pull same, push different)               │
│ └─ Use embedding distance in association cost matrix       │
│                                                              │
│ Trajectory Prediction                                        │
│ ├─ Encoder: past trajectory → latent representation       │
│ ├─ Decoder: latent → future trajectory (K modes)          │
│ ├─ Transformer: temporal reasoning + agent interactions    │
│ ├─ Social interactions: attention over other agents       │
│ └─ Multimodal: output distribution of futures (not 1)     │
│                                                              │
│ Behavioral Prediction                                        │
│ ├─ Lane change probability                                 │
│ ├─ Turn probability (left/right)                            │
│ └─ Intent classification (turn_left, turn_right, go)      │
│                                                              │
│ Uncertainty Estimation                                       │
│ ├─ Aleatoric: sensor noise, measurement uncertainty       │
│ └─ Epistemic: model uncertainty, distribution shift        │
└────────────────────────────┬────────────────────────────────┘
                             ↓
  Output: {Track_ID, 3D_bbox, trajectory_pred, uncertainty}
                             ↓
┌─────────────────────────────────────────────────────────────┐
│ STAGE 4: PRODUCTION DEPLOYMENT & SAFETY                    │
├─────────────────────────────────────────────────────────────┤
│ Model Optimization                                           │
│ ├─ Quantization (FP32 → INT8, 3-5x speedup)              │
│ ├─ Pruning (remove less important parameters)              │
│ ├─ Knowledge distillation (student learns from teacher)    │
│ └─ Neural Architecture Search (find optimal topology)      │
│                                                              │
│ Hardware Acceleration                                        │
│ ├─ ONNX export (device-agnostic format)                   │
│ ├─ TensorRT compilation                                     │
│ │   ├─ Layer fusion (Conv + ReLU → single kernel)         │
│ │   ├─ Kernel selection (best for target GPU)             │
│ │   └─ Memory optimization                                │
│ └─ Edge deployment (mobile GPU, Jetson, etc.)             │
│                                                              │
│ Real-Time Constraints                                       │
│ ├─ Latency budget: <150ms per frame (10 FPS)             │
│ ├─ Throughput: process N videos in parallel               │
│ └─ Memory: fit model + activations in GPU VRAM            │
│                                                              │
│ Safety & Robustness                                          │
│ ├─ Uncertainty quantification (is model confident?)        │
│ ├─ Out-of-distribution detection (data shift?)             │
│ ├─ Adversarial robustness (rain, fog, corruptions)        │
│ ├─ Graceful degradation (what if sensor fails?)            │
│ └─ Collision avoidance (safety metrics)                    │
│                                                              │
│ Monitoring & Reliability                                     │
│ ├─ Latency profiling (per-component breakdown)           │
│ ├─ Accuracy drift (is performance declining?)              │
│ ├─ Data drift (distribution shift detection)               │
│ ├─ Logging & debugging (what went wrong?)                 │
│ └─ Graceful fallbacks (degrade to classical methods)      │
│                                                              │
│ Deployment Infrastructure                                   │
│ ├─ Containerization (Docker)                               │
│ ├─ API exposure (gRPC, REST)                              │
│ ├─ Load balancing (multiple inference servers)             │
│ └─ Version control (model lineage, reproducibility)       │
│                                                              │
│ Certification & Compliance                                  │
│ ├─ ISO 26262 (safety-critical automotive)                │
│ ├─ Traceability (audit trail for decisions)               │
│ └─ Testing & validation (comprehensive coverage)          │
└────────────────────────────┬────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────┐
│           OUTPUT: Planning Module (Next Stage)               │
│    (Not covered in this path, but feeds the planner)       │
└─────────────────────────────────────────────────────────────┘
```

---

# EXECUTION STRATEGY

## For Each Milestone Project, Follow This Protocol:

### Phase 1: VIBE CHECK (Days 1-3)
- [ ] What am I building? (clear 1-sentence objective)
- [ ] Why does it matter? (how does this fit in AV?)
- [ ] What's success? (quantitative metrics, not "good detection")
- [ ] Read 2-3 key papers (understand the landscape)
- [ ] Study 1 reference implementation (Detectron2, official repo, etc.)

### Phase 2: SPECIFY & PLAN (Days 4-7)
- [ ] Repo structure (sketch directory layout)
- [ ] Data pipeline (where do I get training data?)
- [ ] Success criteria (mAP ≥ X, latency ≤ Y, test coverage ≥ Z%)
- [ ] Failure modes (what will I struggle with?)
- [ ] Timeline (realistic weeks for this component)

### Phase 3: TASK & VERIFY (Days 8-N)
- [ ] Write code (start with data loading, always)
- [ ] Unit tests as you go (not after)
- [ ] TensorBoard / Weights & Biases for experiment tracking
- [ ] Document design decisions (comments, commit messages)
- [ ] Profiling (identify bottlenecks before optimization)

### Phase 4: REFACTOR & OWN (Final Week)
- [ ] Code review (ask someone to review PR)
- [ ] Reproducibility check (clone repo, can I run it?)
- [ ] Error analysis (be honest: what fails? Why?)
- [ ] Blog post (explain your approach, results, lessons)
- [ ] Ablation studies (prove each component matters)

---

# HIRING NARRATIVE: "My 2010→2024 Evolution"

## When interviewers ask: "Tell us about your background"

**Version 1 (Weak)**: "I published a tracking paper in 2010. Now I'm learning modern ML."

**Version 2 (Strong — What to say)**:

> "In 2010, I published research on multi-object human tracking using classical optimization—Kalman filtering, Hungarian matching, re-identification heuristics. The fundamental problem hasn't changed: track objects through time, predict where they're going, handle occlusion gracefully.
>
> But the tools have evolved. Deep learning has made my work obsolete in one way (embeddings replace hand-crafted features), and necessary in another (attention mechanisms explain agent interactions better than heuristics).
>
> Here's my 32-week journey to bridge that gap:
>
> **Stage 1**: I implemented YOLO and Faster R-CNN from scratch, not as black boxes. I learned why single-stage detectors are faster (no RPN), why focal loss matters (class imbalance), and why production code requires testing and profiling, not just accuracy.
>
> **Stage 2**: I built sensor fusion pipelines. I learned 3D geometry (camera calibration, frame transforms) and why autonomous driving escapes 2D. I implemented LiDAR-camera fusion on KITTI—understanding that real perception is multi-modal.
>
> **Stage 3**: This is where my 2010 expertise met 2024 methods. I implemented Deep SORT from scratch (Kalman filter, Hungarian matching, neural embeddings). But I added transformers for trajectory prediction, handling the multimodal nature of futures. My classical background made me understand *why* this works: the math is the same, but learned embeddings are more powerful than hand-crafted features.
>
> **Stage 4**: I optimized for deployment. Quantization brought 3-5x speedup. TensorRT compilation. Uncertainty quantification (is my model confident?). Production-grade monitoring and graceful degradation.
>
> **The result**: 10 reproducible GitHub projects, all with benchmarks, ablations, failure analyses. My MOT20 tracker achieves 0.55 MOTA. My trajectory predictor gets < 1.0m ADE on nuScenes. My quantized detector runs at 15 FPS end-to-end.
>
> What makes this different from a fresh ML engineer: I understand the classical foundations deeply. I know *why* Hungarian algorithm works. I can derive Kalman equations. When neural methods replace classical ones, I understand both what was lost and what was gained."

---

# FINAL CHECKPOINT BEFORE APPLYING

**Print this. Check every box before submitting to Mobileye/Waymo:**

### GitHub Portfolio
- [ ] 10 projects, all with:
  - README explaining setup, data, running experiments
  - Exact dependency versions (requirements.txt pinned)
  - Docker file (reproducible environment)
  - GitHub Actions CI/CD (tests pass on every push)
  - Unit tests (>80% coverage for critical components)
  - Performance benchmarks (speed, accuracy measured)
- [ ] All repos are public and code is clean (no debug prints, no commented code)

### Blog & Documentation
- [ ] 5+ technical blog posts published
  - "My tracking journey: 2010 classical → 2024 deep learning"
  - "YOLO vs Faster R-CNN for autonomous driving perception"
  - "Sensor fusion for robust 3D detection"
  - "Implementing Deep SORT: Kalman filters + neural embeddings"
  - "Quantization for real-time inference: tradeoffs and deployment"
- [ ] Comprehensive technical report (detection → tracking → prediction → deployment)

### Technical Depth
- [ ] Can explain without notes:
  - Why focal loss handles class imbalance
  - How RoIAlign works (spatial correctness)
  - Hungarian algorithm complexity (O(n³) but optimal)
  - Kalman filter equations (predict, update steps)
  - Attention mechanism (Q, K, V matrices)
  - Quantization calibration (int8 scale factors)
- [ ] Can derive on whiteboard:
  - Backprop for convolution
  - Kalman update rule
  - IoU loss derivatives
- [ ] Know limitations:
  - When does tracking fail? (occlusion, re-entry)
  - When does prediction fail? (long horizons, rare behaviors)
  - When does quantization hurt? (low-bit activations)

### Safety & Rigor
- [ ] Each project has:
  - Ablation studies (what matters most?)
  - Failure case analysis (honest: what breaks?)
  - Robustness testing (corruptions, sensor failures)
  - Uncertainty quantification (can my model be confident?)
  - Comparison to baselines (where do I stand?)

### Professional Presence
- [ ] Personal website (portfolio site, not LinkedIn brag)
  - Clean design, not flashy
  - Links to GitHub, blog, papers
  - Brief bio: your story, your focus
- [ ] GitHub profile:
  - Clear bio mentioning autonomous driving / perception
  - Pinned 3 best projects
  - Consistent commit messages
  - No random forks or tutorials
- [ ] LinkedIn updated but not overdone

### Mock Interviews
- [ ] 3+ practice sessions with engineers / mentors
  - 45-min technical deep dive on one project
  - Whiteboard: design a detection pipeline
  - Whiteboard: optimize inference latency
  - Tricky questions: "Your tracker loses identity on occlusion. How do you fix it?"
  - Be honest about what you don't know

### Final Sanity Check
- [ ] **Can you run this command and get the same results?**
  ```bash
  git clone https://github.com/[you]/[project]
  cd [project]
  make clean
  make train
  make eval
  # Results match README exactly
  ```
- [ ] **Can you explain every line of code in your projects?**
  - No copy-paste from tutorials
  - Every design choice intentional
- [ ] **Do your repos look like senior engineer code?**
  - Clear naming (not `x`, `y`, `tmp`)
  - Docstrings (not obvious, but non-trivial functions)
  - Type hints (Python 3.8+ style)
  - Tested (pytest runs clean)

---

# RESOURCES SUMMARY

## By Stage (Use Your Library)

| Stage | Topic | Resource |
|-------|-------|----------|
| 1 | Python Hygiene | `Clean Code in Python 2nd Ed` |
| 1 | Performance | `High Performance Python 2nd Ed` (Chapter 6) |
| 1 | Detection | `Math and Architectures of Deep Learning` |
| 1 | YOLO/DETR | Official papers (v10 / RF-DETR) |
| 2 | Geometry | `Multiple View Geometry in CV` (Chapters 2-4) |
| 2 | Camera Models | `Camera Models and Fundamental Concepts in CV` |
| 2 | State Estimation | `Probabilistic Robotics` (Kalman chapters) |
| 2 | 3D Perception | `CV for Autonomous Vehicles` |
| 3 | Tracking Papers | Deep SORT, ByteTrack, MOTR (add to library) |
| 3 | Transformers | `Transformer Architecture Explained` |
| 3 | MOT Metrics | MOT Challenge documentation |
| 4 | Quantization | `Quantization-Int8-FP4 Guides` |
| 4 | TensorRT | `TensorRT Developer Guide` |
| 4 | Deployment | `Docker Deep Dive`, `gRPC Up and Running` |
| 4 | Safety | `Safety-Critical Systems Handbook` |

## Paper Additions Needed

Add to your library (3 files):
- `deep_sort.pdf` (Simple Online and Realtime Tracking with a Deep Association Metric)
- `bytetrack.pdf` (ByteTrack: Multi-Object Tracking by Associating Every Detection Box)
- `motr_or_trackformer.pdf` (Transformer-based tracking)

Place in: `3-cv-core/detection-segmentation-tracking/`

---

# COMPRESSION OPTIONS

### If 32 weeks is too long (16-week sprint):
1. Skip monocular depth (Project #5)
2. Implement Deep SORT + Transformers as single project
3. Focus on production deployment (Stage 4)
4. Result: 6 projects instead of 10 (detection, fusion, 3D detection, tracking, trajectory, production)

### If 32 weeks is too short (48+ weeks):
1. Add Stage 5: Motion Planning & Control Integration
2. Implement end-to-end driving (perception → planning → control)
3. Deploy on CARLA simulator
4. Add sensor-in-the-loop testing (real camera feeds)

---

# KEY INSIGHTS

1. **Your advantage is classical tracking knowledge**. Don't hide it. Lean into the evolution narrative.

2. **Production code beats research code**. TensorRT deployment > fancy architectures.

3. **Reproducibility is your credibility**. If someone clones your repo in 6 months and gets different results, you've failed.

4. **Failure analysis is more impressive than success**. "Here's why my detector fails on small objects and how I'd fix it" > "My mAP is 0.50".

5. **Ablations prove you understand**. "Remove ReID embeddings → MOTA drops from 0.55 to 0.42 because Hungarian matching gets worse" is PhD-level thinking.

6. **Interviews care about tradeoffs, not perfection**. "Why quantization? Because latency mattered more than 2% accuracy" is a great answer.

---

# THE PROMISE

If you execute this path—all 10 projects, all 4 stages, all benchmarks, all ablations—you will be **unhireable by coincidence and hireable by design**.

Mobileye and Waymo don't need another ML engineer. They have hundreds.

They need someone who:
- Understands classical and modern tracking
- Ships production code (not notebooks)
- Proves every claim with benchmarks
- Handles edge cases and failure modes
- Can explain complex systems clearly

This path builds that engineer.

---

**Start today. No more planning. Ship Project #1 (YOLO detector) in 2 weeks. Make it reproducible. Write a blog post. Move to the next.**

**32 weeks from now, you'll have a portfolio that speaks for itself.**
