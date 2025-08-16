#!/bin/bash
# Claude Framework Sync Script
# Syncs configurations between local and repository

set -e

# Configuration
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Functions
usage() {
    cat << EOF
Usage: $0 [command] [options]

Commands:
    push    Copy local configurations to repository
    pull    Copy repository configurations to local
    status  Show differences between local and repository
    merge   Intelligently merge configurations

Options:
    -f, --force     Force overwrite without prompting
    -b, --backup    Create backup before sync
    -p, --profile   Specify profile to sync (personal/work/custom)
    -h, --help      Show this help message

Examples:
    $0 push                 # Push local configs to repo
    $0 pull --backup        # Pull repo configs with backup
    $0 status               # Show configuration differences
    $0 merge --profile work # Merge work profile

EOF
    exit 0
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

check_directories() {
    if [ ! -d "$CLAUDE_HOME" ]; then
        print_error "Claude home directory not found: $CLAUDE_HOME"
        echo "Run setup.sh first to initialize the framework"
        exit 1
    fi
    
    if [ ! -d "$FRAMEWORK_DIR" ]; then
        print_error "Framework directory not found: $FRAMEWORK_DIR"
        exit 1
    fi
}

create_backup() {
    local backup_dir="$CLAUDE_HOME/backups/sync_$(date +%Y%m%d_%H%M%S)"
    echo "Creating backup at $backup_dir..."
    
    mkdir -p "$backup_dir"
    
    # Backup configurations
    for dir in agents settings mcp-servers hooks; do
        if [ -d "$CLAUDE_HOME/$dir" ]; then
            cp -r "$CLAUDE_HOME/$dir" "$backup_dir/" 2>/dev/null || true
        fi
    done
    
    if [ -f "$CLAUDE_HOME/CLAUDE.md" ]; then
        cp "$CLAUDE_HOME/CLAUDE.md" "$backup_dir/" 2>/dev/null || true
    fi
    
    print_success "Backup created"
}

sync_push() {
    echo "Pushing local configurations to repository..."
    
    # Sync agents
    if [ -d "$CLAUDE_HOME/agents" ]; then
        echo "Syncing agents..."
        rsync -av --delete \
            --exclude="*.tmp" \
            --exclude="*.bak" \
            "$CLAUDE_HOME/agents/" "$FRAMEWORK_DIR/agents/"
        print_success "Agents synced"
    fi
    
    # Sync settings (excluding sensitive data)
    if [ -d "$CLAUDE_HOME/settings" ]; then
        echo "Syncing settings..."
        for file in "$CLAUDE_HOME/settings/"*.json; do
            if [ -f "$file" ]; then
                # Remove sensitive data before copying
                jq 'del(.security.api_keys, .security.tokens, .security.passwords)' \
                    "$file" > "$FRAMEWORK_DIR/settings/$(basename "$file")"
            fi
        done
        print_success "Settings synced (sensitive data excluded)"
    fi
    
    # Sync hooks
    if [ -d "$CLAUDE_HOME/hooks" ]; then
        echo "Syncing hooks..."
        rsync -av "$CLAUDE_HOME/hooks/" "$FRAMEWORK_DIR/hooks/"
        print_success "Hooks synced"
    fi
    
    # Sync MCP servers
    if [ -d "$CLAUDE_HOME/mcp-servers" ]; then
        echo "Syncing MCP server configs..."
        rsync -av "$CLAUDE_HOME/mcp-servers/" "$FRAMEWORK_DIR/mcp-servers/"
        print_success "MCP configs synced"
    fi
    
    # Sync CLAUDE.md configuration
    if [ -f "$CLAUDE_HOME/CLAUDE.md" ]; then
        echo "Syncing CLAUDE.md configuration..."
        cp "$CLAUDE_HOME/CLAUDE.md" "$FRAMEWORK_DIR/CLAUDE.md"
        print_success "CLAUDE.md synced"
    fi
    
    print_success "Push complete!"
}

sync_pull() {
    echo "Pulling repository configurations to local..."
    
    # Pull agents
    if [ -d "$FRAMEWORK_DIR/agents" ]; then
        echo "Pulling agents..."
        rsync -av "$FRAMEWORK_DIR/agents/" "$CLAUDE_HOME/agents/"
        print_success "Agents pulled"
    fi
    
    # Pull settings
    if [ -d "$FRAMEWORK_DIR/settings" ]; then
        echo "Pulling settings..."
        for file in "$FRAMEWORK_DIR/settings/"*.json; do
            if [ -f "$file" ]; then
                target="$CLAUDE_HOME/settings/$(basename "$file")"
                if [ -f "$target" ]; then
                    # Merge settings, preserving local sensitive data
                    jq -s '.[0] * .[1]' "$target" "$file" > "$target.tmp"
                    mv "$target.tmp" "$target"
                else
                    cp "$file" "$target"
                fi
            fi
        done
        print_success "Settings pulled"
    fi
    
    # Pull hooks
    if [ -d "$FRAMEWORK_DIR/hooks" ]; then
        echo "Pulling hooks..."
        rsync -av "$FRAMEWORK_DIR/hooks/" "$CLAUDE_HOME/hooks/"
        # Make hooks executable
        find "$CLAUDE_HOME/hooks" -type f -name "*.sh" -exec chmod +x {} \;
        print_success "Hooks pulled"
    fi
    
    # Pull MCP servers
    if [ -d "$FRAMEWORK_DIR/mcp-servers" ]; then
        echo "Pulling MCP configs..."
        rsync -av "$FRAMEWORK_DIR/mcp-servers/" "$CLAUDE_HOME/mcp-servers/"
        print_success "MCP configs pulled"
    fi
    
    # Pull CLAUDE.md configuration
    if [ -f "$FRAMEWORK_DIR/CLAUDE.md" ]; then
        echo "Pulling CLAUDE.md configuration..."
        cp "$FRAMEWORK_DIR/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md"
        print_success "CLAUDE.md pulled"
    fi
    
    print_success "Pull complete!"
}

show_status() {
    echo "Configuration Status"
    echo "===================="
    echo
    
    # Compare directories
    for dir in agents settings hooks mcp-servers; do
        echo "Checking $dir..."
        
        if [ -d "$CLAUDE_HOME/$dir" ] && [ -d "$FRAMEWORK_DIR/$dir" ]; then
            diff_output=$(diff -qr "$CLAUDE_HOME/$dir" "$FRAMEWORK_DIR/$dir" 2>/dev/null || true)
            if [ -z "$diff_output" ]; then
                print_success "$dir is synchronized"
            else
                print_warning "$dir has differences:"
                echo "$diff_output" | sed 's/^/  /'
            fi
        elif [ -d "$CLAUDE_HOME/$dir" ]; then
            print_warning "$dir exists only locally"
        elif [ -d "$FRAMEWORK_DIR/$dir" ]; then
            print_warning "$dir exists only in repository"
        else
            print_error "$dir not found in either location"
        fi
        echo
    done
}

merge_configs() {
    echo "Merging configurations..."
    
    # Intelligent merge logic
    for dir in agents settings hooks mcp-servers; do
        if [ -d "$CLAUDE_HOME/$dir" ] && [ -d "$FRAMEWORK_DIR/$dir" ]; then
            echo "Merging $dir..."
            
            # For each file in repo
            for repo_file in "$FRAMEWORK_DIR/$dir"/*; do
                if [ -f "$repo_file" ]; then
                    local_file="$CLAUDE_HOME/$dir/$(basename "$repo_file")"
                    
                    if [ -f "$local_file" ]; then
                        # File exists in both - merge based on type
                        case "$repo_file" in
                            *.json)
                                # Merge JSON files
                                jq -s '.[0] * .[1]' "$local_file" "$repo_file" > "$local_file.tmp"
                                mv "$local_file.tmp" "$local_file"
                                ;;
                            *.yaml|*.yml)
                                # For YAML, prefer newer version
                                if [ "$repo_file" -nt "$local_file" ]; then
                                    cp "$repo_file" "$local_file"
                                fi
                                ;;
                            *)
                                # For other files, prompt user
                                print_warning "Conflict in $(basename "$repo_file")"
                                ;;
                        esac
                    else
                        # File only in repo - copy it
                        cp "$repo_file" "$local_file"
                    fi
                fi
            done
            
            print_success "$dir merged"
        fi
    done
    
    print_success "Merge complete!"
}

# Parse arguments
COMMAND=""
FORCE=false
BACKUP=false
PROFILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        push|pull|status|merge)
            COMMAND=$1
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -b|--backup)
            BACKUP=true
            shift
            ;;
        -p|--profile)
            PROFILE=$2
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            ;;
    esac
done

# Main execution
check_directories

if [ "$BACKUP" = true ]; then
    create_backup
fi

case $COMMAND in
    push)
        sync_push
        ;;
    pull)
        sync_pull
        ;;
    status)
        show_status
        ;;
    merge)
        merge_configs
        ;;
    *)
        print_error "No command specified"
        usage
        ;;
esac