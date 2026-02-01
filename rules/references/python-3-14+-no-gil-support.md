# Python No-GIL Support (3.13+/3.14+) - Comprehensive Notes

**Date Created:** 2026-02-01
**Focus:** Free-threaded Python and implications for ML/CV engineering and AI prompt optimization

---

## EXECUTIVE SUMMARY

**The Paradigm Shift:** Python 3.13+ introduces **experimental free-threaded mode** (no-GIL), with 3.14+ targeting **production stability**. This fundamentally changes how we architect ML/CV systems and write prompts for AI coding assistants.

**What Changed:**
- **Python 3.12 and earlier:** Global Interpreter Lock (GIL) prevents true parallelism
- **Python 3.13 (October 2024):** Experimental `--disable-gil` build option
- **Python 3.14+ (Expected 2025-2026):** Production-ready free-threaded mode

**Impact on ML/CV:**
- ✅ True multi-core parallelism in pure Python
- ✅ Simplified concurrent data pipelines
- ✅ Better CPU utilization for preprocessing
- ⚠️ Library compatibility still evolving
- ⚠️ Memory overhead ~10-15%

**Impact on AI Prompts:**
- 🔄 Prompts must now specify threading model
- 🔄 Need explicit guidance on thread-safe patterns
- 🔄 Library compatibility checks required
- 🔄 Performance trade-offs must be considered

---

## 1. UNDERSTANDING THE GIL AND ITS REMOVAL

### 1.1 What Is the GIL?

**Global Interpreter Lock (GIL):**
A mutex that protects access to Python objects, preventing multiple native threads from executing Python bytecodes simultaneously.

**Visual Representation:**

```
BEFORE (GIL - Python 3.12 and earlier):
┌─────────────────────────────────────┐
│  CPU Core 1  │  CPU Core 2  │ ... │
├─────────────────────────────────────┤
│ Thread 1 ████│              │     │  ← Only one thread executes
│              │ Thread 2 ████│     │     Python code at a time
│ Thread 3 ████│              │     │
│              │ Thread 4 ████│     │
└─────────────────────────────────────┘
        GIL switches between threads
        (but never runs 2 Python threads
         simultaneously on different cores)

AFTER (No-GIL - Python 3.13+):
┌─────────────────────────────────────┐
│  CPU Core 1  │  CPU Core 2  │ ... │
├─────────────────────────────────────┤
│ Thread 1 ████│ Thread 2 ████│     │  ← All threads can run
│ Thread 3 ████│ Thread 4 ████│     │     simultaneously
└─────────────────────────────────────┘
        True parallelism achieved
```

### 1.2 Why Remove the GIL?

**Historical Context:**
- GIL made CPython simple and memory-safe (1991)
- Trade-off: Simplicity vs parallelism
- Fine for I/O-bound tasks (GIL released during I/O)
- Bottleneck for CPU-bound tasks

**Modern Motivation:**
- Multi-core CPUs ubiquitous (16-128+ cores common)
- ML/CV workloads increasingly CPU-bound
- Data preprocessing pipelines underutilized
- Competition from Julia, Rust, Go (true parallelism)

**PEP 703 (Making the GIL Optional):**
- Proposed by Sam Gross (Meta)
- Accepted for Python 3.13 (experimental)
- Target: Production-ready by Python 3.14

### 1.3 Implementation Details

**How It Works:**

1. **Biased Reference Counting:**
   - Objects track which thread "owns" them
   - Fast path for single-threaded access
   - Slow path for cross-thread access

2. **Immortal Objects:**
   - Common objects (None, True, False, small integers) made immortal
   - Reference count = ∞
   - No atomic operations needed

3. **Deferred Reference Counting:**
   - Some decrements batched and deferred
   - Reduces synchronization overhead

4. **Thread-Local Caching:**
   - Per-thread object allocation
   - Reduces contention

**Build Flags:**
```bash
# Python 3.13 experimental
./configure --disable-gil
make
./python -X gil=0  # Runtime flag

# Python 3.14+ (expected)
# Free-threaded by default, or:
./configure --enable-gil  # If you want GIL back
```

---

## 2. TIMELINE AND VERSION DETAILS

### 2.1 Python 3.13 (October 2024)

**Status:** Experimental free-threaded mode

**Availability:**
```bash
# Check if free-threaded build
python3.13 -VV
# Output: Python 3.13.0 experimental free-threaded build

# Runtime control
python3.13 -X gil=0  # Disable GIL
python3.13 -X gil=1  # Enable GIL (default)
```

**Features:**
- ✅ Free-threaded mode available
- ⚠️ Experimental (expect bugs)
- ⚠️ Limited library support
- ⚠️ Performance not fully optimized

**Library Compatibility (as of 3.13):**
- **NumPy:** Partial support (work in progress)
- **PyTorch:** Not yet compatible
- **TensorFlow:** Not yet compatible
- **Pandas:** Limited support
- **Pillow:** Compatible
- **requests:** Compatible

### 2.2 Python 3.14 (Expected Late 2025)

**Status:** Production-ready free-threaded mode (target)

**Expected Improvements:**
- ✅ Stable API/ABI for free-threaded mode
- ✅ Major libraries compatible (NumPy, SciPy)
- ✅ Performance optimizations
- ✅ Better tooling support

**Roadmap:**
- Beta: Mid-2025
- RC: September 2025
- Release: October 2025

### 2.3 Python 3.15+ (2026+)

**Expected Features:**
- Free-threaded as default mode
- GIL optional for legacy code
- Full ecosystem compatibility
- Performance parity with GIL builds

---

## 3. IMPACT ON ML/CV ENGINEERING

### 3.1 Data Preprocessing Pipelines

**BEFORE (GIL - multiprocessing required):**

