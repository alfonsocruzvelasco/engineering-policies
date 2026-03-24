# Language Policies

**Status:** Authoritative
**Last updated:** 2026-03-24
**Purpose:** Language-specific engineering standards for Python, TypeScript/Node.js, Java, C/C++, Rust, and CUDA

---

## Python

### 0) Scope and intent

This section governs **Python application and library repositories** using virtual environments (`venv`) and modern dependency tooling.
It applies equally to local development, CI, and production builds.

## 1) Core principles

1. **Reproducibility over convenience.** Anyone must be able to recreate the exact environment from source control, not from a copied folder.
2. **Environments are disposable.** A venv is a build artifact; delete/recreate is normal.
3. **One project, one environment.** No shared “mega-venv” across unrelated repos.
4. **Pin what matters.** Lock dependencies for deterministic installs in CI and production.
5. **Keep secrets out.** No credentials inside venv configs, activation scripts, or `.env` files committed to Git.

## 2) Where the venv lives (and naming)

6. **Do not commit the venv.** Always ignore it in Git (`.venv/`, `venv/`, `.python-version` may be committed if you use pyenv; the interpreter itself never is).
7. **Virtual environment location is defined by `development-environment-policy.md`.**
8. In this environment:
   * Each project has exactly one venv.
   * All venvs live under:
     `~/dev/venvs/<project-name>/`
   * Virtual environments are **never** created inside repositories.

9. Repository-local `.venv/` directories are not used in this system.

## 3) Python version discipline

10. **Pin the Python version.** Use one of:

    * `pyproject.toml` classifiers / requires-python,
    * `.python-version` (pyenv),
    * CI matrix definition.
11. **CI is the source of truth** for supported versions; developers must match it locally.
12. **No system Python modification.** Never `sudo pip install ...` into system Python.
13. **Upgrade policy:** Python minor upgrades (3.11 → 3.12) are planned, tested in CI, then rolled out—not ad hoc.

**Note:** For Python 3.14+ free-threaded mode (no-GIL) support and implications for ML/CV engineering, see [Python 3.14+ No-GIL Support](references/python-3-14+-no-gil-support.md). This document covers threading patterns, library compatibility, and prompting strategies for AI coding assistants.

## 4) Environment creation rules

14. **Create venv with the intended interpreter** (explicitly):

    * `python -m venv .venv` where `python` is already the correct version, or
    * `py -3.11 -m venv .venv` (Windows), or
    * `$(pyenv which python) -m venv .venv`.
15. **Immediately upgrade packaging tooling** inside the venv after creation (teams standardize this in bootstrap scripts):

    * `pip`, `setuptools`, `wheel` (or only `pip` if your tooling policy dictates).
16. **Never rely on “global site-packages”** (`--system-site-packages`) except for tightly controlled enterprise edge cases.

## 5) Dependency management and locking

17. **Single source of dependency truth** per repo. Avoid “requirements.txt plus random pip installs.”
18. **Use `pyproject.toml` as the canonical declaration** for modern projects (PEP 621). Treat ad-hoc `requirements.txt` as legacy unless your org standard is otherwise.
19. **Separate dependency categories**:

    * runtime / production
    * dev (lint, format, test)
    * optional extras (e.g., `gpu`, `docs`)
20. **Lock dependencies for deterministic installs** (one of):

    * `poetry.lock` (Poetry)
    * `uv.lock` (uv)
    * `requirements.lock` / `constraints.txt` (pip-tools / compiled lock)
21. **CI installs from the lock**, not from floating specifiers.
22. **Avoid unbounded ranges** (`requests>=2` without an upper bound is usually rejected in mature teams).
23. **No direct installs from random Git SHAs** unless justified and tracked; prefer released versions.
24. **Private indexes must be documented** (and authenticated via CI secrets), not baked into developer machines.

## 6) Installation workflow rules

25. **Bootstrap is scripted.** Provide `make setup`, `./scripts/bootstrap`, or similar. New devs should not “guess” commands.
26. **No manual `pip install` in day-to-day work** unless followed by updating the declared dependencies + lock.
27. **Editable installs for local packages** are the default for app repos (`pip install -e .`), so imports reflect current code.
28. **Install is idempotent.** Running setup twice should not break or drift.

## 7) Activation and command execution

29. **Activation is optional if tooling supports it**, but teams standardize execution:

    * `source .venv/bin/activate` (manual),
    * or `uv run ...`, `poetry run ...`, `pipenv run ...`,
    * or `python -m <tool>` inside the venv.
30. **Never run project tools with system python** (linters/tests must run in the project env).
31. **Document OS-specific activation commands** (Linux/macOS vs Windows PowerShell) in the README.

## 8) What must be in version control

32. **Must commit**:

    * `pyproject.toml` (or equivalent)
    * lock file (if your workflow uses one)
    * tool config (ruff/black/pytest/mypy, etc.)
    * bootstrap script / Makefile targets
33. **Must not commit**:

    * `.venv/`
    * `__pycache__/`, `.pytest_cache/`, `.ruff_cache/`, `.mypy_cache/`
    * local `.env` secrets
    * build outputs (`dist/`, `build/`)
34. **Use `.gitignore` as policy**, not suggestion. Keep it maintained.

## 9) Security and supply-chain rules

35. **Prefer hashes in locked requirements** where feasible (pip-tools `--generate-hashes`) for stronger integrity.
36. **Pin build backends and tooling** in CI when your org needs strict reproducibility.
37. **Scan dependencies** (SCA tooling) in CI; treat high-severity CVEs as build-breaking per policy.
38. **No `pip install` from untrusted sources** (random URLs). Approved indexes only.
39. **Avoid running `pip` as admin/root**; use least privilege.

## 10) Performance and ergonomics

40. **Use wheels whenever possible.** Ensure build deps are documented when native compilation is unavoidable.
41. **Cache downloads in CI** (pip/uv/poetry cache) but never cache the venv itself unless you fully understand the implications.
42. **Keep the env lean.** Remove unused dependencies; avoid “kitchen sink” dev extras.
43. **Use `pip check` (or equivalent) in CI** to detect broken dependency resolution.

