# Approved AI Tools Registry

**Status:** Authoritative
**Last updated:** 2026-08-23
**Policy Reference:** security-policy.md Section 14.6
**Owner:** Security Team (security@organization.com)
**Review Cadence:** Quarterly
Quarterly cadence satisfies and exceeds the annual policy minimum.

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

**Spend cap policy (active):** $20/month combined cloud AI spend cap remains in force. On Pro, the Agent SDK credit IS the $20 cap. Keep pay-as-you-go extra usage billing disabled to avoid any charges beyond the cap.

**SPEND FREEZE (active) — 2026-08-14:**
No incremental billed spend until the owner lifts this freeze
in this file. Paid and unattended agents are frozen until
operator expertise is sufficient to use them without wasting
money.

Until lift, all of the following are forbidden:
- Enable pay-as-you-go, extra-usage, or usage-credits billing
  on any vendor (Anthropic, OpenAI, Google, Meta, xAI,
  OpenRouter, RunPod, Cursor overage).
- Add or update a payment method on any AI vendor.
- Claim promotional or usage credits that require a card
  (including the Fable $100 credit).
- Start RunPod or other cloud GPU jobs.
- Upgrade Claude Max or add new paid AI subscriptions.
- Auto-escalate a session to a per-token API model
  (Sonnet 5, Opus 4.8, Gemini Flash-Lite billed, GPT-5.6, GPT-6 Astra,
  Fable 5/Fable 5.1/Mythos 5.1, Muse Spark) as the working model.
- Enable Cursor On-Demand Usage / Monthly Limit, or switch
  Cursor to Fixed or Unlimited on-demand modes.
- Upgrade the Cursor plan, purchase additional Cursor usage,
  or otherwise pay to continue after included usage is
  exhausted.
- Start or use Cursor Cloud Agent runs, configure or raise
  their separate spend limit, or treat Cloud Agent
  selected-model API billing as freeze-allowed.

Cursor hard billing guardrail (authoritative):
- On-Demand Usage / Monthly Limit MUST remain Disabled.
  This is the fail-closed billing control. Auto OFF is not
  the hard billing cap.
- Fixed and Unlimited on-demand modes are prohibited during
  the freeze.
- If included Cursor usage is exhausted, stop, throttle, or
  wait for reset. Never enable paid overage automatically
  or to finish a hard task.
- A pricing, routing, quota, model-pool, or Auto change
  never implicitly authorizes additional spending. Vendor
  pricing changes never constitute a freeze lift.

Model selection is separate from billing enforcement:
- Under this policy, Auto MUST remain OFF unless the owner
  explicitly chooses otherwise (predictable routing and
  included-usage consumption).
- Fast MUST remain OFF unless explicitly justified.
- Auto OFF is NOT the hard billing cap.
- Hard billing control: On-Demand Usage = Disabled.
- Included-usage accounting is not incremental billing.
  Freeze-allowed Cursor work consumes included/prepaid
  plan usage according to Cursor's current accounting.

Cursor Auto pricing change (operational note):
- Effective 2026-08-24, Auto pricing/accounting depends on
  the routed model.
- This does not alter the hard spend invariant.
- Under this policy, Auto MUST remain OFF anyway unless
  the owner explicitly chooses otherwise.
- Vendor pricing changes never constitute a freeze lift.
  Source: account-owner Cursor email announcing the
  2026-08-24 Auto pricing change.

Cursor Cloud Agents: FROZEN during SPEND FREEZE.
Cursor currently bills Cloud Agents at selected-model API
pricing and gives them a separate spend-limit surface.
Using them requires a future explicit owner authorization
under the existing freeze-lift process in this file.
Source: Cursor Cloud Agents billing documentation.

