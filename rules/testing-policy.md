# Testing Policy

**Status:** Authoritative
**Last updated:** 2026-03-20
**Purpose:** Language-specific testing standards for CV/ML engineering with strict artifact isolation

---

### 7.0 Testing Philosophy

#### Core Principle

> **Tests validate specifications, prevent regressions, and enforce invariants. They are binding contracts, not optional documentation.**

#### Integration with Existing Policies

This testing policy enforces:
- **Artifact isolation** (see `development-environment-policy.md §Repository Isolation Rules`)
- **Spec-driven verification** (see `ai-workflow-policy.md Part 4: Spec-Driven Development`)
- **Container-first execution** (see `development-environment-policy.md §Infrastructure Services Rule`)
- **Production stewardship** (see `production-policy.md §Production Ownership and Stewardship`)

---

### 7.1 Test Classification

#### 7.1.1 Unit Tests

**Definition:**
Tests of **pure logic** in complete isolation from external systems.

**Characteristics:**
- No network, filesystem, database, GPU, or running services
- Deterministic (fixed seeds, stable ordering, explicit tolerances)
- Fast (<100ms per test, <10s total suite per module)
- Execute in-process without containers

**Location:**
- Test code: `<repo>/tests/unit/`
- Fixtures (tiny): `<repo>/tests/fixtures/` (committed to Git)
- Generated test data: `~/test-data/<project>/unit/` (never committed)

**What to unit test:**
- Math, geometry, tensor shape rules, coordinate transforms
- Parsers, serializers, schema validators
- Pre/post-processing: resize, crop, normalize, bbox transforms
- Camera intrinsics/extrinsics calculations
- Numerical edge cases (NaN/inf handling, division by zero)

**What NOT to unit test:**
- Anything requiring network access
- Real datasets (use tiny fixtures or `~/test-data/`)
- Model training (use integration tests)
- Services with state (use integration tests)

---

#### 7.1.2 Integration Tests

**Definition:**
Tests of **component interactions** within controlled boundaries.

**Characteristics:**
- May use containers, local databases, mock services
- May use small real datasets from `~/datasets/` or `~/test-data/`
- Deterministic where possible (controlled inputs, fixed configs)
- Moderate speed (<5s per test, <2min total suite)
- Execute in Docker Compose or with mounted volumes

**Location:**
- Test code: `<repo>/tests/integration/`
- Test configs: `<repo>/tests/integration/configs/`
- Test data: `~/test-data/<project>/integration/` (never committed)
- Container definitions: `<repo>/tests/integration/docker-compose.yml`

**What to integration test:**
- Pipeline end-to-end (ingest → process → output)
- Model inference with sample data
- Database schema migrations
- Service-to-service communication (mocked external APIs)
- ROS node message passing (mocked sensor topics)
- MLflow experiment tracking workflow

**Container execution pattern:**
```bash
# From repo root
cd tests/integration/
docker-compose up -d postgres kafka
pytest test_pipeline.py --mount ~/test-data/myproject/integration:/data
docker-compose down
```

---

#### 7.1.3 System Tests

**Definition:**
Tests of **complete system behavior** in production-like environments.

**Characteristics:**
- Full stack deployment (all services, real infrastructure)
- Real or production-representative datasets
- May be non-deterministic (timing, concurrency)
- Slow (minutes to hours)
- Execute in staging environment or local Kubernetes

**Location:**
- Test code: `<repo>/tests/system/`
- Infrastructure: `<repo>/tests/system/k8s/` or `~/docker/<project>-test/`
- Test data: `~/datasets/<immutable-snapshot>/` or cloud storage

**What to system test:**
- Multi-service workflows (data ingestion → training → serving → monitoring)
- Model serving under load
- Data pipeline correctness with real datasets
- Disaster recovery procedures
- Performance benchmarks

**Execution pattern:**
```bash
# Deploy to local k8s or docker-compose
kubectl apply -f tests/system/k8s/
pytest tests/system/ --env=local-k8s --dataset=~/datasets/validation-2026-01-15/
kubectl delete -f tests/system/k8s/
```

---

### 7.2 Cross-Cutting Policies (All Languages)

#### 7.2.1 Determinism

**Requirements:**
- Fixed random seeds for all stochastic operations
- Stable sort ordering (never rely on dict/set iteration order)
- Explicit numerical tolerances (never use exact equality for floats)
- Golden fixtures where appropriate (small arrays, tiny images, sample JSON)

**Example (Python):**
```python
import numpy as np
import random

def setup_module():
    np.random.seed(42)
    random.seed(42)
    torch.manual_seed(42)

def test_transform():
    # Explicit tolerance
    assert np.allclose(result, expected, rtol=1e-5, atol=1e-8)
```

---

#### 7.2.2 Test Structure (AAA Pattern)

**Mandatory structure:**
1. **Arrange:** Set up inputs, fixtures, and preconditions
2. **Act:** Execute the code under test (single operation)
3. **Assert:** Verify expected outcomes

**One behavior per test:**
```python
# GOOD: Single behavior
def test_bbox_clipping_at_image_boundary():
    image_size = (640, 480)
    bbox = BBox(x=620, y=460, w=50, h=50)
    clipped = clip_bbox(bbox, image_size)
    assert clipped == BBox(x=620, y=460, w=20, h=20)

# BAD: Multiple behaviors
def test_bbox_operations():
    # Tests clipping, scaling, AND rotation
    ...
```

---

#### 7.2.3 Test Data Isolation

**Rules:**
- **Tiny fixtures** (< 1MB total): commit to `<repo>/tests/fixtures/`
- **Small test data** (1MB - 100MB): store in `~/test-data/<project>/`
- **Large test data** (> 100MB): store in `~/datasets/` as immutable snapshots
- **Never commit** generated outputs, model checkpoints, or large binaries

**Fixture organization:**
```text
<repo>/tests/fixtures/
├── images/
│   ├── cat-32x32.png         # Tiny image (< 10KB)
│   └── bbox-test-image.jpg   # Small test image
├── json/
│   └── valid-manifest.json   # Schema validation fixture
└── arrays/
    └── transform-golden.npy  # Small numpy array
```

---

#### 7.2.4 CI/CD Gating

**Requirements:**
- Unit tests **MUST** run on every PR (< 10s total)
- Integration tests **SHOULD** run on every PR (< 2min total)
- System tests **MAY** run on merge to main or nightly
- GPU tests **MUST** be tagged/segmented for runners with GPU access

