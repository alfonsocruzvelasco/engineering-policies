# Notes — RAID1 pairing + `/workspace` policy (Fedora 41)

## 1) What RAID1 means in my system

* I have **two physical NVMe disks** (2 TB each).
* They are configured as a **RAID1 mirror**.
* RAID1 guarantees that **every write is duplicated to both disks automatically**.
* Therefore: the “other disk” is **always paired** and contains the same data as the first disk (as long as RAID is healthy).

---

## 2) Proof that RAID1 is healthy (verified outputs)

### `/proc/mdstat`

Command:

```bash
cat /proc/mdstat
```

Observed:

* `md127 : active raid1 nvme1n1p3[0] nvme0n1p3[1]`
* `[2/2] [UU]`

Meaning:

* RAID1 array is active.
* Both disks are present in the mirror.
* `[UU]` = **both members Up/healthy** (no degraded mode).

---

### `mdadm --detail`

Command:

```bash
sudo mdadm --detail /dev/md/vg_raid
```

Observed:

* `Raid Level : raid1`
* `Working Devices : 2`
* `Failed Devices : 0`
* Both listed as `active sync`:

  * `/dev/nvme1n1p3`
  * `/dev/nvme0n1p3`

Meaning:

* RAID mirror is fully operational.
* **Both disks are actively synchronized.**
* No failures, no spares, no degradation.

---

## 3) What `/workspace` means (policy)

* `/workspace` is a **mount point for the RAID-backed storage layer**.
* `/workspace` is not a semantic taxonomy and should not be used directly for workflows.
* Canonical semantics live under `~` only.

Policy summary:

* `~` = meaning + workflow paths (`~/dev`, `~/learning`, etc.)
* `/workspace` = physical RAID backing only
* bridge = symlink targets only (example: `~/datasets -> /workspace/datasets`)

---

## 4) Important conclusion

✅ The “other disk” is correctly paired.
✅ RAID1 is healthy (`[UU]`, both `active sync`).
✅ Therefore **all data stored under `/workspace` is automatically present on both physical disks**.

---

## 5) Optional final verification (mount chain)

To confirm what device backs `/workspace`:

```bash
findmnt /workspace -o SOURCE,FSTYPE,SIZE,USED,AVAIL,TARGET
```

Expected:

* Source is `/dev/md/vg_raid` **or** an LVM LV built on top of it.
* Either way, `/workspace` remains RAID1-backed.
