# Web Policies

**Status:** Authoritative
**Last updated:** 2026-03-24
**Purpose:** Web technology standards for API design, JavaScript/React, and HTML/CSS

---

## API / REST / MVC / gRPC

Below is a professional-team rule set for **API design and implementation**, covering **REST** (Representational State Transfer), **MVC** (Model–View–Controller), and **gRPC** (Google Remote Procedure Call). I’m treating “gRPV” as **gRPC**.

## 1) Core principles

1. **Contract-first**: the API contract is designed, reviewed, versioned, and tested as a primary artifact.
2. **Backwards compatibility by default**: breaking changes are exceptional and require explicit versioning.
3. **Security by default**: authentication and authorization are mandatory; “internal only” is never an excuse.
4. **Consistency beats cleverness**: naming, error formats, pagination, filtering, and auth patterns are uniform across endpoints.
5. **Observability is part of the API**: every request is traceable, measurable, and debuggable in production.

## 2) API styles: when and how to use REST vs gRPC

6. **REST** is the default for public/partner APIs and broad interoperability (browsers, mobile, third parties).
7. **gRPC** is preferred for service-to-service calls requiring strong typing, high throughput, streaming, or low latency.
8. If you expose both, **REST and gRPC must share the same domain model semantics** (don’t drift).
9. Define one **canonical source of truth** for schema:

   * REST: OpenAPI specification (first mention: **OpenAPI** = standard for describing HTTP APIs).
   * gRPC: `.proto` files (Protocol Buffers).
10. Do not design “hybrid endpoints” that behave like RPC over REST without a clear reason.

## 3) REST (Representational State Transfer) rules

### Resource modeling and naming

11. Model endpoints around **resources** (nouns), not actions (verbs).
12. Use consistent plural nouns: `/users`, `/orders`, `/payments`.
13. Use hierarchical paths only for true containment: `/users/{userId}/orders`.
14. Avoid deep nesting (usually max 2–3 levels).

### HTTP methods and semantics

15. GET is **safe** (no side effects) and **idempotent**.
16. POST creates or triggers non-idempotent operations.
17. PUT is full replacement and **idempotent**.
18. PATCH is partial update; define patch semantics clearly.
19. DELETE is idempotent where feasible.

### Status codes and content negotiation

20. Use status codes correctly:

* 200/201/204 for success
* 400 validation errors
* 401 unauthenticated
* 403 unauthorized
* 404 not found
* 409 conflict
* 429 rate limited
* 5xx server errors

21. Return `Location` on 201 where applicable.
22. Content-Type and Accept are respected; default to JSON.

### Pagination, filtering, sorting

23. Pagination is mandatory for list endpoints.
24. Choose one pagination strategy and standardize it:

* cursor-based preferred for large datasets

25. Filtering and sorting parameters are documented and validated.
26. Response must include metadata (next cursor, page size, total count if feasible and not expensive).

### Idempotency and retries

27. For POST endpoints that clients may retry, support **Idempotency-Key** headers when appropriate.
28. Document retry behavior; ensure retries cannot double-charge or double-create.

## 4) MVC (Model–View–Controller) rules for server applications

29. Controllers are **thin**: parse/validate input, call services, map to responses.
30. Business logic lives in **service/domain layer**, not controllers.
31. Persistence concerns live in **repositories/DAO** (Data Access Object; first mention: **DAO** = persistence abstraction).
32. Controllers must not leak internal domain entities directly; use DTOs (first mention: **DTO** = Data Transfer Object).
33. Centralize error handling (global exception handlers / middleware), not per-endpoint try/catch.

## 5) gRPC (Google Remote Procedure Call) rules

### `.proto` contract discipline

34. `.proto` files are versioned and reviewed like code.
35. Follow consistent package naming and service naming conventions.
36. Messages are designed for evolution: add fields; do not renumber existing field tags.

### API design

37. Prefer “resource-oriented” RPCs where it makes sense (Create/Get/List/Update/Delete patterns), even in gRPC.
38. Define timeouts and deadlines as mandatory client behavior; services must respect deadlines.
39. Use streaming only when it delivers clear value; document flow control and backpressure.

