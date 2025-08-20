#!/bin/bash
# Claude Framework Setup Script
# Installs and configures the Claude Code framework

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$CLAUDE_HOME/backups/$(date +%Y%m%d_%H%M%S)"

# Functions
print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  Claude Framework Setup${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

check_dependencies() {
    echo "Checking dependencies..."
    
    local deps_missing=false
    
    # Check for required commands
    for cmd in git jq; do
        if ! command -v $cmd &> /dev/null; then
            print_error "$cmd is not installed"
            deps_missing=true
        else
            print_success "$cmd found"
        fi
    done
    
    if [ "$deps_missing" = true ]; then
        echo
        print_error "Please install missing dependencies and run again"
        exit 1
    fi
    
    echo
}

backup_existing() {
    if [ -d "$CLAUDE_HOME" ]; then
        print_warning "Existing Claude configuration found at $CLAUDE_HOME"
        read -p "Do you want to backup existing configuration? (y/n) " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Creating backup at $BACKUP_DIR..."
            mkdir -p "$BACKUP_DIR"
            
            # Backup existing configuration
            if [ -d "$CLAUDE_HOME/agents" ]; then
                cp -r "$CLAUDE_HOME/agents" "$BACKUP_DIR/" 2>/dev/null || true
            fi
            if [ -d "$CLAUDE_HOME/settings" ]; then
                cp -r "$CLAUDE_HOME/settings" "$BACKUP_DIR/" 2>/dev/null || true
            fi
            if [ -f "$CLAUDE_HOME/CLAUDE.md" ]; then
                cp "$CLAUDE_HOME/CLAUDE.md" "$BACKUP_DIR/" 2>/dev/null || true
            fi
            
            print_success "Backup created at $BACKUP_DIR"
        fi
    fi
    echo
}

create_directories() {
    echo "Creating Claude directories..."
    
    mkdir -p "$CLAUDE_HOME"/{agents,settings,mcp-servers,hooks,logs,backups}
    print_success "Created directory structure at $CLAUDE_HOME"
    
    echo
}

install_agents() {
    echo "Installing agents..."
    
    # Copy agents preserving directory structure
    if [ -d "$FRAMEWORK_DIR/agents" ]; then
        # Create agent subdirectories
        for subdir in development operations maintenance product security testing custom uncategorized; do
            if [ -d "$FRAMEWORK_DIR/agents/$subdir" ]; then
                mkdir -p "$CLAUDE_HOME/agents/$subdir"
                # Copy only .md files from each subdirectory
                find "$FRAMEWORK_DIR/agents/$subdir" -maxdepth 1 -name "*.md" -exec cp {} "$CLAUDE_HOME/agents/$subdir/" \; 2>/dev/null || true
            fi
        done
        
        # Copy any root-level .md files (but not directories)
        find "$FRAMEWORK_DIR/agents" -maxdepth 1 -name "*.md" -exec cp {} "$CLAUDE_HOME/agents/" \; 2>/dev/null || true
        
        print_success "Installed agent configurations"
    fi
    
    echo
}

install_settings() {
    echo "Installing settings..."
    
    # Copy settings
    if [ -d "$FRAMEWORK_DIR/settings" ]; then
        # Merge or install settings
        if [ -f "$CLAUDE_HOME/settings/settings.json" ]; then
            print_warning "Existing settings found, skipping..."
        else
            cp -r "$FRAMEWORK_DIR/settings/"* "$CLAUDE_HOME/settings/" 2>/dev/null || true
            print_success "Installed settings templates"
        fi
    fi
    
    # Apply global permissions to settings.local.json
    if [ -f "$FRAMEWORK_DIR/settings/global/settings.json" ]; then
        echo "Applying global permissions..."
        global_settings="$FRAMEWORK_DIR/settings/global/settings.json"
        local_settings="$CLAUDE_HOME/settings.local.json"
        
        # Extract permissions from global settings and create/update local settings
        if jq -e '.permissions' "$global_settings" > /dev/null 2>&1; then
            if [ -f "$local_settings" ]; then
                # Merge permissions into existing local settings
                jq --slurpfile global "$global_settings" \
                   '.permissions = $global[0].permissions' \
                   "$local_settings" > "$local_settings.tmp"
                mv "$local_settings.tmp" "$local_settings"
            else
                # Create new local settings with permissions from global
                jq '{permissions: .permissions}' "$global_settings" > "$local_settings"
            fi
            print_success "Applied global permissions to settings.local.json"
        fi
    fi
    
    echo
}

install_hooks() {
    echo "Installing hooks..."
    
    if [ -d "$FRAMEWORK_DIR/hooks" ]; then
        cp -r "$FRAMEWORK_DIR/hooks/"* "$CLAUDE_HOME/hooks/" 2>/dev/null || true
        # Make hooks executable
        find "$CLAUDE_HOME/hooks" -type f -name "*.sh" -exec chmod +x {} \;
        print_success "Installed hook scripts"
    fi
    
    echo
}

install_mcp_servers() {
    echo "Installing MCP server configurations..."
    
    if [ -d "$FRAMEWORK_DIR/mcp-servers" ]; then
        cp -r "$FRAMEWORK_DIR/mcp-servers/"* "$CLAUDE_HOME/mcp-servers/" 2>/dev/null || true
        print_success "Installed MCP server configs"
    fi
    
    echo
}

setup_environment() {
    echo "Setting up environment..."
    
    # Add to shell profile if not already present
    SHELL_PROFILE=""
    if [ -f "$HOME/.bashrc" ]; then
        SHELL_PROFILE="$HOME/.bashrc"
    elif [ -f "$HOME/.zshrc" ]; then
        SHELL_PROFILE="$HOME/.zshrc"
    elif [ -f "$HOME/.profile" ]; then
        SHELL_PROFILE="$HOME/.profile"
    fi
    
    if [ -n "$SHELL_PROFILE" ]; then
        if ! grep -q "CLAUDE_HOME" "$SHELL_PROFILE"; then
            echo "" >> "$SHELL_PROFILE"
            echo "# Claude Framework" >> "$SHELL_PROFILE"
            echo "export CLAUDE_HOME=\"$CLAUDE_HOME\"" >> "$SHELL_PROFILE"
            echo "export PATH=\"\$PATH:$FRAMEWORK_DIR/scripts\"" >> "$SHELL_PROFILE"
            print_success "Added environment variables to $SHELL_PROFILE"
        else
            print_warning "Environment variables already configured"
        fi
    fi
    
    echo
}

install_profile() {
    echo "Select installation profile:"
    echo "  1) Personal - For individual projects"
    echo "  2) Work - For professional/company projects"
    echo "  3) Full - Install everything"
    echo "  4) Custom - Choose components"
    
    read -p "Select profile (1-4): " -n 1 -r
    echo
    echo
    
    case $REPLY in
        1)
            print_success "Installing Personal profile..."
            # Install specific components for personal use
            ;;
        2)
            print_success "Installing Work profile..."
            # Install work-specific components
            ;;
        3)
            print_success "Installing Full profile..."
            # Install everything
            ;;
        4)
            print_success "Custom installation selected..."
            # Allow user to choose components
            ;;
        *)
            print_warning "Invalid selection, installing default profile..."
            ;;
    esac
    
    echo
}

