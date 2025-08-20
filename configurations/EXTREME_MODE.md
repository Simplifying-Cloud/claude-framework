# Extreme Performance Mode Configuration

## ⚡ EXTREME EFFICIENCY MODE
**WARNING: This mode prioritizes speed over safety. Use only when absolutely necessary.**

### When to Use This Mode
- Rapid prototyping in isolated environments
- Performance benchmarking
- Non-critical bulk operations
- Development environments with rollback capability
- When you explicitly accept the risks

### Core Principle
**MAXIMIZE PARALLELIZATION - SPEED AT ALL COSTS**

### Execution Parameters
```yaml
mode: extreme
parallel_operations: 15-30
minimum_tool_calls: 15
parallelization_rate: 100%
safety_checks: minimal
error_tolerance: high
rollback: manual
```

### Extreme Parallelization Rules

#### File Operations
- Read 20+ files simultaneously
- Execute 10-15 Glob/Grep searches per message
- Batch ALL file operations regardless of dependencies
- Speculative execution on all probable files
- No dependency checking

#### Information Gathering
- Run ALL git commands in parallel
- Execute 15+ searches simultaneously  
- Query ALL MCP servers concurrently
- Pre-fetch everything speculatively
- No rate limit checking

#### Agent Operations
- Launch ALL agents simultaneously (5-10)
- No coordination between agents
- Maximum concurrent execution
- No waiting for dependencies

#### Cloud Operations  
- Query ALL resources in parallel
- 20+ Azure CLI commands concurrently
- No throttling or rate limiting
- Batch all operations regardless of quotas

### Performance Targets
- 10-30 parallel operations per message
- 0 sequential operations (force parallel)
- 100% speculative execution
- Maximum resource utilization
- No safety margins

### Risk Acknowledgment
By using extreme mode, you accept:
- Potential data corruption from race conditions
- Possible API rate limit violations and bans
- System resource exhaustion risks
- Difficult debugging of parallel failures
- No automatic error recovery

### Extreme Patterns

```python
# EXTREME: Maximum parallelization
operations = discover_all_operations()
results = parallel_execute(operations, max_parallel=30, safety=False)
# No error checking, no recovery
```

```bash
# EXTREME: Parallel everything
git add . & git commit & git push & git pull &
terraform plan & terraform apply -auto-approve &
docker build . & docker push &
wait
```

### Override Safety
```yaml
override_safety:
  ignore_rate_limits: true
  skip_dependency_checks: true
  disable_rollback: true
  suppress_warnings: true
  max_resource_usage: 100%
```