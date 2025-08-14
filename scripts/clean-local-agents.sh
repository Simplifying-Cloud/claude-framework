#!/bin/bash
# Clean up duplicate agents in local Claude settings
# Reorganizes ~/.claude/agents to remove duplicates

set -e

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
AGENTS_DIR="$CLAUDE_HOME/agents"
BACKUP_DIR="$CLAUDE_HOME/backups/agents_cleanup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "Cleaning up duplicate agents in local Claude settings..."
echo

# Check if agents directory exists
if [ ! -d "$AGENTS_DIR" ]; then
    echo -e "${RED}✗${NC} No agents directory found at $AGENTS_DIR"
    exit 1
fi

# Create backup
echo "Creating backup at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"
cp -r "$AGENTS_DIR" "$BACKUP_DIR/"
echo -e "${GREEN}✓${NC} Backup created"
echo

# Count current agents
total_before=$(find "$AGENTS_DIR" -name "*.md" -type f | wc -l)
echo "Current state:"
echo "  Total agent files: $total_before"

# Find and remove duplicates
echo
echo "Analyzing for duplicates..."

# Build a list of all unique agents (keeping categorized ones)
declare -A agent_locations
duplicates_found=0

# First pass: record all agent locations
while IFS= read -r agent_file; do
    basename_agent=$(basename "$agent_file")
    dirname_agent=$(dirname "$agent_file")
    
    if [[ -v agent_locations["$basename_agent"] ]]; then
        # Duplicate found
        duplicates_found=$((duplicates_found + 1))
        echo -e "${YELLOW}⚠${NC} Duplicate found: $basename_agent"
        echo "    Location 1: ${agent_locations[$basename_agent]}"
        echo "    Location 2: $agent_file"
        
        # Keep the one in a subdirectory (categorized), remove root-level one
        if [[ "$dirname_agent" == "$AGENTS_DIR" ]]; then
            # This is a root-level file, remove it
            echo "    Removing root-level duplicate: $agent_file"
            rm "$agent_file"
        elif [[ "${agent_locations[$basename_agent]}" == "$AGENTS_DIR/"* ]] && 
             [[ "${agent_locations[$basename_agent]}" == "$AGENTS_DIR/"*.md ]]; then
            # The stored one is root-level, remove it
            stored_dir=$(dirname "${agent_locations[$basename_agent]}")
            if [[ "$stored_dir" == "$AGENTS_DIR" ]]; then
                echo "    Removing root-level duplicate: ${agent_locations[$basename_agent]}"
                rm "${agent_locations[$basename_agent]}"
                agent_locations["$basename_agent"]="$agent_file"
            fi
        fi
    else
        agent_locations["$basename_agent"]="$agent_file"
    fi
done < <(find "$AGENTS_DIR" -name "*.md" -type f)

# Clean up any YAML files that might have been left from conversion
yaml_count=$(find "$AGENTS_DIR" -name "*.yaml" -o -name "*.yml" | wc -l)
if [ "$yaml_count" -gt 0 ]; then
    echo
    echo "Removing $yaml_count old YAML files..."
    find "$AGENTS_DIR" -name "*.yaml" -o -name "*.yml" -exec rm {} \;
fi

# Final count
echo
total_after=$(find "$AGENTS_DIR" -name "*.md" -type f | wc -l)
echo -e "${GREEN}Cleanup complete!${NC}"
echo
echo "Summary:"
echo "  Agents before: $total_before"
echo "  Agents after: $total_after"
echo "  Duplicates removed: $((total_before - total_after))"

# Show final structure
echo
echo "Final agent structure:"
for dir in "$AGENTS_DIR"/*; do
    if [ -d "$dir" ]; then
        category=$(basename "$dir")
        count=$(find "$dir" -name "*.md" | wc -l)
        if [ "$count" -gt 0 ]; then
            echo "  - $category: $count agents"
        fi
    fi
done

# Count root-level agents
root_count=$(find "$AGENTS_DIR" -maxdepth 1 -name "*.md" | wc -l)
if [ "$root_count" -gt 0 ]; then
    echo "  - root level: $root_count agents"
fi

echo
echo -e "${GREEN}✓${NC} Local agents cleaned successfully!"
echo "Backup saved at: $BACKUP_DIR"