```python
import multiprocessing as mp
from PIL import Image
import numpy as np

def preprocess_image(path):
    """Preprocess single image (CPU-bound)."""
    img = Image.open(path)
    img = img.resize((224, 224))
    arr = np.array(img) / 255.0
    # Augmentation, normalization, etc.
    return arr

# REQUIRED multiprocessing (expensive fork/spawn)
with mp.Pool(8) as pool:
    results = pool.map(preprocess_image, image_paths)
```

**Downsides:**
- Heavy process overhead (fork/spawn)
- No shared memory (need to serialize/deserialize)
- Complex error handling
- Debugging difficult

**AFTER (No-GIL - threading works):**

```python
import threading
from concurrent.futures import ThreadPoolExecutor
from PIL import Image
import numpy as np

def preprocess_image(path):
    """Preprocess single image (CPU-bound).

    Note:
        This function is now truly parallelizable with threading
        in Python 3.13+ free-threaded mode.
    """
    img = Image.open(path)
    img = img.resize((224, 224))
    arr = np.array(img) / 255.0
    return arr

# Threading now works for CPU-bound tasks!
with ThreadPoolExecutor(max_workers=8) as executor:
    results = list(executor.map(preprocess_image, image_paths))
```

**Benefits:**
- ✅ Lightweight threads vs heavy processes
- ✅ Shared memory space (no serialization)
- ✅ Easier debugging
- ✅ Better resource utilization

### 3.2 Real-Time Inference Servers

**Example: Multi-Model Serving**

```python
# Python 3.14+ with no-GIL
import threading
from queue import Queue
from typing import List, Dict
import numpy as np

class MultiModelServer:
    """Serve multiple models with true parallel inference.

    In Python 3.14+ free-threaded mode, this achieves true
    multi-core parallelism for CPU inference tasks.

    Attributes:
        models: Dictionary of loaded models.
        request_queue: Thread-safe queue for inference requests.
        worker_threads: Pool of worker threads.
    """

    def __init__(self, model_configs: List[Dict], num_workers: int = 4):
        """Initialize multi-model server.

        Args:
            model_configs: List of model configuration dicts.
            num_workers: Number of worker threads (matches CPU cores).

        Note:
            In GIL builds, num_workers > 1 provides no benefit for
            CPU-bound inference. In free-threaded builds, scales linearly.
        """
        self.models = {cfg['name']: self.load_model(cfg)
                       for cfg in model_configs}
        self.request_queue = Queue()
        self.result_queues = {}

        # Spawn worker threads (truly parallel in no-GIL)
        self.workers = [
            threading.Thread(target=self._worker, daemon=True)
            for _ in range(num_workers)
        ]
        for worker in self.workers:
            worker.start()

    def _worker(self):
        """Worker thread for processing inference requests.

        This runs in parallel with other workers in free-threaded mode,
        enabling true multi-core CPU utilization.
        """
        while True:
            request = self.request_queue.get()
            if request is None:  # Shutdown signal
                break

            model_name, input_data, result_queue = request

            # CPU-bound inference (parallelized in no-GIL!)
            model = self.models[model_name]
            result = model.predict(input_data)

            result_queue.put(result)

    def infer(self, model_name: str, input_data: np.ndarray) -> np.ndarray:
        """Submit inference request.

        Args:
            model_name: Name of model to use.
            input_data: Input array for inference.

        Returns:
            Model prediction results.
        """
        result_queue = Queue()
        self.request_queue.put((model_name, input_data, result_queue))
        return result_queue.get()

# Usage
server = MultiModelServer([
    {'name': 'yolo', 'path': 'yolo.pt'},
    {'name': 'resnet', 'path': 'resnet.pt'},
], num_workers=8)

# These run in parallel across CPU cores (no-GIL)
results = []
for img in batch_images:
    result = server.infer('yolo', img)
    results.append(result)
```

### 3.3 Feature Engineering Pipelines

**Example: Parallel Feature Computation**

```python
import threading
import numpy as np
from typing import List, Callable

class ParallelFeatureExtractor:
    """Extract features in parallel using threading.

    Python 3.14+ free-threaded mode enables true parallel
    execution of CPU-bound feature extraction functions.

    Example:
        >>> extractor = ParallelFeatureExtractor([
        ...     compute_histogram,
        ...     compute_edges,
        ...     compute_texture
        ... ])
        >>> features = extractor.extract(image)
        >>> features.shape
        (512,)  # Concatenated features
    """

    def __init__(self, feature_funcs: List[Callable]):
        """Initialize feature extractor.

        Args:
            feature_funcs: List of functions that compute features.
                Each should take an image and return feature vector.
        """
        self.feature_funcs = feature_funcs

    def extract(self, image: np.ndarray) -> np.ndarray:
        """Extract all features in parallel.

        Args:
            image: Input image (H, W, C).

        Returns:
            Concatenated feature vector.

        Note:
            In Python 3.14+ free-threaded mode, feature functions
            execute truly in parallel on different CPU cores.
        """
        results = [None] * len(self.feature_funcs)
        threads = []

        def compute_feature(idx, func):
            results[idx] = func(image)

        # Launch threads (parallel in no-GIL)
        for idx, func in enumerate(self.feature_funcs):
            t = threading.Thread(
                target=compute_feature,
                args=(idx, func)
            )
            t.start()
            threads.append(t)

        # Wait for completion
        for t in threads:
            t.join()

        # Concatenate features
        return np.concatenate(results)

# Feature computation functions
def compute_histogram(img: np.ndarray) -> np.ndarray:
    """Compute color histogram (CPU-bound)."""
    hist, _ = np.histogram(img, bins=256)
    return hist

def compute_edges(img: np.ndarray) -> np.ndarray:
    """Compute edge features (CPU-bound)."""
    # Sobel, Canny, etc.
    return edge_features

def compute_texture(img: np.ndarray) -> np.ndarray:
    """Compute texture features (CPU-bound)."""
    # GLCM, LBP, etc.
    return texture_features

# Usage
extractor = ParallelFeatureExtractor([
    compute_histogram,
    compute_edges,
    compute_texture
])

# All three computations run in parallel (no-GIL)
features = extractor.extract(image)
```