## 11) Tooling integration (IDE + linters + tests)

44. **IDE must point to the project interpreter** (the venv Python). This is non-negotiable for consistent analysis.
45. **Pre-commit hooks run inside the venv context** (or via tool runners like `uv run`).
46. **Single formatting/linting stack** across the team (avoid “some use black, others yapf”).
47. **Tests must run the same way locally and in CI**, via a single command (`make test`, `pytest`, etc.), executed in the env.

## 12) CI/CD rules

48. **CI rebuilds env from scratch** (from lock) to prove reproducibility.
49. **Fail if lock is out of date** (e.g., dependency file changed but lock didn’t).
50. **Matrix test across supported Python versions** (at least the minimum and latest supported).
51. **Dependency drift is controlled**: scheduled lock refreshes with CI verification, not random upgrades.

## 13) Common anti-patterns to ban

52. Committing `.venv/` to Git.
53. Installing packages without updating dependency declarations/lock.
54. Mixing conda + venv in the same repo without a clear policy.
55. Depending on globally installed tooling (“it works on my machine”).
56. Letting developers choose arbitrary Python versions not covered by CI.
57. Using `.env` for secrets and committing it (even accidentally).

## 14) Minimal “gold standard” repo checklist

58. `.gitignore` includes `.venv/`.
59. `pyproject.toml` defines dependencies and `requires-python`.
60. Lock file present and used in CI.
61. `make setup` (or `./scripts/bootstrap`) creates venv + installs deps.
62. `make test`, `make lint`, `make format` run inside the env.
63. README has 5–10 lines that get a new developer running in minutes.

---

# Node/npm/Typescript

Below is the equivalent “professional-team grade” rule set for **Node.js + npm + TypeScript**. Written as enforceable conventions suitable for a repo policy and CI.

## 1) Core principles

1. **Reproducibility over convenience.** Anyone can clone, install, and run with identical results.
2. **Lockfile is authoritative.** Installs in CI must be deterministic.
3. **One project, one toolchain contract.** Node version, package manager, TypeScript version, and scripts are standardized.
4. **Build artifacts are disposable.** `dist/`, caches, and `node_modules/` are not sources of truth.
5. **No secrets in repo.** Never commit `.env` with credentials.

## 2) Node version discipline

6. **Pin Node.js version** and enforce it everywhere:

   * `.nvmrc` or `.node-version` (or Volta in `package.json`)
   * CI uses the same version.
7. **Define a support window** (e.g., “LTS only”). No random Node versions across dev machines.
8. **No global installs required** to build/test/lint. Everything runs via repo scripts.
9. **Upgrade Node intentionally** (scheduled, validated in CI, then rolled out).

## 3) Package manager policy (npm)

10. **Standardize on one package manager** per repo (here: npm). Do not mix npm/yarn/pnpm in the same codebase.
11. **Use npm CI installs in CI**:

    * CI must run `npm ci` (not `npm install`) for deterministic installs.
12. **Never edit lockfile manually.** It is generated by npm.
13. **Treat `package-lock.json` as mandatory.** Commit it, review it, keep it in sync.

## 4) `node_modules` and repo hygiene

14. **Never commit `node_modules/`.** Always `.gitignore` it.
15. **Build output is ignored** (e.g., `dist/`, `.tsbuildinfo`, coverage folders).
16. **Keep generated files out of source** unless they are explicitly required (rare).
17. **Avoid vendoring dependencies** (copy/pasting library code) unless legal/security reasons exist.

## 5) Dependency declaration and versioning

18. **Runtime deps go in `dependencies`.** Tooling/test/lint/build go in `devDependencies`.
19. **Use semver ranges deliberately:**

    * Prefer `^` for mature libraries when acceptable.
    * Pin exact versions for brittle toolchains if the team needs maximum reproducibility.
20. **No “floating latest”** patterns in scripts or docs.
21. **Avoid duplicate libraries** (one HTTP client, one test framework, one logger, etc.) unless you have a clear reason.
22. **Document private registries** and keep auth in CI secrets, not in code.

## 6) Install workflow rules

23. **Local install:** `npm install` only when intentionally changing dependencies.
24. **CI install:** always `npm ci`.
25. **If `package.json` changes, lockfile must change** in the same PR (CI should fail otherwise).
26. **No manual `npm install <pkg>` without updating the repo contract** (scripts/config/tsconfig as needed).

## 7) Scripts are the interface

27. **Everything runs through `npm run ...` scripts**:

    * `npm run build`, `test`, `lint`, `typecheck`, `format`, `dev`, etc.
28. **No “run this tool globally” instructions** in README.
29. **Scripts must be cross-platform** (avoid bash-only unless you explicitly target Linux only; otherwise use Node-based scripts).

## 8) TypeScript configuration discipline

30. **`tsconfig.json` is not personal.** One team-standard config, committed.
31. **Enable strictness by default** (`"strict": true`) for professional codebases, with explicit exceptions.
32. **Use consistent module settings** aligned with runtime:

    * Node ESM vs CJS is a deliberate decision; don’t mix casually.
33. **Separate configs when needed**:

    * `tsconfig.json` (base)
    * `tsconfig.build.json` (emit/build)
    * `tsconfig.test.json` (test tooling) if required
34. **Do not compile in-place.** Emit to `dist/` (or equivalent).
35. **Commit type boundaries**: public APIs should have stable types; avoid leaking internal types across packages.

## 9) Formatting, linting, and code quality

36. **Single formatting standard** (typically Prettier) and enforced via script + CI.
37. **Single lint standard** (typically ESLint) integrated with TypeScript.
38. **Typechecking is separate and required**:

    * `npm run typecheck` must run in CI.
39. **No “it compiles” without typechecking**. JS builds can pass while TS types fail—CI must catch it.
40. **Pre-commit hooks are allowed but not relied on**; CI is the enforcement point.

## 10) Testing rules

