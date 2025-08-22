# Claude Framework

A comprehensive framework for managing and versioning Claude Code configurations, agents, MCP servers, hooks, and settings with an adaptive multi-mode execution system.

## Features

- **🎯 Adaptive Multi-Mode System**: Intelligent execution modes (Safe/Balanced/Extreme) that adapt to context
- **🤖 Agent Management**: 30+ specialized agents for development, operations, testing, and more
- **⚙️ Settings Templates**: Standardized configuration management with global and local settings
- **🔌 MCP Server Configs**: GitHub and Azure MCP configurations
- **🪝 Hook System**: Automate workflows with pre/post-commit and session hooks
- **📦 Profile Support**: Switch between personal, work, and custom profiles
- **🔄 Sync & Backup**: Automated synchronization and backup utilities
- **📚 Documentation**: Comprehensive templates and examples
- **🔒 Security First**: Built-in protection for sensitive data
- **🚀 Utility Scripts**: Maintenance, performance dashboard, agent launcher
- **📊 Analytics**: Performance tracking and optimization tools
- **🎯 Workflow Templates**: Pre-built workflows for common tasks
- **🧠 Core Philosophy**: KISS (Keep It Simple) and YAGNI (You Aren't Gonna Need It) principles

## Multi-Mode Execution System

The framework features an intelligent adaptive execution system with three modes:

### 🛡️ Safe Mode
- **Use Case**: Production environments, critical operations
- **Parallel Ops**: 3-5 maximum
- **Features**: Maximum validation, automatic rollback, full audit logging
- **Reliability**: 99.9% target

### ⚖️ Balanced Mode (Default)
- **Use Case**: Most operations, development, testing
- **Parallel Ops**: 5-10 adaptive
- **Features**: Smart validation, error recovery with retry
- **Performance**: 2-3x improvement over sequential

### ⚡ Extreme Mode
- **Use Case**: Prototyping, benchmarks, bulk operations
- **Parallel Ops**: 15-30 aggressive
- **Features**: Minimal validation, maximum speed
- **Performance**: 5-10x theoretical improvement

The system automatically selects the appropriate mode based on context, or you can manually override with mode tags or environment variables.

## Quick Start

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Simplifying-Cloud/claude-framework.git
cd claude-framework
```

2. Run the setup script:
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

3. Reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc
```

### Basic Usage

#### Utility Scripts

The framework includes powerful utility scripts for automation:

```bash
# Run maintenance and health checks
./scripts/maintenance.sh

# Check MCP server configuration
./scripts/mcp-check.sh

# Launch agent reference guide
./scripts/agent-launcher.sh

# View performance analytics
./scripts/performance-dashboard.sh

# Switch between profiles
./scripts/profile-switcher.sh
```

#### Working with Agents

Agents are specialized Claude configurations for specific tasks:

```bash
# List available agents
ls agents/

# Install an agent (agents are now in .md format)
cp agents/development/go-expert.md ~/.claude/agents/

# Convert YAML agents to Markdown (if needed)
python3 scripts/convert-agents.py agents/

# Create custom agent
cp agents/custom/template.md agents/custom/my-agent.md
# Edit agents/custom/my-agent.md
```

#### Managing Settings

```bash
# Edit global settings
vim settings/global/settings.json

# Apply settings
./scripts/sync.sh pull
```

#### Using Hooks

Hooks automate tasks at various points:

```bash
# Enable pre-commit validation
cp hooks/pre-commit/validate-code.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/validate-code.sh
```

## Documentation

Comprehensive guides are available in the `docs/` directory:

- **[MCP_SETUP.md](docs/MCP_SETUP.md)** - MCP server configuration guide
- **[OPTIMIZATION_GUIDE.md](docs/OPTIMIZATION_GUIDE.md)** - Performance optimization tips
- **[UTILITIES_GUIDE.md](docs/UTILITIES_GUIDE.md)** - Complete utilities reference
- **[RECOMMENDATIONS_STATUS.md](docs/RECOMMENDATIONS_STATUS.md)** - Framework utilization guide

## Directory Structure

```
claude-framework/
├── agents/                  # Agent configurations (.md and .yaml formats)
│   ├── cloud/             # Cloud infrastructure agents
│   ├── custom/            # User-defined agents
│   ├── development/       # Coding and development agents
│   ├── documentation/     # Documentation specialists
│   ├── maintenance/       # Framework maintenance agents
│   ├── operations/        # DevOps and operational agents
│   ├── product/           # Product management agents
│   ├── security/          # Security scanning agents
│   └── testing/           # Testing and QA agents
├── configurations/        # Execution mode configurations
│   ├── SAFE_MODE.md      # Production-ready safe execution
│   ├── BALANCED_MODE.md  # Default balanced execution
│   └── EXTREME_MODE.md   # High-performance execution
├── settings/              # Configuration templates
│   └── global/           # Global settings
├── mcp-servers/          # MCP server configurations
│   ├── configs/          # Server config files
│   └── scripts/          # Setup scripts
├── hooks/                # Automation hooks
│   ├── pre-commit/       # Pre-commit validation
│   ├── post-commit/      # Post-commit actions
│   ├── session-start/    # Session initialization
│   ├── session-end/      # Session cleanup
│   └── tool-use/         # Tool execution hooks
├── templates/            # Document templates
│   └── CLAUDE.md        # Project instruction template
├── scripts/              # Utility scripts
│   ├── setup.sh         # Installation script
│   ├── sync.sh          # Sync configurations
│   ├── backup.sh        # Backup management
│   ├── validate.sh      # Validation script
│   └── maintenance.sh   # System maintenance
├── docs/                 # Documentation
└── CLAUDE.md            # Framework configuration guide
```

## Available Agents

### Cloud Infrastructure
- **azure-deployment-specialist**: Azure deployment and containerization expert
- **cloud-infrastructure-manager**: Cloud infrastructure and IaC specialist

### Development Agents
- **go-expert**: Go programming specialist
- **go-test-specialist**: Go testing expert  
- **frontend-engineer**: Modern frontend development specialist
- **solution-architect**: Platform-agnostic solution architect
- **meta-agent**: Creates new agent configurations
- **agent-generator**: Intelligent agent configuration creator

### Operations Agents
- **github-ops-specialist**: GitHub operations expert
- **azure-cloud-architect**: Azure cloud solutions architect
- **security-specialist**: Security and vulnerability specialist
- **work-summary-agent**: Work summary generator
- **performance-auditor**: Session performance analyzer
- **filesystem-orchestrator**: Optimizes complex filesystem operations
- **observability-specialist**: Monitoring and observability expert
- **compliance-auditor**: Compliance and regulatory specialist
- **data-analyst**: Business intelligence and data analysis
- **project-manager**: Comprehensive project management
- **secret-scanner-specialist**: Advanced secret detection

### Documentation
- **technical-writer**: Technical documentation specialist

### Testing Agents
- **test-automation-engineer**: Comprehensive test suite creation
- **qa-testing-coordinator**: Testing orchestration
- **performance-engineer**: Performance testing and optimization

### Security Agents
- **secret-scanner-specialist**: Advanced secret detection and removal

### Maintenance Agents
- **framework-auditor**: Automated consistency checking
- **documentation-maintainer**: Documentation synchronization
- **config-migration-specialist**: Configuration versioning and migration

### Product Agents
- **business-analyst**: Business requirements and analysis
- **prd-writer**: Product requirements document creator
- **requirements-verifier**: Requirements validation
- **prd-analytics-tracker**: Analytics and metrics tracking
- **stakeholder-alignment-coordinator**: Stakeholder management

## MCP Server Integration

The framework includes pre-configured MCP servers:

### GitHub Integration
```json
{
  "name": "github",
  "server": {
    "command": "npx",
    "args": ["@modelcontextprotocol/server-github"]
  }
}
```

### Available MCP Servers

- **GitHub Integration**: Repository management, PRs, issues
- **Azure Integration**: Resource management and documentation

*Note: See FUTURE_FEATURES.md for planned MCP server additions*

## Scripts Reference

### setup.sh
Initializes the Claude framework:
```bash
./scripts/setup.sh
# Options:
#   1) Personal profile
#   2) Work profile
#   3) Full installation
#   4) Custom selection
```

### sync.sh
Synchronizes configurations:
```bash
# Push local changes to repository
./scripts/sync.sh push

# Pull repository changes to local
./scripts/sync.sh pull --backup

# Show differences
./scripts/sync.sh status

# Merge configurations
./scripts/sync.sh merge
```

### backup.sh
Manages configuration backups:
```bash
# Create backup
./scripts/backup.sh create --name "before-update"

# List backups
./scripts/backup.sh list

# Restore backup
./scripts/backup.sh restore 20240112_143022

# Export backup
./scripts/backup.sh export --compress
```

## Configuration

### Framework Configuration (CLAUDE.md)

The framework uses `CLAUDE.md` as its primary configuration guide, which includes:
- Core development philosophy (KISS and YAGNI principles)
- Multi-mode execution system configuration
- Automatic mode detection rules
- Performance metrics and best practices

### Global Settings

Edit `settings/global/settings.json`:

```json
{
  "claude_code": {
    "model": "claude-opus-4-1-20250805",
    "tools": {
      "parallel_execution": true,
      "max_parallel_calls": 10
    }
  },
  "profiles": {
    "default": "personal",
    "available": ["personal", "work", "client"]
  }
}
```

### Environment Variables

Required environment variables for MCP servers:

```bash
# GitHub
export GITHUB_TOKEN="your-github-token"

# Azure
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_TENANT_ID="your-tenant-id"
export AZURE_CLIENT_ID="your-client-id"
export AZURE_CLIENT_SECRET="your-client-secret"
```

## Project Templates

Use the CLAUDE.md template for project-specific instructions:

```bash
cp templates/CLAUDE.md ~/myproject/CLAUDE.md
# Edit with project-specific details
```

## Security

The framework includes built-in security features:

- **Sensitive Data Protection**: Automatically excludes API keys and tokens from sync
- **Pre-commit Validation**: Scans for exposed secrets before commits
- **Backup Encryption**: Optional encryption for exported backups
- **Directory Restrictions**: Limits file access to allowed directories

## Workflows

### Setting Up a New Project

1. Copy the CLAUDE.md template to your project
2. Configure project-specific settings
3. Select appropriate agents
4. Set up relevant hooks

### Creating Custom Agents

1. Use the meta-agent to generate configuration:
```bash
# Claude will help create the agent
```

2. Or manually create from template:
```bash
cp agents/custom/template.yaml agents/custom/my-agent.yaml
vim agents/custom/my-agent.yaml
```

### Switching Profiles

```bash
# Edit settings to change default profile
vim ~/.claude/settings/settings.json
# Change "default": "work"
```

## Troubleshooting

### Common Issues

**Issue**: Scripts not found in PATH
```bash
export PATH="$PATH:$(pwd)/scripts"
```

**Issue**: Permission denied on hooks
```bash
chmod +x hooks/*/*.sh
```

**Issue**: MCP server not starting
```bash
# Check environment variables
env | grep GITHUB_TOKEN
# Check server logs
tail -f ~/.claude/logs/mcp-*.log
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add your configurations
4. Submit a pull request

### Guidelines

- Follow existing naming conventions
- Include documentation for new agents
- Test scripts before submitting
- Don't include sensitive data

## License

MIT License - See LICENSE file for details

## Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/claude-framework/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/claude-framework/discussions)
- **Documentation**: [Wiki](https://github.com/yourusername/claude-framework/wiki)

## Roadmap

See [FUTURE_FEATURES.md](FUTURE_FEATURES.md) for the complete roadmap including:
- MCP server integrations (Security Vault, Framework Manager, Testing Orchestrator)
- Documentation and examples
- Advanced hook system
- Multi-factor authentication
- Automated testing infrastructure

---

**Version**: 2.0.0  
**Last Updated**: August 2025  
**Maintainer**: Simplifying-Cloud Team  
**Agent Format**: Markdown with YAML frontmatter (Claude Code compatible)  
**Execution Modes**: Safe, Balanced (default), and Extreme adaptive modes

Built with ❤️ for the Claude Code community