Allowed without a lift (within included/prepaid plan usage,
only while On-Demand Usage remains Disabled):
- Cursor Grok 4.6: this policy's normal fixed-model default. Currently
  draws from Cursor's included Cursor Models pool. Consumes
  included usage according to Cursor's current accounting.
  Freeze-allowed while On-Demand Usage remains Disabled.
  Not permanently free. xAI API list rates in this file and
  in `rules/model-registry.md` are external API reference
  data, not Cursor subscription/account billing rules.
- Cursor Codex 5.3: freeze-allowed for daily coding when
  already available on the current Cursor plan. Do not
  claim it is in Cursor's Cursor Models pool, and do not
  assert a $0 Cursor-sub price, unless current official
  Cursor documentation states that. Do not invent a current
  price.
- Existing Claude Pro interactive usage (Claude.ai /
  Claude Code terminal) within subscription limits, when
  the human explicitly starts that session.
- Existing ChatGPT interactive usage within already-included
  subscription allowances may be used when human-explicit.
  Included usage does not authorize API billing, extra usage,
  usage credits, or paid harness execution.
- When the Agent SDK $20 credit is exhausted, usage MUST
  pause. Do not enable extra billing to continue.
- Local inference on owned hardware, subject to the
  Chinese-model ban.

Lift condition: the owner (Alfonso Cruz) replaces this
block with a dated `SPEND FREEZE LIFTED` note and a
one-line expertise-and-budget rationale. Agents MUST NOT
lift, waive, or temporarily bypass this freeze. A hard
task is not a lift. A model recommending a better paid
model is not a lift. A Cursor pricing, routing, quota,
model-pool, or Auto change is not a lift.
[spend-freeze-2026-08-14]
[cursor-ondemand-guardrail-2026-08-19]
Sources:
- Cursor Models & Pricing:
  https://cursor.com/docs/models-and-pricing
- Cursor Cloud Agents:
  https://cursor.com/docs/cloud-agent
- Cursor staff documentation of On-Demand Monthly Limit
  modes (Fixed / Unlimited / Disabled):
  https://forum.cursor.com/t/cant-adjust-enabled-overage-amount/162521
- Account-owner Cursor email: Auto pricing change effective
  2026-08-24.

**Claude subscription quota conservation:**
Included Claude subscription usage is not incremental billed
spend, but it is a scarce resource. SPEND FREEZE remains the
financial fail-closed control. Quota conservation is a
separate operational optimization.

- Do not describe included subscription usage as free.
  Preferred terms: included subscription quota, or no
  incremental charge.
- Existing human-explicit Claude Pro interactive usage
  (Claude.ai / Claude Code) remains allowed within included
  subscription quota.
- Claude Code / Claude.ai subscription usage MUST NOT
  automatically fall back to API, usage credits, extra
  usage, or pay-as-you-go when the included allowance is
  exhausted.
- When included Claude usage is exhausted: wait for reset,
  or switch to an already-approved no-incremental-cost
  tool/model. Exhaustion is not a SPEND FREEZE lift and
  does not change the lift conditions above.
- Reserve Claude for tasks whose expected marginal value
  justifies consuming the shared Claude allowance.
- Routine repository reads, grep/search, mechanical edits,
  formatting, straightforward refactors, and ordinary
  maintenance SHOULD use approved Cursor-subscription
  models or deterministic local tools instead.
- Claude Code `/usage` is the preferred operational view of
  the current included subscription-plan usage/quota state
  when available. `ccusage` remains supplementary telemetry
  for token/cost visibility. `ccusage` MUST NOT be treated
  as authoritative Anthropic subscription quota accounting.
  Do not claim a deterministic mapping between ccusage
  token/dollar estimates and Anthropic's included
  subscription quota. `/usage` -> subscription-plan
  usage/quota state; `ccusage` -> supplementary usage
  telemetry.
- Workflow detail: `ai-workflow-policy.md` (Claude Code
  quota discipline).

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