41. **Tests run via script** (`npm test`) and are CI-required.
42. **Test environment matches runtime assumptions** (Node version, ESM/CJS).
43. **Coverage is measured consistently** (if required), but do not block dev flow with overly strict thresholds unless intentional.
44. **No flaky tests tolerated**—quarantine or fix quickly.

## 11) Build and release discipline

45. **Define one build command** producing deterministic artifacts (`dist/`).
46. **Do not ship source TS** unless your distribution strategy explicitly requires it.
47. **Source maps policy is explicit** (enabled for debugging; controlled in production if needed).
48. **For libraries:** ensure `exports`/entry points in `package.json` are correct and tested.
49. **For apps:** environment config is documented and validated (fail fast if required vars missing).

## 12) Security and supply chain

50. **Run `npm audit` (or org’s scanner) in CI** with a defined policy for failures.
51. **Block install scripts by default** (`ignore-scripts=true` in `.npmrc`). Explicitly allowlist packages that require postinstall hooks after human review. See `security-policy.md §9.4` (UNC6426 supply chain attack reference).
52. **Pin critical dependencies** if you’ve had supply-chain incidents or strict compliance needs.
53. **Use provenance/attestations if your org requires it** (policy-driven).
54. **Never commit `.npmrc` with tokens.** Use environment/CI secret injection.

## 13) Monorepos and workspaces (if applicable)

55. **If using npm workspaces:** standardize workspace layout and ensure tooling supports it.
56. **One lockfile at root** and consistent scripts at root.
57. **Avoid cross-package relative imports**; use workspace package boundaries.

#### Common anti-patterns to ban

58. Committing `node_modules/` or `dist/`.
59. Using `npm install` in CI instead of `npm ci`.
60. Mixing npm with yarn/pnpm in one repo.
61. Allowing multiple Node versions without enforcement.
62. Skipping `typecheck` in CI.
63. Relying on globally installed TypeScript/ESLint/Prettier.
64. Leaving `any` everywhere instead of fixing types (allow exceptions, but track them).

## 14) Minimal “gold standard” checklist

65. Node version pinned (`.nvmrc` / `.node-version` / Volta) and CI matches.
66. `package-lock.json` committed; CI uses `npm ci`.
67. `npm run build`, `test`, `lint`, `typecheck` exist and pass in CI.
68. `tsconfig.json` is strict and emits to `dist/`.
69. `node_modules/`, `dist/`, caches ignored.
70. Secrets not in repo; `.env` ignored; example env file provided (`.env.example`).

---

# Java/Maven/Gradle/Spring/Spring Boot

Below is a professional-team rule set for **Java + Maven/Gradle + Spring + Spring Boot** (first mention: **Spring Boot** = Spring’s opinionated framework for building production-ready applications quickly).

## 1) Core principles

1. **Reproducible builds.** Same source must produce same artifact in CI and on any developer machine.
2. **Build tool is the contract.** Everything (compile/test/lint/package/run) is done via Maven/Gradle tasks, not IDE magic.
3. **Dependencies are explicit and controlled.** No “works on my machine” via transitive drift.
4. **Configuration is externalized.** Code is environment-agnostic; environment is configuration.
5. **Security is continuous.** Dependency scanning and patching are part of the normal workflow.

## 2) JDK version discipline

6. **Standardize one JDK major version** per repo (e.g., 17 or 21) and enforce it in:

   * build config (toolchains),
   * CI,
   * developer setup docs.
7. **Do not rely on system Java defaults.** Use a managed JDK (SDKMAN!/asdf/IDE-managed) and document the source.
8. **No ad hoc JDK upgrades.** Upgrade as a planned change with CI matrix testing when needed.
9. **Fail fast on wrong JDK.** Builds should error clearly if the wrong Java version is used.

## 3) Maven vs Gradle policy

10. **Choose one build tool per repo.** Do not keep both active.
11. **Use the wrapper always:**

* Maven Wrapper (`mvnw`, `.mvn/`)
* Gradle Wrapper (`gradlew`, `gradle/wrapper/`)

12. **Never require global Maven/Gradle installation.** CI and developers invoke wrapper scripts only.
13. **Wrapper version is reviewed and pinned** (committed), updated intentionally.

## 4) Repository and module structure

14. **Standard layout only.** Maven/Gradle conventional structure:

* `src/main/java`, `src/main/resources`
* `src/test/java`, `src/test/resources`

15. **Multi-module builds are explicit** (root aggregator), with clear module boundaries.
16. **One application entry point** per Spring Boot service (unless it’s a deliberate multi-app repo).
17. **Keep generated sources out of VCS** unless required (rare and justified).

## 5) Dependency management discipline

18. **Use Spring Boot dependency management** (BOM: Bill of Materials, first mention: **BOM** = a curated set of compatible dependency versions):

* For Maven: `spring-boot-starter-parent` or `dependencyManagement` importing Boot BOM.
* For Gradle: `io.spring.dependency-management` plugin or platform/BOM import.

19. **Do not pin versions already managed by the BOM** unless you are deliberately overriding (and document why).
20. **Ban duplicate/competing libraries** (multiple JSON libs, multiple HTTP clients) unless justified.
21. **Keep runtime vs test vs dev-only deps separated**:

* Maven scopes (`compile`, `runtime`, `test`, `provided`)
* Gradle configurations (`implementation`, `runtimeOnly`, `testImplementation`, `testRuntimeOnly`)

22. **No “latest” version specs** or dynamic ranges in production repos.
23. **Track and minimize transitive dependency surprises** (dependency tree checks as part of review/CI).

## 6) Build reproducibility and locking

24. **CI builds from scratch** with clean caches policy (cache dependencies, not outputs).
25. **Pin plugin versions** (Maven plugins / Gradle plugins) to avoid drift.
26. **Gradle dependency locking** is enabled for high-repro environments (when required by policy).
27. **No local jars in repo** as dependencies unless unavoidable; use a proper artifact repository (Nexus/Artifactory) or publish to an internal registry.

## 7) Spring Boot configuration rules

28. **Configuration externalized via `application.yml` / `application.properties`** plus environment overrides.
29. **No secrets in config files committed to VCS.** Use env vars or secret managers; commit `.example` templates.
30. **Use profiles intentionally** (first mention: **Profile** = named configuration set like `dev`, `test`, `prod`):