**CI configuration example (GitHub Actions):**
```yaml
test-unit:
  runs-on: ubuntu-latest
  steps:
    - run: pytest tests/unit/ -v --maxfail=1

test-integration:
  runs-on: ubuntu-latest
  services:
    postgres:
      image: postgres:15
  steps:
    - run: pytest tests/integration/ -v

test-gpu:
  runs-on: self-hosted-gpu
  if: github.event_name == 'push'  # Only on merge
  steps:
    - run: pytest tests/unit/ -m gpu
```

---

#### 7.2.5 Spec Validation in Tests

**Requirement:**
Every test suite **MUST** include contract tests validating implementation against committed specs.

**For projects using Spec Kit (`.specify/`):**
```python
# tests/test_spec_contract.py
import yaml
from pathlib import Path

def test_api_matches_spec():
    spec_path = Path(__file__).parent.parent / '.specify/specs/001-api/spec.md'
    spec = parse_spec(spec_path)

    # Validate implemented endpoints match spec
    for endpoint in spec['endpoints']:
        assert has_route(app, endpoint['path'])
        assert endpoint['method'] in get_methods(app, endpoint['path'])
```

**For projects using OpenSpec (`openspec/`):**
```python
# tests/test_openspec_contract.py
def test_current_spec_reflects_implementation():
    current_spec = parse_openspec('openspec/specs/api-v1.yaml')

    # Extract actual routes from implementation
    actual_routes = extract_routes(app)
    spec_routes = current_spec['paths'].keys()

    assert set(actual_routes) == set(spec_routes)
```

---

### 7.3 Language-Specific Policies

#### 7.3.1 Python Testing Policy

**Framework:** `pytest` (mandatory)

**Setup:**
```bash
# Virtual environment (lives in ~/dev/venvs/<project>/)
cd ~/dev/repos/github.com/alfonsocruzvelasco/<project>
source ~/dev/venvs/<project>/bin/activate

# Install dev dependencies
pip install pytest pytest-cov pytest-xdist hypothesis --break-system-packages

# Run tests
pytest tests/unit/ -v --cov=src --cov-report=term-missing
```

**Directory structure:**
```text
<repo>/
├── src/
│   └── myproject/
├── tests/
│   ├── __init__.py
│   ├── conftest.py           # Shared fixtures
│   ├── unit/
│   │   ├── test_transforms.py
│   │   └── test_parsers.py
│   ├── integration/
│   │   ├── docker-compose.yml
│   │   └── test_pipeline.py
│   └── fixtures/             # Tiny fixtures (committed)
│       └── sample-image.png
└── pyproject.toml
```

**What to unit test:**
- Dataset path resolution, manifest parsing, label mapping
- Pre/post-processing: resize, crop, normalize, bbox transforms
- Tensor shape/dtype invariants (use `hypothesis` for property testing)
- Serialization/deserialization with tiny fixtures
- Camera math: intrinsics, extrinsics, projection/unprojection

**Fixture best practices:**
```python
# conftest.py
import pytest
import numpy as np
from pathlib import Path

@pytest.fixture
def tiny_image():
    """32x32 RGB image for fast tests."""
    return np.random.randint(0, 255, (32, 32, 3), dtype=np.uint8)

@pytest.fixture
def sample_manifest(tmp_path):
    """Manifest JSON fixture."""
    manifest = {
        "images": [{"id": 1, "path": "img1.jpg"}],
        "labels": [{"id": 1, "category": "cat"}]
    }
    path = tmp_path / "manifest.json"
    path.write_text(json.dumps(manifest))
    return path

@pytest.fixture(scope="session")
def test_dataset_path():
    """Path to integration test data (never committed)."""
    return Path.home() / "test-data" / "myproject" / "integration"
```

**Parametrization for edge cases:**
```python
@pytest.mark.parametrize("bbox,expected", [
    (BBox(0, 0, 10, 10), BBox(0, 0, 10, 10)),        # Normal
    (BBox(-5, -5, 10, 10), BBox(0, 0, 5, 5)),        # Negative origin
    (BBox(630, 470, 50, 50), BBox(630, 470, 10, 10)) # Exceeds boundary
])
def test_bbox_clipping(bbox, expected):
    result = clip_bbox(bbox, image_size=(640, 480))
    assert result == expected
```

**Property-based testing with Hypothesis:**
```python
from hypothesis import given, strategies as st

@given(
    width=st.integers(min_value=1, max_value=1920),
    height=st.integers(min_value=1, max_value=1080)
)
def test_resize_preserves_aspect_ratio(width, height):
    image = np.random.rand(height, width, 3)
    resized = resize_with_aspect_ratio(image, target_width=640)

    original_ratio = width / height
    resized_ratio = resized.shape[1] / resized.shape[0]
    assert abs(original_ratio - resized_ratio) < 1e-6
```

**Mocking external systems:**
```python
from unittest.mock import patch, MagicMock

def test_load_dataset_from_s3(monkeypatch):
    # Mock S3 client
    mock_s3 = MagicMock()
    mock_s3.download_file.return_value = None
    monkeypatch.setattr('boto3.client', lambda x: mock_s3)

    # Test uses mock
    dataset = load_dataset('s3://bucket/dataset.parquet')
    assert mock_s3.download_file.called
```

**GPU test tagging:**
```python
import pytest

@pytest.mark.gpu
def test_cuda_kernel_correctness():
    if not torch.cuda.is_available():
        pytest.skip("CUDA not available")

    # CPU reference
    cpu_result = reference_implementation(input_tensor.cpu())

    # GPU implementation
    gpu_result = cuda_kernel(input_tensor.cuda()).cpu()

    assert torch.allclose(cpu_result, gpu_result, rtol=1e-5)
```

**Integration test example:**
```python
# tests/integration/test_pipeline.py
import pytest
from pathlib import Path

@pytest.fixture(scope="module")
def postgres_container():
    """Spin up postgres for integration tests."""
    # Managed by docker-compose.yml in same directory
    yield "localhost:5432"

def test_end_to_end_pipeline(postgres_container, test_dataset_path):
    # Load data from ~/test-data/myproject/integration/
    dataset = load_dataset(test_dataset_path / "samples.parquet")

    # Run pipeline
    results = process_pipeline(dataset, db_url=postgres_container)

    # Validate outputs
    assert len(results) == expected_count
    assert all(r['confidence'] > 0.5 for r in results)
```

---

#### 7.3.2 C++ Testing Policy

**Framework:** GoogleTest + GoogleMock (mandatory)

**Setup:**
```bash
# Build tests (output to ~/dev/build/<repo>/)
cd ~/dev/repos/github.com/alfonsocruzvelasco/<project>
cmake -B ~/dev/build/<project> -S . -DBUILD_TESTING=ON
cmake --build ~/dev/build/<project> --target tests

# Run tests
cd ~/dev/build/<project>
ctest --output-on-failure
```

