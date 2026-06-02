# Security Exceptions Registry

**Status:** Authoritative
**Owner:** Security Team
**Last updated:** 2026-04-10
**Policy Reference:** security-policy.md Section 14.6, Section 19 PI-7 (repo-level AI agent configuration), Section 21

---

## Purpose

This document tracks all exceptions to security policies, including
exceptions to prohibited AI tool restrictions (Section 14.6).

All exceptions are time-bounded (maximum 90 days) and require
CISO + VP Engineering approval with documented compensating controls.

---

## Active Exceptions

| ID | Policy Section | Requestor | Approver | Start Date | End Date | Compensating Controls |
|----|----------------|-----------|----------|------------|----------|-----------------------|
| CIFSwitch (CVE-2026-46243) | cifs-utils 7.5 installed on Fedora 43 | Alfonso Cruz | — | 2026-06-01 | 2026-06-15 | cifs-utils installed but CIFS service not running. SELinux enforcing on Fedora 43 prevents the namespace-switching exploit chain per researcher confirmation (Fedora 40-44 default SELinux blocks CIFSwitch). Update kernel when Fedora 43 ships upstream fix (commit 3da1fdf backport). Remove cifs-utils if SMB/CIFS network shares are not actively used. |

## Expired/Closed Exceptions

| CVE-2026-31431 (Copy Fail) | CLOSED 2026-05-27 |
| Linux kernel algif_aead LPE CVSS 7.8. Fedora 41 unpatched — CONFIG_CRYPTO_USER_API_AEAD=y (built-in), modprobe.d mitigation ineffective on RHEL-family. Correct mitigation applied 2026-04-30: initcall_blacklist=algif_aead_init via grubby. Resolved by Fedora 43 upgrade 2026-05-27 — kernel 7.0.8-100.fc43.x86_64 includes upstream fix. Mitigation parameter removed post-upgrade and verified absent in /proc/cmdline. | Alfonso Cruz |

| CVE-2026-34040 | CLOSED 2026-05-27 |
| Docker Engine AuthZ plugin bypass via oversized request body CVSS 8.8. moby-engine 29.0.4 unpatched on Fedora 41 as of 2026-04-10 — no AuthZ plugins active, socket permissions correct, single-user machine. Resolved by Fedora 43 upgrade 2026-05-27 — Docker 29.4.2 ≥ 29.3.1 patched threshold. Verified: docker version --format '{{.Server.Version}}' returns 29.4.2. | Alfonso Cruz |

---

## AI Security Tool Findings Exception Process

**Applies to:** Claude Code `/security-review` findings, Semgrep rules, CodeQL queries

**Process:**
1. Developer runs `/security-review` and identifies non-actionable finding
2. Developer documents finding in PR with justification:
   - Why finding is false positive OR
   - Why compensating controls are sufficient OR
   - Why risk is accepted (with mitigation plan)
3. Security reviewer approves exception
4. Exception logged in this registry with 90-day sunset

**Example exception:**

| ID | Tool | Finding | Justification | Compensating Controls | Sunset |
|----|------|---------|---------------|----------------------|--------|
| EX-001 | Claude Code | Pickle deserialization in legacy_loader.py | Legacy model format, migration scheduled Q3 2026 | Models loaded from verified S3 bucket only, hash validation on download, no user input in model path | 2026-05-15 |

---

## Exception Request Process

1. Submit written justification to security@organization.com
2. Include: tool name, business justification, risk assessment, compensating controls, sunset date
3. Wait for CISO + VP Engineering approval
4. Document approved exception in this file
5. Set calendar reminder for sunset date

## Compensating Controls (Required for All Exceptions)

- Air-gapped environment for tool usage
- No access to production credentials or data
- Manual security review of all generated code
- Dedicated security monitoring
- Daily security audit logs

---

**End of Security Exceptions Registry**
