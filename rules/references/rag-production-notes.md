# RAG for Production ML/CV Engineering — Comprehensive Notes v2.0

**Based on:** Cursor's production RAG pipeline + ML/CV engineering requirements
**Focus:** Actionable patterns for code-aware AI assistants and ML/CV knowledge bases
**Date:** 2026-02-05

---

## Executive Summary

**Key insight from Cursor:** RAG success depends on **semantic chunking** (not arbitrary splits) and **hybrid retrieval** (vector + keyword). For ML/CV engineers, this means:

1. **Code requires different chunking than text** → Use AST-based semantic chunking
2. **Privacy matters in production** → Embeddings only in cloud, source code stays local
3. **Incremental updates are essential** → Use Merkle trees for efficient change detection
4. **Hybrid retrieval outperforms pure vector search** → Combine semantic + regex/grep

**Critical distinction for ML/CV:**
- **Research RAG:** Optimize for paper/article retrieval (paragraphs, citations)
- **Code RAG:** Optimize for function/class/module retrieval (syntax-aware chunks)
- **Your use case:** Both — ML/CV code + research papers + experiment logs

---

## 1. What is RAG? (Expanded Definition)

**Retrieval-Augmented Generation (RAG)** = Information Retrieval + LLM Generation

**Traditional RAG (text documents):**
```
User Query → Embed → Vector Search → Top-K Chunks → LLM Context → Answer
```

**Production RAG (Cursor-style, code-aware):**
```
User Query → Embed → Hybrid Search (Vector + Regex) → Re-rank →
  → Metadata Filter → Local Retrieval → LLM Context → Answer
```

**Key differences:**
| Aspect | Basic RAG | Production Code RAG |
|--------|-----------|---------------------|
| Chunking | Fixed-size or paragraph | AST-based semantic |
| Storage | All data in vector DB | Embeddings only, source local |
| Search | Pure vector similarity | Hybrid (vector + keyword) |
| Updates | Full reindex | Incremental (Merkle tree) |
| Privacy | Unclear | Client-side obfuscation |

---

## 2. Core RAG Pipeline (Production-Grade)

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│ CLIENT SIDE (Your Machine)                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ 1. CHUNKING LAYER (Syntax-Aware)                           │
│    ├─ Code: AST-based semantic chunks (tree-sitter)        │
│    ├─ Papers: Paragraph/section-based chunks               │
│    └─ Logs: Structured log parsing                         │
│                                                             │
│ 2. EMBEDDING GENERATION                                     │
│    └─ Local embedding model OR API calls                   │
│                                                             │
│ 3. METADATA EXTRACTION                                      │
│    ├─ File paths (obfuscated before cloud upload)          │
│    ├─ Line ranges                                          │
│    ├─ Language/framework tags                              │
│    └─ Git commit hash (for versioning)                     │
│                                                             │
│ 4. CHANGE DETECTION                                         │
│    └─ Merkle tree of file hashes (incremental updates)     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ CLOUD SIDE (Vector Database)                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ 5. VECTOR STORAGE (Turbopuffer/Pinecone/Qdrant)            │
│    └─ Store: embeddings + obfuscated metadata              │
│                                                             │
│ 6. HYBRID SEARCH                                            │
│    ├─ Vector similarity (semantic)                         │
│    ├─ Keyword matching (BM25/full-text)                    │
│    └─ Metadata filters (file type, date range)             │
│                                                             │
│ 7. RE-RANKING (Optional)                                    │
│    └─ Small model refines top-K results                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ CLIENT SIDE (Your Machine)                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ 8. LOCAL RETRIEVAL                                          │
│    └─ Use metadata (file path + line range) to fetch       │
│       original source code from local filesystem           │
│                                                             │
│ 9. CONTEXT INJECTION                                        │
│    └─ Format retrieved chunks + user query into prompt     │
│                                                             │
│ 10. LLM GENERATION                                          │
│     └─ Generate answer grounded in retrieved context       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Privacy guarantee:** Source code never leaves your machine. Only embeddings + obfuscated metadata go to cloud.

---

## 3. Key Components (Deep Dive)

### 3.1 Semantic Code Chunking (Critical Innovation from Cursor)

**Problem:** Naive chunking breaks code mid-function, losing semantic coherence.

**Solution:** AST-based chunking that respects code structure.

#### How AST-Based Chunking Works

**Step 1:** Parse code into Abstract Syntax Tree (AST)
```python
# Source code
def train_model(model, loader, epochs=10):
    for epoch in range(epochs):
        for batch in loader:
            loss = model(batch)
            loss.backward()
    return model

# AST representation (simplified)
FunctionDef(name='train_model')
├─ arguments: [model, loader, epochs=10]
├─ ForLoop(range(epochs))
│  └─ ForLoop(loader)
│     ├─ Assign(loss = model(batch))
│     └─ Call(loss.backward())
└─ Return(model)
```

**Step 2:** Traverse AST and group nodes into chunks

**Chunking rules:**
- ✅ Keep entire functions together (unless >500 tokens)
- ✅ Keep classes together (unless >1000 tokens)
- ✅ Break at statement boundaries, not mid-expression
- ✅ Include docstrings with function definitions
- ❌ Never split inside a for-loop or if-block

**Implementation with tree-sitter (Python example):**

