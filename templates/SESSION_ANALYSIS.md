# Claude Code Session Analysis Template

Use this template to analyze your Claude Code sessions for performance optimization opportunities.

## Manual Analysis Checklist

### 1. Quick Metrics
- [ ] Count total operations performed
- [ ] Count operations executed in parallel (same message)
- [ ] Count operations executed serially (separate messages)
- [ ] Calculate parallelization percentage

### 2. Anti-Pattern Check

#### File Operations
- [ ] Check for multiple Edit calls to same file
  - Found: _____ instances
  - Files affected: _____
  - Should use: MultiEdit with array of edits

#### Directory Operations  
- [ ] Check for sequential mkdir commands
  - Found: _____ instances
  - Should use: `mkdir -p dir1 dir2 dir3`

- [ ] Check for sequential rm commands
  - Found: _____ instances
  - Should use: `rm -f file1 file2 file3`

#### Discovery Patterns
- [ ] Check for Glob/Grep followed by separate Read
  - Found: _____ instances
  - Should: Read files during discovery

#### Git Operations
- [ ] Check for sequential git commands
  - Found: _____ instances
  - Should: Batch in single Bash call

### 3. Performance Scoring

Calculate your session score:

| Metric | Points | Your Score |
|--------|--------|------------|
| Parallelization >70% | 40 | ___ |
| No multiple edits to same file | 20 | ___ |
| Batched directory operations | 10 | ___ |
| Parallel agent usage | 10 | ___ |
| Efficient discovery patterns | 10 | ___ |
| Batched git operations | 10 | ___ |
| **Total** | **100** | **___** |

### 4. Optimization Opportunities

List specific improvements for next session:

1. **Highest Impact**: _____
2. **Quick Win**: _____
3. **Pattern to Avoid**: _____

## Automated Analysis Options

### Option 1: Using Performance Auditor Agent
```bash
# In Claude Code, request analysis
"Please use the performance-auditor agent to analyze our recent session"
```

### Option 2: Using Performance Analyzer Script
```bash
# Run the analyzer on session log
~/.claude/hooks/post-session/performance-analyzer.sh [session-log]

# View generated report
cat ~/.claude/analytics/performance_*.md
```

### Option 3: Quick Command Analysis
```bash
# Count parallel operations (operations in same timestamp)
grep -E "Tool:|Task:" session.log | uniq -c | awk '$1>1 {print}' | wc -l

# Find multiple edits to same file
grep "Edit:.*file_path" session.log | grep -oE '/[^"]+' | sort | uniq -c | sort -rn

# Check parallelization rate
total=$(grep -c "Tool:\|Task:" session.log)
parallel=$(grep -E "Tool:|Task:" session.log | uniq -c | awk '$1>1' | wc -l)
echo "Parallelization: $((parallel*100/total))%"
```

## Tracking Improvements Over Time

Create a simple tracking spreadsheet or use this markdown table:

| Date | Session | Parallel % | Score | Key Learning |
|------|---------|------------|-------|--------------|
| 2025-01-13 | Framework Review | 70% | 85/100 | Use MultiEdit for same file |
| | | | | |

## Configuration Updates Based on Analysis

If you identify recurring patterns, update your `~/.claude/CLAUDE.md`:

```markdown
## Personal Anti-Patterns to Avoid
Based on session analysis, I frequently:
- [Pattern 1]: [Solution]
- [Pattern 2]: [Solution]
```

## Questions for Reflection

After each session, ask:

1. **What operations could have been batched together?**
2. **Did I read files immediately upon discovery?**
3. **Were all my agent calls necessary to be serial?**
4. **Could I have anticipated next steps and prefetched?**
5. **Did I use the most efficient tool for each task?**

---

*Use this template after each Claude Code session to continuously improve your execution efficiency.*