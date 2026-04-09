# ML/CV Code Documentation Standards - Comprehensive Notes

**Date Created:** 2026-02-01
**Focus:** Modern documentation practices for Machine Learning and Computer Vision engineering

---

## EXECUTIVE SUMMARY

**The Dominant Standard:** Python docstrings (PEP 257) with type hints (PEP 484)
**Critical Exception:** Doxygen for C++/CUDA performance layers

**Why Python Dominates ML/CV:**
- PyTorch, TensorFlow, JAX = Python-first
- NumPy, SciPy, OpenCV = Python bindings
- Hugging Face, Scikit-learn = Pure Python
- Jupyter notebooks = Python ecosystem
- Research → Production pipeline = Python end-to-end

**The Layered Reality:**
- **80% of ML/CV work** → Python docstrings (Google/NumPy style)
- **15% of ML/CV work** → Mixed Python/C++ (docstrings + Doxygen)
- **5% of ML/CV work** → Pure C++/CUDA (Doxygen)

**Key Finding:**
- **Google-style docstrings + type hints** = Industry standard for production Python ML/CV code
- **NumPy-style docstrings** = Preferred for scientific/research contexts with heavy math
- **Doxygen** = Required for C++/CUDA kernels, custom ops, inference engines

**Professional Rule:** Use the documentation system native to the language of the layer you're working in.

---

## 1. PYTHON DOCSTRING FUNDAMENTALS

### 1.1 PEP 257 - Docstring Conventions

**Official Specification:** https://peps.python.org/pep-0257/

**Core Principles:**
```python
def function(arg):
    """Single-line summary.

    Detailed description if needed. Can span
    multiple paragraphs.

    Additional sections follow.
    """
    pass
```

**Key Rules:**
1. **Triple quotes:** Always use `"""triple double quotes"""`
2. **First line:** Should be a brief, complete sentence
3. **Blank line:** Separates summary from detailed description
4. **Indentation:** Match the opening quotes
5. **Capitalization:** Start with capital, end with period

### 1.2 Type Hints (PEP 484)

**Modern ML/CV Code Standard:**
```python
from typing import Optional, Union, Tuple, List
import numpy as np
import torch

def preprocess_image(
    image: np.ndarray,
    target_size: Tuple[int, int] = (224, 224),
    normalize: bool = True
) -> torch.Tensor:
    """Preprocess image for model input.

    Args:
        image: Input image array (H, W, C).
        target_size: Target dimensions (height, width).
        normalize: Whether to normalize to [0, 1].

    Returns:
        Preprocessed image tensor.
    """
    pass
```

**Benefits in ML/CV:**
- IDE autocomplete for tensor shapes
- Static type checking (mypy, pyright)
- Self-documenting APIs
- Better refactoring support

---

## 2. GOOGLE-STYLE DOCSTRINGS (INDUSTRY STANDARD)

### 2.1 Complete Template

```python
def train_model(
    dataset: Dataset,
    model: nn.Module,
    optimizer: torch.optim.Optimizer,
    epochs: int = 10,
    batch_size: int = 32,
    device: str = "cuda",
    checkpoint_dir: Optional[str] = None,
) -> Tuple[nn.Module, Dict[str, List[float]]]:
    """Train a deep learning model on the provided dataset.

    This function implements a standard training loop with automatic
    checkpointing, learning rate scheduling, and metric tracking.
    Supports both single-GPU and distributed training.

    Args:
        dataset: Training dataset implementing torch.utils.data.Dataset.
        model: PyTorch model to train. Should be on CPU initially.
        optimizer: Optimizer instance (e.g., Adam, SGD).
        epochs: Number of complete passes through the dataset.
        batch_size: Number of samples per batch.
        device: Device to use for training ('cuda' or 'cpu').
        checkpoint_dir: Directory to save model checkpoints. If None,
            checkpoints are not saved.

    Returns:
        A tuple containing:
            - Trained model (on CPU)
            - Dictionary of training metrics with keys 'loss', 'accuracy'

    Raises:
        ValueError: If dataset is empty or batch_size <= 0.
        RuntimeError: If CUDA is specified but not available.

    Example:
        >>> dataset = ImageDataset(root='./data')
        >>> model = ResNet50(num_classes=10)
        >>> optimizer = torch.optim.Adam(model.parameters())
        >>> trained_model, metrics = train_model(
        ...     dataset, model, optimizer, epochs=5
        ... )
        >>> print(metrics['accuracy'][-1])  # Final accuracy
        0.94

    Note:
        The model is automatically moved to the specified device during
        training and returned on CPU to save GPU memory.

    See Also:
        evaluate_model: Evaluate trained model on validation set.
        load_checkpoint: Resume training from saved checkpoint.
    """
    pass
```

### 2.2 Section Breakdown

**Required Sections:**
- **Summary:** First line, imperative mood ("Train a model" not "Trains a model")
- **Args:** All parameters, in order, with types and descriptions
- **Returns:** What the function returns, including structure

**Optional Sections:**
- **Raises:** Exceptions that can be raised
- **Example:** Usage examples (executable if possible)
- **Note:** Important caveats or warnings
- **See Also:** Related functions
- **Attributes:** For classes, document instance variables
- **Yields:** For generators

### 2.3 Google Style in ML/CV Context

**Model Definition:**
```python
class YOLOv5(nn.Module):
    """YOLOv5 object detection model.

    This implementation follows the YOLOv5 architecture with CSPDarknet53
    backbone and PANet neck. Supports multiple scales (nano, small, medium,
    large, xlarge) and arbitrary input resolutions.

    Attributes:
        backbone: Feature extraction network (CSPDarknet53).
        neck: Feature pyramid network (PANet).
        head: Detection head with three output scales.
        num_classes: Number of object categories to detect.
        anchors: Predefined anchor boxes (3 per scale, 9 total).

    Example:
        >>> model = YOLOv5(num_classes=80, size='medium')
        >>> x = torch.randn(1, 3, 640, 640)
        >>> predictions = model(x)
        >>> predictions.shape
        torch.Size([1, 25200, 85])  # [batch, anchors, 5+classes]
    """

    def __init__(
        self,
        num_classes: int = 80,
        size: str = 'medium',
        pretrained: bool = False
    ):
        """Initialize YOLOv5 model.

        Args:
            num_classes: Number of object classes to detect.
            size: Model size variant ('nano', 'small', 'medium', 'large', 'xlarge').
            pretrained: Whether to load pretrained COCO weights.

        Raises:
            ValueError: If size is not a valid variant.
        """
        super().__init__()
        # Implementation
```