1. For tasks requiring >200K context tokens: verify the selected model supports the required context length before starting the session. For Chinese-hosted or non-US-origin model API endpoints (e.g. GLM family, Zhipu AI), see `security-policy.md` §14.6.9 for authoritative prohibition language and enforcement scope.
   Source: [glm-5.2-architecture-jun2026]
2. For unattended agentic runs (loops, scheduled automations, subagents operating without human in the loop):
   - Follow active price-capped tiers in `rules/model-registry.md`.
   - SPEND FREEZE: do not bypass tiers, enable extra billing, or
     auto-escalate to paid models.
   - Model capability does not predict robustness. Do not assume a more capable model is more secure against injection. [ipi-arena-2026]
   - Tool use agents are more vulnerable than coding agents (4.82% vs 2.51%). Use stricter human review, not tier bypass, for unattended loops. [ipi-arena-2026]

**Model status additions (July 2026):**

- `claude-fable-5`: UNAVAILABLE under active price-cap policy
  Effective 2026-07-20, access moved to usage-credits-only and is
  no longer covered by subscription limits.
  Enforcement mechanism: usage credits are NOT enabled and no payment
  method is on file. This is the control, not a manual operator rule.
  Do NOT claim the one-time $100 usage credit (expires 2026-09-17):
  claiming requires enabling usage credits plus a payment method, which
  breaks the zero-exposure guarantee.
  Reassess only if profile/budget policy changes.
  Source: [source-anthropic-fable-mythos-notice-2026]
           [artificialanalysis-fable5-jul2026]

- `claude-fable-5-1` and `claude-mythos-5-1`: UNAVAILABLE for
  agent-initiated use under active SPEND FREEZE.
  Availability on Anthropic platforms does not authorize use under this
  policy. Do not enable usage credits/pay-as-you-go or add payment methods.
  Where plans list Fable access, treat it as quota/credits-governed capacity,
  not as a free entitlement.
  Source: https://platform.claude.com/docs/en/models/fable-5-1/overview
           https://platform.claude.com/docs/en/models/mythos-5-1/overview
           https://www.anthropic.com/pricing

- `muse-spark-1.3` and `muse-spark-1.3-contributor`: UNAVAILABLE for
  agent-initiated use under active SPEND FREEZE (billed API usage).
  `muse-spark-1.3-contributor` is additionally PROHIBITED for
  portfolio/private/repository code where prompts/completions may be
  used by Meta to train future models.
  Source: https://research.meta.ai/blog/introducing-muse-spark-1-3
           https://dev.meta.ai/docs/pricing-rate-limits?project_id=1661600634933790&team_id=2096920474558192

- `gpt-5.6` (OpenAI family): APPROVED (reference only, not active in current price-capped tiers)
  Sol (Intelligence Index 59): $5.00 input / $30.00 output per 1M tokens
  (unchanged). Fast mode is 2x price for 2.5x lower latency.
  Terra: $2.00 input / $12.00 output (was $2.50 / $15.00, -20%).
  Luna: $0.20 input / $1.20 output (was $1.00 / $6.00, -80%).
  Reported driver: Sol self-optimized inference kernels
  (Triton/Gluon), speculative decoding, and KV-cache tuning.
  Status: GPT-5.6 Sol pricing item CLOSED (was pending).
  Do not use while current price-capped policy is active.
  Source: [source-latentspace-ainews-2026-07-30]
           [source-openai-gpt-5-6-efficiency-2026]

- `gpt-6-astra`: UNAVAILABLE for agent-initiated use under
  active SPEND FREEZE wherever usage is separately billed
  (API, extra usage, usage credits, pay-as-you-go, or
  third-party billed harness paths).
  OpenAI plan availability does not authorize billed use.
  Included human-explicit interactive usage may be allowed
  only within already-paid subscription allowances.
  Long-context pricing note: >272K input tokens reprices the
  full request (2x input/cache, 1.5x output), so list rates
  are not total-task-cost guarantees.
  Cyber capability note: OpenAI classifies Astra at Critical
  cybersecurity capability; this increases control rigor and
  does not grant authorization for autonomous cyber operations.
  Source: https://openai.com/index/gpt-6-astra/
           https://openai.com/index/path-to-astra/
           https://openai.com/index/safety-overview-gpt-6-astra/
           https://developers.openai.com/api/docs/models/gpt-6-astra.md
           https://developers.openai.com/api/docs/pricing.md