### 3.4 Performance Considerations

**Speedup Expectations:**

| Task Type | GIL Build | No-GIL Build | Speedup |
|-----------|-----------|--------------|---------|
| Single-threaded CPU | 1.0x | 0.85-0.95x | -5-15% slower |
| Multi-threaded CPU (8 cores) | 1.0x | 6-7x | 6-7x faster |
| I/O-bound | 1.0x | 1.0x | No change |
| NumPy-heavy | 1.0x | 1.0x | No change (releases GIL) |
| Pure Python loops | 1.0x | 6-7x | 6-7x faster |

**Trade-offs:**

✅ **Pros:**
- True multi-core parallelism
- Simpler code (threads vs processes)
- Shared memory (no serialization)
- Better debugging experience

⚠️ **Cons:**
- Single-threaded overhead (~10-15% slower)
- Memory overhead (~10-15% higher)
- Need thread-safe code
- Library compatibility issues (transitional)

---

## 4. IMPLICATIONS FOR AI PROMPTS

### 4.1 The New Prompting Paradigm

**BEFORE (GIL era - Python 3.12 and earlier):**

```
❌ BAD PROMPT (assumes threading works for CPU tasks):
"Write a Python function to preprocess 10,000 images in parallel using threading."

✅ GOOD PROMPT (GIL-aware):
"Write a Python function to preprocess 10,000 images in parallel using
multiprocessing.Pool with 8 workers."
```

**AFTER (No-GIL era - Python 3.14+):**

```
✅ GOOD PROMPT (no-GIL aware):
"Write a Python 3.14+ function to preprocess 10,000 images in parallel
using concurrent.futures.ThreadPoolExecutor with 8 workers. Assume
free-threaded mode (no-GIL)."

✅ EVEN BETTER (explicit about version):
"Write a Python function for image preprocessing with the following:
- Target: Python 3.14+ free-threaded mode
- Use threading (not multiprocessing)
- ThreadPoolExecutor with worker count = CPU cores
- Include docstring noting no-GIL requirement
- Add compatibility check for free-threaded build"
```

### 4.2 Essential Prompt Components (No-GIL Era)

**1. Version Specification:**
```
"Python 3.14+ free-threaded mode" or
"Python 3.13+ with --disable-gil" or
"Assume no-GIL build"
```

**2. Threading Model:**
```
"Use threading for CPU-bound parallelism" or
"ThreadPoolExecutor for parallel processing" or
"Avoid multiprocessing (use threads instead)"
```

**3. Thread Safety:**
```
"Ensure thread-safe data structures" or
"Use threading.Lock for shared state" or
"Avoid global mutable state"
```

**4. Compatibility Check:**
```
"Include check for free-threaded build" or
"Detect and warn if GIL is enabled" or
"Provide fallback for GIL builds"
```

**5. Performance Context:**
```
"Optimize for 8-core CPU" or
"Target num_workers = os.cpu_count()" or
"Expect 6-7x speedup on 8 cores"
```

### 4.3 Complete Prompt Template

**Template for ML/CV Tasks:**

```
Task: [Describe what you want]

Requirements:
- Python Version: 3.14+ (free-threaded mode / no-GIL)
- Concurrency: Use threading (ThreadPoolExecutor)
- Workers: Match CPU core count
- Thread Safety: [Specify if shared state needed]
- Libraries: [List required packages with versions]
- Input: [Data format, size, source]
- Output: [Expected results]
- Performance: [Target metrics if applicable]

Code Style:
- Include Google-style docstrings
- Type hints for all functions
- Note no-GIL requirement in docstrings
- Add compatibility check for free-threaded build
- Handle errors gracefully

Example Usage:
[Provide example if helpful]
```

### 4.4 Example Prompts: Before vs After

**Example 1: Image Preprocessing**

**❌ OLD PROMPT (GIL-era):**
```
"Write a function to preprocess images in parallel."
```

**✅ NEW PROMPT (No-GIL):**
```
"Write a Python 3.14+ function to preprocess images in parallel:

Requirements:
- Use concurrent.futures.ThreadPoolExecutor (not multiprocessing)
- Workers: os.cpu_count()
- Process images: resize to 224x224, normalize to [0,1]
- Input: List of image file paths
- Output: numpy array of shape (N, 224, 224, 3)
- Thread-safe: Each thread processes different images (no shared state)

Include:
- Docstring noting free-threaded mode requirement
- Type hints
- Progress tracking (optional)
- Error handling for invalid images

Assume Python 3.14+ free-threaded build (no-GIL).
"
```

**Example 2: Feature Extraction**

**❌ OLD PROMPT (GIL-era):**
```
"Compute features from images using multiple cores."
```

**✅ NEW PROMPT (No-GIL):**
```
"Write a Python 3.14+ class for parallel feature extraction:

Class: ParallelFeatureExtractor

Methods:
- __init__(feature_funcs: List[Callable])
- extract(image: np.ndarray) -> np.ndarray

Requirements:
- Use threading.Thread (not multiprocessing)
- Run all feature_funcs in parallel on same image
- Concatenate results into single feature vector
- Thread-safe: Each thread computes different feature
- Python 3.14+ free-threaded mode (no-GIL)

Include:
- Google-style docstrings with no-GIL note
- Type hints
- Example usage in docstring
- Error handling

Features to support:
- Histogram computation (CPU-bound)
- Edge detection (CPU-bound)
- Texture analysis (CPU-bound)
"
```