**Data Processing:**
```python
def augment_batch(
    images: torch.Tensor,
    labels: torch.Tensor,
    augmentations: List[str] = ['flip', 'rotate', 'color_jitter']
) -> Tuple[torch.Tensor, torch.Tensor]:
    """Apply data augmentation to a batch of images.

    Args:
        images: Batch of images (B, C, H, W).
        labels: Batch of labels (B, num_boxes, 5) in [x, y, w, h, class] format.
        augmentations: List of augmentation names to apply.

    Returns:
        Tuple of augmented images and updated labels.

    Note:
        Spatial augmentations (flip, rotate) automatically update
        bounding box coordinates in labels.
    """
    pass
```

---

## 3. NUMPY-STYLE DOCSTRINGS (SCIENTIFIC STANDARD)

### 3.1 Complete Template

```python
def detect_edges(
    image: np.ndarray,
    method: str = 'canny',
    threshold1: float = 100.0,
    threshold2: float = 200.0
) -> np.ndarray:
    """
    Detect edges in a grayscale image using various methods.

    This function implements multiple edge detection algorithms including
    Canny, Sobel, and Laplacian. The Canny detector uses dual thresholding
    and edge tracking by hysteresis for superior results.

    Parameters
    ----------
    image : np.ndarray
        Input grayscale image of shape (H, W) with dtype uint8 or float32.
    method : {'canny', 'sobel', 'laplacian'}, optional
        Edge detection algorithm to use (default is 'canny').
    threshold1 : float, optional
        Lower threshold for Canny edge detection (default is 100.0).
    threshold2 : float, optional
        Upper threshold for Canny edge detection (default is 200.0).

    Returns
    -------
    edges : np.ndarray
        Binary edge map of shape (H, W) with dtype uint8.
        Edge pixels are 255, non-edge pixels are 0.

    Raises
    ------
    ValueError
        If image is not 2D grayscale or method is unknown.
    TypeError
        If image dtype is not uint8 or float32.

    See Also
    --------
    cv2.Canny : OpenCV Canny edge detector implementation.
    sobel_filter : Apply Sobel operator for gradient computation.

    Notes
    -----
    The Canny edge detector follows these steps:

    1. Gaussian smoothing to reduce noise
    2. Gradient magnitude and direction computation
    3. Non-maximum suppression
    4. Double thresholding
    5. Edge tracking by hysteresis

    For the Sobel method, only horizontal and vertical gradients are
    combined; diagonal edges may be less pronounced.

    References
    ----------
    .. [1] Canny, J. (1986). "A Computational Approach to Edge Detection".
           IEEE Transactions on Pattern Analysis and Machine Intelligence.

    Examples
    --------
    >>> import cv2
    >>> image = cv2.imread('image.jpg', cv2.IMREAD_GRAYSCALE)
    >>> edges = detect_edges(image, method='canny')
    >>> edges.shape == image.shape
    True
    >>> np.unique(edges)
    array([  0, 255], dtype=uint8)

    Using custom thresholds:

    >>> edges = detect_edges(image, threshold1=50, threshold2=150)
    >>> cv2.imwrite('edges.jpg', edges)
    """
    pass
```

### 3.2 Section Breakdown

**Required Sections:**
- **Summary:** First paragraph, descriptive
- **Parameters:** All args with type, shape, units
- **Returns:** Return value with type and shape

**Optional Sections:**
- **Raises:** Exception types and conditions
- **See Also:** Related functions with brief descriptions
- **Notes:** Algorithm details, mathematical formulas
- **References:** Citations for papers/algorithms
- **Examples:** Code examples with expected output

### 3.3 NumPy Style for Computer Vision

**Image Processing:**
```python
def compute_optical_flow(
    frame1: np.ndarray,
    frame2: np.ndarray,
    method: str = 'lucas_kanade',
    max_corners: int = 1000
) -> np.ndarray:
    """
    Compute dense or sparse optical flow between consecutive frames.

    Parameters
    ----------
    frame1 : np.ndarray
        First frame (H, W, 3) in RGB format, dtype uint8.
    frame2 : np.ndarray
        Second frame with same shape as frame1.
    method : {'lucas_kanade', 'farneback', 'rlof'}, optional
        Optical flow algorithm (default is 'lucas_kanade').
    max_corners : int, optional
        Maximum number of corners to track for sparse methods.

    Returns
    -------
    flow : np.ndarray
        For dense methods: flow field of shape (H, W, 2) where
        flow[:,:,0] is x-displacement and flow[:,:,1] is y-displacement.
        For sparse methods: (N, 4) array with [x1, y1, dx, dy] per point.

    Notes
    -----
    Lucas-Kanade assumes flow is constant in local neighborhood and
    solves the optical flow constraint equation:

    .. math:: I_x u + I_y v + I_t = 0

    where :math:`I_x`, :math:`I_y` are spatial gradients and
    :math:`I_t` is temporal gradient.
    """
    pass
```

**Feature Extraction:**
```python
class SIFTDetector:
    """
    Scale-Invariant Feature Transform (SIFT) keypoint detector.

    Attributes
    ----------
    n_features : int
        Maximum number of keypoints to detect.
    n_octave_layers : int
        Number of layers in each octave.
    contrast_threshold : float
        Threshold for filtering weak keypoints.
    edge_threshold : float
        Threshold for filtering edge-like keypoints.
    sigma : float
        Gaussian sigma for initial smoothing.

    Methods
    -------
    detect(image)
        Detect keypoints in an image.
    compute(image, keypoints)
        Compute descriptors for detected keypoints.
    detectAndCompute(image)
        Detect keypoints and compute descriptors in one call.

    References
    ----------
    .. [1] Lowe, D.G. (2004). "Distinctive Image Features from
           Scale-Invariant Keypoints". International Journal of
           Computer Vision.
    """
    pass
```

---

## 4. DOCUMENTATION GENERATION TOOLS

### 4.1 Sphinx (Most Common for ML Libraries)

