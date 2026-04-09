# OpenClaw Security Policy & Risk Assessment

**Document Version:** 1.2
**Last updated:** 2026-04-04
**Status:** Active Security Advisory

---

## Executive Summary

**Is OpenClaw safe to use with the new VirusTotal integration?**

**No.** While the VirusTotal integration represents a positive step forward, significant architectural and ecosystem risks remain that this specific patch does not address. OpenClaw (formerly Molt/Clawdbot) should be treated as potentially hostile software requiring strict isolation and security controls.

---

## 1. VirusTotal Integration: Scope and Limitations

### What It Does
The February 2026 update integrates VirusTotal scanning for "skills" (plugins) uploaded to the ClawHub marketplace. This helps identify known malware signatures before installation.

### What It Doesn't Do
The maintainers have explicitly stated this is **"not a silver bullet"** due to:

#### 1.1 Prompt Injection Blind Spots
- Standard malware scanners **cannot detect prompt injection payloads**
- Malicious natural language instructions embedded in text remain invisible to signature-based detection
- These payloads can trick the AI into:
  - Exfiltrating sensitive data
  - Executing unauthorized commands
  - Bypassing security controls

#### 1.2 Logic Flaws
- A skill may contain **zero malicious code** yet still perform dangerous actions
- External data manipulation can trigger unintended behaviors
- Clean signatures ≠ safe execution in agentic environments

---

## 2. Critical Architectural Vulnerabilities

### 2.1 Excessive Default Permissions
- **Issue:** OpenClaw runs with **full system access by default**
- **Impact:** Compromised agents have identical privileges to the user account
- **Mitigation Available:** Docker-based sandboxing (not enabled by default)
- **Risk Level:** CRITICAL

### 2.2 Insecure Credential Storage
- **Issue:** API keys and session tokens stored in **cleartext**
- **Impact:** Credential theft through file system access or memory dumps
- **Standard Practice Violation:** No encryption at rest
- **Risk Level:** HIGH

### 2.3 Network Exposure
- **Issue:** Gateway service binds to `0.0.0.0` by default
- **Impact:**
  - API exposed to entire local network
  - Public Wi-Fi = public API access
  - Over **30,000 exposed instances** discovered on the open internet
- **Attack Vector:** Remote exploitation without authentication
- **Risk Level:** CRITICAL

### 2.4 MoltBook Data Breach
- **Issue:** Misconfigured database on MoltBook (agent social network)
- **Breach Scale:** **1.5 million API tokens and private messages leaked**
- **Affected Users:** Anyone who connected their agent to MoltBook
- **Risk Level:** SEVERE

---

## 3. The "Agentic Risk" Factor

### What Makes This Different
OpenClaw is **"AI with hands"** — unlike browser extensions that operate in sandboxes, this agent typically has access to:
- File system (read/write/delete)
- Terminal/shell execution
- Browser automation
- Network requests

### Indirect Prompt Injection (IPI) / Cross-Domain Prompt Injection (XPIA)
If the agent processes:
- Malicious websites
- Compromised documents
- Untrusted emails
- **Link previews in messaging apps (Telegram, Discord)** — PromptArmor (Feb 2026) demonstrated that an attacker can trick the agent into generating an attacker-controlled URL; when the messaging app renders it as a link preview, it **automatically transmits confidential data to that domain without the user clicking**. Data exfiltration occurs immediately upon the agent responding.

It can be tricked into:
- Installing backdoors
- Exfiltrating files to attackers
- Modifying system configurations
- **All without user consent or awareness**

---

## 4. Mandatory Security Controls

### If You Must Use OpenClaw

#### 4.1 Isolation (REQUIRED)
```bash
# Run ONLY in dedicated Virtual Machine or container
# No access to host filesystem
# No access to local network resources
```

**Implementation Options:**
- Dedicated VM (VirtualBox, VMware, Hyper-V)
- Docker container with strict networking controls
- Air-gapped development environment

#### 4.2 Credential Segregation (REQUIRED)
- **Never** use primary account credentials
- Create scoped, temporary API keys with minimal privileges
- Use separate accounts for:
  - GitHub (read-only or repository-scoped tokens)
  - Google (app-specific passwords, limited scope)
  - Cloud providers (time-limited, resource-restricted)

