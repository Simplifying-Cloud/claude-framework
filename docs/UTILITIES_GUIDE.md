# Claude Framework Utilities Guide

## 🚀 New Utilities Overview

Your Claude Framework now includes powerful utilities to maximize efficiency and framework utilization.

## Available Scripts

### 1. 🔧 **maintenance.sh** - Automated Maintenance
```bash
~/.claude/scripts/maintenance.sh
```
**Features:**
- Quick health check (sync status + validation)
- Full maintenance with backup
- Performance review
- Framework synchronization
- Cleanup old backups

**Usage:** Run weekly for optimal framework health

### 2. 🔍 **mcp-check.sh** - MCP Server Readiness
```bash
~/.claude/scripts/mcp-check.sh
```
**Features:**
- Checks Azure MCP configuration
- Verifies GitHub MCP setup
- Shows missing environment variables
- Provides setup instructions

**Usage:** Run before using MCP tools

### 3. 🤖 **agent-launcher.sh** - Agent Quick Reference
```bash
~/.claude/scripts/agent-launcher.sh
```
**Features:**
- Lists all 39 available agents
- Shows usage examples
- Provides quick launch commands
- Agent best practices

**Usage:** Reference when starting new tasks

### 4. 📊 **performance-dashboard.sh** - Performance Analytics
```bash
~/.claude/scripts/performance-dashboard.sh
```
**Features:**
- Performance summary dashboard
- Recent session analysis
- Optimization tips
- Benchmark comparisons
- Report generation

**Usage:** Review after sessions for insights

### 5. 👤 **profile-switcher.sh** - Profile Management
```bash
~/.claude/scripts/profile-switcher.sh
```
**Features:**
- Switch between personal/work/client profiles
- Profile-specific configurations
- Preferred agents per profile
- Security settings per profile

**Usage:** Switch profiles based on context

## Workflow Templates

### **workflow-go-api.md** - Go API Development
Complete workflow for Go REST API development with parallel execution examples

### **workflow-azure-deploy.md** - Azure Deployment
End-to-end Azure deployment workflow with MCP integration

## Quick Commands Reference

### Daily Operations
```bash
# Check framework health
~/.claude/scripts/maintenance.sh
# Choose option 1 for quick check

# Verify MCP readiness
~/.claude/scripts/mcp-check.sh

# Review agents for task
~/.claude/scripts/agent-launcher.sh
```

### Weekly Maintenance
```bash
# Full maintenance with backup
~/.claude/scripts/maintenance.sh
# Choose option 2

# Performance review
~/.claude/scripts/performance-dashboard.sh
# Choose option 6 for full view
```

### Context Switching
```bash
# Switch to work profile
~/.claude/scripts/profile-switcher.sh
# Choose option 3

# Switch to client profile
~/.claude/scripts/profile-switcher.sh
# Choose option 4
```

## Aliases for Quick Access

Add to your ~/.bashrc or ~/.zshrc:
```bash
alias claude-check='~/.claude/scripts/maintenance.sh'
alias claude-mcp='~/.claude/scripts/mcp-check.sh'
alias claude-agents='~/.claude/scripts/agent-launcher.sh'
alias claude-perf='~/.claude/scripts/performance-dashboard.sh'
alias claude-profile='~/.claude/scripts/profile-switcher.sh'
```

## Performance Optimization Tips

1. **Before Starting Work:**
   - Run `claude-check` for health status
   - Run `claude-mcp` if using Azure/GitHub
   - Check `claude-agents` for relevant agents

2. **During Work:**
   - Batch operations (10-20 per message)
   - Use specialized agents proactively
   - MultiEdit for same-file changes

3. **After Sessions:**
   - Run `claude-perf` for metrics
   - Review anti-patterns
   - Update workflow templates

## Troubleshooting

### MCP Not Working?
```bash
~/.claude/scripts/mcp-check.sh
# Follow the setup instructions shown
```

### Framework Out of Sync?
```bash
cd ~/Documents/code/claude-framework
./scripts/sync.sh status
./scripts/sync.sh pull
```

### Need Performance Help?
```bash
~/.claude/scripts/performance-dashboard.sh
# Choose option 3 for optimization tips
```

## Next Steps

1. Configure MCP servers (see MCP_SETUP.md)
2. Review workflow templates
3. Set up shell aliases
4. Run performance dashboard after next session
5. Experiment with profile switching

---

**Framework Utilization: 95%** 🎯

You now have all tools needed for maximum Claude Framework efficiency!