# Approved AI Tools Registry

**Status:** Authoritative
**Last updated:** 2026-04-04
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

- [ ] **Billing / access tier (Anthropic Claude ecosystem)**

**Anthropic billing policy — programmatic usage (updated May 2026, effective June 15 2026):**

Anthropic has restructured how subscriptions handle programmatic usage. Starting June 15 2026, a dedicated monthly Agent SDK credit is issued separately from interactive subscription limits:

- Pro: $20/month
- Max 5x: $100/month
- Max 20x: $200/month

This credit covers: Claude Agent SDK, claude -p, Claude Code GitHub Actions, third-party apps built on the Agent SDK. Interactive usage (Claude.ai chat, Claude Code terminal, Claude Code interactive sessions) draws from the unchanged subscription limits and is unaffected.

Credit is non-rollover. When exhausted, programmatic usage pauses until reset unless pay-as-you-go extra usage billing is enabled. Activation required: claim credit via email notification on June 8 2026.

**Spend cap policy (unchanged):** $20/month combined hard cap across all cloud AI spend remains in force. On Pro, the Agent SDK credit IS the $20 cap — do not enable pay-as-you-go extra usage billing, which would allow charges beyond the cap at standard API rates. Exit code 2 on cap hit (see budget_guard.py spec).

**OpenClaw — prohibition unchanged:** OpenClaw is now technically permitted via Agent SDK credits per Anthropic's May 2026 reversal. The prohibition in this repo is NOT a billing restriction — it is a security prohibition: credential harvesting via `openclaw models auth login --provider anthropic --method cli --set-default` and prompt injection via social engineering bypass (see security-policy.md and April 2026 OpenClaw social engineering incident). OpenClaw remains prohibited regardless of billing status.

**Mandatory three-step reliability evaluation (May 2026):**

No agent tool may be approved without completing all three:

1. Check Princeton HAI reliability dashboard (https://hal.cs.princeton.edu/reliability). If not listed, require independent task-class evaluation.
   Cross-reference with METR's autonomous task time-horizon evaluations (metr.org) for independent assessment of agent capability length and reliability. METR's May 2026 productivity survey of 349 technical workers found a median 1.4–2x self-reported productivity gain from AI tools — with explicit caveats on the reliability of self-reported magnitude. Vendor productivity claims must be verified against independent evaluation before approval.
2. Verify benchmark scores are from independent evaluation not self-reported marketing. UC Berkeley (April 2026) demonstrated all major benchmarks can be gamed — published leaderboard scores are disqualifying if self-reported.
3. Confirm task-class score exceeds human baseline (OSWorld 72.36% or equivalent for intended use case). Agents below human baseline are not approved for autonomous operation.
4. **Comprehension audit before production deployment.**
   Before any AI-generated codebase reaches production, the owning engineer must be able to answer the following three questions without referring to the AI tool or its output:
   - What does this module do and why is it structured this way?
   - What breaks if this dependency changes?
   - Where are the boundaries I do not fully understand?

   If any answer is "I don't know," that is not a blocker on using AI assistance. It is a blocker on shipping. Treat unaudited AI-generated code as an unreviewed external dependency until the comprehension pass is complete.

   Basis: fluency illusion (Alter & Oppenheimer, 2009) — readable output is systematically mistaken for understood output. AI-generated code is maximally fluent. That feeling is not evidence of comprehension. Anthropic's own study (InfoQ, Feb 2026) found developers who delegated code generation to AI scored below 40% on comprehension tests versus 65%+ for those who used AI for conceptual inquiry only.

**Model selection criteria (mandatory):**

1. For tasks requiring >200K context tokens: verify the selected model supports the required context length before starting the session. For non-US-origin models in this tier (e.g. GLM family, Zhipu AI / Z.ai): these models are EXCLUDED from use via their API endpoints. See Chinese-hosted endpoint prohibition in ai-agent-security-and-supply-chain-notes.md. Self-hosting weights on US/EU trusted infrastructure is the only acceptable path.
   Source: [glm-5.2-architecture-jun2026]

Architectural risk and CVE risk are evaluated separately. A tool with patched CVEs may still be architecturally prohibited. See security-policy.md §Prohibited Agent Platforms and Frameworks.

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

**Model deprecation (May 2026):** Claude Sonnet 3.7 is deprecated for new workloads. Anthropic's system card for Claude Opus 4 and Sonnet 4 (May 2025) documents lower over-refusal rates than Sonnet 3.7 on benign requests. Use `claude-sonnet-4-20250514` or above. Do not start new workloads on Sonnet 3.7.

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

#### Z.ai (GLM-5 API)
STATUS: PROHIBITED — Chinese-hosted infrastructure. Excluded per Chinese-endpoint policy (ai-agent-security-and-supply-chain-notes.md). Do not use API endpoint regardless of task sensitivity. Self-hosting weights on trusted infrastructure is the only acceptable path.
**Tier:** Enterprise/Paid Only (no free tier)
**Approval Date:** 2026-02-12
**Approved By:** CISO, VP Engineering
**Next Review:** 2026-05-12

**Use Cases:**
- Code generation (OpenAI SDK compatible)
- Natural language processing
- Data analysis
- Content generation

**Security Features:**
- ✅ Bring-your-own API key (BYO key)
- ✅ OpenAI SDK compatibility (drop-in replacement)
- ✅ Privacy mode available
- ✅ MIT-licensed model (GLM-5 on Hugging Face)
- ⚠️ Data retention/training policy: **MUST be explicitly documented by vendor before use**
- ⚠️ DPA and enterprise compliance: **MUST be verified before production use**

**Access Control:**
- API key authentication (BYO key)
- Base URL override for OpenAI SDK compatibility
- Rate limiting per API key
- Usage tracking via API key

**Restrictions:**
- MUST use enterprise/paid tier only (no free tier)
- MUST use sandbox-only repositories (no production code access)
- MUST sanitize all prompts before sending
- MUST enable privacy mode if available
- MUST perform manual review of all generated code
- MUST maintain audit logs of all API usage
- MUST verify vendor data retention and training policies before use
- MUST verify DPA availability and enterprise compliance before production use
- MUST NOT use for repositories containing secrets or production credentials

**Evaluation Mode (Free Tier - Policy-Compliant Pattern):**

For minimal, policy-compliant evaluation use only (no production, no real code):

**0. Label the mode correctly (non-negotiable):**
- You are using **GLM-5 in EVALUATION MODE**
- Capability sampling only
- No trust assumptions
- No durability expectations

**1. Where you may use it (hard boundary):**
- ✅ **Only** inside a **dedicated sandbox repo**
- ✅ Repo contains: toy code, synthetic examples, throwaway files
- ✖ Never: real projects, client code, personal data, configs, secrets, paths, usernames
- **Rule:** If you wouldn't paste it into a public gist, don't paste it here

**2. Safe interaction pattern in Cursor:**
- **Allowed prompts:** Generic, abstract, content-free
  - "Review this function and suggest edge cases."
  - "Generate unit tests for this toy algorithm."
  - "Explain tradeoffs in this design pattern."
  - "Refactor this dummy code for clarity."
- **Forbidden prompts:** Stack traces with paths, internal architecture, real filenames/repo names, personal/sensitive topics
- **Assume everything is logged**

**3. Code handling rule:**
- GLM-5 output is **never trusted**
- **Never pasted directly** into real code
- Must be manually reviewed line by line
- Treat as: "Untrusted external suggestion"

**4. Time-box the evaluation:**
- Set short evaluation window (1-3 days)
- Evaluation questions only:
  - Is reasoning quality interesting?
  - Is long-context handling noticeably better?
  - Is latency acceptable?
- If answer isn't clear **yes**, stop using it

**5. What "free" means:**
- No payment, no expectations, no guarantees
- Does **not** mean: low risk, private, ephemeral

**6. Exit conditions (immediately stop if):**
- You feel tempted to paste real code
- You want to rely on it repeatedly
- You forget it's evaluation-only
- Signal that tool needs either: paid tier + verified DPA, or removal from active use

**7. Operational rule:**
> **Use GLM-5 like a public whiteboard: useful for ideas, unsafe for content.**

**Cost Model:** Per-token pricing (enterprise/paid tier only)
**Documentation:**
- GLM-5 model card/license: https://huggingface.co/models/GLM-5 (MIT license)
**Support:** Enterprise support (verify availability)

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
- MUST install only from **Anthropic-documented** distribution (official npm/install path). MUST NOT install from unofficial GitHub forks, "leaked source" builds, or unverified mirrors (npm packaging / fake-repo lures — [`security-policy.md`](security-policy.md) §9.4, April 2026).
- **MCP server installation policy (updated 2026-04-22):**
MCP servers MUST only be installed from the official GitHub MCP Registry. Community marketplaces including mcp.so and any non-official registry are prohibited — 9 out of 11 tested community registries accepted malicious MCP servers in the April 2026 OX Security disclosure. No agent session may write to, modify, or self-configure its own MCP config files. See security-policy.md for full MCP STDIO vulnerability mitigations.

**Minimum safe version (repo-config RCE/key-exfil):**
- Claude Code MUST be kept at or above vendor-fixed versions for known repo-level config vulnerabilities (see security-policy.md Section 19 PI-7.1).
- Track Anthropic security advisories; update the minimum version floor below within 7 days of disclosure (per Section 14.6.8 cadence).
- **Current minimum version floor:** *Verify against Anthropic security advisories before encoding; do not rely on unverified disclosure version numbers (e.g. `>= 2.0.65`) until confirmed.*
- **Version floor review cadence:** On **any** Anthropic security advisory affecting Claude Code, revisit and update this subsection **within 7 days** (same obligation as `security-policy.md` §14.6.8 and Section 19 PI-7.1). **Do not** defer the floor check until the annual `approved-ai-tools.md` recertification date in the table below — that schedule is for the full registry, not for emergency version floors.

**Cost Model:** API usage costs (Anthropic Claude pricing)
**Documentation:** https://docs.anthropic.com/claude-code
**Support:** Anthropic support portal

**Related product (separate posture — Claude Code Web):** Browser/cloud async agent with GitHub integration is **not** classified the same as local CLI Claude Code for data-exfiltration and control boundaries. **MUST** follow [`claude-code-web-usage-policy.md`](claude-code-web-usage-policy.md) (forbidden for ML/CV core, secrets, credentials, datasets, infra configs; review-before-integrate).

**ccusage (APPROVED)**
Local CLI for tracking token usage and estimated
costs across Claude Code, Codex, Gemini CLI, and
14 other coding agent CLIs. Reads local log files
only — no data uploaded. MIT licensed.
Source: https://ccusage.com / https://github.com/ryoppippi/ccusage

Approved because:
- Local data only — no cloud upload
- Fills the spend metering gap pending budget_guard.py
- MIT licensed, open source, auditable
- Supports Claude Code, Codex VS Code extension,
  and Gemini CLI — all tools in active use or
  evaluation

Usage constraints:
- Install with explicit version pin:
  npm install -g ccusage@<version>
  Verify version against https://www.npmjs.com/package/ccusage
  before installing — npm supply chain attacks are
  active (TrapDoor, Mini Shai-Hulud, May 2026)
- OpenClaw appears in the supported sources list —
  this does not affect the OpenClaw prohibition,
  which covers use of OpenClaw, not tools that
  read its log format
- When budget_guard.py is implemented, ccusage
  output can serve as the metering input
- Built on Vite toolchain (now under Cloudflare/VoidZero stewardship since June 4 2026). Re-pin to a verified version after any upstream Rolldown or Oxc release. See dependency-install-policy.md supply chain centralisation section.

---

**token-savior (Mibayy): APPROVED. MIT. Symbol-nav MCP.**
Install: isolated venv, core profile only.

**claude-code-router (musistudio): APPROVED. MIT. Model routing.**

**caveman (JuliusBrussee): APPROVED. MIT. Output compression skill, ultra mode.**

**ooples/token-optimizer-mcp: APPROVED. MIT. Caching MCP for repeat reads.**

**thedotmack/claude-mem: APPROVED. MIT. Cross-session memory. Plugin install only.**

**Squeezr (sergioramosv): CONDITIONAL. MIT.**
Security: no credentials/PII in sessions while proxy active.
Infra: container only — conflicts with host-install prohibition.
Local backend mandatory for this setup (RTX 4070 + Ollama).
Exception: security-exceptions.md EXCEPTION-TOKEN-001.

---

#### Codex on Amazon Bedrock (NOT APPROVED — evaluation pending)
OpenAI coding agent available on Amazon Bedrock since April 28 2026 (limited preview). Accessible via Codex CLI, Codex desktop app, and VS Code extension. Authentication via AWS credentials; inference runs on Bedrock infrastructure.

**Not approved because:**
- Limited preview — not yet stable
- Requires AWS account and Bedrock access not currently in use
- Remote execution on cloud infrastructure — same restriction class as Claude Code Routines and Claude Code Review (see [`claude-code-web-usage-policy.md`](claude-code-web-usage-policy.md))
- No evaluation against current stack has been performed

**Re-evaluate when:** limited preview exits, AWS/Bedrock access is active, and a specific use case justifies evaluation against Claude Code.

**Reference:** https://openai.com/index/openai-on-aws/

---

#### Codex — OpenAI VS Code/Cursor Extension (APPROVED with restrictions)
OpenAI's coding agent VS Code extension (identifier: openai.chatgpt). Currently installed in Cursor (v26.422.71525, last updated 2026-04-29). 5M installs. Requires ChatGPT Plus/Pro/Business/Edu/Enterprise account authentication.

Two operating modes — different approval status:

APPROVED: Local pairing mode — chat, edit, and preview changes side-by-side in IDE with opened file and selected code context. Runs locally, no code sent to cloud execution. Equivalent risk to Cursor's native AI features.

RESTRICTED: Cloud delegation mode — "Delegate to Codex in the cloud" offloads jobs to OpenAI infrastructure. Same restriction class as Claude Code Routines and Claude Code Review: forbidden for ML/CV core workloads, credentials, datasets, and infra configs. Permitted only for non-sensitive tasks where output is reviewed before use.

Additional constraints:
- ChatGPT account credential: do not store API keys or tokens in Cursor environment variables accessible to MCP sessions (see MCP STDIO policy in security-policy.md)
- Assisted-by tag required in commits where Codex materially contributed (see ai-workflow-policy.md):
  Assisted-by: Codex:gpt-5.x [Cursor]
- Cloud delegation subject to same audit trail requirement as all agentic sessions

**CursorJacking exposure (unpatched, April 2026):** The Codex extension authenticates via ChatGPT account credentials. Do NOT store this credential in Cursor's built-in credential store — any other installed extension can read it via the unpatched CursorJacking vulnerability (CVSS 8.2). Store OpenAI API keys in shell environment variables only. Re-evaluate storage approach when Cursor ships a patch for the SQLite access control issue.

Reference: https://developers.openai.com/codex/ide

---

#### MAI-Code-1-Flash via GitHub Copilot (APPROVED with same restrictions as Codex VS Code extension)
Microsoft's 5B parameter coding model, rolling out to all GitHub Copilot tiers in VS Code from June 2 2026. Appears in the VS Code model picker automatically — no separate installation required.
Built on commercially licensed data without third-party distillation. Trained on GitHub Copilot production harness. Benchmark: outperforms Claude Haiku 4.5 by 16 points on SWE-Bench Pro at 60% fewer tokens on complex tasks.

Same restrictions as Codex VS Code extension:
- Local assistance mode: APPROVED
- Cloud delegation: RESTRICTED — forbidden for ML/CV core, credentials, datasets, infra configs
- Assisted-by tag required in commits where MAI-Code-1-Flash materially contributed:
  Assisted-by: MAI-Code-1-Flash:microsoft [Copilot]
- GitHub Copilot CVE-2025-53773 (CVSS 9.6) applies to the Copilot harness — not model-specific. See security-policy.md prohibited platforms.

MAI-Thinking-1 (35B MoE reasoning, 256K context): private preview only on Microsoft Foundry as of June 2 2026 — not yet actionable. Re-evaluate when generally available.

---

#### Gemini CLI (NOT APPROVED — evaluation pending)
Google's terminal-based AI coding agent. Direct competitor to Claude Code in the same category: agentic coding loop, MCP support, Skills system, Plan Mode, multi-agent subagent delegation. Current stable: v0.39.0 (April 23 2026).

Underlying models (as of Google I/O 2026, May 19 2026):
- Default: Gemini 3.5 Flash — surpasses Gemini 3.1 Pro on coding, agentic, and multimodal benchmarks at 4x output token speed
- Gemini 3.5 Pro: in testing, available June 2026
- Gemini 3.5 Flash powers Antigravity 2.0 CLI (same codebase as Gemini CLI — see Antigravity entry in prohibited frameworks)

**Notable features relevant to current stack:**
- `gemini gemma` command: native local Gemma model integration — relevant to approved Gemma 4 E4B local inference workflow (evaluate against Ollama path before adopting)
- Plan Mode with skill activation confirmation — same pattern as Claude Code Plan Mode in use
- Four-tier prompt-driven memory management — architecturally similar to SemaClaw context model
- MCP Resource Tools (v0.40.0 preview): list and read MCP resources

**Not approved because:**
- No evaluation against current stack performed
- MCP STDIO architectural vulnerability applies (see security-policy.md — Gemini CLI explicitly listed as vulnerable in OX Security April 2026 disclosure); same MCP marketplace restrictions apply as Claude Code
- Gemini API key required — additional credential surface not currently in use
- Claude Code already covers the approved CLI agent use case

**Re-evaluate when:** a specific capability gap in Claude Code justifies evaluation, or `gemini gemma` local integration offers measurable advantage over current Ollama path.

**Reference:** https://geminicli.com/docs/changelogs/latest/

Deprecation notice (action before June 25 2026):
gemini-3.1-flash-image-preview and gemini-3-pro-image-preview shut down June 25 2026. Any code in learning repos referencing these model strings will break after that date.
Audit: grep -r "gemini-3.1-flash-image-preview|gemini-3-pro-image-preview" ~/dev/repos/

NOT APPROVED status unchanged — model upgrade does not change the security evaluation. Minimum version floor remains ≥ 0.39.1 (CVE-2026 RCE). Re-evaluate when Gemini CLI security evaluation completes and specific use case justifies it.

**Minimum version floor (April 2026):** Any future evaluation of Gemini CLI MUST use version ≥ 0.39.1. Versions below 0.39.1 carry a CVSS 10.0 RCE vulnerability (no CVE assigned yet): headless mode automatically trusted workspace folders for config loading, allowing attacker-controlled .gemini/ directory content in a cloned repo to execute commands on the host before any sandbox initialized. Same attack class as MCP STDIO prompt injection via repo files (see security-policy.md). Patched in 0.39.1 via explicit workspace trust requirement.

---

#### Herdr (NOT APPROVED — evaluation pending)
Terminal-native agent runtime ([herdr.dev](https://herdr.dev/)). Runs inside the existing terminal emulator (Ghostty, Kitty, iTerm, Alacritty, etc.) — not a browser dashboard or terminal replacement. Provides tmux-style persistent PTY sessions, mouse-native panes, semantic agent state rollups (blocked / working / done / idle), detach/reattach, remote SSH attach (`herdr --remote`), and a CLI plus newline-delimited JSON socket API for workspace/tab/pane orchestration. Single Rust binary; install via vendor script, Homebrew, or Nix flake. Integrates with terminal agents already in this registry (Claude Code, Codex, Cursor, Pi, and others listed on the vendor site).

**Layer classification:** Agent system layer (harness / orchestration) — not a model. Complements approved CLI agents; does not replace them. See `ai-workflow-policy.md` Agent harness principles (May 2026) and Ralph Loop pattern for filesystem continuity across sessions.

**Tracked for evaluation because:**
- Potential fit for parallel Claude Code sessions, Ralph Loop progress files, and harness tool-scoping (minimum tool exposure per workspace)
- Keeps shell, SSH, fonts, and keybinds while adding agent-aware layout vs. raw tmux alone

**Not approved because:**
- No security or reliability evaluation against current stack (mandatory three-step gate in this file not completed)
- Socket API allows agents to create panes, run commands, read output, and wait on state — expands automated execution surface; must be assessed against `security-policy.md` §8 (tool use) and PI-7 repo-config rules before approval
- `curl | sh` install path requires same supply-chain discipline as any new binary (pin version, verify checksums, prefer Homebrew/Nix after review)
- No published enterprise SLA, DPA, or SOC attestation on vendor site as of 2026-05-24

**Re-evaluate when:** a concrete use case (e.g. multi-agent CV training/debug herd) justifies evaluation; install channel and API permissions are documented; and evaluation covers remote attach, persistence across untrusted repos, and interaction with approved agents only.

**Reference:** https://herdr.dev/ — Docs: https://herdr.dev/ (compare, quick start, API)

---

**Reve 2.0 (CANDIDATE — evaluation pending)**
Text-to-image generation using plan/render architecture: LLM generates structured intermediate code representation (composition, layout, element relationships, style, text positioning) before diffusion renderer is invoked.
Source: https://app.reve.com
Arena AI leaderboard: #2 text-to-image (June 2026).

Relevant to CV portfolio for:
- Synthetic training data generation with free ground truth labels (element positions and relationships are explicit in the intermediate representation — no manual annotation needed)
- Dataset augmentation for rare or long-tail AV perception scenarios

Not approved until:
- API access confirmed (UI-only tools cannot be integrated into CV pipelines)
- Pricing evaluated against $20/month hard cap
- No credentials, repo content, or production data in any Reve session (browser-based tool, same isolation policy as untrusted web summarization)

Reference: rules/references/ — reve-2-plan-render-architecture.md

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

#### Gemma 4 (Google DeepMind — Self-Hosted via Ollama)
**Tier:** Self-hosted
**Approval Date:** 2026-04-05
**Approved By:** Alfonso Cruz
**Next Review:** 2026-10-05

**Approved variants (hardware-gated):**
- `gemma4:e4b` — Local GPU inference. RTX 4070 (12GB VRAM). Primary target.
- `gemma4:26b-a4b` — Cloudflare Workers AI only (`@cf/google/gemma-4-26b-a4b-it`).
  Local CPU inference permitted for non-latency-critical tasks only (64GB RAM).

**Use Cases:**
- CV pipeline inference (object detection, segmentation, multimodal input)
- Local multimodal reasoning (image + text)
- Offline/air-gapped development and evaluation

**Hardware baseline (do not run outside this envelope without a recorded exception):**
- GPU: NVIDIA RTX 4070, 12GB VRAM, CUDA 12.9
- CPU: AMD Ryzen 9 7900X, 64GB RAM
- OS: Fedora Linux 41, Python 3.11

**Vision encoder notes (relevant for CV pipeline integration):**
- All Gemma 4 variants use GemmaVis ViT with variable aspect ratio support
- Soft token budget: 70 / 140 / 280 / 560 / 1120 tokens — select based on
  task latency vs. resolution trade-off (object detection: 560+; video: 140)
- Patch pooling: 3×3 blocks averaged to soft tokens; linear projection + RMSNorm
  before LM input

**Security Features:**
- ✅ Fully self-hosted for E4B (no data exfiltration)
- ✅ No external network access required for local variant
- ✅ Open weights (MIT-licensed via Hugging Face / Google)
- ⚠️ Cloudflare Workers AI path: subject to Cloudflare data retention policy —
  verify before sending sensitive data
- Cloudflare acquired VoidZero (Vite, Rolldown, Oxc, Vitest) June 4 2026 — Cloudflare now owns the JS build toolchain used by 130M weekly developers. Supply chain centralisation risk: monitor VoidZero tool releases with the same scrutiny as Cloudflare infrastructure updates.

**Restrictions:**
- MUST install weights only from official sources:
  `ollama pull gemma4:e4b` or Hugging Face `google/gemma-4-e4b-it`
- MUST NOT install from unofficial mirrors, forks, or re-uploads
  (same supply chain rule as Claude Code — see security-policy.md §9.4)
- MUST NOT process production credentials or secrets
- MUST be in isolated development environment
- MUST NOT be used for production workloads without a recorded
  exception in security-exceptions.md
- PyTorch MUST be installed before GPU inference:
  `pip install torch torchvision --index-url https://download.pytorch.org/whl/cu129`

**Cost Model:** Free (local); Cloudflare Workers AI pay-per-token for 26B A4B
**Documentation:**
- https://huggingface.co/google/gemma-4-e4b-it
- https://developers.cloudflare.com/workers-ai/models/gemma-4-26b-a4b-it/
**Support:** Community (Ollama, HuggingFace); Cloudflare support for Workers AI path

**Local integration note (April 2026):** Gemini CLI v0.40.0 introduces a `gemini gemma` command for streamlined local Gemma model setup. Evaluate against current Ollama path (`ollama pull gemma4:e4b`) before adopting — Gemini CLI itself is not yet approved (see Gemini CLI evaluation entry). Do not add a new credential surface (Gemini API key) solely to access a local model already available via Ollama.

**Gemma 4 12B — updated June 4 2026:**
Google AI Edge blog (June 3 2026) clarifies that 16GB refers to system RAM, not VRAM, for LiteRT-LM CPU inference path. Your machine has 64GB RAM — Gemma 4 12B may be runnable locally via CPU inference without RunPod.

Two local inference paths to evaluate:

Path A — LiteRT-LM (CPU, system RAM):
  pip install litert-lm
  litert-lm serve --model gemma-4-12b-it
  Exposes OpenAI-compatible local endpoint.
  Slower than GPU but no VRAM constraint.
  No RunPod spend required.
  Test: latency acceptable for CV pipeline use?

Path B — RunPod (GPU, RTX 4090 or A100):
  For throughput-sensitive workloads, batch
  inference, fine-tuning. Subject to $20/month
  spend cap.

Status: CANDIDATE — evaluate Path A first.
Before approving: benchmark inference latency
via LiteRT-LM on your hardware. If latency is
acceptable for intended use case, approve for
local use. If not, defer to RunPod path.

**True throughput evaluation (not just tok/s):**
Benchmark against actual CV pipeline task classes,
not synthetic prompts:

1. Short structured output (<500 tokens):
   acceptable if ≥ 5 tok/s
2. Long structured output (2,000-4,000 tokens):
   measure wall-clock time end-to-end
3. Agentic loop (10 tool calls, ReAct):
   measure total session time — if > 5 minutes
   per task, CPU path is not viable for
   interactive development
4. Context scaling: benchmark at 512, 2K, 8K
   token context — CPU inference degrades
   non-linearly with context length

If tasks 2 and 3 exceed acceptable thresholds,
CPU path is viable only for batch/offline use,
not interactive CV pipeline development.
Approve with explicit scope restriction or
defer to RunPod path.
Reference:
https://developers.googleblog.com/bringing-gemma-4-12b-to-your-laptop-unlocking-local-agentic-workflows-with-google-ai-edge/

---

### Category: Cloud GPU Infrastructure

**RunPod — Cloud GPU Rental (APPROVED with
restrictions)**
On-demand GPU cloud for ML/CV training and
fine-tuning runs that exceed local RTX 4070
12GB VRAM capacity.
Source: https://www.runpod.io

Two tiers:
- Community Cloud: GPUs from individual providers
  globally. RTX 4090 ~$0.34/hr, A100 80GB ~$0.89/hr.
  Prices fluctuate. Machines can go offline.
  Use for: training runs, experimentation, workloads
  that checkpoint and resume.
  Do NOT use for: production inference, sensitive
  data, anything that cannot tolerate interruption.
- Secure Cloud: RunPod's own data centres.
  Higher prices, enterprise reliability.
  Use for: workloads requiring stable uptime.
  Not required for CV portfolio training runs.

**Approved use cases:**
- YOLOv8/CV model training that exceeds 12GB VRAM
- Fine-tuning runs requiring A100+ memory
- Benchmark runs requiring sustained GPU hours

**Spend cap:**
$20/month combined hard cap across all cloud AI
spend (RunPod + Anthropic API). RunPod GPU hours
draw from the same cap. RTX 4090 at $0.34/hr =
~58 hours/month at cap. A100 at $0.89/hr = ~22
hours/month at cap. Run `npx ccusage@latest monthly`
before each RunPod session to check remaining budget.
Exit code 2 on cap hit (see budget_guard.py spec).

**Security constraints (mandatory):**
- No production data, credentials, API keys, or
  secrets in any RunPod session — treat all
  Community Cloud environments as potentially
  compromised at the hardware level
- GPUBreach (GDDR6 RowHammer, April 2026): RTX
  4090 and A100 on Community Cloud are multi-tenant
  — hardware-level isolation is not guaranteed.
  No secrets in environment variables, no credential
  files on attached storage, no SSH keys beyond
  session scope
- Rotate any credentials exposed in a RunPod
  session immediately after session ends
- Use network storage only for model weights and
  datasets — never for credentials or configs
  containing secrets
- Terminate pods immediately when training completes
  — do not leave pods running idle

**Workflow:**
1. Check monthly spend: `npx ccusage@latest monthly`
2. Spin up pod with minimal required GPU
3. Train / benchmark / evaluate
4. Download artefacts to ~/dev/models/<project>/
5. Terminate pod immediately
6. Verify termination in RunPod console

---

## Prohibited Tools (Reference)

For the complete list of prohibited tool categories and characteristics, see **security-policy.md Section 14.6.1**.

**Summary of Prohibited Categories:**
1. Unvetted AI aggregators and front-ends (e.g., "chawd.ai", "chad.ai")
2. Unvetted browser extensions and IDE plugins
3. Self-hosted AI services without security hardening
4. Free or community AI services without compliance certifications
5. Tools with unclear data retention or training policies

### IDE Extension and Plugin Supply Chain Policy

**Threat reference:** UNC6426 (March 2026) — a legitimate IDE plugin (Nx Console) was compromised via a trojanized npm postinstall script. The plugin auto-update triggered credential theft and full cloud environment breach within 72 hours. See `security-policy.md §9.4`.

**Requirements for all IDE extensions:**
- Only install extensions from official, verified marketplace publishers
- Review extension permissions before installation (filesystem, network, shell execution are high-risk)
- Pin extension versions in team-shared configurations where possible
- Review extension changelogs before accepting auto-updates
- Any extension that executes postinstall/lifecycle scripts, spawns subprocesses, or makes network calls outside its stated function is PROHIBITED until reviewed
- Add `Cursor IDE extensions: review installed extensions for supply chain risk` to the Recertification Checklist

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
   - **Layer classification (mandatory):** Classify the candidate as **model layer** (LLM/API — reasoning and generation) or **agent system layer** (execution and orchestration — tools, state, security boundary). A new model does not replace an agent harness; a new harness does not replace a model. Misclassification invalidates the comparison.
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
- [ ] **Claude Code:** Update minimum safe version floor from Anthropic security advisories (per Section 19 PI-7.1; within 7 days of disclosure per Section 14.6.8)

**Recertification Schedule:**

| Tool                      | Next Recertification | Owner          |
| ------------------------- | -------------------- | -------------- |
| Anthropic Claude API      | 2027-02-01           | Security Team  |
| OpenAI API                | 2027-02-01           | Security Team  |
| GitHub Copilot Enterprise | 2027-02-01           | Security Team  |
| Cursor IDE                | 2027-02-01           | Security Team  |
| Claude Code               | 2027-02-01           | Security Team  |
| Ollama (self-hosted)      | 2027-02-01           | Security Team  |
| Gemma 4 (self-hosted) | 2026-10-05 | Alfonso Cruz |

---

## Change Log

| Date       | Change                                     | Approver        |
| ---------- | ------------------------------------------ | --------------- |
| 2026-02-07 | Initial registry with 6 approved tools     | CISO, VP Eng    |
| 2026-02-12 | Added Z.ai (GLM-5 API) - Enterprise tier   | CISO, VP Eng    |

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
