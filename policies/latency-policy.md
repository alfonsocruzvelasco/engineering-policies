# Latency Policies (CV/ML Systems)

**Status:** Authoritative  
**Last updated:** 2026-01-15  
**Scope:** Computer Vision (CV) / Machine Learning (ML) perception stacks with real-time constraints.

---

## Acronyms

- **CV** = Computer Vision
- **ML** = Machine Learning
- **E2E** = End-to-end
- **SLA** = Service Level Agreement
- **p50/p95/p99** = latency percentiles
- **FPS** = Frames per second
- **HIL** = Hardware-in-the-loop
- **SoC** = System-on-chip
- **DAG** = Directed Acyclic Graph (pipeline dependency graph)

---

## 1) Purpose

Latency is a **system property**, not a model property.

This policy defines:
- the theory you need to reason about latency correctly
- non-negotiable constraints for real-time CV/ML work
- the typical trade-offs used in production autonomy pipelines (e.g., Mobileye/Waymo-class stacks)

---

## 2) Theory: what latency really is

### 2.1 Latency types (must distinguish)

1) **Algorithmic latency**
- time spent in compute (preprocess → inference → postprocess)

2) **System latency**
- scheduling delays, queueing, memory copies, serialization, IPC, ROS middleware, GPU sync

3) **Sensing-to-actuation latency (true E2E)**
- camera exposure → perception → planning → control → actuator

**Rule:** never optimize one without measuring the others.

---

### 2.2 Percentiles are the truth (not mean)

- A real-time system is dominated by **tail latency**, not average latency.
- Report at minimum:
  - **p50, p95, p99**
  - plus max spikes when relevant

**Rule:** “it runs at 20ms avg” is meaningless if p99 is 120ms.

---

### 2.3 Queueing dominates at scale

Even if inference is fast, any unstable stage causes queue buildup.

Key consequence:
- Latency increases super-linearly once utilization crosses a threshold.

**Rule:** design for *stable utilization* (headroom), not peak throughput.

---

### 2.4 Throughput is not latency

- Throughput = how many frames/sec
- Latency = time per frame including waiting

You can have:
- high throughput and terrible tail latency (batching / queueing)
- low throughput but excellent latency (strict real-time scheduling)

---

## 3) Non-negotiable constraints

### 3.1 Measurement discipline (mandatory)

Every performance claim MUST include:
- hardware target (GPU/CPU, clocks, precision mode)
- input size(s) and pipeline mode
- measurement harness (where timing starts/stops)
- percentiles (p50/p95/p99)
- warmup and steady-state duration

---

### 3.2 Define latency budget up-front

Every real-time CV/ML component MUST declare:
- E2E target (e.g., “<80ms p99 sensing→actuation”)
- perception allocation (e.g., “<30ms p99 perception”)
- sub-stage budget (decode/preprocess/inference/post)

**Rule:** no “optimize later”. Budget first, then design.

---

### 3.3 No optimization without profiling

Before touching code:
- identify the bottleneck stage
- confirm it dominates p99

Profilers:
- CPU: perf
- GPU: Nsight Systems / Nsight Compute
- system: tracing / flamegraphs

---

### 3.4 No regression allowed

Any optimization must include:
- baseline numbers
- new numbers
- acceptance threshold
- rollback plan

---

## 4) Typical production trade-offs (Mobileye/Waymo-class systems)

### 4.1 Accuracy vs latency

Common levers:
- reduce input resolution
- shrink model backbone
- reduce number of heads/tasks
- reduce temporal window length

**Trade-off:** fewer features → more fragile edge cases.

---

### 4.2 Determinism vs maximum performance

Determinism levers:
- fixed batch sizes
- fixed memory pools
- avoiding dynamic shapes
- avoiding Python runtime in critical loop

**Trade-off:** less flexibility; more engineering burden.

---

### 4.3 Batching vs tail latency

Batching increases throughput but hurts p99 and responsiveness.

**Rule of thumb:** batching is usually incompatible with strict real-time perception unless you enforce a hard deadline drop policy.

---

### 4.4 Pipeline parallelism vs complexity

Parallelism improves throughput:
- multi-stream GPU execution
- pipelined stages (decode/infer/post overlap)

**Trade-off:** race conditions, ordering bugs, harder debugging.

---

### 4.5 Model compression vs robustness

Compression options:
- quantization (INT8/FP8)
- pruning
- distillation

**Typical failure modes:**
- rare classes disappear
- calibration drift in unusual lighting/weather
- long-tail degradation not captured in mAP

---

### 4.6 Memory bandwidth dominates on edge

On SoCs/embedded:
- memory movement can dominate inference compute

Optimization focus:
- fuse kernels
- reduce tensor copies
- use NHWC/NCHW layouts correctly
- avoid CPU↔GPU ping-pong

---

## 5) Standard latency tactics (approved)

### 5.1 Architectural
- simplify pipeline DAG
- remove redundant transforms
- enforce bounded queues (backpressure)

### 5.2 ML-side
- smaller backbone
- reduce input dimensions
- early exit networks (when safe)
- reduce temporal aggregation

### 5.3 Compilation/Runtime
- TensorRT / ONNX Runtime acceleration
- static shapes where possible
- pinned memory / zero-copy when applicable
- pre-allocated buffers

---

## 6) Default acceptance criteria (must be written in PRs)

For any latency work:
- p50, p95, p99 before vs after
- “no quality regression” clause OR explicit degraded-metric acceptance
- reproducible benchmark command

---

## 7) Enforcement

- This document is **authoritative**
- Any repo touching CV/ML runtime paths MUST adhere unless exception logged
- Exceptions require entry in `versioning-security-and-documenting-policy.md` (exception log section)
