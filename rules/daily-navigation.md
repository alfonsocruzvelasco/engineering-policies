# Daily Navigation

> One-page map from daily workflow moment to exact policy location.
> Do not read policies. Find the rule. Apply it. Move on.

## Session Start
Model tier (price-capped + spend freeze): check rules/model-registry.md
and rules/approved-ai-tools.md SPEND FREEZE before any paid model.
last_updated date before any hard+ task. If >30 days old,
run the snapshot update procedure first.
start a focused execution session → rules/ai-workflow-policy.md → §Session Lifecycle
map concept to authority quickly → rules/system/concept-index.md → §AI Workflow & Prompting
validate local workspace boundaries → rules/development-environment-policy.md → §Repository Isolation Rules
confirm tool approval before use → rules/approved-ai-tools.md → §Approved Tools
apply injection response protocol first → rules/agent-stopping-conditions.md → §INJECTION RESPONSE PROTOCOL (tiered)

## Coding
implement production-grade structure → rules/production-policy.md → §1) Engineering principles (non-negotiable)
apply language-specific standards → rules/language-policies.md → §1) Core principles
enforce test discipline while coding → rules/testing-policy.md → §Test Data Setup
record decisions and evidence clearly → rules/documentation-policy.md → §1) Core principles
ship browser/API-safe interfaces → rules/web-policies.md → §1) Core principles

## Benchmarking
enforce token budget limits → rules/token-cost-controls.md → §Mandatory rules
track token and USD telemetry → rules/token-cost-observability.md → §Mandatory rules
choose model tier by economics → rules/model-cost-discipline.md → §Mandatory rules
benchmark model lifecycle performance → rules/mlops-policy.md → §5) Model Monitoring & Observability
evaluate retrieval quality and drift → rules/ai-retrieval-policy.md → §5) Evaluation and Monitoring

## Commit
prepare release-safe version metadata → rules/versioning-and-release-policy.md → §5) Release process (standard)
validate dependency install hygiene → rules/dependency-install-policy.md → §Mandatory rules
register temporary security deviations → rules/security-exceptions.md → §Exception Request Process
apply runtime stop and timeout guards → rules/agent-stopping-conditions.md → §Mandatory rules
run fast prohibited-tool policy checks → rules/ai-tool-policy-quick-reference.md → §Security

## Session End
close ML/CV execution loop cleanly → rules/ml-cv-operations-policy.md → §ML/CV Operations
log experiment outcomes consistently → rules/ml-experiment-tracking-policy.md → §Required for Every Experiment
verify canonical project structure state → rules/folder-organisation-policy.md → §1. Top-Level Layout — Universal Project Root
apply cloud-browser usage boundary checks → rules/claude-code-web-usage-policy.md → §7. Key rules
finalize environment boundary compliance → rules/development-environment-policy.md → §Enforcement
OBSERVE (mandatory) → rules/ai-workflow-policy.md → §OBSERVE Log: tokens + USD cost, latency + call count, incidents. Session is not complete until OBSERVE fields are captured.

