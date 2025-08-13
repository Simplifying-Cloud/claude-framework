#!/bin/bash
# Pre-commit hook: Validate code before allowing commits

set -e

echo "🔍 Running pre-commit validation..."

# Check for syntax errors in common languages
check_syntax() {
    local changed_files=$(git diff --cached --name-only)
    
    # Python files
    if echo "$changed_files" | grep -q "\.py$"; then
        echo "Checking Python syntax..."
        for file in $(echo "$changed_files" | grep "\.py$"); do
            python -m py_compile "$file" 2>/dev/null || {
                echo "❌ Python syntax error in $file"
                exit 1
            }
        done
    fi
    
    # JavaScript/TypeScript files
    if echo "$changed_files" | grep -q "\.[jt]sx\?$"; then
        if command -v npx &> /dev/null; then
            echo "Checking JavaScript/TypeScript..."
            npx tsc --noEmit 2>/dev/null || {
                echo "⚠️  TypeScript check failed (non-blocking)"
            }
        fi
    fi
    
    # Go files
    if echo "$changed_files" | grep -q "\.go$"; then
        echo "Checking Go syntax..."
        go vet ./... 2>/dev/null || {
            echo "❌ Go vet found issues"
            exit 1
        }
    fi
}

# Check for sensitive data
check_secrets() {
    local patterns=(
        "password.*=.*['\"]"
        "api[_-]?key.*=.*['\"]"
        "secret.*=.*['\"]"
        "token.*=.*['\"]"
        "AWS[_-]?ACCESS[_-]?KEY"
        "AWS[_-]?SECRET"
        "PRIVATE[_-]?KEY"
    )
    
    echo "Checking for exposed secrets..."
    for pattern in "${patterns[@]}"; do
        if git diff --cached | grep -iE "$pattern" > /dev/null; then
            echo "❌ Potential secret detected! Please review your changes."
            echo "   Pattern matched: $pattern"
            exit 1
        fi
    done
}

# Check file size
check_file_size() {
    local max_size=10485760  # 10MB in bytes
    local changed_files=$(git diff --cached --name-only)
    
    for file in $changed_files; do
        if [ -f "$file" ]; then
            size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
            if [ "$size" -gt "$max_size" ]; then
                echo "❌ File $file exceeds 10MB limit"
                exit 1
            fi
        fi
    done
}

# Run all checks
check_syntax
check_secrets
check_file_size

echo "✅ Pre-commit validation passed!"
exit 0