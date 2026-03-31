# Learning Repository AI Usage Boundary

**Purpose:** Explicitly define AI usage boundaries for learning repositories to ensure policy compliance and reduce ambiguity.

**Scope:** Applies to all learning library repositories (book code, course material, reference implementations, study corpus).

**Last updated:** 2026-03-29

---

## 1. Learning Corpus Classification

### ✅ This is a **Learning-Only Repository**

**What this means:**
- **Read-only / study corpus** — not an execution surface for production code
- **No proprietary or employer data** — contains only public knowledge, examples, and personal study materials
- **No automated agents acting on it** — AI assistance is limited to tutoring, synthesis, and planning
- **BYOAI-safe by design** — compatible with strict enterprise AI policies

### Key Distinction

> **Learning corpus ≠ production codebase**

This structure enforces that separation:
- ❌ **Not** pointing personal agents at:
  - Company repos
  - Proprietary datasets
  - Internal APIs
  - Production infrastructure
- ✅ **Using AI as:**
  - A tutor
  - A synthesizer
  - A planning aid
  - A concept explainer

This is exactly the **"controlled enablement"** model enterprises want — applied personally.

---

## 2. AI Usage Policy (Default: Allowed)

### ✅ Permitted AI Usage in Learning Repositories

**By default, AI usage is allowed** in learning repositories for:

1. **Conceptual Learning:**
   - Explaining mathematical concepts
   - Clarifying algorithm implementations
   - Summarizing research papers
   - Generating study questions

2. **Code Understanding:**
   - Explaining existing code
   - Suggesting improvements (as learning exercises)
   - Generating test cases for practice
   - Refactoring examples for clarity

3. **Planning & Organization:**
   - Structuring learning paths
   - Creating study schedules
   - Organizing notes and references
   - Generating documentation from notes

4. **Tooling & Infrastructure:**
   - Setting up development environments
   - Creating boilerplate for practice projects
   - Generating configuration files
   - Scaffolding project structures

### ⚠️ Restrictions

**AI usage is NOT permitted for:**
- Accessing or processing proprietary data
- Connecting to production systems
- Automating actions on company infrastructure
- Bypassing security controls
- Processing sensitive information

---

## 3. AI-Assisted Engineering Folder Boundaries

**Location:** `4-ml-systems-mlops/ai-assisted-engineering`

### ✅ What AI Usage Means Here

**AI here = patterns, architectures, tooling**

- Learning about AI-assisted development patterns
- Understanding agent architectures
- Studying tooling and frameworks
- Exploring best practices

### ❌ What AI Usage Does NOT Mean Here

**Not: autonomous agents touching real infrastructure**

If you later add:
- Agents
- Automation
- Pipelines
- Production tooling

They **MUST** live in:
- A sandbox repo (see `ai-workflow-policy.md` for sandbox restrictions)
- A clearly marked experimental area
- A separate repository with explicit boundaries

**Rule:** This folder is for **learning about** AI-assisted engineering, not **deploying** it.

---

## 4. Cursor Plugin Workspace (Learning)

Cursor plugin artifacts live under `.cursor/` in learning repos.

- **Rules:** `.cursor/rules/` (active guidance, standards)
- **Skills:** `.cursor/skills/`
- **Agents:** `.cursor/agents/`
- **Commands:** `.cursor/commands/`
- **MCP Servers:** `.cursor/mcp/`
- **Hooks:** `.cursor/hooks/`

**Scope:** Learning repos and non-proprietary codebases only. Human remains accountable.

**Boundaries:**
- ✅ Permitted in learning repositories (study corpus, reference implementations)
- ✅ Permitted in personal, non-proprietary projects
- ❌ **Not permitted** in company/proprietary codebases without explicit approval
- ❌ **Not permitted** for production systems without security review

**Accountability:** The human developer remains fully accountable for all AI-assisted outputs, regardless of Cursor plugin configuration.

---

## 5. Policy Compliance Statement

### Enterprise AI Governance Alignment

This learning repository structure:

1. **Declares intent** → Reduces ambiguity → Reduces risk
2. **Separates learning from production** → Prevents accidental policy violations
3. **Documents boundaries explicitly** → Enables audit and compliance

### BYOAI (Bring Your Own AI) Compliance

**This repository is BYOAI-safe because:**
- No proprietary data exposure
- No production system access
- No automated agent execution
- Clear boundaries documented

**AI tools allowed:**
- ChatGPT / Claude (for tutoring and explanation)
- Local LLMs (for privacy-sensitive learning)
- Summarization tools
- Concept explanation tools

**AI tools restricted:**
- Autonomous agents with production access
- Tools that process proprietary data
- Agents that modify production systems
- Tools that bypass security controls

---

## 6. Documentation Requirements

### Required Documentation

Every learning repository should include in its README:

```markdown
## AI Usage Boundary

This repository is a **learning-only corpus**. AI usage is permitted for:
- Conceptual learning and explanation
- Code understanding and practice
- Planning and organization
- Tooling and infrastructure setup

**Restrictions:**
- No proprietary data processing
- No production system access
- No autonomous agent execution

See `rules/system/learning-ai-usage-boundary.md` for full policy.
```

### Optional: AI Usage Charter

For repositories with significant AI-assisted learning, consider adding a one-page "AI Usage Charter" that:
- Documents specific AI tools used
- Describes learning objectives
- Notes any experimental boundaries
- Records compliance with enterprise policies

---

## 7. Enforcement

### Self-Governance

**You are responsible for:**
- Maintaining clear boundaries between learning and production
- Not blurring the line between study corpus and execution surface
- Documenting any experimental AI usage
- Escalating questions about boundary cases

### Red Flags (Stop and Reassess)

Immediately stop and reassess if you find yourself:
- Using AI to access company systems
- Processing proprietary data through AI tools
- Deploying agents from learning repos to production
- Automating actions on production infrastructure
- Bypassing security controls for "learning purposes"

---

## 8. Relationship to Other Policies

### Related Documents

- **`learning-library-governance.md`** — Structural discipline for learning repos
- **`ai-workflow-policy.md`** — Production AI usage policies and sandbox restrictions
- **`security-policy.md`** — Security boundaries and prohibited tools
- **`approved-ai-tools.md`** — Authorized AI tools registry

### Policy Hierarchy

1. **Learning repos** → This document (AI usage allowed by default, with restrictions)
2. **Sandbox repos** → `ai-workflow-policy.md` (strict sandbox enforcement)
3. **Production repos** → `security-policy.md` + `approved-ai-tools.md` (full compliance required)

---

## 9. Bottom Line

**This is a policy-compliant learning control plane.**

- ✅ Structure matches senior-level ML engineering reality
- ✅ Fully compatible with conservative enterprise AI policies
- ✅ Cleanly avoids the personal-agent liability zone
- ✅ Explicitly documents boundaries to reduce ambiguity

**Verdict:** This learning repository structure is **BYOAI-safe by design**. Maintain clear boundaries, document intent, and keep learning separate from production.

---

**Next Steps:**
- Add AI usage boundary statement to learning repository READMEs
- Review `4-ml-systems-mlops/ai-assisted-engineering` folder to ensure it's clearly marked as learning-only
- Consider creating an AI Usage Charter for repositories with significant AI-assisted learning
