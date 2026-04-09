# Integration Guide: Prohibited AI Tools Policy

**Purpose:** Step-by-step instructions to integrate Section 14.6 (Prohibited AI Tools) into your repository

**Target Repo:** `rules/` directory structure
**Policy Version:** 1.0
**Integration Date:** 2026-02-07

---

## Overview of New Files

This integration adds the following components:

1. **Policy Content:** Section 14.6 for `../security-policy.md`
2. **Tool Registry:** `approved-ai-tools.md`
3. **Detection Script:** `ai-prohibited-tools-check.sh`
4. **Pre-commit Config:** Pre-commit hook integration
5. **Quick Reference:** Developer-facing guide

---

## File Placement in Repository

### Your Current Structure:
```
rules/
├── ../security-policy.md               (existing)
├── ai-workflow-policy.md            (existing)
├── mlops-policy.md                  (existing)
├── system/
│   ├── scripts/
│   │   ├── ai-security-check.sh    (existing)
│   │   └── setup-sops-age.sh       (existing)
│   └── ...
├── templates/                       (existing)
└── ...
```

### After Integration:
```
rules/
├── ../security-policy.md               (MODIFIED: Add Section 14.6)
├── ai-workflow-policy.md            (existing, may reference 14.6)
├── approved-ai-tools.md             (NEW: Tool registry)
├── ai-tool-policy-quick-reference.md  (NEW: Developer guide)
├── system/
│   ├── scripts/
│   │   ├── ai-security-check.sh    (existing)
│   │   ├── ai-prohibited-tools-check.sh  (NEW: Detection script)
│   │   └── setup-sops-age.sh       (existing)
│   └── ...
├── templates/                       (existing)
└── .pre-commit-config.yaml          (MODIFIED: Add AI tool checks)
```

---

## Step-by-Step Integration

### Step 1: Backup Current Files

```bash
# Navigate to repository root
cd /path/to/your/repo

# Create backup branch
git checkout -b backup-pre-ai-policy
git add .
git commit -m "Backup before AI tool policy integration"

# Create working branch for integration
git checkout -b feature/prohibited-ai-tools-policy
```

---

### Step 2: Add Section 14.6 to ../security-policy.md

**Location:** Insert after Section 14.5 (Logging and Audit Expectations)

**Method 1: Manual Integration**

1. Open `../security-policy.md` in editor
2. Find Section 14.5 (around line 694)
3. Copy content from `../security-policy.md` Section 14.6
4. Paste after Section 14.5
5. Verify section numbering (should be 14.6)
6. Update Table of Contents to include:
   ```markdown
   - [Prohibited External AI Tool Classes](#146-prohibited-external-ai-tool-classes)
   ```

**Method 2: Scripted Integration**

```bash
# From repository root
cd rules/

# Insert Section 14.6 after line 694 (end of Section 14.5)
# Section 14.6 content is now integrated directly in ../security-policy.md
awk '/^## 15\)/ {
    while ((getline line < "../security-policy.md") > 0)
        print line;
    print "";
}
{print}' ../security-policy.md > ../security-policy.md.new

mv ../security-policy.md.new ../security-policy.md
```

**Verification:**
```bash
# Check that Section 14.6 exists
grep "^### 14.6" ../security-policy.md

# Check line count increased
wc -l ../security-policy.md  # Should be ~3800+ lines (was 3151)
```

---

### Step 3: Add approved-ai-tools.md Registry

```bash
# From repository root
cp approved-ai-tools.md ../approved-ai-tools.md

# Verify file
ls -lh ../approved-ai-tools.md
```

**Customization Required:**
1. Edit `../approved-ai-tools.md`
2. Update contact emails (search for "@organization.com")
3. Update Slack channels to match your workspace
4. Adjust tool list based on your organization's actual approved tools
5. Set realistic approval/review dates

---

### Step 4: Add Detection Script

```bash
# From repository root
cp ai-prohibited-tools-check.sh rules/system/scripts/ai-prohibited-tools-check.sh
chmod +x rules/system/scripts/ai-prohibited-tools-check.sh

# Test the script
rules/system/scripts/ai-prohibited-tools-check.sh --help
```

**Customization Required:**
1. Edit prohibited patterns based on your organization's specific risks
2. Add any additional prohibited tool names
3. Adjust approved patterns to match your `approved-ai-tools.md`

---

### Step 5: Add Quick Reference Guide

```bash
# From repository root
cp ai-tool-policy-quick-reference.md ../ai-tool-policy-quick-reference.md

# Verify
ls -lh ../ai-tool-policy-quick-reference.md
```

**Customization Required:**
1. Update support channels (Slack, email)
2. Adjust approved tool examples
3. Customize violation consequences to match HR policy

---

### Step 6: Update .pre-commit-config.yaml

**If .pre-commit-config.yaml exists:**

```bash
# From repository root
cat pre-commit-ai-tools-config.yaml >> .pre-commit-config.yaml
```

**If .pre-commit-config.yaml does NOT exist:**

