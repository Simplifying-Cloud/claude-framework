# Claude Framework - Adaptive Configuration System

## 🎯 Intelligent Mode Selection

This configuration system automatically selects the appropriate execution mode based on context, task requirements, and explicit user preferences. Three modes are available: **Safe**, **Balanced**, and **Extreme**.

## 📊 Current Mode Selection

### Default Mode: **BALANCED**
The framework defaults to Balanced mode for optimal performance with safety guarantees.

### Mode Selection Priority
1. **Explicit user request** (e.g., "use extreme mode for this")
2. **Context detection** (production = safe, development = balanced)
3. **Task analysis** (critical = safe, bulk = extreme)
4. **Default fallback** (balanced)

## 🔄 Available Execution Modes

### 🛡️ **SAFE MODE** (Production/Critical)
- **Config**: `configurations/SAFE_MODE.md`
- **Parallel Ops**: 3-5 maximum
- **Safety**: Maximum validation and rollback
- **Use When**: Production, compliance, critical data
- **Performance**: 1.5-2x improvement
- **Reliability**: 99.9% target

### ⚖️ **BALANCED MODE** (Default/Recommended)
- **Config**: `configurations/BALANCED_MODE.md`
- **Parallel Ops**: 5-10 adaptive
- **Safety**: Smart validation with recovery
- **Use When**: Most operations, development, testing
- **Performance**: 2-3x improvement
- **Reliability**: 95%+ target

### ⚡ **EXTREME MODE** (Development/Benchmarking)
- **Config**: `configurations/EXTREME_MODE.md`
- **Parallel Ops**: 15-30 aggressive
- **Safety**: Minimal checks, manual recovery
- **Use When**: Prototyping, benchmarks, bulk ops
- **Performance**: 5-10x theoretical
- **Reliability**: 70-80% (unstable)

## 🤖 Automatic Mode Detection

The system automatically selects the appropriate mode based on:

### Environment Indicators
```yaml
production_indicators:
  - Branch: main, master, production
  - Environment: PROD, PRODUCTION
  - Tags: critical, compliance, audit
  → Selects: SAFE MODE

development_indicators:
  - Branch: dev, develop, feature/*
  - Environment: DEV, DEVELOPMENT, TEST
  - Tags: prototype, experiment
  → Selects: BALANCED MODE

performance_indicators:
  - Tags: benchmark, performance-test, bulk
  - Explicit: "maximize speed", "ignore safety"
  → Selects: EXTREME MODE
```

### Task Type Detection
```yaml
safe_mode_tasks:
  - Database migrations
  - Financial transactions
  - User data operations
  - Production deployments
  - Security operations

balanced_mode_tasks:
  - Code analysis
  - Testing operations
  - Documentation generation
  - Development tasks
  - Standard deployments

extreme_mode_tasks:
  - Bulk file processing
  - Performance benchmarking
  - Large-scale analysis
  - Non-critical batch operations
```

## 🎮 Manual Mode Control

### Switching Modes via Comments
```markdown
<!-- MODE: SAFE -->
Perform critical operations here

<!-- MODE: EXTREME -->
Run performance benchmarks here

<!-- MODE: BALANCED -->
Return to balanced mode
```

### Switching Modes via Commands
```bash
# Set mode for session
export CLAUDE_MODE=safe

# Set mode for single operation
CLAUDE_MODE=extreme <operation>

# Check current mode
echo $CLAUDE_MODE
```

### Switching Modes via Tags
- `#safe-mode` - Forces safe mode
- `#balanced-mode` - Forces balanced mode
- `#extreme-mode` - Forces extreme mode
- `#auto-mode` - Returns to automatic detection

## 📋 Mode Configuration Loading

The system loads configurations in this order:

1. Check for explicit mode directive
2. Load base configuration from selected mode file
3. Apply any user overrides
4. Validate configuration consistency
5. Initialize with selected parameters

### Configuration Structure
```
configurations/
├── SAFE_MODE.md      # Maximum safety configuration
├── BALANCED_MODE.md  # Optimal balance (default)
└── EXTREME_MODE.md   # Maximum performance configuration
```

## 🔧 Mode-Specific Behaviors

### Safe Mode Behaviors
- Sequential git operations
- File locking on all writes
- Pre-execution validation
- Automatic rollback on failure
- Full audit logging
- Max 5 parallel operations

### Balanced Mode Behaviors
- Intelligent parallelization (5-10 ops)
- Dependency-aware execution
- Rate limit compliance
- Error recovery with retry
- Selective audit logging
- Adaptive resource scaling

### Extreme Mode Behaviors
- Maximum parallelization (15-30 ops)
- Speculative execution
- Minimal validation
- Manual error recovery
- Limited logging
- 100% resource utilization

## 📊 Mode Selection Examples