create_example_project() {
    echo "Creating example project..."
    
    if [ -d "$FRAMEWORK_DIR/examples" ]; then
        mkdir -p "$CLAUDE_HOME/examples"
        cp -r "$FRAMEWORK_DIR/examples/"* "$CLAUDE_HOME/examples/" 2>/dev/null || true
        print_success "Created example projects"
    fi
    
    echo
}

print_completion() {
    echo
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  Installation Complete!${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo
    echo "Claude Framework has been installed to: $CLAUDE_HOME"
    echo
    echo "Next steps:"
    echo "  1. Reload your shell: source $SHELL_PROFILE"
    echo "  2. Configure your settings: $CLAUDE_HOME/settings/settings.json"
    echo "  3. Set up environment variables for MCP servers"
    echo "  4. Review agent configurations: $CLAUDE_HOME/agents/"
    echo "  5. Customize hooks: $CLAUDE_HOME/hooks/"
    echo
    echo "For more information, see: $FRAMEWORK_DIR/README.md"
    echo
}

# Main installation flow
main() {
    print_header
    check_dependencies
    backup_existing
    create_directories
    install_profile
    install_agents
    install_settings
    install_hooks
    install_mcp_servers
    setup_environment
    create_example_project
    print_completion
}

# Run main function
main "$@"