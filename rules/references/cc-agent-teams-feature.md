# Claude Code Agent Teams - Complete Feature Notes

## Table of Contents
- [Overview](#overview)
- [Core Concepts](#core-concepts)
- [Setup & Activation](#setup--activation)
- [Best Use Cases](#best-use-cases)
- [Display Modes](#display-modes)
- [Usage Patterns](#usage-patterns)
- [Token Economics](#token-economics)
- [Technical Architecture](#technical-architecture)
- [Coordination Features](#coordination-features)
- [Integration & Ecosystem](#integration--ecosystem)
- [Current Limitations](#current-limitations)
- [Best Practices](#best-practices)
- [Philosophy](#philosophy)
- [References](#references)

---

## Overview

**Release Date:** February 2026 (with Claude Opus 4.6)
**Status:** Experimental/Research Preview
**Availability:** Claude Code (requires explicit enablement)

Agent Teams enables multiple Claude Code instances to work together in parallel on shared tasks. This represents a fundamental shift from sequential single-agent workflows to collaborative multi-agent orchestration, similar to coordinating a team of specialized developers.

---

## Core Concepts

### What Are Agent Teams?

Agent Teams allow you to coordinate multiple Claude Code instances working together. One session acts as the **team lead**, coordinating work, assigning tasks, and synthesizing results. **Teammates** work independently, each in its own context window, and communicate directly with each other.

### Key Differentiators from Subagents

| Feature | Subagents | Agent Teams |
|---------|-----------|-------------|
| Context | Single session | Separate context per teammate |
| Communication | Report back to main agent only | Direct inter-teammate messaging |
| Workflow | Sequential | Parallel execution |
| Task Coordination | Through main agent | Shared task list |
| User Interaction | Via main agent | Can interact with individual teammates |

**Key Insight:** Subagents can only report results back. They can't message each other, share discoveries mid-task, or coordinate without the main agent acting as intermediary. Agent teams enable true collaboration.

---

## Setup & Activation

### Enable the Feature

Agent Teams is **disabled by default**. Enable it via environment variable:

```bash
# Option 1: Environment variable
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# Option 2: In settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### Persistence

To persist across sessions, add to your shell profile:
```bash
# Add to ~/.bashrc or ~/.zshrc
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

---

## Best Use Cases

### High-Value Scenarios (Justify 5x Token Cost)

#### 1. Multi-Perspective Code Reviews
**Problem:** Single reviewer gravitates toward one type of issue
**Solution:** Spawn specialized reviewers

```
Create an agent team to review PR #142. Spawn three reviewers:
- Security Reviewer: Token handling, input validation, auth flows
- Performance Reviewer: N+1 queries, memory leaks, unnecessary renders
- Test Reviewer: Coverage gaps, edge cases, flaky test patterns

Have them each review and report findings.
```

**Why it works:** Three perspectives catch what one misses. Lead synthesizes all findings into one comprehensive review.

#### 2. Adversarial Debugging (The Killer Use Case)
**Problem:** Single agents find one plausible explanation and stop
**Solution:** Multiple agents arguing with competing hypotheses

**Pattern:**
- Spawn 3-5 teammates
- Each investigates different hypothesis
- Teammates message each other to disprove theories
- Consensus emerges through debate, not guessing

**Why it works:** The competing hypotheses pattern finds the right explanation faster than a single agent guessing.

#### 3. Cross-Layer Feature Development
**Problem:** Context-switching between frontend, backend, and database
**Solution:** Each teammate owns their layer

```
I'm building a real-time notification system. Create an agent team:
- Frontend teammate: React components and WebSocket client
- Backend teammate: API endpoints and business logic
- Database teammate: Schema design and migration scripts
```

**Why it works:** Each agent stays deep in their domain without losing context to task-switching.

#### 4. Research & Exploration
**Problem:** Need diverse perspectives on a design problem
**Solution:** Parallel exploration with distinct viewpoints

```
I'm designing a CLI tool that helps developers track TODO comments
across their codebase. Create an agent team to explore this from
different angles: one teammate on UX, one on technical architecture,
one playing devil's advocate.
```

**Why it works:** Independent exploration prevents groupthink; diverse perspectives emerge naturally.

### Poor Use Cases (Stick to Single Session or Subagents)

- **Sequential tasks** - No parallelization benefit
- **Same-file edits** - Agents would conflict
- **Routine/simple tasks** - Overhead not justified
- **Anything without parallel exploration value** - Token cost isn't worth it

**Rule of Thumb:** If the task can't benefit from multiple specialists working simultaneously, don't use agent teams.

---

## Display Modes

### 1. In-Process Mode (Default in non-tmux terminals)

**Characteristics:**
- All teammates run in single terminal window
- Switch between teammate views: `Shift+Up` / `Shift+Down`
- Works everywhere
- Can feel cramped with 3+ teammates

**Best for:** 2-teammate teams, terminals without tmux/iTerm2

### 2. Split Panes Mode

**Characteristics:**
- Each teammate gets own tmux or iTerm2 pane
- See all agents working simultaneously
- Catch problems as they happen, not after the fact
- **The recommended mode for 3+ teammates**

**Requirements:**
- tmux or iTerm2
- Standalone terminal (NOT VS Code integrated terminal)

**Setup for tmux:**
```bash
# Install tmux (Ubuntu/Debian)
sudo apt-get install tmux

# Install tmux (macOS)
brew install tmux

# Start tmux session before launching Claude Code
tmux
```

**Setup for iTerm2 (macOS alternative):**
- Install it2 CLI tool
- Enable Python API in iTerm2 settings

**Does NOT work with:**
- VS Code integrated terminal
- Windows Terminal
- Ghostty

### 3. Auto Mode (Default Setting)

**Behavior:**
- Detects your environment automatically
- Uses split panes if already in tmux session
- Falls back to in-process otherwise

**Recommendation:** Use split panes for any team with 3+ members to monitor all agents simultaneously.

---

## Usage Patterns

### Natural Language Prompting

Agent Teams uses **natural language** for setup - no YAML configs, no boilerplate.

**Example 1: Code Review Team**
```
Create an agent team to review our authentication module:
- One teammate checking security implications
- One teammate analyzing performance impact
- One teammate validating test coverage

Each should review independently and report their findings.
```

**Example 2: Feature Development Team**
```
I need to add OAuth integration to our app. Create an agent team:
- Frontend teammate: Login UI and token handling
- Backend teammate: OAuth flow and API integration
- DevOps teammate: Environment config and secrets management
```

**Example 3: Debugging Team**
```
Our app crashes intermittently in production. Create an agent team
to investigate:
- One teammate exploring memory leak hypothesis
- One teammate investigating race conditions
- One teammate checking for external service failures

Have them share findings and debate the most likely cause.
```

### What Claude Does Automatically

1. Creates team with shared task list
2. Spawns teammates for each specified role
3. Coordinates work distribution
4. Enables inter-teammate communication
5. Synthesizes findings from all teammates
6. Attempts cleanup when task completes

### Autonomous Team Proposals

Claude can autonomously propose creating a team if it determines your task would benefit from multi-agent collaboration. **You stay in control** - Claude asks before spawning.

---

## Token Economics

### Cost Structure

**Base Reality:** Each teammate is a full Claude instance with its own context window.

- **Single session:** 1x tokens
- **5-person team:** ~5x tokens
- **10-person team:** ~10x tokens

**Token usage scales linearly with team size.**

### When the Cost Is Justified

✅ **Worth it:**
- Parallel code reviews (3-5 specialized reviewers)
- Adversarial debugging (competing hypotheses)
- Multi-module feature development (each owns a layer)
- Research with multiple perspectives

❌ **Not worth it:**
- Sequential tasks
- Single-file edits
- Routine refactoring
- Simple bug fixes

### Real-World Example

From the Rust C compiler case study:
- **16 agents** working on building a C compiler
- **~2,000 Claude Code sessions**
- **$20,000 in API costs**
- **Result:** 100,000-line compiler that compiles Linux kernel

**Key Takeaway:** For sufficiently complex tasks, the parallel exploration justifies significant token investment.

---

## Technical Architecture

### High-Level Design

From Anthropic's C compiler case study, here's how parallel Claude instances work:

```
┌─────────────────────────────────────────┐
│         Bare Git Repository             │
│            (/upstream)                  │
└─────────────────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
    ┌───▼───┐   ┌───▼───┐   ┌───▼───┐
    │Agent 1│   │Agent 2│   │Agent 3│
    │Docker │   │Docker │   │Docker │
    └───┬───┘   └───┬───┘   └───┬───┘
        │           │           │
    /workspace  /workspace  /workspace
    (local)     (local)     (local)
        │           │           │
        └───────────┴───────────┘
                    │
            Push to /upstream
```

**Flow:**
1. Bare git repo created as shared workspace
2. Each agent gets Docker container with repo mounted to `/upstream`
3. Agent clones local copy to `/workspace`
4. Agent works independently in its workspace
5. When done, pushes from local container to upstream
6. Simple lock file prevents task collision

### Synchronization

**Lock Mechanism:** Agent takes a "lock" on a task by writing a text file to communicate which tasks are in progress.

**Prevents:** Two agents solving the same problem simultaneously.

### Key Architectural Learnings

#### 1. Fresh Container = No Context
**Problem:** Each agent drops into fresh container with no prior knowledge
**Solution:** Maintain extensive READMEs and progress files that are updated frequently

**Example Structure:**
```
/upstream/
  ├── README.md           # Project overview
  ├── PROGRESS.md         # Current status, completed tasks
  ├── ARCHITECTURE.md     # Design decisions
  └── NEXT_STEPS.md       # Prioritized todo list
```

#### 2. Tests Designed for AI, Not Humans
**Problem:** Agents need different feedback than human developers
**Solution:** Design test harness assuming no human oversight

**Key Differences:**
- More verbose error messages
- Explicit instructions in test output
- Progress indicators that help orientation
- Clear success/failure criteria

#### 3. Continuous Integration Critical
**Problem:** Agents broke existing functionality when implementing new features
**Solution:** Strict CI pipeline enforcement

**Implementation:**
- All tests must pass before merge
- No new commits can break existing code
- Automated regression detection

---

## Coordination Features

### 1. Shared Task List
Central coordination mechanism that all teammates can see and update.

**Benefits:**
- Prevents duplicate work
- Enables progress tracking
- Facilitates dynamic work distribution

### 2. Inter-Agent Messaging
Teammates communicate directly without going through the lead.

**Use Cases:**
- Sharing discoveries mid-task
- Debating approaches
- Coordinating on interfaces/contracts
- Challenging each other's assumptions

**Example Exchange:**
```
Agent 1: "I found the performance bottleneck in the ORM query"
Agent 2: "That matches what I'm seeing in the profiler - but I also
          see memory allocation spikes. Could be related?"
Agent 3: "Actually, I think you're both looking at symptoms. The
          root cause is the connection pool size..."
```

### 3. Lead Synthesis
Team lead aggregates results from all teammates into coherent output.

**Responsibilities:**
- Collect findings from all teammates
- Identify conflicts or contradictions
- Synthesize unified recommendation
- Present final deliverable to user

### 4. Independent Execution
Each agent works autonomously within its domain.

**Benefits:**
- Parallel progress
- Deep focus without context switching
- Specialized expertise development
- No blocking dependencies

---

## Integration & Ecosystem

### Compound Engineering Plugin

**Source:** Every Inc.
**GitHub:** https://github.com/EveryInc/compound-engineering-plugin

**Philosophy:** 80% planning and review, 20% execution

**Installation:**
```bash
/plugin marketplace add https://github.com/EveryInc/compound-engineering-plugin
/plugin install compound-engineering
```

**Key Workflows:**

#### `/workflows:plan`
Turns feature ideas into detailed implementation plans.

**Why it matters:** Better specs → better agent output. The detailed planning makes agent delegation work well.

#### `/workflows:review`
Runs multi-agent code review before merging.

**Specialized Reviewers:**
- Security reviewer
- Performance reviewer
- Architecture reviewer
- Complexity reviewer

#### `/workflows:compound`
Documents learnings so future agents benefit from past work.

**Why it matters:** Creates institutional knowledge. Each subsequent agent starts with more context and makes fewer mistakes.

**Compounding Dynamic:** The more you codify learnings, the less each new agent struggles.

**Compatibility:**
- Claude Code (primary)
- OpenCode (experimental)
- Codex (experimental)

### Community Orchestration Tools

**Claude Code Orchestrator**
GitHub: https://github.com/mohsen1/claude-code-orchestrator

Third-party tool for multi-agent orchestration that predated official Agent Teams feature.

---

## Current Limitations

### 1. Platform Restrictions
**Split pane mode requires:**
- tmux or iTerm2
- Standalone terminal

**NOT supported:**
- VS Code integrated terminal
- Windows Terminal
- Ghostty

**Workaround:** Use in-process mode or switch to supported terminal.

### 2. Token Intensive
**Reality:** 5-10x token consumption vs single session

**Mitigation:** Reserve for tasks where parallel exploration adds real value.

### 3. Experimental Status
**Current state:** Research preview, subject to change

**Implications:**
- API may evolve
- Bugs possible
- Documentation may lag features

### 4. Coordination Complexity
**Challenge:** Requires thoughtful task decomposition

**Skills needed:**
- Breaking work into independent pieces
- Defining clear boundaries
- Specifying interfaces between components

**Think of it as:** Being a tech lead for AI team, not just pair programming.

### 5. No Built-in Guardrails
**Risk:** Autonomous agents can introduce bugs or break functionality

**Mitigation:**
- Human oversight still critical
- Strong CI/CD pipeline
- Regular progress monitoring
- Clear acceptance criteria

---

## Best Practices

### 1. Start Small
**Recommendation:** Begin with read-only tasks before implementing changes.

**Good starting points:**
- Code reviews
- Research tasks
- Documentation analysis
- Architecture exploration

**Why:** Lower risk, easier to evaluate quality, builds familiarity with the system.

### 2. Define Clear Boundaries
**For each teammate, specify:**
- Their specific domain/responsibility
- What they should NOT touch
- Success criteria
- How they should coordinate with others

**Example:**
```
Frontend teammate:
- Own: All React components in /src/components
- Don't touch: Backend API endpoints
- Success: Components render correctly with mock data
- Coordinate: API contract definitions with backend teammate
```

### 3. Provide Rich Context
**Include in your prompt:**
- Project overview and goals
- Relevant architecture documentation
- Coding standards and conventions
- Known constraints or gotchas
- Links to relevant files/docs

**Remember:** Each agent starts fresh. Context you provide is all they have.

### 4. Monitor Progress
**Human acts as "tech lead":**
- Review interim work
- Steer when agents drift
- Resolve conflicts between teammates
- Make judgment calls on tradeoffs

**Use split pane mode** to observe all agents simultaneously and catch issues early.

### 5. Leverage Specialized Roles
**Think in terms of expertise:**
- Security expert
- Performance optimizer
- Test specialist
- UX advocate
- Devil's advocate/critic

**Different perspectives = better outcomes**

### 6. Design Tests for AI
**Key principles:**
- Verbose, explicit error messages
- Clear success/failure criteria
- Progress indicators
- Orientation information

**Example test output:**
```
❌ Test failed: Authentication flow
Expected: User redirected to /dashboard after login
Actual: User sees 404 error
Likely cause: Missing route definition in src/routes/index.js
Next step: Add dashboard route to router configuration
```

### 7. Maintain Project Documentation
**Critical files for agent orientation:**
- `README.md` - Project overview
- `PROGRESS.md` - Current status and completed work
- `ARCHITECTURE.md` - Design decisions and rationale
- `NEXT_STEPS.md` - Prioritized tasks

**Update frequently** as agents can't remember across sessions.

### 8. Use Competing Hypotheses for Debugging
**Pattern:**
```
Create an agent team to debug production crashes:
- Agent 1: Investigate memory leak hypothesis
- Agent 2: Check for race conditions
- Agent 3: Explore external service failures
- Agent 4: Analyze resource exhaustion

Have them debate findings and converge on root cause.
```

**Why it works:** Multiple theories tested in parallel, weaker hypotheses eliminated through evidence and debate.

---

## Philosophy

### Core Insight: Context Expansion Degrades Performance

**Observation:** LLMs perform worse as context windows expand.

**Why:**
- More information = harder to focus on what matters
- Mixing strategic notes with implementation details hurts performance
- General-purpose context dilutes specific task focus

**Human Analogy:**
- Backend engineers don't sit in frontend code reviews
- Don't CC entire company on every Slack thread
- Specialization enables focus

### From Pair Programming to Autonomous Teams

**Evolution:**
1. **Early models:** Tab-completion in IDEs
2. **Function-level:** Complete function from docstring
3. **Claude Code:** Pair programming with human oversight
4. **Agent Teams:** Autonomous complex project implementation

**Shift:** From "human defines task → LLM runs for minutes → human follows up" to "human defines project → agent team implements autonomously over hours/days"

### The Single-Agent Failure Mode

**Common pattern:**
1. Ask Claude to do complex task (refactor auth across 3 services)
2. Gets 60% of the way there
3. Context degrades - details blur together
4. `/clear` and start over
5. Repeat until frustrated

**Agent Teams solution:**
- Each agent maintains focused context
- Specialization prevents blur
- Parallel progress instead of sequential degradation

### Implications for Ambition

**Agent teams enable:**
- More ambitious goals
- Longer-running projects
- Higher complexity tolerance
- Less human micromanagement

**Trade-off:** Requires stronger upfront planning and verification systems.

---

## References

### Official Documentation

1. **Claude Code Agent Teams - Primary Docs**
   https://code.claude.com/docs/en/agent-teams
   Official Anthropic guide on orchestrating teams

### Official Announcements

2. **Boris Cherny (Anthropic) - Threads**
   https://www.threads.com/@boris_cherny/post/DUYr3wwkxHH
   Initial announcement of research preview

### Technical Deep Dives

3. **Anthropic Engineering - Building a C Compiler**
   https://www.anthropic.com/engineering/building-c-compiler
   Case study: 16 agents, $20K, 100,000-line compiler
   **Most detailed technical insights on autonomous teams**

4. **ClaudeFa.st - Agent Teams Guide**
   https://claudefa.st/blog/guide/agents/agent-teams
   Comprehensive technical guide with patterns

5. **Marco Patzelt - Setup Guide**
   https://www.marc0.dev/en/blog/claude-code-agent-teams-multiple-ai-agents-working-in-parallel-setup-guide-1770317684454
   Practical setup walkthrough and use case analysis

6. **Addy Osmani - Claude Code Swarms**
   https://addyosmani.com/blog/claude-code-agent-teams/
   Analysis of multi-agent orchestration patterns

7. **Dára Sobaloju - Medium Tutorial**
   https://medium.com/@darasoba/how-to-set-up-and-use-claude-code-agent-teams-and-actually-get-great-results-9a34f8648f6d
   Step-by-step guide to setup and optimization

### News Coverage

8. **TechCrunch - Opus 4.6 Release**
   https://techcrunch.com/2026/02/05/anthropic-releases-opus-4-6-with-new-agent-teams/
   Product announcement coverage with quotes from Anthropic's Head of Product

9. **Heise Online - Opus 4.6 Coverage**
   https://www.heise.de/en/news/Anthropic-introduces-Claude-Opus-4-6-with-Agent-Teams-11167248.html
   International tech news coverage

### Community Discussion

10. **Hacker News - Agent Teams Discussion**
    https://news.ycombinator.com/item?id=46902368
    Community technical discussion and insights

### Related Projects

11. **Claude Code Orchestrator**
    https://github.com/mohsen1/claude-code-orchestrator
    Third-party orchestration tool (pre-official feature)

12. **Compound Engineering Plugin**
    https://github.com/EveryInc/compound-engineering-plugin
    Every's structured workflow plugin for agent teams

### Recommended Reading Order

**For Quick Start:**
1. Official docs (#1)
2. Marco Patzelt setup guide (#5)
3. Addy Osmani analysis (#6)

**For Deep Understanding:**
1. Anthropic C compiler case study (#3)
2. ClaudeFa.st technical guide (#4)
3. Medium tutorial (#7)

**For Product Context:**
1. TechCrunch announcement (#8)
2. Boris Cherny announcement (#2)

---

## Quick Reference Card

### Enable Agent Teams
```bash
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

### Best Use Cases
- Multi-perspective code reviews (3-5 specialized reviewers)
- Adversarial debugging (competing hypotheses)
- Cross-layer features (frontend/backend/database)
- Research & exploration (diverse viewpoints)

### Avoid For
- Sequential tasks
- Same-file edits
- Simple/routine work
- Anything without parallelization value

### Display Modes
- **In-process:** All teammates in one terminal (Shift+Up/Down to switch)
- **Split panes:** Each teammate in own pane (requires tmux/iTerm2)
- **Auto:** Detects environment automatically

### Token Economics
- Each teammate = full context window
- 5-person team ≈ 5x tokens
- Only justified for high-value parallel exploration

### Key Principle
**LLMs perform worse as context expands.**
Specialization enables focus = better results.

---

**Last updated:** February 2026
**Feature Status:** Experimental/Research Preview
**Released With:** Claude Opus 4.6
