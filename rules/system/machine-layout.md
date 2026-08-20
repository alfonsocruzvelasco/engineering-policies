# Machine Layout

**Status:** Descriptive system reference
**Last verified:** 2026-08-19

## Purpose

This file is a concise map of **this workstation's current physical and logical layout**.

- Authoritative placement rules remain in `rules/development-environment-policy.md`.
- If this document conflicts with an authoritative policy, **the policy wins**.
- This file records implementation: canonical user-facing paths, backing-storage paths, symlinks, and policy-authorized exceptions.
- It does not create new placement rules, a second taxonomy, or a disk-usage report.

Companion identity/toolchain snapshot: `rules/system/machine-fedora-43-fractal.md`.

## Machine Identity

| Field | Value |
| ----- | ----- |
| Static hostname | `fedora-43-fractal` |
| Pretty hostname | `Fedora_43-Fractal` |
| OS | Fedora Linux 43 Workstation (`VERSION_ID=43`) |
| Kernel | `6.17.8-200.fc43.x86_64` |

## Storage Model

Day-to-day work uses **`$HOME` paths**. Physical bytes sit on a RAID1 LVM stack. `/workspace` is **backing storage**, not a user-facing workflow tree.

```text
nvme0n1 (Samsung SSD 990 PRO 2TB)  ─┐
  p3                               ─┼─ md127 RAID1 (healthy [UU]) ─ VG fedora
nvme1n1 (WD_BLACK SN850X 2000GB)   ─┘
  p3
```

| Mount | Backing LV / device | Role |
| ----- | ------------------- | ---- |
| `/` | `fedora-root` | OS. `/workspace` is a **directory on this filesystem**, not its own mount. |
| `/home` | `fedora-home` | `$HOME`, including `~/dev` and most canonical dirs |
| `/boot` | `nvme0n1p2` | Boot |
| `/boot/efi` | `nvme0n1p1` | ESP |
| `/var/lib/docker` | `fedora-docker` | Docker data |
| `/mnt/devops` | `fedora-data` | Extra LV mount. **Not** part of the `$HOME` taxonomy. |
| `[SWAP]` | `fedora-swap` + `zram0` | Swap |

Boot partitions on `nvme1n1` exist but are not mounted (mirror disk).

## Canonical Home Layout

Semantics live under `$HOME`. Tool-managed dotdirs (`~/.config`, `~/.cache`, `~/.local`, …) exist and are **out of this map**.

| Path | Kind | Meaning |
| ---- | ---- | ------- |
| `~/admin` | directory | Personal admin / paperwork |
| `~/ai` | symlink → `/workspace/ai` | AI/ML notes (no tooling state) |
| `~/apps` | directory | Manually installed user apps / AppImages |
| `~/archive` | directory | Cold storage |
| `~/backup` | directory | Backup scripts, manifests, logs |
| `~/bin` | directory | User scripts on `$PATH` |
| `~/datasets` | symlink → `/workspace/datasets` | Immutable datasets |
| `~/test-data` | directory | Large disposable local test inputs |
| `~/dev` | directory on `/home` | Development tooling, envs, repos |
| `~/docker` | symlink → `/workspace/containers` | Docker / Compose stacks |
| `~/Documents` | directory | Human documents |
| `~/Downloads` | directory | Ephemeral downloads |
| `~/go` | directory | Go workspace |
| `~/learning-repos` | directory on `/home` | Non-authoritative learning & scratch |
| `~/Templates` | directory | Templates |
| `~/tmp_backup` | directory | Temporary safety net |
| `~/vpn` | directory | VPN configs (path only; contents out of scope) |
| `~/policies` | symlink | Convenience view of the policies repo (not a second repo) |

Also present, **not** policy-canonical: `~/Desktop`, `~/Music`, `~/Pictures`, `~/Public`, `~/Videos`, `~/Zotero`, `~/nltk_data`, `~/snap`, `~/thunderbird`. `~/codeql-queries` is an authorized exception (below). `~/Dropbox` exists and is out of scope.

## `/workspace` Backing Storage

`/workspace` is **not** a mount point on this machine. It is a directory on `/` (`fedora-root`), which is itself RAID1-backed via `md127`.

Do **not** treat `/workspace/...` as a parallel taxonomy. Workflows use the `$HOME` paths.

```text
/workspace/
├── ai           # target of ~/ai
├── datasets     # target of ~/datasets
└── containers   # target of ~/docker
```

`~/dev/models` is a real directory on `/home`, not a `/workspace` symlink. Policy-canonical `~/dev/data` is **not present**.

## Development Layout