**Directory structure:**
```text
<repo>/
├── src/
│   └── geometry/
│       ├── transforms.h
│       └── transforms.cpp
├── tests/
│   ├── CMakeLists.txt
│   ├── unit/
│   │   └── test_transforms.cpp
│   └── fixtures/
│       └── sample_pointcloud.pcd
└── CMakeLists.txt
```

**What to unit test:**
- Geometry kernels (point cloud transforms, convex hulls)
- Coordinate transforms (camera → world, pixel → ray)
- Projection/unprojection math
- SIMD-safe utilities (alignment, lane ops)
- Deterministic numeric functions with explicit tolerances
- Binary serialization formats

**CMake test configuration:**
```cmake
# tests/CMakeLists.txt
enable_testing()
find_package(GTest REQUIRED)

add_executable(geometry_tests
    unit/test_transforms.cpp
    unit/test_projection.cpp
)

target_link_libraries(geometry_tests
    PRIVATE
        GTest::gtest_main
        myproject::geometry
)

gtest_discover_tests(geometry_tests)
```

**Test example:**
```cpp
// tests/unit/test_transforms.cpp
#include <gtest/gtest.h>
#include "geometry/transforms.h"
#include <Eigen/Dense>

TEST(TransformTest, IdentityTransformPreservesPoint) {
    Eigen::Vector3d point(1.0, 2.0, 3.0);
    Eigen::Matrix4d identity = Eigen::Matrix4d::Identity();

    auto result = apply_transform(point, identity);

    EXPECT_NEAR(result.x(), 1.0, 1e-9);
    EXPECT_NEAR(result.y(), 2.0, 1e-9);
    EXPECT_NEAR(result.z(), 3.0, 1e-9);
}

TEST(TransformTest, RotationAroundZAxis) {
    Eigen::Vector3d point(1.0, 0.0, 0.0);
    Eigen::Matrix4d rot = rotation_z(M_PI / 2);  // 90 degrees

    auto result = apply_transform(point, rot);

    EXPECT_NEAR(result.x(), 0.0, 1e-9);
    EXPECT_NEAR(result.y(), 1.0, 1e-9);
    EXPECT_NEAR(result.z(), 0.0, 1e-9);
}

// Parameterized test
class ProjectionTest : public testing::TestWithParam<std::tuple<double, double>> {};

TEST_P(ProjectionTest, ProjectionRoundTrip) {
    auto [fx, fy] = GetParam();
    CameraIntrinsics K(fx, fy, 320, 240);

    Eigen::Vector3d world_point(1.0, 2.0, 5.0);
    auto pixel = project(world_point, K);
    auto unprojected = unproject(pixel, 5.0, K);

    EXPECT_NEAR((world_point - unprojected).norm(), 0.0, 1e-6);
}

INSTANTIATE_TEST_SUITE_P(
    VariousFocalLengths,
    ProjectionTest,
    testing::Values(
        std::make_tuple(500.0, 500.0),
        std::make_tuple(800.0, 800.0),
        std::make_tuple(600.0, 700.0)
    )
);
```

**Fixture management:**
```cpp
class GeometryFixture : public testing::Test {
protected:
    void SetUp() override {
        // Load tiny fixture from repo
        test_cloud_ = load_pcd("tests/fixtures/sample_pointcloud.pcd");
    }

    PointCloud test_cloud_;
};

TEST_F(GeometryFixture, DownsamplePreservesStructure) {
    auto downsampled = voxel_downsample(test_cloud_, voxel_size=0.05);
    EXPECT_LT(downsampled.size(), test_cloud_.size());
    EXPECT_GT(downsampled.size(), 0);
}
```

**Avoid testing private unless necessary:**
```cpp
// GOOD: Test via public interface
TEST(BBoxTest, IntersectionAreaComputation) {
    BBox a(0, 0, 10, 10);
    BBox b(5, 5, 10, 10);
    EXPECT_DOUBLE_EQ(compute_iou(a, b), 0.14285714);  // Public method
}

// ONLY IF NO CLEAN SEAM: Test private helper
class BBoxTestWithPrivateAccess : public testing::Test {
protected:
    // Friend declaration in BBox class required
    double get_intersection_area(const BBox& a, const BBox& b) {
        return BBox::intersection_area_internal(a, b);  // Private method
    }
};
```

**Compile time control:**
```cmake
# Keep test compile times reasonable
# Separate test targets per module
add_executable(transforms_tests unit/test_transforms.cpp)
add_executable(projection_tests unit/test_projection.cpp)

# Use unity builds cautiously (can hurt iteration)
set_target_properties(transforms_tests PROPERTIES UNITY_BUILD OFF)
```

---

#### 7.3.3 CUDA / GPU C++ Testing Policy

**Core principle:**
Kernels are hard to test directly. **Unit-test device logic via small `__device__` functions** and keep kernels thin.

**Framework:** GoogleTest on host + custom kernel assertion harness

**Two-tier testing:**
1. **CPU-reference unit tests** (mandatory, runs in CI)
2. **GPU correctness tests** (tagged, requires GPU runner)

**Setup:**
```bash
# Build with CUDA tests enabled
cmake -B ~/dev/build/<project> -S . \
    -DBUILD_TESTING=ON \
    -DCUDA_TESTS=ON \
    -DCMAKE_CUDA_ARCHITECTURES=75

cmake --build ~/dev/build/<project> --target cuda_tests

# Run GPU tests (requires CUDA-capable runner)
cd ~/dev/build/<project>
ctest -R cuda --output-on-failure
```

**Directory structure:**
```text
<repo>/
├── src/
│   └── kernels/
│       ├── reduce.cu
│       └── reduce.cuh
├── tests/
│   ├── unit/
│   │   └── test_reduce_cpu_reference.cpp   # CPU reference (always runs)
│   └── gpu/
│       ├── test_reduce_gpu.cu               # GPU correctness (tagged)
│       └── cuda_test_utils.cuh
└── CMakeLists.txt
```

**What to test:**
- Device function logic (`__device__` helpers)
- Launch bounds edge cases (grid/block size limits)
- Alignment assumptions (shared memory, global memory)
- Numerical correctness under float error
- Memory access patterns (coalescing, bank conflicts via profiling, not tests)

