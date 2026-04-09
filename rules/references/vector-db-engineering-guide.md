# Vector Databases for ML/CV Engineering
## The No-BS Engineering Reference

> **For:** Robotics Perception Engineers, ML/CV practitioners building production systems
> **Focus:** ANN structures, data plumbing, real-world tradeoffs
> **Anti-goal:** Marketing fluff, surface-level tutorials

---

## 🎯 The Core Mental Model

Vector databases are **NOT** traditional databases. They're:

```
┌─────────────────────────────────────────────────────────────┐
│  Embedding Model                                            │
│       ↓                                                     │
│  float32[n] dense vector                                    │
│       ↓                                                     │
│  ID Mapping Layer (hash map: vector_id → metadata)         │
│       ↓                                                     │
│  ANN Index (HNSW/IVF/PQ graph structures)                  │
│       ↓                                                     │
│  Metadata Index (inverted/B-tree for filtering)            │
│       ↓                                                     │
│  Filtered Similarity Search                                 │
│       ↓                                                     │
│  Re-ranking (optional: cross-encoders, business logic)     │
│       ↓                                                     │
│  Final Results                                              │
└─────────────────────────────────────────────────────────────┘
```

**Engineering truth:**
- **50%** = ANN graph/index structures (HNSW, IVF, PQ)
- **50%** = Data plumbing (ID mapping, metadata indices, serialization)

---

## 📘 Essential References (No Fluff)

### Foundation Layer (Must Read)

1. **"Efficient and Robust Approximate Nearest Neighbor Search Using Hierarchical Navigable Small World Graphs"**
   *Authors:* Malkov & Yashunin
   *Why:* HNSW is the dominant ANN index in 90% of production vector DBs
   *What you learn:* Graph construction, layer hierarchy, greedy search, ef/efConstruction tuning

2. **FAISS Documentation** (Meta AI)
   *Link:* `github.com/facebookresearch/faiss`
   *Why:* Reference implementation for IVF, PQ, HNSW
   *What you learn:* Practical vector indexing, quantization, GPU acceleration

3. **"Designing Data-Intensive Applications"** — Martin Kleppmann
   *Why:* Not vector-specific, but essential for understanding indexing, storage engines, consistency tradeoffs that vector DBs inherit
   *Critical chapters:* 3 (Storage and Retrieval), 6 (Partitioning)

### System Design Layer

4. **Pinecone Learn / Documentation**
   *Focus areas:* Filtering strategies, namespace design, hybrid search
   *Engineering value:* Best explanations of production concerns (not just theory)

5. **Weaviate Concepts Documentation**
   *Focus areas:* Vector + metadata + schema co-design
   *Engineering value:* Mental models for structuring multi-modal data

6. **Milvus Architecture Docs**
   *Focus areas:* Storage layers, index lifecycle, compaction strategies
   *Engineering value:* Deep dive into distributed vector DB internals

### Practical Wisdom

7. **Academic Surveys:** "A Survey on Vector Databases" (recent)
   *Why:* Taxonomy of ANN structures and recall/latency/memory tradeoffs

8. **Erik Bernhardsson Talks**
   *Background:* Creator of Spotify's Annoy index, former Pinecone engineering lead
   *Why:* Excellent mental models for similarity search at scale

---

## 🧠 Critical Data Structures

### 1. Dense Vectors (Embedding Arrays)

**Structure:**
```python
np.ndarray[float32, shape=(n_dims,)]  # Fixed-length vector
```

**Engineering concerns:**
- **Memory layout:** Contiguous vs strided affects cache performance
- **Alignment:** SIMD operations require 16/32-byte alignment
- **dtype precision:** float32 is standard (float16 for compression, loses accuracy)
- **Serialization:** Must preserve order & precision bit-exactly

**Common representations:**
```python
# NumPy (CPU)
embedding = np.array([0.1, 0.2, ...], dtype=np.float32)

# PyTorch (GPU-friendly)
embedding = torch.tensor([0.1, 0.2, ...], dtype=torch.float32)

# Flat buffer (network transfer)
embedding_bytes = struct.pack(f'{n_dims}f', *embedding)
```