```bash
# From repository root
cp pre-commit-ai-tools-config.yaml .pre-commit-config.yaml
```

**Then install pre-commit hooks:**

```bash
# Install pre-commit if not already installed
pip install pre-commit

# Install the hooks
pre-commit install

# Test the hooks
pre-commit run --all-files
```

---

### Step 7: Update Cross-References

**Files to update:**

1. **ai-workflow-policy.md** (add reference to Section 14.6)
   ```markdown
   ### Core Security Position

   AI coding tools must comply with **../security-policy.md Section 14.6
   (Prohibited External AI Tool Classes)** and only use approved tools
   listed in `approved-ai-tools.md`.
   ```

2. **README.md** (add quick link)
   ```markdown
   ## Quick Links

   - [Security Policy](../security-policy.md)
   - [AI Tool Policy Quick Reference](../ai-tool-policy-quick-reference.md)
   - [Approved AI Tools](../approved-ai-tools.md)
   ```

3. **Table of Contents in ../security-policy.md**
   ```markdown
   ## Table of Contents

   ...
   - [External AI Code Generation Usage Policy](#14-external-ai-code-generation-usage-policy)
     - [Prohibited External AI Tool Classes](#146-prohibited-external-ai-tool-classes)
   ...
   ```

---

### Step 8: Create Supporting Documents

**Create `security-exceptions.md` (referenced in policy):**

```bash
cat > rules/security-exceptions.md <<'EOF'
# Security Exceptions Registry

**Status:** Authoritative
**Owner:** Security Team
**Last updated:** 2026-02-07

---

## Purpose

This document tracks all exceptions to security policies, including
exceptions to prohibited AI tool restrictions (Section 14.6).

---

## Active Exceptions

| ID | Policy Section | Requestor | Approver | Start Date | End Date | Compensating Controls |
|----|----------------|-----------|----------|------------|----------|-----------------------|
| - | - | - | - | - | - | - |

## Expired/Closed Exceptions

| ID | Policy Section | Requestor | Approver | Start Date | End Date | Closure Reason |
|----|----------------|-----------|----------|------------|----------|----------------|
| - | - | - | - | - | - | - |

---

**End of Security Exceptions Registry**
EOF
```

---

### Step 9: Testing and Validation

**Test 1: Policy Rendering**
```bash
# Verify markdown renders correctly
# Open in your markdown viewer or GitHub
cat ../security-policy.md | grep "14.6"
```

**Test 2: Detection Script**
```bash
# Test on clean repository
rules/system/scripts/ai-prohibited-tools-check.sh

# Expected output: "Result: CLEAN"
```

**Test 3: Pre-commit Hooks**
```bash
# Create a test file with prohibited content
echo "# Generated by chawd.ai" > test-violation.md

# Stage it
git add test-violation.md

# Try to commit (should fail)
git commit -m "Test violation detection"

# Expected: Pre-commit hook should block the commit

# Clean up
git reset HEAD test-violation.md
rm test-violation.md
```

**Test 4: Cross-Reference Links**
```bash
# Verify all internal links work
# (This is manual or use a markdown link checker)
npm install -g markdown-link-check
markdown-link-check ../security-policy.md
markdown-link-check ../ai-tool-policy-quick-reference.md
```

---

### Step 10: Commit and Document

```bash
# Review all changes
git status

# Add all new and modified files
git add ../security-policy.md
git add ../approved-ai-tools.md
git add ../ai-tool-policy-quick-reference.md
git add rules/system/scripts/ai-prohibited-tools-check.sh
git add rules/security-exceptions.md
git add .pre-commit-config.yaml

# Commit with descriptive message
git commit -m "feat(security): Add Section 14.6 - Prohibited AI Tool Classes

- Add comprehensive policy on prohibited external AI tools
- Add approved-ai-tools.md registry for allowed tools
- Add ai-prohibited-tools-check.sh detection script
- Add ai-tool-policy-quick-reference.md for developers
- Add pre-commit hooks for automated detection
- Create security-exceptions.md for tracking exceptions
- Update cross-references in ai-workflow-policy.md

Implements security controls for unvetted AI aggregators like 'chawd.ai'
and establishes clear criteria for approved enterprise AI tools.

Policy Ref: ../security-policy.md Section 14.6"

# Push to remote
git push origin feature/prohibited-ai-tools-policy
```

---

## Post-Integration Tasks

### Task 1: Notify Development Team

**Email template:**

```
Subject: [ACTION REQUIRED] New AI Tool Usage Policy - Section 14.6

Hi Engineering Team,

We've added a new security policy section governing external AI code-generation
tools. This policy clarifies which tools are approved and which are prohibited.

**What You Need to Know:**
1. Only tools listed in `approved-ai-tools.md` are approved for use
2. Tools like "chawd.ai" and similar aggregators are prohibited
3. Pre-commit hooks will now check for prohibited tool usage
4. Quick reference guide available: `ai-tool-policy-quick-reference.md`

**Action Required:**
1. Read the quick reference guide (10 min)
2. Verify your current AI tools are on the approved list
3. Remove any prohibited tools from your workflow
4. Update your .git/hooks if using custom pre-commit

**Resources:**
- Quick Reference: [link to ai-tool-policy-quick-reference.md]
- Approved Tools: [link to approved-ai-tools.md]
- Full Policy: ../security-policy.md Section 14.6

**Questions?**
- Slack: #security-policy
- Email: security@organization.com

Thanks,
Security Team
```