### Example 1: Database Migration
```markdown
Task: "Migrate production database"
Detection: Keywords "production", "database"
Selected Mode: SAFE
Reason: Critical operation requiring maximum safety
```

### Example 2: Codebase Analysis
```markdown
Task: "Analyze project structure"
Detection: Non-critical read operations
Selected Mode: BALANCED
Reason: Standard operation with good performance/safety balance
```

### Example 3: Bulk File Processing
```markdown
Task: "Process 10000 log files"
Detection: "bulk", high file count
Selected Mode: EXTREME
Reason: Non-critical bulk operation where speed matters
```

## 🚨 Mode Override Warnings

When manually selecting a mode, be aware:

### ⚠️ Forcing Extreme Mode
```
WARNING: Extreme mode selected
- No automatic rollback
- Potential API violations
- Resource exhaustion risk
- Limited error recovery
Continue only if you accept these risks
```

### ✅ Forcing Safe Mode
```
INFO: Safe mode selected
- Operations will be slower
- Maximum validation enabled
- Full rollback capability
- Complete audit trail
```

## 🔄 Dynamic Mode Switching

The system can dynamically switch modes based on:

### Performance Degradation
```yaml
if error_rate > 10%:
  switch_to_safe_mode()
  
if response_time > 10s:
  reduce_parallelization()
  
if resource_usage > 90%:
  switch_to_balanced_mode()
```

### Context Changes
```yaml
if entering_production_branch():
  switch_to_safe_mode()
  
if user_requests_speed():
  switch_to_extreme_mode()
  
if detecting_sensitive_data():
  switch_to_safe_mode()
```

## 📈 Mode Performance Metrics

| Metric | Safe | Balanced | Extreme |
|--------|------|----------|---------|
| Parallel Ops | 3-5 | 5-10 | 15-30 |
| Speed Gain | 1.5-2x | 2-3x | 5-10x |
| Reliability | 99.9% | 95% | 70-80% |
| Error Recovery | Auto | Auto | Manual |
| Resource Usage | 30-40% | 50-70% | 90-100% |
| Debug Difficulty | Easy | Medium | Hard |

## 🛠️ Configuration Utilities

### Check Current Mode
```bash
./scripts/check-mode.sh
```

### Switch Mode
```bash
./scripts/switch-mode.sh [safe|balanced|extreme]
```

### Mode Recommendation
```bash
./scripts/recommend-mode.sh <task-description>
```

## 📚 Mode Documentation

For detailed information about each mode:
- **Safe Mode**: See `configurations/SAFE_MODE.md`
- **Balanced Mode**: See `configurations/BALANCED_MODE.md`
- **Extreme Mode**: See `configurations/EXTREME_MODE.md`

## 🔐 Security Considerations

### Mode Security Levels
- **Safe**: Full security validation, encrypted operations
- **Balanced**: Standard security, selective encryption
- **Extreme**: Minimal security, speed prioritized

### Sensitive Operations
Certain operations always force safe mode:
- Credential management
- Payment processing
- User data modifications
- Security configurations
- Compliance operations

## 🎯 Best Practices

1. **Let the system choose**: Automatic detection works well for most cases
2. **Explicit when needed**: Use mode tags for clarity in critical sections
3. **Monitor metrics**: Watch performance indicators for mode effectiveness
4. **Test mode changes**: Verify behavior when switching modes
5. **Document overrides**: Explain why manual mode selection was necessary

## 🚀 Quick Start

### Using Default (Balanced) Mode
No configuration needed - the system automatically uses balanced mode.

### Forcing a Specific Mode
```markdown
<!-- MODE: SAFE -->
Your critical operations here
```

### Temporary Mode Switch
```bash
CLAUDE_MODE=extreme ./run-bulk-operation.sh
```

## 📋 Mode Selection Decision Tree

```
Start
  ├── Explicit mode request? → Use requested mode
  ├── Production environment? → Use SAFE mode
  ├── Critical operation? → Use SAFE mode
  ├── Bulk operation? → Consider EXTREME mode
  ├── Development task? → Use BALANCED mode
  └── Default → Use BALANCED mode
```

## 🔄 Continuous Improvement

The mode selection system continuously improves through:
- Performance metrics analysis
- Error rate monitoring
- User feedback integration
- Context pattern learning
- Automatic threshold adjustment

## ⚙️ Advanced Configuration

### Custom Mode Parameters
```yaml
custom_override:
  base_mode: balanced
  parallel_operations: 7
  safety_level: medium
  rate_limit_strict: true
  custom_threshold: 0.08
```

### Mode Combination
```yaml
hybrid_mode:
  read_operations: extreme
  write_operations: safe
  api_operations: balanced
```

---

**System Version**: 3.0.0 (Multi-Mode)
**Default Mode**: BALANCED
**Mode Files**: `/configurations/*.md`
**Last Updated**: January 2025

For mode-specific details, refer to the individual configuration files in the `configurations/` directory.