**Configuration (`conf.py`):**
```python
# Sphinx configuration for ML/CV project

extensions = [
    'sphinx.ext.autodoc',        # Auto-generate from docstrings
    'sphinx.ext.napoleon',       # Google/NumPy style support
    'sphinx.ext.viewcode',       # Add source code links
    'sphinx.ext.mathjax',        # Math equations
    'sphinx.ext.intersphinx',    # Link to other docs
    'sphinx_autodoc_typehints',  # Type hint support
]

# Napoleon settings for Google-style docstrings
napoleon_google_docstring = True
napoleon_numpy_docstring = True
napoleon_include_init_with_doc = True
napoleon_include_private_with_doc = False
napoleon_use_param = True
napoleon_use_rtype = True
napoleon_preprocess_types = True

# Theme for ML/CV docs
html_theme = 'sphinx_rtd_theme'  # Read the Docs theme

# Intersphinx mapping for cross-referencing
intersphinx_mapping = {
    'python': ('https://docs.python.org/3', None),
    'numpy': ('https://numpy.org/doc/stable', None),
    'torch': ('https://pytorch.org/docs/stable', None),
}
```

**Building Documentation:**
```bash
# Install Sphinx and extensions
pip install sphinx sphinx-rtd-theme sphinx-autodoc-typehints

# Generate API documentation
sphinx-apidoc -f -o docs/source/ src/

# Build HTML docs
cd docs && make html

# Build PDF docs
make latexpdf
```

### 4.2 MkDocs (Popular for Internal ML Platforms)

**Configuration (`mkdocs.yml`):**
```yaml
site_name: ML Pipeline Documentation
theme:
  name: material
  features:
    - navigation.tabs
    - navigation.sections
    - toc.integrate
    - search.suggest

plugins:
  - search
  - mkdocstrings:
      handlers:
        python:
          options:
            docstring_style: google
            show_source: true
            show_type_annotations: true

markdown_extensions:
  - pymdownx.highlight
  - pymdownx.superfences
  - pymdownx.arithmatex:
      generic: true
  - admonition

nav:
  - Home: index.md
  - API Reference:
    - Models: api/models.md
    - Data: api/data.md
    - Training: api/training.md
  - Tutorials: tutorials/
```

**Example Page (`docs/api/models.md`):**
```markdown
# Models API

::: src.models.resnet
    options:
      show_root_heading: true
      show_source: true

::: src.models.yolo
    options:
      members:
        - YOLOv5
        - YOLOHead
```

### 4.3 pdoc (Lightweight Alternative)

**Usage:**
```bash
# Install pdoc
pip install pdoc3

# Generate docs for module
pdoc --html --output-dir docs/ src/models/

# Serve docs locally
pdoc --http localhost:8080 src/
```

---

## 5. REAL-WORLD EXAMPLES FROM MAJOR ML/CV LIBRARIES

### 5.1 PyTorch (Google Style)

**From `torch.nn.Conv2d`:**
```python
class Conv2d(_ConvNd):
    """Applies a 2D convolution over an input signal.

    In the simplest case, the output value of the layer with input size
    :math:`(N, C_{in}, H, W)` and output :math:`(N, C_{out}, H_{out}, W_{out})`
    can be precisely described as:

    .. math::
        \\text{out}(N_i, C_{out_j}) = \\text{bias}(C_{out_j}) +
        \\sum_{k = 0}^{C_{in} - 1} \\text{weight}(C_{out_j}, k) \\star \\text{input}(N_i, k)

    Args:
        in_channels (int): Number of channels in the input image.
        out_channels (int): Number of channels produced by the convolution.
        kernel_size (int or tuple): Size of the convolving kernel.
        stride (int or tuple, optional): Stride of the convolution. Default: 1
        padding (int, tuple or str, optional): Padding added to all four sides.
            Default: 0
        dilation (int or tuple, optional): Spacing between kernel elements. Default: 1
        groups (int, optional): Number of blocked connections. Default: 1
        bias (bool, optional): If True, adds a learnable bias. Default: True

    Shape:
        - Input: :math:`(N, C_{in}, H_{in}, W_{in})`
        - Output: :math:`(N, C_{out}, H_{out}, W_{out})` where

        .. math::
            H_{out} = \\lfloor\\frac{H_{in} + 2 \\times \\text{padding}[0] -
                      \\text{dilation}[0] \\times (\\text{kernel_size}[0] - 1) - 1}
                      {\\text{stride}[0]} + 1\\rfloor

    Examples::
        >>> # With square kernels and equal stride
        >>> m = nn.Conv2d(16, 33, 3, stride=2)
        >>> # non-square kernels and unequal stride and with padding
        >>> m = nn.Conv2d(16, 33, (3, 5), stride=(2, 1), padding=(4, 2))
        >>> input = torch.randn(20, 16, 50, 100)
        >>> output = m(input)
    """
```

### 5.2 NumPy (NumPy Style)

**From `numpy.fft.fft2`:**
```python
def fft2(a, s=None, axes=(-2, -1), norm=None):
    """
    Compute the 2-dimensional discrete Fourier Transform.

    This function computes the N-dimensional discrete Fourier Transform
    over any axes in an M-dimensional array by means of the Fast Fourier
    Transform (FFT).

    Parameters
    ----------
    a : array_like
        Input array, can be complex.
    s : sequence of ints, optional
        Shape (length of each transformed axis) of the output.
    axes : sequence of ints, optional
        Axes over which to compute the FFT (default is last two axes).
    norm : {"backward", "ortho", "forward"}, optional
        Normalization mode (default is "backward").

    Returns
    -------
    out : complex ndarray
        The truncated or zero-padded input, transformed along the axes
        indicated by `axes`, or the last two axes if `axes` is not given.

    See Also
    --------
    numpy.fft : Overall view of discrete Fourier transforms.
    ifft2 : The inverse 2-D FFT.
    fft : The 1-D FFT.
    fftn : The N-D FFT.

    Notes
    -----
    `fft2` is just `fftn` with a different default for `axes`.

    The output has the same shape as the input except along the
    transformed axes. This is because the input is zero-padded or
    truncated to the shape specified by `s`.

    Examples
    --------
    >>> a = np.mgrid[:5, :5][0]
    >>> np.fft.fft2(a)
    array([[ 50.  +0.j,   0.  +0.j,   0.  +0.j,   0.  +0.j,   0.  +0.j],
           [-12.5+17.20477401j,  0.  +0.j,   0.  +0.j,   0.  +0.j,   0.  +0.j]])
    """
```

### 5.3 Hugging Face Transformers (Google Style)

**From `transformers.AutoModel`:**
```python
class AutoModel(_BaseAutoModelClass):
    """Generic model class for loading pretrained transformers.

    This is a generic model class that will be instantiated as one of the
    base model classes when created with the `from_pretrained()` method.

    Args:
        config (`PretrainedConfig`):
            Model configuration class with all parameters required for
            the model. Initializing with a config file does not load
            the weights, only the configuration.

    Example:
        >>> from transformers import AutoModel, AutoTokenizer
        >>>
        >>> tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")
        >>> model = AutoModel.from_pretrained("bert-base-uncased")
        >>>
        >>> inputs = tokenizer("Hello world!", return_tensors="pt")
        >>> outputs = model(**inputs)
        >>> last_hidden_states = outputs.last_hidden_state
    """
```