**Gotcha:** Normalization matters for cosine similarity. L2-normalize before insertion if using inner product index.

---

### 2. Vector ID Mapping

**Purpose:** Link vector embeddings back to original objects

**Structure:**
```
vector_id (int64 or UUID) → metadata → raw object reference
```

**Implementation:**
- Hash maps (O(1) lookup)
- Key-value stores (Redis, RocksDB)

**Example schema:**
```python
{
  "vector_id": "uuid-123",
  "metadata": {
    "image_path": "s3://bucket/img.jpg",
    "class_label": "dog",
    "timestamp": 1638360000,
    "bbox": [x, y, w, h]
  },
  "embedding": [0.1, 0.2, ...]  # Or reference to vector store
}
```

**Engineering pattern:**
```python
# After ANN search returns IDs
candidate_ids = index.search(query_vector, k=100)

# Fast metadata lookup
results = [id_mapping[vid] for vid in candidate_ids]
```

---

### 3. Metadata Index Structures (Secondary Indices)

**Problem:** Vectors alone are insufficient. You need to filter by:
- Class labels (categorical)
- Timestamps (range)
- User IDs (equality)
- Spatial regions (geospatial)

**Solutions:**

| Index Type | Use Case | Example Query |
|------------|----------|---------------|
| **Inverted Index** | Categorical filtering | `class_label = "dog"` |
| **B-tree / LSM tree** | Range queries | `timestamp > 2024-01-01` |
| **Bitmap Index** | Boolean filtering | `is_verified = true` |
| **R-tree** | Geospatial | `within_radius(lat, lon, 10km)` |

**Production reality:**
Vector DBs combine **ANN index + metadata index**. Query flow:

```
1. Filter by metadata → candidate set (1M → 100K vectors)
2. ANN search on filtered set → top-k results (100K → 100)
3. Re-rank by business logic → final results (100 → 10)
```

**Tradeoff:** Pre-filter vs post-filter
- **Pre-filter:** Faster if filter reduces candidates significantly
- **Post-filter:** Better recall if filter is selective

---

### 4. ANN Index Structures (The Core Engine)

You **cannot** brute-force search billions of vectors at query time. You need approximate nearest neighbor (ANN) indices.

#### **HNSW (Hierarchical Navigable Small World)**

**Structure:** Multi-layer graph
```
Layer 2:  ●━━━●━━━●  (sparse, long-range connections)
          ┃   ┃   ┃
Layer 1:  ●━●━●━●━●  (denser)
          ┃ ┃ ┃ ┃ ┃
Layer 0:  ●━●━●━●━●━●━●  (all vectors, short-range)
```

**How it works:**
1. Start at top layer (sparse)
2. Greedy search for closest node
3. Drop down layers (increasing density)
4. Final layer: exhaustive local search

**Tuning parameters:**
- `M`: Max connections per node (16-64 typical)
- `efConstruction`: Candidate pool size during build (100-500)
- `ef`: Candidate pool size during search (50-200)

**Tradeoffs:**
- Higher `M` → better recall, more memory, slower build
- Higher `ef` → better recall, slower search

**Use when:** High recall required, memory available

---

#### **IVF (Inverted File Index)**

**Structure:** k-means clustering + inverted lists
```
Cluster 0: [vec_1, vec_5, vec_9, ...]
Cluster 1: [vec_2, vec_7, vec_12, ...]
Cluster 2: [vec_3, vec_8, vec_15, ...]
...
```

**How it works:**
1. Train k-means on dataset (e.g., 4096 clusters)
2. Assign each vector to nearest cluster
3. At query time: search only `nprobe` nearest clusters

**Tuning parameters:**
- `nlist`: Number of clusters (sqrt(N) to N/100)
- `nprobe`: Clusters to search (1-100)

**Tradeoffs:**
- Higher `nprobe` → better recall, slower search
- More clusters → faster search, requires more training data