* `application-dev.yml`, `application-prod.yml`
* Avoid profile explosion; keep it manageable.

31. **Prefer constructor injection** over field injection.
32. **Avoid component-scanning ambiguity.** Keep package structure clean under a single base package.

## 8) API and architecture conventions (Spring)

33. **Clear layering** (typical):

* controller (web/API)
* service (business logic)
* repository (persistence)
* domain (entities/value objects)

34. **Controllers thin, services thick.** No business logic in controllers.
35. **Transactions at service layer** (`@Transactional`) with deliberate boundaries.
36. **DTOs at boundaries.** Do not expose JPA entities directly from controllers.
37. **Validation at boundaries** using Bean Validation (`@Valid`, constraints) consistently.
38. **Global error handling** via `@ControllerAdvice` with a stable error schema.

## 9) Persistence and migrations

39. **Database schema changes are versioned** (Flyway or Liquibase) and applied automatically in CI/test.
40. **No “manual SQL in prod.”** Migrations are the only path.
41. **Test with real DB when practical** (Testcontainers, first mention: **Testcontainers** = disposable Docker-based dependencies for tests) for integration coverage.
42. **JPA performance rules**: avoid N+1 queries, control fetch strategies, and measure with logs/profilers.

## 10) Testing standards

43. **JUnit 5 is standard** unless you have a legacy exception.
44. **Test pyramid enforced:**

* unit tests for business logic
* slice tests (`@WebMvcTest`, `@DataJpaTest`) for focused integration
* end-to-end integration tests for critical flows

45. **Spring Boot tests must be scoped**:

* avoid `@SpringBootTest` everywhere; it’s expensive.

46. **No flaky tests.** Quarantine or fix immediately.
47. **CI runs tests headlessly** with no IDE dependencies.

## 11) Code quality and formatting

48. **One formatter enforced** (Spotless, Checkstyle, Google Java Format, or equivalent) via build tasks + CI.
49. **Static analysis in CI** (e.g., SpotBugs, Error Prone) as policy dictates.
50. **No unchecked warnings ignored casually**; keep compiler warnings meaningful.
51. **Consistent logging** (SLF4J + Logback typical), no `System.out.println`.
52. **Structured logging** for services (JSON logs) if your runtime/observability stack expects it.

## 12) Spring Boot runtime and ops conventions

53. **Actuator enabled and secured** (first mention: **Actuator** = Spring Boot’s production endpoints for health/metrics):

* health, info, metrics endpoints
* restrict sensitive endpoints

54. **Health checks are meaningful** (DB connectivity, downstream dependencies where required).
55. **Metrics and tracing are standardized** (Micrometer, first mention: **Micrometer** = metrics facade used by Spring Boot).
56. **Graceful shutdown configured** and validated.
57. **External calls have timeouts and retries** (no infinite waits), with circuit breaking when required.

## 13) Packaging and deployment

58. **One artifact output** per service:

* Boot fat jar (common) or container image

59. **Versioning is automated** (CI sets version; do not hand-edit for releases unless policy requires).
60. **Build once, deploy many.** Same artifact promoted across environments.
61. **Container builds are deterministic** if used (no `latest` base images without pinning digest in strict orgs).

## 14) Security rules

62. **Dependency scanning in CI** (OWASP Dependency-Check, Snyk, etc.) with a defined failure policy.
63. **Keep Spring Boot patched** (Boot upgrades are the primary vehicle for patching the ecosystem).
64. **No deserialization risks** (avoid unsafe serialization; validate inputs).
65. **Secure defaults**: CSRF, CORS policies explicit; avoid permissive wildcard configs.
66. **Secrets via secret manager** (KMS/Vault/cloud secret stores); never in Git.

## 15) Common anti-patterns to ban

67. Building/running from the IDE without ensuring wrapper builds pass.
68. Committing `target/` or `build/`, `.classpath`, `.project`, `.idea/` (except curated run configs if your org allows).
69. Pinning random dependency versions that fight the Boot BOM.
70. Using field injection everywhere.
71. `@SpringBootTest` for every test.
72. Business logic in controllers.
73. No migrations / manual schema drift.
74. Missing timeouts on HTTP clients.
75. Actuator exposed publicly without controls.

## 16) Minimal “gold standard” checklist

76. JDK pinned and enforced via toolchains; CI matches.
77. Maven/Gradle wrapper committed and used everywhere.
78. Dependency management via Spring Boot BOM; plugins pinned.
79. `./mvnw test` or `./gradlew test` is the canonical command; CI runs it.
80. Migrations (Flyway/Liquibase) integrated; Testcontainers used for integration where appropriate.
81. Lint/format/static analysis tasks exist and are CI-enforced.
82. Actuator health/metrics configured and secured.

---

# C/C++/CMake

Below is a professional-team rule set for **C / C++ / CMake**. It is written as enforceable policy for repos and CI.

## 1) Core principles

1. **Out-of-source builds only.** Source tree stays clean; build outputs are disposable.
2. **One build definition.** CMake is the single source of truth; IDE project files are generated, not committed.
3. **Reproducibility is mandatory.** Same commit + same toolchain config yields the same artifacts in CI.
4. **Warnings are treated as defects.** Default posture is “clean build” on supported compilers.
5. **Cross-platform by design** (or explicitly constrained). If Linux-only, state it clearly.

## 2) Toolchain and language standards

6. **Pin language standards** in CMake:

   * `C_STANDARD` / `C_STANDARD_REQUIRED`
   * `CXX_STANDARD` / `CXX_STANDARD_REQUIRED`
   * avoid compiler-default standards.
7. **Define supported compilers and versions** (e.g., GCC/Clang/MSVC) and enforce in CI.
8. **No reliance on implicit flags** from developer machines. All required flags come from CMake targets.
9. **Prefer modern C++ target usage** (properties + `target_*` commands) over global flags.
10. **Use a toolchain file** for cross-compilation or non-default toolchains; do not “hand-set” compilers ad hoc.