### Error model

40. Standardize error mapping using gRPC status codes (INVALID_ARGUMENT, NOT_FOUND, ALREADY_EXISTS, PERMISSION_DENIED, UNAUTHENTICATED, RESOURCE_EXHAUSTED, INTERNAL, UNAVAILABLE).
41. Include machine-readable error details (structured error metadata) consistently.

### Interop

42. If you expose REST alongside gRPC, consider a gateway; ensure the mapping is documented and tested.

## 6) Versioning strategy (REST and gRPC)

43. Define one versioning policy and enforce it:

* REST: URI version (`/v1/...`) or header-based versioning; pick one and standardize.
* gRPC: package versioning (`my.service.v1`) is common.

44. Backwards-compatible changes:

* adding optional fields
* adding endpoints/RPCs

45. Breaking changes require a new major version and migration plan.
46. Deprecation policy must include:

* deprecation announcement
* sunset date
* telemetry to detect remaining usage
* clear migration docs

## 7) Input validation and schema rules

58. Validate at the boundary (controllers/handlers).
59. Use a shared schema definition:

* OpenAPI schemas for REST
* `.proto` for gRPC

60. Reject unknown fields when strictness is required; otherwise document permissive behavior.
61. Normalize and validate identifiers, dates, currency, locale/timezone behavior.

## 8) Error handling and error contracts

62. Standardize error response format for REST (single envelope):

* `code` (machine)
* `message` (human)
* `details` (structured)
* `trace_id` (for support)

63. Never leak sensitive internal details in errors.
64. For gRPC, standardize mapping to status + structured details.
65. Document error codes and make them stable.

## 9) Observability and operational rules

66. Every request has a correlation/trace identifier (first mention: **Trace ID** = identifier linking logs/metrics/traces).
67. Logs are structured; PII (Personally Identifiable Information) is redacted (first mention: **PII** = data that can identify a person).
68. Metrics include:

* request rate
* latency (p50/p95/p99)
* error rates by code
* saturation signals (threads, queue depth)

69. Distributed tracing is enabled for service-to-service calls, including gRPC.
70. Health endpoints are meaningful (readiness vs liveness).

## 10) Performance, rate limiting, and resilience

71. Timeouts are mandatory end-to-end; no infinite waits.
72. Rate limiting and quotas are defined and enforced (429 / RESOURCE_EXHAUSTED).
73. Retries are bounded and use backoff; retries are safe only with idempotency.
74. Bulkheads/circuit breakers are applied for unstable dependencies.
75. Payload sizes are bounded; reject overly large requests.

## 11) Data and compatibility rules

76. Do not expose database schema directly as API shapes.
77. Avoid breaking JSON field renames; if needed, support both during migration.
78. Define canonical date/time formats (ISO 8601) and timezone semantics.
79. For gRPC, keep field tags stable forever.

## 12) Security hygiene

80. TLS everywhere (including internal traffic where feasible).
81. CORS (Cross-Origin Resource Sharing; first mention: **CORS** = browser cross-origin policy controls) is explicit and minimal.
82. Audit logging for sensitive actions is mandatory.
83. Least privilege for OAuth2 scopes and service credentials.
84. Regular dependency scanning and patching cadence.

## 13) “Gold standard” CI gate

85. Contract validation:

* OpenAPI lint + breaking change detection (REST)
* proto lint + compatibility checks (gRPC)

86. Unit tests + integration tests
87. AuthZ tests (authorization) for critical endpoints
88. Load/perf smoke test for hot paths
89. Static analysis + security scans

## 14) HTML-facing API rules (browser clients)

This subsection defines **how APIs are consumed from HTML-based clients** (plain HTML, server-rendered pages, or JS-enhanced UIs). These rules exist to prevent accidental contract violations caused by browser defaults.

### HTML forms and HTTP semantics

90. **HTML forms are limited to GET and POST.**
    PUT, PATCH, and DELETE **must not** be assumed available from native forms.
91. **Method overrides are explicit** when required:

* Use a hidden field (`_method=PUT`) **only if your server framework explicitly supports it**.
* Never rely on undocumented middleware behavior.