**Use when:** Very large datasets (100M+ vectors), can tolerate recall loss

---

#### **PQ (Product Quantization)**

**Structure:** Compression via vector quantization
```
Original vector [768 dims] →
  Subvector 1 [96 dims] → centroid_id: 42
  Subvector 2 [96 dims] → centroid_id: 13
  ...
  Subvector 8 [96 dims] → centroid_id: 201

Compressed: [42, 13, ..., 201]  (8 bytes instead of 3072 bytes)
```

**How it works:**
1. Split vector into `m` subvectors (e.g., 8)
2. Train k-means codebook for each subvector (e.g., 256 centroids)
3. Replace subvector with centroid ID (1 byte)
4. Distance computed in compressed space

**Tradeoffs:**
- 10-30x memory reduction
- 10-20% recall loss
- Faster search (less data to load)

**Use when:** Memory-constrained, billions of vectors

---

#### **LSH (Locality Sensitive Hashing)**

**Structure:** Hash functions that preserve similarity
```
h(v) = sign(v · r)  (random projection)
```

**How it works:**
1. Generate random projection vectors
2. Hash vectors into buckets
3. Search only matching buckets

**Tradeoffs:**
- Very fast build
- Lower recall than HNSW/IVF
- Good for high-dimensional spaces (>1000 dims)

**Use when:** Streaming data, need fast updates

---

### Comparison Matrix

| Index | Build Time | Search Time | Memory | Recall | Updates |
|-------|-----------|-------------|--------|--------|---------|
| **HNSW** | Slow | Fast | High | Excellent | Slow |
| **IVF** | Medium | Medium | Medium | Good | Medium |
| **PQ** | Medium | Fast | Low | Fair | Slow |
| **LSH** | Fast | Medium | Low | Fair | Fast |

**Production pattern:** Combine strategies
```
IVF256,PQ8  → Cluster into 256 partitions, then compress with 8-byte PQ
HNSW32,Flat → HNSW graph with full-precision vectors
```

---

### 5. Internal Search Structures

**Adjacency Lists (HNSW graphs):**
```python
graph[node_id] = {
  "layer_0": [neighbor_1, neighbor_2, ...],
  "layer_1": [neighbor_5, neighbor_9],
  "layer_2": [neighbor_15]
}
```

**Cluster Assignment Lists (IVF):**
```python
inverted_lists[cluster_id] = [vec_id_1, vec_id_2, ...]
```

**Priority Queues (Best-first search):**
```python
import heapq
candidates = [(distance, vec_id), ...]
heapq.heappush(candidates, (new_dist, new_id))
```

---

### 6. Serialization Formats

**Problem:** Move vectors between model → storage → network → index

| Format | Size | Speed | Use Case |
|--------|------|-------|----------|
| **Flat binary** | Raw | Fastest | Local disk, mmap |
| **NumPy `.npy`** | Raw + header | Fast | Python ecosystems |
| **Apache Arrow** | Columnar | Fast | Cross-language, batch transfer |
| **Protobuf** | Compressed | Medium | Network payloads |
| **MsgPack** | Compressed | Medium | Network payloads |
| **HDF5** | Chunked | Medium | Large datasets, random access |

**Engineering example:**
```python
# Bad: JSON serialization (10x slower, precision loss)
json.dumps({"embedding": embedding.tolist()})

# Good: Binary serialization
embedding.tobytes()  # NumPy → bytes

# Better: Arrow for batch transfer
import pyarrow as pa
table = pa.Table.from_arrays([embeddings], names=["embedding"])
```

**Critical gotcha:** Float precision
```python
# JSON loses precision
>>> x = 0.1234567890123456
>>> json.loads(json.dumps(x))
0.12345678901234559  # Precision loss!

# Binary preserves bits
>>> struct.unpack('f', struct.pack('f', x))[0]
0.12345679104328156  # float32 precision preserved
```

---

### 7. Batch Buffers / Ring Buffers