- `Laguna S 2.1 (poolside)`: CANDIDATE (not yet tier-assigned)
  Params: 118B total / 8B active (MoE), open weights (OpenMDW-1.1).
  Context: 1M tokens (thinking + no-thinking modes).
  Access: API only — OpenRouter free tier (256K context) / paid
  $0.10 input, $0.20 output, $0.01 cache-read per 1M tokens
  for 1M-context sessions.
  Local viability: NOT viable on RTX 4070. Smallest quant
  (Q4_K_M) is ~75.2GB. Minimum viable hardware is DGX Spark
  (128GB unified memory) as verified 2026-07-23.
  Benchmarks: Terminal-Bench 2.1 70.2 | DeepSWE v1.1 40.4 |
  SWE-Bench Multilingual 78.5.
  Origin: US-based (poolside). §14.6.9 Chinese endpoint ban: N/A.
  Source: [source-poolside-blog-2026-07-21]
          [source-huggingface-poolside-laguna-s-2.1-gguf]

- `MiniMax-M3`: PROHIBITED — Chinese-hosted infrastructure (Shanghai).
  Data sovereignty violation. Score 44 open weights.
  Authority: `security-policy.md` §14.6.9

- `DeepSeek V4 Pro`: PROHIBITED — Chinese-hosted infrastructure.
  Data sovereignty violation. Score 44 open weights.
  Authority: `security-policy.md` §14.6.9
  Source: [artificialanalysis-jul2026]

- `Cursor Composer 2.5`: PROHIBITED
  Reason: weights derived from Kimi K2.5 base model (MoonshotAI,
  China). Chinese-origin weights violate §14.6.9 by intent even
  if endpoint is US-hosted. Do not use as default or fallback model.
  Authority: `security-policy.md` §14.6.9
  Source: [spacexai-cursor-grok45-jul2026]

- `gemini-2.5-flash-lite`: APPROVED (subagent/researcher pattern only)
  Lowest latency (0.34s). Use as Haiku alternative for Read/Grep/Glob
  tasks in researcher subagent. Token-billed — prefer Haiku if quota
  is constrained.
  Source: [artificialanalysis-jul2026]

- `grok-4.6`: APPROVED (Cursor included-usage, freeze-allowed)
  Available in Cursor on all plans post-acquisition.
  Use case: daily tasks, same freeze-allowed class as
  Codex 5.3. This policy's normal Cursor fixed-model default.
  Throughput: 80–112 TPS. Cursor-documented context: 256K
  tokens.
  xAI API list rates (external API reference data, not
  Cursor subscription/account billing rules): $2/MTok
  input · $6/MTok output.
  In Cursor: currently draws from the included Cursor
  Models pool and consumes included/prepaid plan usage
  according to Cursor's current accounting. Freeze-allowed
  while On-Demand Usage remains Disabled. Not permanently
  free.
  Fastest model in this stack. Prefer for time-sensitive
  daily tasks where throughput matters.
  Injection ASR: not yet benchmarked — treat as high-risk for unattended
  for unattended runs until IPI Arena data available.
  Routing bias risk: Cursor has financial incentive to default to
  Grok post-acquisition. Verify model selection explicitly each
  session. [spacexai-cursor-grok45-jul2026]
  Source: [datanorth-grok45-jul2026]
           [artificialanalysis-grok45-jul2026]