92. **GET forms are read-only**:

* No state changes
* Safe for reloads, back/forward navigation, and caching.

93. **POST forms are non-idempotent by default**:

* Protect with CSRF tokens
* Redirect after success (PRG pattern: Post → Redirect → Get).

### URL and routing discipline

94. **HTML links (`<a>`) always map to GET endpoints only.**
    No side effects behind links. Ever.

95. **URLs exposed to browsers are stable contracts**:

* No leaking internal IDs without intent
* No accidental coupling to database keys unless documented.

96. **Human-facing routes and API routes are distinct**:

* `/users/42` (HTML view)
* `/api/v1/users/42` (API resource)

Never mix both responsibilities in the same controller without a clear policy.

### Content negotiation and representation

97. **HTML clients negotiate explicitly**:

* Browser views expect `text/html`
* API clients expect `application/json`

Do not rely on User-Agent sniffing.

98. **Controllers must return one representation per endpoint** unless explicitly designed for negotiation.
Avoid “sometimes HTML, sometimes JSON” endpoints without a formal content-negotiation strategy.

### Validation and error feedback (HTML context)

99. **Validation errors for HTML clients are user-facing**:

* Field-level messages
* Non-technical language
* No stack traces or internal codes rendered in HTML.

100. **HTTP status codes still matter**, even with HTML:

* 400 for validation errors
* 401/403 for auth issues (with proper redirects)
* 404 for missing resources
* 500 rendered as generic error pages

HTML rendering does **not** relax correctness of HTTP semantics.

### Authentication and sessions (HTML vs API)

101. **HTML clients typically use sessions/cookies**, not OAuth tokens.

* Cookies must be `HttpOnly`, `Secure`, and SameSite-controlled.
* CSRF protection is mandatory.

102. **OAuth2 tokens are not stored in HTML or JS-accessible cookies** unless you fully understand the security implications.
103. **Never mix session-based auth and token-based auth implicitly** on the same endpoints.

### Progressive enhancement rule

104. **HTML-first must still work without JavaScript** for critical flows when feasible.
105. **JavaScript enhances HTML; it does not redefine the contract**:

* JS fetches call the same APIs documented for non-browser clients.
* No “secret endpoints” used only by frontend code.

### Caching and browser behavior

106. **Cache headers are explicit** for HTML responses:

* Prevent caching of authenticated pages unless intentional.
* Public pages declare cacheability deliberately.

107. **Redirects are intentional**:

* 302/303 after POST
* Avoid redirect chains that hide failures.

### HTML security rules

108. **All HTML output is escaped by default** (XSS prevention).
109. **Never inject raw API error messages into HTML** without sanitization.
110. **CORS rules do not protect HTML pages** — they protect APIs.
     Do not assume browser same-origin rules replace server-side authorization.

---

# Vanilla JavaScript (ES2020)/React/WebGL/D3
Below is a professional-team rule set for **Vanilla JavaScript** (using the most common modern baseline: **ES2020**), **React**, **WebGL**, and **D3** (first mention: **D3** = Data-Driven Documents, a visualization library).

## 1) Core principles

1. **One baseline, enforced.** Language/runtime targets are pinned and enforced in CI and tooling.
2. **Type safety is intentional.** If you use TypeScript, it is mandatory across the repo; if you don’t, you compensate with runtime validation and tests.
3. **Single source of truth for state and data flow.** No ad hoc shared mutable state.
4. **Performance is measured.** Profiling evidence is required for perf-driven changes.
5. **Accessibility and UX are non-negotiable** for user-facing apps.

## 2) Vanilla JavaScript baseline (ES2020) rules

### Language/runtime targeting

6. **Baseline: ES2020** unless your user base requires older browsers. This is the default “modern web” compromise.
7. **Target is explicit** via build tooling (Babel/TS compiler settings) and documented.
8. **No mixing module systems.** Pick and enforce **ES Modules** (first mention: **ESM** = ECMAScript Modules) for modern code.

### Code style and hygiene

