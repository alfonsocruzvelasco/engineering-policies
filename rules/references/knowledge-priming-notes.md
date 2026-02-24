# Knowledge Priming — Comprehensive Notes

> **Source:** [Martin Fowler / Rahul Garg — *Knowledge Priming*](https://martinfowler.com/articles/reduce-friction-ai/knowledge-priming.html)
> **Author:** Rahul Garg (Principal Engineer, Thoughtworks)
> **Published:** 24 February 2026
> **Series:** Patterns for Reducing Friction in AI-Assisted Development

---

## Core Thesis

AI coding assistants default to **generic patterns from training data** — "the average of the internet." Knowledge Priming is the practice of sharing curated project context with AI *before* asking it to generate code. This is essentially **manual RAG (Retrieval-Augmented Generation)** and fundamentally changes the quality of AI output.

> *"AI assistants are like highly capable but entirely contextless collaborators."*

---

## 1. The Default Behavior Problem

### The "Frustration Loop"
Without priming, developers experience a recurring cycle:
1. Generate code
2. Find it doesn't fit the codebase
3. Regenerate with corrections
4. Repeat until giving up or accepting heavily-modified output

This friction stems not from AI capability, but from a **missing onboarding step**.

### Example: What Goes Wrong Without Priming

**Request:** "Create a UserService that handles authentication"

**AI generates 200 lines using:**
- Express.js → project uses Fastify
- JWT stored in `localStorage` → project uses httpOnly cookies
- `utils/auth.js` helper → convention is `lib/services/`
- Class-based syntax → codebase is functional
- Outdated bcrypt API → project uses latest version

The code *works* syntactically, but is **completely wrong** for the codebase.

**Root cause:** AI defaults to training data — a blend of millions of repos, tutorials, and Stack Overflow answers.

---

## 2. The Knowledge Hierarchy

Three layers of AI knowledge, ordered by priority (highest wins):

| Priority | Layer | Description |
|----------|-------|-------------|
| **Highest** | **Priming Documents** | Explicit project context: architecture decisions, naming conventions, specific versions and patterns. Overrides defaults. |
| **Medium** | **Conversation Context** | What's been discussed in the current session. Fades over long conversations. |
| **Lowest** | **Training Data** | Millions of repositories, tutorials, generic patterns — often outdated. "Average of the internet." |

### Why Priming Works (Mechanistic Explanation)

Transformer models use **attention mechanisms as a finite token budget**. Every token in the context window competes for influence over output:

- Generic window → model draws on average of training data
- Specific, high-signal project context → those tokens attract more attention weight → steers generation toward project-specific patterns

**Key insight:** Curation matters more than volume. A focused priming document doesn't just *add* context, it **shifts the balance** of what the model pays attention to.

---

## 3. Before and After: Impact of Priming

| Dimension | Without Priming | With Priming |
|-----------|----------------|--------------|
| Framework | Express.js (wrong) | Fastify (correct) |
| Syntax | Class-based (wrong) | Functional (correct) |
| File paths | Incorrect convention | Correct structure |
| APIs | Outdated | Current |
| Time to usable code | 45+ min of fixing | 5 min review + tweaks |

---

## 4. Anatomy of a Priming Document

A good priming document is a **curated cheat sheet** — not a brain dump. Target: **1–3 pages maximum**.

### Section 1: Architecture Overview

Explain the big picture: what kind of application, major components, how they interact.

```markdown
## Architecture Overview
This is a microservices-based e-commerce platform.
- API Gateway: Handles routing, auth, rate limiting
- User Service: Authentication, profiles, preferences
- Order Service: Cart, checkout, order history
- Notification Service: Email, SMS, push notifications

Services communicate via async message queues (RabbitMQ).
Each service owns its database (PostgreSQL).
```

### Section 2: Tech Stack and Versions

**Version numbers matter** — APIs change between versions. Be specific.

```markdown
## Tech Stack
- **Runtime**: Node.js 20.x (LTS)
- **Framework**: Fastify 4.x (not Express)
- **Database**: PostgreSQL 15 with Prisma ORM 5.x
- **Auth**: JWT with httpOnly cookies (not localStorage)
- **Testing**: Vitest + Testing Library (not Jest)
- **Validation**: Zod schemas (not Joi)
```

### Section 3: Curated Knowledge Sources

Direct AI to the team's trusted sources — not the generic internet. Includes:
- Official documentation the team actually uses
- Blog posts that influenced architecture
- Internal ADRs and docs

```markdown
## Curated Knowledge

### Official Documentation
| Topic | Source | Why We Trust It |
|-------|--------|-----------------|
| Fastify routing | https://fastify.dev/docs/latest | Official, matches our v4.x |
| Prisma relations | https://www.prisma.io/docs/orm/... | Authoritative for schema patterns |

### Internal References
| Topic | Path | What It Captures |
|-------|------|------------------|
| Error conventions | docs/error-handling.md | Our specific patterns |
| API design | docs/adr/003-api-versioning.md | Decision rationale |
```

**Keep it curated:** 5–10 sources that genuinely shaped how the team works.

### Section 4: Project Structure

Show AI where things live. File placement matters.

```
src/
├── lib/
│   ├── services/      # Business logic
│   ├── repositories/  # Database access layer
│   ├── schemas/       # Zod validation schemas
│   └── utils/         # Pure utility functions
├── routes/            # Fastify route handlers
├── middleware/        # Auth, logging, error handling
├── types/             # TypeScript type definitions
└── config/            # Environment-specific config
```

### Section 5: Naming Conventions

Explicit conventions prevent style drift.

```markdown
## Naming Conventions
- **Files**: kebab-case (`user-service.ts`, not `UserService.ts`)
- **Functions**: camelCase, verb-first (`createUser`, `validateToken`)
- **Types/Interfaces**: PascalCase with descriptive suffixes (`UserCreateInput`)
- **Constants**: SCREAMING_SNAKE_CASE (`MAX_RETRY_COUNT`)
- **Booleans**: is/has/can prefix (`isActive`, `hasPermission`)
```

### Section 6: Code Examples

**Show, don't just tell.** Include 2–3 examples of "good code" from the codebase.

```typescript
// lib/services/user-service.ts
import { prisma } from '../db/client'
import { UserCreateInput, UserResponse } from '../types/user'
import { hashPassword } from '../utils/crypto'

export async function createUser(input: UserCreateInput): Promise<UserResponse> {
  const hashedPassword = await hashPassword(input.password)

  const user = await prisma.user.create({
    data: { ...input, password: hashedPassword },
    select: {
      id: true,
      email: true,
      createdAt: true,
      // Never return password
    },
  })

  return user
}
```

Key demonstrated patterns: functional (not class-based), Prisma ORM, explicit field selection.

### Section 7: Anti-patterns to Avoid

Tell AI what NOT to do. Prevents common mistakes.

```markdown
## Anti-patterns (Do NOT use)
- Class-based services (use functional approach)
- Express.js patterns (this project uses Fastify)
- Storing JWT in localStorage (use httpOnly cookies)
- Using `any` type (always define proper types)
- Business logic in route handlers (use services)
- Raw SQL queries (use Prisma ORM)
```

---

## 5. Priming as Infrastructure, Not Habit

### The Key Shift

| Approach | Description | Problem |
|----------|-------------|---------|
| **Habit** (copy-paste) | Manually paste context at start of each session | Fades over time, inconsistent |
| **Infrastructure** (versioned files) | Store priming doc in repo, auto-loads per tool | Persists, team-wide, auditable |

### Tool-Specific Storage Locations

```
# Cursor
.cursor/rules                          # Always-on, auto-loaded

# GitHub Copilot
.github/copilot-instructions.md        # Workspace-level instructions

# Claude Projects
Upload priming doc to Project Knowledge
```

### Benefits of Infrastructure Approach

- **Version controlled** — changes are auditable and reviewable
- **Applies automatically** — no manual copy-paste each session
- **Team-wide consistency** — everyone gets the same context
- **PR-reviewable changes** — governance built into existing workflows

> *"The difference between a habit that fades and a practice that persists."*

---

## 6. Common Pitfalls

| Pitfall | Symptom | Fix |
|---------|---------|-----|
| **Too much information** | 20+ page docs overwhelm AI | Keep to 1–3 pages of essential context |
| **Too vague** | "Modern best practices" | Be specific: "Fastify 4.x, Prisma 5.x, functional services" |
| **No examples** | Describing patterns without showing them | Include 2–3 real code snippets |
| **Outdated content** | Priming doc from 6+ months ago | Review monthly or after major changes |
| **Missing anti-patterns** | Telling AI what TO do only | Explicitly list patterns NOT wanted |

### The "Too Much" Trap

A priming document is a **cheat sheet**, not comprehensive documentation. If longer than 3 pages, ask:
- Does AI need *all* of this to generate a service?
- Can detailed docs live elsewhere and just be referenced?
- Are edge cases included that rarely come up?

AI can ask follow-up questions. Start focused, expand only when needed.

---

## 7. Keeping Priming Documents Current

Documentation rots. To prevent staleness:

### Treat It as Code
- Store in repo: `docs/ai-priming.md`
- Changes require PR review
- Tech lead owns quarterly review (aligned with dependency updates)

### Reference, Don't Duplicate
- For auth decisions: "See ADR-007"
- For API contracts: "See `/api/schema.yaml`"
- For deployment: "See ops runbook"

### Update Triggers

| Trigger | Action |
|---------|--------|
| New framework version | Update stack section |
| New architectural pattern | Add code example |
| Repeated AI mistakes | Add to anti-patterns |
| Major refactor | Review structure section |

> **Warning:** A stale priming doc is *worse* than none — it actively teaches AI outdated patterns.

---

## 8. Real-World Condensed Example

Target: **under 50 lines**. The Acme API example:

```markdown
# Acme API - Priming Context

## Quick Overview
B2B SaaS API for inventory management. Multi-tenant, event-driven.

## Stack
- Node.js 20, Fastify 4, TypeScript 5
- PostgreSQL 15 + Prisma 5 (multi-tenant via tenantId)
- Auth: Clerk (external), JWT validation middleware
- Queue: BullMQ + Redis for async jobs
- Testing: Vitest

## Trusted Sources
- Fastify: https://fastify.dev/docs/latest
- Prisma multi-tenancy: https://www.prisma.io/docs/...
- ADRs: docs/adr/
- Error handling: docs/error-conventions.md

## Structure
src/
├── modules/           # Feature modules (users/, products/, orders/)
│   └── [module]/
│       ├── service.ts    # Business logic
│       ├── routes.ts     # HTTP handlers
│       ├── schema.ts     # Zod schemas
│       └── types.ts      # TypeScript types
├── shared/            # Cross-cutting (db, auth, queue)
└── config/

## Patterns
- Functional services (no classes)
- All queries include `where: { tenantId }` (multi-tenant)
- Validation at route level with Zod
- Errors thrown as `AppError` with status codes

## Anti-patterns
- No classes for services
- No raw SQL (use Prisma)
- No business logic in routes
- No hardcoded tenantId

## Example Service
[One short example from the codebase]
```

---

## 9. Trade-offs and Limitations

| Cost | Notes |
|------|-------|
| **Upfront effort** | Creating and maintaining priming docs requires time |
| **Diminishing returns** | For very simple tasks, overhead may not be justified |
| **Stale context risk** | Outdated docs can be worse than none |
| **Not a guarantee** | Even with good priming, AI will sometimes produce wrong output |

**Best ROI:** Non-trivial work spanning multiple sessions or involving team coordination. For a quick utility function, manual correction may be faster.

---

## 10. Key Takeaways

1. **Context is infrastructure.** Store priming docs in version control — not in someone's clipboard.
2. **Curation beats volume.** A focused 2-page document outperforms a 20-page dump.
3. **Show, don't just tell.** Real code examples anchor AI to actual project patterns.
4. **Anti-patterns are as important as patterns.** Explicitly saying "not this" is as valuable as "do this."
5. **This is manual RAG.** You're filling the context window with high-signal tokens to shift attention weights away from generic defaults.
6. **Priming compounds.** It makes design conversations, custom commands, and other AI workflows more effective downstream.
7. **Update triggers matter.** Tie doc updates to architectural events, not calendar dates.

---

## Mental Model Summary

```
Without Priming:
  AI → training data defaults → "average of the internet" → wrong for your codebase

With Priming:
  AI → priming doc (high-attention tokens) → project-specific patterns → fits your codebase

As Infrastructure:
  priming doc → repo → version controlled → auto-loads → team-wide → PR-reviewed → stays current
```

---

*Notes compiled from: https://martinfowler.com/articles/reduce-friction-ai/knowledge-priming.html*
