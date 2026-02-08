## **Claude Code Agent Teams - Feature Overview**

### **Core Concept**
Agent Teams enables multiple Claude Code instances to work together in parallel on shared tasks. One session acts as **team lead**, coordinating work, while **teammates** operate independently in their own context windows and communicate directly with each other.

### **Key Differentiators from Subagents**

**Subagents:**
- Run within a single session
- Can only report back to main agent
- No inter-agent communication
- Sequential workflow

**Agent Teams:**
- Each teammate has its own context window
- Direct inter-teammate messaging
- Shared task list
- Parallel execution
- Can interact with individual teammates without going through the lead

---

## **Setup & Activation**

**Enable the feature:**
```bash
# Environment variable
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# Or in settings.json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**Status:** Experimental/Research Preview (disabled by default)

---

## **Best Use Cases**

### **High-Value Scenarios:**

1. **Multi-perspective Code Reviews**
   - Security reviewer
   - Performance reviewer
   - Test coverage reviewer
   - Each reviews independently, findings synthesized by lead

2. **Adversarial Debugging**
   - Multiple agents explore competing hypotheses
   - Direct debate between teammates
   - Consensus emerges through argumentation vs. single guess

3. **Cross-layer Feature Development**
   - Frontend teammate
   - Backend teammate
   - Database teammate
   - Each owns their domain without context-switching

4. **Research & Exploration**
   - Parallel investigation of different approaches
   - UX perspective
   - Technical architecture
   - Devil's advocate/critical analysis

### **Poor Use Cases (stick to single session or subagents):**
- Sequential tasks
- Same-file edits
- Routine/simple tasks
- Anything where parallel exploration doesn't add value

---

## **Display Modes**

**1. In-Process (default in non-tmux terminals)**
- All teammates in single terminal
- Switch views: Shift+Up / Shift+Down
- Works everywhere but can feel cramped

**2. Split Panes**
- Each teammate gets own tmux/iTerm2 pane
- See all agents working simultaneously
- Best for 3+ teammates
- Catch issues in real-time

**3. Auto (default)**
- Detects environment
- Uses split panes if in tmux session
- Falls back to in-process otherwise

**Requirements for Split Panes:**
- tmux or iTerm2
- **NOT supported:** VS Code integrated terminal, Windows Terminal, Ghostty

---

## **Usage Pattern**

**Natural Language Prompting:**
```
"Create an agent team to review PR #142. Spawn three reviewers:
- One focused on security implications
- One checking performance impact
- One validating test coverage
Have them each review and report findings."
```

**What Claude does:**
1. Creates team with shared task list
2. Spawns teammates for each role
3. Coordinates work
4. Teammates communicate directly
5. Synthesizes findings
6. Cleans up team when finished

**Claude can also autonomously propose teams** if it determines a task would benefit from multi-agent collaboration.

---

## **Token Economics**

**Cost:** ~5x tokens vs single session
- Each teammate has full context window
- Token usage scales linearly with team size
- Only justified for tasks where parallel exploration adds real value

**Example:** 5-person team = 5x token consumption

---

## **Technical Architecture Insights**

From the Rust C compiler case study (16 agents, $20K API costs):

**Parallel Implementation Pattern:**
- Bare git repo created
- Each agent gets Docker container with repo mounted to `/upstream`
- Agent clones to `/workspace`
- When done, pushes to upstream
- Simple lock file synchronization to prevent task collision

**Key Learnings:**
- Fresh container = no context, agents spend time orienting
- Solution: Extensive READMEs and progress files
- Need CI pipeline to prevent breaking existing code
- Test harness must be designed for AI, not humans

---

## **Coordination Features**

1. **Shared Task List** - Central coordination
2. **Inter-Agent Messaging** - Direct communication between teammates
3. **Lead Synthesis** - Team lead aggregates results
4. **Independent Execution** - Each agent works autonomously

---

## **Integration & Ecosystem**

**Compound Engineering Plugin** (from Every):
- Adds specialized review agents
- Plan → Work → Review → Compound cycle
- Philosophy: 80% planning/review, 20% execution
- Works with OpenCode and Codex (experimental)
- Key workflows:
  - `/workflows:plan` - detailed implementation planning
  - `/workflows:review` - multi-agent code review
  - `/workflows:compound` - document learnings for future agents

---

## **Current Limitations**

1. **Platform restrictions** - Split pane mode requires specific terminals
2. **Token intensive** - Not cost-effective for routine tasks
3. **Experimental status** - Feature still in research preview
4. **Coordination complexity** - Requires thoughtful task decomposition
5. **No built-in guardrails yet** - Human oversight still critical

---

## **Released With Claude Opus 4.6** (February 2026)
- 1M token context window (matching Sonnet 4/4.5)
- Improved coding capabilities
- Also includes PowerPoint integration (direct side panel)

---

## **Best Practices**

1. **Start small** - Begin with read-only tasks (reviews, research)
2. **Clear boundaries** - Define distinct roles/responsibilities
3. **Rich context** - Provide comprehensive task specifications
4. **Monitor progress** - Human still acts as "tech lead"
5. **Specialized roles** - Leverage different perspectives/expertise
6. **Test for AI** - Design verification assuming no human oversight

---

## **Philosophy**

**Core insight:** LLMs perform worse as context expands. Specialization enables focus. Similar to human teams - don't have backend engineers in frontend reviews, don't CC entire company on every thread.

**Agent teams enable** moving from pair programming to autonomous, complex project implementation with proper scaffolding and oversight.