---

## 6. TYPE HINTS BEST PRACTICES FOR ML/CV

### 6.1 Tensor Shape Documentation

**Shape Annotations (Comments):**
```python
def attention(
    query: torch.Tensor,  # (batch, seq_len, d_model)
    key: torch.Tensor,    # (batch, seq_len, d_model)
    value: torch.Tensor,  # (batch, seq_len, d_model)
    mask: Optional[torch.Tensor] = None  # (batch, seq_len, seq_len)
) -> torch.Tensor:  # (batch, seq_len, d_model)
    """Compute scaled dot-product attention.

    Args:
        query: Query tensor of shape (batch, seq_len, d_model).
        key: Key tensor of shape (batch, seq_len, d_model).
        value: Value tensor of shape (batch, seq_len, d_model).
        mask: Optional attention mask of shape (batch, seq_len, seq_len).

    Returns:
        Attention output of shape (batch, seq_len, d_model).
    """
    pass
```

**Using torchtyping (Experimental):**
```python
from torchtyping import TensorType, patch_typeguard
from typeguard import typechecked

Batch = int
SeqLen = int
DModel = int

@typechecked
def attention(
    query: TensorType["batch", "seq_len", "d_model"],
    key: TensorType["batch", "seq_len", "d_model"],
    value: TensorType["batch", "seq_len", "d_model"],
    mask: Optional[TensorType["batch", "seq_len", "seq_len"]] = None
) -> TensorType["batch", "seq_len", "d_model"]:
    """Compute scaled dot-product attention with runtime shape checking."""
    pass
```

### 6.2 Generic Types for Flexibility

```python
from typing import TypeVar, Generic, Protocol
import numpy as np
import torch

ArrayLike = TypeVar('ArrayLike', np.ndarray, torch.Tensor)

def normalize(data: ArrayLike) -> ArrayLike:
    """Normalize array to [0, 1] range.

    Works with both NumPy arrays and PyTorch tensors.

    Args:
        data: Input array or tensor.

    Returns:
        Normalized data of same type as input.
    """
    if isinstance(data, torch.Tensor):
        return (data - data.min()) / (data.max() - data.min())
    return (data - np.min(data)) / (np.max(data) - np.min(data))
```

### 6.3 Protocol for Duck Typing

```python
from typing import Protocol

class ModelProtocol(Protocol):
    """Protocol for ML models."""

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        """Forward pass."""
        ...

    def parameters(self) -> Iterator[torch.Tensor]:
        """Return model parameters."""
        ...

def train_model(model: ModelProtocol, data: DataLoader) -> None:
    """Train any model implementing ModelProtocol.

    Args:
        model: Model with forward() and parameters() methods.
        data: Training data loader.
    """
    pass
```

---

## 7. DOXYGEN FOR C++/CUDA ML COMPONENTS

### 7.1 The Stack Reality

**Where Doxygen IS the Right Choice:**

Modern ML/CV has a **layered architecture** where documentation systems match the language of each layer:

| Layer | Language | Documentation | % of ML Work |
|-------|----------|---------------|--------------|
| Research, modeling, training | Python | Docstrings | ~80% |
| Data pipelines | Python | Docstrings | ~15% |
| Feature engineering | Python | Docstrings | ~3% |
| Serving glue code | Python/Rust/Go | Docstrings/godoc | ~1.5% |
| High-performance kernels | C++/CUDA | **Doxygen** | ~0.5% |

**Key Insight:** Doxygen covers a **small but critical layer** — the performance core, not the bulk of daily ML engineering.

### 7.2 When to Use Doxygen

**Use Doxygen when writing:**

1. **CUDA Kernels** - GPU-accelerated operations
2. **Custom C++ Ops** - PyTorch/TensorFlow extensions
3. **Inference Engines** - TensorRT plugins, ONNX Runtime kernels
4. **Performance-Critical CV Libraries** - Real-time processing
5. **Embedded/Robotics Vision Stacks** - Edge deployment

**Why Doxygen Here:**
- The language is C++/CUDA (not Python)
- Tooling expects Doxygen comments
- API documentation matters for other C++ engineers
- Integration with IDEs and static analysis works well

### 7.3 Doxygen Template for ML/CV

**CUDA Kernel Example:**
```cpp
/**
 * @file nms_kernel.cu
 * @brief GPU-accelerated Non-Maximum Suppression for object detection.
 *
 * Implements parallel NMS algorithm optimized for CUDA architecture.
 * Achieves ~10x speedup over CPU implementation on RTX 3090.
 */

/**
 * @brief Computes IoU between two bounding boxes on GPU.
 *
 * Uses parallel reduction to compute intersection over union for
 * all box pairs. Optimized for coalesced memory access patterns.
 *
 * @param boxes_a Pointer to first box array (N x 4) in [x1, y1, x2, y2] format
 * @param boxes_b Pointer to second box array (M x 4) in [x1, y1, x2, y2] format
 * @param output IoU matrix (N x M), row-major layout
 * @param N Number of boxes in first set
 * @param M Number of boxes in second set
 *
 * @note Assumes boxes are in normalized coordinates [0, 1]
 * @note Requires N * M threads in grid
 *
 * @warning No bounds checking - caller must ensure valid dimensions
 *
 * @see compute_nms_kernel() for full NMS implementation
 */
__global__ void compute_iou_kernel(
    const float* boxes_a,
    const float* boxes_b,
    float* output,
    int N,
    int M
) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.y * blockDim.y + threadIdx.y;

    if (i >= N || j >= M) return;

    // Implementation
}

/**
 * @brief Performs Non-Maximum Suppression on detected bounding boxes.
 *
 * Filters overlapping detections using IoU threshold. Implements
 * parallel algorithm with atomic operations for thread-safe updates.
 *
 * @param[in] boxes Detection boxes (N x 4) in [x1, y1, x2, y2] format
 * @param[in] scores Confidence scores (N x 1)
 * @param[in] N Number of input detections
 * @param[in] iou_threshold IoU threshold for suppression (typically 0.5-0.7)
 * @param[out] keep_mask Binary mask (N x 1) indicating kept detections
 * @param[out] num_keep Number of kept detections
 *
 * @return CUDA error code (cudaSuccess on success)
 *
 * @pre boxes and scores must be in device memory
 * @pre N must be > 0 and <= MAX_DETECTIONS (10000)
 * @pre iou_threshold must be in range [0.0, 1.0]
 *
 * @post keep_mask contains 1 for kept boxes, 0 for suppressed
 * @post num_keep contains total number of kept detections
 *
 * @code{.cpp}
 * // Example usage
 * float* d_boxes;
 * float* d_scores;
 * int* d_keep_mask;
 * int* d_num_keep;
 *
 * cudaMalloc(&d_boxes, N * 4 * sizeof(float));
 * cudaMalloc(&d_scores, N * sizeof(float));
 * cudaMalloc(&d_keep_mask, N * sizeof(int));
 * cudaMalloc(&d_num_keep, sizeof(int));
 *
 * cudaError_t err = compute_nms_kernel(
 *     d_boxes, d_scores, N, 0.5f, d_keep_mask, d_num_keep
 * );
 * @endcode
 *
 * @throw None (returns error code instead)
 *
 * @performance O(N²) complexity, ~2ms for 1000 boxes on RTX 3090
 *
 * @remark Based on algorithm from Faster R-CNN paper
 * @see https://arxiv.org/abs/1506.01497
 */
cudaError_t compute_nms_kernel(
    const float* boxes,
    const float* scores,
    int N,
    float iou_threshold,
    int* keep_mask,
    int* num_keep
);
```

