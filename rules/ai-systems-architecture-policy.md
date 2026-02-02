# AI Systems Architecture Policy

**Status:** Authoritative
**Last updated:** 2026-02-01
**Purpose:** Govern the architectural shift from deterministic to probabilistic systems, establishing patterns for AI-powered software architecture in production

**Note:** This policy was renamed from `probabilistic-systems-architecture-policy.md` to `ai-systems-architecture-policy.md` for clarity. The name "probabilistic systems" was confusing as it suggested probability theory rather than AI/LLM-powered systems.

---

## Table of Contents

- [Executive Summary](#executive-summary)
- [The Architectural Paradigm Shift](#the-architectural-paradigm-shift)
- [The Six Pillars of Probabilistic Architecture](#the-six-pillars-of-probabilistic-architecture)
- [Verification as Runtime Infrastructure](#verification-as-runtime-infrastructure)
- [Context Management Systems](#context-management-systems)
- [Dual-State Architecture](#dual-state-architecture)
- [Evals Over Unit Tests](#evals-over-unit-tests)
- [Agent Runtime Patterns](#agent-runtime-patterns)
- [Robotics-Specific Considerations](#robotics-specific-considerations)
- [Production Readiness Checklist](#production-readiness-checklist)
- [Anti-Patterns](#anti-patterns)
- [Quick Reference](#quick-reference)

---

## Executive Summary

**Software architecture has undergone its most significant transformation since the Cloud Native revolution.**

We are transitioning from:
- **Deterministic Systems** (explicit rules for every state) → **Probabilistic Systems** (goal-oriented behavior with statistical guarantees)
- **`Input + Logic = Output`** → **`Context + Intent + Model = Probabilistic Output + Verification`**

**Core Thesis:**
Modern software architecture is no longer about *defining constraints* — it's about *managing ambiguity*.

**Critical Implications:**
1. Application logic is now **soft** (prompts, not code)
2. APIs have **blurry boundaries** (natural language inputs)
3. Testing shifts from **assertions** to **statistical evaluation**
4. The LLM **is** the runtime (not just a component)
5. **Verification becomes infrastructure**, not QA

This policy establishes mandatory patterns for building, deploying, and maintaining probabilistic systems in production.

---

## The Architectural Paradigm Shift

### The Six Fundamental Changes

#### 1. The Death of "If-This-Then-That" (Logic Layer)

**Old Architecture:**
```python
if user_input == 'refund':
    call_refund_service()
elif user_input == 'cancel':
    call_cancel_service()
# You are responsible for every edge case
```

**New Architecture:**
```python
intent = llm_router.analyze(user_input, schema={
    "action": ["refund", "cancel", "query"],
    "parameters": {...}
})
route_to_service(intent)
# Model handles variations, typos, paraphrasing
```

**The Consequence:**
- **Flexibility** ↑ (handles 99% of natural variations)
- **Determinism** ↓ (1% hallucination risk)
- **Trade:** Rigidity for variance

**Mandatory Controls:**
- Output schema validation (Pydantic/Guardrails)
- Confidence thresholding
- Fallback to human review at <90% confidence
- Logging ALL ambiguous cases

---

#### 2. The Rise of "Semantic State" (Data Layer)

**Old Architecture:**
```sql
SELECT * FROM products WHERE id = 123
```

**New Architecture:**
```python
# Dual retrieval
transactional_truth = db.query("SELECT * WHERE id=123")
semantic_truth = vector_db.search("warm winter jacket", top_k=5)
results = merge_with_rerank(transactional_truth, semantic_truth)
```

**The Consequence:**
You now have **two sources of truth**:
1. **Transactional Truth** (Postgres) — strongly consistent, exact matches
2. **Semantic Truth** (Vector DB) — eventually consistent, meaning-based

**Architectural Pattern: Dual-Write with Semantic Indexing**
```
Write → Postgres (source of truth)
     ↓
Async → Embed → Vector DB (semantic index)
Read  → Vector DB (semantic retrieval)
     ↓
Verify ← Postgres (ground truth validation)
```

**The New "Cache Invalidation" Problem:**
Keeping transactional and semantic stores in sync.

**Mandatory Requirements:**
- Vector embeddings MUST be regenerated on transactional writes
- Stale semantic data MUST be flagged (TTL on embeddings)
- Retrieval MUST validate against transactional source for critical operations

---

#### 3. Natural Language as API (Interface Layer)

**Old Architecture:**
```json
POST /api/products
{
  "name": "Widget",
  "price": 29.99,
  "quantity": 100
}
// Schema is strict. Wrong type = 400 error
```

**New Architecture:**
```python
user_input = "Add 100 widgets at $30 each"
structured_call = llm.function_call(
    user_input,
    tools=[create_product_tool],
    enforce_schema=True
)
execute_tool(structured_call)
```

**The Consequence:**
The API boundary is **blurry**. You are no longer coding for a *known client* — you are coding **tools for an AI agent to discover and use**.

**Mandatory Patterns:**
- Tool definitions MUST include detailed docstrings (models read them)
- Parameter validation MUST happen server-side (don't trust the model)
- Idempotency MUST be enforced (models may retry)
- All destructive operations MUST require confirmation prompts

**Tool Design Anti-Pattern:**
```python
# BAD: Assumes client knows exact format
def delete_user(user_id: int) -> bool
```

**Tool Design Best Practice:**
```python
# GOOD: Robust to model errors, safe defaults
def delete_user(
    user_id: int,
    confirm_deletion: bool = False,
    require_backup: bool = True
) -> DeleteResult:
    """
    Delete a user account from the system.

    WARNING: This is a destructive operation.

    Args:
        user_id: The unique identifier of the user
        confirm_deletion: MUST be True to proceed
        require_backup: If True, creates backup before deletion

    Returns:
        DeleteResult with status and backup_path

    Raises:
        ValueError: If user_id invalid or confirmation not provided
    """
```

---

#### 4. Testing is Dead; Long Live "Evals" (QA Layer)

**Old Architecture:**
```python
def test_add():
    assert add(2, 2) == 4  # Pass or fail
```

**New Architecture:**
```python
# Eval set: 100 diverse examples
def eval_intent_router():
    results = []
    for example in test_set:
        prediction = router(example.input)
        results.append(prediction == example.expected)

    accuracy = sum(results) / len(results)
    assert accuracy > 0.90  # Statistical threshold
```

**The Consequence:**
- You **cannot unit test a prompt**
- CI/CD now runs **statistical evaluations**
- Tests take **20 minutes** and **cost money** (API tokens)
- Regressions are **probabilistic**, not binary

**Mandatory Eval Infrastructure:**

```python
@eval_suite(name="intent_classification", threshold=0.90)
def test_customer_service_intents():
    """
    Eval Set: 500 customer service messages
    Success: >90% correct intent classification
    Cost: ~$2.50 per run (OpenAI API)
    Runtime: ~8 minutes
    """
    pass

@eval_suite(name="rag_retrieval", threshold=0.85)
def test_document_retrieval_quality():
    """
    Eval Set: 200 queries with golden documents
    Metrics: Precision@5, Recall@10, MRR
    Success: P@5 > 0.85, R@10 > 0.90
    """
    pass
```

**CI/CD Integration:**
```yaml
# .github/workflows/evals.yml
name: Model Evals
on: [pull_request]
jobs:
  run-evals:
    steps:
      - name: Run Intent Classification Eval
        run: pytest tests/evals/ --threshold=0.90
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}

      - name: Check Cost Budget
        run: |
          if [ $EVAL_COST -gt 10 ]; then
            echo "Eval cost exceeded $10 budget"
            exit 1
          fi
```

---

#### 5. The "Context Window" is the New RAM (Memory Layer)

**Old Architecture:**
```python
# Managing RAM and disk I/O
data = load_from_disk()  # Disk
process(data)            # RAM
save_to_disk(result)     # Disk
```

**New Architecture:**
```python
# Managing tokens in context window
context = retrieve_from_vector_db(query, top_k=10)  # "Disk"
prompt = build_prompt(context, user_query)          # "RAM"
response = llm(prompt, max_tokens=4096)             # Processing
# Context window (128k tokens) is your "RAM"
```

**The Consequence:**
You are now architecting **Context Management Systems** (RAG). You must decide:
- What data to **shove into the prompt** (RAM)
- What to **leave in the Vector DB** (Disk)

**"Context Stuffing" = Memory Leak**

**Mandatory Context Management Patterns:**

```python
class ContextManager:
    """
    Manages the 'working memory' (context window) of the LLM.
    Analogous to RAM management in traditional systems.
    """

    def __init__(self, max_tokens: int = 128_000):
        self.max_tokens = max_tokens
        self.reserved_tokens = 4096  # For response
        self.available_tokens = max_tokens - self.reserved_tokens

    def pack_context(
        self,
        system_prompt: str,
        user_query: str,
        retrieved_docs: List[Document]
    ) -> str:
        """
        Pack context with priority:
        1. System prompt (always include)
        2. User query (always include)
        3. Retrieved docs (fit as many as possible, highest ranked first)
        """
        token_budget = self.available_tokens

        # Reserve for system + user
        system_tokens = count_tokens(system_prompt)
        query_tokens = count_tokens(user_query)
        token_budget -= (system_tokens + query_tokens)

        # Pack retrieved docs until budget exhausted
        packed_docs = []
        for doc in retrieved_docs:
            doc_tokens = count_tokens(doc.text)
            if token_budget >= doc_tokens:
                packed_docs.append(doc)
                token_budget -= doc_tokens
            else:
                break

        return build_prompt(system_prompt, packed_docs, user_query)
```

---

#### 6. The "Agent Runtime" is the New Application Server (Execution Layer)

**Old Architecture:**
```python
# Traditional application server
uvicorn app:main --workers 4

# Server executes YOUR code
@app.post("/api/refund")
def process_refund(request: RefundRequest):
    # Your logic runs here
    return execute_refund_logic(request)
```

**New Architecture:**
```python
# LLM *is* the runtime
tools = [refund_tool, cancel_tool, query_tool]

response = llm.chat(
    messages=[{"role": "user", "content": user_input}],
    tools=tools  # LLM decides which to call
)

# The MODEL makes control flow decisions at runtime
if response.tool_calls:
    for call in response.tool_calls:
        result = execute_tool(call.name, call.arguments)
```

**The Consequence:**
Your "application" is now:
- **Prompt** (system instructions)
- **Tool registry** (available functions)
- **Orchestration policy** (how tools compose)

The **LLM makes runtime decisions** about control flow based on observations.

**Mandatory Agent Runtime Patterns:**

```python
class AgentRuntime:
    """
    The LLM-as-runtime execution model.
    Analogous to traditional app servers, but control flow is probabilistic.
    """

    def __init__(
        self,
        model: str,
        tools: List[Tool],
        max_iterations: int = 10,
        timeout_seconds: int = 30
    ):
        self.model = model
        self.tools = {t.name: t for t in tools}
        self.max_iterations = max_iterations
        self.timeout_seconds = timeout_seconds

    def execute(self, user_input: str) -> AgentResult:
        """
        Execute agent loop with safety guardrails.
        """
        messages = [{"role": "user", "content": user_input}]
        iterations = 0
        start_time = time.time()

        while iterations < self.max_iterations:
            # Check timeout
            if time.time() - start_time > self.timeout_seconds:
                raise TimeoutError("Agent exceeded timeout")

            # LLM decides next action
            response = self.llm.chat(messages, tools=self.tools.values())

            # No tool calls = final answer
            if not response.tool_calls:
                return AgentResult(
                    answer=response.content,
                    iterations=iterations,
                    tool_calls_made=[...]
                )

            # Execute tool calls (VERIFY outputs)
            for call in response.tool_calls:
                result = self._execute_tool_safely(call)
                messages.append(result)

            iterations += 1

        raise MaxIterationsError("Agent exceeded max iterations")

    def _execute_tool_safely(self, call: ToolCall) -> dict:
        """
        Execute tool with verification and error handling.
        """
        if call.name not in self.tools:
            return {"error": f"Unknown tool: {call.name}"}

        try:
            # Validate arguments against schema
            validated_args = self.tools[call.name].validate(call.arguments)

            # Execute tool
            result = self.tools[call.name].execute(**validated_args)

            # Verify result against constraints
            if not self.tools[call.name].verify_output(result):
                return {"error": "Tool output failed verification"}

            return {"result": result}

        except Exception as e:
            log_tool_error(call.name, call.arguments, e)
            return {"error": str(e)}
```

---

## Verification as Runtime Infrastructure

**CRITICAL PRINCIPLE:**
In probabilistic systems, **verification is not a QA phase — it is a runtime architectural layer.**

### The Three Verification Layers

#### Layer 1: Pre-Execution Verification (Input Validation)

```python
from pydantic import BaseModel, Field, validator
from typing import Literal

class RefundRequest(BaseModel):
    """Schema for refund tool input"""

    order_id: str = Field(..., regex=r'^ORD-\d{8}$')
    amount: float = Field(..., gt=0, lt=10000)
    reason: Literal["defective", "unwanted", "duplicate"]
    confirm: bool = Field(..., const=True)  # MUST be True

    @validator('amount')
    def validate_amount(cls, v, values):
        # Cross-field validation
        if 'order_id' in values:
            max_amount = get_order_total(values['order_id'])
            if v > max_amount:
                raise ValueError(f"Refund exceeds order total: ${max_amount}")
        return v

# Tool definition
@tool(schema=RefundRequest)
def process_refund(request: RefundRequest) -> RefundResult:
    """Process a refund - arguments are ALREADY VALIDATED"""
    # If we're here, schema validation passed
    return execute_refund(request)
```

#### Layer 2: Post-Execution Verification (Output Validation)

```python
class OutputVerifier:
    """Verify LLM outputs meet constraints"""

    @staticmethod
    def verify_sql_query(query: str) -> bool:
        """Verify generated SQL is safe"""
        # No destructive operations
        forbidden = ['DROP', 'DELETE', 'TRUNCATE', 'ALTER']
        if any(kw in query.upper() for kw in forbidden):
            raise SecurityError("SQL contains destructive operation")

        # Parse and validate
        try:
            parsed = sqlparse.parse(query)[0]
            # Additional AST-based validation
            return validate_sql_ast(parsed)
        except:
            raise ValidationError("Invalid SQL syntax")

    @staticmethod
    def verify_geometric_constraints(
        detection: BoundingBox,
        camera_params: CameraParams
    ) -> bool:
        """Verify object detection doesn't hallucinate outside FOV"""
        # In robotics: verify detections are geometrically possible
        if not detection.within_fov(camera_params):
            raise GeometricViolation("Detection outside camera FOV")

        if not detection.physically_plausible(camera_params):
            raise GeometricViolation("Detection violates physical constraints")

        return True
```

#### Layer 3: Runtime Monitoring (Continuous Verification)

```python
class RuntimeVerifier:
    """Continuous monitoring of system invariants"""

    def __init__(self):
        self.metrics = PrometheusMetrics()

    def monitor_hallucination_rate(self, window_minutes: int = 60):
        """Track hallucination rate over time"""
        rate = self.metrics.query(
            f'rate(hallucinations_total[{window_minutes}m])'
        )

        if rate > 0.05:  # >5% hallucination rate
            alert_on_call("Hallucination rate exceeded threshold")
            enable_human_in_loop()

    def monitor_latency_regression(self):
        """Ensure LLM latency doesn't degrade performance"""
        p95_latency = self.metrics.query('llm_latency_p95')

        # In robotics: real-time constraints
        if p95_latency > 500:  # ms
            alert("LLM latency blocking control loop")
            fallback_to_deterministic_policy()
```

---

## Context Management Systems

**Architecture Pattern: Embodied RAG for Robotics**

In robotics perception, the "context window" problem is **4D**: space + time.

```python
class SpatiotemporalRAG:
    """
    Context management for embodied AI systems.
    Manages what sensor history to keep in 'working memory' vs. spatial memory.
    """

    def __init__(
        self,
        vector_db: VectorDB,
        spatial_index: SpatialIndex,
        context_budget_tokens: int = 32_000
    ):
        self.vector_db = vector_db
        self.spatial_index = spatial_index
        self.context_budget = context_budget_tokens

    def retrieve_relevant_observations(
        self,
        current_pose: Pose3D,
        current_time: float,
        query: str
    ) -> List[Observation]:
        """
        Retrieve relevant past observations for current decision.

        Criteria:
        1. Semantic relevance (via embedding similarity)
        2. Spatial proximity (near current pose)
        3. Temporal recency (recent observations prioritized)
        4. Geometric validity (observations from valid viewpoints)
        """

        # Semantic retrieval
        candidates = self.vector_db.search(
            query_embedding=embed(query),
            top_k=100
        )

        # Spatial filtering
        spatially_relevant = self.spatial_index.query_radius(
            center=current_pose.position,
            radius_meters=10.0,
            observations=candidates
        )

        # Temporal decay (recent observations weighted higher)
        time_weighted = [
            (obs, self._temporal_weight(obs.timestamp, current_time))
            for obs in spatially_relevant
        ]

        # Re-rank by combined score
        reranked = sorted(
            time_weighted,
            key=lambda x: x[0].similarity * x[1],
            reverse=True
        )

        # Pack into context budget
        packed = []
        tokens_used = 0
        for obs, weight in reranked:
            obs_tokens = count_tokens(obs.serialize())
            if tokens_used + obs_tokens <= self.context_budget:
                packed.append(obs)
                tokens_used += obs_tokens
            else:
                break

        return packed

    def _temporal_weight(self, obs_time: float, current_time: float) -> float:
        """Exponential decay: recent observations matter more"""
        age_seconds = current_time - obs_time
        half_life_seconds = 60.0  # Observations decay to 50% weight after 1 min
        return math.exp(-age_seconds / half_life_seconds)
```

**See also:** [RAG Engineering Notes](references/rag-engineering-notes.md) for production RAG system design, chunking strategies, retrieval pipelines, reranking, and evaluation frameworks.

---

## Dual-State Architecture

**Pattern: Managing Transactional + Semantic State**

```python
class DualStateManager:
    """
    Manage the 'two sources of truth' problem.
    Keep transactional DB (Postgres) and semantic index (Vector DB) in sync.
    """

    def __init__(
        self,
        transactional_db: Database,
        vector_db: VectorDB,
        embedding_model: EmbeddingModel
    ):
        self.transactional_db = transactional_db
        self.vector_db = vector_db
        self.embedding_model = embedding_model

    def write(self, document: Document) -> None:
        """
        Dual-write pattern:
        1. Write to transactional DB (source of truth)
        2. Async embed and index in vector DB
        """
        # Write to transactional DB (synchronous, source of truth)
        doc_id = self.transactional_db.insert(document)

        # Async embed and index (eventually consistent)
        self._async_embed_and_index(doc_id, document)

    def _async_embed_and_index(self, doc_id: str, document: Document):
        """Background job: embed and index"""
        # Generate embedding
        embedding = self.embedding_model.embed(document.text)

        # Write to vector DB with metadata
        self.vector_db.upsert(
            id=doc_id,
            embedding=embedding,
            metadata={
                "doc_id": doc_id,
                "indexed_at": time.time(),
                "checksum": hash(document.text)
            }
        )

    def read_with_verification(self, query: str) -> List[Document]:
        """
        Read pattern:
        1. Semantic retrieval from vector DB
        2. Verification against transactional DB
        """
        # Semantic retrieval
        candidates = self.vector_db.search(
            query_embedding=self.embedding_model.embed(query),
            top_k=10
        )

        # Verify against transactional source
        verified = []
        for candidate in candidates:
            # Check transactional DB for ground truth
            source_doc = self.transactional_db.get(candidate.metadata['doc_id'])

            # Verify checksum (detect stale embeddings)
            if hash(source_doc.text) != candidate.metadata['checksum']:
                # Embedding is stale, trigger re-index
                self._async_embed_and_index(candidate.metadata['doc_id'], source_doc)
                continue

            verified.append(source_doc)

        return verified
```

---

## Robotics-Specific Considerations

### The Real-Time + Probabilistic Tension

**Problem:** Robotics demands real-time performance, but LLMs have 200-500ms latency.

**Solution: Hybrid Architecture**

```python
class HybridPerceptionPipeline:
    """
    Two-brain architecture:
    - Fast brain: Deterministic, real-time (vision models)
    - Slow brain: Probabilistic, high-level reasoning (LLM)
    """

    def __init__(
        self,
        fast_models: Dict[str, VisionModel],  # DINO, SAM, etc.
        slow_brain: LLM,
        control_loop_hz: float = 30.0
    ):
        self.fast_models = fast_models
        self.slow_brain = slow_brain
        self.control_period = 1.0 / control_loop_hz

        # Slow brain runs async, doesn't block control loop
        self.slow_brain_queue = Queue()
        self.slow_brain_thread = Thread(target=self._slow_brain_loop)
        self.slow_brain_thread.start()

    def process_frame(self, frame: np.ndarray) -> Action:
        """
        Process frame at 30 Hz (fast brain).
        Slow brain runs async, updates world model.
        """
        # Fast brain: deterministic perception (< 33ms)
        detections = self.fast_models['detector'].detect(frame)
        segmentation = self.fast_models['segmenter'].segment(frame)

        # Immediate action from fast brain
        action = self._fast_action_policy(detections, segmentation)

        # Send to slow brain for high-level reasoning (async)
        self.slow_brain_queue.put({
            'frame': frame,
            'detections': detections,
            'segmentation': segmentation,
            'timestamp': time.time()
        })

        return action

    def _slow_brain_loop(self):
        """
        Async loop: LLM processes observations, updates world model.
        Doesn't block control loop.
        """
        while True:
            observation = self.slow_brain_queue.get()

            # LLM analyzes scene (200-500ms, okay because async)
            analysis = self.slow_brain.analyze_scene(
                observation['frame'],
                observation['detections']
            )

            # Update world model (influences future fast brain actions)
            self.world_model.update(analysis)
```

### Geometric Verification Layer

**Problem:** Vision models can hallucinate objects outside the camera FOV.

**Solution: Geometric Invariants as Verification**

```python
class GeometricVerifier:
    """
    Verify perception outputs against geometric constraints.
    Catch hallucinations that violate physics.
    """

    def __init__(self, camera_params: CameraParams):
        self.camera_params = camera_params

    def verify_detection(
        self,
        detection: BoundingBox3D,
        camera_pose: Pose3D
    ) -> VerificationResult:
        """
        Verify detection is geometrically plausible.
        """
        checks = {
            'within_fov': self._check_fov(detection, camera_pose),
            'depth_plausible': self._check_depth(detection),
            'size_plausible': self._check_size(detection),
            'physics_valid': self._check_physics(detection)
        }

        passed = all(checks.values())

        if not passed:
            log_geometric_violation(detection, checks)

        return VerificationResult(passed=passed, checks=checks)

    def _check_fov(self, det: BoundingBox3D, pose: Pose3D) -> bool:
        """Verify detection is within camera field of view"""
        # Transform detection to camera frame
        det_camera_frame = pose.inverse() * det.center

        # Check if within FOV frustum
        return self.camera_params.is_within_fov(det_camera_frame)

    def _check_depth(self, det: BoundingBox3D) -> bool:
        """Verify depth is within valid range"""
        # Stereo cameras have min/max depth
        return (
            self.camera_params.min_depth
            < det.center.z
            < self.camera_params.max_depth
        )

    def _check_size(self, det: BoundingBox3D) -> bool:
        """Verify object size is plausible at detected depth"""
        # Apparent size should match distance
        expected_size = self.camera_params.project_size(
            real_size=det.dimensions,
            depth=det.center.z
        )

        detected_size = det.bbox_2d.size()

        return abs(detected_size - expected_size) / expected_size < 0.3  # 30% tolerance
```

**See also:** [Software Architecture in Machine-to-Machine Systems](../references/software-architecture-in-machine-to-machine-systems.md) for comprehensive architectural guidance on autonomous systems, safety-critical design, ethical-aware architecture (E-MAPE-K), control surfaces, system survivability, and architectural patterns for robots, IoT devices, and AI agents.

---

## Production Readiness Checklist

**Before deploying probabilistic systems to production:**

### [ ] 1. Verification Infrastructure

- [ ] Input validation schemas (Pydantic/Guardrails)
- [ ] Output verification logic
- [ ] Geometric/physical constraint checks (robotics)
- [ ] Confidence thresholding
- [ ] Fallback to human review

### [ ] 2. Eval Suite

- [ ] Eval dataset (>100 examples)
- [ ] Success threshold defined (e.g., 90% accuracy)
- [ ] CI/CD integration
- [ ] Cost budget monitoring
- [ ] Performance baselines

### [ ] 3. Context Management

- [ ] Token budget defined
- [ ] Context packing strategy
- [ ] Retrieval ranking logic
- [ ] Temporal decay (if applicable)
- [ ] Stale data detection

### [ ] 4. Dual-State Sync

- [ ] Transactional DB (source of truth)
- [ ] Vector DB (semantic index)
- [ ] Async embedding pipeline
- [ ] Checksum verification
- [ ] Sync monitoring

### [ ] 5. Runtime Safety

- [ ] Timeout enforcement
- [ ] Max iteration limits
- [ ] Tool execution sandboxing
- [ ] Error handling + logging
- [ ] Graceful degradation

### [ ] 6. Monitoring

- [ ] Hallucination rate tracking
- [ ] Latency monitoring (p50/p95/p99)
- [ ] Cost tracking
- [ ] Success rate dashboard
- [ ] Alerting on degradation

### [ ] 7. Robotics-Specific (if applicable)

- [ ] Real-time constraint verification
- [ ] Geometric verification layer
- [ ] Fast brain / slow brain separation
- [ ] Deterministic fallback policy
- [ ] Control loop isolation

---

## Anti-Patterns

### ❌ Anti-Pattern 1: "The Model Will Handle It"

**BAD:**
```python
def process_user_request(request: str):
    return llm.chat(request)  # No validation, no verification
```

**GOOD:**
```python
def process_user_request(request: str):
    # Parse intent
    intent = llm.chat(request, schema=IntentSchema)

    # Validate
    if intent.confidence < 0.85:
        return escalate_to_human(request)

    # Verify constraints
    if not verify_intent_safety(intent):
        raise SecurityError("Intent failed safety check")

    # Execute with verification
    result = execute_with_verification(intent)
    return result
```

### ❌ Anti-Pattern 2: "Context Stuffing"

**BAD:**
```python
# Dump entire database into context
context = "\n".join([doc.text for doc in all_documents])
llm.chat(context + user_query)  # Exceeds context window, degrades quality
```

**GOOD:**
```python
# Retrieve only relevant documents
relevant_docs = vector_db.search(user_query, top_k=5)

# Pack within token budget
context = context_manager.pack_context(
    system_prompt=system_prompt,
    user_query=user_query,
    retrieved_docs=relevant_docs,
    max_tokens=32_000
)
llm.chat(context)
```

### ❌ Anti-Pattern 3: "Prompt Chaos"

**BAD:**
```python
# Different prompt every time, no versioning
prompt = f"Do the thing: {user_input}"
```

**GOOD:**
```python
# Versioned, tested prompts
@prompt_template(version="v2.1", eval_threshold=0.92)
def intent_classification_prompt(user_input: str) -> str:
    return f"""
    Classify the user's intent into one of the following categories:
    - refund
    - cancel
    - query

    User input: {user_input}

    Output format: {{"intent": "...", "confidence": 0.0-1.0}}
    """
```

### ❌ Anti-Pattern 4: "No Fallback"

**BAD:**
```python
# If model fails, system fails
result = llm.chat(user_input)
return result  # What if hallucination? What if API down?
```

**GOOD:**
```python
try:
    result = llm.chat(user_input)

    if not verify_output(result):
        # Fallback to deterministic policy
        return deterministic_fallback(user_input)

    return result

except APIError:
    # Graceful degradation
    return "Service temporarily unavailable. Please try again."
```

### ❌ Anti-Pattern 5: "Black Box Deployment"

**BAD:**
```python
# Deploy without monitoring
deploy_model()
# Hope for the best
```

**GOOD:**
```python
# Deploy with full observability
deploy_model_with_monitoring(
    model=model,
    eval_suite=eval_suite,
    hallucination_alerts=True,
    latency_thresholds={'p95': 500},
    success_rate_threshold=0.90,
    rollback_on_degradation=True
)
```

---

## Quick Reference

### Probabilistic Systems Cheat Sheet

| Traditional System | Probabilistic System | Control Mechanism |
|-------------------|---------------------|------------------|
| `if user_input == 'refund'` | `intent = llm_router(user_input)` | Schema validation |
| `SELECT * WHERE id=123` | `vector_db.search("warm jacket")` | Verification against transactional DB |
| `assert add(2,2) == 4` | `assert accuracy > 0.90` | Statistical thresholds |
| `execute_code()` | `llm.function_call(tools)` | Tool input/output validation |
| `Cache invalidation` | `Vector DB sync` | Checksum verification |

### Verification Decision Tree

```
Is output from LLM?
├─ YES → Apply verification layer
│   ├─ Is it structured data?
│   │   └─ Validate schema (Pydantic)
│   ├─ Does it affect state?
│   │   └─ Verify against constraints
│   ├─ Is it safety-critical?
│   │   └─ Require human confirmation
│   └─ Is confidence < threshold?
│       └─ Escalate to human review
│
└─ NO → Standard code path
```

### When to Use Which Architecture

| Use Case | Architecture | Key Concern |
|----------|-------------|-------------|
| Customer support routing | LLM Router + Tools | Intent classification accuracy |
| Document search | RAG (Vector DB + LLM) | Retrieval precision |
| Code generation | LLM + Verification | Syntax/security validation |
| Robotics perception | Hybrid (Fast + Slow brain) | Real-time constraints |
| SQL query generation | LLM + AST validation | SQL injection prevention |
| Multi-step workflows | Agent Runtime | Iteration limits + timeouts |

---

## Conclusion

**Software architecture is now probabilistic.**

The engineers who internalize these patterns — who think in:
- Evals, not unit tests
- Context budgets, not RAM
- Semantic retrieval, not exact matches
- Verification loops, not QA phases
- Agent runtimes, not application servers

...will architect the next decade of software.

**The old rules don't apply. Welcome to probabilistic systems engineering.**
