#!/bin/bash
# AI-Generated Code Security Validation Script
# Implements verification gates from AI-Assisted Coding Security framework
# Enhanced with DZone OWASP LLM Top 10 prompt injection defenses

set -euo pipefail

ERRORS=0
WARNINGS=0

echo "🔍 AI-Generated Code Security Validation"
echo "========================================"
echo ""

# Section 10.1: Pre-commit checks
echo "📋 Layer 1: Pre-commit validation..."

# Check for secrets
echo "  → Scanning for secrets..."
if trufflehog filesystem . --json --only-verified > /tmp/secrets-report.json 2>&1; then
    SECRET_COUNT=$(jq length /tmp/secrets-report.json 2>/dev/null || echo 0)
    if [ "$SECRET_COUNT" -gt 0 ]; then
        echo "  ❌ Found $SECRET_COUNT verified secrets - BLOCKED"
        ((ERRORS++))
    else
        echo "  ✅ No secrets detected"
    fi
else
    echo "  ⚠️  TruffleHog scan failed"
    ((WARNINGS++))
fi

# Section 10.3: Static analysis
echo ""
echo "📋 Layer 3: CI/CD Pipeline checks..."

# Semgrep security rules
echo "  → Running Semgrep security rules..."
if semgrep --config=auto --error . --json > /tmp/semgrep-report.json 2>&1; then
    SEMGREP_ERRORS=$(jq '[.results[] | select(.extra.severity == "ERROR")] | length' /tmp/semgrep-report.json 2>/dev/null || echo 0)
    if [ "$SEMGREP_ERRORS" -gt 0 ]; then
        echo "  ❌ Found $SEMGREP_ERRORS critical Semgrep findings - BLOCKED"
        ((ERRORS++))
    else
        echo "  ✅ Semgrep checks passed"
    fi
else
    echo "  ⚠️  Semgrep scan failed"
    ((WARNINGS++))
fi

# Python-specific checks
if [ -f requirements.txt ] || [ -f pyproject.toml ]; then
    echo "  → Scanning Python dependencies..."

    # Safety check
    if safety check --json > /tmp/safety-report.json 2>&1; then
        echo "  ✅ No known vulnerabilities in dependencies"
    else
        VULN_COUNT=$(jq '[.vulnerabilities[]] | length' /tmp/safety-report.json 2>/dev/null || echo "unknown")
        echo "  ❌ Found $VULN_COUNT vulnerable dependencies - REVIEW REQUIRED"
        ((WARNINGS++))
    fi

    # Bandit security checks
    if bandit -r . -ll -f json -o /tmp/bandit-report.json 2>&1; then
        echo "  ✅ Bandit security checks passed"
    else
        BANDIT_HIGH=$(jq '[.results[] | select(.issue_severity == "HIGH")] | length' /tmp/bandit-report.json 2>/dev/null || echo 0)
        if [ "$BANDIT_HIGH" -gt 0 ]; then
            echo "  ❌ Found $BANDIT_HIGH high-severity Bandit findings - BLOCKED"
            ((ERRORS++))
        fi
    fi
fi

# Section 5.3: Output sanitization checks
echo ""
echo "📋 Critical pattern checks (Section 5.3)..."

# Check for shell injection vectors
echo "  → Checking for shell=True..."
if grep -r "shell=True" --include="*.py" . 2>/dev/null; then
    echo "  ❌ CRITICAL: shell=True detected - BLOCKED"
    echo "     Use subprocess with argument lists instead"
    ((ERRORS++))
else
    echo "  ✅ No shell=True found"
fi

# Check for SQL concatenation
echo "  → Checking for SQL string concatenation..."
if grep -rE "\.execute\(f\"|\.execute\(\".*\{|executemany\(f\"" --include="*.py" . 2>/dev/null; then
    echo "  ❌ CRITICAL: SQL string concatenation detected - BLOCKED"
    echo "     Use parameterized queries instead"
    ((ERRORS++))
else
    echo "  ✅ No SQL concatenation found"
fi

# Check for dangerous functions
echo "  → Checking for dangerous functions..."
if grep -rE "eval\(|exec\(|__import__\(" --include="*.py" . 2>/dev/null; then
    echo "  ⚠️  WARNING: eval/exec/__import__ detected - REVIEW REQUIRED"
    echo "     These functions can execute arbitrary code"
    ((WARNINGS++))
