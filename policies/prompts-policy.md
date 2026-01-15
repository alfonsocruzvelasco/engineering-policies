# Prompt Policies (Refactored Reference Manual)

**Purpose:** This is your operational playbook (the "what" and "how").  
For theoretical foundation and deep research, see the original extensive version.

---

## Quick Navigation

**For immediate use:**
1. [The 80/20 Rule](#the-8020-rule-hallucinations-are-inevitable)
2. [5 Production Patterns for Claude](#5-production-patterns-for-claude-roboticsml)
3. [How to Structure Requests](#how-to-structure-requests)
4. [Verification Checklist](#verification-checklist)
5. [Common Mistakes](#common-mistakes-and-how-to-fix-them)

**For reference:**
- [Theoretical Foundation](#theoretical-foundation)
- [Framework Glossary](#framework-glossary)
- [Tools & Platforms](#tools-and-platforms)
- [Resources](#resources)

---

## The 80/20 Rule: Hallucinations Are Inevitable

**Fact**: Fano's Inequality proves mathematically that hallucinations become inevitable when prompts are ambiguous (high H(X|Y)).

**Your job**: Reduce hallucination risk through systematic techniques:

1. **Specificity** — Reduce ambiguity H(X|Y) by being explicit about constraints
2. **Constraint Awareness** — Name failure modes upfront instead of trusting generic solutions
3. **Built-In Verification** — Ask me to show my work instead of trusting conclusions

These three levers work together. Miss any one and you'll get hallucinations.

---

## 5 Production Patterns for Claude (Robotics/ML)

These patterns force specificity, constraint awareness, and explicit failure mode naming. Use them as templates for all Claude interactions.

### Pattern 1: Constraint-First Architecture Questions

**Problem:** Vague questions → generic answers → hallucinated tradeoffs

**Template:**
```
I'm building [system]. Constraints: [specific limits]. 
Current bottleneck: [what's slow/broken]. 

Should I use [option A] or [option B]? 
What are the failure modes of each?
```

**Real example:**
```
I'm building a real-time object detection pipeline for a mobile manipulator. 
Constraints: <50ms latency, edge deployment (Jetson Orin), RGB-D input. 
Current bottleneck: feature extraction. 

Should I use TensorRT quantization, knowledge distillation, or architectural pruning? 
What are the failure modes of each?
```

**Verification checkpoint:** Ask me to name one failure mode of my recommendation that you've seen in production. If I can't, I'm hallucinating.

---

### Pattern 2: Implementation-Specific Code Review

**Problem:** "Review my code" → surface-level feedback → misses actual risks

**Template:**
```
Review this [code]. Focus on: 
(1) [Specific concern A]? 
(2) [Specific concern B]? 
(3) What happens when [edge case]?
```

**Real example:**
```
Review this perception module. Focus on: 
(1) Does the coordinate transform between camera and robot frame handle edge cases (occlusion, out-of-FOV)? 
(2) Are there race conditions in the callback chain? 
(3) What happens when inference fails?
```

**Verification checkpoint:** For each issue I flag, ask me to show the exact line where it could fail. Vague answers = hallucination.

---

### Pattern 3: Assumption-Explicit Debugging

**Problem:** "My detector is slow" → guessing at causes → fixes the wrong thing

**Template:**
```
[System] shows [symptom]. I suspect [hypothesis].

Before we discuss solutions:
(1) Confirm I should validate [hypothesis] first—what's the minimum data/experiment?
(2) What are the three most common failure modes you've seen in this exact scenario?
```

**Real example:**
```
My YOLOv8 detector trained on synthetic data shows 92% mAP on test set but 64% in production. 
I suspect domain gap. 

Before we discuss solutions:
(1) Confirm I should validate domain gap first—what's the minimum data I need to isolate domain gap vs. hardware quantization effects?
(2) What are the three most common failure modes you've seen in this exact scenario?
```

**Verification checkpoint:** Ask me to cite one peer-reviewed paper or reference for each failure mode. If I can't, I'm inventing.

---

### Pattern 4: Risk-Aware Trade-off Analysis

**Problem:** Comparing options without understanding downstream costs of failure

**Template:**
```
Comparing [option A] vs [option B]:
- A: [metric 1], [metric 2], [known failure]
- B: [metric 1], [metric 2], [known failure]

My use case: [what you actually do with the system]

What are the downstream costs of each failure mode? Help me quantify the risk tradeoff.
```

**Real example:**
```
Comparing two gripper detectors:
- Model A: 95% accuracy, 200ms latency, unknown failure modes on reflective surfaces
- Model B: 91% accuracy, 50ms latency, documented failure on thin objects

My use case: Robot operates on unstructured shelves with both reflective packaging and thin items.

What are the downstream costs of each failure mode? Help me quantify the risk tradeoff.
```

**Verification checkpoint:** Ask me to name a failure mode you didn't mention and explain why. If I can't, my analysis is incomplete.

---

### Pattern 5: Verification-Built-In Requests

**Problem:** You trust my answer without checking → hallucination becomes your problem

**Template:**
```
[Question]?

Assume I don't trust your answer. Give me:
(1) The recommendation
(2) One edge case where it fails
(3) How you'd test for that failure
(4) A reference I can check independently
```

**Real example:**
```
What's the best way to handle coordinate transformations in ROS2?

Assume I don't trust your answer. Give me:
(1) The recommendation
(2) One edge case where it fails
(3) How you'd test for that failure
(4) A reference I can check independently
```

**Verification checkpoint:** Independently verify the reference. If it doesn't support my claim, that's a hallucination signal.

---

## How to Structure Requests

### The Four-Stage Workflow (Your Standard)

**Stage 1: Vibe**
- What's the emotional/business context?
- What matters most (speed, reliability, cost)?
- Example: "We need 50ms latency or the robot can't react in time."

**Stage 2: Specify/Plan**
- Use COSTAR or CRISPE framework
- Define constraints explicitly
- Name what success looks like
- Example: "Constraints: <50ms, Jetson Orin, RGB-D input. Success = 90% mAP at <50ms."

**Stage 3: Task/Verify**
- Pick one of the 5 patterns above
- Ask for failure modes upfront
- Request verification checkpoint
- Example: "Should I use TensorRT or distillation? What fails with each?"

**Stage 4: Refactor/Own**
- Take my answer
- Test it against failure modes
- Iterate based on what breaks
- Example: "Your TensorRT approach failed on reflective surfaces. How do we fix that?"

### COSTAR Framework (For Clarity)

- **C**ontext: What's the situation?
- **O**bjective: What are you optimizing for?
- **S**tyle: What tone/format do you want?
- **T**ask: What's the specific ask?
- **A**ction: What should I do?
- **R**esult: What output format?

### CRISPE Framework (Alternative)

- **C**apacity: What role should I play?
- **R**ole: What's my specific function?
- **I**nsight: What context do I need?
- **S**tatement: What's the core request?
- **P**ersonality: What tone should I use?
- **E**xperiment: What should we test?

---

## Verification Checklist

Before trusting any recommendation from me, run through this:

- [ ] **Specificity**: Did I reference specific failure modes, not generic warnings?
- [ ] **Domain Context**: Did I reference robotics/ML production systems (not general AI)?
- [ ] **Failure Modes Named**: Did I name at least 2-3 concrete failure modes?
- [ ] **References**: Can I cite a paper, documentation, or production example?
- [ ] **Edge Cases**: Did I discuss what happens when inputs are unusual (occlusion, latency spikes, etc.)?
- [ ] **Downstream Impact**: Did I explain what breaks in your actual system if this fails?
- [ ] **Alternatives**: Did I mention tradeoffs vs. other approaches?

If you can't check 5+ boxes, ask me to do the work.

---

## Common Mistakes (And How to Fix Them)

### Mistake 1: Vague Prompts
**Bad:** "How should I structure my perception pipeline?"  
**Good:** "I'm building [specific system] with [specific constraints]. Current bottleneck is [X]. Should I use [A] or [B]? What are the failure modes?"

**Fix**: Use Pattern 1 (Constraint-First) template.

---

### Mistake 2: Trust Without Verification
**Bad:** "Claude says use quantization. I'll deploy it."  
**Good:** "Claude says quantization. Let me test it on reflective surfaces (known failure mode) first."

**Fix**: Always ask for failure modes (Pattern 3). Test them before shipping.

---

### Mistake 3: Missing Constraint Context
**Bad:** "Should I use model A or B?"  
**Good:** "Model A [details], Model B [details]. My use case [specific details]. What fails with each?"

**Fix**: Use Pattern 4 (Risk-Aware) to force quantification.

---

### Mistake 4: Code Review Without Specificity
**Bad:** "Review my code."  
**Good:** "Review this [code]. Focus on: coordinate transforms under occlusion, race conditions in callbacks, behavior on inference failure."

**Fix**: Use Pattern 2 template. Name what you want checked.

---

### Mistake 5: Assuming I Know Your Production Setup
**Bad:** "Why is my detector slow?"  
**Good:** "My detector shows 92% mAP in testing but 64% in production (Jetson Orin, RGB-D, real lighting). I suspect domain gap. Confirm I should test that first—what's the minimum experiment?"

**Fix**: Use Pattern 3 (Assumption-Explicit). Force me to ask clarifying questions.

---

## Theoretical Foundation

### Fano's Inequality (Why Hallucinations Happen)

**Mathematical fact**: Hallucination becomes inevitable when H(X|Y) > 0 (ambiguity in your prompt).

**Translation**: If your prompt is ambiguous, no model can reliably generate correct output.

**Three levers to reduce hallucinations**:
1. **Reduce output space (M)** — Use structured formats (XML, JSON) instead of free text
2. **Reduce ambiguity (H(X|Y))** — Be explicit about constraints, failure modes, edge cases
3. **Design for uncertainty floor** — Accept that some hallucination is unavoidable; build verification systems

### Why Each Pattern Works

- **Constraint-First**: Forces you to reduce M and H(X|Y) by being specific
- **Implementation-Specific**: Prevents surface-level answers by naming what you actually need checked
- **Assumption-Explicit**: Forces me to ask clarifying questions instead of hallucinating answers
- **Risk-Aware**: Quantifies consequences of failures, making H(X|Y) concrete
- **Verification-Built-In**: Shifts burden of proof from you (trusting me) to me (showing my work)

### Core Techniques That Work

- **Chain of Verification (CoV)**: Model verifies its own output step-by-step
- **Step-Back Prompting**: "What general principle applies here?" before solving specifics
- **Cognitive Verifier**: Iterative clarifying questions to reduce ambiguity
- **RAG-Sequence**: Force model to ingest all context before generating (not RAG-Token)
- **Structured Output**: XML/JSON forces clearer thinking and shrinks output space

### Model-Specific Notes

- **Claude**: Responds best to XML structure, context-aware, good at admitting uncertainty
- **GPT-4**: Strong on agentic tasks, function calling, tool use
- **Both**: Require explicit examples and constraints. Neither does well with vague prompts.

---

## Framework Glossary

| Term | Meaning | When to Use |
|------|---------|------------|
| **COSTAR** | Context, Objective, Style, Task, Action, Result | General-purpose structured prompts |
| **CRISPE** | Capacity, Role, Insight, Statement, Personality, Experiment | When role-play or persona matters |
| **CoV** | Chain of Verification | When you need step-by-step reasoning verification |
| **Step-Back** | Ask principle before details | When you need foundational understanding first |
| **RAG-Sequence** | Retrieve documents once, generate full output | Factual accuracy critical (gold standard) |
| **Cognitive Verifier** | Iterative clarifying questions | When ambiguity is high |
| **H(X\|Y)** | Conditional entropy (ambiguity measure) | Theoretical analysis of why prompts fail |
| **M** | Output space size | Theoretical measure of complexity |

---

## Tools and Platforms

### Tier 1 (Minimum Viable Production)
- **Anthropic Console**: Free, version control, model testing
- **Helicone**: Free tier, logging + monitoring
- **Cost**: $0/month

### Tier 2 (Balanced Production)
- Add: **Guardrails AI** for output validation
- **Cost**: ~$0.005 per request (validation overhead)

### Tier 3 (Enterprise/Strict)
- Add: **PromptLayer** for full version control
- Add: **TruLens** for evaluation monitoring
- **Cost**: ~$0.02 per request (full monitoring)

### Version Control (Non-Negotiable)
- Use PromptLayer or Langfuse for production
- Tag every prompt with version + timestamp
- A/B test new versions before rollout

### Security
- **Rebuff**: Prompt injection detection
- **Guardrails AI**: Output validation + safety

### Evaluation
- **Agenta**: A/B test prompts quickly
- **TruLens**: Production monitoring + trace logging
- **Without metrics**: Optimization is guesswork

---

## Resources

### Official Documentation
- **Anthropic Prompt Engineering**: https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/overview
- **Claude 4 Best Practices**: https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices
- **Context Engineering Guide**: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents

### Academic Papers (Foundational)
- **White et al.** - A Prompt Pattern Catalog (structural patterns for reliable prompting)
- **Lewis et al.** - RAG: Retrieval-Augmented Generation (RAG-Sequence vs RAG-Token distinction)
- **Frontiers in AI Survey (2025)** - Hallucination attribution and metrics (PS, MV)

### Guides
- **Lakera 2025 Prompt Engineering Guide**: Comprehensive techniques, defensive prompting, security
- **O'Reilly LLM Prompt Engineering**: Enterprise patterns and best practices
- **OpenAI GPT-4 Prompting Guide**: Agent patterns, function calling, tool use

### For Your Robotics/ML Context
- **Anthropic Context Engineering**: Managing context as finite resource
- **LangChain Retrieval Docs**: Building RAG systems
- **PromptHub**: Hallucination reduction methods for production systems

---

## Your Implementation Checklist

### Before First Deployment
- [ ] Pick COSTAR or CRISPE framework (standardize on one)
- [ ] Test all 5 patterns above with your actual queries
- [ ] Identify which pattern fits your most common requests
- [ ] Set up Anthropic Console + Helicone (free)
- [ ] Document your most reliable prompts

### Before Production
- [ ] Build evaluation dataset (20+ test cases)
- [ ] Measure baseline hallucination rate
- [ ] Implement verification checkpoints (Pattern 5)
- [ ] Set up PromptLayer or Langfuse for version control
- [ ] Define when to use which tier (fast/balanced/strict)

### Ongoing
- [ ] Log every significant query + response
- [ ] Track hallucination incidents
- [ ] A/B test new patterns against baseline
- [ ] Review and iterate weekly

---

## The Meta-Insight

**You already know this stuff.** Your four-stage workflow (Vibe→Specify→Verify→Own) mirrors the best practices in the literature. The five patterns here are just operationalizing what you already do intuitively.

Your job now: **Enforce it systematically.** Make every interaction follow the patterns. Refuse vague prompts. Always ask for failure modes. Always verify before trusting.

That's the difference between getting lucky and getting reliable.

---

*Last Updated: January 15, 2026*  
*Integrated patterns from Claude Code Skills guide + production robotics/ML context*
