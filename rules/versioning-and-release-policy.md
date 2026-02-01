# Versioning and Release Policy

**Status:** Authoritative
**Last updated:** 2026-02-01

This policy defines how versions are assigned, how releases are produced, and how artifacts are published.

**Note:** This policy was split from the consolidated `versioning-and-documenting-policy.md` for better organization. See also:
- [Documentation Policy](documentation-policy.md) for documentation standards and exception/decision logging
- [Git and Source Control Policy](git-and-source-control-policy.md) for Git workflow and repository management

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