**CPU reference test (mandatory):**
```cpp
// tests/unit/test_reduce_cpu_reference.cpp
#include <gtest/gtest.h>
#include <vector>

// CPU reference implementation
float reduce_sum_cpu(const std::vector<float>& data) {
    float sum = 0.0f;
    for (auto val : data) sum += val;
    return sum;
}

TEST(ReduceTest, SumOfOnesReturnsCount) {
    std::vector<float> data(1024, 1.0f);
    float result = reduce_sum_cpu(data);
    EXPECT_FLOAT_EQ(result, 1024.0f);
}

TEST(ReduceTest, SumOfZerosReturnsZero) {
    std::vector<float> data(512, 0.0f);
    float result = reduce_sum_cpu(data);
    EXPECT_FLOAT_EQ(result, 0.0f);
}

TEST(ReduceTest, NumericalStability) {
    // Test large + small values
    std::vector<float> data = {1e8, 1.0, 1e8, 1.0};
    float result = reduce_sum_cpu(data);
    EXPECT_NEAR(result, 2e8 + 2.0, 1e-3);  // Tolerance for float error
}
```

**GPU correctness test (tagged):**
```cpp
// tests/gpu/test_reduce_gpu.cu
#include <gtest/gtest.h>
#include <cuda_runtime.h>
#include "kernels/reduce.cuh"

class ReduceGPUTest : public testing::Test {
protected:
    void SetUp() override {
        if (!has_cuda_device()) {
            GTEST_SKIP() << "CUDA device not available";
        }
    }

    bool has_cuda_device() {
        int device_count;
        cudaGetDeviceCount(&device_count);
        return device_count > 0;
    }
};

TEST_F(ReduceGPUTest, GPUMatchesCPUReference) {
    constexpr size_t N = 1024;
    std::vector<float> h_data(N, 1.0f);

    // CPU reference
    float cpu_result = std::accumulate(h_data.begin(), h_data.end(), 0.0f);

    // GPU implementation
    float *d_data, *d_result;
    cudaMalloc(&d_data, N * sizeof(float));
    cudaMalloc(&d_result, sizeof(float));
    cudaMemcpy(d_data, h_data.data(), N * sizeof(float), cudaMemcpyHostToDevice);

    reduce_sum_kernel<<<1, 256>>>(d_data, d_result, N);
    cudaDeviceSynchronize();

    float gpu_result;
    cudaMemcpy(&gpu_result, d_result, sizeof(float), cudaMemcpyDeviceToHost);

    EXPECT_NEAR(gpu_result, cpu_result, 1e-5);

    cudaFree(d_data);
    cudaFree(d_result);
}

TEST_F(ReduceGPUTest, LaunchBoundsEdgeCases) {
    // Test with non-power-of-2 sizes
    for (size_t N : {1, 7, 127, 1023, 1025}) {
        std::vector<float> h_data(N, 1.0f);

        float *d_data, *d_result;
        cudaMalloc(&d_data, N * sizeof(float));
        cudaMalloc(&d_result, sizeof(float));
        cudaMemcpy(d_data, h_data.data(), N * sizeof(float), cudaMemcpyHostToDevice);

        int blocks = (N + 255) / 256;
        reduce_sum_kernel<<<blocks, 256>>>(d_data, d_result, N);
        cudaDeviceSynchronize();

        float result;
        cudaMemcpy(&result, d_result, sizeof(float), cudaMemcpyDeviceToHost);

        EXPECT_NEAR(result, static_cast<float>(N), 1e-4);

        cudaFree(d_data);
        cudaFree(d_result);
    }
}
```

**Device function testing pattern:**
```cuda
// kernels/reduce.cuh
__device__ inline float warp_reduce_sum(float val) {
    for (int offset = 16; offset > 0; offset /= 2) {
        val += __shfl_down_sync(0xffffffff, val, offset);
    }
    return val;
}

// tests/gpu/test_device_functions.cu
__global__ void test_warp_reduce_kernel(float* input, float* output, int n) {
    int tid = threadIdx.x;
    float val = (tid < n) ? input[tid] : 0.0f;

    val = warp_reduce_sum(val);  // Test device function

    if (tid == 0) *output = val;
}

TEST_F(ReduceGPUTest, WarpReduceCorrectness) {
    constexpr int WARP_SIZE = 32;
    std::vector<float> h_input(WARP_SIZE, 1.0f);

    float *d_input, *d_output;
    cudaMalloc(&d_input, WARP_SIZE * sizeof(float));
    cudaMalloc(&d_output, sizeof(float));
    cudaMemcpy(d_input, h_input.data(), WARP_SIZE * sizeof(float), cudaMemcpyHostToDevice);

    test_warp_reduce_kernel<<<1, 32>>>(d_input, d_output, WARP_SIZE);
    cudaDeviceSynchronize();

    float result;
    cudaMemcpy(&result, d_output, sizeof(float), cudaMemcpyDeviceToHost);

    EXPECT_FLOAT_EQ(result, 32.0f);

    cudaFree(d_input);
    cudaFree(d_output);
}
```

**CMake configuration:**
```cmake
# tests/CMakeLists.txt
if(CUDA_TESTS AND CMAKE_CUDA_COMPILER)
    enable_language(CUDA)

    add_executable(cuda_tests
        gpu/test_reduce_gpu.cu
        gpu/test_device_functions.cu
    )

    target_link_libraries(cuda_tests
        PRIVATE
            GTest::gtest_main
            myproject::kernels
    )

    set_target_properties(cuda_tests PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON
        CUDA_ARCHITECTURES 75  # Tune for your hardware
    )

    # Tag GPU tests for CI filtering
    gtest_discover_tests(cuda_tests
        PROPERTIES LABELS "gpu;requires_cuda"
    )
endif()
```

**CI configuration (GitHub Actions):**
```yaml
test-cuda:
  runs-on: self-hosted-gpu  # Runner with CUDA
  if: github.event_name == 'push'  # Only on merge, not PR
  steps:
    - name: Build CUDA tests
      run: |
        cmake -B build -S . -DCUDA_TESTS=ON
        cmake --build build --target cuda_tests

    - name: Run GPU tests
      run: |
        cd build
        ctest -L "gpu" --output-on-failure
```

**Handling non-deterministic GPU reductions:**
```cpp
// Use epsilon-based assertions for parallel reductions
TEST_F(ReduceGPUTest, ParallelSumWithTolerance) {
    // GPU parallel sum may have different associativity than CPU
    float gpu_result = reduce_sum_gpu(data);
    float cpu_result = reduce_sum_cpu(data);

    // Relative tolerance accounts for float error accumulation
    float max_val = *std::max_element(data.begin(), data.end());
    float tolerance = max_val * data.size() * 1e-6;

    EXPECT_NEAR(gpu_result, cpu_result, tolerance);
}
```

---

#### 7.3.4 Rust Testing Policy