**Problem:** High-throughput ingestion
- Embeddings produced in batches (GPU inference)
- Index insertion has overhead
- Network/disk I/O is bursty

**Solution:** Producer/consumer queues

```python
from queue import Queue
import threading

embedding_queue = Queue(maxsize=1000)

# Producer: embedding model
def embed_worker():
    while True:
        batch = get_image_batch()
        embeddings = model.encode(batch)
        for emb in embeddings:
            embedding_queue.put(emb)

# Consumer: vector DB insertion
def insert_worker():
    batch = []
    while True:
        batch.append(embedding_queue.get())
        if len(batch) >= 100:
            index.add(batch)
            batch = []
```

**Advanced:** Ring buffers for lock-free concurrency
```python
import numpy as np

class RingBuffer:
    def __init__(self, size, dim):
        self.buffer = np.zeros((size, dim), dtype=np.float32)
        self.write_idx = 0
        self.read_idx = 0
        self.size = size

    def push(self, vector):
        self.buffer[self.write_idx] = vector
        self.write_idx = (self.write_idx + 1) % self.size
```

**Backpressure handling:**
- Drop oldest (lossy)
- Block producer (preserves data, risks deadlock)
- Spill to disk (S3, local cache)

---

## 🧩 Engineering Fluencies Required

Vector DB engineering is **NOT** traditional database work. You need:

### 1. Arrays & Tensors
- NumPy broadcasting, striding, views
- GPU tensor operations (PyTorch, CuPy)
- Memory alignment for SIMD

### 2. Graph Structures
- Adjacency lists
- Graph traversal (DFS, BFS, greedy search)
- Layer hierarchy (HNSW)

### 3. Hash Maps
- O(1) lookup for ID mapping
- Collision handling
- Distributed hash tables (consistent hashing)

### 4. Inverted Indices
- Posting lists
- Term frequency / document frequency
- Boolean query optimization

### 5. Queues & Buffers
- Producer/consumer patterns
- Backpressure strategies
- Lock-free data structures

### 6. Compression & Quantization
- K-means clustering
- Vector quantization
- Scalar quantization (int8, binary)

---

## ⚡ Production Engineering Concerns

### Recall vs Latency Tradeoff

```
┌─────────────────────────────────────┐
│  Recall                             │
│    ▲                                │
│100%│   HNSW (ef=500)                │
│    │   ●                            │
│ 95%│       ● HNSW (ef=200)          │
│    │           ● IVF (nprobe=50)    │
│ 90%│               ● IVF (nprobe=10)│
│    │                   ● PQ         │
│ 85%│                       ● LSH    │
│    └────────────────────────────────▶
│         1ms  10ms  100ms  1s        │
│              Latency                 │
└─────────────────────────────────────┘
```

**Tuning HNSW:**
```python
# Low latency, lower recall
index = faiss.IndexHNSWFlat(dim, 16)
index.hnsw.efConstruction = 100
index.hnsw.ef = 50  # Query-time parameter

# High recall, higher latency
index = faiss.IndexHNSWFlat(dim, 64)
index.hnsw.efConstruction = 500
index.hnsw.ef = 200
```

---

### Memory vs Accuracy

**Full precision (baseline):**
```python
# 1M vectors × 768 dims × 4 bytes (float32) = 3 GB
index = faiss.IndexFlatL2(768)
```

**Product Quantization (10x compression):**
```python
# 1M vectors × 96 bytes (768 dims / 8 subvectors) = 92 MB
index = faiss.IndexPQ(768, 8, 8)  # 8 subvectors, 8-bit codes
# ~10% recall loss
```

**Scalar Quantization (4x compression):**
```python
# 1M vectors × 768 bytes (int8) = 768 MB
index = faiss.IndexScalarQuantizer(768, faiss.ScalarQuantizer.QT_8bit)
# ~2% recall loss
```

---

### Ingestion Throughput vs Query Performance

