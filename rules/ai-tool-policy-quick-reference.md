# AI Tool Policy Quick Reference

**Policy:** `rules/security-policy.md` Section 14.6 (Prohibited External AI Tool Classes)
**Registry:** `rules/approved-ai-tools.md`
**Last Updated:** 2026-02-07
**Target Audience:** All engineers using AI-assisted development tools

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

**Full list:** See `rules/approved-ai-tools.md`

---

## 🎯 Quick Decision Tree

```
┌─────────────────────────────────────────────────────────┐
│ Do I need an AI coding tool?                            │
└────────────┬────────────────────────────────────────────┘
             │
             ├─ YES → Is it in approved-ai-tools.md?
             │         │
             │         ├─ YES → Are you using enterprise tier?
             │         │         │
             │         │         ├─ YES → Does prompt contain secrets?
             │         │         │         │
             │         │         │         ├─ NO → ✅ Use it (follow restrictions)
             │         │         │         │
             │         │         │         └─ YES → ❌ STOP. Sanitize first
             │         │         │
             │         │         └─ NO → ❌ STOP. Upgrade to enterprise tier
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

## ⚡ Common Scenarios (Detailed)

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

**Why it matters:**
- Unvetted services may log your code indefinitely
- No guarantee your proprietary code won't be used for training
- No audit trail or access controls
- Risk of credential exposure if secrets are in code

**Approved alternatives:**
- Claude Code CLI (best for refactoring, security review)
- Cursor IDE (best for inline completion, multi-file edits)
- GitHub Copilot Enterprise (best for GitHub-integrated workflows)

---

### Scenario 2: "I want to try a new AI model"

**❌ DON'T:** Use first free AI service you find
**✅ DO:** Check `approved-ai-tools.md` or request formal evaluation

**Process:**
1. Email security@organization.com with tool details
2. Wait for security evaluation (~3 weeks)
3. Use approved alternative in the meantime

**What to include in your request:**
- Tool name and vendor
- Intended use case
- Business justification
- Security documentation (if available)
- Compliance certifications (if any)

**Evaluation timeline:**
- Initial screening: 3 business days
- Full evaluation: 10 business days
- Approval decision: 5 business days
- Total: ~3 weeks from request to decision

---

### Scenario 3: "I found a cool browser extension"

**❌ DON'T:** Install random AI extensions
**✅ DO:** Verify it's from official provider (Anthropic, OpenAI, GitHub)

**Check:**
- Extension publisher matches AI provider
- Extension has official endorsement
- Listed in `approved-ai-tools.md`

**Red flags:**
- Publisher name doesn't match official provider
- Requests broad permissions (filesystem, network, clipboard)
- No security audit or code signing
- Unknown update mechanism
- Closed-source or obfuscated code

**Why it matters:**
- Extensions can exfiltrate your entire repository
- May intercept API keys and credentials
- Can inject malicious code into your IDE
- No accountability if something goes wrong

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
- [ ] Remove database connection strings
- [ ] Remove session IDs and cookies
- [ ] Remove authentication headers

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

**Sanitization script example:**
```bash
#!/bin/bash
# sanitize-for-ai.sh
sed -i 's/sk-[a-zA-Z0-9]\{32,\}/<API_KEY_REDACTED>/g' "$1"
sed -i 's/AKIA[A-Z0-9]\{16\}/<AWS_KEY_REDACTED>/g' "$1"
sed -i 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Z|a-z]{2,}/<EMAIL_REDACTED>/g' "$1"
sed -i 's/192\.168\.\d+\.\d+/<INTERNAL_IP_REDACTED>/g' "$1"
sed -i 's/password[=:]\s*\S+/password=<REDACTED>/gi' "$1"
```

---

### Scenario 5: "AI suggested a package"

**❌ DON'T:** Blindly install AI-suggested packages
**✅ DO:** Verify package legitimacy before installation

**Verification steps:**
1. Check package on official registry (npm, PyPI, Maven, etc.)
2. Verify package name spelling (no typosquatting)
3. Check package popularity and maintenance
4. Review package dependencies
5. Run security scan: `npm audit`, `pip-audit`, `safety check`
6. Review package code for suspicious patterns
7. Check package maintainer reputation
8. Verify package hasn't been compromised

**Common typosquatting patterns:**
- `requests` vs `requets` (typo)
- `lodash` vs `lodahs` (typo)
- `express` vs `expres` (typo)
- `tensorflow` vs `tensorfow` (typo)

**Security scanning commands:**
```bash
# Python
pip-audit
safety check
bandit -r .

