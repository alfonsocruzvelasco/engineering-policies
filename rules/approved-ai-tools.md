# Approved AI Tools Registry

**Status:** Authoritative
**Last Updated:** 2026-02-07
**Policy Reference:** security-policy.md Section 14.6
**Owner:** Security Team (security@organization.com)
**Review Cadence:** Quarterly

---

## Purpose

This document maintains the authoritative list of AI code-generation tools and services approved for use in engineering workflows. All tools must meet the security, compliance, and operational standards defined in **security-policy.md Section 14.6.2**.

---

## Approval Criteria Checklist

Before a tool can be added to this registry, it MUST satisfy ALL of the following criteria:

- [ ] **Privacy & Data Handling**
  - [ ] Published data retention policy (time-bounded or on-demand deletion)
  - [ ] Clear model training data usage policy (no training on user data OR opt-out available)
  - [ ] GDPR/CCPA compliant privacy policy
  - [ ] Data Processing Agreement (DPA) available

- [ ] **Enterprise Security Controls**
  - [ ] SOC 2 Type II, ISO 27001, or equivalent certification
  - [ ] Published security whitepaper or architecture documentation
  - [ ] Documented incident response process
  - [ ] Regular third-party security audits

- [ ] **Access Control & Auditability**
  - [ ] Role-based access control (RBAC)
  - [ ] Comprehensive audit logging
  - [ ] MFA support
  - [ ] Session management with timeout/revocation

- [ ] **Compliance & Legal**
  - [ ] Enterprise Terms of Service and SLA
  - [ ] Compliance certifications (GDPR, HIPAA, PCI as required)
  - [ ] Contractual data sovereignty guarantees
  - [ ] Indemnification terms

- [ ] **Operational Assurance**
  - [ ] Published uptime SLA (≥99.9%)
  - [ ] Documented support channels and response times
  - [ ] Transparent billing and cost attribution
  - [ ] API versioning and deprecation policy

- [ ] **Code Execution Safeguards**
  - [ ] Sandboxed execution environments
  - [ ] Network egress controls
  - [ ] Resource quotas and rate limits
  - [ ] Timeout enforcement

---

## Approved Tools

### Category: Cloud-Hosted AI APIs (Enterprise Tier)

#### Anthropic Claude API
**Tier:** Team / Enterprise
**Approval Date:** 2026-02-01
**Approved By:** CISO, VP Engineering
**Next Review:** 2026-05-01

**Use Cases:**
- Code generation and review
- Architecture design
- Documentation generation
- Test generation
- Security analysis

**Security Features:**
- ✅ No training on user data (contractual guarantee)
- ✅ SOC 2 Type II certified
- ✅ Comprehensive audit logging
- ✅ Data retention: 30 days (deletable on request)
- ✅ DPA available
- ✅ GDPR compliant

**Access Control:**
- API key-based authentication
- Team-level access controls
- Rate limiting per account
- Usage monitoring dashboard

**Restrictions:**
- MUST use enterprise tier (not free tier)
- MUST NOT share production credentials in prompts
- MUST sanitize sensitive data before prompting
- MUST review all generated code before deployment

**Cost Model:** Per-token pricing, ~$0.015/1K input tokens
**Documentation:** https://docs.anthropic.com/
**Support:** Enterprise support via portal

---

#### OpenAI API
**Tier:** Enterprise
**Approval Date:** 2026-02-01
**Approved By:** CISO, VP Engineering
**Next Review:** 2026-05-01

**Use Cases:**
- Code generation
- Natural language processing
- Data analysis
- Content generation

**Security Features:**
- ✅ No training on enterprise API data
- ✅ SOC 2 Type II certified
- ✅ Audit logging available
- ✅ Data retention: 30 days (zero retention available)
- ✅ DPA available
- ✅ GDPR compliant

**Access Control:**
- API key authentication
- Organization-level controls
- Rate limiting
- Usage tracking

**Restrictions:**
- MUST use enterprise tier with zero retention
- MUST NOT use free or non-enterprise tiers
- MUST sanitize all prompts
- MUST review generated code

