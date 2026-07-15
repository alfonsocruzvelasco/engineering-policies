#!/usr/bin/env bash
set -euo pipefail

fail=0

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

files=$(git diff --cached --name-only --diff-filter=ACM \
  | grep -E '\.(md|txt|prompt|yaml|yml|json)$' || true)

[ -z "$files" ] && exit 0

for file in $files; do
  [ -f "$file" ] || continue
  for pattern in "${patterns[@]}"; do
    if grep -Ein "$pattern" "$file" >/tmp/pi-match.txt 2>/dev/null; then
      echo "[prompt-injection-scan] ERROR: suspicious pattern"
      echo "file: $file"
      cat /tmp/pi-match.txt
      echo
      fail=1
    fi
  done
done

exit "$fail"
