#!/bin/bash

# Script to switch between Claude execution modes

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check for mode argument
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 [safe|balanced|extreme|auto]"
    echo ""
    echo "Modes:"
    echo "  safe     - Maximum safety, minimal parallelization (3-5 ops)"
    echo "  balanced - Optimal balance of speed and safety (5-10 ops)"
    echo "  extreme  - Maximum speed, minimal safety (15-30 ops)"
    echo "  auto     - Automatic mode selection based on context"
    exit 1
fi

MODE="$1"
PREVIOUS_MODE="${CLAUDE_MODE:-balanced}"

# Validate mode
case "$MODE" in
    safe|balanced|extreme|auto)
        ;;
    *)
        echo -e "${RED}Error: Invalid mode '$MODE'${NC}"
        echo "Valid modes: safe, balanced, extreme, auto"
        exit 1
        ;;
esac

# Confirm extreme mode
if [[ "$MODE" == "extreme" ]]; then
    echo -e "${RED}⚠️  WARNING: Extreme Mode Selected${NC}"
    echo ""
    echo "This mode has:"
    echo "  • No automatic rollback"
    echo "  • Potential API violations"  
    echo "  • Resource exhaustion risk"
    echo "  • Limited error recovery"
    echo ""
    read -p "Are you sure you want to enable extreme mode? (yes/no): " confirm
    if [[ "$confirm" != "yes" ]]; then
        echo "Mode switch cancelled"
        exit 0
    fi
fi

# Update configuration
echo -e "${YELLOW}Switching from $PREVIOUS_MODE to $MODE mode...${NC}"

# Export for current session
export CLAUDE_MODE="$MODE"
export CLAUDE_MODE_SOURCE="manual"

# Update persistent configuration if .clauderc exists
CLAUDERC="$HOME/.clauderc"
if [[ -f "$CLAUDERC" ]]; then
    # Remove old CLAUDE_MODE line if exists
    sed -i '/^export CLAUDE_MODE=/d' "$CLAUDERC" 2>/dev/null || true
    # Add new mode
    echo "export CLAUDE_MODE=$MODE" >> "$CLAUDERC"
    echo -e "${GREEN}✓${NC} Updated $CLAUDERC"
else
    # Create .clauderc with mode setting
    echo "#!/bin/bash" > "$CLAUDERC"
    echo "# Claude Framework Configuration" >> "$CLAUDERC"
    echo "export CLAUDE_MODE=$MODE" >> "$CLAUDERC"
    echo -e "${GREEN}✓${NC} Created $CLAUDERC"
fi

# Display mode information
echo ""
case "$MODE" in
    safe)
        echo -e "${GREEN}🛡️  SAFE MODE ACTIVATED${NC}"
        echo "• Maximum validation and safety checks"
        echo "• 3-5 parallel operations maximum"
        echo "• Automatic rollback on failures"
        echo "• Full audit logging enabled"
        echo "• Best for: Production, critical operations"
        ;;
    balanced)
        echo -e "${BLUE}⚖️  BALANCED MODE ACTIVATED${NC}"
        echo "• Intelligent parallelization"
        echo "• 5-10 adaptive parallel operations"
        echo "• Smart error recovery"
        echo "• Rate limit compliance"
        echo "• Best for: Development, standard operations"
        ;;
    extreme)
        echo -e "${RED}⚡ EXTREME MODE ACTIVATED${NC}"
        echo "• Maximum parallelization"
        echo "• 15-30 aggressive parallel operations"
        echo "• Minimal safety checks"
        echo "• Manual error recovery required"
        echo "• Best for: Benchmarking, bulk operations"
        ;;
    auto)
        echo -e "${YELLOW}🤖 AUTO MODE ACTIVATED${NC}"
        echo "• Context-aware mode selection"
        echo "• Automatic safety detection"
        echo "• Dynamic switching based on task"
        echo "• Optimal mode for each operation"
        ;;
esac

# Log mode switch
LOG_FILE="$HOME/.claude/logs/mode-switches.log"
mkdir -p "$(dirname "$LOG_FILE")"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Switched from $PREVIOUS_MODE to $MODE" >> "$LOG_FILE"

# Update mode counter
case "$MODE" in
    safe)
        export SAFE_MODE_COUNT=$((${SAFE_MODE_COUNT:-0} + 1))
        ;;
    balanced)
        export BALANCED_MODE_COUNT=$((${BALANCED_MODE_COUNT:-0} + 1))
        ;;
    extreme)
        export EXTREME_MODE_COUNT=$((${EXTREME_MODE_COUNT:-0} + 1))
        ;;
esac

echo ""
echo -e "${GREEN}Mode switch complete!${NC}"
echo "To make this permanent, add to your shell profile:"
echo "  source $CLAUDERC"