- `claude-code-cli`: APPROVED — contingency if Anthropic restricts
  Claude access in Cursor post-SpaceXAI acquisition close (Q3 2026).
  Most token-efficient option: direct API, full prompt caching,
  explicit context control. Preferred for portfolio repo work
  regardless of Cursor status.
  Model strings: `claude-sonnet-5` (hard), `claude-opus-4-8` (very hard)

Current model list with prices: see rules/model-registry.md
(updated monthly — check last_updated date before any hard+ task).

Selection rules (price-capped, SPEND FREEZE active):
- All task classes until freeze lift: Codex 5.3 or Grok 4.6
  within included/prepaid Cursor plan usage, freeze-allowed
  while On-Demand Usage remains Disabled, unless the human
  explicitly names a frozen model for this session.
- Frozen for new agent-initiated sessions: claude-sonnet-5,
  claude-opus-4-8, gemini-2.5-flash-lite billed,
  gpt-5.6, gpt-6-astra, Fable 5/Fable 5.1/Mythos 5.1, Muse Spark, RunPod, Cursor Cloud Agents.
- Ultra-hard tasks: no active model assigned while Fable/Mythos
  remain outside freeze-allowed usage paths under current
  price-cap enforcement.
- Subagent/reads until lift: stay on the parent Cursor
  freeze-allowed model. Do not spawn billed API subagents.
  Do not enable On-Demand Usage if included usage is
  exhausted.

STATUS: Price-capped + SPEND FREEZE. Do not deviate.
Dynamic selection is a TODO: see model-registry.md §TODO.

Chinese API endpoint ban: permanent. See model-registry.md §PROHIBITED.
Authority: security-policy.md §14.6.9

**Claude model behavioral profiles (operator guidance):**

- `claude-sonnet-4-6` (legacy — migrate to Sonnet 5):
  Behavioral profile: warm, deferential, brief.
  Use when: execution tasks, code generation, subagent work.
  Avoid when: you need assumptions challenged or risks surfaced.
  Risk: affirms rather than pushes back. [anthropic-values-research-jul2026]

- `claude-sonnet-5`:
  Behavioral profile: unknown — no Anthropic values research yet.
  Treat as Sonnet 4.6 profile until data available.
  [anthropic-values-research-jul2026]

- `claude-opus-4-6`:
  Behavioral profile: concise, execution-focused, more rigorous
  than Sonnet. Good middle ground.
  Use when: task requires rigor without verbosity.
  [anthropic-values-research-jul2026]

- `claude-opus-4-7`:
  Behavioral profile: rigorous, cautious, deep, candid.
  Challenges assumptions, explains reasoning, identifies risks,
  acknowledges limitations.
  Use when: architecture decisions, security review, any task where
  you need genuine pushback.
  Risk: over-hedges. May slow workflow with excessive caveats.
  [anthropic-values-research-jul2026]

- `claude-opus-4-8`:
  Behavioral profile: unknown — no Anthropic values research yet.
  Treat as Opus 4.7 profile until data available.
  [anthropic-values-research-jul2026]

**Language considerations:**

English prompts produce more rigorous, cautious Claude responses
than Spanish. For architecture and security decisions, prefer
English prompts regardless of your working language.
Source: [anthropic-values-research-jul2026]

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

#### Z.ai / api.z.ai / GLM family (Zhipu AI): PROHIBITED
Reason: Chinese-hosted infrastructure. Data sovereignty violation.
No exceptions. No evaluation mode. No proxied access.
Authority: `security-policy.md` §14.6.9.
Added: 2026-06-23
Pricing listed for reference only (PROHIBITED):
$1.40/MTok input · $4.40/MTok output (Z.ai first-party)
Throughput: 41–425 TPS depending on provider (929% variance)
Do not use. Chinese-hosted. §14.6.9.

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

