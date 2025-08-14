#!/bin/bash
# Fix duplicate agents in Claude Framework
# This script reorganizes agents to prevent duplicates when deploying

set -e

FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="$FRAMEWORK_DIR/agents"
TEMP_DIR="$FRAMEWORK_DIR/agents_temp"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "Fixing duplicate agents in Claude Framework..."
echo

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Keep only the categorized agents (from subdirectories)
echo "Reorganizing agents..."

# Copy subdirectory agents to temp
for subdir in development operations maintenance product security testing custom; do
    if [ -d "$AGENTS_DIR/$subdir" ]; then
        echo "  Processing $subdir agents..."
        mkdir -p "$TEMP_DIR/$subdir"
        cp "$AGENTS_DIR/$subdir"/*.md "$TEMP_DIR/$subdir/" 2>/dev/null || true
    fi
done

# Copy any unique root-level agents that don't exist in subdirectories
echo "  Checking for unique root-level agents..."
for agent in "$AGENTS_DIR"/*.md; do
    if [ -f "$agent" ]; then
        basename_agent=$(basename "$agent")
        found=false
        
        # Check if this agent exists in any subdirectory
        for subdir in development operations maintenance product security testing custom; do
            if [ -f "$TEMP_DIR/$subdir/$basename_agent" ]; then
                found=true
                break
            fi
        done
        
        # If not found in any subdirectory, keep it in uncategorized
        if [ "$found" = "false" ]; then
            echo "    Keeping unique agent: $basename_agent"
            mkdir -p "$TEMP_DIR/uncategorized"
            cp "$agent" "$TEMP_DIR/uncategorized/"
        fi
    fi
done

# Backup original agents directory
echo
echo "Creating backup..."
mv "$AGENTS_DIR" "$AGENTS_DIR.backup.$(date +%Y%m%d_%H%M%S)"

# Move temp to agents
mv "$TEMP_DIR" "$AGENTS_DIR"

echo
echo -e "${GREEN}✓${NC} Agents reorganized successfully!"
echo

# Count agents
total_agents=$(find "$AGENTS_DIR" -name "*.md" | wc -l)
echo "Total agents: $total_agents"
echo
echo "Agent categories:"
for dir in "$AGENTS_DIR"/*/; do
    if [ -d "$dir" ]; then
        category=$(basename "$dir")
        count=$(find "$dir" -name "*.md" | wc -l)
        echo "  - $category: $count agents"
    fi
done

echo
echo -e "${YELLOW}Note:${NC} The setup.sh script will be updated to handle the new structure properly."