**Example 3: Model Serving**

**❌ OLD PROMPT (GIL-era):**
```
"Create a multi-model inference server."
```

**✅ NEW PROMPT (No-GIL):**
```
"Write a Python 3.14+ multi-model inference server:

Class: MultiModelServer

Requirements:
- Use threading (not multiprocessing) for parallel inference
- Thread-safe request queue (queue.Queue)
- Worker threads: configurable (default: cpu_count())
- Support multiple models loaded simultaneously
- CPU-bound inference runs in parallel across workers

Methods:
- __init__(model_configs: List[Dict], num_workers: int)
- infer(model_name: str, input_data: np.ndarray) -> np.ndarray
- shutdown()

Thread Safety:
- Queue for requests
- No global mutable state
- Each worker processes different requests

Include:
- Docstrings noting no-GIL enables true parallel CPU inference
- Type hints
- Example with 2 models, 8 workers
- Graceful shutdown

Target: Python 3.14+ free-threaded build.
"
```

---

## 5. THREAD-SAFE PATTERNS FOR NO-GIL

### 5.1 Thread-Safe Data Structures

**Standard Library:**

```python
from queue import Queue, LifoQueue, PriorityQueue
from threading import Lock, RLock, Semaphore, Event, Condition
from collections import deque
import threading

# Thread-safe queue
task_queue = Queue()  # FIFO
result_queue = LifoQueue()  # LIFO
priority_queue = PriorityQueue()  # Priority-based

# Thread-safe deque (for bounded queues)
bounded_deque = deque(maxlen=1000)
lock = threading.Lock()

def thread_safe_append(item):
    """Thread-safe append to deque."""
    with lock:
        bounded_deque.append(item)
```

**Shared Counters:**

```python
import threading

class ThreadSafeCounter:
    """Thread-safe counter using lock.

    In Python 3.14+ free-threaded mode, explicit locking
    is required for shared mutable state.
    """

    def __init__(self):
        self._value = 0
        self._lock = threading.Lock()

    def increment(self):
        """Increment counter (thread-safe)."""
        with self._lock:
            self._value += 1

    def value(self):
        """Get current value (thread-safe)."""
        with self._lock:
            return self._value

# Usage
counter = ThreadSafeCounter()

def worker():
    for _ in range(1000):
        counter.increment()

threads = [threading.Thread(target=worker) for _ in range(8)]
for t in threads: t.start()
for t in threads: t.join()

print(counter.value())  # 8000 (guaranteed)
```

### 5.2 Lock-Free Patterns

**Immutable Data:**

```python
from typing import List, Tuple
import numpy as np

def process_batch_immutable(
    images: List[np.ndarray],  # Immutable input
    num_workers: int = 8
) -> List[np.ndarray]:
    """Process images with immutable pattern.

    No shared mutable state = no locks needed.
    Each thread reads from input list (immutable)
    and returns new results.

    Args:
        images: List of input images (not modified).
        num_workers: Number of worker threads.

    Returns:
        List of processed images.

    Note:
        Lock-free design works perfectly in Python 3.14+
        free-threaded mode.
    """
    from concurrent.futures import ThreadPoolExecutor

    def process_single(img):
        # Pure function - no side effects
        processed = img.copy()
        # Apply transformations
        return processed

    with ThreadPoolExecutor(max_workers=num_workers) as executor:
        results = list(executor.map(process_single, images))

    return results
```

**Thread-Local Storage:**

```python
import threading

# Thread-local storage (no synchronization needed)
thread_local = threading.local()

def initialize_worker():
    """Initialize thread-local resources.

    Each thread gets its own copy - no locking needed.
    """
    thread_local.model = load_model()
    thread_local.cache = {}
    thread_local.stats = {'processed': 0}

def process_with_thread_local(data):
    """Process using thread-local resources.

    No locks needed - each thread has isolated state.
    """
    if not hasattr(thread_local, 'model'):
        initialize_worker()

    result = thread_local.model.predict(data)
    thread_local.stats['processed'] += 1

    return result
```

### 5.3 Common Pitfalls to Avoid

**❌ PITFALL 1: Shared Mutable State**

```python
# BAD (race condition in no-GIL)
results = []  # Shared mutable list

def worker(item):
    processed = process(item)
    results.append(processed)  # NOT thread-safe!

# GOOD (thread-safe)
from queue import Queue

results = Queue()  # Thread-safe queue

def worker(item):
    processed = process(item)
    results.put(processed)  # Thread-safe
```

**❌ PITFALL 2: Unprotected Counters**

```python
# BAD (race condition)
counter = 0

def worker():
    global counter
    counter += 1  # NOT atomic in no-GIL!

# GOOD (use lock)
import threading

counter = 0
counter_lock = threading.Lock()

def worker():
    global counter
    with counter_lock:
        counter += 1  # Thread-safe
```

**❌ PITFALL 3: Assuming NumPy is Thread-Safe**

```python
# BAD (NumPy arrays are not thread-safe for writes)
shared_array = np.zeros((1000, 1000))

def worker(idx):
    shared_array[idx] = compute(idx)  # Race condition!

# GOOD (each thread gets separate array)
def worker(idx):
    result = compute(idx)
    return idx, result

with ThreadPoolExecutor() as executor:
    results = executor.map(worker, range(1000))

shared_array = np.zeros((1000, 1000))
for idx, value in results:
    shared_array[idx] = value
```

---

## 6. LIBRARY COMPATIBILITY MATRIX

### 6.1 Current Status (as of early 2025)