**Framework:** Built-in `#[test]` + `proptest` for property-based testing

**Setup:**
```bash
cd ~/dev/repos/github.com/alfonsocruzvelasco/<project>
cargo test --all-features
cargo test --lib  # Unit tests only
cargo test --test integration_tests  # Integration tests only
```

**Directory structure:**
```text
<repo>/
├── src/
│   ├── lib.rs
│   └── parser.rs
├── tests/
│   └── integration_test.rs   # Integration tests (separate binary)
└── Cargo.toml
```

**What to unit test:**
- Parsers, serializers, deserializers
- Coordinate transforms, geometry utilities
- Safety-critical utilities (memory-safe wrappers, validation)
- Property invariants: round-trip encoding, transform properties

**Unit test example:**
```rust
// src/parser.rs
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_valid_bbox() {
        let input = "10,20,30,40";
        let bbox = parse_bbox(input).unwrap();

        assert_eq!(bbox.x, 10);
        assert_eq!(bbox.y, 20);
        assert_eq!(bbox.width, 30);
        assert_eq!(bbox.height, 40);
    }

    #[test]
    fn parse_invalid_bbox_returns_error() {
        let input = "invalid";
        let result = parse_bbox(input);

        assert!(result.is_err());
    }

    #[test]
    #[should_panic(expected = "width must be positive")]
    fn zero_width_bbox_panics() {
        BBox::new(0, 0, 0, 10);
    }
}
```

**Property-based testing with `proptest`:**
```rust
// Cargo.toml
[dev-dependencies]
proptest = "1.0"

// src/encoder.rs
#[cfg(test)]
mod tests {
    use super::*;
    use proptest::prelude::*;

    proptest! {
        #[test]
        fn encode_decode_roundtrip(x: f64, y: f64, z: f64) {
            let point = Point3D { x, y, z };
            let encoded = encode_point(&point);
            let decoded = decode_point(&encoded).unwrap();

            // Use approximate equality for floats
            prop_assert!((point.x - decoded.x).abs() < 1e-9);
            prop_assert!((point.y - decoded.y).abs() < 1e-9);
            prop_assert!((point.z - decoded.z).abs() < 1e-9);
        }

        #[test]
        fn bbox_intersection_commutative(
            a_x in 0..1000, a_y in 0..1000, a_w in 1..500, a_h in 1..500,
            b_x in 0..1000, b_y in 0..1000, b_w in 1..500, b_h in 1..500
        ) {
            let a = BBox::new(a_x, a_y, a_w, a_h);
            let b = BBox::new(b_x, b_y, b_w, b_h);

            let area_ab = intersection_area(&a, &b);
            let area_ba = intersection_area(&b, &a);

            prop_assert_eq!(area_ab, area_ba);
        }
    }
}
```

**Persisting failing seeds:**
```rust
// When proptest finds a failure, it saves to proptest-regressions/
// Commit this file to ensure failures are reproducible

// .gitignore
# Keep proptest regression files
!proptest-regressions/
```

**Integration tests:**
```rust
// tests/integration_test.rs
use myproject::pipeline::{load_data, process, save_results};
use std::path::Path;

#[test]
fn end_to_end_pipeline() {
    let test_data = Path::new(env!("HOME"))
        .join("test-data/myproject/integration/sample.json");

    let data = load_data(&test_data).expect("Failed to load test data");
    let results = process(data);

    assert_eq!(results.len(), 10);
    assert!(results.iter().all(|r| r.confidence > 0.5));
}
```

---

#### 7.3.5 Go Testing Policy

**Framework:** Standard `testing` package with table-driven tests

**Setup:**
```bash
cd ~/dev/repos/github.com/alfonsocruzvelasco/<project>
go test ./...               # All packages
go test -v ./pkg/parser     # Specific package
go test -cover ./...        # With coverage
```

**Directory structure:**
```text
<repo>/
├── cmd/
│   └── server/
│       └── main.go
├── pkg/
│   └── parser/
│       ├── parser.go
│       └── parser_test.go  # Tests alongside code
└── go.mod
```

**What to unit test:**
- Validators, parsers, request shaping
- Deterministic helpers (no external dependencies)
- Business logic transformations
- Error handling paths

**Table-driven test pattern:**
```go
// pkg/parser/parser_test.go
package parser

import "testing"

func TestParseBBox(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    BBox
        wantErr bool
    }{
        {
            name:    "valid bbox",
            input:   "10,20,30,40",
            want:    BBox{X: 10, Y: 20, Width: 30, Height: 40},
            wantErr: false,
        },
        {
            name:    "invalid format",
            input:   "invalid",
            want:    BBox{},
            wantErr: true,
        },
        {
            name:    "negative width",
            input:   "10,20,-5,40",
            want:    BBox{},
            wantErr: true,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := ParseBBox(tt.input)

            if (err != nil) != tt.wantErr {
                t.Errorf("ParseBBox() error = %v, wantErr %v", err, tt.wantErr)
                return
            }

            if !tt.wantErr && got != tt.want {
                t.Errorf("ParseBBox() = %v, want %v", got, tt.want)
            }
        })
    }
}
```

**Subtests for descriptive output:**
```go
func TestImageResize(t *testing.T) {
    t.Run("maintains aspect ratio", func(t *testing.T) {
        // ...
    })

    t.Run("handles zero dimensions", func(t *testing.T) {
        // ...
    })

    t.Run("clips to max size", func(t *testing.T) {
        // ...
    })
}
```

**Test helpers:**
```go
func TestMain(m *testing.M) {
    // Setup before all tests
    setup()

    code := m.Run()

    // Teardown after all tests
    teardown()

    os.Exit(code)
}

func setup() {
    // Initialize test database, fixtures, etc.
}

func teardown() {
    // Cleanup
}
```

---

#### 7.3.6 TypeScript / JavaScript Testing Policy

**Framework:** Jest (mandatory for TypeScript projects)

**Setup:**
```bash
cd ~/dev/repos/github.com/alfonsocruzvelasco/<project>
npm install --save-dev jest @types/jest ts-jest
npx jest --coverage
```

**Directory structure:**
```text
<repo>/
├── src/
│   ├── utils/
│   │   ├── bbox.ts
│   │   └── __tests__/
│   │       └── bbox.test.ts
│   └── components/
│       ├── ImageViewer.tsx
│       └── __tests__/
│           └── ImageViewer.test.tsx
├── jest.config.js
└── package.json
```

**What to unit test:**
- Pure functions (data transforms, validators)
- Schema validation, bounding-box conversions
- Query builders, API clients (mocked)
- React component logic (not UI rendering)

