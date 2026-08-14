#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "${repo_root}"

fail=0

echo "[policy-consistency] Running consistency checks..."

# 1) Ban removed legacy exception log target.
if rg -n --glob '!rules/system/scripts/policy-consistency-check.sh' "exception-and-decision-log\.md" "README.md" "rules/" >/dev/null; then
  echo "[policy-consistency] ERROR: Found deprecated exception log path (exception-and-decision-log.md). Use security-exceptions.md." >&2
  fail=1
fi

# 2) README must not state Cursor-only coding guidance.
if rg -n "\*\*Cursor only\*\*" "README.md" >/dev/null; then
  echo "[policy-consistency] ERROR: README contains stale 'Cursor only' guidance." >&2
  fail=1
fi

# 3) web-policies must not contain orphaned infrastructure stub.
if rg -n "^# Docker/Podman/Kubernetes/Kafka$" "rules/web-policies.md" >/dev/null; then
  echo "[policy-consistency] ERROR: web-policies.md contains orphaned Docker/Kubernetes stub heading." >&2
  fail=1
fi

# 4) Spend freeze integrity. Active freeze forbids extra billed
# spend until the owner records SPEND FREEZE LIFTED.
freeze_file="rules/approved-ai-tools.md"
if rg -q "SPEND FREEZE LIFTED" "${freeze_file}" \
  && ! rg -q "SPEND FREEZE \(active\)" "${freeze_file}"; then
  echo "[policy-consistency] INFO: spend freeze lifted in ${freeze_file}"
elif rg -q "SPEND FREEZE \(active\)" "${freeze_file}"; then
  if ! rg -q "pay-as-you-go extra usage billing disabled" "${freeze_file}"; then
    echo "[policy-consistency] ERROR: PAYG-disabled control missing from ${freeze_file} while spend freeze is active." >&2
    fail=1
  fi
  for pointer in \
    "AGENTS.md" \
    "rules/model-registry.md" \
    "rules/ai-workflow-policy.md"
  do
    if ! rg -q "spend freeze|SPEND FREEZE" "${pointer}"; then
      echo "[policy-consistency] ERROR: ${pointer} missing spend-freeze pointer while freeze is active." >&2
      fail=1
    fi
  done
else
  echo "[policy-consistency] ERROR: ${freeze_file} must contain SPEND FREEZE (active) or SPEND FREEZE LIFTED." >&2
  fail=1
fi

# 5) approved-ai-tools stale review dates are warning-only.
python3 - <<'PY'
import re
from datetime import date
from pathlib import Path
import sys

text = Path("rules/approved-ai-tools.md").read_text(encoding="utf-8")
today = date.today()
stale = []
for m in re.finditer(r"Next Review:\s*(\d{4}-\d{2}-\d{2})", text):
    d = date.fromisoformat(m.group(1))
    if d < today:
        stale.append(m.group(1))

if stale:
    print(
        "[policy-consistency] WARN: approved-ai-tools.md has stale Next Review dates: "
        + ", ".join(sorted(set(stale))),
        file=sys.stderr,
    )
PY

if [ "${fail}" -ne 0 ]; then
  echo "[policy-consistency] FAILED" >&2
  exit 1
fi

echo "[policy-consistency] OK"