**Custom PyTorch C++ Extension:**
```cpp
/**
 * @file roi_align.cpp
 * @brief RoI Align operation for Mask R-CNN.
 *
 * Implements differentiable RoI pooling with bilinear interpolation.
 * Provides both forward and backward passes for PyTorch integration.
 */

#include <torch/extension.h>

/**
 * @class RoIAlignFunction
 * @brief Autograd function for RoI Align operation.
 *
 * Implements torch.autograd.Function interface for custom differentiable
 * operation. Handles both CPU and CUDA tensors with appropriate dispatch.
 */
class RoIAlignFunction : public torch::autograd::Function<RoIAlignFunction> {
public:
    /**
     * @brief Forward pass of RoI Align.
     *
     * Extracts fixed-size feature maps from regions of interest using
     * bilinear interpolation. Supports arbitrary input feature resolutions.
     *
     * @param ctx Context object for saving tensors for backward
     * @param features Input feature maps (N, C, H, W)
     * @param rois Region proposals (num_rois, 5) in [batch_idx, x1, y1, x2, y2]
     * @param output_size Target output size (height, width)
     * @param spatial_scale Ratio of input image to feature map size
     * @param sampling_ratio Number of sampling points per bin (0 for adaptive)
     *
     * @return Aligned features (num_rois, C, output_h, output_w)
     *
     * @note All inputs must be on same device (CPU or CUDA)
     * @note Coordinates in rois are in original image space
     *
     * @warning Undefined behavior if batch_idx >= N in any RoI
     */
    static torch::Tensor forward(
        torch::autograd::AutogradContext* ctx,
        torch::Tensor features,
        torch::Tensor rois,
        std::tuple<int, int> output_size,
        double spatial_scale,
        int sampling_ratio
    );

    /**
     * @brief Backward pass of RoI Align.
     *
     * Computes gradients with respect to input features. RoIs are not
     * differentiable (treated as constants in backward pass).
     *
     * @param ctx Context object with saved tensors from forward
     * @param grad_output Gradient of loss w.r.t. output (num_rois, C, H, W)
     *
     * @return Tuple of gradients: (grad_features, None, None, None, None)
     *
     * @note Returns None for non-differentiable inputs (rois, sizes, etc.)
     */
    static torch::autograd::tensor_list backward(
        torch::autograd::AutogradContext* ctx,
        torch::autograd::tensor_list grad_outputs
    );
};

/**
 * @brief Python binding for RoI Align operation.
 *
 * @param features Input feature maps
 * @param rois Region of interest boxes
 * @param output_size Output dimensions
 * @param spatial_scale Feature map scale
 * @param sampling_ratio Sampling density
 *
 * @return Pooled features
 *
 * @see RoIAlignFunction::forward() for detailed parameter descriptions
 */
torch::Tensor roi_align(
    torch::Tensor features,
    torch::Tensor rois,
    std::tuple<int, int> output_size,
    double spatial_scale = 1.0,
    int sampling_ratio = 0
) {
    return RoIAlignFunction::apply(
        features, rois, output_size, spatial_scale, sampling_ratio
    );
}

PYBIND11_MODULE(TORCH_EXTENSION_NAME, m) {
    m.def("roi_align", &roi_align, "RoI Align operation",
          py::arg("features"),
          py::arg("rois"),
          py::arg("output_size"),
          py::arg("spatial_scale") = 1.0,
          py::arg("sampling_ratio") = 0);
}
```

### 7.4 Doxygen Configuration for ML Projects

**Doxyfile Template:**
```doxygen
# Project information
PROJECT_NAME           = "Custom CUDA Ops for YOLOv5"
PROJECT_NUMBER         = 1.0.0
PROJECT_BRIEF          = "High-performance CUDA kernels for object detection"

# Input/output
INPUT                  = src/ include/
FILE_PATTERNS          = *.cpp *.cu *.h *.hpp *.cuh
RECURSIVE              = YES
OUTPUT_DIRECTORY       = docs/

# Extraction settings
EXTRACT_ALL            = YES
EXTRACT_PRIVATE        = NO
EXTRACT_STATIC         = YES

# Build settings
GENERATE_HTML          = YES
GENERATE_LATEX         = NO
HTML_OUTPUT            = html
HTML_COLORSTYLE_HUE    = 220
HTML_COLORSTYLE_SAT    = 100

# CUDA support
EXTENSION_MAPPING      = cu=C++
FILE_PATTERNS          += *.cu *.cuh

# Code browser
SOURCE_BROWSER         = YES
INLINE_SOURCES         = NO
STRIP_CODE_COMMENTS    = NO
REFERENCED_BY_RELATION = YES
REFERENCES_RELATION    = YES

# Preprocessing
ENABLE_PREPROCESSING   = YES
MACRO_EXPANSION        = YES
EXPAND_ONLY_PREDEF     = NO
PREDEFINED             = __CUDACC__ \
                         __global__="" \
                         __device__="" \
                         __host__=""

# Diagram generation
HAVE_DOT               = YES
CALL_GRAPH             = YES
CALLER_GRAPH           = YES
DOT_IMAGE_FORMAT       = svg
INTERACTIVE_SVG        = YES

# External references
TAGFILES               = \
    /path/to/cuda/docs/cuda.tag=https://docs.nvidia.com/cuda/
```