**Jest configuration:**
```javascript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',  // or 'jsdom' for React
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/__tests__/**'
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  }
};
```

**Unit test example:**
```typescript
// src/utils/__tests__/bbox.test.ts
import { BBox, clipBBox, computeIoU } from '../bbox';

describe('BBox utilities', () => {
  describe('clipBBox', () => {
    it('clips bbox exceeding image boundary', () => {
      const bbox: BBox = { x: 620, y: 470, width: 50, height: 50 };
      const imageSize = { width: 640, height: 480 };

      const clipped = clipBBox(bbox, imageSize);

      expect(clipped).toEqual({ x: 620, y: 470, width: 20, height: 10 });
    });

    it('returns original bbox when fully inside image', () => {
      const bbox: BBox = { x: 10, y: 10, width: 50, height: 50 };
      const imageSize = { width: 640, height: 480 };

      const clipped = clipBBox(bbox, imageSize);

      expect(clipped).toEqual(bbox);
    });
  });

  describe('computeIoU', () => {
    it('returns 1 for identical boxes', () => {
      const bbox: BBox = { x: 0, y: 0, width: 10, height: 10 };

      const iou = computeIoU(bbox, bbox);

      expect(iou).toBeCloseTo(1.0, 5);
    });

    it('returns 0 for non-overlapping boxes', () => {
      const a: BBox = { x: 0, y: 0, width: 10, height: 10 };
      const b: BBox = { x: 20, y: 20, width: 10, height: 10 };

      const iou = computeIoU(a, b);

      expect(iou).toBe(0);
    });
  });
});
```

**Mocking filesystem/network:**
```typescript
import { loadManifest } from '../loader';
import fs from 'fs';

jest.mock('fs');

describe('loadManifest', () => {
  it('loads manifest from file', () => {
    const mockData = JSON.stringify({ images: [{ id: 1 }] });
    (fs.readFileSync as jest.Mock).mockReturnValue(mockData);

    const manifest = loadManifest('/path/to/manifest.json');

    expect(manifest.images).toHaveLength(1);
    expect(fs.readFileSync).toHaveBeenCalledWith('/path/to/manifest.json', 'utf-8');
  });
});
```

**React component testing (with React Testing Library):**
```typescript
// src/components/__tests__/ImageViewer.test.tsx
import { render, screen } from '@testing-library/react';
import { ImageViewer } from '../ImageViewer';

describe('ImageViewer', () => {
  it('renders image with bounding boxes', () => {
    const bboxes = [
      { x: 10, y: 10, width: 50, height: 50, label: 'cat' }
    ];

    render(<ImageViewer src="/test.jpg" bboxes={bboxes} />);

    expect(screen.getByRole('img')).toHaveAttribute('src', '/test.jpg');
    expect(screen.getByText('cat')).toBeInTheDocument();
  });
});
```

---

#### 7.3.7 Java Testing Policy

**Framework:** JUnit 5

**Setup:**
```bash
cd ~/dev/repos/github.com/alfonsocruzvelasco/<project>
mvn test                    # Maven
./gradlew test             # Gradle
```

**Directory structure:**
```text
<repo>/
├── src/
│   ├── main/java/com/example/
│   │   └── BBoxUtils.java
│   └── test/java/com/example/
│       └── BBoxUtilsTest.java
└── pom.xml
```

**What to unit test:**
- Boundary conditions with parameterized tests
- Business logic transformations
- Validators, parsers, serializers
- Data pipeline components

**Parameterized test example:**
```java
// src/test/java/com/example/BBoxUtilsTest.java
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;

class BBoxUtilsTest {

    @ParameterizedTest
    @CsvSource({
        "10, 10, 50, 50, 640, 480, 10, 10, 50, 50",  // Inside boundary
        "620, 470, 50, 50, 640, 480, 620, 470, 20, 10",  // Exceeds boundary
        "-5, -5, 10, 10, 640, 480, 0, 0, 5, 5"  // Negative origin
    })
    void testClipBBox(int x, int y, int w, int h, int imgW, int imgH,
                      int expX, int expY, int expW, int expH) {
        BBox bbox = new BBox(x, y, w, h);
        Dimension imageSize = new Dimension(imgW, imgH);

        BBox clipped = BBoxUtils.clip(bbox, imageSize);

        assertEquals(expX, clipped.x);
        assertEquals(expY, clipped.y);
        assertEquals(expW, clipped.width);
        assertEquals(expH, clipped.height);
    }

    @Test
    void testIoUIdenticalBoxes() {
        BBox bbox = new BBox(0, 0, 10, 10);

        double iou = BBoxUtils.computeIoU(bbox, bbox);

        assertEquals(1.0, iou, 1e-9);
    }
}
```

---

### 7.4 Test Execution Environments

#### 7.4.1 Local Development

**Unit tests:**
- Execute bare-metal from virtual environments (`~/dev/venvs/`) or build directories (`~/dev/build/`)
- No containers required (fast iteration)

**Integration tests:**
- Execute in Docker Compose with mounted volumes
- Spin up dependencies (Postgres, Kafka, mock services)

**System tests:**
- Execute in local Kubernetes (k3s, kind, minikube)
- Or Docker Compose for simpler multi-service workflows

---

#### 7.4.2 CI/CD Pipeline

**GitHub Actions example:**
```yaml
# .github/workflows/test.yml
name: Test Suite

on: [push, pull_request]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install -r requirements-dev.txt --break-system-packages

      - name: Run unit tests
        run: |
          pytest tests/unit/ -v --cov=src --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v3

  integration-tests:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: testpass
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v3

      - name: Run integration tests
        run: |
          pytest tests/integration/ -v
        env:
          DATABASE_URL: postgresql://postgres:testpass@postgres:5432/testdb

  gpu-tests:
    runs-on: self-hosted-gpu
    if: github.event_name == 'push'  # Only on merge
    steps:
      - uses: actions/checkout@v3

      - name: Build CUDA tests
        run: |
          cmake -B build -S . -DCUDA_TESTS=ON
          cmake --build build --target cuda_tests

      - name: Run GPU tests
        run: |
          cd build
          ctest -L "gpu" --output-on-failure
```

---

### 7.5 Coverage Requirements

**See also:** [AI Mutation Testing & Debugging Reference](references/ai-mutation-testing-debugging-reference.md) for mutation testing fundamentals — mutation score reveals whether tests actually catch defects, not just execute code.

#### 7.5.1 Unit Test Coverage

**Minimum thresholds:**
- **Line coverage:** 80%
- **Branch coverage:** 75%
- **Function coverage:** 90%