else
    echo "  ✅ No dangerous functions found"
fi

# Check for pickle usage (deserialization risk)
echo "  → Checking for insecure deserialization..."
if grep -rE "pickle\.load|pickle\.loads|yaml\.load\(" --include="*.py" . 2>/dev/null; then
    echo "  ⚠️  WARNING: Insecure deserialization detected - REVIEW REQUIRED"
    echo "     Use safe_load for YAML, avoid pickle for untrusted data"
    ((WARNINGS++))
else
    echo "  ✅ No insecure deserialization found"
fi

# Section 6: Check for resource limits
echo ""
echo "📋 Agent resource limit checks (Section 6)..."

echo "  → Checking for timeout configurations..."
if grep -rE "timeout\s*=|TimeoutError|asyncio\.wait_for" --include="*.py" . >/dev/null 2>&1; then
    echo "  ✅ Timeout handling found"
else
    echo "  ⚠️  No timeout handling detected - ADD for agent code"
    ((WARNINGS++))
fi

# Section 7: Check for prompt injection patterns (ENHANCED)
echo ""
echo "📋 Prompt injection defense checks (Section 7 - OWASP LLM01)..."

echo "  → Checking for unsafe string interpolation in prompts..."
if grep -rE "f\".*\{user|f\".*\{input|prompt.*\+.*user" --include="*.py" . 2>/dev/null; then
    echo "  ⚠️  WARNING: Unsafe prompt construction detected"
    echo "     Treat user input as data, not instructions"
    ((WARNINGS++))
else
    echo "  ✅ No obvious prompt injection vectors found"
fi

# NEW: Check for direct injection patterns in code artifacts
echo "  → Checking for jailbreak patterns in comments/docstrings..."
JAILBREAK_PATTERNS=(
    "ignore previous instructions"
    "ignore all previous"
    "disregard all prior"
    "forget everything"
    "new instructions"
    "system override"
    "admin override"
    "bypass security"
    "disable safeguard"
    "IMPORTANT: ignore"
    "do anything now"
    "DAN mode"
)

JAILBREAK_FOUND=0
for pattern in "${JAILBREAK_PATTERNS[@]}"; do
    if grep -riE "$pattern" --include="*.py" --include="*.md" --include="*.txt" --include="*.rst" . 2>/dev/null | grep -v "ai-security-check.sh" | grep -q .; then
        echo "  ⚠️  WARNING: Potential jailbreak pattern detected: '$pattern'"
        ((WARNINGS++))
        JAILBREAK_FOUND=1
    fi
done

if [ $JAILBREAK_FOUND -eq 0 ]; then
    echo "  ✅ No jailbreak patterns found"
fi

# NEW: Check for hidden unicode/steganographic injection
echo "  → Checking for hidden unicode characters..."
# Zero-width characters: U+200B (ZWSP), U+200C (ZWNJ), U+200D (ZWJ), U+FEFF (BOM), U+00A0 (NBSP)
if grep -rP '[\x{200B}\x{200C}\x{200D}\x{FEFF}\x{00A0}]' --include="*.py" --include="*.md" --include="*.txt" . 2>/dev/null | grep -q .; then
    echo "  ⚠️  WARNING: Hidden unicode characters detected - REVIEW REQUIRED"
    echo "     These can hide malicious instructions (zero-width spaces, etc.)"
    echo "     Run: grep -rP '[\x{200B}-\x{200D}\x{FEFF}\x{00A0}]' . to locate"
    ((WARNINGS++))
else
    echo "  ✅ No hidden unicode found"
fi

# NEW: Check for indirect injection vectors in external data handling
echo "  → Checking for unsafe external content processing..."
UNSAFE_PATTERNS=(
    "\.read\(\).*prompt"
    "requests\.get.*prompt"
    "open\(.*\).*system"
    "pdf.*extract.*prompt"
    "BeautifulSoup.*prompt"
)

UNSAFE_FOUND=0
for pattern in "${UNSAFE_PATTERNS[@]}"; do
    if grep -rE "$pattern" --include="*.py" . 2>/dev/null | grep -q .; then
        if [ $UNSAFE_FOUND -eq 0 ]; then
            echo "  ⚠️  WARNING: Potential indirect injection vector detected"
            echo "     External content directly used in prompts without sanitization"
            UNSAFE_FOUND=1
            ((WARNINGS++))
        fi
    fi