**Build Script:**
```bash
#!/bin/bash
# build_docs.sh

# Generate Doxygen docs for C++ layer
doxygen Doxyfile

# Generate Python docs for wrapper layer
cd python/
sphinx-apidoc -f -o docs/source/ .
cd docs && make html

echo "Documentation built:"
echo "  C++/CUDA API: docs/html/index.html"
echo "  Python API: python/docs/build/html/index.html"
```

### 7.5 Role-Based Documentation Matrix

**Professional Rule:** Use the documentation system native to the language of the layer you're working in.

| Role | Primary Language | Documentation System | Tools |
|------|------------------|---------------------|-------|
| ML Researcher | Python | Python docstrings | Sphinx, Jupyter |
| ML Engineer (training) | Python | Python docstrings | MkDocs, pdoc |
| MLOps Engineer | Python/YAML | Docstrings + OpenAPI | Swagger, Sphinx |
| Inference Engineer | C++/Python | **Doxygen + Docstrings** | Doxygen, Sphinx |
| CUDA Performance Engineer | CUDA/C++ | **Doxygen** | Doxygen, Nsight |
| Systems Engineer | C++/Rust | **Doxygen/rustdoc** | Doxygen, cargo doc |

### 7.6 Why Teams Avoid Doxygen Outside C++

**Practical Limitations:**

1. **Doesn't integrate with Python tooling**
   - No mypy/pyright support
   - No Jupyter notebook rendering
   - Breaks IDE autocomplete

2. **Heavy setup for fast-moving ML repos**
   - Research code changes daily
   - Experimental prototypes don't need HTML docs
   - Maintenance overhead too high

3. **Harder to keep updated in experimental code**
   - Doxygen requires strict format
   - Python docstrings more forgiving
   - Notebook-first workflow doesn't mesh

4. **Most contributors are Python-first**
   - Team velocity matters
   - Lower barrier with familiar tools
   - Better developer experience

### 7.7 API Docs vs Research Iteration

**Doxygen is Built For:**
- ✅ Stable APIs
- ✅ Library documentation
- ✅ Engineered systems
- ✅ Long-term maintenance

**ML/CV Day-to-Day Work:**
- ❌ Rapid experiments
- ❌ Model prototypes
- ❌ One-off scripts
- ❌ Research code

**The Real Boundary:**

```
┌─────────────────────────────────────────────────────┐
│ Python Layer (80% of work)                          │
│ • Research, training, data pipelines                │
│ • Documentation: Python docstrings                  │
│ • Tools: Sphinx, MkDocs, Jupyter                    │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ Python/C++ Interface (15% of work)                  │
│ • Custom ops, bindings, extensions                  │
│ • Documentation: Docstrings + Doxygen               │
│ • Tools: pybind11, torch::extension                 │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ C++/CUDA Layer (5% of work)                         │
│ • Kernels, inference engines, embedded              │
│ • Documentation: Doxygen                            │
│ • Tools: Doxygen, NVIDIA Nsight, TensorRT           │
└─────────────────────────────────────────────────────┘
```

### 7.8 Integration Example: Mixed Python/C++ Project

**Project Structure:**
```
ml_project/
├── python/
│   ├── __init__.py
│   ├── models.py          # Python docstrings
│   ├── training.py        # Python docstrings
│   └── docs/
│       └── conf.py        # Sphinx config
├── csrc/
│   ├── cuda/
│   │   ├── nms_kernel.cu  # Doxygen comments
│   │   └── roi_align.cu   # Doxygen comments
│   ├── ops/
│   │   └── roi_align.cpp  # Doxygen comments
│   └── Doxyfile           # Doxygen config
├── setup.py               # PyTorch extension build
└── README.md
```

**Python Wrapper with Both Styles:**
```python
# python/ops/roi_align.py

import torch
from torch.autograd import Function
from .. import _C  # C++ extension

class RoIAlign(Function):
    """RoI Align operation with bilinear interpolation.

    This is a Python wrapper around the C++/CUDA implementation.
    See csrc/ops/roi_align.cpp for low-level implementation details.

    Args:
        features: Input feature maps (N, C, H, W).
        rois: Region proposals (num_rois, 5) as [batch_idx, x1, y1, x2, y2].
        output_size: Target output dimensions (height, width).
        spatial_scale: Ratio of input image to feature map size.
        sampling_ratio: Number of sampling points per bin.

    Returns:
        Aligned features of shape (num_rois, C, output_h, output_w).

    Note:
        The C++ implementation uses bilinear interpolation for
        sub-pixel accuracy. See Doxygen docs for performance details.

    Example:
        >>> features = torch.randn(2, 256, 38, 38).cuda()
        >>> rois = torch.tensor([
        ...     [0, 10, 10, 50, 50],  # batch 0
        ...     [1, 20, 20, 60, 60],  # batch 1
        ... ]).float().cuda()
        >>> aligned = RoIAlign.apply(features, rois, (7, 7), 1.0/16, 2)
        >>> aligned.shape
        torch.Size([2, 256, 7, 7])
    """

    @staticmethod
    def forward(ctx, features, rois, output_size, spatial_scale, sampling_ratio):
        # Call C++ implementation (documented with Doxygen)
        output = _C.roi_align_forward(
            features, rois, output_size, spatial_scale, sampling_ratio
        )
        ctx.save_for_backward(features, rois)
        ctx.output_size = output_size
        ctx.spatial_scale = spatial_scale
        ctx.sampling_ratio = sampling_ratio
        return output
```

### 7.9 Bottom Line

**Doxygen is absolutely correct for C++/CUDA ML components.**

It's just that those components represent the **performance core**, not the **majority of ML engineering work**, which is why you hear less about it in the broader ML ecosystem.

**When to Use Doxygen:**
- ✅ Writing CUDA kernels
- ✅ Building custom C++ ops
- ✅ Developing inference engines
- ✅ Creating embedded CV libraries
- ✅ Performance-critical paths

**When to Use Python Docstrings:**
- ✅ Everything else (80%+ of ML/CV work)

Use Doxygen **without hesitation** when writing C++/CUDA—it's the industry standard for that layer.

---

## 8. ANTI-PATTERNS TO AVOID

### 8.1 Bad: Incomplete Docstrings

