#!/usr/bin/env python3
# AI-Generated: maintenance helper script
"""
Regenerate the Pull on Demand block in rules/daily-navigation.md.

Rules:
- Collect files referenced in the first five sections:
  Session Start, Coding, Benchmarking, Commit, Session End
- List every file under rules/ recursively that is not covered above
  as "<path> [REFERENCE]" under Pull on Demand.
"""

from __future__ import annotations

from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[3]
RULES_DIR = ROOT / "rules"
NAV_PATH = RULES_DIR / "daily-navigation.md"
PULL_HEADING = "## Pull on Demand (reference only — do not maintain proactively)"
WORKFLOW_HEADINGS = {
    "## Session Start",
    "## Coding",
    "## Benchmarking",
    "## Commit",
    "## Session End",
}


def collect_covered_rules(lines: list[str]) -> set[str]:
    covered: set[str] = set()
    in_workflow = False
    for line in lines:
        if line.startswith("## "):
            in_workflow = line in WORKFLOW_HEADINGS
        if not in_workflow:
            continue
        for match in re.findall(r"rules/[A-Za-z0-9_./+\\-]+", line):
            covered.add(match)
    return covered


def main() -> None:
    text = NAV_PATH.read_text(encoding="utf-8")
    lines = text.splitlines()

    covered = collect_covered_rules(lines)

    all_rule_files = sorted(
        str(p.relative_to(ROOT))
        for p in RULES_DIR.rglob("*")
        if p.is_file()
    )
    generated_refs = [f"{p} [REFERENCE]" for p in all_rule_files if p not in covered]

    start = lines.index(PULL_HEADING)
    # Keep heading + one optional audit-control line if present
    preserved = [lines[start]]
    next_idx = start + 1
    if next_idx < len(lines) and lines[next_idx].startswith("Quarterly spot-audit required:"):
        preserved.append(lines[next_idx])
        next_idx += 1

    new_lines = lines[:start] + preserved + generated_refs
    NAV_PATH.write_text("\n".join(new_lines) + "\n", encoding="utf-8")

    print(f"covered_entries={len(covered)}")
    print(f"generated_references={len(generated_refs)}")


if __name__ == "__main__":
    main()