**Exceptions:**
- UI rendering code (test behavior, not pixels)
- Auto-generated code (protobuf, OpenAPI)
- Deprecated code paths (mark explicitly)

**Enforcement:**
```bash
# Python
pytest --cov=src --cov-fail-under=80

# C++ (with gcov/lcov)
cmake -DCMAKE_BUILD_TYPE=Coverage
make coverage
lcov --summary coverage.info  # Fail if < 80%

# Rust
cargo tarpaulin --fail-under 80
```

---

#### 7.5.2 Integration Test Coverage

**Requirements:**
- All critical paths must have integration tests
- Happy path + at least one error path per API endpoint
- Database migrations must have rollback tests

**Not measured by line coverage:**
- Focus on scenario coverage (business workflows)
- Use test matrices for combinations

---

#### 7.5.3 System Test Coverage

**Requirements:**
- End-to-end workflows for production-critical paths
- Disaster recovery procedures
- Performance regression tests

**Execution:**
- Nightly or on-demand (too slow for PR gating)
- Track success rate over time (trending)

---

### 7.6 Test Data Management

#### 7.6.1 Tiny Fixtures (Committed to Git)

**Location:** `<repo>/tests/fixtures/`

**Rules:**
- Total size < 1MB
- Simple, deterministic, human-readable where possible
- Examples: 32x32 images, small JSON/YAML, tiny numpy arrays

**Example:**
```text
<repo>/tests/fixtures/
├── images/
│   ├── cat-32x32.png           (5 KB)
│   └── checkerboard-64x64.png  (8 KB)
├── manifests/
│   ├── valid-manifest.json     (2 KB)
│   └── invalid-manifest.json   (1 KB)
└── pointclouds/
    └── cube-vertices.pcd       (3 KB)
```

---

#### 7.6.2 Small Test Data (Not Committed)

**Location:** `~/test-data/<project>/`

**Rules:**
- 1MB - 100MB range
- Downloaded or generated locally
- Added to `.gitignore`
- Documented in `tests/README.md`

**Example:**
```bash
# tests/README.md
## Test Data Setup

Download test datasets:

    mkdir -p ~/test-data/myproject/integration
    wget https://example.com/test-dataset.tar.gz
    tar -xzf test-dataset.tar.gz -C ~/test-data/myproject/integration/
```

---

#### 7.6.3 Large Test Data (Immutable Snapshots)

**Location:** `~/datasets/<snapshot-name>/`

**Rules:**
- Follows immutability policy (see `production-policy.md §1.5`)
- Versioned snapshots (YYYY-MM-DD)
- Shared across projects
- Never modified after creation

**Example:**
```bash
~/datasets/
├── coco-validation-2026-01-15/
│   ├── images/
│   └── annotations.json
└── kitti-test-2026-01-20/
    ├── velodyne/
    └── calib/
```

---

### 7.7 Test Maintenance

#### 7.7.1 Flaky Test Policy

**Definition:** A test that passes/fails non-deterministically.

**Response:**
1. **Immediately quarantine:** Mark with `@pytest.mark.flaky` or equivalent
2. **Root cause within 3 days:** Investigate and fix
3. **Remove if unfixable:** Delete the test if it cannot be made deterministic

**Never:**
- Re-run flaky tests until they pass
- Ignore flaky tests in CI

---

#### 7.7.2 Test Debt Tracking

