# AI Tool Policy Quick Reference

**Policy:** security-policy.md Section 14.6 (Prohibited External AI Tool Classes)
**Last Updated:** 2026-02-07

---

## 🚨 TL;DR: What You Need to Know

### ❌ PROHIBITED (Never Use These)
- "chawd.ai", "chad.ai" and similar aggregator services
- Free AI coding tools without enterprise agreements
- Unvetted browser extensions for AI coding
- Self-hosted AI without security hardening
- Any tool not listed in `approved-ai-tools.md`

### ✅ APPROVED (Safe to Use)
- Claude Code (CLI)
- Claude API (Enterprise tier)
- GitHub Copilot Enterprise
- Cursor IDE (with approved API keys)
- OpenAI API (Enterprise tier)
- Ollama (air-gapped dev environments only)

**Full list:** See `approved-ai-tools.md`

---

## 🎯 Quick Decision Tree

```
┌─────────────────────────────────┐
│ Do I need an AI coding tool?    │
└────────────┬────────────────────┘
             │
             ├─ YES → Is it in approved-ai-tools.md?
             │         │
             │         ├─ YES → ✅ Use it (follow restrictions)
             │         │
             │         └─ NO → ❌ Don't use it
             │                  └─ Request approval OR use approved alternative
             │
             └─ NO → No action needed
```

---

## 📋 Before You Use ANY AI Tool, Ask:

1. **Is it in `approved-ai-tools.md`?**
   - YES → Proceed to #2
   - NO → STOP. Request approval or use alternative

2. **Are you using the enterprise/team tier?**
   - YES → Proceed to #3
   - NO → STOP. Upgrade or use different tool

3. **Does your prompt contain sensitive data?**
   - Secrets/credentials → ❌ NEVER share
   - Production code → ⚠️ Sanitize first
   - Proprietary algorithms → ⚠️ Get approval
   - Public info only → ✅ OK

4. **Will you review ALL generated code?**
   - YES → ✅ Proceed
   - NO → ❌ STOP

---

## ⚡ Common Scenarios

### Scenario 1: "I need quick code help"
**❌ DON'T:** Paste code into "chawd.ai" or random AI website
**✅ DO:** Use Claude Code CLI or Cursor IDE with approved keys

**Example:**
```bash
# ✅ APPROVED
claude-code --task "refactor this function for readability"

# ❌ PROHIBITED
# (Opening browser to chawd.ai and pasting code)
```

---

### Scenario 2: "I want to try a new AI model"
**❌ DON'T:** Use first free AI service you find
**✅ DO:** Check `approved-ai-tools.md` or request formal evaluation

**Process:**
1. Email security@organization.com with tool details
2. Wait for security evaluation (~3 weeks)
3. Use approved alternative in the meantime

---

### Scenario 3: "I found a cool browser extension"
**❌ DON'T:** Install random AI extensions
**✅ DO:** Verify it's from official provider (Anthropic, OpenAI, GitHub)

**Check:**
- Extension publisher matches AI provider
- Extension has official endorsement
- Listed in `approved-ai-tools.md`

---

### Scenario 4: "I need to debug production error"
**❌ DON'T:** Paste full stack trace with credentials into AI
**✅ DO:** Sanitize error first, use approved tool

**Sanitization checklist:**
- [ ] Remove all API keys, tokens, passwords
- [ ] Remove internal hostnames and IPs
- [ ] Remove customer/user identifiers
- [ ] Remove file paths revealing infrastructure
- [ ] Remove sensitive variable values

**Example:**
```python
# ❌ PROHIBITED (contains secret)
response = requests.get(
    "https://api.example.com/data",
    headers={"Authorization": "Bearer sk-live-abc123..."}
)

# ✅ SAFE (sanitized)
response = requests.get(
    "https://api.example.com/data",
    headers={"Authorization": "Bearer <REDACTED>"}
)
```

---

### Scenario 5: "AI suggested a package"
**❌ DON'T:** Blindly install AI-suggested packages
**✅ DO:** Verify package legitimacy before installation

**Verification steps:**
1. Check package on official registry (npm, PyPI)
2. Verify package name spelling (no typosquatting)
3. Check package popularity and maintenance
4. Review package dependencies
5. Run security scan: `npm audit` or `pip-audit`
6. Review package code for suspicious patterns

---

## 🔒 Security Best Practices

### Rule 1: Never Share Secrets
**Examples of secrets:**
- API keys (AWS, OpenAI, Anthropic)
- Database passwords
- OAuth tokens
- Private keys
- Session cookies
- Environment variables with credentials

**How to prevent:**
```bash
# Before sharing code with AI:
grep -r "sk-" .          # OpenAI keys
grep -r "AKIA" .         # AWS keys
grep -r "password" .     # Passwords
grep -r "secret" .       # Secrets
```

