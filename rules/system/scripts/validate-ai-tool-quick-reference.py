#!/usr/bin/env python3
# AI-Generated: validation helper script
"""
Validate rules/ai-tool-policy-quick-reference.md source/section references.

Checks:
- Referenced source file exists.
- Referenced heading labels are present in the source file.
"""

from __future__ import annotations

from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[3]
QREF = ROOT / "rules" / "ai-tool-policy-quick-reference.md"


def parse_rows(text: str) -> list[tuple[str, str, str]]:
    rows = []
    for line in text.splitlines():
        if not line.startswith("|") or "`rules/" not in line:
            continue
        parts = [p.strip() for p in line.strip("|").split("|")]
        if len(parts) < 3 or parts[0] in {"Rule", "---"}:
            continue
        rows.append((parts[0], parts[1].strip("`"), parts[2]))
    return rows


def main() -> int:
    rows = parse_rows(QREF.read_text(encoding="utf-8"))
    errors: list[str] = []

    for rule, src, sec in rows:
        src_path = ROOT / src
        if not src_path.exists():
            errors.append(f"{rule}: missing source file {src}")
            continue

        src_text = src_path.read_text(encoding="utf-8", errors="ignore")
        refs = [r.strip(" `") for r in re.split(r" and ", sec) if r.strip()]
        for ref in refs:
            if ref.startswith("#") and ref not in src_text:
                errors.append(f"{rule}: missing heading '{ref}' in {src}")

    if errors:
        print("quick-reference drift check failed:")
        for err in errors:
            print(f"- {err}")
        return 1

    print(f"quick-reference drift check passed ({len(rows)} entries)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
