#!/bin/bash

# Script to check the current Claude execution mode

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get current mode
CURRENT_MODE="${CLAUDE_MODE:-balanced}"
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
CURRENT_ENV="${ENVIRONMENT:-development}"

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}     Claude Framework Mode Status          ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Display current mode
case "$CURRENT_MODE" in
    safe)
        echo -e "Current Mode: ${GREEN}🛡️  SAFE${NC}"
        echo "Configuration: configurations/SAFE_MODE.md"
        echo "Parallel Ops: 3-5 maximum"
        echo "Safety Level: Maximum"
        echo "Performance: 1.5-2x"
        ;;
    balanced)
        echo -e "Current Mode: ${BLUE}⚖️  BALANCED${NC}"
        echo "Configuration: configurations/BALANCED_MODE.md"
        echo "Parallel Ops: 5-10 adaptive"
        echo "Safety Level: Intelligent"
        echo "Performance: 2-3x"
        ;;
    extreme)
        echo -e "Current Mode: ${RED}⚡ EXTREME${NC}"
        echo "Configuration: configurations/EXTREME_MODE.md"
        echo "Parallel Ops: 15-30 aggressive"
        echo "Safety Level: Minimal"
        echo "Performance: 5-10x (theoretical)"
        ;;
    *)
        echo -e "Current Mode: ${YELLOW}? UNKNOWN${NC}"
        echo "Falling back to: BALANCED"
        ;;
esac

echo ""
echo -e "${YELLOW}Context Information:${NC}"
echo "• Git Branch: $CURRENT_BRANCH"
echo "• Environment: $CURRENT_ENV"
echo "• Mode Source: ${CLAUDE_MODE_SOURCE:-automatic}"

# Check for mode indicators
echo ""
echo -e "${YELLOW}Auto-Detection Indicators:${NC}"

if [[ "$CURRENT_BRANCH" == "main" || "$CURRENT_BRANCH" == "master" || "$CURRENT_BRANCH" == "production" ]]; then
    echo -e "• Branch suggests: ${GREEN}SAFE mode${NC}"
elif [[ "$CURRENT_BRANCH" == *"feature/"* || "$CURRENT_BRANCH" == "develop" ]]; then
    echo -e "• Branch suggests: ${BLUE}BALANCED mode${NC}"
fi

if [[ "$CURRENT_ENV" == "PROD" || "$CURRENT_ENV" == "PRODUCTION" ]]; then
    echo -e "• Environment suggests: ${GREEN}SAFE mode${NC}"
elif [[ "$CURRENT_ENV" == "DEV" || "$CURRENT_ENV" == "DEVELOPMENT" ]]; then
    echo -e "• Environment suggests: ${BLUE}BALANCED mode${NC}"
fi

echo ""
echo -e "${YELLOW}Mode Statistics:${NC}"
echo "• Safe Mode Uses: ${SAFE_MODE_COUNT:-0}"
echo "• Balanced Mode Uses: ${BALANCED_MODE_COUNT:-0}"
echo "• Extreme Mode Uses: ${EXTREME_MODE_COUNT:-0}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════════${NC}"