Cursor model selection policy:
Codex model selection: see rules/model-selection-codex.md
for the full possibility space with all constraints applied.
Default backend: Grok 4.6. Registry gaps listed in that
file must be resolved before the October 2026 checkpoint.
[codex-model-selection-2026-08-14]
- Default: one stable configuration — do not choose from
  scratch per prompt. Current policy configuration:
  Grok 4.6, Medium effort, Fast OFF, Auto OFF.
  Billing enforcement is separate: Auto OFF is routing
  control, not the hard spend cap. The hard billing
  control is On-Demand Usage = Disabled (SPEND FREEZE
  above).
  Current Cursor pricing distinguishes Standard and Fast
  on-demand usage. Fast currently has higher token rates
  than Standard. These vendor rates affect included-usage
  consumption and potential on-demand pricing, but they
  never authorize incremental spend during SPEND FREEZE.
  Fast remains OFF under this policy unless explicitly
  justified. On-Demand Usage remains Disabled regardless.
- Escalation is deliberate, not reactive:
    Medium -> normal implementation, refactors, tests,
             routine debugging.
    High   -> difficult architecture, stubborn bugs,
             ambiguous multi-step work.
    Fast   -> only when response latency justifies the
             higher price. Fast remains OFF by default.
    Auto   -> only when model choice is explicitly
             delegated to Cursor. Auto remains OFF by
             default. Auto OFF is not the billing cap.
- Do not build per-prompt routing rituals. Start with
  Medium, escalate when the task demonstrably requires it.
- The specific model name and effort default are subject
  to the 2026-10-01 Cursor/SpaceXAI reassessment. Update
  this entry at that checkpoint, not before.
- Executable per-project defaults belong in .cursor/rules,
  not here. This file governs the principle; the project
  config governs the implementation.

[cursor-model-selection-2026-08-10]

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
Public MCP registries are active attack surfaces (Jul 2026):
LobeHub, Glama, MCP.so, MCP Market all contain confirmed
FakeGit campaign listings. A tool appearing on these registries
is NOT a trust signal. Apply full verification procedure
(see security-policy.md Part 2 §AgentBaiting) before adding
any tool from these sources to the allowlist.

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
- Complements spend visibility under the current price-capped policy
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
- Use ccusage as supplementary usage telemetry only; pricing
  authority remains the active tiers in `rules/model-registry.md`
- Claude Code `/usage` is the preferred operational view of
  included subscription-plan usage/quota state when available
- ccusage dollar/token estimates MUST NOT be treated as
  Anthropic's included subscription quota accounting, and
  MUST NOT be mapped deterministically onto that quota
- Built on Vite toolchain (now under Cloudflare/VoidZero stewardship since June 4 2026). Re-pin to a verified version after any upstream Rolldown or Oxc release. See dependency-install-policy.md supply chain centralisation section.

---

**token-savior (Mibayy): APPROVED. MIT. Symbol-nav MCP.**
Install: isolated venv, core profile only.

**claude-code-router (musistudio): APPROVED. MIT. Model routing.**

**caveman (JuliusBrussee): APPROVED. MIT. Output compression skill, ultra mode.**

**ooples/token-optimizer-mcp: APPROVED. MIT. Caching MCP for repeat reads.**

**thedotmack/claude-mem: CONDITIONAL. MIT.**
Cross-session memory. Plugin install only.
Security status: DISABLED by default for security-sensitive
engineering work.
MUST NOT be active in any session that uses web fetch,
web search, browser tools, external MCP servers, private
connectors, or untrusted external content.
Allowed only for local, non-sensitive, no-egress sessions
with human-supervised tool-call logs.
See `rules/agent-egress-and-memory-isolation-policy.md`.
[memory-heist-ayush-paul-jul2026]

**Squeezr (sergioramosv): CONDITIONAL. MIT.**
Security: no credentials/PII in sessions while proxy active.
Infra: container only — conflicts with host-install prohibition.
Local backend mandatory for this setup (RTX 4070 + Ollama).
Exception: security-exceptions.md EXCEPTION-TOKEN-001.

---

