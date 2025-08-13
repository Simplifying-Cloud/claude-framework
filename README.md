# Claude Framework

A comprehensive framework for managing and versioning Claude Code configurations, agents, MCP servers, hooks, and settings.

## Features

- **🤖 Agent Management**: Organize and version control custom Claude agents
- **⚙️ Settings Templates**: Standardized configuration management
- **🔌 MCP Server Configs**: Pre-configured Model Context Protocol servers
- **🪝 Hook System**: Automate workflows with pre/post-commit hooks
- **📦 Profile Support**: Switch between personal, work, and custom profiles
- **🔄 Sync & Backup**: Automated synchronization and backup utilities
- **📚 Documentation**: Comprehensive templates and examples
- **🔒 Security First**: Built-in protection for sensitive data

## Quick Start

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/claude-framework.git
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

#### Working with Agents

Agents are specialized Claude configurations for specific tasks:

```bash
# List available agents
ls agents/

# Install an agent
cp agents/development/go-expert.yaml ~/.claude/agents/

# Create custom agent
cp agents/custom/template.yaml agents/custom/my-agent.yaml
# Edit agents/custom/my-agent.yaml
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

## Directory Structure

```
claude-framework/
├── agents/                  # Agent configurations
│   ├── development/        # Coding and development agents
│   ├── operations/         # DevOps and operational agents
│   ├── documentation/      # Documentation agents
│   ├── product/           # Product management agents
│   └── custom/            # User-defined agents
├── settings/               # Configuration templates
│   ├── global/            # Global settings
│   ├── project-templates/ # Project-specific templates
│   └── environments/      # Environment configs
├── mcp-servers/           # MCP server configurations
│   ├── configs/          # Server config files
│   └── scripts/          # Setup scripts
├── hooks/                 # Automation hooks
│   ├── pre-commit/       # Pre-commit hooks
│   ├── post-commit/      # Post-commit hooks
│   ├── tool/             # Tool-specific hooks
│   └── custom/           # Custom hooks
├── templates/             # Document templates
│   └── CLAUDE.md         # Project instruction template
├── scripts/               # Utility scripts
│   ├── setup.sh          # Installation script
│   ├── sync.sh           # Sync configurations
│   └── backup.sh         # Backup management
├── examples/              # Example projects
│   ├── projects/         # Sample projects
│   └── workflows/        # Workflow examples
└── docs/                  # Documentation
```

## Available Agents

### Development Agents
- **go-expert**: Go programming specialist
- **go-test-specialist**: Go testing expert
- **meta-agent**: Creates new agent configurations

### Operations Agents
- **github-ops-specialist**: GitHub operations expert
- **azure-cloud-architect**: Azure cloud solutions architect
- **security-specialist**: Security and vulnerability specialist
- **work-summary-agent**: Work summary generator

### Product Agents
- **prd-writer**: Product requirements document creator
- **requirements-verifier**: Requirements validation
- **qa-testing-coordinator**: Testing orchestration

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

### Azure Integration
```json
{
  "name": "azure",
  "capabilities": [
    "documentation",
    "resource_management",
    "monitoring"
  ]
}
```

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

- [ ] GUI configuration tool
- [ ] Cloud sync support
- [ ] Agent marketplace
- [ ] Advanced profile management
- [ ] Integration with more MCP servers
- [ ] Automated testing for agents
- [ ] Performance profiling tools
- [ ] Multi-language support

---

**Version**: 1.0.0  
**Last Updated**: January 2025  
**Maintainer**: Your Name

Built with ❤️ for the Claude Code community