**Batch ingestion (HNSW):**
```python
# Slow: One-by-one insertion
for vec in vectors:
    index.add(vec)  # Rebuilds graph connections

# Fast: Batch insertion
index.add_with_ids(vectors, ids)  # Amortizes overhead
```

**IVF strategy:**
```python
# 1. Train on representative sample
index.train(training_vectors)

# 2. Add vectors (parallel-friendly)
index.add(vectors)

# 3. Query (tune nprobe based on load)
index.nprobe = 10  # Low load
index.nprobe = 50  # High recall needed
```

---

### Filtering Strategies

**Pre-filtering (efficient when selective):**
```python
# Filter → ANN search
filtered_ids = metadata_index.query("class_label = 'dog'")  # 1M → 10K
results = ann_index.search(query_vec, filtered_ids, k=10)
```

**Post-filtering (better recall):**
```python
# ANN search → Filter
candidates = ann_index.search(query_vec, k=1000)  # Over-fetch
results = [c for c in candidates if c.metadata['class_label'] == 'dog'][:10]
```

**Hybrid (production):**
```python
# Combine strategies
if filter_selectivity < 0.1:  # <10% of data
    # Pre-filter
    filtered_ids = metadata_index.query(filter_expr)
    results = ann_index.search(query_vec, filtered_ids, k=k)
else:
    # Post-filter with over-fetch
    results = ann_index.search(query_vec, k=k*10)
    results = [r for r in results if matches_filter(r)][:k]
```

---

### Distributed Sharding

**Horizontal partitioning:**
```
Shard 0: [vectors 0 - 10M]
Shard 1: [vectors 10M - 20M]
Shard 2: [vectors 20M - 30M]
...
```

**Query routing:**
```python
# Scatter-gather pattern
query_results = []
for shard in shards:
    shard_results = shard.search(query_vec, k=k)
    query_results.extend(shard_results)

# Merge and re-rank
final_results = heapq.nsmallest(k, query_results, key=lambda x: x.distance)
```

**Metadata-based routing (better):**
```python
# Route based on partition key
shard_id = hash(metadata['user_id']) % num_shards
results = shards[shard_id].search(query_vec, k=k)
```

---

## 🔧 Practical ML/CV Patterns

### 1. Image Similarity Search

```python
# Embedding extraction
import torch
from torchvision.models import resnet50

model = resnet50(pretrained=True)
model.eval()

def extract_embedding(image):
    with torch.no_grad():
        features = model(image)
    return features.cpu().numpy()

# Index construction
import faiss

embeddings = np.array([extract_embedding(img) for img in dataset])
index = faiss.IndexHNSWFlat(2048, 32)
index.add(embeddings)

# Query
query_emb = extract_embedding(query_image)
distances, indices = index.search(query_emb.reshape(1, -1), k=10)
```

---

### 2. Multi-Modal Retrieval (CLIP-style)

```python
# Text → Image search
text_emb = clip_model.encode_text("a dog playing in the park")
image_indices = image_index.search(text_emb, k=10)

# Image → Text search
image_emb = clip_model.encode_image(query_image)
text_indices = text_index.search(image_emb, k=10)
```

---

### 3. Object Detection with Vector DB

```python
# Store detected objects
for img_id, detections in enumerate(detection_results):
    for det in detections:
        bbox = det['bbox']
        crop = img[bbox[1]:bbox[3], bbox[0]:bbox[2]]
        emb = extract_embedding(crop)

        index.add(emb)
        metadata[vec_id] = {
            'image_id': img_id,
            'bbox': bbox,
            'class': det['class'],
            'confidence': det['score']
        }

# Query: Find similar objects
query_crop = image[y1:y2, x1:x2]
query_emb = extract_embedding(query_crop)
similar_objects = index.search(query_emb, k=50)
```

---

### 4. Video Frame Retrieval