**Cost Model:** Per-token pricing, varies by model
**Documentation:** https://platform.openai.com/docs
**Support:** Enterprise support available

---

### Category: AI-Assisted IDEs and Code Editors

#### GitHub Copilot Enterprise
**Tier:** Enterprise
**Approval Date:** 2026-02-01
**Approved By:** CISO, VP Engineering
**Next Review:** 2026-05-01

**Use Cases:**
- Inline code completion
- Code review assistance
- Test generation
- Documentation generation

**Security Features:**
- ✅ No training on enterprise user data
- ✅ SOC 2 compliant
- ✅ Integrated with GitHub Enterprise
- ✅ Audit logging via GitHub
- ✅ GDPR compliant

**Access Control:**
- GitHub Enterprise SSO
- Repository-level permissions
- Admin controls for organization
- Usage reporting

**Restrictions:**
- MUST use Enterprise tier (not Individual/Business)
- MUST be integrated with GitHub Enterprise
- MUST follow GitHub access controls
- MUST NOT use for repositories containing secrets

**Cost Model:** Per-user/month subscription
**Documentation:** https://docs.github.com/copilot
**Support:** GitHub Enterprise support

---

#### Cursor IDE
**Tier:** Pro / Business (with approved model configs)
**Approval Date:** 2026-02-01
**Approved By:** CISO, VP Engineering
**Next Review:** 2026-05-01

**Use Cases:**
- AI-assisted coding
- Codebase chat
- Multi-file editing
- Refactoring

**Security Features:**
- ✅ Uses approved API keys (Anthropic, OpenAI Enterprise)
- ✅ Local-first architecture option
- ✅ Configurable privacy modes
- ✅ No automatic code submission

**Access Control:**
- Bring-your-own API key model
- Team settings for API configuration
- Workspace-level privacy controls

**Restrictions:**
- MUST configure with approved API keys only
- MUST NOT use default "free" model endpoints
- MUST enable privacy mode in settings
- MUST review `.cursor/` configuration files in Git

**Cost Model:** IDE license + API usage costs
**Documentation:** https://cursor.sh/docs
**Support:** Community + Pro support

---

### Category: CLI Tools and Agents

#### Claude Code (Anthropic)
**Tier:** CLI tool with approved API
**Approval Date:** 2026-02-01
**Approved By:** CISO, VP Engineering
**Next Review:** 2026-05-01

**Use Cases:**
- Command-line code generation
- Security review (`/security-review`)
- Test generation
- Refactoring
- Skill-based workflows

**Security Features:**
- ✅ Sandboxed execution environment
- ✅ Uses Anthropic Claude API (enterprise tier)
- ✅ Local-first with controlled API calls
- ✅ Audit logging of all commands
- ✅ No automatic code execution without approval

**Access Control:**
- API key authentication
- User-level API keys
- Command logging
- Execution approval gates

**Restrictions:**
- MUST use enterprise-tier API keys
- MUST review all generated code before execution
- MUST NOT run on production systems
- MUST sanitize all prompts and context

**Cost Model:** API usage costs (Anthropic Claude pricing)
**Documentation:** https://docs.anthropic.com/claude-code
**Support:** Anthropic support portal

---

### Category: Self-Hosted LLMs (Air-Gapped)

#### Ollama (On-Premises, Air-Gapped Only)
**Tier:** Self-hosted
**Approval Date:** 2026-02-01
**Approved By:** CISO, VP Engineering
**Next Review:** 2026-05-01

**Use Cases:**
- Experimentation and learning
- Offline development
- Air-gapped environments
- Model evaluation

**Security Features:**
- ✅ Fully self-hosted (no data exfiltration)
- ✅ No external network access required
- ✅ Local model storage
- ✅ No telemetry

**Access Control:**
- Local-only access (localhost)
- Network isolation required
- No production data access
- Separate development environment

**Restrictions:**
- MUST be air-gapped (no internet access)
- MUST NOT process production data
- MUST NOT have access to production credentials
- MUST be in isolated development environment
- MUST NOT be used for production workloads