```python
# ❌ BAD
def process_image(img, size):
    """Process image."""
    pass

# ✅ GOOD
def process_image(
    img: np.ndarray,
    size: Tuple[int, int]
) -> np.ndarray:
    """Resize and normalize image for model input.

    Args:
        img: Input image of shape (H, W, 3) in RGB format.
        size: Target size as (height, width).

    Returns:
        Processed image of shape (*size, 3) with values in [0, 1].
    """
    pass
```

### 7.2 Bad: Missing Type Hints

```python
# ❌ BAD
def train(model, data, epochs=10):
    """Train the model."""
    pass

# ✅ GOOD
def train(
    model: nn.Module,
    data: DataLoader,
    epochs: int = 10
) -> Dict[str, List[float]]:
    """Train the model for specified epochs.

    Args:
        model: PyTorch model to train.
        data: Training data loader.
        epochs: Number of training epochs.

    Returns:
        Dictionary of training metrics.
    """
    pass
```

### 7.3 Bad: Unclear Shape Documentation

```python
# ❌ BAD
def forward(self, x):
    """Forward pass.

    Args:
        x: Input tensor.

    Returns:
        Output tensor.
    """
    pass

# ✅ GOOD
def forward(self, x: torch.Tensor) -> torch.Tensor:
    """Forward pass through the network.

    Args:
        x: Input tensor of shape (batch_size, channels, height, width).

    Returns:
        Output tensor of shape (batch_size, num_classes).
    """
    pass
```

### 7.4 Bad: Mixing Documentation Styles

```python
# ❌ BAD - Mixed Google and NumPy styles
def detect_objects(image: np.ndarray) -> List[Dict]:
    """Detect objects in image.

    Parameters  # NumPy section in Google-style doc
    ----------
    image : np.ndarray
        Input image

    Args:  # Google section mixed with NumPy
        image: Input image array
    """
    pass

# ✅ GOOD - Consistent Google style
def detect_objects(image: np.ndarray) -> List[Dict]:
    """Detect objects in image.

    Args:
        image: Input image array of shape (H, W, 3).

    Returns:
        List of detection dictionaries with 'bbox' and 'class' keys.
    """
    pass
```

---

## 9. INTEGRATION WITH YOUR WORKFLOW

### 9.1 Specification Protocol Mapping

**Your Framework → ML/CV Documentation:**

| Your Component | ML/CV Equivalent | Implementation |
|----------------|------------------|----------------|
| Specification Protocol | Docstring Standard | Google-style or NumPy-style |
| Type Validation | Type Hints (PEP 484) | `def func(x: type) -> type:` |
| API Documentation | Sphinx/MkDocs | Auto-generated from docstrings |
| Contract Definition | Function Signatures | Args, Returns, Raises sections |

### 8.2 4-Stage Development Process

**1. Vibe (Concept):**
```python
# Define function purpose in plain English
def train_detector():
    """Train object detection model on custom dataset."""
    pass
```

**2. Specify (Architecture):**
```python
# Add complete type hints and full docstring
def train_detector(
    dataset: Dataset,
    model: nn.Module,
    config: TrainingConfig
) -> Tuple[nn.Module, MetricsDict]:
    """Train object detection model on custom dataset.

    Implements YOLOv5 training with automatic mixed precision,
    gradient accumulation, and learning rate scheduling.

    Args:
        dataset: Training dataset with __getitem__ returning
            (image, targets) tuples.
        model: Detection model (e.g., YOLOv5, RetinaNet).
        config: Training configuration including hyperparameters.

    Returns:
        Tuple containing trained model and dictionary of metrics.

    Raises:
        ValueError: If dataset is empty or config is invalid.
    """
    pass
```

**3. Verify (Testing):**
```bash
# Validate docstrings
pydocstyle src/

# Check type hints
mypy src/

# Generate docs to verify formatting
sphinx-build -b html docs/source docs/build

# Run doctest examples
pytest --doctest-modules src/
```

**4. Own (Production):**
```bash
# Deploy documentation
mkdocs build
mkdocs gh-deploy

# Publish to PyPI with proper docstrings
python -m build
twine upload dist/*
```

### 8.3 Pre-commit Hooks for Documentation Quality

**`.pre-commit-config.yaml`:**
```yaml
repos:
  - repo: https://github.com/PyCQA/pydocstyle
    rev: 6.3.0
    hooks:
      - id: pydocstyle
        args: ['--convention=google']

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        args: ['--strict']
        additional_dependencies: [types-all]

  - repo: local
    hooks:
      - id: docstring-coverage
        name: Check docstring coverage
        entry: docstr-coverage
        args: ['src/', '--fail-under=80']
        language: python
        pass_filenames: false
```

---

## 10. TOOLING ECOSYSTEM

### 10.1 Linters and Validators

**pydocstyle (Docstring Linter):**
```bash
# Install
pip install pydocstyle

# Check Google-style compliance
pydocstyle --convention=google src/

# Check NumPy-style compliance
pydocstyle --convention=numpy src/

# Configuration (.pydocstyle)
[pydocstyle]
convention = google
match = (?!test_).*\.py
match-dir = (?!tests|build|dist).*
```

**darglint (Docstring/Code Consistency):**
```bash
# Install
pip install darglint

# Check docstring matches function signature
darglint -v 2 src/models.py

# Configuration (.darglint)
[darglint]
docstring_style=google
strictness=full
```

**interrogate (Docstring Coverage):**
```bash
# Install
pip install interrogate

# Check coverage
interrogate -v src/

# Generate badge
interrogate --generate-badge docs/

# Configuration (pyproject.toml)
[tool.interrogate]
ignore-init-method = true
ignore-magic = true
fail-under = 80
exclude = ["tests", "build"]
```

### 9.2 Type Checkers

**mypy (Static Type Checker):**
```bash
# Install
pip install mypy

# Check types
mypy src/

# Configuration (mypy.ini)
[mypy]
python_version = 3.10
warn_return_any = True
warn_unused_configs = True
disallow_untyped_defs = True

[mypy-torch.*]
ignore_missing_imports = True
```

**pyright (Microsoft Type Checker):**
```bash
# Install
npm install -g pyright

# Check types
pyright src/

# Configuration (pyrightconfig.json)
{
  "include": ["src"],
  "exclude": ["**/node_modules", "**/__pycache__"],
  "typeCheckingMode": "strict",
  "pythonVersion": "3.10"
}
```

### 9.3 Documentation Generators

**Sphinx Extensions for ML/CV:**
```bash
pip install \
    sphinx \
    sphinx-rtd-theme \
    sphinx-autodoc-typehints \
    sphinx-gallery \
    nbsphinx \
    sphinxcontrib-bibtex
```

