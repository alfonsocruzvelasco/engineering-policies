---
doc_type: policy
authority: authoritative
owner: Alfonso Cruz
scope: Mandatory discipline for installing npm and Python (pip/uv/Poetry) dependencies; normative detail in security-policy.md §9
---

# Dependency Install Policy

**Status:** Authoritative
**Last updated:** 2026-04-03

**Authority:** This file is the **short operational checklist**. **Normative expansion, OWASP alignment, and npm lifecycle-script rules** live in [`security-policy.md`](security-policy.md) §9 and §§9.3–9.4. **Language-specific package-manager rules** live in [`language-policies.md`](language-policies.md) (npm and Python sections). If anything here disagrees with `security-policy.md`, **`security-policy.md` wins**.

**Enforcement:** Policy is binding for humans and agents. **Technical enforcement** (CI failing on lockfile drift, `npm ci`, `pip-audit`, etc.) is **per repository** — this document does not replace CI configuration.

---

## Core rule

**Installing dependencies = executing code** (vendor install hooks, build backends, and malicious packages all run in your environment). There is no “safe passive download.”

---

## Mandatory rules

1. **Never install blindly** — Verify package name, registry, maintainer/repo, and that it is the intended artifact (typosquatting, **slopsquatting** on AI-suggested names). For **Claude Code–adjacent npm / fake-repo lures** (April 2026), see [`security-policy.md`](security-policy.md) §9.4 (named high-risk patterns and mandatory install channel).
2. **Never install freshly released versions by default** — Prefer versions that have been observable for a short period unless you are applying an **urgent security fix**. See [`security-policy.md`](security-policy.md) §9.3 (pip/PyPI); apply the same judgment for npm.
3. **Always pin versions** — Exact pins or semver ranges **as team standard**, with **no “floating latest”** in committed manifests. See [`security-policy.md`](security-policy.md) §9 and §9.3.
4. **Always use lockfiles** — Commit lock artifacts; CI installs from lock (`npm ci`, frozen Poetry/uv/pip-tools flows as applicable). See [`language-policies.md`](language-policies.md) (npm §§3–6, Python dependency sections).
5. **Isolate unknown or high-risk installs** — Use a **disposable virtual environment** or **container** for packages you do not yet trust; do not install untrusted or experimental dependencies into a **global** interpreter or production-like env. See [`security-policy.md`](security-policy.md) §9.3 (venv; never `sudo pip install`).
6. **Require install-time provenance verification in CI (npm)** — CI npm installs must run with signature verification enabled (`npm audit signatures`) or under a policy that requires SLSA provenance attestations. Any package published without provenance must be treated as untrusted regardless of source. Generating provenance on CI publishes is not sufficient; provenance must be required on install, too.
7. **Revoke contributor package/repo publish access on offboarding** — When a contributor leaves a project or organisation, revoke their npm scope access, GitHub repository access, and any token-based publish rights immediately. Dormant accounts with scope access are a supply chain attack surface. Audit contributor access on the same cadence as dependency security reviews.

**Also mandatory (npm):** Block lifecycle scripts by default (`ignore-scripts` / §9.4). **Also mandatory:** SCA on dependency changes where the repo uses that stack (`npm audit`, `pip-audit` / `safety`) per [`security-policy.md`](security-policy.md) §9.3 and team CI policy.

**Cloudflare/VoidZero acquisition — JS build toolchain centralisation risk (June 4 2026):**
Cloudflare acquired VoidZero (Vite, Rolldown, Oxc, Vitest) on June 4 2026. Vite has 130M weekly downloads. Rolldown and Oxc are now the default build toolchain for Vue, Nuxt, SvelteKit, Astro, React toolchains, and the majority of modern npm packages.

This is a supply chain centralisation event. One compromised Cloudflare/VoidZero employee account or one malicious release to any of these tools affects the build pipeline of the majority of JS/TS projects globally — same attack pattern as Miasma (@redhat-cloud-services, June 2026) but with 1,000x the blast radius.

Mitigations:
- Pin Vite, Vitest, Rolldown, Oxc versions explicitly in any JS project. Never use floating @latest for these packages.
- Monitor Cloudflare security advisories for VoidZero tools alongside npm security alerts: https://www.cloudflare.com/trust-hub/
- Treat any Vite/Rolldown/Oxc version bump in a dependency as requiring the same scrutiny as a direct dependency update
- For ccusage and other approved npm tools: re-pin to verified versions after any Rolldown or Oxc upstream release

**npm package supply chain — Lazarus/Contagious Interview pattern:**
- Verify any npm package mimicking known JS tooling before installing: check download count, publish date, author history, and repo link.
- Rollup polyfill namespace is an active attack surface (Jul 2026). Flag any package matching *polyfill*, *rollup-runtime*, or *rollup-core* patterns for manual review before install.
- Run npm audit and verify package provenance on any new dependency.
- Containers-only policy reduces host exposure but does not eliminate risk from packages installed inside containers with mounted volumes.
  Reference: [lazarus-npm-jul2026]

### Legitimate package compromise — credential theft vector

npm supply chain attacks now operate via two distinct vectors.
Your existing rules cover vector 1 (typosquatting/malicious packages).

Blockchain C2 — infrastructure takedown-resistant malware:
ViteVenom/ChainVeil (Jul 2026) uses Tron/Aptos/BSC blockchain
transactions as C2. Domain blocklists are useless — the C2
address is immutable on-chain. No patch, no takedown path.