```python
from tree_sitter import Language, Parser
import tree_sitter_python

# Initialize parser
PY_LANGUAGE = Language(tree_sitter_python.language())
parser = Parser(PY_LANGUAGE)

def chunk_python_code(source_code: str, max_tokens: int = 500) -> list[dict]:
    """
    Chunk Python code semantically using AST.

    Returns:
        List of chunks with metadata:
        [{
            'content': str,  # The code chunk
            'start_line': int,
            'end_line': int,
            'node_type': str,  # 'function', 'class', 'module'
            'context': str  # Parent context (class name if method)
        }]
    """
    tree = parser.parse(bytes(source_code, "utf8"))
    chunks = []

    def traverse(node, parent_context=""):
        # Base case: leaf node or small enough
        if len(node.text.decode('utf8').split()) <= max_tokens:
            chunk = {
                'content': node.text.decode('utf8'),
                'start_line': node.start_point[0],
                'end_line': node.end_point[0],
                'node_type': node.type,
                'context': parent_context
            }
            chunks.append(chunk)
            return

        # Recursive case: split at semantic boundaries
        if node.type in ['function_definition', 'class_definition']:
            new_context = f"{parent_context}.{node.child_by_field_name('name').text.decode('utf8')}"

            # Try to keep whole function/class together
            if len(node.text.decode('utf8').split()) <= max_tokens * 2:
                chunk = {
                    'content': node.text.decode('utf8'),
                    'start_line': node.start_point[0],
                    'end_line': node.end_point[0],
                    'node_type': node.type,
                    'context': new_context
                }
                chunks.append(chunk)
                return

            # Too large, split children
            for child in node.children:
                traverse(child, new_context)
        else:
            # Split at statement boundaries
            for child in node.children:
                traverse(child, parent_context)

    traverse(tree.root_node)
    return chunks
```

**Why this matters for ML/CV:**

Your codebase has:
- Training loops (should stay together)
- Model definitions (class with forward method — keep together)
- Data preprocessing pipelines (multi-step functions)
- Config classes

**Example: Bad chunking vs. Good chunking**

❌ **Bad (arbitrary 200-token splits):**
```python
# Chunk 1 (broken mid-function)
def train_epoch(model, loader, optimizer, device):
    model.train()
    total_loss = 0.0
    for batch_idx, (images, labels) in enumerate(loader):
        images, labels = images.to(device), labels.to(device)
        optimizer.zero_grad()
        outputs = model(images)
        loss = F.cross_

# Chunk 2 (missing context)
_entropy(outputs, labels)
        loss.backward()
        optimizer.step()
        total_loss += loss.item()
    return total_loss / len(loader)
```

✅ **Good (semantic, function-level):**
```python
# Chunk 1 (complete function)
def train_epoch(model, loader, optimizer, device):
    """Train model for one epoch."""
    model.train()
    total_loss = 0.0
    for batch_idx, (images, labels) in enumerate(loader):
        images, labels = images.to(device), labels.to(device)
        optimizer.zero_grad()
        outputs = model(images)
        loss = F.cross_entropy(outputs, labels)
        loss.backward()
        optimizer.step()
        total_loss += loss.item()
    return total_loss / len(loader)
```

**Tools for AST-based chunking:**
- **tree-sitter:** Multi-language parser (Python, C++, Java, etc.)
- **Chonkie:** Lightweight Python library with `CodeChunker` class
- **Custom parsers:** Use language-specific AST modules (Python's `ast`, C++'s Clang)

---

### 3.2 Embeddings (Code vs. Text)

**Critical distinction:** Code embeddings ≠ Text embeddings

**Text embeddings (e.g., OpenAI `text-embedding-3-large`):**
- Optimized for: Natural language, semantics, paraphrasing
- Good for: Research papers, documentation, comments