**MkDocs Plugins for ML/CV:**
```bash
pip install \
    mkdocs-material \
    mkdocstrings[python] \
    mkdocs-jupyter \
    mkdocs-bibtex
```

---

## 11. QUICK REFERENCE

### 11.1 Google-Style Cheat Sheet

```python
def function_name(
    param1: Type1,
    param2: Type2 = default
) -> ReturnType:
    """Single-line summary (imperative mood).

    Extended description explaining what the function does,
    any important context, and algorithmic details.

    Args:
        param1: Description of param1.
        param2: Description of param2. Defaults to value.

    Returns:
        Description of return value.

    Raises:
        ExceptionType: When this exception occurs.

    Example:
        >>> result = function_name(value1, value2)
        >>> print(result)
        expected_output
    """
```

### 10.2 NumPy-Style Cheat Sheet

```python
def function_name(
    param1: Type1,
    param2: Type2 = default
) -> ReturnType:
    """
    Single-line summary (descriptive).

    Extended description explaining what the function does,
    any important context, and algorithmic details.

    Parameters
    ----------
    param1 : Type1
        Description of param1.
    param2 : Type2, optional
        Description of param2 (default is value).

    Returns
    -------
    return_name : ReturnType
        Description of return value.

    Raises
    ------
    ExceptionType
        When this exception occurs.

    See Also
    --------
    other_function : Related function.

    Notes
    -----
    Additional algorithmic details, equations, etc.

    References
    ----------
    .. [1] Author. "Title." Journal. Year.

    Examples
    --------
    >>> result = function_name(value1, value2)
    >>> print(result)
    expected_output
    """
```

### 10.3 Essential Commands

```bash
# Validate docstrings
pydocstyle --convention=google src/

# Check type hints
mypy --strict src/

# Check docstring coverage
interrogate -v src/

# Generate Sphinx docs
sphinx-apidoc -f -o docs/source/ src/
cd docs && make html

# Generate MkDocs site
mkdocs build
mkdocs serve

# Run doctests
pytest --doctest-modules src/

# Auto-format code
black src/
isort src/
```

---

## 12. DECISION MATRIX

**When to Use Each Documentation Style:**

### Python Layer (80% of ML/CV work):

| Criterion | Google Style | NumPy Style |
|-----------|-------------|-------------|
| **Industry ML/CV** | ✅ Preferred | ⚠️ Acceptable |
| **Research/Academic** | ⚠️ Acceptable | ✅ Preferred |
| **Production Code** | ✅ Preferred | ⚠️ Less common |
| **Scientific Libraries** | ⚠️ Less common | ✅ Preferred |
| **Readability** | ✅ Very high | ✅ Very high |
| **Compactness** | ✅ More compact | ⚠️ More verbose |
| **Math Formulas** | ⚠️ Good | ✅ Excellent |
| **References/Citations** | ⚠️ Good | ✅ Excellent |
| **IDE Support** | ✅ Excellent | ✅ Excellent |
| **Sphinx Support** | ✅ Native (Napoleon) | ✅ Native (Napoleon) |

**Recommendation:** Use **Google-style for production ML/CV code**, NumPy-style for scientific/research projects with heavy mathematical content.

### C++/CUDA Layer (5-20% of ML/CV work):

| Criterion | Doxygen | Python Docstrings |
|-----------|---------|-------------------|
| **CUDA Kernels** | ✅ Required | ❌ N/A |
| **Custom C++ Ops** | ✅ Preferred | ⚠️ For wrapper only |
| **Inference Engines** | ✅ Required | ⚠️ For Python API |
| **Embedded/Robotics** | ✅ Required | ❌ N/A |
| **Performance Libraries** | ✅ Preferred | ⚠️ For bindings |
| **C++ Engineer Audience** | ✅ Expected | ❌ Wrong tool |
| **IDE Integration (C++)** | ✅ Excellent | ❌ N/A |
| **HTML Generation** | ✅ Excellent | ⚠️ Different tool |
| **Call Graphs** | ✅ Built-in | ❌ N/A |
| **Maintenance** | ⚠️ Higher overhead | ✅ Lighter |

**Recommendation:** Use **Doxygen for all C++/CUDA code**, Python docstrings for wrapper layers.

### Multi-Layer Projects Decision Tree:

```
Is this a C++/CUDA file?
│
├─ YES → Use Doxygen
│   └─ Is there a Python wrapper?
│       └─ YES → Also add Python docstrings to wrapper
│
└─ NO → Is this Python?
    └─ YES → Use Python docstrings
        ├─ Production/Industry? → Google style
        └─ Research/Scientific? → NumPy style
```

---

## 13. RESOURCES

### 13.1 Official Specifications

- **PEP 257 (Docstrings):** https://peps.python.org/pep-0257/
- **PEP 484 (Type Hints):** https://peps.python.org/pep-0484/
- **PEP 526 (Variable Annotations):** https://peps.python.org/pep-0526/
- **Google Style Guide:** https://google.github.io/styleguide/pyguide.html
- **NumPy Documentation Standard:** https://numpydoc.readthedocs.io/

### 13.2 Documentation Tools

- **Sphinx:** https://www.sphinx-doc.org/
- **MkDocs:** https://www.mkdocs.org/
- **pdoc:** https://pdoc.dev/
- **Doxygen:** https://www.doxygen.nl/
- **pydocstyle:** http://www.pydocstyle.org/
- **darglint:** https://github.com/terrencepreilly/darglint

### 13.3 Type Checking

- **mypy:** https://mypy.readthedocs.io/
- **pyright:** https://github.com/microsoft/pyright
- **torchtyping:** https://github.com/patrick-kidger/torchtyping

### 13.4 C++/CUDA Documentation

- **Doxygen Manual:** https://www.doxygen.nl/manual/
- **CUDA Documentation:** https://docs.nvidia.com/cuda/
- **PyTorch C++ Extensions:** https://pytorch.org/tutorials/advanced/cpp_extension.html
- **TensorFlow Custom Ops:** https://www.tensorflow.org/guide/create_op

### 13.5 Examples from Major Libraries

- **PyTorch Docs:** https://pytorch.org/docs/stable/
- **TensorFlow Docs:** https://www.tensorflow.org/api_docs/python/
- **NumPy Docs:** https://numpy.org/doc/stable/
- **Hugging Face Transformers:** https://huggingface.co/docs/transformers/

---

**END OF NOTES**

**Last updated:** 2026-02-01
**Next Review:** When starting new ML/CV project