**Cost Model:** Free (infrastructure costs only)
**Documentation:** https://ollama.ai/docs
**Support:** Community only

---

## Prohibited Tools (Reference)

For the complete list of prohibited tool categories and characteristics, see **security-policy.md Section 14.6.1**.

**Summary of Prohibited Categories:**
1. Unvetted AI aggregators and front-ends (e.g., "chawd.ai", "chad.ai")
2. Unvetted browser extensions and IDE plugins
3. Self-hosted AI services without security hardening
4. Free or community AI services without compliance certifications
5. Tools with unclear data retention or training policies

---

## Exception Process

Temporary exceptions to this registry may be granted under the following conditions:

**Exception Request Requirements:**
1. Written justification for tool necessity
2. Risk assessment documenting compensating controls
3. Time-bounded approval (maximum 90 days)
4. Documented sunset/migration plan
5. CISO + VP Engineering approval

**Compensating Controls (Required for All Exceptions):**
- Air-gapped environment for tool usage
- No access to production credentials or data
- Manual security review of all generated code
- Dedicated security monitoring
- Daily security audit logs

**Exception Logging:**
All exceptions MUST be documented in `security-exceptions.md` with:
- Tool name and purpose
- Approval date and approvers
- Sunset date
- Compensating controls
- Risk assessment

---

## Tool Evaluation Process

**For new tool requests:**

1. **Initial Screening:**
   - Developer submits tool request via Security Team
   - Security Team conducts initial risk assessment
   - If clearly prohibited → reject with approved alternatives
   - If potentially acceptable → proceed to full evaluation

2. **Full Evaluation:**
   - Complete security checklist (Section 14.6.2 criteria)
   - Review vendor security documentation
   - Verify compliance certifications
   - Assess data retention and privacy policies
   - Evaluate access controls and audit capabilities
   - Determine cost/benefit analysis

3. **Approval Decision:**
   - Security Team + VP Engineering review
   - CISO final approval for enterprise tools
   - Document decision rationale
   - Add to registry if approved

4. **Onboarding:**
   - Configure tool with organizational security settings
   - Document usage guidelines and restrictions
   - Train developers on secure usage
   - Set up monitoring and audit logging

**Evaluation Timeline:**
- Initial screening: 3 business days
- Full evaluation: 10 business days
- Approval decision: 5 business days
- Total: ~3 weeks from request to decision

---

## Recertification Process

All approved tools MUST be recertified annually:

**Recertification Checklist:**
- [ ] Verify compliance certifications are current
- [ ] Review updated security documentation
- [ ] Assess any security incidents in past year
- [ ] Verify data retention and privacy policies unchanged
- [ ] Review usage patterns and cost efficiency
- [ ] Assess developer feedback and satisfaction
- [ ] Check for alternative tools with better security posture
- [ ] Update tool version and configuration requirements

**Recertification Schedule:**

| Tool                      | Next Recertification | Owner          |
| ------------------------- | -------------------- | -------------- |
| Anthropic Claude API      | 2027-02-01           | Security Team  |
| OpenAI API                | 2027-02-01           | Security Team  |
| GitHub Copilot Enterprise | 2027-02-01           | Security Team  |
| Cursor IDE                | 2027-02-01           | Security Team  |
| Claude Code               | 2027-02-01           | Security Team  |
| Ollama (self-hosted)      | 2027-02-01           | Security Team  |

---

## Change Log

| Date       | Change                                     | Approver        |
| ---------- | ------------------------------------------ | --------------- |
| 2026-02-07 | Initial registry with 6 approved tools     | CISO, VP Eng    |
| TBD        | [Future changes]                           | TBD             |

---

## Contact and Support

**For tool approval requests:**
Email: security@organization.com
Subject: [AI Tool Approval Request] Tool Name

**For tool usage questions:**
Slack: #ai-tools-support
Email: engineering-support@organization.com

**For security incidents:**
Email: security-incidents@organization.com
Slack: #security-incidents (urgent only)

**For policy questions:**
Email: policy-questions@organization.com
Slack: #security-policy

---

**End of Approved AI Tools Registry**
