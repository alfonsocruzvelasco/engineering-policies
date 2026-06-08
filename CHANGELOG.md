# Changelog

All notable changes to this repository are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project follows Semantic Versioning guidance in `rules/versioning-and-release-policy.md`.

## [Unreleased]

### Added
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
- Expanded `README.md` policy relationship mermaid map (AI retrieval, hallucinations, token/cost/stopping, security satellites) with an explicit scope note; documented **AI cost, reliability, and observability** in the `/rules` catalogue; extended reading paths and **Using AI assistance** quick reference.
- Updated `rules/system/concept-index.md` with authority rows for token economy, observability tooling, agent stopping, model cost discipline; cross-linked stochastic scheduling to those policies; added index **Last updated** stamp.
- Normalized `**Last updated:**` header casing across `rules/` (replacing `Last Updated`); added file-level vs section-level date notes to `production-policy.md`, `documentation-policy.md`, and `ai-workflow-policy.md`; refreshed stale reference stamps in `rag-relevance-for-ides.md` and `vector-db-engineering-guide.md`.
- Consolidated former `docs/navigation-and-adoption.md` (and `docs/README.md`) into `README.md` under **Navigation, adoption, and maintenance**, removed `docs/`, and updated cross-links in `CONTRIBUTING.md` and `AGENTS.md`.
- Extended `CONTRIBUTING.md` with maintenance and fork/adoption notes.
- Linked local model runtime status from `README.md` and `rules/system/concept-index.md`.
