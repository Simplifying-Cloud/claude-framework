#!/bin/bash
# Safe deployment script for Claude Framework agents
# Prevents duplicate agent installations

set -e

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_SOURCE="$FRAMEWORK_DIR/agents"
AGENTS_TARGET="$CLAUDE_HOME/agents"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Claude Framework Agent Deployment${NC}"
echo "=================================="
echo

# Check source directory
if [ ! -d "$AGENTS_SOURCE" ]; then
    echo "Error: No agents directory found at $AGENTS_SOURCE"
    exit 1
fi

# Backup existing agents if present
if [ -d "$AGENTS_TARGET" ]; then
    BACKUP_DIR="$CLAUDE_HOME/backups/agents_$(date +%Y%m%d_%H%M%S)"
    echo "Backing up existing agents to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    cp -r "$AGENTS_TARGET" "$BACKUP_DIR/"
    echo -e "${GREEN}✓${NC} Backup created"
    echo
fi

# Create target directory structure
echo "Creating agent directory structure..."
mkdir -p "$AGENTS_TARGET"

# Deploy agents by category (no duplicates)
deployed_count=0
categories=()

for category_dir in "$AGENTS_SOURCE"/*/; do
    if [ -d "$category_dir" ]; then
        category=$(basename "$category_dir")
        
        # Skip backup directories
        if [[ "$category" == *.backup.* ]]; then
            continue
        fi
        
        # Create category directory
        mkdir -p "$AGENTS_TARGET/$category"
        
        # Copy agent files
        agent_count=0
        for agent_file in "$category_dir"*.md; do
            if [ -f "$agent_file" ]; then
                cp "$agent_file" "$AGENTS_TARGET/$category/"
                agent_count=$((agent_count + 1))
                deployed_count=$((deployed_count + 1))
            fi
        done
        
        if [ $agent_count -gt 0 ]; then
            echo -e "  ${GREEN}✓${NC} $category: $agent_count agents"
            categories+=("$category")
        fi
    fi
done

# Deploy any root-level agents (uncategorized)
root_count=0
for agent_file in "$AGENTS_SOURCE"/*.md; do
    if [ -f "$agent_file" ]; then
        cp "$agent_file" "$AGENTS_TARGET/"
        root_count=$((root_count + 1))
        deployed_count=$((deployed_count + 1))
    fi
done

if [ $root_count -gt 0 ]; then
    echo -e "  ${GREEN}✓${NC} uncategorized: $root_count agents"
fi

echo
echo -e "${GREEN}Deployment Complete!${NC}"
echo "===================="
echo "Total agents deployed: $deployed_count"
echo "Location: $AGENTS_TARGET"

# Verify no duplicates
echo
echo "Verifying deployment..."
duplicate_check=$(cd "$AGENTS_TARGET" && find . -name "*.md" -exec basename {} \; | sort | uniq -d | wc -l)

if [ "$duplicate_check" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No duplicate agents found"
else
    echo -e "${YELLOW}⚠${NC} Warning: Found duplicate agents. Run clean-local-agents.sh to fix."
fi

echo
echo "Agent deployment successful!"