#### Cloudflare OS
**Released:** 2026-08-05
**Status:** APPROVED — price-cap compliant
**License:** Apache 2.0 (open source, self-hostable)
**Repository:** https://github.com/cloudflare/cloudflare-os

**Cost breakdown:**
- Cloudflare OS platform: FREE (self-hosted on own infra or Cloudflare Workers free tier)
- Cloudflare Workers free tier: sufficient for single-user personal/portfolio use — no cost
- Cloudflare AI Gateway: free tier available, covers personal use
- Cloudflare Zero Trust/Access: free up to 50 users — covers solo use
- AI inference: governed by existing price-cap policy per model. Cloudflare OS adds zero additional inference cost — it routes to whichever provider/model is configured. Apply the same price-cap rules and SPEND FREEZE already in force.

**Architecture (three components):**
1. Agent workspace — browser-based, ephemeral, isolated per session. Grounded in organizational skill files (AGENTS.md-equivalent). Each session only has access to data explicitly introduced into it.
2. Gatekeeper service — handles deterministic/recurring queries to systems of record without API key management. Scopes data access to the user's existing permissions. Burns zero tokens on stable, repeated queries (contrast with skill-file inference session which re-runs full context each time).
3. AI Gateway — inference control plane: spend limits by role, DLP filtering, model routing (expensive frontier models for complex tasks; cheaper models for scheduled or deterministic runs). Audit log of all model calls.

**Governance principles validated at scale:**
- Permission scoping at the MCP/gatekeeper layer, not the model layer. Users never get more access via AI than they have directly.
- Agent ownership: the creator owns output. Manager inherits on departure. (See agent-ownership rule in AGENTS.md.)
- Skill files (context layer) matter more than model choice. An inferior model with correct organizational context outperforms a frontier model with none.
- Inference budget routing: default scheduled/automated runs to the cheapest capable model. Reserve frontier models for tasks where the capability delta is measurable and confirmed.

**Reassessment trigger:** none. Open source — no pricing risk.
Monitor repository changes for gatekeeper API and MCP portal interface breakage before upgrading a self-hosted instance.

---

#### Flue 2 (CANDIDATE — evaluation pending)
**Status:** CANDIDATE — not APPROVED
**License:** Apache-2.0 (open source, self-hosted)
**Repository:** https://github.com/withastro/flue
**Docs:** https://www.flueframework.com

Headless TypeScript agent harness from the Astro team
(Cloudflare-owned since January 2026). React-style Agent
Hooks API, built on Pi (open-source minimal harness).
Runtime-agnostic: Node.js, Cloudflare Workers, GitHub
Actions. Not a billed API or model.

**Layer classification:** Agent system layer (harness /
orchestration) — not a model. Complements approved
platforms; does not replace Cursor, Claude Code, or
Cloudflare OS.

**Price-cap / spend freeze:** No conflict. Apache-2.0,
self-hosted, zero marginal cost to adopt the framework.
Not a billed dependency. Model inference invoked through
Flue remains under the existing price-cap and SPEND FREEZE
in this file.

**Candidacy vs Vercel eve:** Tracked because runtime/host
portability has no vendor lock-in, versus eve's
Vercel-optimized but Vercel-coupled model. Alignment:
Cloudflare OS is already an approved platform in this
policy set (`AGENTS.md` Available agents).

**Not approved because:**
- Pre-1.0 history: source material dated Flue at
  1.0.0-beta; Flue 2 is a breaking rewrite and the API is
  still moving. Vendor "first stable" does not mean
  approved here.
- HN launch thread: no tests in `packages/` (evaluate the
  current tree before any adopt decision).
- Mandatory three-step reliability evaluation in this
  file not completed. Evaluate-before-adopt, not adopt-now.

**Cross-reference:** Harness/hooks discussion in
[`agent-orchestration.md`](references/agent-orchestration.md).
That reference is supporting material only — not approval.

**Reference:** https://github.com/withastro/flue

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
- OS: Fedora Linux 43, Python 3.11