| Library | Python 3.13 (experimental) | Python 3.14+ (target) | Notes |
|---------|---------------------------|----------------------|-------|
| **NumPy** | 🟡 Partial (1.26+) | 🟢 Full support expected | Some operations thread-safe |
| **SciPy** | 🔴 Limited | 🟡 Partial support | Depends on NumPy |
| **PyTorch** | 🔴 Not compatible | 🟡 Work in progress | Major rewrite needed |
| **TensorFlow** | 🔴 Not compatible | 🟡 Work in progress | Major rewrite needed |
| **Pandas** | 🟡 Partial | 🟢 Expected support | Pure Python parts work |
| **Scikit-learn** | 🟡 Partial | 🟢 Expected support | Joblib backend updates |
| **OpenCV (cv2)** | 🟢 Compatible | 🟢 Compatible | C++ extension, already thread-safe |
| **Pillow (PIL)** | 🟢 Compatible | 🟢 Compatible | Works in no-GIL mode |
| **Matplotlib** | 🟡 Partial | 🟢 Expected support | Some backends compatible |
| **requests** | 🟢 Compatible | 🟢 Compatible | Pure Python, I/O-bound |
| **asyncio** | 🟢 Compatible | 🟢 Compatible | Event loop compatible |

**Legend:**
- 🟢 Compatible / Full support
- 🟡 Partial support / Work in progress
- 🔴 Not compatible / Major issues

### 6.2 Checking Compatibility at Runtime

```python
import sys
import sysconfig

def check_free_threaded():
    """Check if running in free-threaded mode.

    Returns:
        bool: True if free-threaded (no-GIL), False otherwise.

    Example:
        >>> check_free_threaded()
        True  # In Python 3.14+ free-threaded build
    """
    # Method 1: Check sysconfig
    gil_disabled = sysconfig.get_config_var('Py_GIL_DISABLED')
    if gil_disabled == 1:
        return True

    # Method 2: Check sys.flags (Python 3.13+)
    if hasattr(sys, 'flags') and hasattr(sys.flags, 'gil'):
        return sys.flags.gil == 0

    return False

def require_free_threaded():
    """Raise error if not in free-threaded mode.

    Raises:
        RuntimeError: If GIL is enabled.

    Example:
        >>> require_free_threaded()  # In no-GIL build
        # Passes silently
        >>> require_free_threaded()  # In GIL build
        RuntimeError: This code requires free-threaded Python build
    """
    if not check_free_threaded():
        raise RuntimeError(
            "This code requires Python 3.14+ free-threaded build "
            "(no-GIL). Current build has GIL enabled."
        )

# Use in your code
def parallel_process(data):
    """Process data in parallel (requires no-GIL).

    Args:
        data: Input data to process.

    Raises:
        RuntimeError: If not running in free-threaded mode.

    Note:
        Requires Python 3.14+ free-threaded build for
        true parallel execution.
    """
    require_free_threaded()

    # Threading code here
    ...
```

### 6.3 Fallback Strategies

```python
def process_parallel(items, num_workers=8):
    """Process items in parallel with automatic fallback.

    Uses threading in free-threaded mode, multiprocessing otherwise.

    Args:
        items: Items to process.
        num_workers: Number of parallel workers.

    Returns:
        List of processed items.

    Note:
        Automatically detects free-threaded mode and chooses
        optimal parallelism strategy.
    """
    if check_free_threaded():
        # Use threading (lightweight, efficient)
        from concurrent.futures import ThreadPoolExecutor
        with ThreadPoolExecutor(max_workers=num_workers) as executor:
            return list(executor.map(process_item, items))
    else:
        # Fallback to multiprocessing (GIL build)
        from multiprocessing import Pool
        with Pool(num_workers) as pool:
            return pool.map(process_item, items)

def process_item(item):
    """Process single item (CPU-bound)."""
    # Implementation
    return result
```

---

## 7. MIGRATION GUIDE

### 7.1 From Multiprocessing to Threading

**BEFORE (GIL - multiprocessing):**

```python
from multiprocessing import Pool
import numpy as np

def process_chunk(chunk):
    """Process data chunk (CPU-bound)."""
    result = np.zeros(len(chunk))
    for i, item in enumerate(chunk):
        result[i] = expensive_computation(item)
    return result

if __name__ == '__main__':
    data = load_data()
    chunks = np.array_split(data, 8)

    with Pool(8) as pool:
        results = pool.map(process_chunk, chunks)

    final = np.concatenate(results)
```

**AFTER (No-GIL - threading):**

```python
from concurrent.futures import ThreadPoolExecutor
import numpy as np

def process_chunk(chunk):
    """Process data chunk (CPU-bound).

    Note:
        Truly parallelized in Python 3.14+ free-threaded mode.
        Each thread runs on different CPU core.
    """
    result = np.zeros(len(chunk))
    for i, item in enumerate(chunk):
        result[i] = expensive_computation(item)
    return result

# No __main__ guard needed
data = load_data()
chunks = np.array_split(data, 8)

with ThreadPoolExecutor(max_workers=8) as executor:
    results = list(executor.map(process_chunk, chunks))

final = np.concatenate(results)
```

**Benefits of Migration:**
- ✅ Simpler code (no `if __name__ == '__main__'`)
- ✅ Shared memory (no pickling)
- ✅ Better debugging (threads easier than processes)
- ✅ Lower overhead (threads lighter than processes)

### 7.2 Step-by-Step Migration

**Step 1: Identify CPU-Bound Code**
```python
# Look for:
# - multiprocessing.Pool
# - ProcessPoolExecutor
# - joblib.Parallel with backend='multiprocessing'
```

**Step 2: Check Library Compatibility**
```python
# Ensure all libraries support free-threaded mode
import numpy as np
print(np.__version__)  # Need 1.26+ for no-GIL

# Test imports
try:
    import your_library
    # Test basic operations
except Exception as e:
    print(f"Library not compatible: {e}")
```

