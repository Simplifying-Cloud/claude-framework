# Global Claude Configuration - Maximum Efficiency Edition

## 🏆 EFFICIENCY MANIFESTO

**CORE PRINCIPLE: NEVER EXECUTE SEQUENTIALLY**

Every operation must be parallelized. Every search batched. Every file read grouped. This configuration enforces maximum efficiency through aggressive parallelization, speculative execution, and intelligent caching. 

**Efficiency Targets:**
- ⚡ 10-30 parallel operations per message
- 🚀 0 sequential tool calls (everything parallel)
- 💯 100% agent utilization for specialized tasks
- 🔥 500% speed boost via caching (Firecrawl maxAge)
- 📊 15+ tool calls is the minimum standard

## 🚀 ULTRA-PARALLEL EXECUTION STRATEGY

### MANDATORY: Maximum Parallelization at All Times
**Execute everything possible in parallel - think in batches, not sequences:**

1. **File Operations - ALWAYS PARALLEL**
   - Read 10+ files simultaneously when analyzing codebases
   - Execute 5-10 Glob/Grep searches in single message
   - Batch ALL independent file edits together
   - **MANDATORY: Use single MultiEdit for same-file changes** - Never use multiple Edit calls on same file
   - **Combine directory operations** - Use single `mkdir -p dir1 dir2 dir3` not multiple mkdirs
   - Speculatively read potentially relevant files

2. **Information Gathering - AGGRESSIVE BATCHING**
   - Run ALL git commands in parallel (status, diff, log, branch, remote)
   - Execute 10+ independent searches simultaneously
   - Fetch ALL web resources in single batch
   - Query ALL relevant MCP servers concurrently
   - Pre-fetch likely next resources speculatively

3. **Agent Operations - MAXIMUM CONCURRENCY**
   - Launch ALL applicable agents simultaneously
   - Run framework-auditor + security-specialist + documentation-maintainer in parallel
   - Execute test + lint + build agents concurrently
   - Chain agent results into parallel next actions

4. **Cloud Operations - BATCH EVERYTHING**
   - Query ALL Azure resources in single parallel batch
   - Run 10+ Azure CLI commands concurrently
   - Fetch ALL service configurations simultaneously
   - Execute terraform plan + validate + fmt in parallel
   - Query all regions/subscriptions/resource groups at once

### 🎯 Parallel Execution Rules

**ALWAYS Parallelize (No Exceptions):**
- ALL read operations - never read files one by one
- ALL search operations - batch every grep/glob/find
- ALL information gathering - single message, many tools
- ALL analysis tasks - multiple agents simultaneously
- ALL test executions - run entire test suite at once
- ALL validation checks - lint + typecheck + test + build together

**Common Anti-Patterns to AVOID:**
- ❌ Multiple Edit calls on same file → Use single MultiEdit
- ❌ Sequential mkdir commands → Use `mkdir -p path1 path2 path3`
- ❌ Separate rm commands → Use `rm -f file1 file2 file3`
- ❌ Reading files after discovery → Read during discovery

**Maximum Parallel Patterns:**
- **Single message with 10-20 tool calls** is NORMAL
- **Group ALL similar operations** - no stragglers
- **Batch EVERYTHING** - think in sets, not items
- **Speculative execution** - pre-fetch probable needs
- **Parallel → Parallel** - chain parallel outputs to parallel inputs

**Performance Gains:**
- 10x faster execution through parallelization
- 90% reduction in round-trip delays
- Near-instant codebase analysis
- Immediate multi-file operations
- Real-time cross-service queries

### 💪 Maximum Efficiency Patterns

**File Modification Pattern:**
```
# CORRECT - Single MultiEdit for multiple changes to same file
- MultiEdit: settings.json with 5 edits array

# WRONG - Multiple operations on same file
- Edit: settings.json change 1
- Edit: settings.json change 2
- Edit: settings.json change 3
```

**Directory Operations Pattern:**
```
# CORRECT - Single command
- Bash: mkdir -p dir1/sub1 dir2/sub2 dir3 && rm -f file1 file2 file3

# WRONG - Multiple commands
- Bash: mkdir dir1/sub1
- Bash: mkdir dir2/sub2
- Bash: rm file1
```

