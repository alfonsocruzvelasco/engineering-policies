---
doc_type: reference
authority: supporting
owner: Alfonso Cruz
scope: Remote GPU Linux desktop access via browser (WebRTC); optional for this stack
---

# Selkies — Remote GPU Workstation via Browser

## Official project

- **Documentation:** [Selkies](https://selkies-project.github.io/selkies/)
- **Upstream:** Selkies-GStreamer — open-source, low-latency, Linux-native GPU/CPU-accelerated WebRTC HTML5 remote desktop streaming (self-hosting, containers, Kubernetes, cloud/HPC). Licensed under **MPL-2.0** (see upstream site for obligations on modified MPL-2.0 files when distributed). For academic publication, upstream requests citation: `Kim, S., Isla, D., Hejtmánek, L., et al., Selkies-GStreamer, (2024), GitHub repository, https://github.com/selkies-project/selkies`

**Governance:** Exposing a full remote desktop over the network requires the same care as any remote-access surface (authentication, network boundaries, secrets, updates). Align deployment with `rules/security-policy.md` and organizational access controls.

---

## 1. What it is

Selkies provides:

- full Linux desktop
- GPU-accelerated
- streamed to browser via WebRTC

**Link:** [https://selkies-project.github.io/selkies/](https://selkies-project.github.io/selkies/)

---

## 2. Core concept

**Remote GPU machine → browser access**

Instead of:

- SSH + CLI

You get:

- full desktop
- GUI apps
- low-latency streaming

---

## 3. Why it matters

### 3.1 ML/CV workflow bottleneck

**Problem:**

- compute ≠ local machine
- GPU often remote (server / cloud)

**Selkies solves:**

- access GPU environment from anywhere
- keep heavy compute remote
- interact visually

---

### 3.2 GUI for ML workflows

Useful for:

- visualization (CV outputs, datasets)
- debugging models
- tools that require GUI

---

### 3.3 Better than traditional remote desktop

**Traditional:**

- VNC → slow
- RDP → limited GPU

**Selkies:**

- WebRTC streaming
- GPU acceleration
- low latency

---

## 4. Architecture

- container-based (Docker)
- Kubernetes-ready
- GPU passthrough
- WebRTC streaming layer

**Conceptually:**

```text
client (browser)
    ↓
WebRTC stream
    ↓
containerized GPU desktop
```

---

## 5. When to use

Use Selkies when:

- working with remote GPU machines
- need GUI (not just CLI)
- using containers for ML workflows
- running experiments on cloud / cluster

---

## 6. When NOT to use

- local development (your RTX 4070 setup)
- simple SSH workflows
- lightweight tasks

---

## 7. Relation to my stack

Relevant to:

- Docker-based ML environments
- GPU workloads (CUDA, PyTorch)
- future remote / cluster setups

---

## 8. Key concepts to learn

- WebRTC for low-latency streaming
- GPU remote execution patterns
- containerized workstations
- separation of compute vs interface

---

## 9. Practical impact

**Now:**

- optional tool
- not required

**Future:**

- useful for:
  - remote GPU
  - distributed ML workflows
  - cloud-based development

---

## 10. Mental model

**SSH** → command access
**Selkies** → full workstation access

---

## 11. One-line takeaway

Bring GPU-powered ML environments to the browser instead of bringing data to your laptop.