## 3) Project layout and hygiene

11. **Canonical layout** (typical):

    * `include/` public headers
    * `src/` implementation
    * `tests/`
    * `cmake/` helper modules
    * `third_party/` only when unavoidable (prefer dependency managers)
12. **No generated files in source** (`compile_commands.json` may be generated into build dir, optionally symlinked).
13. **.gitignore must cover** `build/`, `out/`, `CMakeFiles/`, `CMakeCache.txt`, IDE folders, sanitizer logs, etc.
14. **One top-level CMakeLists.txt** that delegates to subdirectories cleanly.

## 4) CMake authoring rules (modern CMake)

15. **Minimum required CMake version** is explicit and justified (avoid overly old versions).
16. **Targets-first design**:

    * define `add_library()` / `add_executable()`
    * then use `target_sources()`, `target_include_directories()`, `target_compile_definitions()`, `target_compile_options()`, `target_link_libraries()`.
17. **No global `include_directories()` / `add_definitions()`** except in tightly controlled legacy cases.
18. **Use visibility correctly**:

    * `PRIVATE` for internal usage
    * `PUBLIC` for headers that consumers compile against
    * `INTERFACE` for header-only libs.
19. **Exported targets for libraries**: consumers link to targets, not raw include paths or flags.
20. **Avoid file globs for sources** (`file(GLOB ...)`) in serious builds; list sources explicitly (or generate lists intentionally) to avoid stale builds.

## 5) Build types and configuration

21. **Multi-config vs single-config is explicit**:

    * Visual Studio / Xcode are multi-config
    * Ninja/Make often single-config (`CMAKE_BUILD_TYPE`).
22. **Standard build types** supported: `Debug`, `Release`, optionally `RelWithDebInfo`.
23. **Default to `RelWithDebInfo` in CI packaging** if you want production performance plus symbols (policy decision).
24. **No “magic defaults.”** If a feature flag matters, expose it as a CMake option with clear docs.

## 6) Dependency management

25. **Prefer CMake-native dependency flows**:

    * `find_package()` with config packages
    * `FetchContent` for pinned source deps when acceptable
    * Conan/vcpkg when your org standardizes on them
26. **Dependencies are version-pinned** (tags/commits) for reproducibility.
27. **No vendored binaries** committed (unless compliance forces it).
28. **Link via imported targets** (e.g., `fmt::fmt`, `Boost::filesystem`) rather than raw `-l` flags.
29. **Keep dependency surface minimal**; avoid pulling huge frameworks for small needs.

## 7) Compiler warnings and hardening

30. **Warnings enabled aggressively** on each supported compiler.
31. **Warnings-as-errors in CI** (at least for project code) unless you have a formal exception mechanism.
32. **Security hardening flags** are standardized per platform (stack protector, fortify, etc.) where appropriate.
33. **No undefined behavior tolerated**: sanitize and fix rather than suppress.
34. **Treat signed/unsigned, narrowing, and lifetime warnings seriously**—these are common defect sources.

## 8) Debugging, sanitizers, and analysis

35. **Sanitizers are first-class build variants**:

    * AddressSanitizer (ASan), UndefinedBehaviorSanitizer (UBSan), ThreadSanitizer (TSan) where supported.
36. **Static analysis is part of CI** where practical:

    * clang-tidy for C/C++
    * cppcheck optionally (less authoritative than compiler/clang tools)
37. **Build must be able to generate `compile_commands.json`** (for clang tooling).
38. **Never merge sanitizer suppressions casually**; treat them as temporary and tracked.

## 9) Testing standards

39. **Tests are built and run via CTest** (`enable_testing()`, `add_test()`).
40. **One test framework** standardized (GoogleTest/Catch2/etc.), integrated via targets.
41. **Unit tests are hermetic** (don’t depend on developer filesystem state).
42. **Integration tests clearly separated** from unit tests and may require external deps (documented).
43. **CI runs tests on all supported platforms/compilers** (or explicitly scoped).

## 10) Formatting and style

44. **Formatting is automated**:

    * clang-format for C/C++
    * cmake-format optional for CMake
45. **Format is enforced in CI** (check mode) and/or pre-commit.
46. **No style debates in PRs.** Tool output is the standard.
47. **Consistent include ordering** and header guards / `#pragma once` (team standard, enforced).

## 11) Headers, ABI, and interface discipline

48. **Public headers are stable contracts.** Keep them minimal; avoid leaking implementation details.
49. **Use forward declarations** to reduce compile times where safe.
50. **Do not expose STL types across DLL boundaries on Windows** unless you fully control the toolchain/CRT policy.
51. **Control symbol visibility** for shared libraries (visibility presets) to keep ABI clean.
52. **Version and namespace public APIs** when the library is intended for external consumption.

## 12) Build performance and correctness

53. **Unity builds (jumbo) are optional** and off by default unless measured and proven beneficial.
54. **Precompiled headers (PCH)** are optional and policy-driven; only after measurement.
55. **Use Ninja in CI** (commonly) for speed and consistent output.
56. **Avoid unnecessary recompiles**: correct include usage, avoid huge headers in public APIs.

## 13) Packaging and install rules (for libraries)

57. **Use `install(TARGETS ...)` and export configs** so downstream users can `find_package()` your project.
58. **Provide a config package** (`<Project>Config.cmake`) for serious libraries.
59. **Do not hardcode absolute paths** into installed artifacts.
60. **Versioning of the package** is explicit.

## 14) CI/CD gate expectations

61. **CI stages typically include**:

    * configure
    * build
    * unit tests
    * sanitizers (at least ASan+UBSan on Linux)
    * static analysis (clang-tidy)
    * packaging (optional)
62. **CI is run in clean environments**; no reliance on developer caches beyond dependency caches.
63. **Artifacts are produced from CI** (not from dev machines) for releases.

## 15) Common anti-patterns to ban

64. In-source builds (generating `CMakeFiles/` next to `src/`).
65. Global compile flags sprinkled via `add_definitions()` and `include_directories()`.
66. Using `file(GLOB ...)` for sources in production builds without a clear regen mechanism.
67. Committing IDE-generated projects.
68. Pulling dependencies with unpinned `master/main`.
69. Turning off warnings instead of fixing code.
70. Tests that pass only on one developer machine.