```text
~/dev/                          # on /home (fedora-home)
├── repos/                      # Git repositories (source of truth)
├── venvs/                      # Python project environments
├── models/                     # model binaries (never committed)
├── build/                      # build output (present; currently empty)
├── devruns/                    # executions / experiments
├── ide/                        # IDE runtime state
│   ├── cursor/
│   ├── jetbrains/
│   └── vscode/
└── policies -> …/engineering-policies   # convenience symlink, not a clone
```

`~/learning-repos/` holds language/topic sandboxes (`python/`, `cpp/`, `computer-vision/`, …) plus a `policies` convenience symlink. It is not a Git source of truth.

## Repository Locations

Git repositories **normally** live under:

```text
~/dev/repos/github.com/<org>/<repo>
```

Observed org directories:

| Path | Role |
| ---- | ---- |
| `~/dev/repos/github.com/alfonsocruzvelasco/` | Personal repos (write) |
| `~/dev/repos/github.com/upstream/` | Third-party clones |
| `~/dev/repos/github.com/organicmoron/` | Additional GitHub org namespace on this machine |

Canonical policies repo:

```text
~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies/
```

The three `policies` paths below are **symlinks to that single repo**, not duplicate checkouts.

## Virtual Environment Locations

| Class | Location |
| ----- | -------- |
| Normal project environments | `~/dev/venvs/<project-name>/` |
| Only allowed repo-local `.venv` | `~/learning-repos/python/<sandbox-name>/.venv/` |

- Repository-local `.venv/` is prohibited in production, portfolio, application, library, and normal development repositories.
- A shared `~/learning-repos/python/.venv` is prohibited and **does not exist**.
- One or more self-contained Python learning sandboxes may currently use this allowed exception.
Presence is descriptive and may change over time.

Authority: `rules/development-environment-policy.md` (narrow Python learning-sandbox exception).

## Important Symlinks

| Path | Target | Kind |
| ---- | ------ | ---- |
| `~/ai` | `/workspace/ai` | RAID-backed storage bridge |
| `~/datasets` | `/workspace/datasets` | RAID-backed storage bridge |
| `~/docker` | `/workspace/containers` | RAID-backed storage bridge |
| `~/policies` | `~/dev/repos/github.com/alfonsocruzvelasco/engineering-policies` | Policy convenience view |
| `~/dev/policies` | same repo | Policy convenience view |
| `~/learning-repos/policies` | same repo | Policy convenience view |

## Explicit Exceptions

| Item | Status | Authority |
| ---- | ------ | --------- |
| `~/codeql-queries` | Present (Git clone of `https://github.com/github/codeql`). Lives outside `~/dev/repos/...`. | `rules/security-policy.md` §15.2, **CodeQL (GitHub Security)** (`git clone … ~/codeql-queries`) |
| `~/learning-repos/python/<sandbox>/.venv/` | Allowed only for self-contained Python learning sandboxes | `rules/development-environment-policy.md` |
| `/workspace` not a dedicated mount | Directory on `fedora-root`; still RAID1-backed through `md127` | Descriptive fact; placement rules unchanged |
| `/mnt/devops` | Mounted `fedora-data` LV; not a `$HOME` workflow path | Descriptive fact |

## Protected / Out-of-Scope Locations

Do not inspect, traverse, summarize, or document contents of:

- `~/Dropbox/`
- credential stores and secrets paths (including `~/.ssh/`, `~/.git-credentials`, password files)
- VPN config contents under `~/vpn/`
- tool-managed dotdirs (`~/.config`, `~/.cache`, `~/.local`, IDE/cloud agent homes)

Paths and structural metadata only.

## Mental Model

- **Work in `$HOME` canonical paths.** `/workspace` is where some of those paths' bytes live.
- **Repos** → `~/dev/repos/github.com/...` (one clone; `*/policies` are views).
- **Project Python envs** → `~/dev/venvs/<project-name>/`.
- **Learning scratch** → `~/learning-repos/` (non-authoritative).
- **Datasets / AI notes / Docker stacks** → `~/datasets`, `~/ai`, `~/docker` (symlinks into `/workspace`).
- **Models / runs / builds / IDE state** → `~/dev/models`, `~/dev/devruns`, `~/dev/build`, `~/dev/ide`.

## Verification Commands

Read-only checks used for this snapshot:

```bash
hostnamectl --static; hostnamectl --pretty
cat /etc/fedora-release
lsblk -o NAME,TYPE,SIZE,FSTYPE,MOUNTPOINTS
findmnt -T / /home /workspace /mnt/devops /var/lib/docker
cat /proc/mdstat
ls -ld /workspace
find /workspace -mindepth 1 -maxdepth 1
find "$HOME" -mindepth 1 -maxdepth 1 -type l -printf '%p -> %l\n'
ls -la "$HOME/dev"
ls -la "$HOME/dev/repos/github.com"
readlink -f "$HOME/policies" "$HOME/dev/policies" "$HOME/learning-repos/policies"
ls -ld "$HOME/codeql-queries"
```
