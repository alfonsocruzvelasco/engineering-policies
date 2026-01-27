#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
ERRORS=0

# Prefer dedicated venvs if present
SEC_VENV_BIN="${HOME}/dev/venvs/sec-tools/bin"
DEP_VENV_BIN="${HOME}/dev/venvs/dep-audit/bin"

SEMGREP="semgrep"
BANDIT="bandit"
PIP_AUDIT="pip-audit"

if [[ -x "${SEC_VENV_BIN}/semgrep" ]]; then SEMGREP="${SEC_VENV_BIN}/semgrep"; fi
if [[ -x "${SEC_VENV_BIN}/bandit"  ]]; then BANDIT="${SEC_VENV_BIN}/bandit"; fi
if [[ -x "${DEP_VENV_BIN}/pip-audit" ]]; then PIP_AUDIT="${DEP_VENV_BIN}/pip-audit"; fi

echo "AI Security Check"
echo "================="
echo ""

# Must be run from repo root (where .git exists)
if [[ ! -d "${ROOT_DIR}/.git" ]]; then
  echo "BLOCKED: run this from the repo root (folder containing .git)."
  exit 2
fi

echo "[1/4] Secrets (TruffleHog via pre-commit)..."
if command -v pre-commit >/dev/null 2>&1; then
  if pre-commit run trufflehog -a; then
    echo "OK: no verified secrets (per pre-commit hook)."
  else
    echo "BLOCKED: TruffleHog hook failed or found secrets."
    ERRORS=$((ERRORS+1))
  fi
else
  echo "BLOCKED: pre-commit not found on PATH (needed to run trufflehog reliably)."
  ERRORS=$((ERRORS+1))
fi

echo ""
echo "[2/4] SAST (Semgrep)..."
if "${SEMGREP}" --config=auto --error .; then
  echo "OK: semgrep passed."
else
  echo "BLOCKED: semgrep failed or found blocking findings."
  ERRORS=$((ERRORS+1))
fi

echo ""
echo "[3/4] Python security lint (Bandit)..."
if "${BANDIT}" -r . -ll; then
  echo "OK: bandit passed."
else
  echo "BLOCKED: bandit found issues or failed."
  ERRORS=$((ERRORS+1))
fi

echo ""
echo "[4/4] Dependency CVEs (pip-audit)..."
if "${PIP_AUDIT}"; then
  echo "OK: no known dependency vulnerabilities."
else
  echo "BLOCKED: pip-audit reported vulnerabilities."
  ERRORS=$((ERRORS+1))
fi

echo ""
echo "[extra] Critical pattern checks..."
if grep -R --line-number --include="*.py" 'shell=True' . >/dev/null 2>&1; then
  echo "BLOCKED: shell=True detected."
  ERRORS=$((ERRORS+1))
else
  echo "OK: no shell=True."
fi

if grep -R --line-number --include="*.py" -E '\.execute\(\s*f"|\.execute\(\s*".*\{|\bexecutemany\(\s*f"' . >/dev/null 2>&1; then
  echo "BLOCKED: suspicious SQL string formatting detected."
  ERRORS=$((ERRORS+1))
else
  echo "OK: no obvious SQL string formatting patterns."
fi

echo ""
if [[ "${ERRORS}" -gt 0 ]]; then
  echo "RESULT: BLOCKED (${ERRORS} blocking issue(s))"
  exit 1
fi

echo "RESULT: PASS"
