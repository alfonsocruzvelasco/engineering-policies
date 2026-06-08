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

# 4) approved-ai-tools stale review dates are warning-only.
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