**ULTRA-PARALLEL Pattern (Required):**
```
# Single message with 15+ tool calls
- Bash: git status && git branch -a && git remote -v
- Bash: git diff --stat && git diff --cached
- Bash: git log --oneline -20 --graph --all
- Bash: find . -type f -name "*.json" | head -20
- Read: README.md
- Read: package.json
- Read: tsconfig.json
- Read: .gitignore
- Glob: **/*.test.{js,ts,tsx}
- Glob: **/*.spec.{js,ts,tsx}
- Glob: **/README.md
- Grep: "TODO|FIXME|HACK" (output_mode: content)
- Grep: "error|Error|ERROR" (output_mode: files_with_matches)
- Task: security-specialist "Scan for vulnerabilities"
- Task: framework-auditor "Check consistency"
```

**NEVER DO THIS (Sequential Anti-Pattern):**
```
# Multiple messages = INEFFICIENT
Message 1: Read one file
Message 2: Read another file
Message 3: Search for something
Message 4: Read search results
Message 5: Make edit
```

## Sequential Thinking Integration

**ALWAYS use sequential thinking (mcp__sequential-thinking__sequentialthinking) for:**
- Breaking down complex problems into steps
- Planning and designing solutions with room for revision
- Analyzing problems that might need course correction
- Working on problems where the full scope might not be clear initially
- Solving problems that require multi-step solutions
- Maintaining context over multiple steps
- Filtering out irrelevant information
- Generating and verifying solution hypotheses
- Working on architectural design or system analysis
- Creating comprehensive documentation or PRDs
- Debugging complex issues
- Performing code reviews or refactoring tasks
- Any task requiring iterative refinement

## Task Management

**ALWAYS use TodoWrite tool for:**
- Tasks with 3+ steps
- Complex operations requiring tracking
- Multi-phase projects
- Parallel task coordination

## Tool Usage Preferences

1. **Sequential Thinking First**: For any non-trivial task, start with sequential thinking to plan the approach
2. **Task Management**: Use TodoWrite tool proactively for any multi-step task
3. **Parallel Processing**: Execute independent tool calls in parallel when possible
4. **Sub-Agent Delegation**: ALWAYS proactively use specialized sub-agents when tasks match their expertise

## Agent Usage Policy

**MANDATORY: Always use appropriate agents for specialized tasks.**

### When to Use Agents

**IMMEDIATELY delegate to agents when:**
- The task matches any agent's specialized domain
- Complex multi-step operations require expert handling
- Specialized knowledge or best practices are needed
- Multiple related subtasks can be handled by a single agent
- The task involves domain-specific operations (Go, Azure, GitHub, etc.)

### Agent Selection Priority

1. **First Priority**: Check if task matches a specialized agent's expertise
2. **Second Priority**: Consider if multiple agents could work in parallel
3. **Third Priority**: Use Task tool for general-purpose complex operations
4. **Never Skip**: Always use agents instead of attempting specialized tasks directly

### Examples of Mandatory Agent Usage

- **Go Development** → Always use go-expert for Go code
- **Go Testing** → Always use go-test-specialist for Go tests
- **Security Review** → Always use security-specialist for security analysis
- **Azure Architecture** → Always use azure-cloud-architect for Azure design
- **GitHub Operations** → Always use github-ops-specialist for GitHub tasks
- **PRD Creation** → Always use prd-writer for requirements documents
- **Work Summaries** → Always use work-summary-agent after major tasks

### Agent Usage Rules

- **No Direct Implementation**: Never implement specialized tasks yourself if an agent exists
- **Parallel Agents**: Launch multiple agents concurrently when possible
- **Agent Chaining**: Use agents in sequence for complex workflows
- **Expertise First**: Trust agent expertise over general approaches
- **Proactive Delegation**: Don't wait for user to request agent usage

## GitHub Organization Default

**Default GitHub Organization**: Always use `Simplifying-Cloud` as the default GitHub organization unless explicitly asked to use a different organization or account.

### GitHub Repository Resolution Rules

1. **When a repository name is mentioned without an organization:**
   - ALWAYS assume it's in the `Simplifying-Cloud` organization first
   - Search within Simplifying-Cloud before considering other organizations
   - Only look elsewhere if explicitly told or if not found in Simplifying-Cloud

2. **Repository Search Priority:**
   - First: Check `Simplifying-Cloud` organization
   - Second: Ask for clarification if not found
   - Never: Assume popular public repos (like anthropics/claude-code) over Simplifying-Cloud repos

3. **Examples:**
   - "Pull the claude framework" → Search/assume `Simplifying-Cloud/claude-framework`
   - "Clone the utils repo" → Search/assume `Simplifying-Cloud/utils`
   - "Get anthropics/claude-code" → Use the explicitly specified org