---

### Rule 2: Sanitize Production Data
**Before sharing with AI:**
- Replace real customer names with "User A", "User B"
- Replace real emails with "user@example.com"
- Replace real IPs with "192.0.2.1" (TEST-NET-1)
- Replace real hostnames with "api.example.com"
- Replace real amounts with rounded approximations

---

### Rule 3: Review Generated Code
**Mandatory checks:**
- [ ] Code matches requested functionality
- [ ] No hardcoded secrets or credentials
- [ ] Input validation present
- [ ] Error handling appropriate
- [ ] No suspicious network calls
- [ ] Dependencies are legitimate
- [ ] Tests pass

---

### Rule 4: Attribution
**For AI-generated code, add comment:**
```python
# AI-Generated: Claude Code (2026-02-07)
# Task: Refactor authentication logic
# Reviewed by: [Your Name]

def authenticate_user(username, password):
    # ... generated code ...
```

---

## 🚫 Violation Consequences

### First Violation
- Documented warning
- Mandatory security retraining
- Manager notification

### Second Violation
- Written warning
- Escalation to senior management
- Temporary tool access suspension

### Third Violation
- Potential termination
- Security incident investigation
- Legal review if malicious

### Malicious Violations
- Immediate termination
- Legal action
- Law enforcement involvement

---

## 🆘 Help and Support

### "I accidentally used a prohibited tool"
1. STOP using it immediately
2. Document what data was shared
3. Email security-incidents@organization.com
4. Follow incident response instructions
5. Rotate any potentially exposed credentials

### "I need a tool exception"
1. Email security@organization.com
2. Provide business justification
3. Propose compensating controls
4. Wait for CISO approval
5. Document exception in `security-exceptions.md`

### "I'm not sure if my tool is approved"
1. Check `approved-ai-tools.md`
2. If not listed, assume prohibited
3. Ask in #security-policy Slack channel
4. Request formal evaluation if needed

### "I found a security issue with an approved tool"
1. Email security-incidents@organization.com immediately
2. Stop using the tool
3. Document the issue
4. Wait for security team guidance

---

## 📚 Additional Resources

### Internal Documentation
- **Full Policy:** `security-policy.md` Section 14.6
- **Approved Tools:** `approved-ai-tools.md`
- **AI Workflow:** `ai-workflow-policy.md`
- **Security Training:** `security-training/prohibited-ai-tools/`

### Tools and Scripts
- **Detection Script:** `system/scripts/ai-prohibited-tools-check.sh`
- **Pre-Commit Hook:** `.pre-commit-config.yaml`
- **CI/CD Integration:** `.github/workflows/security-scan.yml`

### Support Channels
- **Email:** security@organization.com
- **Slack:** #security-policy, #ai-tools-support
- **Incidents:** security-incidents@organization.com

---

## 🔍 Self-Check Before Using AI Tool

```
┌────────────────────────────────────────────────┐
│  AI Tool Usage Self-Check                      │
├────────────────────────────────────────────────┤
│                                                │
│  ☐ Tool is listed in approved-ai-tools.md     │
│  ☐ Using enterprise/team tier (not free)      │
│  ☐ No secrets in my prompt                    │
│  ☐ Sensitive data sanitized                   │
│  ☐ Will review ALL generated code             │
│  ☐ Know how to report violations              │
│                                                │
│  If ALL boxes checked → ✅ Safe to proceed     │
│  If ANY box unchecked → ❌ STOP, get help      │
└────────────────────────────────────────────────┘
```

---

## 💡 Pro Tips

### Tip 1: Use Approved Alternatives First
Don't default to web-based AI. Try these first:
1. Claude Code (best for security review, refactoring)
2. Cursor IDE (best for inline completion, multi-file edits)
3. GitHub Copilot (best for GitHub-integrated workflows)

### Tip 2: Sanitize Early, Sanitize Often
Create a sanitization script for common patterns:
```bash
#!/bin/bash
# sanitize-for-ai.sh
sed -i 's/sk-[a-zA-Z0-9]\{32,\}/<API_KEY_REDACTED>/g' "$1"
sed -i 's/AKIA[A-Z0-9]\{16\}/<AWS_KEY_REDACTED>/g' "$1"
sed -i 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Z|a-z]{2,}/<EMAIL_REDACTED>/g' "$1"
```

### Tip 3: Bookmark This Guide
Add to your browser bookmarks or pin in Slack for quick reference.

### Tip 4: When in Doubt, Ask
Better to ask and wait than to violate policy and risk security incident.

---

**Remember:** The goal is security, not restriction. Approved tools are powerful and safe. Use them confidently! 🚀

---

**Questions?** Ask in #security-policy or email security@organization.com