# Node.js
npm audit
npm audit fix

# Go
go list -json -m all | nancy sleuth
```

---

### Scenario 6: "I need to generate tests"

**❌ DON'T:** Use unvetted tool with production code
**✅ DO:** Use approved tool with test-only context

**Best practices:**
- Only share test-related code, not production logic
- Use Cursor IDE with test-only file context
- Generate tests in isolated branch
- Review all generated tests before committing
- Ensure tests follow project testing standards

**Example workflow:**
```bash
# ✅ APPROVED
# 1. Create test branch
git checkout -b feature/add-tests

# 2. Use Cursor IDE with only test file open
# 3. Generate tests using approved model
# 4. Review generated tests
# 5. Run tests to verify
pytest tests/

# 6. Commit after review
git commit -m "Add tests (AI-generated, reviewed)"
```

---

### Scenario 7: "I need to refactor legacy code"

**❌ DON'T:** Upload entire codebase to unvetted tool
**✅ DO:** Use approved tool with scoped file access

**Refactoring best practices:**
- Refactor one file/function at a time
- Use Claude Code with explicit file scope
- Review each change before proceeding
- Maintain test coverage throughout
- Document refactoring decisions

**Example:**
```bash
# ✅ APPROVED
claude-code --file src/auth.py --task "Refactor authenticate_user function for readability"

# ❌ PROHIBITED
# Uploading entire codebase to web-based AI tool
```

---

### Scenario 8: "I want to use a local LLM"

**❌ DON'T:** Set up unhardened local LLM with production access
**✅ DO:** Use Ollama in air-gapped development environment

**Requirements for self-hosted LLMs:**
- MUST be air-gapped (no internet access)
- MUST NOT process production data
- MUST NOT have access to production credentials
- MUST be in isolated development environment
- MUST NOT be used for production workloads

**Approved setup:**
```bash
# ✅ APPROVED (air-gapped dev environment)
# Install Ollama on isolated dev machine
# No network access to production systems
# Only process non-sensitive development code
```

---

## 🔒 Security Best Practices (Comprehensive)

### Rule 1: Never Share Secrets

**Examples of secrets:**
- API keys (AWS, OpenAI, Anthropic, GitHub)
- Database passwords and connection strings
- OAuth tokens and refresh tokens
- Private keys (SSH, GPG, TLS)
- Session cookies and session IDs
- Environment variables with credentials
- Service account keys
- JWT signing keys
- Encryption keys

**How to prevent:**
```bash
# Before sharing code with AI, scan for secrets:
grep -r "sk-" .              # OpenAI keys
grep -r "AKIA" .             # AWS keys
grep -r "password" .         # Passwords
grep -r "secret" .           # Secrets
grep -r "token" .            # Tokens
grep -r "api_key" .          # API keys
grep -r "private_key" .      # Private keys