## 🔥 MCP Server Optimization Strategy

### MAXIMUM MCP Server Utilization

**Parallel MCP Query Patterns:**
```
# Query ALL Azure services simultaneously
- mcp__azure__subscription: list all
- mcp__azure__group: list all resources
- mcp__azure__storage: list all accounts
- mcp__azure__aks: list all clusters
- mcp__azure__sql: list all databases
- mcp__azure__monitor: query logs
- mcp__azure__keyvault: list secrets
```

**Web Operations - BATCH EVERYTHING:**
```
# Fetch ALL documentation simultaneously
- mcp__firecrawl__firecrawl_scrape: main page
- mcp__firecrawl__firecrawl_map: discover all URLs
- mcp__firecrawl__firecrawl_search: find specific content
- WebFetch: multiple docs pages
- WebSearch: multiple queries
- mcp__context7__get-library-docs: all relevant libraries
```

**Cache-Aware Patterns:**
- Use `maxAge` parameter in Firecrawl for 500% speed boost
- Reuse fetched content across operations
- Batch similar MCP calls to maximize cache hits
- Pre-fetch likely needed documentation

## 🚀 Agent Army Strategy - USE ALL AGENTS

### PARALLEL AGENT DEPLOYMENT

**Launch Agent Swarms for Every Task:**
```
# Development Task = 5+ Agents Simultaneously
- go-expert: Write the code
- go-test-specialist: Write tests
- security-specialist: Security review
- documentation-maintainer: Update docs
- framework-auditor: Verify consistency
```

### Available Global Sub-Agents

#### Development & Testing Agents
- **go-expert**: Go architecture, error handling, performance optimization
- **go-test-specialist**: Go unit tests, integration tests, mocking
- **security-specialist**: Security vulnerabilities, authentication, credential exposure
- **test-automation-engineer**: Comprehensive test suite creation
- **agent-generator**: Intelligent agent configuration creation

#### Azure & Cloud Agents
- **azure-cloud-architect**: Azure solutions, CAF compliance, security frameworks
- **azure-deployment-specialist**: Azure deployment, Docker, CI/CD pipelines

#### Operations & Collaboration Agents
- **github-ops-specialist**: GitHub repository management, PRs, issues, workflows
- **work-summary-agent**: Task completion summaries and next steps
- **meta-agent**: Generate new sub-agent configurations
- **secret-scanner-specialist**: Advanced secret detection and removal

#### Framework & Maintenance Agents
- **framework-auditor**: Automated consistency checking
- **documentation-maintainer**: Keep docs synchronized
- **config-migration-specialist**: Handle version migrations

#### Product Requirements Document (PRD) Lifecycle Agents
- **prd-writer**: Creates comprehensive Product Requirements Documents
- **requirements-verifier**: Validates products against PRD specifications
- **qa-testing-coordinator**: Orchestrates comprehensive testing against PRDs
- **stakeholder-alignment-coordinator**: Manages review and approval processes
- **prd-analytics-tracker**: Monitors success metrics and KPIs

## Code Quality Practices

- **Always run lint and typecheck commands after code changes**
- **Follow existing code conventions and patterns**
- **Use existing libraries rather than introducing new dependencies**
- **Maintain security best practices**
- Never introduce code that exposes or logs secrets and keys
- Never commit secrets or keys to repositories

## Documentation Standards

- **Reference code locations with `file_path:line_number` format** for easy navigation
- Keep responses concise and action-oriented
- Document significant decisions in sequential thinking
- Provide clear context when referencing code elements
- Use markdown formatting for readability

## Problem-Solving Approach

1. **Understand**: Use sequential thinking to understand the problem
2. **Plan**: Create a todo list for complex tasks
3. **Execute**: Run operations in parallel when possible, with appropriate tools
4. **Verify**: Check results against requirements
5. **Document**: Record findings and next steps
6. **Analyze**: Review session performance for optimization opportunities

## ⚡ EXTREME Performance Optimization

### Speed Maximization Techniques

1. **MEGA-BATCH Operations**: 
   - Group 20+ operations minimum
   - Never execute single operations
   - Combine reads, searches, and analyses

2. **ZERO Round Trips**:
   - Anticipate next 3-5 steps
   - Pre-fetch ALL possible needs
   - Speculative execution is MANDATORY

3. **AGGRESSIVE Speculation**:
   - Read 150% of what you might need
   - Pre-load adjacent files always
   - Query related resources proactively