```python
# Index video frames
frame_embeddings = []
frame_metadata = []

for video in dataset:
    for frame_idx, frame in enumerate(video.frames):
        emb = extract_embedding(frame)
        frame_embeddings.append(emb)
        frame_metadata.append({
            'video_id': video.id,
            'frame_idx': frame_idx,
            'timestamp': frame_idx / video.fps
        })

index.add(np.array(frame_embeddings))

# Query with temporal filtering
results = index.search(query_emb, k=100)
# Post-filter: same video, temporally close frames
filtered = [r for r in results
            if r.metadata['video_id'] == target_video
            and abs(r.metadata['timestamp'] - query_time) < 5.0]
```

---

### 5. Anomaly Detection

```python
# Build index on normal data
normal_embeddings = [extract_embedding(img) for img in normal_dataset]
index.add(np.array(normal_embeddings))

# Detect anomalies
test_emb = extract_embedding(test_image)
distances, _ = index.search(test_emb.reshape(1, -1), k=1)

# If distance > threshold, flag as anomaly
if distances[0][0] > anomaly_threshold:
    print("Anomaly detected!")
```

---

## 🎓 Learning Path

### Week 1: Foundations
- [ ] Read HNSW paper (Malkov & Yashunin)
- [ ] Implement k-NN search (brute force)
- [ ] Implement k-means clustering (for IVF)
- [ ] Build toy HNSW graph (100 vectors)

### Week 2: FAISS Deep Dive
- [ ] Install FAISS
- [ ] Compare IndexFlat vs IndexIVF vs IndexHNSW
- [ ] Experiment with quantization (PQ, SQ)
- [ ] Benchmark recall vs latency tradeoffs

### Week 3: Production Patterns
- [ ] Build embedding pipeline (model → vectors → index)
- [ ] Implement metadata filtering
- [ ] Design ID mapping schema
- [ ] Test batch ingestion performance

### Week 4: Scale & Optimize
- [ ] Profile memory usage (PQ compression)
- [ ] Tune HNSW parameters (M, ef, efConstruction)
- [ ] Implement distributed sharding
- [ ] Add monitoring (query latency, recall metrics)

---

## 🚨 Common Pitfalls

### 1. **Normalization mismatch**
```python
# Bad: Forget to normalize
index.add(embeddings)  # Raw vectors
query_results = index.search(query_vec, k=10)  # Also raw

# Good: Normalize consistently
import faiss
faiss.normalize_L2(embeddings)
index.add(embeddings)
faiss.normalize_L2(query_vec)
query_results = index.search(query_vec, k=10)
```

### 2. **Training on insufficient data (IVF)**
```python
# Bad: Train on too few vectors
index.train(vectors[:1000])  # 1K vectors for 4096 clusters

# Good: Train on representative sample
index.train(vectors[:100000])  # 100K vectors minimum
```

### 3. **Ignoring metadata index design**
```python
# Bad: Store everything in vector DB
# Slow filtering, expensive storage

# Good: Separate metadata index
metadata_db = {
    'vector_id': 123,
    'image_path': 's3://...',  # Store reference, not data
    'class_label': 'dog',
    'timestamp': 1638360000
}
```

### 4. **Over-fetching without re-ranking**
```python
# Bad: Return raw ANN results
results = index.search(query_vec, k=100)  # May have duplicates, noise

# Good: Re-rank by business logic
candidates = index.search(query_vec, k=100)
results = rerank(candidates, query_context)[:10]
```

### 5. **Not monitoring recall**
```python
# Production monitoring
def measure_recall(ground_truth, ann_results):
    overlap = set(ground_truth) & set(ann_results)
    return len(overlap) / len(ground_truth)

# Alert if recall drops below threshold
if recall < 0.90:
    alert("Vector DB recall degraded!")
```

---

## 📊 Benchmarking Template