## 16) Minimal “gold standard” checklist

71. `build/` (or `out/`) is the only build directory; fully ignored in Git.
72. `cmake -S . -B build -G Ninja` (or equivalent) works on a fresh machine.
73. Targets use `target_*` commands, with correct `PRIVATE/PUBLIC/INTERFACE`.
74. Warnings enabled; CI treats warnings as errors for project code.
75. `compile_commands.json` available; clang-tidy usable.
76. CTest runs unit tests in CI; sanitizers run at least on Linux.
77. clang-format enforced.

---

## Rust

### Scope and intent

Rust is used as a **systems and infrastructure language**, not as a primary
ML/CV modeling or research language.

Approved use cases include:
- performance-critical tooling
- dataset validation and ingestion
- inference helpers and edge components
- safe wrappers around C/C++/CUDA (FFI)

Rust web frameworks and full-stack Rust are out of scope unless explicitly justified.

### Toolchain and version discipline

- Rust toolchains are managed via `rustup`.
- **Stable Rust only** is permitted by default.
- Each Rust repository MUST include a `rust-toolchain.toml` file at repo root.
- The pinned toolchain version is authoritative for local development and CI.
- Global defaults MAY exist but MUST NOT be relied upon for reproducibility.

### Cargo usage rules

- `cargo` is the authoritative build and dependency manager.
- `Cargo.toml` is the single source of dependency truth.
- `Cargo.lock` MUST be committed for binaries and tooling projects.
- Build artifacts (`target/`) are never committed.

### Testing baseline

- Unit tests are mandatory (`cargo test`).
- Tests must be deterministic and isolated from external state.
- Integration and system tests follow the global Testing Policy.

---

# Rust/Cargo

