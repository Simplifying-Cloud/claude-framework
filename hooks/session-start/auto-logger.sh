#!/bin/bash

# Claude Session Auto-Logger
# Automatically captures and logs all Claude Code sessions

# Configuration
CLAUDE_DIR="$HOME/.claude"
LOGS_DIR="$CLAUDE_DIR/logs/sessions"
ANALYTICS_DIR="$CLAUDE_DIR/analytics"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SESSION_ID="session_${TIMESTAMP}_$$"
LOG_FILE="$LOGS_DIR/${SESSION_ID}.log"

# Read JSON input from stdin if available
if [ ! -t 0 ]; then
    HOOK_INPUT=$(cat)
fi

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Create directories if needed
mkdir -p "$LOGS_DIR"
mkdir -p "$ANALYTICS_DIR"

# Initialize session log
cat > "$LOG_FILE" << EOF
{
  "session_id": "$SESSION_ID",
  "start_time": "$(date -Iseconds)",
  "user": "$USER",
  "hostname": "$(hostname)",
  "working_directory": "$(pwd)",
  "environment": {
    "claude_home": "$CLAUDE_DIR",
    "shell": "$SHELL",
    "term": "$TERM"
  },
  "operations": []
}
EOF

# Set environment variable for Claude to use
export CLAUDE_SESSION_LOG="$LOG_FILE"
export CLAUDE_SESSION_ID="$SESSION_ID"
export CLAUDE_AUTO_LOGGING="enabled"

# Create session marker
echo "$SESSION_ID" > "$CLAUDE_DIR/.current_session"
echo "$LOG_FILE" > "$CLAUDE_DIR/.current_log"

# Log session start (to stderr so it doesn't interfere with hook output)
echo -e "${BLUE}🔵 Session logging initialized${NC}" >&2
echo -e "Session ID: ${GREEN}$SESSION_ID${NC}" >&2
echo -e "Log file: $LOG_FILE" >&2

# Export functions for Claude to use
export -f log_operation
export -f log_tool_use

# Function to log operations (can be called by Claude)
log_operation() {
    local operation_type="$1"
    local details="$2"
    local timestamp=$(date -Iseconds)
    
    # Append operation to log
    jq --arg type "$operation_type" \
       --arg details "$details" \
       --arg time "$timestamp" \
       '.operations += [{"type": $type, "details": $details, "timestamp": $time}]' \
       "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
}

# Function to log tool usage
log_tool_use() {
    local tool="$1"
    local params="$2"
    log_operation "tool_use" "{\"tool\": \"$tool\", \"params\": $params}"
}

echo -e "${GREEN}✓ Auto-logging active for this session${NC}"