## Pull on Demand (reference only — do not maintain proactively)
Quarterly spot-audit required: sample pull-on-demand entries and verify classification still holds.
rules/daily-navigation.md [REFERENCE]
rules/infrastructure-policy.md [REFERENCE]
rules/llm-usage-policy-hallucinations.md [REFERENCE]
rules/naming-policy.md [REFERENCE]
rules/references/35-insights-from-google-by-addy-osmani.pdf [REFERENCE]
rules/references/a-comprehensive-survey-on-vector-database.pdf [REFERENCE]
rules/references/a-fail-comparison-without-translationese.pdf [REFERENCE]
rules/references/a-qualitative-study-on-security-practices-and-concerns.pdf [REFERENCE]
rules/references/a-rational-analysis-of-the-effects-of-sycophantic-ai.pdf [REFERENCE]
rules/references/a-survey-of-large-language-models.pdf [REFERENCE]
rules/references/accelerating-scientific-research-with-gemini.pdf [REFERENCE]
rules/references/advisor-strategy-claude-api.md [REFERENCE]
rules/references/agent-architecture-intentcua-notes.md [REFERENCE]
rules/references/agent-hq-orchestration-complete-notes.md [REFERENCE]
rules/references/agent-orchestration.md [REFERENCE]
rules/references/agentic-code-review.pdf [REFERENCE]
rules/references/agents-of-chaos.pdf [REFERENCE]
rules/references/ai-agent-platform-infrastructure.md [REFERENCE]
rules/references/ai-agents-microservices-resilience-gap.pdf [REFERENCE]
rules/references/ai-flaws-bedrock-langsmith-sglang-visibility-rce-exfil-reference.md [REFERENCE]
rules/references/ai-mutation-testing-debugging-reference.md [REFERENCE]
rules/references/ai-policy-architecture-expanded.png [REFERENCE]
rules/references/ai-pr-communication-notes.md [REFERENCE]
rules/references/ai-systems-architecture.md [REFERENCE]
rules/references/ai-workflow-agent-skills-reference.md [REFERENCE]
rules/references/ai-workflow-prompt-patterns-reference.md [REFERENCE]
rules/references/api-hooks-usage-in-ai-agents.pdf [REFERENCE]
rules/references/architecting-agentic-mlops-a2a-mcp-notes.md [REFERENCE]
rules/references/architecting-agentic-mlops-a2a-mcp.pdf [REFERENCE]
rules/references/architecture-notes.md [REFERENCE]
rules/references/artificial-hivemind.pdf [REFERENCE]
rules/references/best-gpu-for-llms-2026.pdf [REFERENCE]
rules/references/bypassing-cc-prompts-limit.md [REFERENCE]
rules/references/cc-agent-teams-feature.md [REFERENCE]
rules/references/ceros-claude-code-visibility-control-reference.md [REFERENCE]
rules/references/claude-code-headless.md [REFERENCE]
rules/references/claude-million-token-pricing-reference.md [REFERENCE]
rules/references/claude-skills-definition-use-cases-and-limitations.md [REFERENCE]
rules/references/clawbench.pdf [REFERENCE]
rules/references/cloudflare-ai-sandboxing.pdf [REFERENCE]
rules/references/cloudflare-pay-per-crawl-notes.md [REFERENCE]
rules/references/code-mode-cloudflare.pdf [REFERENCE]
rules/references/codified-context-infrastructure-for-ai-agents-in-a-complex-codebase.pdf [REFERENCE]
rules/references/context-engineering-for-coding-agents.pdf [REFERENCE]
rules/references/context-rot.pdf [REFERENCE]
rules/references/discovering-multiagent-learning-algorithms-with-llm.pdf [REFERENCE]
rules/references/do-all-languages-cost-the-same.pdf [REFERENCE]
rules/references/do-multilingual-language-models-think-better-in-english.pdf [REFERENCE]
rules/references/do-multilingual-llms-think-in-english.pdf [REFERENCE]
rules/references/efficient-and-robust-approximate-nearest-neighbor-search.pdf [REFERENCE]
rules/references/evaluating-agents-md.pdf [REFERENCE]
rules/references/evidence-that-ai-can-already-do-some-weeks-long-coding-tasks.pdf [REFERENCE]
rules/references/fairest-agent-comparison.md [REFERENCE]
rules/references/from-vibe-coding-to-spec-driven-development.pdf [REFERENCE]
rules/references/gemini-integration-in-new-chrome.md [REFERENCE]
rules/references/gemma-4-visual-guide.pdf [REFERENCE]
rules/references/generative-ai-lens.pdf [REFERENCE]
rules/references/graph-of-skills.pdf [REFERENCE]
rules/references/hallucinations-is-inevitable.pdf [REFERENCE]
rules/references/harness-engineering.pdf [REFERENCE]
rules/references/haven-t-written-code-in-two-months.pdf [REFERENCE]
rules/references/how-ai-coding-agents-communicate.pdf [REFERENCE]
rules/references/how-to-make-a-better-product.pdf [REFERENCE]
rules/references/how-to-reduce-cc-token-usage.pdf [REFERENCE]
rules/references/index-architecture.md [REFERENCE]
rules/references/index-prompting.md [REFERENCE]
rules/references/index-security.md [REFERENCE]
rules/references/integration-guide.md [REFERENCE]
rules/references/integration-reliability-ai-systems.md [REFERENCE]
rules/references/intentcua.pdf [REFERENCE]
rules/references/knowledge-priming-notes.md [REFERENCE]
rules/references/langgraph-engineering-notes.md [REFERENCE]
rules/references/linux-kernel-ai-policy-2026.md [REFERENCE]
rules/references/llms-will-always-hallucinate.pdf [REFERENCE]
rules/references/local-model-runtime-status.md [REFERENCE]
rules/references/long-context-windows-opus-4.6+.md [REFERENCE]
rules/references/mcp-ecosystem-notes.md [REFERENCE]
rules/references/mcp-vs-acp.md [REFERENCE]
rules/references/mind-your-tone.pdf [REFERENCE]
rules/references/ml-cv-documentation-standards.md [REFERENCE]
rules/references/moe-notes.md [REFERENCE]
rules/references/molap-ml-engineer-reference.md [REFERENCE]
rules/references/molmoweb.pdf [REFERENCE]
rules/references/muse-spark-eval-methodology.pdf [REFERENCE]
rules/references/mutation-guided-llm-based-test-generation-at-meta.pdf [REFERENCE]
rules/references/mutation-testing-via-iterative-large-language-model-driven-scientific-debugging.pdf [REFERENCE]
rules/references/omni-simplemem-autoresearch-2026.pdf [REFERENCE]
rules/references/on-the-impact-of-agents-md-files.pdf [REFERENCE]
rules/references/open-claw-security-policy.md [REFERENCE]
rules/references/openspec-ml-cv-reference.md [REFERENCE]
rules/references/opus-4.6-gpt-5.3-codex-policy-impact-analysis.md [REFERENCE]
rules/references/owasp-top-10-for-llms-coverage-matrix.pdf [REFERENCE]
rules/references/prompt-engineering-theory.md [REFERENCE]
rules/references/prompt-osmani-self-improving-loop.md [REFERENCE]
rules/references/prompt-repetition-improves-non-reasoning-llms.pdf [REFERENCE]
rules/references/python-3-14+-no-gil-support.md [REFERENCE]
rules/references/rag-engineering-notes.md [REFERENCE]
rules/references/rag-production-notes.md [REFERENCE]
rules/references/rag-relevance-for-ides.md [REFERENCE]
rules/references/rag-vs-rerag-technical-reference.md [REFERENCE]
rules/references/refrag-regthinking-rag-based-decoding.pdf [REFERENCE]
rules/references/retrieval-augmented-generation-for-knowledge-intensive-nlp-tasks.pdf [REFERENCE]
rules/references/rodney-notes.md [REFERENCE]
rules/references/sandboxing-ai-agents-100x-faster.pdf [REFERENCE]
rules/references/saving-swe-bench-a-benchmark-mutation-approach-for-realistic-agent-evaluation.pdf [REFERENCE]
rules/references/secure-code-v-2-0.pdf [REFERENCE]
rules/references/security-enterprise-controls-reference.md [REFERENCE]
rules/references/security-vulnerabilities-in-ai-generated-code.pdf [REFERENCE]
rules/references/self-improving-loop-integration.md [REFERENCE]
rules/references/selkies-remote-gpu-workstation.md [REFERENCE]
rules/references/should-we-respect-llm.pdf [REFERENCE]
rules/references/simplify-command-report.pdf [REFERENCE]
rules/references/software-architecture-in-machine-to-machine-systems.md [REFERENCE]
rules/references/spdd-martinfowler-2026.md [REFERENCE]
rules/references/spec-protocols-guide.md [REFERENCE]
rules/references/sql-and-mcp-notes-ml-cv.md [REFERENCE]
rules/references/stochastic-scheduling-ai-coding-agents.pdf [REFERENCE]
rules/references/stop-using-agent-md.pdf [REFERENCE]
rules/references/strategic-learning-model-usage.md [REFERENCE]
rules/references/sub-agents-ml-cv-notes.md [REFERENCE]
rules/references/swe-ci-evaluating-agent-capabilities.pdf [REFERENCE]
rules/references/sycophantic-chatbots-cause-delusional-spiraling.pdf [REFERENCE]
rules/references/task-management-guide.md [REFERENCE]
rules/references/the-ai-coding-trap.pdf [REFERENCE]
rules/references/the-complete-guide-to-building-skill-for-claude.pdf [REFERENCE]
rules/references/the-dark-side-of-llms.pdf [REFERENCE]
rules/references/the-sdlc-is-dead-boris-tane.pdf [REFERENCE]
rules/references/think-deep-not-just-long.pdf [REFERENCE]
rules/references/vector-db-engineering-guide.md [REFERENCE]
rules/references/why-language-models-hallucinate.pdf [REFERENCE]
rules/references/your-job-is-to-deliver-code-you-have-proven-to-work.pdf [REFERENCE]
rules/system/containers/docker-and-kubernetes-best-practices.md [REFERENCE]
rules/system/containers/docker-compose-best-practices.md [REFERENCE]
rules/system/containers/how-to-use-makefile-to-launch-prune-pods.md [REFERENCE]
rules/system/learning-ai-usage-boundary.md [REFERENCE]
rules/system/learning-library-governance.md [REFERENCE]
rules/system/machine-fedora-43-fractal.md [REFERENCE]
rules/system/raid/raid-system-set-up.md [REFERENCE]
rules/system/scripts/ai-prohibited-tools-check.sh [REFERENCE]
rules/system/scripts/ai-security-check.sh [REFERENCE]
rules/system/scripts/generate-daily-navigation-references.py [REFERENCE]
rules/system/scripts/policy-consistency-check.sh [REFERENCE]
rules/system/scripts/setup-sops-age.sh [REFERENCE]
rules/system/workspace/.ARCHITECTURE.md [REFERENCE]
rules/system/workspace/README.md [REFERENCE]
rules/templates/.cursorrules [REFERENCE]
rules/templates/agents-md-template.md [REFERENCE]
rules/templates/claude-md-template.md [REFERENCE]
rules/templates/domain-template.md [REFERENCE]
rules/templates/folder-organisation-policy.md [REFERENCE]
rules/templates/mcp-template.md [REFERENCE]
rules/templates/ml-cv-skills-template.md [REFERENCE]
rules/templates/naming-policy.md [REFERENCE]
rules/templates/prd-template.md [REFERENCE]
rules/templates/prompt-template-chatgpt-en.md [REFERENCE]
rules/templates/prompt-template-claude-en.md [REFERENCE]
rules/templates/prompt-template-gemini-en.md [REFERENCE]
rules/templates/prompt-template.md [REFERENCE]
rules/templates/readme-template.md [REFERENCE]
rules/templates/researcher-subagent.yaml [REFERENCE]
rules/templates/terraform-devops-skills-template.md [REFERENCE]
