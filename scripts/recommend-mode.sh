#!/bin/bash

# Script to recommend the best Claude mode for a given task

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check for task description
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <task-description>"
    echo ""
    echo "Examples:"
    echo "  $0 'migrate production database'"
    echo "  $0 'analyze codebase structure'"
    echo "  $0 'process 10000 log files'"
    exit 1
fi

TASK="$1"
TASK_LOWER=$(echo "$TASK" | tr '[:upper:]' '[:lower:]')

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}     Claude Mode Recommendation Engine      ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Task:${NC} $TASK"
echo ""

# Initialize scores
SAFE_SCORE=0
BALANCED_SCORE=50  # Default bias toward balanced
EXTREME_SCORE=0

# Analyze task for safe mode indicators
if [[ "$TASK_LOWER" == *"production"* ]]; then
    SAFE_SCORE=$((SAFE_SCORE + 30))
    echo "• Detected: 'production' → +30 safe"
fi

if [[ "$TASK_LOWER" == *"database"* ]]; then
    SAFE_SCORE=$((SAFE_SCORE + 25))
    echo "• Detected: 'database' → +25 safe"
fi

if [[ "$TASK_LOWER" == *"migration"* || "$TASK_LOWER" == *"migrate"* ]]; then
    SAFE_SCORE=$((SAFE_SCORE + 25))
    echo "• Detected: 'migration' → +25 safe"
fi

if [[ "$TASK_LOWER" == *"critical"* || "$TASK_LOWER" == *"important"* ]]; then
    SAFE_SCORE=$((SAFE_SCORE + 30))
    echo "• Detected: 'critical/important' → +30 safe"
fi

if [[ "$TASK_LOWER" == *"payment"* || "$TASK_LOWER" == *"financial"* ]]; then
    SAFE_SCORE=$((SAFE_SCORE + 40))
    echo "• Detected: 'payment/financial' → +40 safe"
fi

if [[ "$TASK_LOWER" == *"security"* || "$TASK_LOWER" == *"credential"* ]]; then
    SAFE_SCORE=$((SAFE_SCORE + 35))
    echo "• Detected: 'security/credential' → +35 safe"
fi

if [[ "$TASK_LOWER" == *"compliance"* || "$TASK_LOWER" == *"audit"* ]]; then
    SAFE_SCORE=$((SAFE_SCORE + 30))
    echo "• Detected: 'compliance/audit' → +30 safe"
fi

# Analyze task for extreme mode indicators
if [[ "$TASK_LOWER" == *"bulk"* || "$TASK_LOWER" == *"batch"* ]]; then
    EXTREME_SCORE=$((EXTREME_SCORE + 30))
    echo "• Detected: 'bulk/batch' → +30 extreme"
fi

if [[ "$TASK_LOWER" == *"benchmark"* || "$TASK_LOWER" == *"performance"* ]]; then
    EXTREME_SCORE=$((EXTREME_SCORE + 35))
    echo "• Detected: 'benchmark/performance' → +35 extreme"
fi

if [[ "$TASK_LOWER" == *"test"* && "$TASK_LOWER" != *"testing"* ]]; then
    EXTREME_SCORE=$((EXTREME_SCORE + 20))
    echo "• Detected: 'test' → +20 extreme"
fi

if [[ "$TASK_LOWER" == *"prototype"* || "$TASK_LOWER" == *"poc"* ]]; then
    EXTREME_SCORE=$((EXTREME_SCORE + 25))
    echo "• Detected: 'prototype/poc' → +25 extreme"
fi

if [[ "$TASK_LOWER" =~ [0-9]{4,} ]]; then
    EXTREME_SCORE=$((EXTREME_SCORE + 25))
    echo "• Detected: large numbers → +25 extreme"
fi

if [[ "$TASK_LOWER" == *"non-critical"* || "$TASK_LOWER" == *"temporary"* ]]; then
    EXTREME_SCORE=$((EXTREME_SCORE + 20))
    echo "• Detected: 'non-critical/temporary' → +20 extreme"
