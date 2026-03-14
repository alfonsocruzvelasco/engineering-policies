# Security Exceptions Registry

**Status:** Authoritative
**Owner:** Security Team
**Last Updated:** 2026-03-12
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
| -  | -              | -         | -        | -          | -        | -                     |

## Expired/Closed Exceptions

| ID | Policy Section | Requestor | Approver | Start Date | End Date | Closure Reason |
|----|----------------|-----------|----------|------------|----------|----------------|
| -  | -              | -         | -        | -          | -        | -              |

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