---

### Task 2: Update Security Training

1. Add Section 14.6 to onboarding materials
2. Create slides on prohibited vs approved tools
3. Add to quarterly security training
4. Update developer handbook

---

### Task 3: Configure CI/CD Integration

**GitHub Actions Example:**

```yaml
# .github/workflows/security-scan.yml
name: Security Scan

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main]

jobs:
  prohibited-ai-tools:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Check for prohibited AI tool usage
        run: |
          chmod +x rules/system/scripts/ai-prohibited-tools-check.sh
          rules/system/scripts/ai-prohibited-tools-check.sh --strict

      - name: Upload scan results
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: ai-tool-scan-results
          path: ai-tool-violations.log
```

---

### Task 4: Network-Level Blocking (Optional but Recommended)

**If you have enterprise network controls:**

1. **DNS Blocking:**
   ```
   # Add to DNS blocklist
   chawd.ai
   chad.ai
   *.free-ai.com
   *.ai-aggregator.xyz
   ```

2. **Firewall Rules:**
   ```bash
   # Example with iptables (adjust for your firewall)
   iptables -A OUTPUT -d chawd.ai -j REJECT
   iptables -A OUTPUT -d chad.ai -j REJECT
   ```

3. **Proxy Configuration:**
   ```
   # Add to corporate proxy blocklist
   deny url_regex chawd\.ai
   deny url_regex chad\.ai
   deny url_regex free-ai\.
   ```

---

## Verification Checklist

Before considering integration complete, verify:

- [ ] Section 14.6 added to ../security-policy.md
- [ ] Table of Contents updated with Section 14.6
- [ ] approved-ai-tools.md created and customized
- [ ] ai-tool-policy-quick-reference.md created
- [ ] ai-prohibited-tools-check.sh added to system/scripts/
- [ ] security-exceptions.md created
- [ ] .pre-commit-config.yaml updated
- [ ] Pre-commit hooks installed and tested
- [ ] Cross-references updated in other policies
- [ ] Detection script runs successfully
- [ ] All markdown links work
- [ ] Team notification sent
- [ ] CI/CD pipeline configured (optional)
- [ ] Network blocking configured (optional)
- [ ] Security training materials updated

---

## Troubleshooting

### Issue: Pre-commit hook fails on every commit

**Cause:** Script not executable or path incorrect

**Fix:**
```bash
chmod +x rules/system/scripts/ai-prohibited-tools-check.sh
# Verify path in .pre-commit-config.yaml matches actual script location
```

---

### Issue: Script reports false positives

**Cause:** Approved patterns not properly configured

**Fix:**
```bash
# Edit ai-prohibited-tools-check.sh
# Update APPROVED_PATTERNS array to include your actual approved tools
```

---

### Issue: Markdown links broken

**Cause:** Relative paths incorrect after file reorganization

**Fix:**
```bash
# Use absolute paths from repo root
# Example: [Link](../security-policy.md) instead of [Link](../security-policy.md)
```

---

## Rollback Plan

If issues arise during integration:

```bash
# Revert to backup branch
git checkout backup-pre-ai-policy

# Or revert specific commits
git log  # Find commit hash
git revert <commit-hash>

# Remove pre-commit hooks if needed
pre-commit uninstall
```

---

## Maintenance Schedule

**Weekly:**
- Review security-exceptions.md for expired exceptions
- Monitor pre-commit hook failures

**Monthly:**
- Review prohibited tool patterns for new threats
- Update approved-ai-tools.md with new approvals

**Quarterly:**
- Recertify all approved tools
- Update detection script patterns
- Review and update quick reference guide

**Annually:**
- Full policy review and update
- Security training refresh
- Tool evaluation process review

---

## Success Metrics

Track the following to measure policy effectiveness:

1. **Adoption Metrics:**
   - % of developers trained on new policy
   - % of repositories with pre-commit hooks enabled
   - # of tool approval requests received

2. **Compliance Metrics:**
   - # of violations detected by pre-commit hooks
   - # of violations detected in CI/CD
   - # of security exceptions granted

3. **Risk Reduction:**
   - # of prohibited tools removed from workflows
   - # of credentials rotated due to potential exposure
   - # of security incidents related to AI tool misuse

---

## Support and Questions

**Integration Support:**
- Email: devops@organization.com
- Slack: #infrastructure-support

**Policy Questions:**
- Email: security@organization.com
- Slack: #security-policy

**Emergency Security Issues:**
- Email: security-incidents@organization.com
- Phone: [Emergency hotline]

---

**End of Integration Guide**