```python
import time
import numpy as np

# Setup
n_vectors = 1_000_000
n_dims = 768
n_queries = 1000
k = 10

vectors = np.random.randn(n_vectors, n_dims).astype(np.float32)
queries = np.random.randn(n_queries, n_dims).astype(np.float32)

# Ground truth (brute force)
def compute_ground_truth(queries, vectors, k):
    ground_truth = []
    for q in queries:
        distances = np.linalg.norm(vectors - q, axis=1)
        indices = np.argpartition(distances, k)[:k]
        ground_truth.append(set(indices))
    return ground_truth

# Benchmark function
def benchmark_index(index, queries, ground_truth, k):
    # Warmup
    index.search(queries[:10], k)

    # Measure
    start = time.time()
    results = index.search(queries, k)
    latency = (time.time() - start) / len(queries) * 1000  # ms

    # Recall
    recall = 0
    for i, (distances, indices) in enumerate(results):
        overlap = set(indices) & ground_truth[i]
        recall += len(overlap) / k
    recall /= len(queries)

    return {
        'latency_ms': latency,
        'recall': recall,
        'qps': 1000 / latency
    }

# Compare indices
indices = {
    'Flat': faiss.IndexFlatL2(n_dims),
    'HNSW32': faiss.IndexHNSWFlat(n_dims, 32),
    'IVF100': faiss.IndexIVFFlat(faiss.IndexFlatL2(n_dims), n_dims, 100),
    'PQ8': faiss.IndexPQ(n_dims, 8, 8)
}

for name, index in indices.items():
    if hasattr(index, 'train'):
        index.train(vectors[:100000])
    index.add(vectors)

    results = benchmark_index(index, queries, ground_truth, k)
    print(f"{name}: {results}")
```

---

## 🎯 Key Takeaways

1. **Vector DBs are NOT traditional databases**
   They're ANN indices + metadata layers + ID mappings

2. **Master HNSW first**
   It's 90% of production systems. Understand layers, greedy search, tuning.

3. **Data plumbing matters as much as algorithms**
   Serialization, batching, ID mapping, metadata indices determine real-world performance.

4. **Always measure recall AND latency**
   Optimizing one without the other is pointless.

5. **Filtering strategy depends on selectivity**
   Pre-filter if selective (<10%), post-filter otherwise.

6. **Compression is essential at scale**
   PQ gives 10x memory reduction for ~10% recall loss.

7. **Batch operations everywhere**
   Never insert one-by-one. Never query one-by-one (if avoidable).

8. **Monitor production recall**
   ANN indices degrade over time (data drift, index fragmentation).

---

## 📚 Appendix: Quick Reference

### FAISS Index Types Cheat Sheet

```python
# Exact search (baseline)
faiss.IndexFlatL2(dim)              # L2 distance
faiss.IndexFlatIP(dim)              # Inner product (cosine if normalized)

# HNSW (high recall, fast search)
faiss.IndexHNSWFlat(dim, M)         # M=32 typical

# IVF (partitioning)
faiss.IndexIVFFlat(quantizer, dim, nlist)

# Compression
faiss.IndexPQ(dim, m, nbits)        # Product quantization
faiss.IndexScalarQuantizer(dim, faiss.ScalarQuantizer.QT_8bit)

# GPU acceleration
faiss.index_cpu_to_gpu(res, device_id, index)
```

### Distance Metrics

| Metric | Formula | When to Use |
|--------|---------|-------------|
| **L2 (Euclidean)** | `sqrt(sum((a-b)^2))` | Default for embeddings |
| **Cosine** | `1 - (a·b)/(||a|| ||b||)` | Normalized embeddings (NLP, vision) |
| **Inner Product** | `a·b` | Faster cosine (if pre-normalized) |
| **Manhattan (L1)** | `sum(abs(a-b))` | Sparse features |

### Tuning Heuristics

**HNSW:**
- `M = 16-64` (higher = better recall, more memory)
- `efConstruction = 100-500` (higher = better index quality)
- `ef = 50-200` (query-time, higher = better recall)

**IVF:**
- `nlist = sqrt(N)` to `N/100`
- `nprobe = 1-100` (higher = better recall)

**PQ:**
- `m = 8-16` subvectors
- `nbits = 8` (256 centroids per subvector)

---

**End of Guide**

*Last updated: 2026-02-01*
*For ML/CV engineers building production vector search systems*
