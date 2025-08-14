#!/bin/bash

# Tool Use Log Interceptor
# Captures tool usage for performance tracking

# Get current session info
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
LOG_FILE="${CLAUDE_SESSION_LOG:-}"

# Tool information
TOOL_NAME="${1:-unknown}"
TOOL_PARAMS="${2:-}"
TIMESTAMP=$(date -Iseconds)

# Only log if auto-logging is enabled
if [ "$CLAUDE_AUTO_LOGGING" = "enabled" ] && [ -f "$LOG_FILE" ]; then
    # Log tool use
    if command -v jq &> /dev/null; then
        jq --arg tool "$TOOL_NAME" \
           --arg params "$TOOL_PARAMS" \
           --arg time "$TIMESTAMP" \
           '.operations += [{"type": "tool_use", "tool": $tool, "params": $params, "timestamp": $time}]' \
           "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE" 2>/dev/null || true
    else
        # Fallback: append to log
        echo "[$TIMESTAMP] TOOL: $TOOL_NAME - $TOOL_PARAMS" >> "$LOG_FILE.txt"
    fi
fi

# Don't interfere with tool execution
exit 0