# Agents & Sub-Agents in ML/CV Engineering
> A practitioner's reference for understanding and designing agent-oriented CV systems.

---

## TL;DR

Sub-agents are valuable **if they replace brittle scripts, reduce manual intervention, improve observability, and scale across GPUs/datasets**. They are irrelevant if they're just LLM theatrics.

---

## Foundations: What Is an Agent?

An agent is an autonomous unit that:

- has a **goal**
- can **perceive state** (inputs, environment, feedback)
- can **decide** (via policy, logic, or learned behavior)
- can **act** (tools, code, APIs, system calls)
- **owns its lifecycle**

> Think: *"a worker that can think and act on its own."*

**Key properties:**
- Autonomy — operates without constant supervision
- Persistence — maintains state across steps
- Responsibility — owns outcomes, not just actions
- Often exposed as a service or long-running process

---

## What Is a Sub-Agent?

A sub-agent is an agent that:

- exists **under another agent**
- has a **narrow, delegated responsibility**
- does **not own the global goal**
- is created, supervised, or terminated by a **parent agent**

> Think: *"a specialized worker spawned by a manager."*

**Key properties:**
- Scoped autonomy — full control within its domain, no authority outside it
- Task-specific — built for one well-defined job
- Lifecycle controlled by parent — can be spawned, paused, or killed
- Reports results upward — success, failure, or partial output

---

## The Real Difference

> **An agent owns a goal. A sub-agent executes part of someone else's goal.**

This is a purely **architectural** distinction — not about LLMs, prompt counts, "intelligence level", or marketing terms.

---

## Analogies Across Domains

| Domain | Agent | Sub-agent |
|---|---|---|
| Software | Service / orchestrator / controller | Worker / job / task executor |
| Operating system | Process | Thread / child process |
| Organization | Team lead | Individual contributor |
| ML/CV pipeline | Pipeline controller | Dataset validator, training runner, eval checker |

---

## What "Sub-Agents" Look Like in ML/CV

In practice, sub-agents are **specialized, semi-autonomous processes coordinated by a controller**. They take one of these forms:

### 1. Pipeline Agents
Each agent owns a discrete stage:
- Data ingestion / validation
- Preprocessing & augmentation
- Training / fine-tuning
- Evaluation & metrics
- Deployment / monitoring

The orchestration agent sequences these stages, decides when each one runs, and handles failures between them. A pipeline agent never decides what comes next — it just signals done, failed, or partial.

### 2. Tool-Calling Agents
Agents that invoke external systems:
- Python scripts
- CUDA kernels
- OpenCV pipelines
- ffmpeg / GStreamer
- Labeling tools
- Cloud APIs (GCS, S3, Vertex AI, etc.)

The orchestration agent decides *when* and *why* a tool gets called. The tool-calling agent handles *how* — wrapping execution, capturing output, and surfacing errors back up the chain.

### 3. Control / Orchestration Agents
This is the coordinator that gives the two types above their purpose. It:
- Routes tasks to pipeline or tool-calling agents
- Retries failures with backoff
- Enforces constraints (time budgets, GPU memory, quota)
- Logs decisions for observability

Pipeline and tool-calling agents are only meaningful in the context of an orchestration agent above them. Without a coordinator owning the goal, they're just scripts with extra steps.

> **Mental model:** Think **distributed system design**, not "chatbots talking to each other".

---

## In ML/CV Systems: Concrete Role Split

**The agent (coordinator)** owns the pipeline and decides:
- When to train or re-train
- When to promote a checkpoint to production
- When to stop or redirect resources
- How to allocate GPU time and data

**The sub-agents (executors)** handle specific work without knowing why:

| Sub-agent | Scope |
|---|---|
| Dataset validator | Checks integrity, schema, geometry |
| Augmentation worker | Applies transforms, generates variants |
| Training job runner | Submits and monitors a single run |
| Evaluation checker | Computes metrics, compares to baseline |
| Inference worker | Runs forward pass, handles batching |