**Code embeddings (e.g., Cursor's custom model, CodeBERT, GraphCodeBERT):**
- Optimized for: Syntax, code structure, variable naming
- Good for: Function retrieval, similar code search, bug detection

**Cursor's approach:** Custom-trained embedding model optimized for code semantics

**For ML/CV engineers — Embedding strategy:**

| Content Type | Embedding Model | Reasoning |
|--------------|-----------------|-----------|
| Python/C++ source code | CodeBERT or custom fine-tuned | Syntax-aware |
| Research papers (arXiv) | OpenAI `text-embedding-3-large` | Semantic understanding |
| Experiment logs (WandB) | OpenAI or lightweight model | Fast, general-purpose |
| CLAUDE.md knowledge base | OpenAI `text-embedding-3-large` | Pattern matching |
| Configuration files (YAML) | Same as code embeddings | Structure-aware |

**Implementation example:**

```python
from sentence_transformers import SentenceTransformer

# For code
code_model = SentenceTransformer('microsoft/codebert-base')
code_embedding = code_model.encode(code_chunk)

# For text
text_model = SentenceTransformer('sentence-transformers/all-mpnet-base-v2')
text_embedding = text_model.encode(paper_chunk)
```

**Key properties to preserve:**
- **Cosine similarity** between embeddings reflects semantic similarity
- **Dimensionality:** 768-1536 dims typical (balance between quality and storage)
- **Normalization:** Normalize vectors to unit length for cosine similarity

---

### 3.3 Vector Database (Production Considerations)

**Cursor uses:** Turbopuffer (serverless, fast ANN search)

**Alternatives for ML/CV engineers:**

| DB | Best For | Pros | Cons |
|----|----------|------|------|
| **FAISS** | Local, research | Fast, free, CPU/GPU | No metadata filtering, manual setup |
| **Qdrant** | Self-hosted production | Open-source, metadata filters, good docs | Requires server |
| **Pinecone** | Cloud-managed | Managed service, scales well | Costly for large indices |
| **Weaviate** | Hybrid search | Built-in hybrid search (vector + keyword) | Complex setup |
| **Chroma** | Local development | Simple API, persistent storage | Limited scale |

**For your use case (ML/CV + code + papers):**

**Recommendation:** **Qdrant** (self-hosted) or **Chroma** (local dev)

**Qdrant setup example:**

```python
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

# Initialize client
client = QdrantClient(url="http://localhost:6333")

# Create collection
client.create_collection(
    collection_name="ml_codebase",
    vectors_config=VectorParams(size=768, distance=Distance.COSINE),
)

# Insert chunks with metadata
points = [
    PointStruct(
        id=1,
        vector=embedding.tolist(),
        payload={
            "file_path": "src/models/resnet.py",
            "start_line": 45,
            "end_line": 78,
            "node_type": "function",
            "function_name": "forward",
            "language": "python",
            "git_hash": "a3f5b2c",
        }
    ),
    # ... more points
]
client.upsert(collection_name="ml_codebase", points=points)

# Search with metadata filter
results = client.search(
    collection_name="ml_codebase",
    query_vector=query_embedding,
    limit=5,
    query_filter={
        "must": [
            {"key": "language", "match": {"value": "python"}},
            {"key": "node_type", "match": {"value": "function"}}
        ]
    }
)
```

**Metadata schema for ML/CV codebase:**

```json
{
  "file_path": "src/models/resnet.py",
  "start_line": 45,
  "end_line": 78,
  "node_type": "function|class|method",
  "function_name": "forward",
  "class_name": "ResNet50",
  "language": "python|cpp|cuda",
  "framework": "pytorch|tensorflow|jax",
  "git_hash": "a3f5b2c",
  "last_modified": "2026-02-05T14:23:00Z",
  "imports": ["torch", "torchvision"],
  "dependencies": ["src.utils.metrics"],
  "tags": ["training", "inference", "optimization"]
}
```

**Why metadata matters:**
- Filter results by file type: "Show me only PyTorch model definitions"
- Filter by recency: "Use code from last 30 days"
- Filter by dependency: "Find functions that import cv2"

---

### 3.4 Hybrid Retrieval (Semantic + Keyword)

**Cursor's approach:** Combine vector search with `grep` and `ripgrep` for exact matches

**Why hybrid?**

**Pure vector search fails when:**
- User query uses exact function name (e.g., "find `train_epoch` function")
- Looking for specific error message (e.g., "RuntimeError: CUDA out of memory")
- Searching for exact class name (e.g., "ResNet50 definition")

**Pure keyword search fails when:**
- Conceptual queries (e.g., "code that handles class imbalance")
- Paraphrased queries (e.g., "focal loss" when code says "class-weighted CE")

**Hybrid approach:**

```python
def hybrid_search(
    query: str,
    vector_db,
    local_codebase_path: str,
    top_k: int = 10,
    semantic_weight: float = 0.7
) -> list[dict]:
    """
    Combine semantic vector search with keyword grep.

    Args:
        query: User's natural language query
        vector_db: Vector database client
        local_codebase_path: Path to local codebase
        top_k: Number of results to return
        semantic_weight: Weight for semantic results (0-1)

    Returns:
        Ranked list of code chunks with scores
    """
    # 1. Semantic search (vector similarity)
    query_embedding = embed_text(query)
    semantic_results = vector_db.search(
        query_vector=query_embedding,
        limit=top_k * 2  # Overquery for later fusion
    )

    # 2. Keyword search (regex/grep)
    # Extract likely keywords from query
    keywords = extract_keywords(query)  # e.g., ["train_epoch", "CUDA", "memory"]

    keyword_results = []
    for keyword in keywords:
        # Use ripgrep for fast search
        import subprocess
        rg_output = subprocess.run(
            ["rg", "--json", keyword, local_codebase_path],
            capture_output=True,
            text=True
        )
        keyword_results.extend(parse_ripgrep_json(rg_output.stdout))

    # 3. Reciprocal Rank Fusion (combine rankings)
    def rrf_score(rank: int, k: int = 60) -> float:
        """Reciprocal Rank Fusion score."""
        return 1.0 / (k + rank)

    combined_scores = {}

    # Add semantic results
    for rank, result in enumerate(semantic_results):
        chunk_id = result.id
        combined_scores[chunk_id] = combined_scores.get(chunk_id, 0) + \
            semantic_weight * rrf_score(rank)

    # Add keyword results
    for rank, result in enumerate(keyword_results):
        chunk_id = result['chunk_id']
        combined_scores[chunk_id] = combined_scores.get(chunk_id, 0) + \
            (1 - semantic_weight) * rrf_score(rank)

    # 4. Sort by combined score and return top-k
    ranked = sorted(combined_scores.items(), key=lambda x: x[1], reverse=True)
    return [fetch_chunk_content(chunk_id) for chunk_id, _ in ranked[:top_k]]
```

**Reciprocal Rank Fusion (RRF):** Standard technique for merging ranked lists

**Formula:**
```
RRF_score(chunk) = Σ 1 / (k + rank_i)
```
where `rank_i` is the rank of the chunk in retrieval method `i`, and `k=60` is a constant.

**Example:**

Query: "How to handle CUDA out of memory errors?"

**Semantic search results:**
1. `train_loop.py:45-78` (memory management code) — rank 1
2. `utils.py:120-145` (gradient checkpointing) — rank 2

**Keyword search results (grep "CUDA out of memory"):**
1. `train_loop.py:45-78` (try-except block) — rank 1
2. `README.md` (troubleshooting section) — rank 2

**Combined (RRF):**
1. `train_loop.py:45-78` — appears in both, highest score
2. `utils.py:120-145` — high semantic relevance
3. `README.md` — exact keyword match but lower semantic relevance

**When to use hybrid:**
- **Always for code search** (users mix exact names + concepts)
- **Optionally for papers** (if citation matching needed)
- **Skip for experiment logs** (pure vector search sufficient)

---

### 3.5 Re-ranking (Optional but Powerful)

**What:** Second-stage model that refines the top-K results from initial retrieval

**Why:** Initial retrieval (vector search) casts a wide net. Re-ranker scores relevance more precisely.

**Cursor likely uses:** Lightweight cross-encoder model

**How it works:**

```python
from sentence_transformers import CrossEncoder

# Initialize re-ranker
reranker = CrossEncoder('cross-encoder/ms-marco-MiniLM-L-6-v2')

def rerank_results(query: str, candidates: list[str], top_k: int = 5) -> list[str]:
    """
    Re-rank candidate chunks using cross-encoder.

    Args:
        query: User query
        candidates: List of code chunks from initial retrieval
        top_k: Number of final results

    Returns:
        Re-ranked top-k chunks
    """
    # Score each (query, candidate) pair
    pairs = [[query, chunk] for chunk in candidates]
    scores = reranker.predict(pairs)

    # Sort by score
    ranked_indices = np.argsort(scores)[::-1]
    return [candidates[i] for i in ranked_indices[:top_k]]
```

**Performance impact:**
- **Latency:** +50-100ms (acceptable for most use cases)
- **Accuracy:** +10-20% in relevance (significant improvement)

**When to skip re-ranking:**
- Low-latency requirements (<200ms total)
- Small result sets (top-3 already good)
- Simple keyword queries (exact matches)

**When to use re-ranking:**
- Complex conceptual queries
- Large candidate sets (top-50 → top-5)
- High precision requirements (debugging, critical code changes)

---

### 3.6 Incremental Updates with Merkle Trees

**Problem:** Codebase changes frequently. Full reindexing is expensive.

**Cursor's solution:** Merkle tree of file hashes to detect changes efficiently

**How Merkle trees work:**

```
Root Hash: H(H(file1) + H(file2) + H(file3) + H(file4))
           /                                  \
    H(H(file1) + H(file2))              H(H(file3) + H(file4))
       /            \                      /            \
    H(file1)     H(file2)            H(file3)       H(file4)
      |             |                   |              |
   file1.py      file2.py           file3.py       file4.py
```

**When `file2.py` changes:**
- Only need to update: H(file2), H(H(file1) + H(file2)), Root Hash
- No need to re-hash file1, file3, file4

**Implementation:**

```python
import hashlib
import json
from pathlib import Path

def hash_file(filepath: Path) -> str:
    """Compute SHA-256 hash of file content."""
    hasher = hashlib.sha256()
    with open(filepath, 'rb') as f:
        hasher.update(f.read())
    return hasher.hexdigest()

def build_merkle_tree(directory: Path) -> dict:
    """
    Build Merkle tree of directory.

    Returns:
        {
            'root_hash': str,
            'files': {filepath: file_hash},
            'tree': {parent_hash: [child_hashes]}
        }
    """
    files = {}
    for filepath in directory.rglob('*.py'):  # Adjust extensions
        files[str(filepath)] = hash_file(filepath)

    # Build tree bottom-up (simplified, pairs of hashes)
    current_level = list(files.values())
    tree = {}

    while len(current_level) > 1:
        next_level = []
        for i in range(0, len(current_level), 2):
            left = current_level[i]
            right = current_level[i+1] if i+1 < len(current_level) else left
            parent = hashlib.sha256((left + right).encode()).hexdigest()
            tree[parent] = [left, right]
            next_level.append(parent)
        current_level = next_level

    root_hash = current_level[0] if current_level else ""

    return {
        'root_hash': root_hash,
        'files': files,
        'tree': tree
    }

def detect_changes(old_tree: dict, new_tree: dict) -> dict:
    """
    Detect changed files by comparing Merkle trees.

    Returns:
        {
            'added': [filepaths],
            'modified': [filepaths],
            'deleted': [filepaths]
        }
    """
    old_files = set(old_tree['files'].keys())
    new_files = set(new_tree['files'].keys())

    added = new_files - old_files
    deleted = old_files - new_files

    modified = [
        f for f in old_files & new_files
        if old_tree['files'][f] != new_tree['files'][f]
    ]

    return {
        'added': list(added),
        'modified': modified,
        'deleted': list(deleted)
    }

def incremental_update(vector_db, old_tree: dict, new_tree: dict):
    """Update vector DB incrementally based on changed files."""
    changes = detect_changes(old_tree, new_tree)

    # Delete embeddings for modified/deleted files
    for filepath in changes['modified'] + changes['deleted']:
        vector_db.delete(filter={'file_path': filepath})

    # Add embeddings for added/modified files
    for filepath in changes['added'] + changes['modified']:
        chunks = chunk_file(filepath)  # Your chunking function
        embeddings = embed_chunks(chunks)  # Your embedding function
        vector_db.upsert(embeddings, metadata={'file_path': filepath})
```

**Performance comparison:**

| Codebase Size | Full Reindex | Incremental Update (1% files changed) |
|---------------|--------------|---------------------------------------|
| 1K files | 30 seconds | 0.3 seconds (100x faster) |
| 10K files | 5 minutes | 3 seconds (100x faster) |
| 100K files | 50 minutes | 30 seconds (100x faster) |

**When to use Merkle trees:**
- Large codebases (>1K files)
- Frequent changes (CI/CD pipelines)
- Real-time indexing requirements

**When to skip:**
- Small codebases (<100 files) — full reindex is fast enough
- Infrequent updates (weekly batch indexing)

---

### 3.7 Privacy-Preserving RAG (Cursor's Approach)

**Critical for ML/CV engineers:** Your code may contain proprietary algorithms, unreleased models, or sensitive data paths.

**Cursor's privacy model:**

1. **Source code NEVER leaves your machine** (only embeddings + metadata in cloud)
2. **File paths are obfuscated** before cloud upload
3. **Local retrieval** at inference time (metadata → source code)

**Path obfuscation implementation:**

```python
import hashlib
import hmac

class PathObfuscator:
    """Obfuscate file paths while preserving directory structure."""

    def __init__(self, secret_key: bytes):
        self.secret_key = secret_key

    def obfuscate_path(self, filepath: str) -> str:
        """
        Obfuscate path: src/models/resnet.py → a9f3/x72k/qp1m8d.f4

        Each component (directory, filename, extension) is hashed separately
        to preserve structure for filtering.
        """
        parts = filepath.replace('\\', '/').split('/')
        obfuscated_parts = []

        for part in parts:
            # Handle filename.extension separately
            if '.' in part and part != '.':
                name, ext = part.rsplit('.', 1)
                obf_name = self._hash_component(name)
                obf_ext = self._hash_component(ext)[:2]  # Short hash for ext
                obfuscated_parts.append(f"{obf_name}.{obf_ext}")
            else:
                obfuscated_parts.append(self._hash_component(part))

        return '/'.join(obfuscated_parts)

    def _hash_component(self, component: str) -> str:
        """Hash a single path component."""
        mac = hmac.new(self.secret_key, component.encode(), hashlib.sha256)
        return mac.hexdigest()[:8]  # First 8 chars for readability

# Usage
obfuscator = PathObfuscator(secret_key=b'your-secret-key')
original = "src/models/resnet.py"
obfuscated = obfuscator.obfuscate_path(original)
print(obfuscated)  # "a9f3b2c1/x72kp5q8/qp1m8d9f.f4"
```

**Privacy trade-offs:**

| Approach | Privacy | Functionality | Performance |
|----------|---------|---------------|-------------|
| **All local (no cloud)** | Maximum | Limited (no cross-device sync) | Slow (local vector search) |
| **Obfuscated metadata** | High | Full features | Fast (cloud vector DB) |
| **Full plaintext in cloud** | Low | Full features | Fast |

**For ML/CV engineers:**

**Recommendation:** Use obfuscated metadata approach (like Cursor) for:
- Proprietary model architectures
- Custom training pipelines
- Client project code

**Use local-only RAG for:**
- Highly sensitive data (medical imaging paths, patient IDs)
- Regulated industries (HIPAA, GDPR)
- Security research

**Implementation checklist:**
- [ ] Store only embeddings in cloud vector DB
- [ ] Obfuscate file paths before upload
- [ ] Use .cursorignore / .ragignore to exclude sensitive files
- [ ] Retrieve source code locally at inference time
- [ ] Log which files were sent to cloud (audit trail)

---

## 4. RAG Failure Modes (Expanded with Solutions)

| Problem | Cause | Detection | Solution |
|---------|-------|-----------|----------|
| **Irrelevant results** | Bad chunking OR embedding mismatch | User feedback, low similarity scores | • Use semantic chunking<br>• Fine-tune embedding model<br>• Add metadata filtering |
| **Hallucinations** | LLM ignores context | Compare answer with retrieved chunks | • Stronger prompt instructions<br>• Citation requirement<br>• Confidence scores |
| **Missing information** | Retrieval missed key chunk | Known answer not in results | • Lower similarity threshold<br>• Increase top-K<br>• Add hybrid search |
| **Long prompts** | Too many chunks included | Context length errors | • Better re-ranking<br>• Chunk pruning<br>• Summarize before injection |
| **Stale data** | Index not updated | Out-of-date answers | • Incremental updates (Merkle tree)<br>• Timestamp metadata<br>• Automatic reindexing |
| **Slow retrieval** | Large vector DB, no indexing | High latency (>500ms) | • Use approximate NN (FAISS/Annoy)<br>• Caching<br>• Metadata pre-filtering |
| **Poor code retrieval** | Text-optimized embeddings | Exact function names not found | • Use code-specific embeddings<br>• Add keyword search<br>• AST-based chunking |

---

## 5. Prompt Design for RAG (ML/CV Focus)

**Cursor's insight:** Even perfect retrieval fails if the prompt doesn't force the LLM to use the context properly.

### 5.1 Instruction Layer (Critical)

**Bad prompt (LLM will hallucinate):**
```
Here's some code related to your question:
[Code chunks]

Question: How do I implement focal loss?
```

**Good prompt (forces grounding):**
```
You are an ML engineering assistant. Answer ONLY using the code provided below.
If the answer is not in the code, say "The retrieved code does not contain this information."

RETRIEVED CODE:
---
File: src/losses.py (lines 45-78)
def focal_loss(logits, targets, alpha=0.25, gamma=2.0):
    ce_loss = F.cross_entropy(logits, targets, reduction='none')
    pt = torch.exp(-ce_loss)
    focal_loss = alpha * (1 - pt) ** gamma * ce_loss
    return focal_loss.mean()
---

QUESTION: How do I implement focal loss in PyTorch?

INSTRUCTIONS:
1. Answer using ONLY the code above
2. Cite the file and line numbers
3. If information is missing, explicitly state what's missing
4. Do not invent code or facts
```

### 5.2 Structured Context Formatting

**Template for code retrieval:**

```markdown
# RETRIEVED CODE CONTEXT

## File: {file_path} (lines {start_line}-{end_line})
```{language}
{code_chunk}
```

## File: {file_path} (lines {start_line}-{end_line})
```{language}
{code_chunk}
```

# USER QUESTION
{query}

# INSTRUCTIONS
- Answer using ONLY the code above
- Cite specific files and line numbers
- If information is missing, state: "Not found in retrieved code"
- Include working code examples when possible
```

### 5.3 Citation Prompting

**Force the model to cite sources:**

```
For each statement in your answer, cite the source file and line numbers in brackets.

Example:
"The focal loss implementation uses alpha=0.25 by default [src/losses.py:46]"
```

**Benefit:** Reduces hallucinations by 40-60% (empirical observation in production RAG systems)

### 5.4 Chain-of-Thought for Code Understanding

**For complex queries, use two-step reasoning:**

```
# STEP 1: Extract relevant information
First, identify which code chunks are relevant to the question.
List the file paths and key functions/classes.

# STEP 2: Answer the question
Using the relevant code from Step 1, answer the user's question.
```

**Example:**

Query: "How does the training loop handle CUDA out of memory errors?"

**Step 1 output:**
```
Relevant code:
- src/train.py (lines 120-145): train_epoch() function
- src/utils.py (lines 78-92): enable_gradient_checkpointing() function

Key pattern: try-except block catches RuntimeError, reduces batch size
```

**Step 2 output:**
```
The training loop handles OOM errors in train_epoch() [src/train.py:120-145] using:
1. Try-except block catches RuntimeError [line 130]
2. Reduces batch size by half [line 135]
3. Enables gradient checkpointing [src/utils.py:78-92]
4. Retries with smaller batch [line 140]
```

### 5.5 Failure Handling (Uncertainty)

**Teach the model to admit when context is insufficient:**

```
If the retrieved code does not contain enough information to answer the question:
1. State clearly: "The retrieved code does not contain [specific missing information]"
2. Suggest what to search for next
3. DO NOT invent code or make assumptions

Example of good failure response:
"The retrieved code does not contain the focal loss backward pass implementation.
Try searching for 'focal_loss.backward()' or 'FocalLoss autograd function'."
```

---

## 6. Advanced RAG for ML/CV Engineering

### 6.1 Multi-Modal RAG (Code + Papers + Experiment Logs)

**Challenge:** Your knowledge base contains:
- Code (Python, C++, CUDA)
- Papers (PDFs, LaTeX)
- Experiment logs (WandB, TensorBoard)
- Config files (YAML, JSON)

**Solution:** Multiple embedding models + fusion

```python
class MultiModalRAG:
    """RAG system for code, papers, and logs."""

    def __init__(self):
        self.code_embedder = SentenceTransformer('microsoft/codebert-base')
        self.text_embedder = SentenceTransformer('all-mpnet-base-v2')
        self.vector_db = QdrantClient()

    def index_codebase(self, code_dir: Path):
        """Index code with AST-based chunking."""
        for file in code_dir.rglob('*.py'):
            chunks = chunk_python_code(file.read_text())
            for chunk in chunks:
                embedding = self.code_embedder.encode(chunk['content'])
                self.vector_db.upsert(
                    collection_name="code",
                    points=[{
                        'vector': embedding,
                        'payload': {
                            'content': chunk['content'],
                            'file_path': str(file),
                            'type': 'code',
                            **chunk  # Include AST metadata
                        }
                    }]
                )

    def index_papers(self, papers_dir: Path):
        """Index research papers."""
        for pdf in papers_dir.glob('*.pdf'):
            text = extract_text_from_pdf(pdf)
            chunks = chunk_paper_by_section(text)
            for chunk in chunks:
                embedding = self.text_embedder.encode(chunk['content'])
                self.vector_db.upsert(
                    collection_name="papers",
                    points=[{
                        'vector': embedding,
                        'payload': {
                            'content': chunk['content'],
                            'file_path': str(pdf),
                            'type': 'paper',
                            'section': chunk['section']
                        }
                    }]
                )

    def hybrid_search(self, query: str, search_types: list[str]) -> list:
        """
        Search across multiple modalities.

        Args:
            query: User query
            search_types: ['code', 'paper', 'logs']
        """
        results = []

        if 'code' in search_types:
            code_emb = self.code_embedder.encode(query)
            code_results = self.vector_db.search(
                collection_name="code",
                query_vector=code_emb,
                limit=5
            )
            results.extend(code_results)

        if 'paper' in search_types:
            text_emb = self.text_embedder.encode(query)
            paper_results = self.vector_db.search(
                collection_name="papers",
                query_vector=text_emb,
                limit=5
            )
            results.extend(paper_results)

        # Fuse results using RRF
        return reciprocal_rank_fusion(results)
```

### 6.2 Query Rewriting (Improve Retrieval)

**Problem:** User queries are often poorly phrased for retrieval

**Example:**
- User: "why is my model not learning?"
- Better query: "training loss not decreasing, gradient issues, learning rate problems"

**Solution:** Use LLM to rewrite query before retrieval

```python
def rewrite_query(original_query: str) -> str:
    """
    Use LLM to expand and clarify query for better retrieval.
    """
    prompt = f"""
    You are a query optimization system for code search.

    Original query: "{original_query}"

    Rewrite this query to improve code retrieval:
    1. Expand with technical terms
    2. Add relevant function/class names
    3. Include common error patterns
    4. List 3-5 keyword variations

    Output format (one line, comma-separated):
    <keyword1>, <keyword2>, <keyword3>, ...
    """

    response = call_llm(prompt)
    return response.strip()

# Example usage
original = "why is my model not learning?"
rewritten = rewrite_query(original)
# Output: "training loss plateau, vanishing gradients, learning rate too high,
#          optimizer not updating, dead ReLU, gradient clipping, loss.backward()"
```

### 6.3 Memory-Augmented RAG (Conversation History)

**For multi-turn conversations, include past context:**

```python
class ConversationalRAG:
    """RAG with conversation history."""

    def __init__(self):
        self.rag = MultiModalRAG()
        self.conversation_history = []

    def answer(self, query: str) -> str:
        """Answer query with conversation context."""

        # 1. Augment query with conversation history
        augmented_query = self._augment_with_history(query)

        # 2. Retrieve relevant chunks
        chunks = self.rag.hybrid_search(augmented_query, ['code', 'paper'])

        # 3. Build prompt with history
        prompt = self._build_prompt_with_history(query, chunks)

        # 4. Generate answer
        answer = call_llm(prompt)

        # 5. Update history
        self.conversation_history.append({
            'query': query,
            'answer': answer,
            'retrieved_chunks': [c['payload']['file_path'] for c in chunks]
        })

        return answer

    def _augment_with_history(self, query: str) -> str:
        """Add context from previous turns."""
        if not self.conversation_history:
            return query

        # Include last 2 turns for context
        recent = self.conversation_history[-2:]
        context = " ".join([
            f"Previous: {turn['query']}" for turn in recent
        ])

        return f"{context} Current: {query}"

    def _build_prompt_with_history(self, query: str, chunks: list) -> str:
        """Build prompt including conversation history."""
        history_text = "\n".join([
            f"Q: {turn['query']}\nA: {turn['answer']}"
            for turn in self.conversation_history[-3:]  # Last 3 turns
        ])

        chunks_text = "\n\n".join([
            f"File: {c['payload']['file_path']}\n```\n{c['payload']['content']}\n```"
            for c in chunks
        ])

        return f"""
# CONVERSATION HISTORY
{history_text}

# RETRIEVED CODE
{chunks_text}

# CURRENT QUESTION
{query}

# INSTRUCTIONS
Answer using the retrieved code and conversation history.
Maintain consistency with previous answers.
"""
```

### 6.4 Tool-Augmented RAG (Execute Code)

**For ML/CV, allow the agent to:**
- Run experiments
- Check GPU memory
- Visualize data

```python
class ToolAugmentedRAG:
    """RAG that can call tools."""

    def __init__(self):
        self.rag = MultiModalRAG()
        self.tools = {
            'run_python': self._run_python,
            'check_gpu': self._check_gpu,
            'visualize_data': self._visualize_data
        }

    def answer_with_tools(self, query: str) -> str:
        """Answer query, using tools if needed."""

        # 1. Retrieve code
        chunks = self.rag.hybrid_search(query, ['code'])

        # 2. Decide if tools needed
        needs_execution = self._needs_execution(query)

        if needs_execution:
            # 3. Extract code to run
            code_to_run = self._extract_executable_code(chunks)

            # 4. Execute and get results
            execution_results = self.tools['run_python'](code_to_run)

            # 5. Build prompt with results
            prompt = f"""
Retrieved code:
{chunks}

Execution results:
{execution_results}

Question: {query}

Answer using both the code and execution results.
"""
        else:
            prompt = f"""
Retrieved code:
{chunks}

Question: {query}
"""

        return call_llm(prompt)

    def _run_python(self, code: str) -> str:
        """Execute Python code in sandbox."""
        # Use Docker or subprocess for isolation
        import subprocess
        result = subprocess.run(
            ['python', '-c', code],
            capture_output=True,
            text=True,
            timeout=10
        )
        return f"Output: {result.stdout}\nErrors: {result.stderr}"

    def _check_gpu(self) -> str:
        """Check GPU memory."""
        import subprocess
        result = subprocess.run(
            ['nvidia-smi', '--query-gpu=memory.used,memory.total', '--format=csv'],
            capture_output=True,
            text=True
        )
        return result.stdout
```

---

## 7. Practical Implementation Guide for ML/CV Engineers

### 7.1 Minimal RAG Setup (Start Here)

**Goal:** Get a working RAG system in <1 hour

```bash
# Install dependencies
pip install sentence-transformers qdrant-client tree-sitter tree-sitter-python
```

**Minimal implementation:**

```python
# minimal_rag.py
from sentence_transformers import SentenceTransformer
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct
import tree_sitter_python
from tree_sitter import Language, Parser
from pathlib import Path

# 1. Initialize
PY_LANGUAGE = Language(tree_sitter_python.language())
parser = Parser(PY_LANGUAGE)
embedder = SentenceTransformer('all-mpnet-base-v2')
client = QdrantClient(":memory:")  # In-memory for testing

# 2. Create collection
client.create_collection(
    collection_name="code",
    vectors_config=VectorParams(size=768, distance=Distance.COSINE)
)

# 3. Index codebase
def index_file(filepath: Path, file_id: int):
    """Index a single Python file."""
    code = filepath.read_text()
    tree = parser.parse(bytes(code, "utf8"))

    # Extract functions
    functions = []
    def extract_functions(node):
        if node.type == 'function_definition':
            functions.append({
                'content': node.text.decode('utf8'),
                'start_line': node.start_point[0],
                'end_line': node.end_point[0]
            })
        for child in node.children:
            extract_functions(child)

    extract_functions(tree.root_node)

    # Embed and store
    for i, func in enumerate(functions):
        embedding = embedder.encode(func['content'])
        client.upsert(
            collection_name="code",
            points=[PointStruct(
                id=file_id * 1000 + i,
                vector=embedding.tolist(),
                payload={
                    'content': func['content'],
                    'file': str(filepath),
                    'lines': f"{func['start_line']}-{func['end_line']}"
                }
            )]
        )

# 4. Search
def search(query: str, top_k: int = 3):
    """Search for relevant code."""
    query_vec = embedder.encode(query)
    results = client.search(
        collection_name="code",
        query_vector=query_vec.tolist(),
        limit=top_k
    )

    for result in results:
        print(f"\nFile: {result.payload['file']}")
        print(f"Lines: {result.payload['lines']}")
        print(f"Score: {result.score:.3f}")
        print(f"Code:\n{result.payload['content'][:200]}...")

# 5. Usage
if __name__ == "__main__":
    # Index your codebase
    code_dir = Path("src/")
    for i, py_file in enumerate(code_dir.rglob("*.py")):
        index_file(py_file, i)

    # Search
    search("how to train a model with focal loss")
```

**Test it:**
```bash
python minimal_rag.py
```

### 7.2 Production RAG Checklist

**Before deploying RAG to production:**

- [ ] **Chunking**
  - [ ] Use AST-based semantic chunking for code
  - [ ] Test chunk quality (manual review of 50 chunks)
  - [ ] Verify no broken functions/classes

- [ ] **Embeddings**
  - [ ] Use code-specific embeddings (CodeBERT) for code
  - [ ] Use text embeddings (OpenAI) for papers/docs
  - [ ] Normalize vectors to unit length

- [ ] **Vector Database**
  - [ ] Set up persistent storage (not in-memory)
  - [ ] Add metadata schema (file path, language, framework)
  - [ ] Implement backup/restore

- [ ] **Retrieval**
  - [ ] Implement hybrid search (vector + keyword)
  - [ ] Add re-ranking for top-K results
  - [ ] Set similarity threshold (e.g., 0.7)

- [ ] **Prompt Engineering**
  - [ ] Force grounding in retrieved context
  - [ ] Require citations
  - [ ] Handle "information not found" cases

- [ ] **Updates**
  - [ ] Implement incremental indexing (Merkle tree)
  - [ ] Set up automatic reindexing (cron job or git hook)
  - [ ] Version embeddings (track model changes)

- [ ] **Privacy**
  - [ ] Obfuscate file paths before cloud upload
  - [ ] Store source code locally only
  - [ ] Add .ragignore for sensitive files

- [ ] **Monitoring**
  - [ ] Log retrieval latency
  - [ ] Track similarity scores
  - [ ] Monitor hallucination rate (user feedback)

- [ ] **Testing**
  - [ ] Unit tests for chunking logic
  - [ ] Integration tests for search pipeline
  - [ ] End-to-end tests with real queries

---

## 8. RAG for CLAUDE.md (Meta-Level)

**Your CLAUDE.md is itself a knowledge base!**

**Use RAG to retrieve relevant patterns/mistakes before each task:**

```python
class CLAUDEmdRAG:
    """RAG system for CLAUDE.md patterns and mistakes."""

    def __init__(self, claude_md_path: Path):
        self.embedder = SentenceTransformer('all-mpnet-base-v2')
        self.client = QdrantClient(":memory:")
        self.client.create_collection(
            collection_name="claude_knowledge",
            vectors_config=VectorParams(size=768, distance=Distance.COSINE)
        )
        self._index_claude_md(claude_md_path)

    def _index_claude_md(self, path: Path):
        """Index patterns and mistakes from CLAUDE.md."""
        content = path.read_text()

        # Extract pattern sections
        patterns = self._extract_sections(content, "### Pattern:")
        for i, pattern in enumerate(patterns):
            emb = self.embedder.encode(pattern)
            self.client.upsert(
                collection_name="claude_knowledge",
                points=[PointStruct(
                    id=i,
                    vector=emb.tolist(),
                    payload={'type': 'pattern', 'content': pattern}
                )]
            )

        # Extract mistake sections
        mistakes = self._extract_sections(content, "### Mistake:")
        for i, mistake in enumerate(mistakes, start=len(patterns)):
            emb = self.embedder.encode(mistake)
            self.client.upsert(
                collection_name="claude_knowledge",
                points=[PointStruct(
                    id=i,
                    vector=emb.tolist(),
                    payload={'type': 'mistake', 'content': mistake}
                )]
            )

    def get_relevant_patterns(self, task_description: str, top_k: int = 3) -> list:
        """Retrieve patterns relevant to current task."""
        query_vec = self.embedder.encode(task_description)
        results = self.client.search(
            collection_name="claude_knowledge",
            query_vector=query_vec.tolist(),
            query_filter={'must': [{'key': 'type', 'match': {'value': 'pattern'}}]},
            limit=top_k
        )
        return [r.payload['content'] for r in results]

    def get_relevant_mistakes(self, task_description: str, top_k: int = 3) -> list:
        """Retrieve mistakes relevant to current task."""
        query_vec = self.embedder.encode(task_description)
        results = self.client.search(
            collection_name="claude_knowledge",
            query_vector=query_vec.tolist(),
            query_filter={'must': [{'key': 'type', 'match': {'value': 'mistake'}}]},
            limit=top_k
        )
        return [r.payload['content'] for r in results]

# Usage before starting a task
rag = CLAUDEmdRAG(Path("CLAUDE.md"))
task = "Implement focal loss with gradient verification"

patterns = rag.get_relevant_patterns(task)
print("Relevant patterns to apply:")
for p in patterns:
    print(f"- {p[:100]}...")

mistakes = rag.get_relevant_mistakes(task)
print("\nMistakes to avoid:")
for m in mistakes:
    print(f"- {m[:100]}...")
```

**Integrate with prompt template:**

In your `prompt-template.md`, add:

```markdown
### Knowledge from CLAUDE.md (Auto-Retrieved via RAG)

**Relevant patterns to apply:**
{rag.get_relevant_patterns(task_description)}

**Relevant mistakes to avoid:**
{rag.get_relevant_mistakes(task_description)}
```

---

## 9. Summary: Key Takeaways for ML/CV Engineers

### Critical Insights from Cursor

1. **Semantic chunking > arbitrary chunking**
   - Use AST-based chunking for code
   - Respect function/class boundaries
   - Tool: tree-sitter or Chonkie

2. **Hybrid retrieval > pure vector search**
   - Combine semantic (embeddings) + keyword (grep/regex)
   - Use Reciprocal Rank Fusion to merge results

3. **Privacy-preserving architecture**
   - Store embeddings in cloud, source code locally
   - Obfuscate file paths
   - Retrieve original content at inference time

4. **Incremental updates are essential**
   - Use Merkle trees for change detection
   - Update only changed files (100x faster)

5. **Prompt engineering is critical**
   - Force LLM to use retrieved context
   - Require citations
   - Handle uncertainty explicitly

### Recommended Stack for ML/CV

**Minimal (local development):**
- Chunking: tree-sitter + custom logic
- Embeddings: sentence-transformers (all-mpnet-base-v2)
- Vector DB: Chroma (persistent local storage)
- Search: Pure vector search

**Production (scalable):**
- Chunking: AST-based (tree-sitter) + metadata extraction
- Embeddings: CodeBERT (code) + OpenAI (text)
- Vector DB: Qdrant (self-hosted) or Pinecone (managed)
- Search: Hybrid (vector + ripgrep) + re-ranking
- Updates: Merkle tree for incremental indexing
- Privacy: Path obfuscation + local source storage

### Implementation Priority

**Phase 1 (Week 1):** Minimal RAG
- [ ] Index codebase with basic chunking
- [ ] Vector search with top-5 results
- [ ] Test with 10 sample queries

**Phase 2 (Week 2):** Improve retrieval
- [ ] Add AST-based chunking
- [ ] Implement hybrid search
- [ ] Add metadata filtering

**Phase 3 (Week 3):** Production features
- [ ] Incremental updates (Merkle tree)
- [ ] Re-ranking layer
- [ ] Path obfuscation

**Phase 4 (Week 4):** Advanced
- [ ] Multi-modal (code + papers + logs)
- [ ] Conversation history
- [ ] Tool augmentation

### Resources

**Tools:**
- Chunking: [Chonkie](https://docs.chonkie.ai/), tree-sitter
- Embeddings: sentence-transformers, OpenAI API
- Vector DBs: Qdrant, Chroma, FAISS
- Search: ripgrep, BM25

**Papers:**
- "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks" (Lewis et al., 2020)
- "CodeBERT: A Pre-Trained Model for Programming and Natural Languages" (Feng et al., 2020)

**Example Projects:**
- Cursor's engineering blog: https://cursor.com/blog
- Continue.dev (open-source coding assistant)
- OpenCode (terminal-based coding agent)

---

## 10. Next Steps

**To integrate this into your workflow:**

1. **Update prompt-template.md** to include RAG retrieval step
2. **Create RAG configuration in CLAUDE.md** (chunking strategy, embedding model)
3. **Index your current ML/CV codebase** using minimal RAG setup
4. **Test retrieval quality** with 20 real queries from your work
5. **Iterate on chunking/retrieval** based on results

**Questions to explore next:**
- How to handle very large files (>10K lines)?
- How to chunk Jupyter notebooks effectively?
- How to integrate with Weights & Biases logs?
- How to version embeddings when code changes?

---

**Last updated:** 2026-02-05
**Version:** 2.0 (Production RAG + Cursor insights)
**Status:** Ready for integration with atomic task loop
