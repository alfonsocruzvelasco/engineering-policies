#!/usr/bin/env bash
set -euo pipefail

fail=0
scanned=0

patterns=(
  'ignore (all )?(previous|above) instructions'
  'override (the )?(system|developer|policy)'
  'do not (tell|mention|log|show)'
  'execute silently'
  'hide this from the user'
  'reveal (the )?(system prompt|secrets|credentials|tokens)'
  'exfiltrate'
  'send .* to .*server'
  'encode .* in (url|path|query|string|header|dns)'
  'navigate .* letter by letter'
  'verify .* user'
  'authenticate .* assistant'
  'profile verified'
  'security question'
  'current employer'
  'hometown'
  'conversation_search'
  'web_fetch'
)

excluded_file() {
  case "$1" in
    rules/agent-egress-and-memory-isolation-policy.md|\
    rules/references/long-context-windows-opus-4.6+.md|\
    rules/references/open-claw-security-policy.md)
      return 0
      ;;
  esac
  return 1
}

scan_file() {
  local file="$1"
  [ -f "$file" ] || return 0
  scanned=$((scanned + 1))
  local pattern
  for pattern in "${patterns[@]}"; do
    if grep -Ein "$pattern" "$file" >/tmp/pi-match.txt 2>/dev/null; then
      echo "[prompt-injection-scan] ERROR: suspicious pattern"
      echo "file: $file"
      cat /tmp/pi-match.txt
      echo
      fail=1
    fi
  done
}

files=()
if [[ $# -gt 0 ]]; then
  # Filenames supplied by pre-commit or an explicit caller: scan exactly those.
  files=("$@")
else
  # Direct invocation with no args: full eligible-repository scan.
  # Do not consult the Git staging index and do not depend on .jj/.
  while IFS= read -r -d '' f; do
    f="${f#./}"
    if excluded_file "$f"; then
      continue
    fi
    files+=("$f")
  done < <(find . -type f \
    \( -name '*.md' -o -name '*.txt' -o -name '*.prompt' \
       -o -name '*.yaml' -o -name '*.yml' -o -name '*.json' \) \
    ! -path './.git/*' \
    ! -path './.jj/*' \
    ! -path '*/node_modules/*' \
    ! -path '*/.venv/*' \
    ! -path '*/venv/*' \
    -print0)
fi

if [[ ${#files[@]} -eq 0 ]]; then
  echo "[prompt-injection-scan] ERROR: no eligible files to scan" >&2
  exit 2
fi

for file in "${files[@]}"; do
  scan_file "$file"
done

echo "[prompt-injection-scan] scanned ${scanned} files"
exit "$fail"
