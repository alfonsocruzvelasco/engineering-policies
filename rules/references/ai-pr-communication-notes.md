# How AI Coding Agents Communicate — PR Communication Evidence

**Source:** arXiv:2602.17084 (MSR 2026)
**PDF:** `rules/references/how-ai-coding-agents-communicate.pdf`
**Date:** February 2026
**Cross-reference:** production-policy.md §5.5 PR requirements; ai-workflow-policy.md §AI Usage Declaration

---

## Summary

Empirical study of **33,596 PRs** across 5 AI coding agents (Claude Code, GitHub Copilot, Cursor, Devin, OpenAI Codex). Measures PR description characteristics against human review outcomes: merge rates, engagement, sentiment, and time to completion. Core finding: **how you communicate a change is a statistically significant factor in review outcomes, independent of code correctness.**

---

## Key Findings (Policy-Relevant)

| Agent | Merge rate | Time to completion | Notes |
|-------|------------|--------------------|-------|
| OpenAI Codex | 82.6% (highest) | 0.02h | Headers + lists; structured PRs |
| Cursor | 65.22% | — | Highest negative sentiment, yet 2nd-best merge rate |
| Claude Code | 59% | 1.95h | Longest reviewer comments, highest positive sentiment |
| GitHub Copilot | 43.0% (lowest) | 13h | Most comments/PR; most verbose; lowest merge |

**Takeaways:**
- **Structured PRs** (headers, lists) correlate with fastest review and highest merge (Codex).
- **Verbosity without structure** creates review drag (Copilot: most text, lowest merge, 13h completion).
- **Sentiment ≠ acceptance.** Cursor had highest negative sentiment but second-best merge rate; negative comments often target presentation, not correctness.
- **Conventional commit** compliance: Claude Code (z=1.06) and Devin (z=1.04) scored highest — empirical backing for conventional commit titles.

---

## Policy Implications

1. **AI-generated PRs MUST use Markdown structure:** at minimum one `##` header per logical section (Problem, Solution, Testing). Evidence: Codex 82.6% merge, 0.02h.
2. **PR descriptions MUST be structured, not verbose.** Evidence: Copilot most text, 43% merge, 13h completion.
3. **Conventional commit titles are REQUIRED for AI-generated PRs.** Evidence: Paper’s conventional_commit metric.
4. **Sentiment in review comments MUST NOT be used as a proxy for PR quality or acceptance.** Evidence: Cursor high negative sentiment, 65.22% merge.
5. **AI usage declaration: solution section must explain intent, not just describe the diff.** Reduces reviewer cognitive burden and verification cost.

---

## What This Paper Does NOT Change

- Existing 2-approval requirement
- CI/security gates
- Agent selection decision tree (paper describes outcomes, not capability rankings)

---

**Last updated:** 2026-02-23
