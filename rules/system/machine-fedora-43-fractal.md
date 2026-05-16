---
doc_type: system
authority: supporting
owner: Alfonso Cruz
scope: Recorded machine state for Fedora_43-Fractal (not normative policy)
---

# Machine State — Fedora_43-Fractal

**Purpose:** Factual snapshot of the primary development workstation. For install conventions (e.g. AppImages), see `rules/development-environment-policy.md`.

**Last updated:** 2026-05-16

---

## Identity

| Field | Value |
| ----- | ----- |
| Hostname | `Fedora_43-Fractal` |
| OS | Fedora Linux 43 Workstation |

---

## Hardware

| Component | Detail |
| --------- | ------ |
| Motherboard | ASUS ROG STRIX B650E-F |
| CPU | AMD Ryzen 9 7900X |
| RAM | 64 GB |
| Storage | 4 TB |
| GPU (display) | AMD Ryzen 9 7900X iGPU (primary) |
| GPU (compute) | NVIDIA RTX 4070 |

---

## NVIDIA

| Setting | Value |
| ------- | ----- |
| Driver version | `580.159.03` |
| Role | Compute (display on iGPU) |

---

## Package and repo configuration

| Item | State |
| ---- | ----- |
| `/etc/dnf/dnf.conf` | `exclude=kernel` |
| Dropbox repo | Disabled — `/etc/yum.repos.d/dropbox.repo`, `enabled=0` |
| CUDA repo | `cuda-fedora43-x86_64` (migrated from `fedora41` on 2026-05-16) |

---

## Paths and symlinks

| Path | Notes |
| ---- | ----- |
| Ollama models | `/usr/local/lib/ollama` → `~/dev/models/ollama/lib` |
| Cursor | AppImage at `~/apps/cursor.AppImage` (v3.4.20) |
