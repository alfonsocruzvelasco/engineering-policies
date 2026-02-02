## RAG Engineering Notes — Production Mental Model

### Core Principle
**RAG = Search Engine + Reasoning Layer**
- Vector DB handles semantic retrieval
- LLM handles contextual reasoning over evidence
- The model is NOT the knowledge store

---

### System Architecture

#### OFFLINE: Indexing Pipeline
```
Raw Data → Chunk → Embed → Store
```

**1. Chunking (This is where most systems fail)**
- Size: 200-500 tokens
- Overlap: 10-20% (preserves context continuity)
- Strategy: One coherent idea per chunk
- Preserve structure: Don't split tables/code blocks

**2. Embedding**
- Dense vectors where distance = semantic similarity
- Metric: Cosine similarity (standard)

**3. Vector DB**
- Production options: Pinecone, Weaviate, Milvus, FAISS
- Enables millisecond semantic search

---

#### ONLINE: Query Pipeline
```
Query → Embed → Retrieve → Rerank → Augment → Generate
```

**Critical steps:**
1. **Embed query** into same vector space
2. **Top-K retrieval** (K=3-8 typical)
3. **Rerank** (cross-encoder or LLM scoring)
   - Vector similarity ≠ true relevance
4. **Context assembly**
   - Deduplicate
   - Respect token limits
5. **Prompt augmentation**
6. **LLM generation** (grounded answer)

---

### Prompt Design Pattern

```
System: Answer using ONLY provided context.
If information is missing, say "I don't know."
Cite source snippets.

Context:
[chunk 1]
[chunk 2]
[chunk 3]

Question: {user_query}
```

**This constraint layer > model size for hallucination reduction**

---

### Evaluation Framework

**Retrieval Metrics:**
- Recall@K: Did we fetch the right chunk?
- MRR (Mean Reciprocal Rank)

**Answer Quality:**
- Faithfulness (supported by context?)
- Relevance
- Completeness

**Common Failure Modes:**

| Symptom | Root Cause | Fix |
|---------|-----------|-----|
| Confident but wrong | Bad retrieval | Improve chunking/reranking |
| Vague answers | Chunks too large | Reduce chunk size |
| Missing key info | Chunks too small/no overlap | Increase size/overlap |
| Slow responses | Inefficient vector search | Optimize DB/index |

---

### Advanced Patterns

**Hybrid Search:**
Vector similarity + BM25 keyword search = better factual recall

**Query Rewriting:**
LLM reformulates vague queries → search-optimized queries

**Multi-Hop Retrieval:**
Iterative retrieval when answer requires multiple documents

**Tool-Augmented RAG:**
LLM can retrieve → call DB → calculate → answer

---

### Engineering Reality Check

**Golden Rule:**
> If answer is wrong, retrieval quality is the problem 90% of the time, not the model.

**RAG engineering is:**
- 70% data structuring + chunk design
- 20% retrieval tuning
- 10% prompt engineering

**NOT:** Prompt poetry or model size games

---

### Production Stack Components

```
Embedding Model → Vector DB → Retriever → Reranker → LLM
     ↓              ↓            ↓           ↓         ↓
  text-embedding  Pinecone   Top-K=5   Cross-Enc  GPT-4/Claude
```

**Frameworks (orchestration only):**
- LangChain
- LlamaIndex

Performance depends on YOUR design, not the framework.

---

### Why RAG vs Fine-tuning

| Without RAG | With RAG |
|------------|----------|
| Hallucinations | Source-grounded |
| Outdated info | Live knowledge |
| Generic | Domain-specific |
| No traceability | Citations |

**RAG = Knowledge interface layer**

---

### Implementation Checklist

- [ ] Chunk strategy tested on sample docs
- [ ] Embedding model selected (domain-specific if needed)
- [ ] Vector DB configured with proper indexing
- [ ] Top-K tuned on validation set
- [ ] Reranker integrated
- [ ] Prompt template constrains hallucination
- [ ] Retrieval metrics baseline established
- [ ] Answer quality eval pipeline built
- [ ] Failure mode analysis completed

---

**These are engineering fundamentals. Master retrieval quality first. Everything else is secondary.**
