# Versioning and Release Policy

**Status:** Authoritative
**Last updated:** 2026-03-14

This policy defines how versions are assigned, how releases are produced, and how artifacts are published.

**Note:** This policy was split from the consolidated `versioning-and-documenting-policy.md` for better organization. See also:
- [Documentation Policy](documentation-policy.md) for documentation standards and exception/decision logging
- [Production Policy](production-policy.md) Section 5 (Git and Source Control Policy) for Git workflow and repository management

## 1) Core principle

Releases must be reproducible from:
- a Git commit
- a version tag
- a build pipeline that produces signed/traceable artifacts

### Acronyms
- **SemVer** = Semantic Versioning
- **CI** = Continuous Integration
- **CD** = Continuous Delivery

## 2) Versioning scheme

Default: **SemVer** (`MAJOR.MINOR.PATCH`)

- MAJOR: incompatible changes
- MINOR: backward-compatible features
- PATCH: backward-compatible fixes

Pre-releases MAY use:
- `-alpha.N`, `-beta.N`, `-rc.N`

## 3) Tagging policy

- Every release MUST have an annotated tag: `vMAJOR.MINOR.PATCH`
- Tags MUST point to a commit on the protected release path (`main` or release branch).

## 4) Changelog policy

- Maintain `CHANGELOG.md` using "Keep a Changelog" structure:
  - Added / Changed / Deprecated / Removed / Fixed / Security
- Every release MUST update the changelog.

## 5) Release process (standard)

A release MUST:
1. Ensure CI is green on the target commit
2. Update `CHANGELOG.md`
3. Bump version (single source of truth: `pyproject.toml` or equivalent)
4. Tag the release
5. Build artifacts in CI
6. Publish artifacts (package registry and/or object storage)
7. Record release metadata (artifact hashes, environment) in release notes

## 6) Artifact policy

Artifacts MUST be:
- content-addressed or integrity-checked (hash recorded)
- traceable to source commit and dataset snapshots where relevant

Model artifacts:
- MUST NOT be "latest"; they MUST be versioned and immutable once referenced.
- Store in object storage with hashes; store metadata in SQL or a registry.

## 7) Compatibility policy

Breaking changes MUST:
- be called out explicitly in the changelog
- include migration notes
- be versioned with MAJOR bump

## 8) Hotfix policy

Hotfix releases:
- MUST follow the same CI and tagging rules
- SHOULD be minimal diffs

## 9) Agent Feedback Loop

`AGENTS.md` is a living performance optimization artifact, not static documentation. It requires the same versioning discipline as any load-bearing configuration.

**Trigger:** After **5+ agent executions** in a repository (cumulative, not per session):

1. **Review failure cases** — what did the agent get wrong, and why?
2. **Update AGENTS.md** — remove ambiguity, add missing constraints, clarify architecture
3. **Remove stale content** — outdated instructions cause silent failures (Vasilopoulos G6)
4. **Add missing architecture clarifications** — if the agent explored unnecessarily, the context was insufficient

**Versioning:** AGENTS.md changes follow the same commit and changelog discipline as code. Significant rewrites SHOULD be noted in the changelog under "Infrastructure" or "Developer Experience."

**Cross-reference:** Agent metrics in `~/dev/devruns/<project>/agent-metrics/` (see `mlops-policy.md` Section 5.8) are the primary input for this review. Efficiency is the feedback signal; AGENTS.md is the control surface.
