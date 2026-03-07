# AI Retrieval Policy

**Purpose:** Define retrieval architecture standards, knowledge base governance, and context injection safety for AI-assisted development and production systems.

**Scope:** Applies to all retrieval-augmented generation (RAG) systems, vector databases, and context retrieval mechanisms used in AI workflows.

**Last updated:** 2026-03-07

---

## 1) Retrieval Architecture Selection

For technical background and trade-offs between RAG, RERAG, and REFRAG,
see:

→ [references/rag-vs-rerag-technical-reference.md](references/rag-vs-rerag-technical-reference.md)

**Policy position:**

| Architecture | Use when | Default |
|---|---|---|
| **Simple RAG** | Standard development workflows, code search, documentation lookup | Yes |
| **RERAG** | High-precision domains where retrieval errors have downstream cost (medical, legal, security policy) | No |
| **REFRAG** | Production latency-critical systems where retrieval + generation must fit within SLA | No |

Deviating from Simple RAG requires documented justification in the project's architecture decision record.

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

**When to use MCP (deterministic symbol resolution):**

- Querying structured data (databases, APIs, registries)
- Accessing live system state (metrics, logs, configuration)
- Operations requiring exact results (not "most similar")

**When to use RAG (probabilistic retrieval):**

- Searching unstructured documentation or specifications
- Finding similar code patterns or examples
- Exploring research literature or decision records

**Do not mix these.** If a query needs an exact answer from a structured source, use MCP. If it needs a relevant-but-approximate answer from unstructured text, use RAG. Routing the wrong query type to the wrong system produces either false precision (RAG on structured data) or unnecessary noise (MCP on unstructured text).

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

- Architecture guidance: `references/rag-vs-rerag-technical-reference.md`
- MCP configuration: `templates/mcp-template.md`
- Prompt injection defense: `security-policy.md §19`
- Context window management: `ai-workflow-policy.md` (Tiered Context Architecture)
- AGENTS.md RAG section: `templates/agents-md-template.md`