**Step 3: Replace Multiprocessing with Threading**
```python
# Before
from multiprocessing import Pool
with Pool(8) as pool:
    results = pool.map(func, items)

# After
from concurrent.futures import ThreadPoolExecutor
with ThreadPoolExecutor(max_workers=8) as executor:
    results = list(executor.map(func, items))
```

**Step 4: Add Thread Safety**
```python
# Audit for shared mutable state
# Add locks where needed
from threading import Lock

shared_resource_lock = Lock()

def thread_safe_update(value):
    with shared_resource_lock:
        shared_resource.update(value)
```

**Step 5: Test and Benchmark**
```python
import time
from concurrent.futures import ThreadPoolExecutor

def benchmark(func, items, num_workers):
    start = time.time()
    with ThreadPoolExecutor(max_workers=num_workers) as executor:
        list(executor.map(func, items))
    elapsed = time.time() - start
    print(f"Workers: {num_workers}, Time: {elapsed:.2f}s")

# Test scaling
for workers in [1, 2, 4, 8]:
    benchmark(process_item, items, workers)
```

---

## 8. PROMPTING STRATEGIES FOR AI CODING ASSISTANTS

### 8.1 Prompt Structure Template

```
[TASK DESCRIPTION]

Python Version: 3.14+ (free-threaded mode / no-GIL)
Concurrency Model: threading (not multiprocessing)

Requirements:
- Threading: Use concurrent.futures.ThreadPoolExecutor
- Workers: [Specify number or os.cpu_count()]
- Thread Safety: [Specify shared state handling]
- Libraries: [List with version requirements]
- Performance: [Expected speedup or targets]

Code Standards:
- Google-style docstrings
- Type hints (PEP 484)
- Note no-GIL requirement in docstrings
- Include compatibility check
- Error handling

[OPTIONAL: Example usage or edge cases]
```

### 8.2 Context-Setting Phrases