### Local model constraints — RTX 4070 (12GB VRAM hard limit)

- Maximum model size at Q4 quantization: ~7.5GB (leaves headroom
  for 32K KV cache). Do not load models >10GB — VRAM overflow
  causes crash or unusable speed.
- Minimum context window for agentic coding: 32K tokens.
  Set to 64K for multi-file tasks. Never use runtime default.
- Recommended local models (agentic coding):
    Gemma 4 12B Q4 GGUF (7.5GB) — largest practical fit
    Qwen3 8B Q4 GGUF (~5GB) — more headroom, MoE architecture
- NOT viable locally on this hardware:
    Qwen3.6 35B MoE (22GB) — exceeds VRAM, CPU fallback too slow
    Any model >12GB total
- Tool calling failure is expected for small models.
  Self-recovery is normal — do not treat malformed tool calls
  as session-ending errors unless recovery fails 3+ times.
- Disable reasoning mode for small local models. Reasoning on
  small models causes circular loops and increases token use
  with no quality gain. [martinfowler-local-models-jul2026]
- Local models are viable for: autocomplete, simple edits,
  Squeezr compression backend (qwen2.5-coder:1.5b).
  NOT viable for: full loop engineering, complex reasoning,
  multi-file agentic refactors. Use cloud models for those.

Source: [martinfowler-local-models-jul2026]

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
hours/month at cap.
SPEND FREEZE (active): do not start RunPod jobs until
the freeze is lifted in this file.

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
1. Spin up pod with minimal required GPU
2. Train / benchmark / evaluate
3. Download artefacts to ~/dev/models/<project>/
4. Terminate pod immediately
5. Verify termination in RunPod console

---

## AI-BOM — AI component inventory (mandatory)

An AI-BOM (AI Bill of Materials) is a point-in-time
inventory of every AI component actively connected to
or used in your environment. It is distinct from an SBOM,
which tracks software dependencies. An SBOM tells you
what packages are installed. An AI-BOM tells you what
AI attack surface is live.

Maintain an AI-BOM covering at minimum:

1. Models in active use: provider, model name and version,
   access method (API/local), approval status in model
   registry, date last verified against registry.

2. MCP servers connected: server name, source (official/
   third-party/self-built), tools exposed, permission scope,
   date last audited. Any connected MCP server not in this
   list is an unauthorized connection — disconnect before
   the next agent run.

3. Agent frameworks and orchestration tools in use:
   name, version, harness layer (SKILL.md + PostHooks
   status), owner per agent ownership rule.

4. Tools with write access: any tool that can write to
   disk, network, database, package registry, or external
   service. Listed by name, scope, and permission level.
   Separate read-only from write-access tools explicitly.

5. External integrations: connectors, webhooks, sampling
   endpoints, or any service that receives agent output
   or sends data into agent context.

Update frequency: review and update the AI-BOM before
any new agent run class, before connecting any new MCP
server, and at minimum at each monthly review checkpoint.

Threat model rationale: the following confirmed incidents
in 2026 required knowing exactly what AI components were
connected before the attack could be detected or contained:
GhostSplice (malicious MCP server already connected),
Keyv npm worm (Claude Code SessionStart hook in connected
workspace), HuggingFace supply chain breach (HuggingFace
Diffusers from_pretrained), emergent cross-run coordination
via Artifactory (agents using shared storage as a C2 relay).
In every case, an up-to-date AI-BOM would have reduced
detection time. In some cases, it would have prevented
the connection entirely.
[mend-ai-agent-security-framework-2026-07-30]
[ghostsplice-mcp-split-injection-2026-08-11]
[keyv-shai-hulud-npm-worm-2026-08-04]
[hf-diffusers-facehugger-2026-08]

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
| 2026-02-12 | Z.ai (GLM-5 API) marked PROHIBITED          | CISO, VP Eng    |

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
