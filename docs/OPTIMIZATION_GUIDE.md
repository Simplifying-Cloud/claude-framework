# Claude Framework Optimization Guide

## Quick Performance Tips

### 1. Use Parallel Execution
Always batch multiple operations in a single message:
```bash
# GOOD - Single message with multiple tool calls
- Read: file1.js
- Read: file2.js
- Grep: "pattern" 
- Bash: npm test

# BAD - Sequential operations
Message 1: Read file1
Message 2: Read file2
```

### 2. Leverage Specialized Agents
Don't implement tasks yourself when agents exist:
- **Go Development** → Use `go-expert` agent
- **Security Review** → Use `security-specialist` agent
- **Azure Tasks** → Use `azure-cloud-architect` agent
- **GitHub Operations** → Use `github-ops-specialist` agent

### 3. Use MultiEdit for Same File
When making multiple changes to the same file:
```bash
# GOOD
MultiEdit: file.js with array of edits

# BAD
Edit: file.js change 1
Edit: file.js change 2
```

### 4. Track Your Performance
After each session, run:
```bash
~/.claude/hooks/post-session/performance-analyzer.sh [session-log]
```

## Agent Quick Reference

### Development
- `go-expert`: Go architecture, best practices
- `go-test-specialist`: Go testing, mocking
- `meta-agent`: Generate new agents
- `agent-generator`: Create agent configs

### Operations
- `azure-cloud-architect`: Azure design, CAF compliance
- `github-ops-specialist`: GitHub repos, PRs, issues
- `security-specialist`: Security vulnerabilities
- `performance-auditor`: Performance analysis
- `filesystem-orchestrator`: Complex file operations
- `work-summary-agent`: Session summaries

### Maintenance
- `framework-auditor`: Framework consistency
- `documentation-maintainer`: Doc synchronization
- `config-migration-specialist`: Version migrations

### Security
- `secret-scanner-specialist`: Secret detection

### Testing
- `test-automation-engineer`: Test suite creation

## Performance Checklist
- [ ] Batch all independent operations
- [ ] Use agents for specialized tasks
- [ ] MultiEdit for same-file changes
- [ ] Run validation after changes
- [ ] Check performance analytics regularly