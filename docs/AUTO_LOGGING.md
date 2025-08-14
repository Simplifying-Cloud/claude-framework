# Automatic Session Logging & Performance Tracking

## Overview

The Claude Framework now includes **automatic session logging** that captures all your Claude Code sessions without any manual intervention. Performance metrics are automatically calculated and stored for analysis.

## How It Works

### 1. Automatic Session Start
When you begin a Claude Code session, the framework automatically:
- Creates a unique session ID
- Initializes a session log file
- Sets environment variables for tracking
- Starts capturing operations

### 2. During Your Session
The framework silently logs:
- Tool usage (Read, Write, Bash, etc.)
- Operation types and parameters
- Timestamps for all activities
- Parallel vs sequential execution patterns

### 3. Session End
When your session completes, the framework automatically:
- Analyzes the session log
- Calculates performance metrics
- Updates aggregate statistics
- Archives the session log
- Displays a performance summary

## Files and Locations

### Log Files
- **Active logs**: `~/.claude/logs/sessions/`
- **Archived logs**: `~/.claude/logs/archives/` (compressed)
- **Analytics data**: `~/.claude/analytics/`

### Hook Scripts
- **Session start**: `~/.claude/hooks/session-start/auto-logger.sh`
- **Session end**: `~/.claude/hooks/session-end/auto-analyzer.sh`
- **Tool logging**: `~/.claude/hooks/tool-use/log-interceptor.sh`

### Data Files
- **Session history**: `~/.claude/analytics/sessions.csv`
- **Aggregate metrics**: `~/.claude/analytics/metrics.json`

## Metrics Tracked

### Per Session
- **Session ID**: Unique identifier
- **Duration**: Session length
- **Operations**: Total operations performed
- **Tools Used**: Number of unique tools
- **Parallel Rate**: Percentage of parallel operations
- **Performance Score**: 0-100 overall score

### Aggregate Metrics
- **Total Sessions**: Count of all sessions
- **Average Operations**: Mean operations per session
- **Average Parallel Rate**: Mean parallelization percentage
- **Average Performance Score**: Overall performance trend

## Performance Scoring

Performance scores are calculated based on:
- **Parallelization** (0-50 points): Higher parallel execution = better score
- **Operation Volume** (0-25 points): 10+ operations adds bonus points
- **Tool Diversity** (0-25 points): 5+ different tools adds bonus points

### Score Interpretation
- **85-100**: Excellent performance! ✨
- **70-84**: Good performance ✓
- **Below 70**: Room for improvement ⚠️

## Viewing Your Data

### Performance Dashboard
```bash
~/.claude/scripts/performance-dashboard.sh
```

Options:
1. **Summary Dashboard** - Overall metrics
2. **Recent Sessions** - Last 5 sessions
3. **Performance Tips** - Optimization suggestions
4. **Benchmarks** - Target metrics
5. **Generate Report** - Export detailed report

### Quick Check
After each session, you'll see:
```
═══════════════════════════════════════
    Session Analysis Complete
═══════════════════════════════════════
Session ID: session_20250114_093042_12345
Operations: 25
Tools Used: 8
Parallel Rate: 75%
Performance Score: 88/100
✓ Excellent performance!
```

## Privacy & Control

### Data Storage
- All logs are stored locally in `~/.claude/`
- No data is sent externally
- Logs are compressed after analysis

### Disable Logging
To temporarily disable auto-logging:
```bash
export CLAUDE_AUTO_LOGGING="disabled"
```

### Clear Data
To reset all performance data:
```bash
rm -rf ~/.claude/analytics/*
rm -rf ~/.claude/logs/sessions/*
rm -rf ~/.claude/logs/archives/*
```

## Tips for Better Scores

1. **Batch Operations**: Read/write multiple files in one go
2. **Use Agents**: Leverage specialized agents for tasks
3. **Parallel Execution**: Run independent operations simultaneously
4. **Tool Diversity**: Use appropriate tools for each task
5. **MultiEdit**: Make multiple edits to same file at once

## Troubleshooting

### No Data Showing?
- Check if hooks are executable: `ls -la ~/.claude/hooks/*/`
- Verify jq is installed: `which jq`
- Check log directory: `ls ~/.claude/logs/sessions/`

### Session Not Logged?
- Ensure hooks are in place
- Check environment: `echo $CLAUDE_AUTO_LOGGING`
- Look for errors in: `~/.claude/logs/`

### Wrong Metrics?
- Metrics improve over time with more sessions
- First few sessions may show placeholder data
- Run 5+ sessions for accurate averages

## Technical Details

### Session Log Format (JSON)
```json
{
  "session_id": "session_20250114_093042_12345",
  "start_time": "2025-01-14T09:30:42Z",
  "user": "username",
  "hostname": "machine",
  "working_directory": "/path/to/project",
  "operations": [
    {
      "type": "tool_use",
      "tool": "Read",
      "params": "file.txt",
      "timestamp": "2025-01-14T09:30:45Z"
    }
  ]
}
```

### Metrics File Format (JSON)
```json
{
  "total_sessions": 10,
  "avg_operations": 22.5,
  "avg_parallel_rate": 72.3,
  "avg_performance_score": 81.7,
  "last_updated": "2025-01-14T10:15:30Z"
}
```

## Integration with Framework

The auto-logging system integrates with:
- **Performance Dashboard**: Displays all metrics
- **Maintenance Script**: Includes performance review
- **Profile System**: Tracks metrics per profile
- **Agent Usage**: Logs agent invocations

---

**Note**: Auto-logging starts with your next Claude Code session. Historical sessions cannot be retroactively analyzed.