# Use tools like:
git-secrets scan
trufflehog filesystem .
detect-secrets scan
```

**Secret detection tools:**
- `git-secrets` - Git hook for preventing secrets
- `trufflehog` - Comprehensive secret scanning
- `detect-secrets` - Python-based secret detection
- `gitleaks` - Fast secret scanning for Git repos

---

### Rule 2: Sanitize Production Data

**Before sharing with AI:**
- Replace real customer names with "User A", "User B"
- Replace real emails with "user@example.com"
- Replace real IPs with "192.0.2.1" (TEST-NET-1)
- Replace real hostnames with "api.example.com"
- Replace real amounts with rounded approximations
- Replace real dates with generic dates
- Replace real UUIDs with example UUIDs
- Replace real file paths with generic paths

**Data sanitization patterns:**
```python
# Example sanitization function
def sanitize_for_ai(text):
    # Replace emails
    text = re.sub(r'[\w\.-]+@[\w\.-]+\.\w+', 'user@example.com', text)

    # Replace IPs
    text = re.sub(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b', '192.0.2.1', text)

    # Replace API keys
    text = re.sub(r'sk-[a-zA-Z0-9]{32,}', '<API_KEY_REDACTED>', text)

    # Replace AWS keys
    text = re.sub(r'AKIA[A-Z0-9]{16}', '<AWS_KEY_REDACTED>', text)

    return text
```

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
- [ ] Code follows project style guide
- [ ] Performance considerations addressed
- [ ] Security best practices followed
- [ ] No SQL injection vulnerabilities
- [ ] No command injection vulnerabilities
- [ ] No path traversal vulnerabilities
- [ ] No XSS vulnerabilities (if web code)

**Code review checklist:**
```markdown
## AI-Generated Code Review Checklist

### Functionality
- [ ] Code does what was requested
- [ ] Edge cases handled
- [ ] Error cases handled
- [ ] Performance acceptable

### Security
- [ ] No secrets in code
- [ ] Input validation present
- [ ] Output encoding present (if needed)
- [ ] Authentication/authorization correct
- [ ] No injection vulnerabilities

### Quality
- [ ] Code is readable
- [ ] Follows style guide
- [ ] Has appropriate comments
- [ ] No obvious bugs

### Testing
- [ ] Tests written
- [ ] Tests pass
- [ ] Coverage adequate
```

---

### Rule 4: Attribution

**For AI-generated code, add comment:**
```python
# AI-Generated: Claude Code (2026-02-07)
# Task: Refactor authentication logic
# Reviewed by: [Your Name]
# Security Review: Passed

def authenticate_user(username, password):
    # ... generated code ...
```

**Attribution format:**
- Tool name and date
- Task description
- Reviewer name
- Security review status (if applicable)

---

### Rule 5: Use Approved Tools Only

**Check before using:**
1. Is tool in `approved-ai-tools.md`?
2. Are you using the correct tier (enterprise/team)?
3. Are API keys configured correctly?
4. Are privacy settings enabled?

**Tool configuration checklist:**
- [ ] Using enterprise/team tier
- [ ] API keys are from approved source
- [ ] Privacy mode enabled (if available)
- [ ] Data retention settings configured
- [ ] Audit logging enabled
- [ ] Access controls configured

---

### Rule 6: Monitor and Audit

**Regular checks:**
- Review API usage logs monthly
- Check for unusual patterns
- Verify no prohibited tools in use
- Ensure all AI-generated code is attributed
- Confirm security reviews completed

---

## 🚫 Violation Consequences (Detailed)

### First Violation
- **Documented warning** - Written record in personnel file
- **Mandatory security retraining** - Must complete within 30 days
- **Manager notification** - Direct manager informed
- **Policy acknowledgment** - Must re-acknowledge policy
- **Follow-up review** - Security team follow-up in 90 days

### Second Violation
- **Written warning** - Formal written warning
- **Escalation to senior management** - VP Engineering notified
- **Temporary tool access suspension** - May lose AI tool access for 30-90 days
- **Enhanced monitoring** - Increased security monitoring
- **Mandatory counseling** - Security team counseling session

### Third Violation
- **Potential termination** - Employment termination possible
- **Security incident investigation** - Full security investigation
- **Legal review** - Legal team review if malicious
- **Industry notification** - May be required to notify industry partners
- **Regulatory reporting** - May require regulatory reporting

### Malicious Violations
- **Immediate termination** - No warning, immediate termination
- **Legal action** - Potential civil or criminal charges
- **Law enforcement involvement** - FBI/cybercrime unit notification
- **Industry blacklist** - May be blacklisted from industry
- **Financial liability** - May be held financially liable for damages

**What constitutes malicious violation:**
- Intentional data exfiltration
- Sharing trade secrets with competitors
- Deliberate policy circumvention
- Using prohibited tools after explicit warning
- Attempting to hide prohibited tool usage

---

## 🆘 Help and Support (Comprehensive)

### "I accidentally used a prohibited tool"

**Immediate steps:**
1. STOP using it immediately
2. Document what data was shared
3. Email security-incidents@organization.com
4. Follow incident response instructions
5. Rotate any potentially exposed credentials
6. Review logs to determine scope
7. Notify manager and security team

**What to include in incident report:**
- Tool name and URL
- Date and time of usage
- What data was shared (code, prompts, etc.)
- Whether credentials were exposed
- Steps taken to mitigate
- Credentials rotated (if applicable)

**Incident response timeline:**
- Immediate: Stop usage, rotate credentials
- Within 1 hour: Report to security team
- Within 4 hours: Initial assessment complete
- Within 24 hours: Full incident report
- Within 7 days: Remediation complete

---

### "I need a tool exception"

**Exception request process:**
1. Email security@organization.com
2. Provide business justification
3. Propose compensating controls
4. Wait for CISO approval
5. Document exception in `security-exceptions.md`

**Required information:**
- Tool name and vendor
- Business justification
- Intended use case
- Risk assessment
- Compensating controls
- Sunset date (max 90 days)
- Migration plan

**Compensating controls (required):**
- Air-gapped environment for tool usage
- No access to production credentials or data
- Manual security review of all generated code
- Dedicated security monitoring
- Daily security audit logs
- Isolated network segment

**Exception approval criteria:**
- Strong business justification
- No approved alternative available
- Compensating controls adequate
- Time-bounded (max 90 days)
- CISO + VP Engineering approval

---

### "I'm not sure if my tool is approved"

**Decision process:**
1. Check `approved-ai-tools.md`
2. If not listed, assume prohibited
3. Ask in #security-policy Slack channel
4. Request formal evaluation if needed

**Quick reference:**
- ✅ Listed in `approved-ai-tools.md` → Approved
- ❌ Not listed → Prohibited (request approval)
- ⚠️ Similar name but different vendor → Prohibited
- ⚠️ Free tier of approved tool → Prohibited (use enterprise tier)

**Common confusion:**
- "Claude" (approved) vs "Claude-like" services (prohibited)
- "GitHub Copilot" (approved) vs "Copilot alternatives" (prohibited)
- "OpenAI API" (approved) vs "OpenAI-like APIs" (prohibited)

---

### "I found a security issue with an approved tool"

**Reporting process:**
1. Email security-incidents@organization.com immediately
2. Stop using the tool
3. Document the issue
4. Wait for security team guidance
5. Follow remediation instructions

**What to include:**
- Tool name and version
- Description of security issue
- Steps to reproduce
- Potential impact
- Suggested remediation
- Evidence (screenshots, logs, etc.)

**Security issue examples:**
- Data leakage
- Unauthorized access
- Credential exposure
- Privacy violation
- Compliance issue

---

### "I need help with approved tool configuration"

**Support channels:**
- **Email:** engineering-support@organization.com
- **Slack:** #ai-tools-support
- **Documentation:** `approved-ai-tools.md`
- **Training:** Security team training sessions

**Common configuration issues:**
- API key setup
- Privacy mode configuration
- Access control setup
- Audit logging configuration
- Data retention settings

---

## 📚 Additional Resources

### Internal Documentation
- **Full Policy:** `rules/security-policy.md` Section 14.6
- **Approved Tools:** `rules/approved-ai-tools.md`
- **AI Workflow:** `rules/ai-workflow-policy.md`
- **Security Training:** `security-training/prohibited-ai-tools/`

### Tools and Scripts
- **Detection Script:** `rules/system/scripts/ai-prohibited-tools-check.sh`
- **Pre-Commit Hook:** `.pre-commit-config.yaml`
- **CI/CD Integration:** `.github/workflows/security-scan.yml`
- **Sanitization Script:** `scripts/sanitize-for-ai.sh`

### Support Channels
- **Email:** security@organization.com
- **Slack:** #security-policy, #ai-tools-support
- **Incidents:** security-incidents@organization.com
- **Policy Questions:** policy-questions@organization.com

### External Resources
- **OWASP Top 10 for LLMs:** OWASP documentation
- **AI Security Best Practices:** Industry standards
- **Compliance Guides:** GDPR, HIPAA, PCI DSS

---

## 🔍 Self-Check Before Using AI Tool

```
┌─────────────────────────────────────────────────────────┐
│  AI Tool Usage Self-Check                               │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ☐ Tool is listed in approved-ai-tools.md                │
│  ☐ Using enterprise/team tier (not free)                  │
│  ☐ No secrets in my prompt                              │
│  ☐ Sensitive data sanitized                             │
│  ☐ Will review ALL generated code                        │
│  ☐ Know how to report violations                        │
│  ☐ Tool configured with privacy settings                │
│  ☐ Audit logging enabled                                │
│  ☐ Access controls configured                           │
│                                                          │
│  If ALL boxes checked → ✅ Safe to proceed               │
│  If ANY box unchecked → ❌ STOP, get help                │
└─────────────────────────────────────────────────────────┘
```

---

## 💡 Pro Tips

### Tip 1: Use Approved Alternatives First
Don't default to web-based AI. Try these first:
1. **Claude Code** (best for security review, refactoring)
2. **Cursor IDE** (best for inline completion, multi-file edits)
3. **GitHub Copilot** (best for GitHub-integrated workflows)
4. **Claude API** (best for programmatic access)

### Tip 2: Sanitize Early, Sanitize Often
Create a sanitization script for common patterns:
```bash
#!/bin/bash
# sanitize-for-ai.sh
sed -i 's/sk-[a-zA-Z0-9]\{32,\}/<API_KEY_REDACTED>/g' "$1"
sed -i 's/AKIA[A-Z0-9]\{16\}/<AWS_KEY_REDACTED>/g' "$1"
sed -i 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[A-Z|a-z]{2,}/<EMAIL_REDACTED>/g' "$1"
sed -i 's/192\.168\.\d+\.\d+/<INTERNAL_IP_REDACTED>/g' "$1"
sed -i 's/password[=:]\s*\S+/password=<REDACTED>/gi' "$1"
```

### Tip 3: Bookmark This Guide
Add to your browser bookmarks or pin in Slack for quick reference.

### Tip 4: When in Doubt, Ask
Better to ask and wait than to violate policy and risk security incident.

### Tip 5: Regular Security Reviews
Schedule monthly reviews of your AI tool usage:
- Review API usage logs
- Check for policy compliance
- Update tool configurations
- Review generated code quality

### Tip 6: Stay Updated
- Subscribe to security team updates
- Attend security training sessions
- Review policy changes quarterly
- Stay informed about new threats

---

## 🎓 Training and Education

### Required Training
- **Initial:** Security training during onboarding
- **Annual:** Mandatory annual security training
- **After Violation:** Mandatory retraining within 30 days

### Training Topics
- AI tool security risks
- Approved vs prohibited tools
- Data sanitization techniques
- Code review best practices
- Incident reporting procedures

### Training Resources
- Security team presentations
- Policy documentation
- Video tutorials
- Interactive workshops
- Q&A sessions

---

## 📊 Metrics and Monitoring

### What We Monitor
- Tool usage patterns
- Policy violations
- Security incidents
- Code quality metrics
- Developer compliance

### How We Use Metrics
- Identify training needs
- Improve policy effectiveness
- Detect security threats
- Measure compliance
- Guide tool approvals

---

## 🔄 Policy Updates

### Update Frequency
- **Quarterly:** Policy review and updates
- **As Needed:** Incident-driven updates
- **Annual:** Comprehensive policy review

### How to Stay Informed
- Subscribe to security team updates
- Review policy changes in Git
- Attend security team meetings
- Check Slack #security-policy channel

---

**Remember:** The goal is security, not restriction. Approved tools are powerful and safe. Use them confidently! 🚀

---

**Questions?** Ask in #security-policy or email security@organization.com

**Last Updated:** 2026-02-07
**Next Review:** 2026-05-07