4. **CACHE EVERYTHING**:
   - Use Firecrawl maxAge=3600000 always
   - Store results for reuse
   - Never re-fetch within session

5. **PARALLEL CHAINING**:
   - Output of parallel → Input to parallel
   - Never serialize workflows
   - Pipeline everything possible

### 📊 Performance Metrics to Maximize

- **Operations per message**: Target 15-30
- **Parallel tool calls**: Minimum 10
- **Agent concurrency**: 3-5 agents always
- **MCP batch size**: 5-10 queries
- **File batch reads**: 10-20 files
- **Search parallelism**: 5+ searches

### 🎮 Advanced Parallel Patterns

**Pattern 1: Shotgun Discovery**
```
# Discover everything about a codebase instantly
- Glob: **/*.{js,ts,jsx,tsx,py,go,java,rs}
- Glob: **/package.json
- Glob: **/README.md
- Glob: **/.env*
- Grep: "main|Main|MAIN" 
- Grep: "test|Test|TEST"
- Grep: "TODO|FIXME"
- Bash: find . -type f | wc -l
- Bash: git log --oneline | head -50
- Read: [all config files found]
```

**Pattern 2: Instant Full Analysis**
```
# Complete project analysis in one message
- Task: framework-auditor "Full audit"
- Task: security-specialist "Security scan"
- Task: documentation-maintainer "Doc check"
- Task: go-expert "Code review"
- Task: test-automation-engineer "Test coverage"
- Bash: npm test && npm run lint && npm run build
```

**Pattern 3: Parallel-to-Parallel Pipeline**
```
# Stage 1: Parallel discovery
[10 parallel searches] → 
# Stage 2: Parallel reads
[Read all found files] →
# Stage 3: Parallel edits
[MultiEdit all files] →
# Stage 4: Parallel validation
[Test + Lint + Build + Deploy]
```

## Global Best Practices

- **Proactive Information Gathering**: Anticipate information needs and fetch in parallel
- **Efficient Tool Usage**: Choose the right tool for each task
- **Smart Batching**: Group related operations for concurrent execution
- **Context Preservation**: Maintain relevant context across operations
- **Error Resilience**: Handle failures gracefully in parallel operations
- **Performance Analysis**: Review each session for optimization opportunities

## Session Performance Analysis

### Automatic Analysis After Each Session

**Option 1: Use Performance Auditor Agent**
```
Request: "Analyze our session performance using the performance-auditor agent"
```

**Option 2: Manual Analysis Template**
```
Use: ~/Documents/code/claude-framework/templates/SESSION_ANALYSIS.md
```

**Option 3: Automated Script**
```bash
# Run analyzer
~/.claude/hooks/post-session/performance-analyzer.sh

# View trends
cat ~/.claude/analytics/trends.csv
```

### Performance Targets
- **Parallelization Rate**: >70%
- **Operations per Message**: 10-20
- **Performance Score**: >85/100
- **Zero Anti-Patterns**: No multiple edits to same file

## Core Development Philosophy

### KISS (Keep It Simple, Stupid)

Simplicity should be a key goal in design. Choose straightforward solutions over complex ones whenever possible. Simple solutions are easier to understand, maintain, and debug.

### YAGNI (You Aren't Gonna Need It)

Avoid building functionality on speculation. Implement features only when they are needed, not when you anticipate they might be useful in the future.

### Design Principles

- **IMPORTANT** Go is the preferred language for all projects.
- External libraries use should be kept to a minimum, and only used when absolutely required.
- Frontend services should be provided through WebAssembly whenever possible.
- Any deviation should be done using the most simple option possible unless explicitly requested to do differently.
- All work should be considered a minimum viable product unless explicitly requested to do differently.

## Critical Thinking Reminders

### Adaptive Problem-Solving
- **Always validate assumptions before proceeding**
- **Question or revise previous thoughts when new information emerges**
- **Add more thinking steps if initial estimates prove insufficient**
- **Mark thoughts that revise previous thinking or branch into new paths**
- **Generate solution hypotheses and verify them systematically**

### Execution Safety
- Parallel execution should never compromise accuracy or safety
- Always verify dependencies before parallelizing operations
- Monitor for race conditions in write operations
- Maintain clear logging for parallel operations
- Fall back to sequential execution when order matters

### Quality Assurance
- Test assumptions with small experiments before large-scale changes
- Verify outputs match expected results
- Document unexpected behaviors or edge cases
- Consider rollback strategies for risky operations
- Maintain version control awareness