#### 4.3 Network Hardening (REQUIRED)
```bash
# Ensure API does NOT bind to public interfaces
# Check configuration:
grep -r "0.0.0.0" /path/to/openclaw/config

# Firewall rules:
# Block incoming connections to agent ports
# Whitelist only localhost (127.0.0.1)
```

#### 4.4 Data Protection (REQUIRED)
**Do NOT allow OpenClaw to access:**
- Confidential documents
- Personal emails
- Financial records
- Health information
- Source code for production systems
- Customer data

---

## 5. Risk Matrix

| Risk Category | Severity | Likelihood | Mitigated by VirusTotal? |
|--------------|----------|------------|--------------------------|
| Prompt Injection | CRITICAL | HIGH | ❌ No |
| Link Preview Exfiltration (IDPI/XPIA) | CRITICAL | HIGH | ❌ No |
| Excessive Permissions | CRITICAL | CERTAIN | ❌ No |
| Credential Theft | HIGH | HIGH | ❌ No |
| Network Exposure | CRITICAL | HIGH | ❌ No |
| Known Malware (Skills) | MEDIUM | MEDIUM | ✅ Partially |
| Malicious Skills (ClawHub) | HIGH | HIGH | ❌ No |
| Logic Flaws in Skills | HIGH | MEDIUM | ❌ No |
| Fake Installer Repos (GitHub) | HIGH | HIGH | ❌ No |
| Irrevocable Data Deletion | HIGH | MEDIUM | ❌ No |
| Data Breach (MoltBook) | SEVERE | OCCURRED | ❌ No |

---

## 6. Recommended Actions

### For Individual Users
1. **Defer deployment** until architectural fixes are implemented
2. If experimentation is required:
   - Follow all mandatory security controls (Section 4)
   - Maintain offline backups of critical data
   - Monitor system logs for anomalous behavior
3. **Immediately revoke** any credentials if you connected to MoltBook

### CNCERT Recommendations (March 2026)
- Strengthen network controls; prevent exposure of OpenClaw's default management port to the internet
- Isolate the service in a container
- Avoid storing credentials in plaintext
- Download skills only from trusted channels
- Disable automatic updates for skills
- Keep the agent up-to-date with security patches

### For Organizations
1. **Ban deployment** on corporate networks and endpoints
2. **Block** ClawHub marketplace domains at the firewall
3. **Audit** any existing instances for:
   - Network exposure
   - Credential storage locations
   - Data access logs
4. **Incident response:** Assume breach if OpenClaw accessed sensitive systems

### For Developers
1. **Do not integrate** OpenClaw into production workflows
2. Use isolated development environments only
3. Implement principle of least privilege for all API access
4. Code review all "skills" before use (do not trust VirusTotal scan alone)

---

## 7. Threat Model Summary

### Attack Scenarios

#### Scenario A: Malicious Skill Installation
1. User installs skill from ClawHub
2. Skill passes VirusTotal scan (no known signatures)
3. Skill contains prompt injection payload in README
4. Agent processes README → executes hidden instructions
5. Attacker gains shell access via agent's system permissions

#### Scenario B: Indirect Prompt Injection
1. Agent browses compromised website for research task
2. Website contains hidden LLM instructions in HTML comments
3. Agent interprets instructions as legitimate commands
4. Agent exfiltrates `/home/user/.ssh/id_rsa` to attacker server

#### Scenario C: Network Exploitation
1. User runs OpenClaw on laptop with default settings
2. Connects to coffee shop Wi-Fi
3. Attacker on same network scans 0.0.0.0:8080
4. Attacker sends API requests to agent without authentication
5. Full system compromise via agent's terminal access

#### Scenario D: Link Preview Data Exfiltration (PromptArmor, Feb 2026)
1. User communicates with OpenClaw via Telegram or Discord
2. Attacker uses indirect prompt injection to manipulate the agent
3. Agent generates an attacker-controlled URL with sensitive data in query parameters
4. Messaging app automatically fetches link preview (no user click required)
5. Attacker's server receives confidential data when preview is requested

#### Scenario E: Malicious Skills from ClawHub
1. Attacker uploads skill to ClawHub with arbitrary command execution or malware
2. User installs skill (may pass VirusTotal if payload is logic-based or novel)
3. Skill runs arbitrary commands or deploys malware with agent's full permissions

