#!/bin/bash
# Auto-analyze Claude Code session on exit
# Add to your shell RC file: trap ~/.claude/hooks/post-session/auto-analyze.sh EXIT

# Only run if last command was claude
last_cmd=$(history 1 | sed 's/^[ ]*[0-9]*[ ]*//')
if [[ ! "$last_cmd" =~ claude ]]; then
    exit 0
fi

# Configuration
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
ANALYZER="$CLAUDE_HOME/hooks/post-session/performance-analyzer.sh"
SESSION_LOG="/tmp/claude-session-$(date +%Y%m%d).log"

# Check if analyzer exists
if [[ ! -f "$ANALYZER" ]]; then
    echo "Performance analyzer not found. Skipping analysis."
    exit 0
fi

# Run analysis
echo "🔍 Analyzing Claude Code session performance..."
"$ANALYZER" "$SESSION_LOG" 2>/dev/null

# Show summary
echo "📊 Performance Summary:"
tail -3 "$CLAUDE_HOME/analytics/performance_*.md" 2>/dev/null | grep -E "Score:|Parallelization"

# Offer to view full report
read -p "View full report? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    less "$CLAUDE_HOME/analytics/performance_*.md"
fi