fi

# Analyze task for balanced mode indicators
if [[ "$TASK_LOWER" == *"develop"* || "$TASK_LOWER" == *"code"* ]]; then
    BALANCED_SCORE=$((BALANCED_SCORE + 20))
    echo "• Detected: 'develop/code' → +20 balanced"
fi

if [[ "$TASK_LOWER" == *"analyze"* || "$TASK_LOWER" == *"analysis"* ]]; then
    BALANCED_SCORE=$((BALANCED_SCORE + 25))
    echo "• Detected: 'analyze/analysis' → +25 balanced"
fi

if [[ "$TASK_LOWER" == *"testing"* || "$TASK_LOWER" == *"validation"* ]]; then
    BALANCED_SCORE=$((BALANCED_SCORE + 20))
    echo "• Detected: 'testing/validation' → +20 balanced"
fi

if [[ "$TASK_LOWER" == *"deploy"* && "$TASK_LOWER" != *"production"* ]]; then
    BALANCED_SCORE=$((BALANCED_SCORE + 15))
    echo "• Detected: 'deploy' (non-prod) → +15 balanced"
fi

if [[ "$TASK_LOWER" == *"refactor"* || "$TASK_LOWER" == *"optimize"* ]]; then
    BALANCED_SCORE=$((BALANCED_SCORE + 20))
    echo "• Detected: 'refactor/optimize' → +20 balanced"
fi

# Calculate recommendation
echo ""
echo -e "${YELLOW}Mode Scores:${NC}"
echo "• Safe Mode:     $SAFE_SCORE"
echo "• Balanced Mode: $BALANCED_SCORE"
echo "• Extreme Mode:  $EXTREME_SCORE"
echo ""

# Determine winner
RECOMMENDED_MODE="balanced"
HIGHEST_SCORE=$BALANCED_SCORE

if [[ $SAFE_SCORE -gt $HIGHEST_SCORE ]]; then
    RECOMMENDED_MODE="safe"
    HIGHEST_SCORE=$SAFE_SCORE
fi

if [[ $EXTREME_SCORE -gt $HIGHEST_SCORE ]]; then
    RECOMMENDED_MODE="extreme"
    HIGHEST_SCORE=$EXTREME_SCORE
fi

# Display recommendation
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}Recommendation:${NC}"
echo ""

case "$RECOMMENDED_MODE" in
    safe)
        echo -e "${GREEN}🛡️  USE SAFE MODE${NC}"
        echo ""
        echo "Reasoning:"
        echo "• Task involves critical operations"
        echo "• High risk of data corruption"
        echo "• Requires maximum validation"
        echo ""
        echo "Configuration:"
        echo "• 3-5 parallel operations"
        echo "• Full rollback capability"
        echo "• Complete audit trail"
        ;;
    balanced)
        echo -e "${BLUE}⚖️  USE BALANCED MODE${NC}"
        echo ""
        echo "Reasoning:"
        echo "• Standard development task"
        echo "• Good speed/safety balance needed"
        echo "• Moderate risk tolerance"
        echo ""
        echo "Configuration:"
        echo "• 5-10 adaptive operations"
        echo "• Smart error recovery"
        echo "• Rate limit compliance"
        ;;
    extreme)
        echo -e "${RED}⚡ USE EXTREME MODE${NC}"
        echo ""
        echo "Reasoning:"
        echo "• Bulk or batch operation"
        echo "• Speed is primary concern"
        echo "• Low risk of data loss"
        echo ""
        echo "Configuration:"
        echo "• 15-30 parallel operations"
        echo "• Minimal validation"
        echo "• Manual error handling"
        echo ""
        echo -e "${YELLOW}⚠️  Warning:${NC} Extreme mode has risks!"
        ;;
esac

echo ""
echo "To apply this mode:"
echo -e "${YELLOW}./scripts/switch-mode.sh $RECOMMENDED_MODE${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════${NC}"