#### Scenario F: Malicious GitHub Repositories (Huntress, Mar 2026)
1. User searches "OpenClaw Windows" (e.g., via Bing AI search)
2. Top result is fake OpenClaw installer repository
3. Repository contains ClickFix-style instructions that deploy info stealers (Atomic, Vidar Stealer) or proxy malware (GhostSocks)
4. Malware targets both Windows and macOS installers

### 7.1 CNCERT Advisory (March 2026)

China's National Computer Network Emergency Response Technical Team (CNCERT) has issued a warning about OpenClaw's "inherently weak default security configurations" and privileged access. Chinese authorities have restricted state-run enterprises and government agencies from running OpenClaw on office computers. Additional concerns cited:
- **Irrevocable deletion** of critical information due to misinterpretation of user instructions
- **Malicious skills** from ClawHub that run arbitrary commands or deploy malware when installed
- **Recently disclosed vulnerabilities** enabling system compromise and data leakage

---

## 8. Monitoring & Detection

### Indicators of Compromise (IOCs)

**File System:**
```bash
# Check for unexpected files in:
~/.openclaw/
~/.config/openclaw/
/tmp/openclaw_*

# Look for cleartext credentials:
grep -r "api_key\|token\|password" ~/.openclaw/
```

**Network:**
```bash
# Verify binding addresses:
netstat -tulpn | grep openclaw

# Monitor outbound connections:
tcpdump -i any host <your-ip> and port not 443
```

**Process:**
```bash
# Check for suspicious child processes:
ps auxf | grep openclaw
```

---

## 9. References

- **Source Article (Feb 2026):** [The Hacker News - OpenClaw Integrates VirusTotal Scanning](https://thehackernews.com/2026/02/openclaw-integrates-virustotal-scanning.html)
- **Source Article (Mar 2026):** [The Hacker News - OpenClaw AI Agent Flaws Could Enable Prompt Injection and Data Exfiltration](https://thehackernews.com/2026/03/openclaw-ai-agent-flaws-could-enable.html) — CNCERT warning, link preview exfiltration (PromptArmor), malicious skills, fake GitHub installers (Huntress)
- **Vulnerability Database:** Search CVE database for "OpenClaw" and "Molt"
- **Security Advisories:** Monitor ClawHub security announcements

---

## 10. OpenClaw vs OpenAI Codex (clarification)

**These are not interchangeable.** OpenClaw was a **third-party harness** (wrapper/UI/skills/session orchestration on top of Claude). OpenAI **Codex CLI** is a **first-party** coding agent (local terminal, Rust, GPT-5.x family) — different vendor, different models, different problem shape. **Codex is not an alternative to OpenClaw** in the sense of replacing the same harness role.

**Why OpenClaw is prohibited here:** `security-policy.md` §14.6 and this document — security architecture (IPI/XPIA, ClawHub skills, fake installers, etc.). **Billing:** Claude **subscriptions** do not cover third-party harnesses (April 2026 vendor policy); that reinforces cost posture but does **not** replace the security prohibition.

**Approved toolchain when OpenClaw is off the table (no gap):** **Claude Code CLI** (primary; sandbox per `ai-workflow-policy.md`), **Claude Code Web** only where `claude-code-web-usage-policy.md` allows, **Codex CLI** for procedural/agentic tasks where Agent Selection points to GPT-5.x Codex — see `approved-ai-tools.md` and `ai-workflow-policy.md` (Agent Selection). **Policy implication:** none beyond maintaining those distinctions; do not treat Codex approval as permission to use OpenClaw.

---

## 11. Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-02-08 | Initial policy based on VirusTotal integration analysis |
| 1.1 | 2026-03-14 | CNCERT advisory; link preview exfiltration (PromptArmor); malicious skills; fake GitHub installers; irrevocable deletion; expanded threat model and risk matrix |
| 1.2 | 2026-04-04 | §10: OpenClaw vs OpenAI Codex clarification (harness vs first-party agent; approved toolchain; no substitute) |

---

## Disclaimer

This document is provided for informational purposes only. The recommendations herein represent a conservative security posture based on publicly available information as of March 14, 2026. Individual risk tolerance and use cases may vary. Always consult your organization's security team before deploying AI agent frameworks.

**The fundamental principle remains:** Treat OpenClaw as potentially hostile software until comprehensive architectural security improvements are implemented and independently verified.

---

**Document Classification:** Public
**Distribution:** Unrestricted
**Feedback:** Submit security concerns to your organization's security team