Below is a professional-team rule set for **Rust + Cargo** (first mention: **Cargo** = Rust's official build system and package manager).

## 1) Core principles

1. **Reproducible builds.** Same commit builds the same way in CI and locally.
2. **One source of truth.** `Cargo.toml` + `Cargo.lock` (when applicable) define the build.
3. **Tooling is standardized.** Formatting, linting, tests, and docs are run the same way everywhere.
4. **Warnings are defects.** CI treats warnings seriously (often as errors).
5. **Small, reviewable changes.** Rust’s safety story depends on clear ownership and API boundaries.

## 2) Toolchain discipline (rustup)

6. **Pin the toolchain** with `rust-toolchain.toml` committed:

   * choose `stable` or a specific version (policy decision)
   * document exceptions if nightly is required.
7. **CI uses the same toolchain** (no “latest stable” drift unless you explicitly want that).
8. **No system Rust installs.** Use `rustup` as the standard.
9. **If nightly is required, pin the nightly date** and justify it (feature gates are not free).

## 3) Workspace and crate structure

10. **Use Cargo workspaces** for multi-crate repos; define members explicitly.
11. **Clear crate boundaries**:

    * library crates for reusable logic
    * binary crates for applications/CLI
12. **Avoid cyclic dependencies** across crates; refactor shared code into a core crate.
13. **Keep public API minimal**; prefer internal modules and re-export intentionally.
14. **Do not put “everything in one crate”** if it creates unreviewable modules; split by domain.

## 4) Dependencies and version control

15. **Declare dependencies with intent**:

    * `dependencies` for runtime
    * `dev-dependencies` for tests/bench
    * `build-dependencies` for build scripts.
16. **Avoid unnecessary features.** Enable crate features explicitly; do not accept default features blindly.
17. **Prefer semver-compatible ranges**, but do not allow uncontrolled drift in critical repos:

    * for libraries: keep `Cargo.toml` ranges reasonable
    * for applications: rely on lockfile for determinism.
18. **Avoid git/path dependencies** unless:

    * in a workspace, or
    * pinned to a commit and justified.
19. **Review transitive dependencies** for bloat and risk; keep the tree lean.

## 5) `Cargo.lock` policy

20. **Applications/binaries commit `Cargo.lock`.** This is the norm for reproducible deploys.
21. **Libraries may omit `Cargo.lock`** (common convention), unless your org mandates otherwise.
22. **CI verifies lockfile consistency**:

    * fail if `Cargo.toml` changes without lock updates where applicable.
23. **No hand-editing of `Cargo.lock`.** It is generated.

## 6) Build profiles and flags

24. **Use standard profiles** (`dev`, `release`) and only customize when measured.
25. **Avoid “mystery flags” in docs.** If a flag matters, encode it in:

    * `Cargo.toml` profiles, or
    * scripts (`just`, `make`, `cargo-*` aliases), or
    * CI config.
26. **For release artifacts**, ensure `release` builds are used and reproducible (no local-only toggles).
27. **Linker/tooling choices are explicit** when relevant (e.g., `lld`), documented, and consistent in CI.

## 7) Formatting and linting

28. **Formatting is enforced** with `rustfmt`:

    * `cargo fmt --check` in CI.
29. **Linting is enforced** with Clippy (first mention: **Clippy** = Rust’s official linter):

    * `cargo clippy -- -D warnings` (or equivalent policy).
30. **No style debates in PRs.** Tool output is the standard.
31. **Keep the lint baseline clean.** If you allow `#[allow(...)]`, require a reason and scope it narrowly.

## 8) Testing and quality gates

32. **Tests run in CI**:

    * `cargo test` (all crates, all features as policy dictates).
33. **Feature matrix is tested** if you publish a library (at least common feature combinations).
34. **Doctests and examples** should compile and run when they are part of your API contract.
35. **Use `cargo test --locked`** in CI to guarantee lockfile correctness.
36. **No flaky tests.** Quarantine or fix quickly.

## 9) Documentation and API stability

37. **Public APIs require docs** (`///`), especially for library crates.
38. **Fail docs in CI** for published libs:

    * `cargo doc` (and optionally `-D warnings` in rustdoc for serious crates).
39. **Semver discipline** for published crates:

    * breaking changes are major bumps
    * deprecate before removal when feasible.
40. **Keep examples minimal and correct**; they are part of the developer experience.

## 10) Error handling and observability

41. **Use structured error types** (e.g., `thiserror`, `anyhow` with clear boundaries).
42. **Avoid panics in library code** except for programmer errors; return `Result` for expected failure.
43. **Logging/tracing is standardized**:

    * prefer `tracing` for async/services when appropriate
    * keep log levels meaningful and consistent.
44. **No silent error swallowing.** Errors are propagated or logged with context.

## 11) Safety, `unsafe`, and concurrency

45. **`unsafe` is exceptional.** Require:

    * a documented safety invariant
    * the smallest possible scope
    * review by someone comfortable with unsafe Rust.
46. **Use safe abstractions first**; introduce `unsafe` only when profiling proves the need.
47. **Concurrency policy is explicit**:

    * async runtime choice (Tokio/async-std) is standardized per repo
    * avoid mixing runtimes casually.
48. **No data races by construction**—lean on ownership and synchronization primitives appropriately.

## 12) Supply chain and security

49. **Audit dependencies** (first mention: **cargo-audit** = tool that checks dependencies for known vulnerabilities):

    * run `cargo audit` (or org SCA tool) in CI with a defined fail policy.
50. **Review licenses** with `cargo-deny` where required (first mention: **cargo-deny** = checks licenses/advisories/bans).
51. **Ban known-bad crates** and duplicate versions if your org standardizes this.
52. **Avoid unmaintained crates** when practical; document exceptions.

## 13) Performance and profiling

53. **Measure before optimizing.** Use `criterion` for benchmarks when needed.
54. **Prefer algorithmic wins** over micro-optimizations.
55. **Control features for perf** (disable heavy default features you don’t need).
56. **Use release profiling tools** (`perf`, `pprof`, etc.) with symbols when required.

## 14) CI/CD conventions

57. **Canonical CI steps**:

    * `cargo fmt --check`
    * `cargo clippy -- -D warnings`
    * `cargo test --locked`
    * `cargo build --release --locked` (when producing artifacts)
58. **Cache Cargo registries** and `target/` intelligently, but never let cache hide reproducibility issues.
59. **Test on all supported platforms** (Linux/Windows/macOS) if you claim support.
60. **MSRV policy** (first mention: **MSRV** = Minimum Supported Rust Version) for libraries:

    * define MSRV explicitly
    * enforce in CI.

## 15) Common anti-patterns to ban

61. Unpinned toolchains (CI drift).
62. Committing “quick fixes” via broad `#[allow(clippy::all)]`.
63. Excessive crate features enabled “just in case.”
64. `unsafe` without safety comments/invariants.
65. Git dependencies pointing to branches instead of pinned commits.
66. Ignoring `Cargo.lock` policy (apps should commit it; CI should enforce).

## 16) Minimal “gold standard” checklist

67. `rust-toolchain.toml` pinned; CI matches.
68. `cargo fmt --check` and `cargo clippy -- -D warnings` in CI.
69. `cargo test --locked` in CI; lockfile policy followed.
70. Workspace layout clean; crate boundaries clear.
71. Dependency audit (cargo-audit / cargo-deny or org scanner) in CI.
72. Documented API + examples for public crates; semver discipline followed.

---

# CUDA/OpenCV/OpenGL

Below is a professional-team rule set for **CUDA + OpenCV + OpenGL** (first mention: **CUDA** = NVIDIA’s GPU computing platform; **OpenCV** = Open Source Computer Vision library; **OpenGL** = Open Graphics Library, a graphics API).

## 1) Core principles

1. **Determinism and reproducibility first.** Same commit + pinned toolchain must build and run the same in CI and on dev machines.
2. **Correctness before performance.** Performance work is gated by profiling evidence, not intuition.
3. **Clear boundaries.** Computer vision (OpenCV), compute (CUDA), and rendering (OpenGL) responsibilities are separated in code and build targets.
4. **Interop is explicit.** Any CUDA–OpenGL sharing is documented, isolated, and tested.

## 2) Toolchain and version discipline

5. **Pin GPU toolchain versions**:

   * CUDA Toolkit version (and driver minimum) is documented and enforced.
   * C++ standard and compiler versions are pinned (host compiler matters for NVCC).
6. **Single build system contract** (typically CMake): devs and CI build the same way, without IDE-only steps.
7. **No “works on my GPU” drift.** Define supported GPU architectures (first mention: **SM** = Streaming Multiprocessor capability like `sm_86`) and compile accordingly.
8. **Explicit GPU arch flags**: build must set `-gencode`/`CMAKE_CUDA_ARCHITECTURES` deliberately, not default.
9. **OpenCV version is pinned and consistent** across all machines (ABI stability matters). No “system OpenCV on one machine, custom build on another”.

## 3) Repository hygiene and build outputs

10. **Out-of-source builds only.** Build directories are disposable and ignored (`build/`, `out/`).
11. **No vendored binaries** (OpenCV libs, drivers, compiled artifacts) committed to Git.
12. **Third-party dependencies are managed** via a clear mechanism (package manager or pinned source build) and documented.

## 4) GPU/CPU API boundaries and ownership rules

13. **Explicit memory ownership**:

* Every buffer has a single owner and a documented lifetime.
* Define whether memory is on host (CPU), device (GPU), or shared.

14. **No hidden transfers.** Any host↔device copy is visible in code review (named functions/wrappers), measurable, and logged in profiling.
15. **RAII everywhere** (first mention: **RAII** = Resource Acquisition Is Initialization): GPU resources (device buffers, streams, events, GL objects) are released deterministically.
16. **No raw pointers crossing layers** without a clear contract (size, alignment, ownership, stream/context).

## 5) CUDA kernel and runtime best practices

17. **Kernel launch correctness is mandatory**:

* Check and handle `cudaGetLastError()` / `cudaPeekAtLastError()` in debug builds.
* Synchronization points are explicit and justified.

18. **No implicit synchronization surprises**:

* Avoid accidental device-wide syncs (e.g., careless `cudaDeviceSynchronize()`).
* Stream usage is intentional (first mention: **Stream** = CUDA command queue for async execution).

19. **Stable error-handling policy**:

* Wrap CUDA API calls in a single macro/function that logs file/line and error string.
* Fail fast in debug; controlled recovery only where needed.

20. **Memory access patterns are reviewed**:

* Coalesced global memory access where possible.
* Avoid bank conflicts in shared memory when relevant.

21. **Numerics policy is explicit**:

* float vs half vs int types are chosen intentionally.
* Use fast math only when validated against accuracy requirements.

22. **Avoid undefined behavior on GPU**: alignment, out-of-bounds, race conditions, and uninitialized memory are treated as critical defects.
23. **Kernels are benchmarked under realistic sizes**, not micro toy inputs.

## 6) Performance workflow (profiling-driven)

24. **Profile before optimizing** using Nsight tools (first mention: **Nsight Systems** = system-level GPU/CPU timeline; **Nsight Compute** = kernel-level profiling).
25. **Separate bottleneck identification**:

* CPU preprocessing (OpenCV)
* PCIe transfers (first mention: **PCIe** = CPU–GPU interconnect)
* GPU kernels (CUDA)
* Render pipeline (OpenGL)

26. **Performance changes must include evidence**:

* baseline vs after metrics (timings, throughput, GPU utilization)
* profiler snapshots or summaries

27. **Avoid premature micro-optimizations.** Prioritize removing transfers, reducing memory traffic, and improving algorithmic complexity.

## 7) OpenCV usage rules (production-grade)

28. **Build OpenCV consistently** (same compile flags, same modules enabled, same SIMD options).
29. **Treat `cv::Mat` lifetime carefully**:

* Avoid accidental deep copies.
* Be explicit when cloning vs referencing.

30. **Color space and layout are explicit**:

* BGR/RGB, YUV formats, alpha handling are documented at boundaries.

31. **Avoid hidden conversions** (types and channel counts) in hot paths.
32. **Threading policy is explicit**:

* OpenCV internal threading (TBB/OpenMP) is either enabled and controlled or disabled to avoid oversubscription with your own thread pools.

## 8) OpenGL usage rules (rendering correctness)

33. **Context management is disciplined**:

* Context creation is centralized.
* No OpenGL calls outside a valid context/thread.

34. **GL state is not “ambient.”** State changes are localized; do not rely on implicit global state across modules.
35. **Use debug layers in dev**:

* Enable GL debug output (first mention: **KHR_debug** = OpenGL debug extension) and fail fast on errors in debug builds.

36. **Resource lifecycle is explicit** (buffers, textures, shaders, programs, VAOs). No leaks tolerated.
37. **Shader compilation and validation** errors are surfaced clearly (build logs, runtime logs).

## 9) CUDA–OpenGL interoperability rules

38. **Interop is isolated behind a small API** (one module) with clear invariants.
39. **Registration and mapping discipline**:

* Register GL buffers/textures once when possible.
* Map/unmap per frame only when required, and measure it.

40. **Synchronization is explicit and minimal**:

* Avoid device-wide sync.
* Use events/fences appropriately (first mention: **Fence** = GPU synchronization primitive; in GL, `glFenceSync`).

41. **No undefined ownership while shared**:

* When CUDA has a mapped resource, GL does not touch it and vice versa.

42. **Validate interop on target drivers**: interop can be driver-sensitive; CI or release qualification must cover it.

## 10) Data layout and zero-copy rules

43. **Define canonical image buffer formats** across the pipeline (stride, alignment, pixel format).
44. **Prefer contiguous, aligned allocations** for predictable performance.
45. **Use pinned host memory only when justified** (first mention: **Pinned** = page-locked host memory for faster DMA), because it affects system memory behavior.
46. **Avoid “accidental zero-copy” assumptions.** Unified Memory (first mention: **UVM** = Unified Virtual Memory) is not a free win; if used, it is a deliberate policy with performance validation.

## 11) Testing and validation

47. **Golden tests for vision outputs**:

* deterministic test inputs
* tolerance-based assertions for floating point

48. **CPU/GPU parity tests** for core algorithms where feasible (same semantics).
49. **Stress and soak tests**:

* long-run GPU memory leak detection
* repeated context creation/destruction (OpenGL)

50. **Sanity checks in debug builds**:

* bounds checks where possible
* asserts for invariants (dimensions, strides, formats)

51. **Performance regression tests** on representative workloads (even a small benchmark suite) gated in CI where practical.

## 12) CI/CD and release discipline

52. **CI builds with pinned toolchain** (containerized builds strongly preferred).
53. **CI runs at least**:

* unit tests
* a minimal GPU smoke test on a GPU runner (if the project depends on GPU correctness)

54. **Artifact provenance is clear** (exact CUDA/OpenCV/OpenGL dependencies used).
55. **Driver/toolkit compatibility matrix is documented** and kept current.

## 13) Logging, telemetry, and diagnostics

56. **Structured logging around GPU steps**:

* timings for preprocess/transfer/kernel/postprocess/render
* key dimensions and formats

57. **Crash reports include GPU context**:

* driver version
* CUDA runtime version
* GPU model and SM capability

58. **Debug toggles exist** (compile-time and runtime) to enable heavy checks without impacting release builds.

#### Common anti-patterns to ban

59. Mixing OpenCV CPU ops and CUDA kernels with silent copies between them.
60. Calling OpenGL from random threads without context discipline.
61. Relying on “it’s fast on my GPU” without profiler evidence.
62. Global `cudaDeviceSynchronize()` sprinkled to “make it work.”
63. Unpinned CUDA/OpenCV versions causing ABI/runtime drift.
64. Interop code spread across the codebase instead of isolated.

---

<a id="apirest"></a>

# API / REST / MVC / gRPC

Below is a professional-team rule set for **API design and implementation**, covering **REST** (Representational State Transfer), **MVC** (Model–View–Controller), and **gRPC** (Google Remote Procedure Call). I’m treating “gRPV” as **gRPC**.
