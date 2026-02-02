# Prompt Engineering for Production Systems

**Comprehensive Theory + Control + Anti-Hallucination + Evaluation**

**Purpose:** A production-grade reference for designing, controlling, verifying, and *measuring* LLM prompt performance in engineering environments.
**Scope:** ML/AI systems, coding workflows, RAG pipelines, deterministic and safety-critical use.

---

## 1. Temperature Theory

### 1.1 Mathematical Meaning

Language models produce logits **z** over the vocabulary. Temperature rescales them before softmax:

$$
p_i(T) = \frac{\exp(z_i/T)}{\sum_j \exp(z_j/T)}
$$

| Temperature     | Effect                              |
| --------------- | ----------------------------------- |
| **Low (<0.3)**  | Peaked distribution → deterministic |
| **High (>0.7)** | Flatter distribution → diverse      |
| **T→0**         | Greedy decoding                     |
| **T→∞**         | Uniform randomness                  |

**Engineering model:** Temperature controls **entropy**, not truthfulness.

---

### 1.2 What Temperature Does NOT Do

Temperature **cannot**:

- Add missing facts
- Prevent hallucinations alone
- Guarantee correctness

Low temperature can produce **consistent but wrong** answers.

---

### 1.3 Industry Temperature Ranges

| Task                  | Temperature |
| --------------------- | ----------- |
| Bug fixing / analysis | **0.0–0.2** |
| Production code       | **0.2–0.3** |
| Design exploration    | **0.6–0.9** |
| Creative writing      | **1.0+**    |

---

## 2. The Accuracy Stack

Accuracy is determined primarily by **information and verification**, not sampling.

### Ranked by Impact

1. **Grounding / Context**
   Provide code, logs, documents, constraints.

2. **Tool Verification**
   Execution, tests, retrieval, web search.

3. **Model Choice**
   Code-specialized vs reasoning models.

4. **Prompt Constraints**
   Structured outputs, “no guessing”, schema.

5. **Decoding Parameters**
   Temperature/top_p influence variance only.

> **Key Principle:** If truth is not in context, the model guesses.

---

## 3. Hallucination Theory

Hallucinations arise when **ambiguity is high** and **output space is large**.

### Three Reduction Levers

| Lever                  | How                     |
| ---------------------- | ----------------------- |
| Reduce output space    | Structured outputs      |
| Reduce ambiguity       | Clear prompts + context |
| Design for uncertainty | Verification loops      |

---

### 3.1 Evidence-Based Mitigation

1. **RAG (Retrieval-Augmented Generation)**
2. **Verification loops (CoVe style)**
3. **Structured outputs (JSON/XML)**
4. **Citation requirement**
5. **Model allowed to say “UNKNOWN”**

---

## 4. Tokenization & Context

- Different models tokenize differently → affects cost & limits
- Use summarization **only after grounding is preserved**
- Never sacrifice critical evidence to save tokens

---

## 5. Prompt Engineering Patterns

### Design → Decide → Implement → Verify

**Exploration (High T)**
Generate alternatives with pros/cons.

**Decision (Low T)**
Pick one solution.

**Implementation (Low T)**
Minimal diff + tests.

**Verification (Lowest T)**
Audit assumptions, risks, rollback.

---

## 6. Structured Output Patterns

### JSON Example

```json
{
  "assumptions": [],
  "solution": "",
  "tests": [],
  "risks": []
}
````

Benefits:

* Smaller output space
* Programmatic validation
* Reduced hallucination surface

---

## 7. Deterministic Engineering Mode (Prompt Trick)

When temperature cannot be controlled:

```
You are in deterministic engineering mode.
Rules:
- No guessing
- If uncertain, say UNKNOWN
- Output only: diagnosis, minimal fix, tests, risks
```

This shrinks the model’s search space similar to lowering temperature.

---

## 8. Anti-Hallucination Protocol

### Step A — Ground

Provide artifacts and constraints.

### Step B — Structure

Require assumptions, uncertainties, tests.

### Step C — Tool Verify

Use execution, citations, or retrieval.

### Step D — Audit

Label claims: Certain / Likely / Speculative. Remove speculative.

---

## 9. Prompt Frameworks

| Framework                  | Best Use                         |
| -------------------------- | -------------------------------- |
| **RTF** (Role-Task-Format) | Fast engineering tasks           |
| **COSTAR**                 | Complex stakeholder tasks        |
| **CRISPE**                 | Tone/personality-sensitive tasks |

---

## 10. Model Selection Principles

| Task          | Model Type             |
| ------------- | ---------------------- |
| Code          | Code-specialized       |
| System design | Strong reasoning model |
| Long docs     | High context models    |

Model quality > temperature tuning.

---

# 11. NEW — Prompt Evaluation & Metrics

This is the **missing layer** in most prompt engineering:
You must **measure** prompt quality like ML model performance.

**See also:** [Fairest Agent Comparison Metric](fairest-agent-comparison.md) for comprehensive methodology on comparing prompting strategies (COSTAR, CRISPE, RTF, spec-driven) using Pareto frontier analysis and utility scores.

---

## 11.1 Offline Evaluation (Before Deployment)

Create a **Prompt Test Set**.

| Metric             | Measures                    | Implementation      |
| ------------------ | --------------------------- | ------------------- |
| Task Success Rate  | % outputs meeting spec      | Unit tests          |
| Groundedness       | Claims supported by sources | Citation validation |
| Hallucination Rate | Unsupported claims          | Human or LLM audit  |
| Format Compliance  | JSON/XML validity           | Schema validator    |
| Determinism Score  | Output stability            | Repeat runs         |

**Determinism Test:**
Run prompt 10× at low temperature. Measure structural + factual drift.

---

## 11.2 Online Evaluation (After Deployment)

Production requires monitoring.

**Pipeline:**

```
Prompt → LLM → Output
              ↓
        Automated Checks
      (tests, schema, tools)
              ↓
        Pass / Fail Logging
              ↓
      Evaluation Dashboard
```

Track:

* Failure rate over time
* Drift in output style or length
* Regression of old failures

---

## 11.3 Golden Prompt Sets

Maintain a **versioned benchmark suite**:

* Fixed prompts
* Known good outputs
* Regression tests after prompt edits

Prompt engineering becomes **empirical, not intuitive**.

---

## 11.4 LLM-as-Judge (Use Carefully)

Use strong models to score:

* Helpfulness
* Correctness
* Completeness

⚠ Judge models hallucinate too. Use for **triage**, not final authority.

---

## 11.5 Failure Taxonomy

| Failure Type       | Cause              | Fix                      |
| ------------------ | ------------------ | ------------------------ |
| Missing Context    | Model guessed      | Add grounding            |
| Overgeneralization | Rare edge case     | Add counterexamples      |
| Format Drift       | JSON broken        | Stronger schema          |
| Tool Misuse        | Wrong API          | Tool validation          |
| Instruction Drift  | Constraint ignored | Shorter, stricter prompt |

---

# 12. Production Prompt Lifecycle

1. Design prompt
2. Test offline (metrics)
3. Deploy with monitoring
4. Log failures
5. Update prompt
6. Re-run evaluation suite

This mirrors **ML model iteration**.

---

# 13. Core Laws of Production Prompting

1. **Temperature controls variance, not truth**
2. **Grounding beats clever wording**
3. **Verification beats confidence**
4. **Workflows beat parameters**
5. **Evaluation beats intuition**
