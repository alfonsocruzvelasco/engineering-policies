# Project Name

**Purpose:** [One-sentence description of what this project does]

---

## Quickstart

[Brief instructions to get the project running locally]

```bash
# Example commands
git clone <repo-url>
cd <project-name>
# Setup steps
# Run steps
```

---

## Technical Baseline

| Component | Version | Notes |
|-----------|---------|-------|
| Python    | 3.11    | Managed via pyenv, enforced in `pyproject.toml` |
| C++       | C++20   | ISO mode, no GNU extensions. Enforced in `CMakeLists.txt` |
| Compiler  | GCC ≥14 | Must support C++20 fully |
| CUDA      | 12.4    | Required for GPU builds |
| PyTorch   | 2.2     | See `pyproject.toml` for exact version |
| Node      | 20 LTS  | See `.nvmrc` |

**Note:** Only critical versions that affect compatibility are listed here. For exact dependency versions, see lockfiles (`poetry.lock`, `package-lock.json`, etc.).

---

## Environment Setup

[Instructions for setting up the development environment]

---

## Testing

[How to run tests]

```bash
# Example
pytest
```

---

## Key Links

- [Documentation](docs/)
- [Contributing](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)

---

## License

[License information]
