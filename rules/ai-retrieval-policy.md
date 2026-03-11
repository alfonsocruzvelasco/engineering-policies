# AI Retrieval Policy

**Purpose:** Define retrieval architecture standards, knowledge base governance, and context injection safety for AI-assisted development and production systems.

**Scope:** Applies to all retrieval-augmented generation (RAG) systems, vector databases, and context retrieval mechanisms used in AI workflows.

**Last updated:** 2026-03-11

---

## 1) Retrieval Architecture Selection

**Foundational reference:** Lewis et al., "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks," NeurIPS 2020 (see `references/retrieval-augmented-generation-for-knowledge-intensive-nlp-tasks.pdf`). This paper established the RAG framework: a pre-trained retriever (DPR, bi-encoder) provides latent documents, and a pre-trained generator (BART) conditions on those documents plus the input to produce output. Both components are fine-tuned end-to-end.

For trade-offs between RAG, RERAG, and REFRAG variants, see:

→ [references/rag-vs-rerag-technical-reference.md](references/rag-vs-rerag-technical-reference.md)

**Policy position:**

| Architecture | Use when | Default |
|---|---|---|
| **Simple RAG** | Standard development workflows, code search, documentation lookup | Yes |
| **RERAG** | High-precision domains where retrieval errors have downstream cost (medical, legal, security policy) | No |
| **REFRAG** | Production latency-critical systems where retrieval + generation must fit within SLA | No |

Deviating from Simple RAG requires documented justification in the project's architecture decision record.

### RAG Formulation Selection

Lewis et al. define two marginalization strategies. The choice affects how the generator uses retrieved documents:

| Formulation | Mechanism | Use when |
|---|---|---|
| **RAG-Sequence** | Same retrieved document conditions the entire generated sequence | Answer is likely in a single source document; coherence matters |
| **RAG-Token** | Different documents can condition different output tokens | Answer combines facts from multiple sources; diversity matters |

**Default:** RAG-Sequence for most development workflows (simpler, more coherent). Use RAG-Token when the task requires synthesizing across multiple documents (e.g., multi-source summarization, comparative analysis).

---

## 2) Knowledge Base Ingestion

**What goes into vector stores:**

- Source code and documentation from owned repositories
- Approved reference materials (papers, specs, standards)
- Versioned policy documents (this repo)
- Experiment logs and decision records

**What MUST NOT go into vector stores:**

- Secrets, credentials, API keys, or tokens
- Unredacted PII or sensitive personal data
- Untrusted third-party content without provenance verification
- Raw LLM outputs not validated by a human (to prevent retrieval of hallucinated content)

**Versioning:** Every knowledge base must be reproducible. Track: source documents, chunking strategy, embedding model version, ingestion timestamp. If the embedding model changes, the entire index must be rebuilt.

**Index hot-swapping:** Lewis et al. demonstrated that a RAG model's knowledge can be updated by replacing the document index without retraining the model. A model trained with a 2016 index answered 70% correctly for 2016 facts; swapping to a 2018 index shifted accuracy to 2018 facts. This means knowledge base updates are cheap — you rebuild the index, not retrain the model. Use this property: when source documents change, rebuild the index and redeploy; do not retrain the retriever or generator unless retrieval quality degrades.

---

## 3) Retrieval Result Sandboxing

Retrieved context is untrusted input until validated. Before injection into an LLM prompt:

1. **Source attribution** — every retrieved chunk must carry its source document path and version
2. **Staleness check** — retrieved content older than the project's review cadence (default: 90 days) must be flagged
3. **Conflict detection** — if retrieved chunks contradict each other, surface the conflict to the user rather than silently picking one
4. **Token budget** — retrieved context must not exceed 40% of the available context window; reserve the remainder for instructions, reasoning, and output

**Prompt injection via retrieval:** A poisoned knowledge base is an indirect prompt injection vector. If an attacker can write to the knowledge base, they can inject instructions that the LLM will execute. Mitigations:

- Write access to knowledge bases requires the same access control as code repositories
- Ingested documents must pass the same review process as committed code
- Monitor for anomalous content in retrieval results (unexpected instructions, role overrides, system prompt fragments)

See `security-policy.md §19` (Prompt Injection Defense) for the broader threat model.

---

## 4) MCP vs RAG Decision

RAG combines two memory types (Lewis et al.): **parametric memory** (knowledge stored in model weights) and **non-parametric memory** (knowledge stored in a retrievable document index). MCP bypasses both by querying structured data directly.

**When to use MCP (deterministic symbol resolution):**

- Querying structured data (databases, APIs, registries)
- Accessing live system state (metrics, logs, configuration)
- Operations requiring exact results (not "most similar")

**When to use RAG (probabilistic retrieval over non-parametric memory):**

- Searching unstructured documentation or specifications
- Finding similar code patterns or examples
- Exploring research literature or decision records
- Tasks where the model's parametric knowledge is insufficient, stale, or unverifiable

**Do not mix these.** If a query needs an exact answer from a structured source, use MCP. If it needs a relevant-but-approximate answer from unstructured text, use RAG. Routing the wrong query type to the wrong system produces either false precision (RAG on structured data) or unnecessary noise (MCP on unstructured text).

**Why RAG over parametric-only models:** Parametric-only models cannot easily update their knowledge, cannot provide provenance for decisions, and hallucinate more on knowledge-intensive tasks. RAG reduces hallucination by grounding generation in retrieved evidence (Lewis et al. showed RAG generates more factual, specific, and diverse text than parametric-only BART). The trade-off is retrieval latency and index maintenance cost.

See `templates/mcp-template.md` for MCP configuration standards.

---

## 5) Evaluation and Monitoring

**Retrieval quality metrics (track periodically):**

| Metric | What it measures | Target |
|---|---|---|
| Recall@k | Fraction of relevant documents in top-k results | >0.8 for k=5 |
| Precision@k | Fraction of top-k results that are relevant | >0.6 for k=5 |
| Staleness rate | Percentage of retrieved documents past review cadence | <10% |
| Conflict rate | Percentage of queries returning contradictory chunks | Monitor, no hard target |

**Failure signal:** If the LLM frequently ignores retrieved context or produces answers inconsistent with it, the retrieval system is likely returning low-quality or irrelevant results. Treat this as a retrieval infrastructure bug, not a model problem.

---

## 6) Cross-References

- Foundational paper: `references/retrieval-augmented-generation-for-knowledge-intensive-nlp-tasks.pdf` (Lewis et al., NeurIPS 2020)
- Architecture variants: `references/rag-vs-rerag-technical-reference.md`
- Engineering patterns: `references/rag-engineering-notes.md`, `references/rag-production-notes.md`
- MCP configuration: `templates/mcp-template.md`
- Prompt injection defense: `security-policy.md §19`
- Context window management: `ai-workflow-policy.md` (Tiered Context Architecture)
- AGENTS.md RAG section: `templates/agents-md-template.md`