Active namespace: @vite-* scoped packages.
Flag any package matching @vite-*/*, @vitets/*, @vite-tab/*,
@vite-mcp/*, @vite-pro/*, @vite-ln/* for manual review.
These are not legitimate Vite ecosystem namespaces.
Legitimate Vite packages use @vitejs/* only.
Source: [vitevenom-checkmarx-jul2026]

Vector 2 requires separate controls:

Vector 2 — Compromised legitimate package via stolen npm credential:
- A package you already trust can be poisoned mid-release.
- `--ignore-scripts` does NOT protect against payloads moved into
  package main code or CLI (confirmed: jscrambler 8.18.0/8.20.0,
  Jul 2026). [jscrambler-compromise-jul2026]
- Controls:
  (a) Pin exact versions in lockfiles. Never use ranges for
      build-time tools (devDependencies).
  (b) Verify package diff before upgrading any devDependency:
      https://socket.dev/npm/package/<name>/diff/<version>
  (c) Cross-reference npm version against GitHub tags. No matching
      tag = treat as suspect until confirmed by maintainer.
  (d) On any build machine: rotate cloud keys, npm/GitHub tokens,
      and AI tool API keys (Claude, Cursor, Windsurf) if a
      compromised version ran. Treat as stolen, not exposed.
  (e) Specific target of jscrambler-class infostealers on Linux:
      eBPF kernel module loaded from memory. If unknown BPF
      programs appear post-install (`bpftool prog list`), treat
      the machine as compromised.

Vector 3 — CI/CD pipeline compromise via push credential
(confirmed: AsyncAPI @asyncapi/generator family, Jul 15 2026):
- Attacker gains push access to a legitimate repo.
- Commits under a placeholder git identity.
- Project's own GitHub Actions OIDC trusted-publisher workflow
  publishes the package with valid SLSA provenance attestations.
- No npm token stolen. No malicious maintainer. Provenance is valid.
- SLSA attestation proves the authorized workflow produced the
  package — it does NOT prove the triggering commits were legitimate.

Controls:
  (a) Provenance attestation is not a trust signal for commit
      legitimacy. Verify commit author identity independently for
      any unexpected version bump.
  (b) Pin exact versions in lockfiles. Any unexpected minor/patch
      bump in a trusted package warrants a commit diff review before
      upgrading: https://socket.dev/npm/package/<name>/diff/<version>
  (c) Require branch protection on release branches: no direct push,
      require PR + review before any commit triggers a release workflow.
  (d) Monitor for placeholder git identities in commits upstream of
      packages you depend on.

NOTE: npm 12 allowScripts=off does NOT protect against load-time
droppers. The AsyncAPI attack fires when the module is require()d
during normal build/CI use — not at npm install time. allowScripts
is a necessary but insufficient defence. Runtime module loading
of untrusted versions remains a live attack surface.
[asyncapi-compromise-jul2026]

Miasma persistence indicators (Linux):
If any build or CI environment loaded one of the affected versions,
check for:
- systemd user units: `~/.config/systemd/user/` — unknown `.service` files
- crontab entries: `crontab -l` — unknown scheduled commands
- The malware has a dead man's switch: if a stolen token is revoked,
  it wipes the working directory. Do not revoke tokens before
  isolating the affected machine.
[asyncapi-compromise-jul2026]
Source: [jscrambler-compromise-jul2026]

### npm 12 — mandatory minimum

npm 12 (released Jul 8, 2026) ships with:
- allowScripts: off by default. Preinstall/install/postinstall
  hooks do not run unless explicitly approved.
- `--allow-git`: none by default. Git dependencies blocked.
- `--allow-remote`: none by default. Remote URL dependencies blocked.

Policy requirement:
- Minimum npm version: 12. Do not use npm <12 in any new container
  or CI pipeline.
- Run: `npm approve-scripts --allow-scripts-pending` before installing
  in any new project. Commit the resulting allowlist to `package.json`.
- Existing projects: upgrade npm to 12 and audit current
  allow-scripts list. Remove any entry that cannot be justified.
Source: [npm12-jul2026]

---

## Agents

1. **Separate planning from execution** — Decide *what* to install and *why* in a spec/PR/issue; treat the actual install as a distinct, reviewable step. Aligns with Spec–Plan–Patch–Verify in [`ai-workflow-policy.md`](ai-workflow-policy.md) Part 1.
2. **No automatic execution without validation** — Do not let an agent run `npm install` / `pip install` without **human review** of the dependency delta (names, versions, lockfile diff) unless the repo’s automation explicitly allows it. Destructive or publishing commands remain HITL per [`security-policy.md`](security-policy.md).
3. **Restrict tools by default** — Least-privilege tool allowlists, PreToolUse guardrails where used, and deny-read for secrets. See [`security-policy.md`](security-policy.md) §§8, 8.1.1, and Part 2 agent controls.

---

## One-line rule

**What code is being executed, and with what permissions?** — Ask this before every install, publish, or agent-driven package command.

---

## Quick links

| Topic | Where |
|------|--------|
| OWASP npm + PyPI alignment | [`security-policy.md`](security-policy.md) §9.3 |
| npm postinstall / IDE supply chain; Claude Code npm / fake-repo lures | [`security-policy.md`](security-policy.md) §9.4 |
| Tokens, 2FA, OIDC publishing | [`security-policy.md`](security-policy.md) §9.5 |
| npm CI, lockfile, `ignore-scripts` | [`language-policies.md`](language-policies.md) (TypeScript/Node sections) |
| Python venv, lock, SCA | [`language-policies.md`](language-policies.md) (Python §9 and related) |
| Agent context constraints | [`templates/agents-md-template.md`](templates/agents-md-template.md) |