9. **Strict mode by default** (ESM implies strict).
10. **No global variables.** Everything is module-scoped.
11. **Prefer `const`, then `let`; avoid `var`.**
12. **Prefer pure functions** and immutable patterns in shared logic.
13. **Avoid hidden coercions.** Use strict equality (`===`), explicit parsing, explicit null handling.
14. **Error handling is explicit**: don’t swallow errors in async flows.

### Tooling gates

15. **Formatter and linter are mandatory** (Prettier + ESLint typical) and enforced in CI.
16. **No “style debates” in PRs.** Tool output is the standard.

## 3) React rules (production-grade)

### Architecture and component discipline

17. **Components are small and composable.** One component = one responsibility.
18. **Separate “container” vs “presentational” concerns** where it reduces complexity.
19. **Business logic does not live in JSX.** Extract logic to hooks or service modules.
20. **Side effects are isolated** (useEffect used sparingly, with clear dependency reasoning).

### State management

21. **Prefer local state first**, then lift state only when necessary.
22. **Avoid prop drilling beyond a few levels**; use context intentionally.
23. **Global state is explicit** (a dedicated store pattern) and justified; no ad hoc module singletons.
24. **Server state is managed as server state** (caching, invalidation, retries) rather than shoved into local/global state.

### Rendering performance

25. **Avoid premature memoization.** Use `memo`, `useMemo`, `useCallback` only with evidence.
26. **Keys are stable and meaningful** (never array index if the list can reorder).
27. **Virtualize large lists** when needed; measure first.

### Testing

28. **Test behavior, not implementation details.** Prefer user-level interactions.
29. **Critical flows have integration tests** (routing, auth, data fetch, error states).

### Accessibility and UX

30. **Accessibility (a11y) is mandatory** (first mention: **a11y** = accessibility):

* semantic HTML first
* keyboard navigation
* focus management
* ARIA only when needed

31. **Loading/empty/error states** are treated as first-class UI states.

## 4) WebGL rules (graphics correctness + maintainability)

(First mention: **WebGL** = browser graphics API based on OpenGL ES.)

### Context and state discipline

32. **Context creation is centralized.** No scattered context management.
33. **No “ambient global GL state.”** State changes are localized and tracked.
34. **Use WebGL debug tooling in dev** (error checks, shader logs); remove overhead in production.

### Resource lifecycle

35. **Explicit lifecycle for GPU resources** (buffers, textures, shaders, programs):

* create
* use
* delete on teardown

36. **No leaks tolerated.** Long-lived apps must clean up on route changes/unmounts.

### Data and performance

37. **Minimize CPU↔GPU transfers.** Upload once, reuse buffers, batch updates.
38. **Avoid per-frame allocations** in render loops.
39. **Shaders are versioned and tested** (compile/link logs surfaced).
40. **Precision and color space are explicit** (gamma, linear/sRGB decisions documented).

### Integration with React

41. **WebGL is isolated behind a component boundary**:

* React owns lifecycle
* WebGL module owns rendering and resources

42. **Use refs for imperative rendering**; avoid tying rendering to React re-renders.

## 5) D3 rules (visualization discipline)

(First mention: **D3** = Data-Driven Documents.)

### Separation of concerns

43. **D3 for math/layout/scales**, not for owning your entire DOM if you are using React.
44. If using React, prefer:

* D3 scales, axes calculations, layouts
* React renders DOM/SVG

45. If using D3 for DOM manipulation, keep it in an isolated subtree and don’t let React compete for the same nodes.

### Data joins and updates

46. **Data join is explicit and stable**:

* stable keys for joins
* update/enter/exit flows are handled intentionally

47. **Animations are deliberate** and must not harm performance/accessibility.

### Performance and correctness

48. **Avoid re-computing scales/layout each render** unless data changed materially.
49. **Prefer SVG for small/medium datasets**, Canvas/WebGL for very large datasets; choose deliberately and document.
50. **Axis formatting, tick density, and labels** are consistent and readable.

## 6) Interop rules: React + WebGL + D3 in one codebase

51. **Single owner per DOM subtree**: either React or D3 imperative code, never both on the same nodes.
52. **Rendering loops (WebGL) are not React state loops.** Use a requestAnimationFrame loop managed via refs.
53. **Data flow is unidirectional**:

* props/state → visualization input
* visualization emits events (hover/select) via callbacks

54. **Debounce/throttle high-frequency events** (mouse move, zoom) and measure impact.

## 7) Security and robustness

55. **Never interpolate untrusted content into HTML** (XSS controls).
56. **Validate external data** at boundaries; don’t assume API payload shape.
57. **Content Security Policy (CSP)** is considered early if you embed shaders or dynamic code (first mention: **CSP** = Content Security Policy).

## 8) CI and “gold standard” gates

58. **Lint + format** on every PR.
59. **Typecheck** if TypeScript is in use (otherwise stronger test coverage + runtime validation).
60. **Unit + integration tests** on core flows.
61. **Bundle/build check** with the pinned targets (ES2020 baseline).
62. **Performance smoke checks** for critical render paths (WebGL/D3-heavy pages), at least via automated benchmarks or manual profiling checklist.
63. **Accessibility checks** (automated where possible, manual for key flows).

## 9) Common anti-patterns to ban

64. Mixing React rendering with D3 DOM mutation on the same elements.
65. Using React state updates on every animation frame for WebGL.
66. Shader compilation errors hidden in console noise (must be surfaced clearly).
67. Unstable list keys causing re-mount storms.
68. Overuse of `useEffect` with unclear dependencies.
69. Per-frame allocations in hot rendering loops.
70. “Works in Chrome” without baseline browser testing.

---

# HTML/CSS

Below is a professional-team rule set for **HTML + CSS**.

## 1) Core principles

1. **Semantic first.** Use HTML to express meaning and structure; CSS handles presentation.
2. **Accessibility is mandatory.** Every UI is keyboard- and screen-reader-usable.
3. **Consistency over creativity.** A shared design system and naming conventions beat ad hoc styling.
4. **Responsive by default.** Layouts must work across target breakpoints and input types.
5. **Maintainability first.** CSS is authored to scale: predictable specificity, minimal overrides, no fragile hacks.

## 2) HTML semantics and structure rules

6. **Use semantic elements** (`header`, `nav`, `main`, `section`, `article`, `footer`) rather than div soup.
7. **Exactly one `<main>` per page/view.**
8. **Heading hierarchy is valid**:

   * one primary `h1` per page/view
   * do not skip heading levels casually.
9. **Landmarks are present and correct** (nav, main, complementary, contentinfo).
10. **Forms use real form semantics**:

* `label` is associated with inputs
* `fieldset/legend` for grouped inputs
* correct input types (`email`, `number`, `date`) when applicable.

11. **Buttons are buttons.** Use `<button>` for actions, `<a>` for navigation. No div-clickables.
12. **Avoid inline styles** except for narrowly justified cases (e.g., dynamic calculated styles in rare components).

## 3) Accessibility rules (a11y)

(First mention: **a11y** = accessibility.)
13. **Keyboard access**: all interactive elements must be reachable and operable with keyboard alone.
14. **Visible focus**: focus outlines are not removed; any customization keeps strong visibility.
15. **Alt text is meaningful**:

* decorative images: empty alt (`alt=""`)
* informative images: descriptive alt.

16. **ARIA is last resort**:

* prefer semantic HTML
* if using ARIA, it must be correct and tested.

17. **Accessible names for controls**:

* labels, `aria-label`, or `aria-labelledby` where needed.

18. **Color contrast meets WCAG** targets; do not encode meaning only by color.
19. **Motion is respectful**:

* honor `prefers-reduced-motion`
* avoid aggressive animations.

## 4) CSS architecture rules

20. **Pick one CSS strategy and enforce it** (e.g., BEM, CSS Modules, utility-first, design tokens). Do not mix casually.
21. **Component-scoped styles are preferred** for large apps to avoid global leakage.
22. **Global CSS is minimal**:

* resets/normalization
* typography base
* design tokens (CSS variables)
* layout primitives.

23. **Design tokens are the source of truth**:

* colors, spacing, typography, radii, shadows via CSS variables.

24. **Avoid high specificity**:

* do not rely on `!important` except as a documented escape hatch.

25. **No deep nesting** (if using preprocessors). Keep selectors shallow and predictable.