**Version/Build Specification:**
- ✅ "Python 3.14+ free-threaded mode"
- ✅ "Assume no-GIL build (Python 3.14+)"
- ✅ "Target: Python 3.13+ with --disable-gil"
- ❌ "Use latest Python" (too vague)
- ❌ "Python 3.x" (doesn't specify no-GIL)

**Concurrency Model:**
- ✅ "Use threading for CPU-bound parallelism"
- ✅ "ThreadPoolExecutor with N workers"
- ✅ "Avoid multiprocessing (threading works now)"
- ❌ "Use parallel processing" (ambiguous)
- ❌ "Make it concurrent" (vague)

**Thread Safety:**
- ✅ "Use threading.Lock for shared counter"
- ✅ "Each thread processes different items (no shared state)"
- ✅ "Thread-safe queue for results"
- ❌ "Make it thread-safe" (too vague)

**Performance:**
- ✅ "Expect 6-7x speedup on 8 cores"
- ✅ "Linear scaling up to cpu_count() workers"
- ✅ "Optimize for multi-core CPU utilization"
- ❌ "Make it fast" (vague)

### 8.3 Example Prompts (Complete)

**Prompt 1: Data Augmentation Pipeline**

```
Create a data augmentation pipeline for image preprocessing:

Task:
Write a class that applies random augmentations to images in parallel.

Python Version: 3.14+ (free-threaded mode)
Concurrency: threading (ThreadPoolExecutor)

Requirements:
- Class: ParallelAugmenter
- Methods:
  - __init__(augmentations: List[Callable], num_workers: int = 8)
  - augment_batch(images: List[np.ndarray]) -> List[np.ndarray]
- Augmentations: Each function takes np.ndarray, returns np.ndarray
- Thread-safe: Each thread processes different images
- Workers: Default to os.cpu_count()
- No shared mutable state

Augmentations to support:
- Random flip (horizontal/vertical)
- Random rotation (-30 to +30 degrees)
- Random brightness (±20%)
- Random crop (resize to original size)

Code Standards:
- Google-style docstrings
- Note: "Requires Python 3.14+ free-threaded mode for parallel CPU execution"
- Type hints for all methods
- Include example usage in docstring
- Add check_free_threaded() compatibility check

Example Usage:
>>> augmenter = ParallelAugmenter([flip, rotate, brightness], num_workers=8)
>>> augmented = augmenter.augment_batch(images)
>>> len(augmented) == len(images)
True
```

**Prompt 2: Feature Extraction Server**

```
Create a real-time feature extraction server:

Task:
Build a server that extracts features from images using multiple models.

Python Version: 3.14+ (free-threaded mode)
Concurrency: threading (worker threads + request queue)

Requirements:
- Class: FeatureExtractionServer
- Methods:
  - __init__(model_configs: List[Dict], num_workers: int = 4)
  - extract(image: np.ndarray, model_names: List[str]) -> Dict[str, np.ndarray]
  - shutdown()
- Thread-safe queue for requests (queue.Queue)
- Worker threads process requests in parallel
- Support multiple models loaded simultaneously
- Each request can use one or more models

Architecture:
- Request queue (thread-safe)
- Worker threads (num_workers)
- Result queues (per request)
- Model dictionary (shared, read-only)

Thread Safety:
- Queue.Queue for request/result passing
- No shared mutable state
- Models loaded once (read-only access)

Code Standards:
- Google-style docstrings
- Note: "Free-threaded mode enables true parallel feature extraction"
- Type hints
- Include graceful shutdown
- Add compatibility check

Performance:
- Expect linear scaling up to num_workers
- Support concurrent requests from multiple clients

Example:
>>> server = FeatureExtractionServer([
...     {'name': 'resnet', 'path': 'resnet50.pt'},
...     {'name': 'vgg', 'path': 'vgg16.pt'}
... ], num_workers=8)
>>> features = server.extract(image, ['resnet', 'vgg'])
>>> features.keys()
dict_keys(['resnet', 'vgg'])
```

**Prompt 3: Batch Inference Optimizer**

```
Optimize batch inference for CPU-bound model:

Task:
Create a function that processes batches in parallel with dynamic batching.

Python Version: 3.14+ (free-threaded mode)
Concurrency: ThreadPoolExecutor

Requirements:
- Function: parallel_inference(model, items: List, batch_size: int, num_workers: int)
- Split items into batches
- Process batches in parallel across workers
- Each worker runs model.predict(batch)
- Concatenate results in original order
- Thread-safe: No shared mutable state

Features:
- Dynamic batching (last batch can be smaller)
- Order preservation (results match input order)
- Progress tracking (optional, thread-safe)
- Error handling (skip failed batches with warning)

Code Standards:
- Google-style docstrings
- Type hints
- Note: "Python 3.14+ free-threaded mode required"
- Include usage example
- Add check for free-threaded build

Performance Target:
- 6-7x speedup on 8-core CPU
- Linear scaling up to cpu_count()

Example:
>>> model = load_model('resnet50')
>>> items = [load_image(p) for p in paths]  # 10,000 images
>>> results = parallel_inference(model, items, batch_size=32, num_workers=8)
>>> len(results) == len(items)
True
# Processing time: ~8x faster than sequential
```

### 8.4 Anti-Patterns in Prompts

**❌ BAD PROMPT (too vague):**
```
"Make this function run in parallel"
```
**Issues:**
- No version specified
- No concurrency model (threads? processes?)
- No thread safety guidance
- No library compatibility consideration

**✅ GOOD PROMPT:**
```
"Convert this function to use threading for parallelism:

Python Version: 3.14+ (free-threaded mode)
Concurrency: ThreadPoolExecutor with 8 workers
Thread Safety: Each thread processes different items (no shared state)
Libraries: NumPy 1.26+, Pillow 10.0+

Include:
- Google-style docstring noting no-GIL requirement
- Type hints
- Compatibility check for free-threaded build
"
```

**❌ BAD PROMPT (assumes multiprocessing):**
```
"Use multiprocessing.Pool to speed this up"
```
**Issues:**
- Outdated pattern (multiprocessing not needed in no-GIL)
- Misses opportunity for simpler threading approach
- Higher overhead than necessary

**✅ GOOD PROMPT:**
```
"Parallelize this function using threading (not multiprocessing):

Python Version: 3.14+ free-threaded mode
Use: concurrent.futures.ThreadPoolExecutor
Workers: os.cpu_count()
Note: Threading is sufficient for CPU-bound work in no-GIL builds
"
```

---

## 9. PERFORMANCE BENCHMARKING

### 9.1 Measuring Speedup

```python
import time
import os
from concurrent.futures import ThreadPoolExecutor
from typing import Callable, List, Any

def benchmark_parallel(
    func: Callable,
    items: List[Any],
    max_workers_range: List[int] = None
) -> None:
    """Benchmark function with different worker counts.

    Args:
        func: Function to benchmark (should be CPU-bound).
        items: List of items to process.
        max_workers_range: List of worker counts to test.
            Defaults to [1, 2, 4, 8, cpu_count()].

    Example:
        >>> items = [load_image(p) for p in paths[:100]]
        >>> benchmark_parallel(preprocess_image, items)
        Workers: 1, Time: 10.5s, Speedup: 1.0x
        Workers: 2, Time: 5.4s, Speedup: 1.9x
        Workers: 4, Time: 2.8s, Speedup: 3.8x
        Workers: 8, Time: 1.5s, Speedup: 7.0x

    Note:
        Requires Python 3.14+ free-threaded mode to see
        linear speedup with worker count.
    """
    if max_workers_range is None:
        cpu_count = os.cpu_count() or 8
        max_workers_range = [1, 2, 4, 8, cpu_count]
        max_workers_range = sorted(set(max_workers_range))

    baseline_time = None

    for num_workers in max_workers_range:
        start = time.time()

        if num_workers == 1:
            # Sequential baseline
            results = [func(item) for item in items]
        else:
            # Parallel execution
            with ThreadPoolExecutor(max_workers=num_workers) as executor:
                results = list(executor.map(func, items))

        elapsed = time.time() - start

        if baseline_time is None:
            baseline_time = elapsed
            speedup = 1.0
        else:
            speedup = baseline_time / elapsed

        print(f"Workers: {num_workers:2d}, "
              f"Time: {elapsed:6.2f}s, "
              f"Speedup: {speedup:.2f}x")
```

### 9.2 Expected Performance Characteristics

**CPU-Bound Tasks (No-GIL):**

```
Workers |  Time  | Speedup | Efficiency
--------|--------|---------|------------
   1    | 10.0s  |  1.0x   |   100%
   2    |  5.2s  |  1.9x   |    95%
   4    |  2.7s  |  3.7x   |    93%
   8    |  1.5s  |  6.7x   |    84%
  16    |  0.9s  | 11.1x   |    69%
```

**Why Not Perfect Scaling:**
- Synchronization overhead
- Memory bandwidth limits
- Cache contention
- Load imbalance

**Single-Threaded Overhead:**
```
GIL Build (3.12):     1.00x baseline
No-GIL Build (3.14):  0.90x (10% slower)
```

### 9.3 Profiling Tools

```python
import cProfile
import pstats
from concurrent.futures import ThreadPoolExecutor

def profile_parallel(func, items, num_workers=8):
    """Profile parallel execution.

    Args:
        func: Function to profile.
        items: Items to process.
        num_workers: Number of worker threads.
    """
    profiler = cProfile.Profile()
    profiler.enable()

    with ThreadPoolExecutor(max_workers=num_workers) as executor:
        list(executor.map(func, items))

    profiler.disable()

    # Print stats
    stats = pstats.Stats(profiler)
    stats.sort_stats('cumulative')
    stats.print_stats(20)

# Usage
profile_parallel(preprocess_image, images, num_workers=8)
```

---

## 10. FUTURE OUTLOOK

### 10.1 Python 3.15+ (2026+)

**Expected Features:**
- Free-threaded as default build
- GIL available via flag (for compatibility)
- Performance optimizations (reduced overhead)
- Full ecosystem compatibility
- JIT compiler integration (faster single-threaded)

**Ecosystem Maturity:**
- All major ML/CV libraries compatible
- Stable ABI for C extensions
- Mature tooling (debuggers, profilers)
- Best practices established

### 10.2 Long-Term Implications

**For ML/CV Engineering:**
- ✅ Threading becomes default for parallelism
- ✅ Multiprocessing relegated to isolation needs
- ✅ Simpler concurrent code
- ✅ Better resource utilization
- ✅ Faster development iteration

**For AI Coding Assistants:**
- ✅ Default to threading in prompts
- ✅ Assume no-GIL for Python 3.15+
- ✅ Simpler prompt templates
- ✅ Better performance by default

**For Education:**
- ✅ Easier to teach concurrency
- ✅ Threading examples actually work
- ✅ Less confusion about GIL
- ✅ Better alignment with other languages

---

## 11. QUICK REFERENCE

### 11.1 Prompt Checklist

When prompting for parallel ML/CV code:

- [ ] Specify Python version (3.14+ for no-GIL)
- [ ] Specify concurrency model (threading preferred)
- [ ] Indicate worker count (cpu_count() typical)
- [ ] Clarify thread safety requirements
- [ ] List library dependencies with versions
- [ ] Request compatibility check in code
- [ ] Ask for docstring noting no-GIL requirement
- [ ] Specify performance expectations
- [ ] Include error handling requirements

### 11.2 Code Template

```python
"""
Module for [description].

Requires Python 3.14+ free-threaded mode (no-GIL) for
optimal parallel performance.
"""

import os
import sys
import sysconfig
from concurrent.futures import ThreadPoolExecutor
from typing import List, Any
import numpy as np

def check_free_threaded() -> bool:
    """Check if running in free-threaded mode."""
    gil_disabled = sysconfig.get_config_var('Py_GIL_DISABLED')
    return gil_disabled == 1

def parallel_process(
    items: List[Any],
    num_workers: int = None
) -> List[Any]:
    """Process items in parallel using threading.

    Args:
        items: Items to process.
        num_workers: Number of worker threads.
            Defaults to os.cpu_count().

    Returns:
        List of processed items.

    Raises:
        RuntimeError: If not running in free-threaded mode.

    Note:
        Requires Python 3.14+ free-threaded build for
        true parallel CPU execution. Single-threaded
        performance may be 10-15% slower than GIL builds.

    Example:
        >>> items = load_data()
        >>> results = parallel_process(items, num_workers=8)
        >>> len(results) == len(items)
        True
    """
    if not check_free_threaded():
        raise RuntimeError(
            "This function requires Python 3.14+ free-threaded "
            "build (no-GIL). Current build has GIL enabled."
        )

    if num_workers is None:
        num_workers = os.cpu_count() or 8

    with ThreadPoolExecutor(max_workers=num_workers) as executor:
        results = list(executor.map(process_item, items))

    return results

def process_item(item: Any) -> Any:
    """Process single item (CPU-bound).

    This function is CPU-bound and benefits from
    parallel execution in free-threaded mode.
    """
    # Implementation
    return result

if __name__ == '__main__':
    # Test
    items = generate_test_data(1000)
    results = parallel_process(items, num_workers=8)
    print(f"Processed {len(results)} items")
```

### 11.3 Essential Commands

```bash
# Check Python build type
python3.14 -VV
# Output: Python 3.14.0 experimental free-threaded build

# Run with GIL disabled
python3.14 -X gil=0 script.py

# Run with GIL enabled (compatibility)
python3.14 -X gil=1 script.py

# Install free-threaded Python from source
./configure --disable-gil
make -j8
make install

# Check NumPy compatibility
python -c "import numpy; print(numpy.__version__)"
# Need 1.26+ for no-GIL support
```

---

## 12. RESOURCES

### 12.1 Official Documentation

- **PEP 703:** https://peps.python.org/pep-0703/
- **Python 3.13 Release Notes:** https://docs.python.org/3.13/whatsnew/3.13.html
- **Free-Threading Design:** https://docs.python.org/3.13/howto/free-threading-python.html
- **Porting Guide:** https://docs.python.org/3.13/howto/free-threading-extensions.html

### 12.2 Key Articles and Talks

- **Sam Gross - PEP 703 Announcement:** https://discuss.python.org/t/pep-703-making-the-global-interpreter-lock-optional-in-cpython/
- **Python 3.13 Free-Threading FAQ:** https://py-free-threading.github.io/
- **NumPy Free-Threading Status:** https://github.com/numpy/numpy/issues/
- **Thread Safety in Python 3.13+:** https://docs.python.org/3.13/library/threading.html

### 12.3 Benchmarks and Performance

- **Free-Threading Benchmarks:** https://github.com/python/cpython/issues/
- **PyPerformance Suite:** https://github.com/python/pyperformance
- **Real-World Benchmarks:** https://github.com/faster-cpython/benchmarking

### 12.4 Library Compatibility Tracking

- **NumPy Status:** https://github.com/numpy/numpy/labels/free-threading
- **SciPy Status:** https://github.com/scipy/scipy/labels/free-threading
- **PyTorch Discussion:** https://github.com/pytorch/pytorch/discussions/
- **Community Tracker:** https://py-free-threading.github.io/tracking/

---

**END OF NOTES**

**Last Updated:** 2026-02-01
**Next Review:** When Python 3.14 stable releases (expected Oct 2025)
**Critical for:** Prompting AI coding assistants for modern Python ML/CV code
