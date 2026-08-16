---
doc_type: system
authority: supporting
owner: Alfonso Cruz
scope: Recorded machine state for Fedora_43-Fractal (not normative policy)
---

# Machine State — Fedora_43-Fractal

**Purpose:** Factual snapshot of the primary development workstation. For install conventions (e.g. AppImages), see `rules/development-environment-policy.md`.

**Last updated:** 2026-08-16

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
| Driver version | `580.178.04` |
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

---

## Verified toolchain (2026-08-16)

Factual snapshot of the current workstation. This table does **not** add
install requirements; authoritative machine-setup rules live in
`rules/production-policy.md` and `rules/language-policies.md`.

| Item | Value |
| ---- | ----- |
| OS | Fedora Linux 43 Workstation, x86_64 |
| GPU | NVIDIA GeForce RTX 4070 |
| NVIDIA driver | `580.178.04` |
| Python version manager | pyenv `2.6.17-23-g2c27f446` |
| Active Python | 3.11.9 |
| Package / tool runner | uv `0.11.32` |
| Ruff | `0.14.10` (canonical formatter/linter) |
| mypy | `1.20.2` (canonical strict type checker) |
| pytest | installed and working |
| Pyright | `1.1.411` (available; not authoritative) |
| pre-commit | `4.6.2` |
| make | installed |
| Git | `2.55.0` (default branch `main`; identity configured) |
| GitHub CLI | `gh` `2.87.3`, HTTPS, authenticated as `alfonsocruzvelasco` (`repo`, `workflow`) |
| Docker | `29.6.2` |
| CMake | `3.31.11` |
| Compilers | gcc, g++, clang |
| Ninja | installed |
| nvidia-smi | installed |
| IDEs present | VS Code, Cursor, PyCharm, CLion, DataGrip |