Sub-agents answer *how well a task was done* — not *whether it should be done*.

---

## Where Sub-Agents Actually Matter in CV

### Dataset Engineering ✅ (Very Relevant)

| Sub-agent | Responsibility |
|---|---|
| Integrity checker | Schema validation, corrupt file detection |
| Statistics agent | Computes class distribution, drift signals |
| Edge-case sampler | Mines hard negatives, rare conditions |
| Label validator | Checks bounding box geometry, mask consistency |

**High-value domains:**
- Autonomous driving (scene diversity, sensor sync)
- Medical imaging (label quality, DICOM compliance)
- Video analytics (temporal consistency, frame dropout)

---

### Training at Scale ✅ (Moderately Relevant)

| Sub-agent | Responsibility |
|---|---|
| Launcher | Submits training jobs to cluster / cloud |
| Monitor | Watches loss curves, flags divergence |
| Controller | Early-stops or re-queues based on rules |
| Comparator | Diffs checkpoints, promotes best model |

**Best fit when:**
- Running many parallel experiments
- Multi-GPU or multi-node setups
- Limited human supervision (overnight runs, CI/CD pipelines)

---

### Inference Pipelines ✅ (Very Relevant in Production)

| Sub-agent | Responsibility |
|---|---|
| Frame ingestion | Decodes video, batches frames |
| Model inference | Runs forward pass, manages TensorRT/ONNX |
| Post-processing | NMS, object tracking, Kalman filtering |
| Alerting / logging | Pushes events, writes to observability stack |

Maps cleanly to **microservice CV systems** — each component independently scalable and replaceable.

---

## When Sub-Agents Are the Wrong Tool ❌

| Anti-pattern | Why it fails |
|---|---|
| "LLM agents deciding architecture" | Non-deterministic, untestable |
| Agents generating training code | Brittle, opaque, hard to debug |
| Over-engineered agent swarms | Complexity without proportional value |
| Prompt-heavy "AI talking to AI" designs | No measurable production signal |

An agent-based design only earns its complexity if it delivers on measurable dimensions: latency (p50/p95), throughput (frames/sec, samples/hour), robustness (failure rate, retry success rate), and observability (trace coverage, alert fidelity).

---

## Precision in Language

Using precise systems language signals sound architectural thinking. The pattern is the same regardless of context: lead with the **problem solved** and the **system property improved**, not with the word "agent".

| ❌ Vague | ✅ Precise |
|---|---|
| "Multi-agent AI system" | "Modular, agent-oriented CV pipeline" |
| "AI workers" | "Autonomous dataset validation workers" |
| "Agent orchestration" | "Supervisor–worker architecture for training orchestration" |
| "Smart inference" | "Fault-tolerant inference pipeline with independent components" |

---

## Design Checklist: Is a Sub-Agent Worth Building?

Before committing to an agent-based design, verify:

- [ ] Does it replace a brittle, hand-maintained script?
- [ ] Does it reduce a human bottleneck (manual review, manual retry)?
- [ ] Can it fail independently without taking down the whole pipeline?
- [ ] Is its success measurable (latency, accuracy, throughput, uptime)?
- [ ] Does it expose logs/metrics to your observability stack?
- [ ] Is it re-deployable or swappable without pipeline changes?

If fewer than 4 boxes are checked → a well-structured class or service may be sufficient.

---

## Key References & Related Concepts

- **MLOps principles** — pipeline modularity, reproducibility, observability
- **Distributed systems** — supervisor/worker, circuit breaker, idempotent retries
- **CV production patterns** — TensorRT serving, DeepStream, GStreamer pipelines
- **Orchestration tools** — Prefect, Airflow, Ray, Kubeflow Pipelines
- **Observability** — OpenTelemetry, Prometheus, Weights & Biases, MLflow

---

*Last updated: 2026-02-23 | Context: ML/CV Engineering — Agent Architecture Notes*
