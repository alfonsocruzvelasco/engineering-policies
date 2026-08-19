# Changelog

All notable changes to this repository are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project follows Semantic Versioning guidance in `rules/versioning-and-release-policy.md`.

## [Unreleased]

### Added
- Added GPT-Red-style prompt-injection hardening framework: authoritative spec `rules/security/injection-eval-spec.md`, versioned corpus under `security-evals/attack-corpus/`, baseline thresholds in `security-evals/baselines/injection-baseline.json`, and automation runner `security-evals/run_injection_evals.py`; wired static validation into `.pre-commit-config.yaml` as `prompt-injection-evals-static` (2026-07-18).
- Resolved policy consistency blockers: unified exception logging references to `rules/security-exceptions.md`, clarified README AI-tool guidance (approved-tools + Cursor sandbox scope), and clarified `security-policy.md` sandbox directory table as Cursor-specific while preserving repo-local controls for other approved agents (2026-06-08).
- Added optional consistency follow-ups: removed orphaned infrastructure stub from `rules/web-policies.md`; expanded `rules/system/concept-index.md` governance/runtime coverage; added `rules/system/scripts/policy-consistency-check.sh` and wired it into `.pre-commit-config.yaml` to guard key policy drift conditions.
- Agent–microservices resilience controls in `rules/agent-stopping-conditions.md` (distinct agent traffic class, universal tool idempotency, session timeout/rate budgets, call-graph observability); cross-refs in `security-policy.md` §8 and `web-policies.md` §10 (Bhatkoti, DZone 2026).
- Tier A content UX checklist (non-normative, NN/g + Baymard) in `rules/web-policies.md`; concept-index and `index-security.md` links (2026-06-02).
- Tiered browser-facing quality gates in `rules/web-policies.md` (Tier A/B/C, Observatory + Lighthouse evidence, regression-first blockers); Appendix C A02 verification cross-link; concept-index and `index-security.md` links (2026-06-01).
- OWASP Top 10:2025 web application coverage matrix in `rules/security-policy.md` Appendix C (A01–A10 traceability, Covered/Partial/N/A legend, per-app assessment obligation); concept-index and `index-security.md` links (2026-05-30).
- Mandatory ChatGPT untrusted-content isolation controls in `rules/ai-workflow-policy.md` §8.1 (isolated browser profile, manual plain-text paste, Temporary Chat, connector restrictions); cross-reference in `rules/security-policy.md` §19; concept-index row (2026-05-30).
- Added root `.gitignore` with policy-aligned ignore rules for environment artifacts, build outputs, and local secrets.
- Added root `.editorconfig` for consistent newline, whitespace, and indentation behavior.
- Added root `AGENTS.md` with required project context, constraints, and verification commands.
- Added root `CONTRIBUTING.md` to standardize contribution workflow and verification discipline.
- Added `rules/references/local-model-runtime-status.md` documenting locally validated Ollama/llama.cpp models, paths, VRAM behavior, and practical usage recommendations (with security posture note).

### Changed
- Made `pre-commit` enforcement Jujutsu-compatible: hooks consume filenames supplied by pre-commit instead of the Git staging index; `jj commit` does not run Git hooks, so `pre-commit run --all-files` is the mandatory explicit gate (`development-environment-policy.md`, `production-policy.md`, `security-policy.md`, 2026-08-19).
- Corrected the Jujutsu publish workflow to match protected `main` and PR-only merges: short-lived bookmarks on `@-`, never `jj bookmark move main` for normal work (`development-environment-policy.md`, `production-policy.md`, `CONTRIBUTING.md`, 2026-08-19).
- Added a narrowly scoped Python learning-sandbox `.venv` exception at `~/learning-repos/python/<sandbox-name>/.venv/`; canonical project venvs remain `~/dev/venvs/<project-name>/` (`development-environment-policy.md`, `language-policies.md`, `learning-library-governance.md`, 2026-08-19).
- Updated `rules/security-policy.md` with mandatory automated injection evaluation gate (PI-5.2) and verification-gate enforcement under Section 20.
- Updated `rules/ai-workflow-policy.md` with ChatGPT model hardening control CT-15 (mandatory injection-evaluation loop and critical-failure stop rule).
- Updated `rules/system/concept-index.md` with authority mappings for prompt-injection evaluation harness controls.
- Expanded `README.md` policy relationship mermaid map (AI retrieval, hallucinations, token/cost/stopping, security satellites) with an explicit scope note; documented **AI cost, reliability, and observability** in the `/rules` catalogue; extended reading paths and **Using AI assistance** quick reference.
- Updated `rules/system/concept-index.md` with authority rows for token economy, observability tooling, agent stopping, model cost discipline; cross-linked stochastic scheduling to those policies; added index **Last updated** stamp.
- Normalized `**Last updated:**` header casing across `rules/` (replacing `Last Updated`); added file-level vs section-level date notes to `production-policy.md`, `documentation-policy.md`, and `ai-workflow-policy.md`; refreshed stale reference stamps in `rag-relevance-for-ides.md` and `vector-db-engineering-guide.md`.
- Consolidated former `docs/navigation-and-adoption.md` (and `docs/README.md`) into `README.md` under **Navigation, adoption, and maintenance**, removed `docs/`, and updated cross-links in `CONTRIBUTING.md` and `AGENTS.md`.
- Extended `CONTRIBUTING.md` with maintenance and fork/adoption notes.
- Linked local model runtime status from `README.md` and `rules/system/concept-index.md`.
