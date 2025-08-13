#!/bin/bash
# Claude Framework Backup Script
# Creates timestamped backups of Claude configurations

set -e

# Configuration
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
BACKUP_ROOT="${BACKUP_ROOT:-$CLAUDE_HOME/backups}"
MAX_BACKUPS="${MAX_BACKUPS:-10}"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
usage() {
    cat << EOF
Usage: $0 [command] [options]

Commands:
    create      Create a new backup
    restore     Restore from a backup
    list        List available backups
    clean       Remove old backups (keeps last $MAX_BACKUPS)
    export      Export backup to archive
    import      Import backup from archive

Options:
    -n, --name      Backup name/description
    -t, --tag       Tag for categorization
    -c, --compress  Compress backup
    -h, --help      Show this help message

Examples:
    $0 create --name "before-update"
    $0 restore 20240112_143022
    $0 list
    $0 export --compress

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

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

create_backup() {
    local backup_name="${1:-backup}"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$BACKUP_ROOT/${timestamp}_${backup_name}"
    
    echo "Creating backup: $backup_dir"
    mkdir -p "$backup_dir"
    
    # Create metadata file
    cat > "$backup_dir/metadata.json" << EOF
{
    "timestamp": "$timestamp",
    "name": "$backup_name",
    "date": "$(date -Iseconds)",
    "user": "$USER",
    "hostname": "$(hostname)",
    "claude_home": "$CLAUDE_HOME",
    "version": "1.0.0"
}
EOF
    
    # Backup components
    echo "Backing up configurations..."
    
    # Agents
    if [ -d "$CLAUDE_HOME/agents" ]; then
        cp -r "$CLAUDE_HOME/agents" "$backup_dir/"
        print_success "Agents backed up"
    fi
    
    # Settings
    if [ -d "$CLAUDE_HOME/settings" ]; then
        cp -r "$CLAUDE_HOME/settings" "$backup_dir/"
        print_success "Settings backed up"
    fi
    
    # MCP Servers
    if [ -d "$CLAUDE_HOME/mcp-servers" ]; then
        cp -r "$CLAUDE_HOME/mcp-servers" "$backup_dir/"
        print_success "MCP servers backed up"
    fi
    
    # Hooks
    if [ -d "$CLAUDE_HOME/hooks" ]; then
        cp -r "$CLAUDE_HOME/hooks" "$backup_dir/"
        print_success "Hooks backed up"
    fi
    
    # CLAUDE.md
    if [ -f "$CLAUDE_HOME/CLAUDE.md" ]; then
        cp "$CLAUDE_HOME/CLAUDE.md" "$backup_dir/"
        print_success "CLAUDE.md backed up"
    fi
    
    # Calculate size
    size=$(du -sh "$backup_dir" | cut -f1)
    print_info "Backup size: $size"
    
    print_success "Backup created successfully: ${timestamp}_${backup_name}"
    echo "$backup_dir"
}

list_backups() {
    echo -e "${BLUE}Available Backups:${NC}"
    echo "=================="
    
    if [ ! -d "$BACKUP_ROOT" ] || [ -z "$(ls -A "$BACKUP_ROOT" 2>/dev/null)" ]; then
        print_warning "No backups found"
        return
    fi
    
    # List backups with details
    for backup in "$BACKUP_ROOT"/*; do
        if [ -d "$backup" ]; then
            backup_name=$(basename "$backup")
            
            # Read metadata if available
            if [ -f "$backup/metadata.json" ]; then
                name=$(jq -r '.name // "unknown"' "$backup/metadata.json" 2>/dev/null || echo "unknown")
                date=$(jq -r '.date // "unknown"' "$backup/metadata.json" 2>/dev/null || echo "unknown")
                size=$(du -sh "$backup" | cut -f1)
                
                echo "  $backup_name"
                echo "    Name: $name"
                echo "    Date: $date"
                echo "    Size: $size"
            else
                size=$(du -sh "$backup" | cut -f1)
                echo "  $backup_name (size: $size)"
            fi
            echo
        fi
    done
}

restore_backup() {
    local backup_id="$1"
    
    if [ -z "$backup_id" ]; then
        print_error "No backup ID specified"
        echo "Usage: $0 restore <backup-id>"
        list_backups
        exit 1
    fi
    
    # Find backup
    local backup_dir=""
    for dir in "$BACKUP_ROOT"/*; do
        if [[ "$(basename "$dir")" == *"$backup_id"* ]]; then
            backup_dir="$dir"
            break
        fi
    done
    
    if [ -z "$backup_dir" ] || [ ! -d "$backup_dir" ]; then
        print_error "Backup not found: $backup_id"
        exit 1
    fi
    
    echo "Restoring from: $(basename "$backup_dir")"
    
    # Create safety backup first
    print_info "Creating safety backup before restore..."
    create_backup "pre-restore-safety" > /dev/null
    
    # Restore components
    echo "Restoring configurations..."
    
    # Restore each component
    for component in agents settings mcp-servers hooks; do
        if [ -d "$backup_dir/$component" ]; then
            rm -rf "$CLAUDE_HOME/$component"
            cp -r "$backup_dir/$component" "$CLAUDE_HOME/"
            print_success "$component restored"
        fi
    done
    
    # Restore CLAUDE.md
    if [ -f "$backup_dir/CLAUDE.md" ]; then
        cp "$backup_dir/CLAUDE.md" "$CLAUDE_HOME/"
        print_success "CLAUDE.md restored"
    fi
    
    print_success "Restore complete!"
}

clean_backups() {
    echo "Cleaning old backups..."
    
    if [ ! -d "$BACKUP_ROOT" ]; then
        print_warning "No backup directory found"
        return
    fi
    
    # Count backups
    backup_count=$(find "$BACKUP_ROOT" -maxdepth 1 -type d | wc -l)
    backup_count=$((backup_count - 1))  # Exclude the root directory itself
    
    if [ $backup_count -le $MAX_BACKUPS ]; then
        print_info "Number of backups ($backup_count) within limit ($MAX_BACKUPS)"
        return
    fi
    
    # Remove oldest backups
    to_remove=$((backup_count - MAX_BACKUPS))
    print_warning "Removing $to_remove old backup(s)..."
    
    # Get oldest backups and remove them
    find "$BACKUP_ROOT" -maxdepth 1 -type d -printf '%T+ %p\n' | \
        sort | head -n $to_remove | cut -d' ' -f2 | \
        while read -r old_backup; do
            if [ "$old_backup" != "$BACKUP_ROOT" ]; then
                rm -rf "$old_backup"
                print_success "Removed: $(basename "$old_backup")"
            fi
        done
    
    print_success "Cleanup complete"
}

export_backup() {
    local compress="${1:-false}"
    local export_name="claude-backup-$(date +%Y%m%d_%H%M%S)"
    local export_file="$HOME/${export_name}.tar"
    
    echo "Exporting backups..."
    
    # Create tarball
    tar -cf "$export_file" -C "$CLAUDE_HOME" .
    
    if [ "$compress" = true ]; then
        echo "Compressing..."
        gzip "$export_file"
        export_file="${export_file}.gz"
    fi
    
    size=$(du -sh "$export_file" | cut -f1)
    print_success "Exported to: $export_file (size: $size)"
}

import_backup() {
    local import_file="$1"
    
    if [ ! -f "$import_file" ]; then
        print_error "Import file not found: $import_file"
        exit 1
    fi
    
    echo "Importing backup from: $import_file"
    
    # Create safety backup
    print_info "Creating safety backup before import..."
    create_backup "pre-import-safety" > /dev/null
    
    # Extract based on file type
    case "$import_file" in
        *.tar.gz|*.tgz)
            tar -xzf "$import_file" -C "$CLAUDE_HOME"
            ;;
        *.tar)
            tar -xf "$import_file" -C "$CLAUDE_HOME"
            ;;
        *)
            print_error "Unsupported file format. Use .tar or .tar.gz"
            exit 1
            ;;
    esac
    
    print_success "Import complete!"
}

# Parse arguments
COMMAND=""
NAME=""
TAG=""
COMPRESS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        create|restore|list|clean|export|import)
            COMMAND=$1
            shift
            ;;
        -n|--name)
            NAME=$2
            shift 2
            ;;
        -t|--tag)
            TAG=$2
            shift 2
            ;;
        -c|--compress)
            COMPRESS=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            # Could be backup ID for restore
            if [ "$COMMAND" = "restore" ] || [ "$COMMAND" = "import" ]; then
                ARG=$1
                shift
            else
                print_error "Unknown option: $1"
                usage
            fi
            ;;
    esac
done

# Execute command
case $COMMAND in
    create)
        create_backup "${NAME:-backup}"
        ;;
    restore)
        restore_backup "$ARG"
        ;;
    list)
        list_backups
        ;;
    clean)
        clean_backups
        ;;
    export)
        export_backup "$COMPRESS"
        ;;
    import)
        import_backup "$ARG"
        ;;
    *)
        print_error "No command specified"
        usage
        ;;
esac