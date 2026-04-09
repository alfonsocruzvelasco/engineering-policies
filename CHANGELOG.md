# Changelog

All notable changes to this repository are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project follows Semantic Versioning guidance in `rules/versioning-and-release-policy.md`.

## [Unreleased]

### Added
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