## 5) Naming and conventions

26. **Class naming is consistent**:

* if using BEM (Block__Element--Modifier), use it everywhere.
* if using CSS Modules, keep class names simple and local.

27. **No styling by IDs.** IDs are for semantics/JS hooks, not layout/styling.
28. **No styling by tag chains** as primary approach (`.card div ul li span`) is brittle.
29. **One responsibility per class** where possible; avoid “do-everything” utility soup unless you are explicitly utility-first.

## 6) Layout rules (modern CSS)

30. **Use Flexbox and Grid intentionally**:

* Flexbox for 1D layouts (row/column)
* Grid for 2D layouts.

31. **Avoid layout hacks**:

* no float-based layouts (except text flow)
* no table-based layouts.

32. **Responsive units are standard**:

* use `rem` for typography and spacing baseline
* use `%`, `fr`, `minmax()` for responsive layout.

33. **Mobile-first is preferred** unless the product strongly dictates otherwise.
34. **Avoid fixed heights** in content containers; prefer intrinsic sizing.
35. **Use `gap` instead of margin hacks** for spacing between flex/grid items.

## 7) Typography, spacing, and sizing

36. **Set a root font-size** and scale typography consistently.
37. **Use `line-height` intentionally**; avoid cramped defaults.
38. **Limit arbitrary spacing values**; prefer tokenized spacing steps.
39. **Don’t hardcode colors.** Use tokens/variables.

## 8) Responsiveness and media

40. **Breakpoints are standardized** (few, meaningful). No random per-component breakpoints.
41. **Images are responsive**:

* set max width constraints (`max-width: 100%`) where appropriate
* use `srcset/sizes` for performance when needed.

42. **Use `@media (prefers-reduced-motion)`** for animation-heavy UIs.
43. **Dark mode is explicit** if supported:

* `prefers-color-scheme` or a theme toggle
* tokens handle theme switching.

## 9) Performance rules

44. **Minimize CSS bundle size**:

* remove dead styles
* avoid huge global frameworks unless justified.

45. **Avoid expensive selectors** and overly broad rules (e.g., `* {}` used carelessly).
46. **Animations**:

* animate `transform` and `opacity` primarily
* avoid layout thrash (width/height/top/left) unless necessary.

47. **Avoid forced synchronous layout** patterns in JS/CSS interplay.

## 10) Forms and UI states

48. **All interactive states are designed**:

* default, hover, active, focus, disabled, error, loading.

49. **Validation styles** are consistent and accessible (text + icon + color, not color alone).
50. **Touch targets** meet minimum sizing guidelines; avoid tiny clickable areas.

## 11) Cross-browser and quality gates

51. **Define browser support policy** and test against it.
52. **Use Autoprefixer** (or equivalent) rather than hand-writing vendor prefixes.
53. **Normalize CSS** in a controlled way (reset/normalize is standardized).
54. **Linting and formatting are mandatory**:

* Stylelint for CSS
* Prettier formatting (or equivalent)

55. **No inline `style=` in markup** unless policy allows it for rare dynamic cases.

## 12) Common anti-patterns to ban

56. Divs used as buttons/links.
57. Removing focus outlines without a replacement.
58. `!important` everywhere to “fix” specificity issues.
59. Deep selector chains that break on minor DOM changes.
60. Hardcoded magic numbers for spacing/colors outside a token system.
61. Layout built with fixed pixel heights that clip content.
62. Unlabeled form controls.

## 13) Minimal “gold standard” checklist

63. Semantic HTML landmarks and heading structure correct.
64. Keyboard navigation works end-to-end; focus is visible.
65. Design tokens drive colors/spacing/typography.
66. Layout uses Flex/Grid with responsive units and standardized breakpoints.
67. Styles are scoped (or globally minimal) with predictable specificity.
68. Stylelint + formatter enforced in CI; Autoprefixer enabled.
69. Responsive images handled; motion respects user preferences.

---

# Docker/Podman/Kubernetes/Kafka

Below is a professional-team rule set for **Docker / Kubernetes / Podman / Kafka**, written as enforceable policy suitable for real production teams.
