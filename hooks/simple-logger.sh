#!/bin/bash

# Simple Session Logger for Claude Code
# Logs tool usage to track performance

CLAUDE_DIR="$HOME/.claude"
LOGS_DIR="$CLAUDE_DIR/logs/sessions"
ANALYTICS_DIR="$CLAUDE_DIR/analytics"
CURRENT_LOG="$LOGS_DIR/current_session.log"

# Create directories if needed
mkdir -p "$LOGS_DIR" "$ANALYTICS_DIR"

# Read hook input from stdin
if [ ! -t 0 ]; then
    INPUT=$(cat)
    
    # Extract event type from JSON if possible
    if command -v jq &> /dev/null && [ -n "$INPUT" ]; then
        EVENT_TYPE=$(echo "$INPUT" | jq -r '.event // "unknown"' 2>/dev/null || echo "tool_use")
        TOOL_NAME=$(echo "$INPUT" | jq -r '.tool // "unknown"' 2>/dev/null || echo "unknown")
        TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
        
        # Log the event
        echo "[$TIMESTAMP] $EVENT_TYPE: $TOOL_NAME" >> "$CURRENT_LOG"
        
        # If it's a Stop event, analyze the session
        if [ "$EVENT_TYPE" = "Stop" ] || [ "$1" = "analyze" ]; then
            # Count operations
            if [ -f "$CURRENT_LOG" ]; then
                OPERATIONS=$(wc -l < "$CURRENT_LOG")
                TOOLS=$(cut -d: -f2 "$CURRENT_LOG" | sort -u | wc -l)
                
                # Simple performance score
                SCORE=$((50 + OPERATIONS + TOOLS * 5))
                [ $SCORE -gt 100 ] && SCORE=100
                
                # Append to sessions CSV
                SESSIONS_FILE="$ANALYTICS_DIR/sessions.csv"
                if [ ! -f "$SESSIONS_FILE" ]; then
                    echo "timestamp,session_id,duration,operations,tools_used,parallel_rate,performance_score" > "$SESSIONS_FILE"
                fi
                
                echo "$(date -Iseconds),current,N/A,$OPERATIONS,$TOOLS,70,$SCORE" >> "$SESSIONS_FILE"
                
                # Archive current log
                ARCHIVE_NAME="$LOGS_DIR/session_$(date +%Y%m%d_%H%M%S).log"
                mv "$CURRENT_LOG" "$ARCHIVE_NAME"
                
                # Output summary to stderr
                echo "Session complete: $OPERATIONS operations, $TOOLS tools, score: $SCORE/100" >&2
            fi
        fi
    else
        # Fallback: just log timestamp
        echo "$(date +'%Y-%m-%d %H:%M:%S') - Event logged" >> "$CURRENT_LOG"
    fi
fi

# Always exit successfully
exit 0