**When tests become unmaintainable:**
1. File issue with label `test-debt`
2. Document why test is problematic
3. Set deadline for resolution (default: 1 sprint)
4. If not resolved, delete test (don't let broken tests accumulate)

---

#### 7.7.3 Deprecated Code Testing

**Rule:** Do not write new tests for deprecated code.

**Existing tests:**
- Mark with `@pytest.mark.deprecated` or equivalent
- Run in separate CI job (optional)
- Delete when deprecated code is removed

---

### 7.8 Test-Driven Development (TDD) Guidance

#### When to Use TDD

**Recommended for:**
- Complex algorithms with clear specifications
- Parsers, validators, serializers
- Math-heavy geometry/transform code
- Refactoring existing code

**Not required for:**
- Exploratory prototyping (Vibe stage)
- UI layout/styling
- Trivial getters/setters

---

#### TDD Workflow

1. **Write failing test** (Red)
2. **Implement minimal code to pass** (Green)
3. **Refactor** (keeping tests green)
4. **Commit** (test + implementation together)

**Example:**
```python
# Step 1: Write failing test
def test_clip_bbox_at_boundary():
    bbox = BBox(x=620, y=470, w=50, h=50)
    clipped = clip_bbox(bbox, image_size=(640, 480))
    assert clipped.w == 20
    assert clipped.h == 10

# Step 2: Implement
def clip_bbox(bbox, image_size):
    max_x = min(bbox.x + bbox.w, image_size[0])
    max_y = min(bbox.y + bbox.h, image_size[1])
    return BBox(
        x=bbox.x,
        y=bbox.y,
        w=max_x - bbox.x,
        h=max_y - bbox.y
    )

# Step 3: Refactor (if needed)
# ...

# Step 4: Commit both together
git add tests/test_bbox.py src/bbox.py
git commit -m "feat(bbox): add boundary clipping"
```

---

### 7.9 Performance Testing

#### 7.9.1 Benchmark Tests

**Location:** `<repo>/tests/benchmarks/`

**Framework:**
- Python: `pytest-benchmark`
- C++: Google Benchmark
- Rust: `cargo bench` (built-in)

**Example (Python):**
```python
def test_resize_performance(benchmark):
    image = np.random.rand(1080, 1920, 3)
    result = benchmark(resize_with_aspect_ratio, image, target_width=640)

    # Assert performance threshold
    assert benchmark.stats['mean'] < 0.05  # < 50ms
```

**CI integration:**
- Store baseline results in repo (`benchmarks/baseline.json`)
- Fail if new code is >10% slower than baseline

---

#### 7.9.2 Load Testing

**For services:**
- Use dedicated tools (Locust, k6, JMeter)
- Not part of unit/integration test suites
- Run in staging environment, not CI

---

### 7.10 Contract Testing (Spec Validation)

#### 7.10.1 Spec Kit Contracts

**Location:** `<repo>/tests/test_spec_contracts.py`

**Pattern:**
```python
import yaml
from pathlib import Path

def test_api_matches_spec():
    """Validate implemented API matches .specify/specs/001-api/spec.md"""
    spec_path = Path(__file__).parent.parent / '.specify/specs/001-api/spec.md'
    spec = parse_spec_markdown(spec_path)

    # Extract routes from implementation
    actual_routes = get_all_routes(app)
    spec_routes = [ep['path'] for ep in spec['endpoints']]

    # Assert implemented routes match spec
    assert set(actual_routes) == set(spec_routes), \
        f"Routes mismatch: {set(actual_routes) ^ set(spec_routes)}"

    # Validate method signatures
    for endpoint in spec['endpoints']:
        path = endpoint['path']
        expected_methods = endpoint['methods']
        actual_methods = get_methods(app, path)

        assert set(actual_methods) == set(expected_methods), \
            f"Methods mismatch for {path}: {actual_methods} vs {expected_methods}"
```

---

#### 7.10.2 OpenSpec Contracts

**Location:** `<repo>/tests/test_openspec_contracts.py`

**Pattern:**
```python
def test_openspec_reflects_implementation():
    """Validate openspec/specs/ matches current implementation"""
    spec = yaml.safe_load(Path('openspec/specs/api-v1.yaml').read_text())

    # Extract schemas
    for schema_name, schema_def in spec['components']['schemas'].items():
        model_class = get_model_class(schema_name)

        # Validate fields match
        spec_fields = set(schema_def['properties'].keys())
        model_fields = set(model_class.__annotations__.keys())

        assert spec_fields == model_fields, \
            f"Schema {schema_name} mismatch: {spec_fields ^ model_fields}"
```

---

### 7.11 Monitoring and Alerting

#### 7.11.1 Test Suite Metrics

**Track:**
- Test execution time (total and per-suite)
- Flaky test rate (failures / total runs)
- Coverage trends (over time)
- Test count growth (lines of test code / lines of prod code)

**Alert on:**
- Test suite time > 10 minutes (unit tests)
- Flaky test rate > 5%
- Coverage drop > 2% in single PR

---

#### 7.11.2 Production Monitoring

**Synthetic tests in production:**
- Health check endpoints (`/health`, `/ready`)
- Smoke tests after deployment
- Canary analysis (compare new version vs baseline)

**See also:** `mlops-policy.md §Monitoring and Observability`

---

### 7.12 Quick Reference: Test Command Cheatsheet

#### Python (pytest)
```bash
# Run all tests
pytest

# Unit tests only
pytest tests/unit/ -v

# Integration tests with coverage
pytest tests/integration/ --cov=src --cov-report=html

# Run specific test
pytest tests/unit/test_bbox.py::test_clip_at_boundary

# Run tests matching pattern
pytest -k "test_bbox"

# Run with parallel execution
pytest -n auto

# Run GPU-tagged tests only
pytest -m gpu
```

---

#### C++ (GoogleTest + CMake)
```bash
# Build tests
cmake -B ~/dev/build/<project> -S . -DBUILD_TESTING=ON
cmake --build ~/dev/build/<project> --target tests

# Run all tests
cd ~/dev/build/<project>
ctest --output-on-failure

# Run specific test suite
ctest -R TransformTest

# Run with verbose output
ctest -V

# Run GPU tests only
ctest -L gpu
```

---

#### CUDA (GPU tests)
```bash
# Build with CUDA tests
cmake -B build -S . -DCUDA_TESTS=ON -DCMAKE_CUDA_ARCHITECTURES=75
cmake --build build --target cuda_tests

# Run GPU tests
cd build
ctest -L gpu --output-on-failure
```

---

#### Rust
```bash
# Run all tests
cargo test

# Unit tests only
cargo test --lib

# Integration tests only
cargo test --test integration_test

# With coverage
cargo tarpaulin --out Html

# Run specific test
cargo test test_bbox_clipping
```

---

#### Go
```bash
# Run all tests
go test ./...

# Specific package
go test -v ./pkg/parser

# With coverage
go test -cover ./...

# Parallel execution
go test -parallel 4 ./...
```

---

#### TypeScript (Jest)
```bash
# Run all tests
npm test

# Watch mode
npm test -- --watch

# Coverage
npm test -- --coverage

# Specific test file
npm test -- bbox.test.ts

# Update snapshots
npm test -- -u
```

---

#### Java (JUnit 5)
```bash
# Maven
mvn test

# Gradle
./gradlew test

# Specific test class
mvn test -Dtest=BBoxUtilsTest

# With coverage (JaCoCo)
mvn test jacoco:report
```

---

### 7.13 Anti-Patterns to Avoid

#### 7.13.1 Testing Anti-Patterns

**Never:**
1. **Test implementation details** (test behavior, not internals)
2. **Test private methods directly** (refactor to testable units)
3. **Use sleep() for timing** (use mocks/stubs for async)
4. **Share state between tests** (each test must be independent)
5. **Write tests that depend on execution order** (tests must be parallelizable)
6. **Mock everything** (use real dependencies for unit tests when simple)
7. **Ignore flaky tests** (fix or delete immediately)
8. **Write tests after the fact** (test-first or test-concurrent, never test-never)

---

#### 7.13.2 Test Data Anti-Patterns

**Never:**
1. **Commit large files to Git** (use `~/test-data/` or `~/datasets/`)
2. **Use production data in tests** (privacy/security violation)
3. **Generate random test data without seeds** (non-deterministic)
4. **Hardcode file paths** (use fixtures or environment variables)
5. **Modify fixtures during tests** (copy fixture if mutation needed)

---

### 7.14 Exceptions Process

#### When to Deviate from This Policy

**Allowed deviations:**
1. **Legacy code:** Gradual migration plan documented
2. **Experimental prototypes:** Clearly marked as non-production
3. **Third-party constraints:** External library limitations
4. **Performance-critical paths:** Document why tests are skipped

**Process:**
1. File issue with `test-exception` label
2. Document rationale and timeline
3. Get approval from code owner
4. Add to `TESTING.md` exceptions section
5. Review quarterly

---

### 7.15 Enforcement

#### Code Review Checklist

**Mandatory checks:**
- [ ] Tests included for new code (or exception documented)
- [ ] All tests pass locally
- [ ] Coverage thresholds met
- [ ] No flaky tests introduced
- [ ] Test data properly isolated (not committed if > 1MB)
- [ ] Spec contracts validated (if using Spec Kit / OpenSpec)

---

#### CI/CD Enforcement

**Pull request requirements:**
- Unit tests must pass (blocking)
- Integration tests must pass (blocking)
- Coverage must not decrease by > 2% (blocking)
- GPU tests must pass (non-blocking, informational)

---

#### Continuous Improvement

**Quarterly review:**
- Test suite execution time trends
- Flaky test rate
- Coverage trends
- Test debt backlog

**Action items:**
- Optimize slow tests
- Fix or delete flaky tests
- Increase coverage in low-coverage modules
- Refactor unmaintainable tests

---
