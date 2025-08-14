#!/bin/bash

# Claude Framework Maintenance Script
# Automates regular maintenance tasks

set -e

FRAMEWORK_DIR="$HOME/Documents/code/claude-framework"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

function print_header() {
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}    Claude Framework Maintenance${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
}

function check_sync_status() {
    echo -e "\n${YELLOW}📊 Checking Sync Status...${NC}"
    cd "$FRAMEWORK_DIR"
    ./scripts/sync.sh status | head -20
}

function run_validation() {
    echo -e "\n${YELLOW}✓ Running Validation...${NC}"
    cd "$FRAMEWORK_DIR"
    ./scripts/validate.sh | grep -E "✓|✗" | head -20
}

function create_backup() {
    echo -e "\n${YELLOW}💾 Creating Backup...${NC}"
    cd "$FRAMEWORK_DIR"
    BACKUP_NAME="maintenance-$(date +%Y%m%d)"
    ./scripts/backup.sh create --name "$BACKUP_NAME"
}

function analyze_performance() {
    echo -e "\n${YELLOW}📈 Performance Metrics...${NC}"
    if [ -f "$CLAUDE_DIR/analytics/sessions.csv" ]; then
        echo "Recent sessions:"
        tail -5 "$CLAUDE_DIR/analytics/sessions.csv" | column -t -s,
    else
        echo "No performance data yet. Run a session first."
    fi
}

function check_agent_count() {
    echo -e "\n${YELLOW}🤖 Agent Status...${NC}"
    AGENT_COUNT=$(find "$CLAUDE_DIR/agents" -name "*.md" -type f | wc -l)
    echo "Total agents installed: $AGENT_COUNT"
    echo "Categories:"
    for dir in "$CLAUDE_DIR/agents"/*/; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            count=$(find "$dir" -name "*.md" -type f | wc -l)
            echo "  - $dirname: $count agents"
        fi
    done
}

function cleanup_old_backups() {
    echo -e "\n${YELLOW}🧹 Cleaning Old Backups...${NC}"
    cd "$FRAMEWORK_DIR"
    ./scripts/backup.sh clean
}

# Main menu
print_header
echo -e "\nSelect maintenance tasks:"
echo "1) Quick Health Check (sync status + validation)"
echo "2) Full Maintenance (all tasks + backup)"
echo "3) Performance Review"
echo "4) Sync Framework"
echo "5) Clean Up (remove old backups)"
echo "6) Exit"

read -p "Choice [1-6]: " choice

case $choice in
    1)
        check_sync_status
        run_validation
        check_agent_count
        ;;
    2)
        check_sync_status
        run_validation
        create_backup
        check_agent_count
        analyze_performance
        cleanup_old_backups
        ;;
    3)
        analyze_performance
        ;;
    4)
        cd "$FRAMEWORK_DIR"
        ./scripts/sync.sh pull
        ;;
    5)
        cleanup_old_backups
        ;;
    6)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}✓ Maintenance complete!${NC}"