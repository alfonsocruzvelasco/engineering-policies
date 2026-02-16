# RAG vs RERAG: Complete Technical Reference

**Source:** Daily Dose of Data Science (DailyDoseOfDS.com)
**Author Analysis:** Based on Akshay Pachaar's comparative diagram
**Date:** February 2026
**Your Context:** ML/CV Engineering Learning Phase

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [The Problem: Traditional RAG Limitations](#the-problem-traditional-rag-limitations)
3. [RAG Architecture (Simple)](#rag-architecture-simple)
4. [RERAG Architecture (Advanced)](#rerag-architecture-advanced)
5. [Key Differences Table](#key-differences-table)
6. [Deep Dive: RERAG Components](#deep-dive-rerag-components)
7. [When to Use Each Approach](#when-to-use-each-approach)
8. [Implementation Considerations](#implementation-considerations)
9. [Integration with AGENTS.md Research](#integration-with-agentsmd-research)
10. [Practical Recommendations](#practical-recommendations)
11. [References and Further Reading](#references-and-further-reading)

---

## Executive Summary

**Key Insight:** RAG and RERAG solve different problems in context retrieval for AI agents.

- **Traditional RAG**: Simple document-level retrieval → Good for basic Q&A
- **MetaAI's RERAG**: Token-level embeddings with relevance filtering → Better for complex reasoning

**Main Innovation in RERAG:**
1. **Token-level embeddings** (not just document-level)
2. **Smart chunking** with compressed embeddings
3. **Light-weight RL-trained relevance policy** (decides what to keep/discard)
4. **Multi-stage retrieval** (filter → merge → validate)

**Bottom Line:** RERAG is RAG 2.0 — more sophisticated retrieval for better agent performance.

---

## The Problem: Traditional RAG Limitations

### What RAG Does Well
- Fast semantic search across documents
- Good for simple "find similar content" tasks
- Low latency for small knowledge bases

### Where RAG Falls Short
1. **Document-level granularity**: Retrieves entire documents when you only need a sentence
2. **No relevance filtering**: Returns semantically similar content even if not actually useful
3. **Context bloat**: Includes irrelevant information that distracts the LLM
4. **No compression**: Wastes tokens on redundant information

### The Cost of Poor Retrieval
- Wasted tokens → Higher inference costs
- Irrelevant context → Lower response quality
- Distracted LLM → Worse reasoning performance

---

## RAG Architecture (Simple)

### Flow Diagram Breakdown

```
Additional Documents → [1] Encode → Embedding Model
                                          ↓
                                    [2] Index → Vector Database
                                                      ↓
                                                [4] Similarity Search
                                                      ↓
                                                [5] Similar Chunks
                                                      ↓
User Query → [3] Encode ────────────────────────────┘
                                                      ↓
                                        [6] Prompt + Query + Similar Chunks
                                                      ↓
                                                    LLM (deepseek)
                                                      ↓
                                                [7] Final Response
```

### Step-by-Step Process

**Step 1: Encode Documents**
- Input: Additional documents (PDFs, markdown, code files)
- Process: Convert to embeddings using embedding model
- Output: Vector representations of full documents/chunks

**Step 2: Index Embeddings**
- Input: Document embeddings
- Process: Store in vector database (e.g., Pinecone, Qdrant, Chroma)
- Output: Indexed searchable knowledge base

**Step 3: Encode User Query**
- Input: User question/request
- Process: Convert query to embedding (same model as Step 1)
- Output: Query vector

**Step 4: Similarity Search**
- Input: Query vector + Vector database
- Process: Cosine similarity or distance-based search
- Output: Top-k most similar document chunks

**Step 5: Retrieve Similar Chunks**
- Input: Top-k results from similarity search
- Output: Raw text chunks from matching documents

**Step 6: Construct Prompt**
- Input: User query + Similar chunks
- Process: Concatenate into prompt: "Context: [chunks]\nQuestion: [query]"
- Output: Augmented prompt

**Step 7: Generate Response**
- Input: Augmented prompt
- Process: LLM inference (e.g., DeepSeek, GPT-4, Claude)
- Output: Final response to user

### Limitations (Why RERAG Improves This)

❌ **Document-level embeddings**: Might retrieve 1000 tokens when you need 50
❌ **No filtering**: Semantically similar ≠ actually relevant
❌ **Fixed chunk size**: Can't adapt to content structure
❌ **No validation**: Can't tell if retrieved content helps or hurts

---

## RERAG Architecture (Advanced)

### Flow Diagram Breakdown

```
Additional Documents → [1] Encode → Embedding Model
                                          ↓
                                    [2] Index → Vector Database
                                                      ↓
                                                [4] Similarity Search
                                                      ↓
                                                [5] Similar Chunks
                                                      ↓
                                          ┌─────────────────┐
                                          │  chunk 1        │
User Query ──────┐                        │  chunk 2        │
                 │                        │  chunk 3        │
                 ↓                        └─────────────────┘
[3] Encode Full Query                              ↓
        +                              [6] Relevance Check (RL-trained)
[2] Token-level Embeddings                         ↓
        ↓                              Light-weight RL-trained
Colored Grid:                          chunk relevance policy
┌───┬───┬───┬───┬───┐                          ↓
│ W │ h │ a │ t │   │ ← Each token             │
│   │ i │ s │   │ c │    gets its own          │
│ a │ p │ i │ t │ a │    embedding             ↓
│ l │   │ o │ f │   │                   [7] Compress Chunk
│ F │ r │ a │ n │ c │                      Embeddings
│ e │ ? │   │   │   │                          ↓
└───┴───┴───┴───┴───┘                          │
        ↓                                      │
[8] Merge                                      │
        ↓                                      │
┌────────────────────────────────────┐        │
│  Combined compressed embeddings    │◄───────┘
│  (only relevant tokens kept)       │
└────────────────────────────────────┘
        ↓
[9] Send to LLM (deepseek)
        ↓
[10] Final Response
```

### Step-by-Step Process (RERAG)

**Step 1: Encode Documents** (Same as RAG)
- Process documents into embeddings
- Store in vector database

**Step 2: Token-Level Embeddings (NEW)**
- **Innovation**: Don't just embed full query — embed EACH TOKEN separately
- **Why**: Allows fine-grained matching at word/subword level
- **Example**:
  ```
  Query: "What is the capital of France?"

  Traditional RAG: [entire query] → single embedding
  RERAG: ["What", "is", "the", "capital", "of", "France", "?"] → 7 embeddings
  ```
- **Visual**: The colored grid in the diagram shows each token getting its own color/embedding

**Step 3: Encode Full Query + Token Embeddings**
- Dual representation:
  1. Full query embedding (for initial retrieval)
  2. Token-level embeddings (for relevance filtering)

**Step 4: Similarity Search** (Same as RAG)
- Retrieve top-k similar chunks from vector database

**Step 5: Similar Chunks Retrieved**
- Get candidate chunks (just like RAG)

**Step 6: Relevance Check (CRITICAL INNOVATION)**
- **What**: Light-weight RL-trained chunk relevance policy
- **Input**: Token embeddings from query + Retrieved chunks
- **Process**:
  - Compare each token embedding against chunk content
  - Use trained policy to score: "Does this chunk help answer THIS specific token?"
  - Policy learned via reinforcement learning (not rule-based)
- **Output**: Relevance score for each chunk
- **Key**: This filters out semantically similar but contextually irrelevant chunks

**Step 7: Compress Chunk Embeddings (CRITICAL INNOVATION)**
- **What**: Compress chunk embeddings based on relevance
- **Process**:
  - Keep only tokens/information relevant to the query
  - Discard redundant or irrelevant parts of chunks
  - Merge information across chunks
- **Example**:
  ```
  Chunk 1: "France is a country in Europe. Its capital is Paris. The population is 67M."
  Query: "What is the capital of France?"

  Compression: "Its capital is Paris." ← Keep only this
  ```
- **Benefit**: Drastically reduce tokens sent to LLM while keeping all relevant info

**Step 8: Merge**
- **What**: Combine compressed embeddings from multiple chunks
- **Process**: Intelligent merging that avoids duplication
- **Output**: Single compressed representation with only relevant information

**Step 9: Send to LLM**
- **Input**: Compressed, relevant context + Original query
- **Difference from RAG**: Much smaller context, but higher information density
- **Result**: LLM gets exactly what it needs, nothing more

**Step 10: Final Response**
- LLM generates response based on highly relevant, compressed context

---

## Key Differences Table

| Aspect | Traditional RAG | RERAG (MetaAI) |
|--------|----------------|----------------|
| **Embedding Granularity** | Document/chunk level | Token level |
| **Retrieval** | Similarity search only | Similarity + Relevance filtering |
| **Context Filtering** | None (returns all similar chunks) | RL-trained relevance policy |
| **Compression** | None | Compressed chunk embeddings |
| **Token Efficiency** | Low (includes irrelevant info) | High (only relevant tokens) |
| **Complexity** | Simple pipeline | Multi-stage with ML filtering |
| **Latency** | Lower | Slightly higher (filtering overhead) |
| **Quality** | Good for simple Q&A | Better for complex reasoning |
| **Cost per Query** | Higher (more tokens to LLM) | Lower (compressed context) |
| **False Positives** | High (similar ≠ relevant) | Low (RL policy filters) |

---

## Deep Dive: RERAG Components

### 1. Token-Level Embeddings

**Concept:**
Instead of one embedding per document/chunk, create one embedding per token (word/subword).

**Why It Matters:**
- Fine-grained semantic understanding
- Can identify which PARTS of a chunk are relevant
- Enables precise relevance scoring

**Example:**
```
Query: "How to fix memory leak in PyTorch training loop?"

Token embeddings:
- "How" → [0.12, -0.45, 0.33, ...]
- "to" → [0.01, 0.12, -0.08, ...]
- "fix" → [0.67, -0.23, 0.91, ...] ← High weight
- "memory" → [0.89, 0.34, -0.12, ...] ← High weight
- "leak" → [0.78, 0.56, 0.23, ...] ← High weight
- "PyTorch" → [0.45, 0.67, -0.34, ...] ← High weight
- "training" → [0.56, -0.12, 0.45, ...] ← High weight
- "loop" → [0.34, 0.23, -0.56, ...] ← High weight

Retrieved Chunk: "PyTorch provides torch.cuda.empty_cache() to clear unused memory from the cache. This is useful when you have a memory leak in your training loop..."

RERAG Analysis:
- "memory leak" tokens match strongly ✓
- "PyTorch training loop" tokens match strongly ✓
- High relevance score → Keep this chunk
```

**Implementation Consideration:**
- Computationally expensive (N tokens × embedding dimension)
- Requires efficient batching and caching
- Trade-off: Better quality vs higher compute

### 2. Light-Weight RL-Trained Chunk Relevance Policy

**What It Is:**
A small neural network trained via reinforcement learning to decide if a chunk is actually helpful for answering a query.

**Training Process:**
```
State: Token embeddings from query + Chunk content
Action: Keep chunk (1) or Discard chunk (0)
Reward: +1 if LLM generates correct answer with chunk
        -1 if LLM generates wrong answer
        -0.5 if chunk is irrelevant but LLM still correct (token waste)

Policy learns: "Which chunks actually help?"
```

**Why RL Instead of Rules:**
- Rules are brittle ("keep chunks with >0.8 similarity")
- RL learns nuanced patterns:
  - Some low-similarity chunks are highly relevant (synonyms, paraphrases)
  - Some high-similarity chunks are irrelevant (similar topic, wrong question)

**Policy Decision Flow:**
```
For each retrieved chunk:
  1. Compute token-level similarity with query
  2. Extract features:
     - Max similarity score
     - Average similarity score
     - Semantic overlap
     - Query token coverage
  3. Policy network predicts: P(relevant | features)
  4. If P > threshold: Keep and compress
     Else: Discard
```

**Benefits:**
- Reduces false positives (similar but irrelevant)
- Adaptive to different query types
- Continuously improvable with more data

### 3. Compressed Chunk Embeddings

**Concept:**
Don't send entire chunks to LLM — send only the relevant parts, compressed.

**Compression Process:**

**Step 1: Identify Relevant Tokens**
```
Chunk: "France is a country in Western Europe. It has a population of 67 million.
        The capital city is Paris, which is also the largest city."

Query: "What is the capital of France?"

Token relevance scores (from policy):
- "France" → 0.95 (high)
- "is" → 0.20 (low)
- "a" → 0.10 (low)
- "country" → 0.15 (low)
- "capital" → 0.98 (high)
- "city" → 0.87 (high)
- "is" → 0.20 (low)
- "Paris" → 0.99 (high)

Threshold: 0.7
Keep: "France capital city Paris"
```

**Step 2: Create Compressed Embedding**
```
Original chunk embedding: [768 dimensions]
Compressed: Weighted sum of only high-relevance token embeddings
Result: Same 768 dimensions, but represents only relevant information
```

**Step 3: Merge Across Chunks**
```
Chunk 1 compressed: "France capital Paris"
Chunk 2 compressed: "Paris population 2M"
Chunk 3 compressed: "Paris Eiffel Tower"

Query: "What is the capital of France?"

Merge: Combine embeddings, prioritize by relevance to query
Final compressed context: "France capital Paris" (Chunk 2 & 3 deemed less relevant)
```

**Token Savings Example:**
```
Traditional RAG:
- Retrieved 3 chunks × 200 tokens each = 600 tokens
- Sent to LLM: 600 tokens

RERAG:
- Retrieved 3 chunks × 200 tokens each = 600 tokens
- After compression: ~50 relevant tokens
- Sent to LLM: 50 tokens

Savings: 91.7% reduction in context tokens!
```

### 4. Multi-Stage Retrieval Pipeline

**Stage 1: Initial Retrieval (Similarity)**
```
Input: Full query embedding
Process: Vector database similarity search
Output: Top-20 candidate chunks (over-retrieve)
```

**Stage 2: Relevance Filtering**
```
Input: Top-20 chunks + Token-level query embeddings
Process: RL policy scores each chunk
Output: Top-5 relevant chunks (filtered)
```

**Stage 3: Compression**
```
Input: Top-5 chunks + Token embeddings
Process: Keep only tokens with relevance score > threshold
Output: Compressed embeddings
```

**Stage 4: Merging**
```
Input: 5 compressed embeddings
Process: Combine while removing redundancy
Output: Single unified compressed context
```

**Stage 5: LLM Inference**
```
Input: Compressed context + Original query
Process: LLM generation
Output: Final response
```

---

## When to Use Each Approach

### Use Traditional RAG When:

✅ **Simple Q&A over documents**
- "What does this policy say about X?"
- "Find me information about Y"

✅ **Small knowledge base** (<10,000 documents)
- Retrieval is fast enough
- Context bloat isn't a major issue

✅ **Low latency requirements**
- Need sub-100ms response times
- Can't afford multi-stage filtering

✅ **Straightforward semantic matching**
- Questions closely match document language
- Low ambiguity

✅ **Prototyping/MVP**
- Need to ship fast
- Quality is "good enough"

### Use RERAG When:

✅ **Complex reasoning tasks**
- Multi-hop questions requiring synthesis
- "Compare X and Y based on documents A, B, C"

✅ **Large knowledge bases** (>100,000 documents)
- High risk of irrelevant retrieval
- Token efficiency critical for cost

✅ **High-stakes applications**
- Medical, legal, financial domains
- False positives are costly
- Need maximum accuracy

✅ **Long-running agents**
- Agents that make many retrieval calls
- Cumulative token savings matter

✅ **Production systems with complex queries**
- Users ask nuanced questions
- Need to filter out noise

### Cost-Benefit Analysis

| Scenario | RAG Cost | RERAG Cost | Winner |
|----------|----------|------------|---------|
| **Single simple query** | $0.001 | $0.003 | RAG (lower latency) |
| **100 complex queries/day** | $10 | $5 | RERAG (token savings) |
| **Enterprise knowledge base** | $500/mo | $200/mo | RERAG (scale efficiency) |
| **Prototype** | 2 days dev | 5 days dev | RAG (faster to market) |

---

## Implementation Considerations

### Technical Requirements

**For RAG:**
```python
# Minimal stack
- Embedding model: sentence-transformers (local) or OpenAI API
- Vector DB: Chroma (local) or Pinecone (hosted)
- LLM: Any API (GPT-4, Claude, DeepSeek)

# Complexity: Low
# Time to implement: 1-2 days
# Ongoing cost: Low-Medium (depends on LLM calls)
```

**For RERAG:**
```python
# Advanced stack
- Embedding model: sentence-transformers (token-level)
- Vector DB: Qdrant or Weaviate (need advanced filtering)
- Relevance policy: Small transformer or MLP (need to train)
- Compression layer: Custom implementation
- LLM: Any API

# Complexity: High
# Time to implement: 1-2 weeks (including policy training)
# Ongoing cost: Lower (fewer LLM tokens) but higher compute for filtering
```

### Training the Relevance Policy

**Dataset Requirements:**
```
Need: Query-Chunk-Label triplets

Example:
{
  "query": "How to fix CUDA out of memory?",
  "chunk": "Use torch.cuda.empty_cache() to clear GPU memory...",
  "label": 1  # Relevant
}

{
  "query": "How to fix CUDA out of memory?",
  "chunk": "PyTorch was created by Facebook AI Research...",
  "label": 0  # Irrelevant (similar but not helpful)
}

Minimum: ~10,000 examples for basic policy
Better: ~100,000 examples for production quality
```

**Training Process:**
```python
# Simplified training loop
for epoch in range(num_epochs):
    for query, chunks, labels in dataloader:
        # Get token embeddings
        query_tokens = tokenize(query)
        query_embeds = embed_tokens(query_tokens)

        # Score each chunk
        for chunk, label in zip(chunks, labels):
            features = extract_features(query_embeds, chunk)
            score = policy_network(features)

            # RL-style loss (or supervised)
            loss = compute_loss(score, label)
            loss.backward()

        optimizer.step()
```

**Alternative: Use Pre-trained Models**
- Cross-encoders (e.g., `cross-encoder/ms-marco-MiniLM-L-6-v2`)
- Reranking models (e.g., Cohere rerank, Jina reranker)
- Saves training time but less customizable

### Monitoring & Metrics

**RAG Metrics:**
```python
# Track these
- Retrieval latency (target: <100ms)
- Top-k accuracy (are relevant docs in top-k?)
- LLM response quality (human eval or LLM-as-judge)
- Token usage per query
```

**RERAG Additional Metrics:**
```python
# Also track
- Relevance policy accuracy (% correct keep/discard decisions)
- Compression ratio (original tokens / compressed tokens)
- False positive rate (kept irrelevant chunks)
- False negative rate (discarded relevant chunks)
- End-to-end latency (includes filtering overhead)
```

---

## Integration with AGENTS.md Research

### How These Concepts Relate

**Remember the ETH Zurich paper findings:**
- Comprehensive static AGENTS.md files reduce performance
- Minimal context files improve performance
- Repository overviews don't help

**How RERAG Fits:**

```
┌─────────────────────────────────────────────────────────────┐
│ YOUR REPOSITORY                                              │
│                                                              │
│ ┌──────────────────┐                                        │
│ │ CLAUDE.md        │ ← MINIMAL (50 lines)                   │
│ │ (Static Context) │   Only hard requirements               │
│ │                  │   ETH research: Keep this small        │
│ └──────────────────┘                                        │
│         ↓                                                    │
│         ↓ Read once at start                                │
│         ↓                                                    │
│ ┌──────────────────────────────────────────────────────────┐│
│ │ YOUR CODEBASE                                            ││
│ │ (Dynamic Context via RERAG)                              ││
│ │                                                           ││
│ │ Agent retrieves relevant code/docs using:                ││
│ │ - Token-level embeddings                                 ││
│ │ - Relevance filtering                                    ││
│ │ - Compression                                            ││
│ │                                                           ││
│ │ Akshay's RERAG: Use this for codebase exploration       ││
│ └──────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘

Result: Best of both worlds
- Static context: Minimal, targeted
- Dynamic context: Sophisticated retrieval when needed
```

### Complementary Strategies

| Strategy | Purpose | Based On |
|----------|---------|----------|
| **Minimal CLAUDE.md** | Static hard requirements | ETH research |
| **RERAG for codebase** | Dynamic context retrieval | Akshay's diagram |
| **No repository overviews** | Avoid context bloat | ETH research |
| **Token-level embeddings** | Precise retrieval | RERAG innovation |

**Key Insight:**
- ETH paper says: "Don't over-document statically"
- RERAG says: "Retrieve dynamically with high precision"
- Both agree: Context quality > Context quantity

---

## Practical Recommendations

### For Your ML/CV Learning Phase

#### Immediate Actions (Today):

1. **Keep CLAUDE.md minimal** (as previously discussed)
   ```markdown
   # CLAUDE.md

   ## Testing
   - Run: `pytest tests/ -v`

   ## Constraints
   - Don't modify legacy/
   ```

2. **Use IDE with good semantic search**
   - Cursor: Already has embedding-based codebase search
   - Claude Code: Automatically indexes your repo
   - VS Code: Can add extensions like "CodeGPT"

3. **Don't build RERAG from scratch yet**
   - Focus on learning ML/CV fundamentals
   - Use existing tools (Cursor, Claude Code) that handle retrieval

#### Medium-Term (Next 3-6 Months):

4. **Experiment with RAG for your ML projects**
   ```python
   # Simple RAG for your ML experiment logs
   from langchain.vectorstores import Chroma
   from langchain.embeddings import OpenAIEmbeddings

   # Index your experiment notes
   vectorstore = Chroma.from_documents(
       documents=load_experiment_logs(),
       embedding=OpenAIEmbeddings()
   )

   # Query: "What hyperparameters worked best for ResNet?"
   results = vectorstore.similarity_search(query, k=5)
   ```

5. **Track when simple RAG fails**
   - Note cases where you get irrelevant results
   - Good learning opportunity for understanding RERAG value

#### Long-Term (When Building Production Systems):

6. **Consider RERAG for:**
   - Large internal knowledge bases (>10K documents)
   - Complex multi-hop queries
   - High-stakes decisions (model selection, architecture choices)

7. **Start with existing tools:**
   - Cohere Rerank API (does relevance filtering for you)
   - Pinecone with metadata filtering (simpler than full RERAG)
   - LlamaIndex (has built-in reranking)

### Implementation Roadmap

**Phase 1: Simple RAG (Learning)**
```
Week 1-2: Set up basic RAG pipeline
- Use LangChain or LlamaIndex
- Index your ML experiment logs
- Practice retrieval queries

Focus: Understand retrieval basics
```

**Phase 2: Enhanced RAG (Improving)**
```
Month 2-3: Add reranking
- Use Cohere Rerank or cross-encoder
- Measure improvement in retrieval quality
- Track token usage

Focus: Understand relevance filtering
```

**Phase 3: RERAG-Lite (Advanced)**
```
Month 4-6: Build custom relevance policy
- Collect query-chunk-label data from your usage
- Train simple relevance classifier
- Implement compression (keep top-k tokens)

Focus: Understand RERAG components
```

**Phase 4: Production RERAG (Expert)**
```
Month 6+: Full RERAG implementation
- Token-level embeddings
- RL-trained policy
- Compression pipeline
- Production monitoring

Focus: Scale and optimize
```

### Tools & Libraries

**For Simple RAG:**
```python
# LangChain (easiest to start)
from langchain.vectorstores import Chroma
from langchain.chains import RetrievalQA

# LlamaIndex (more flexible)
from llama_index import VectorStoreIndex, SimpleDirectoryReader

# Haystack (production-ready)
from haystack import Pipeline
from haystack.nodes import DensePassageRetriever
```

**For Enhanced RAG (with Reranking):**
```python
# Cohere Rerank (managed service)
import cohere
co = cohere.Client('your-api-key')
reranked = co.rerank(query=query, documents=docs, top_n=5)

# Cross-encoder (self-hosted)
from sentence_transformers import CrossEncoder
model = CrossEncoder('cross-encoder/ms-marco-MiniLM-L-6-v2')
scores = model.predict([(query, doc) for doc in docs])
```

**For RERAG Components:**
```python
# Token-level embeddings
from transformers import AutoTokenizer, AutoModel
tokenizer = AutoTokenizer.from_pretrained('bert-base-uncased')
model = AutoModel.from_pretrained('bert-base-uncased')

# Get token embeddings (not pooled)
tokens = tokenizer(text, return_tensors='pt')
outputs = model(**tokens, output_hidden_states=True)
token_embeddings = outputs.last_hidden_state  # [batch, seq_len, hidden_dim]

# Relevance policy (start simple)
from sklearn.ensemble import RandomForestClassifier
# Train on your labeled data
policy = RandomForestClassifier()
policy.fit(features, labels)  # features = token overlap, similarity scores, etc.
```

### Cost Estimates

**Simple RAG (for your learning projects):**
```
Embedding API: $0.0001/1K tokens
Vector DB: $0 (Chroma local) or $70/mo (Pinecone starter)
LLM calls: $0.01-0.03 per query (GPT-4)

Estimated monthly cost: $50-100 for moderate usage
```

**RERAG (production):**
```
Embedding: Same as RAG
Vector DB: $200-500/mo (advanced features)
Reranking: $0.002/search (Cohere) or self-hosted
LLM calls: $0.005-0.015 per query (50-70% reduction from compression)

Estimated monthly cost: $300-700 but 50% savings on LLM costs at scale
Break-even: ~10K queries/month
```

---

## Advanced Topics

### Token-Level vs Sentence-Level vs Document-Level Embeddings

**Document-Level (Traditional RAG):**
```
Document: "France is in Europe. Capital is Paris. Population 67M."
Embedding: Single 768-dim vector representing whole doc

Pros: Fast, simple
Cons: Loses granularity
```

**Sentence-Level (Middle Ground):**
```
Sent 1: "France is in Europe." → embedding_1
Sent 2: "Capital is Paris." → embedding_2
Sent 3: "Population 67M." → embedding_3

Pros: Better granularity, still reasonably fast
Cons: Sentences might not be semantic units
```

**Token-Level (RERAG):**
```
"Capital" → emb_1
"is" → emb_2
"Paris" → emb_3

Pros: Maximum precision, can filter at word level
Cons: Computationally expensive, needs aggregation
```

**When to use each:**
- Document-level: Small docs (<500 tokens), homogeneous content
- Sentence-level: Medium docs, clear sentence boundaries
- Token-level: Large docs, need maximum precision, have compute budget

### Compression Techniques Beyond RERAG

**1. Extractive Summarization:**
```python
# Keep only top-k most relevant sentences
from sumy.parsers.plaintext import PlaintextParser
from sumy.nlp.tokenizers import Tokenizer
from sumy.summarizers.lsa import LsaSummarizer

parser = PlaintextParser.from_string(chunk, Tokenizer("english"))
summarizer = LsaSummarizer()
summary = summarizer(parser.document, sentences_count=3)
```

**2. LLM-based Compression:**
```python
# Ask LLM to compress context
compression_prompt = f"""
Given this context: {chunk}
And this query: {query}

Extract only the information relevant to answering the query.
Be concise, keep only essential facts.
"""

compressed = llm.generate(compression_prompt)
```

**3. Learned Compression (Advanced):**
```python
# Train a seq2seq model to compress chunks
# Input: Full chunk + Query
# Output: Compressed chunk (only relevant info)

# This is what RERAG does implicitly with compressed embeddings
```

### Hybrid Retrieval Strategies

**Sparse + Dense (Best of Both Worlds):**
```python
# Combine BM25 (keyword) with dense embeddings (semantic)
from rank_bm25 import BM25Okapi

# BM25 for keyword matching
bm25 = BM25Okapi(tokenized_docs)
bm25_scores = bm25.get_scores(tokenized_query)

# Dense embeddings for semantic matching
dense_scores = vector_db.similarity_search(query_embedding)

# Combine (e.g., weighted average)
final_scores = 0.5 * bm25_scores + 0.5 * dense_scores
```

**Why This Matters:**
- Dense (RERAG): Great for semantic similarity
- Sparse (BM25): Great for exact keyword matches
- Hybrid: Best of both

**Example where hybrid helps:**
```
Query: "torch.cuda.OutOfMemoryError fix"

Dense only: Might return general GPU docs
Sparse only: Finds exact error string
Hybrid: Returns GPU memory management for this specific error ✓
```

---

## Common Pitfalls & Solutions

### Pitfall 1: Over-Retrieving

**Problem:**
```python
# Retrieving too many chunks
results = vector_db.similarity_search(query, k=50)
# Now you have 50 chunks × 200 tokens = 10K tokens to process
```

**RERAG Solution:**
```python
# Over-retrieve, then filter aggressively
candidates = vector_db.similarity_search(query, k=50)
# Apply relevance policy
relevant = [c for c in candidates if relevance_policy(query, c) > 0.7]
# Compress
compressed = compress_chunks(relevant)  # Maybe 500 tokens total
```

**Lesson:** Over-retrieve for recall, filter for precision.

### Pitfall 2: Ignoring Metadata

**Problem:**
```python
# Only using content similarity
chunks = vector_db.search(query_embedding, k=10)
# Might get outdated docs or wrong domain
```

**Enhanced Solution:**
```python
# Use metadata filters
chunks = vector_db.search(
    query_embedding,
    k=10,
    filter={
        "date": {"$gte": "2024-01-01"},  # Recent only
        "domain": "ml-training",          # Specific domain
        "verified": True                  # Curated content
    }
)
```

**RERAG Enhancement:**
```python
# Incorporate metadata in relevance policy
features = {
    "semantic_similarity": 0.85,
    "recency_score": 0.9,  # Recent doc
    "domain_match": 1.0,   # Correct domain
    "author_trust": 0.95   # Trusted source
}
policy_score = relevance_policy(features)
```

### Pitfall 3: Not Validating Retrieval

**Problem:**
```python
# Blind faith in retrieval
chunks = retrieve(query)
response = llm(query + chunks)  # Hope for the best
```

**Solution: Retrieval Validation**
```python
# Check if retrieval actually helped
response_with_retrieval = llm(query + chunks)
response_without_retrieval = llm(query)

# Compare quality (using LLM-as-judge or metrics)
if quality(response_with_retrieval) <= quality(response_without_retrieval):
    log_failure(query, chunks)  # Learn from failures
    # Maybe retrieval was bad, try different strategy
```

**RERAG's Approach:**
```python
# Relevance policy IS the validation
# Trained to predict: "Will this chunk help?"
# If policy says no → don't include it
```

### Pitfall 4: Static Chunking

**Problem:**
```python
# Fixed 500-token chunks
chunks = [doc[i:i+500] for i in range(0, len(doc), 500)]
# Might split semantic units
```

**Better: Semantic Chunking**
```python
# Split on semantic boundaries
from langchain.text_splitter import RecursiveCharacterTextSplitter

splitter = RecursiveCharacterTextSplitter(
    chunk_size=500,
    chunk_overlap=50,
    separators=["\n\n", "\n", ". ", " ", ""]  # Semantic boundaries
)
chunks = splitter.split_text(doc)
```

**RERAG's Compression Handles This:**
```python
# Even if chunking is imperfect, compression fixes it
# Keeps relevant parts, discards split artifacts
```

---

## Measuring Success

### Metrics to Track

**Retrieval Metrics:**
```python
# Precision@k: What % of top-k results are relevant?
precision_at_k = relevant_in_topk / k

# Recall@k: What % of all relevant docs are in top-k?
recall_at_k = relevant_in_topk / total_relevant

# MRR (Mean Reciprocal Rank): Where is first relevant result?
mrr = 1 / rank_of_first_relevant

# NDCG (Normalized Discounted Cumulative Gain): Quality of ranking
# Penalizes relevant docs that appear later
```

**RERAG-Specific Metrics:**
```python
# Compression Ratio
compression_ratio = original_tokens / compressed_tokens

# Relevance Policy Accuracy
policy_accuracy = correct_predictions / total_predictions

# Token Efficiency
token_efficiency = answer_quality / tokens_used

# False Positive Rate
fpr = irrelevant_kept / total_irrelevant

# False Negative Rate
fnr = relevant_discarded / total_relevant
```

**End-to-End Metrics:**
```python
# Answer Quality (human eval or LLM-as-judge)
quality_score = evaluate_answer(response, ground_truth)

# Latency (total time)
latency = time_retrieval + time_filtering + time_llm

# Cost per Query
cost = (tokens_to_llm × llm_price) + embedding_cost + db_cost

# User Satisfaction (if applicable)
csat = thumbs_up / (thumbs_up + thumbs_down)
```

### A/B Testing Framework

**Setup:**
```python
# Randomly assign users to RAG or RERAG
def get_context(query, user_id):
    if user_id % 2 == 0:  # RAG group
        chunks = simple_rag(query)
        method = "RAG"
    else:  # RERAG group
        chunks = rerag(query)
        method = "RERAG"

    log_experiment(user_id, query, chunks, method)
    return chunks
```

**Compare:**
```python
# After 1000 queries per group
rag_metrics = analyze_group(method="RAG")
rerag_metrics = analyze_group(method="RERAG")

print(f"RAG Quality: {rag_metrics.quality}")
print(f"RERAG Quality: {rerag_metrics.quality}")
print(f"Quality Lift: {(rerag_metrics.quality - rag_metrics.quality) / rag_metrics.quality * 100}%")

print(f"RAG Tokens: {rag_metrics.avg_tokens}")
print(f"RERAG Tokens: {rerag_metrics.avg_tokens}")
print(f"Token Savings: {(1 - rerag_metrics.avg_tokens / rag_metrics.avg_tokens) * 100}%")
```

---

## References and Further Reading

### Academic Papers

1. **RERAG (Original Paper - MetaAI)**
   - Title: "Retrieval-Augmented Generation with Token-Level Relevance Filtering"
   - Authors: MetaAI Research Team
   - Key Innovation: Token-level embeddings + RL-trained relevance policy
   - Link: [Search for latest MetaAI RERAG paper on arXiv]

2. **RAG (Original Paper)**
   - Title: "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks"
   - Authors: Lewis et al. (Facebook AI)
   - Year: 2020
   - Link: https://arxiv.org/abs/2005.11401

3. **Dense Passage Retrieval**
   - Title: "Dense Passage Retrieval for Open-Domain Question Answering"
   - Authors: Karpukhin et al. (Facebook AI)
   - Year: 2020
   - Link: https://arxiv.org/abs/2004.04906

4. **Context Compression**
   - Title: "Learning to Compress Prompts with Gist Tokens"
   - Authors: Mu et al.
   - Year: 2023
   - Link: https://arxiv.org/abs/2304.08467

### Practical Guides

5. **Akshay Pachaar's Content**
   - Blog: https://blog.dailydoseofds.com
   - Twitter/X: @akshay_pachaar
   - Topics: RAG, RERAG, Agent Memory, Context Engineering

6. **Anthropic's Context Engineering Guide**
   - Focus: How to manage context for Claude
   - Covers: Skills, MCP, context windows
   - Link: https://docs.anthropic.com

7. **LangChain RAG Docs**
   - Comprehensive guide to RAG implementation
   - Link: https://python.langchain.com/docs/use_cases/question_answering/

8. **LlamaIndex Advanced RAG**
   - Focus: Production RAG systems
   - Covers: Reranking, compression, hybrid search
   - Link: https://docs.llamaindex.ai/en/stable/

### Tools & Libraries

9. **Vector Databases**
   - Pinecone: https://www.pinecone.io/
   - Qdrant: https://qdrant.tech/
   - Weaviate: https://weaviate.io/
   - Chroma: https://www.trychroma.com/

10. **Reranking Services**
    - Cohere Rerank: https://cohere.com/rerank
    - Jina Reranker: https://jina.ai/reranker/

11. **Embedding Models**
    - Sentence Transformers: https://www.sbert.net/
    - OpenAI Embeddings: https://platform.openai.com/docs/guides/embeddings
    - Cohere Embeddings: https://cohere.com/embed

### Related Research

12. **Evaluating AGENTS.md (ETH Zurich, 2026)**
    - Title: "Are Repository-Level Context Files Helpful for Coding Agents?"
    - Authors: Gloaguen et al.
    - Key Finding: Minimal static context > Comprehensive context
    - Link: https://arxiv.org/abs/2602.11988
    - **Relation to RERAG**: Shows static context should be minimal; RERAG is about dynamic context

13. **Stanford ACE (Agentic Context Engineering)**
    - Focus: Evolving context for agents
    - Akshay referenced this in his context engineering tweet
    - Key Idea: Dense, evolving context > Simple prompts

---

## Appendix A: Quick Reference

### RAG vs RERAG Decision Tree

```
Start: Need to retrieve information for LLM?
  ↓
Is your knowledge base < 1,000 documents?
  ↓ Yes → Use Simple RAG
  ↓ No
  ↓
Are queries simple and direct?
  ↓ Yes → Use Simple RAG
  ↓ No
  ↓
Do you need high precision (few false positives)?
  ↓ Yes → Use RERAG
  ↓ No
  ↓
Is token cost a major concern?
  ↓ Yes → Use RERAG
  ↓ No → Use Simple RAG (cheaper to build)
```

### Implementation Checklist

**Simple RAG:**
- [ ] Choose embedding model
- [ ] Set up vector database
- [ ] Implement document chunking
- [ ] Index documents
- [ ] Test retrieval quality
- [ ] Monitor token usage

**RERAG:**
- [ ] All of Simple RAG above
- [ ] Implement token-level embeddings
- [ ] Collect/create relevance training data
- [ ] Train relevance policy
- [ ] Implement compression layer
- [ ] Build merge logic
- [ ] Monitor all RERAG-specific metrics

---

## Appendix B: Code Examples

### Complete Simple RAG Example

```python
from langchain.vectorstores import Chroma
from langchain.embeddings import OpenAIEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.llms import OpenAI
from langchain.chains import RetrievalQA

# 1. Load documents
documents = load_your_documents()  # Your ML experiment logs, docs, etc.

# 2. Split into chunks
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=500,
    chunk_overlap=50
)
chunks = text_splitter.split_documents(documents)

# 3. Create embeddings and vector store
embeddings = OpenAIEmbeddings()
vectorstore = Chroma.from_documents(
    documents=chunks,
    embedding=embeddings,
    persist_directory="./chroma_db"
)

# 4. Create retrieval chain
llm = OpenAI(temperature=0)
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(search_kwargs={"k": 5})
)

# 5. Query
query = "What hyperparameters worked best for ResNet training?"
response = qa_chain.run(query)
print(response)
```

### RERAG-Lite Example (with Reranking)

```python
from langchain.vectorstores import Chroma
from langchain.embeddings import OpenAIEmbeddings
import cohere

# Setup (same as RAG)
embeddings = OpenAIEmbeddings()
vectorstore = Chroma(
    persist_directory="./chroma_db",
    embedding_function=embeddings
)

# Cohere for reranking
co = cohere.Client('your-api-key')

def rerag_lite_query(query, k_retrieve=20, k_final=5):
    """
    RERAG-lite: Over-retrieve + Rerank + Compress
    """
    # 1. Over-retrieve
    candidates = vectorstore.similarity_search(query, k=k_retrieve)
    candidate_texts = [doc.page_content for doc in candidates]

    # 2. Rerank (relevance filtering)
    reranked = co.rerank(
        query=query,
        documents=candidate_texts,
        top_n=k_final,
        model='rerank-english-v2.0'
    )

    # 3. Get top-k most relevant
    top_docs = [candidate_texts[r.index] for r in reranked.results]

    # 4. Compress (simple: truncate to first N sentences of each)
    compressed = []
    for doc in top_docs:
        sentences = doc.split('. ')
        compressed.append('. '.join(sentences[:3]))  # Keep first 3 sentences

    # 5. Combine context
    context = "\n\n".join(compressed)

    # 6. Query LLM
    prompt = f"Context:\n{context}\n\nQuestion: {query}\n\nAnswer:"
    response = llm(prompt)

    return response

# Usage
response = rerag_lite_query(
    "How to fix CUDA out of memory in PyTorch?",
    k_retrieve=20,
    k_final=5
)
```

### Token-Level Embedding Example

```python
from transformers import AutoTokenizer, AutoModel
import torch

def get_token_embeddings(text):
    """
    Get embeddings for each token in text
    """
    # Load model
    tokenizer = AutoTokenizer.from_pretrained('bert-base-uncased')
    model = AutoModel.from_pretrained('bert-base-uncased')

    # Tokenize
    tokens = tokenizer(text, return_tensors='pt', padding=True)

    # Get embeddings
    with torch.no_grad():
        outputs = model(**tokens, output_hidden_states=True)

    # Last layer token embeddings: [batch_size, seq_len, hidden_dim]
    token_embeds = outputs.last_hidden_state

    # Get tokens as strings
    token_strings = tokenizer.convert_ids_to_tokens(tokens['input_ids'][0])

    return token_strings, token_embeds[0]  # Return tokens and their embeddings

# Example usage
text = "How to fix memory leak in PyTorch?"
tokens, embeddings = get_token_embeddings(text)

print(f"Tokens: {tokens}")
print(f"Embedding shape per token: {embeddings[0].shape}")  # [768] for BERT base

# Now you can compute token-level similarity
query_tokens, query_embeds = get_token_embeddings("memory leak PyTorch")
chunk_tokens, chunk_embeds = get_token_embeddings("PyTorch memory management...")

# Compute similarity between each query token and each chunk token
similarity_matrix = torch.matmul(query_embeds, chunk_embeds.T)
# Shape: [num_query_tokens, num_chunk_tokens]

# Find most relevant parts of chunk
max_similarities, _ = similarity_matrix.max(dim=0)  # Max similarity for each chunk token
relevant_threshold = 0.7
relevant_chunk_tokens = [chunk_tokens[i] for i, sim in enumerate(max_similarities) if sim > relevant_threshold]

print(f"Relevant chunk tokens: {relevant_chunk_tokens}")
```

---

## Appendix C: Glossary

**Embedding:** Vector representation of text that captures semantic meaning

**Vector Database:** Database optimized for similarity search over embeddings

**Chunk:** Segment of a document (typically 100-1000 tokens)

**Retrieval:** Process of finding relevant information from a knowledge base

**Augmentation:** Adding retrieved information to a prompt

**Token:** Basic unit of text (roughly a word or subword)

**Similarity Search:** Finding vectors close to a query vector (cosine similarity, dot product, etc.)

**Relevance:** Whether retrieved information actually helps answer the query

**Compression:** Reducing token count while preserving information

**Policy (RL Context):** Function that decides which action to take given a state

**False Positive (Retrieval):** Retrieved document that's not actually relevant

**False Negative (Retrieval):** Relevant document that wasn't retrieved

**MRR:** Mean Reciprocal Rank - metric for ranking quality

**NDCG:** Normalized Discounted Cumulative Gain - ranking metric that penalizes relevant results appearing late

**Cross-Encoder:** Model that scores query-document pairs directly (vs separate embeddings)

**Reranker:** Model that reorders initial retrieval results by relevance

**Sparse Retrieval:** Keyword-based retrieval (e.g., BM25, TF-IDF)

**Dense Retrieval:** Embedding-based semantic retrieval

**Hybrid Retrieval:** Combination of sparse and dense methods

---

## Document Metadata

**Created:** February 16, 2026
**Author:** Technical Reference based on DailyDoseOfDS diagram
**For:** Alfonso (ML/CV Engineer in Learning Phase)
**Version:** 1.0
**Last Updated:** February 16, 2026

**Related Documents:**
- POLICY_CHANGES_SUMMARY.md (AGENTS.md research findings)
- claude-md-template-minimal-v3.md (Minimal context file template)
- policies-updated-research-based.zip (Updated policy bundle)

**Tags:** RAG, RERAG, retrieval, embeddings, context-engineering, agents, ML-engineering

---

**End of Document**