done

if [ $UNSAFE_FOUND -eq 0 ]; then
    echo "  ✅ No unsafe external content processing found"
fi

# NEW: Check for privilege escalation patterns in agentic code
echo "  → Checking for privilege escalation risks..."
PRIV_ESC_PATTERNS=(
    "sudo"
    "chmod 777"
    "chown.*root"
    "os\.setuid"
    "os\.setgid"
    "exec.*bash"
    "eval.*subprocess"
)

PRIV_ESC_FOUND=0
for pattern in "${PRIV_ESC_PATTERNS[@]}"; do
    if grep -rE "$pattern" --include="*.py" . 2>/dev/null | grep -v "# Example:" | grep -v "# WRONG" | grep -q .; then
        if [ $PRIV_ESC_FOUND -eq 0 ]; then
            echo "  ⚠️  WARNING: Privilege escalation pattern detected"
            echo "     Review all uses of privileged operations"
            PRIV_ESC_FOUND=1
            ((WARNINGS++))
        fi
    fi
done

if [ $PRIV_ESC_FOUND -eq 0 ]; then
    echo "  ✅ No privilege escalation patterns found"
fi

# NEW: Check for context window manipulation attempts
echo "  → Checking for context manipulation patterns..."
CONTEXT_MANIP=(
    "context.*override"
    "system.*role.*change"
    "forget.*conversation"
    "clear.*history"
    "reset.*context"
)

CONTEXT_FOUND=0
for pattern in "${CONTEXT_MANIP[@]}"; do
    if grep -riE "$pattern" --include="*.py" --include="*.md" . 2>/dev/null | grep -q .; then
        if [ $CONTEXT_FOUND -eq 0 ]; then
            echo "  ⚠️  WARNING: Context manipulation pattern detected"
            echo "     Verify this is legitimate and not an injection attempt"
            CONTEXT_FOUND=1
            ((WARNINGS++))
        fi
    fi
done

if [ $CONTEXT_FOUND -eq 0 ]; then
    echo "  ✅ No context manipulation patterns found"
fi

# Generate summary report
echo ""
echo "========================================"
echo "📊 Security Validation Summary"
echo "========================================"
echo "Critical Errors:   $ERRORS"
echo "Warnings:          $WARNINGS"
echo ""

# Generate detailed reports
if [ -f /tmp/semgrep-report.json ]; then
    echo "📄 Detailed reports generated:"
    echo "   - Semgrep:     /tmp/semgrep-report.json"
fi
if [ -f /tmp/secrets-report.json ]; then
    echo "   - Secrets:     /tmp/secrets-report.json"
fi
if [ -f /tmp/safety-report.json ]; then
    echo "   - Safety:      /tmp/safety-report.json"
fi
if [ -f /tmp/bandit-report.json ]; then
    echo "   - Bandit:      /tmp/bandit-report.json"
fi

echo ""

# Final decision
if [ $ERRORS -gt 0 ]; then
    echo "❌ VALIDATION FAILED - $ERRORS critical issues must be fixed"
    echo ""
    echo "Common fixes:"
    echo "  • Replace shell=True with subprocess.run(['cmd', 'arg1', 'arg2'])"
    echo "  • Use parameterized queries: cursor.execute('SELECT * FROM users WHERE id = ?', (user_id,))"
    echo "  • Remove hardcoded secrets, use environment variables or secret managers"
    echo "  • Replace eval/exec with safer alternatives"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo "⚠️  VALIDATION PASSED WITH WARNINGS - $WARNINGS items need review"
    echo ""
    echo "Recommendations:"
    echo "  • Review flagged patterns in Layer 2 (Code Review)"
    echo "  • Add timeout handling for agent operations"
    echo "  • Sanitize user input before using in prompts"
    echo "  • Consider adding rate limiting for API calls"
    echo "  • Validate external content before using in AI prompts"
    echo "  • Remove any hidden unicode characters found"
    exit 0
else
    echo "✅ VALIDATION PASSED - All security checks successful"
    exit 0
fi
