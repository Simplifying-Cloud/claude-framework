#!/bin/bash

# Agent Launcher - Quick access to specialized agents
# Provides examples and easy launching of agents

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

function print_header() {
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}    Claude Agent Launcher${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
}

function list_agents() {
    echo -e "\n${YELLOW}Available Agents by Category:${NC}\n"
    
    echo -e "${CYAN}Development:${NC}"
    echo "  • go-expert - Go architecture, best practices, performance"
    echo "  • go-test-specialist - Go testing, mocking, test coverage"
    echo "  • meta-agent - Generate new agent configurations"
    echo "  • agent-generator - Create agent config files"
    
    echo -e "\n${CYAN}Operations:${NC}"
    echo "  • azure-cloud-architect - Azure design, CAF, security"
    echo "  • github-ops-specialist - GitHub repos, PRs, issues"
    echo "  • security-specialist - Security vulnerabilities, auth"
    echo "  • performance-auditor - Performance analysis, optimization"
    echo "  • filesystem-orchestrator - Complex file operations"
    echo "  • work-summary-agent - Session summaries"
    
    echo -e "\n${CYAN}Maintenance:${NC}"
    echo "  • framework-auditor - Framework consistency checking"
    echo "  • documentation-maintainer - Doc synchronization"
    echo "  • config-migration-specialist - Version migrations"
    
    echo -e "\n${CYAN}Security:${NC}"
    echo "  • secret-scanner-specialist - Secret detection, removal"
    
    echo -e "\n${CYAN}Testing:${NC}"
    echo "  • test-automation-engineer - Test suite creation"
}

function show_examples() {
    echo -e "\n${YELLOW}Example Agent Usage:${NC}\n"
    
    echo -e "${GREEN}1. Go Development:${NC}"
    echo "   Task: 'Write a REST API in Go'"
    echo "   Agent: go-expert"
    echo "   Command: Use Task tool with go-expert to design and implement"
    
    echo -e "\n${GREEN}2. Security Review:${NC}"
    echo "   Task: 'Review code for security vulnerabilities'"
    echo "   Agent: security-specialist"
    echo "   Command: Use Task tool with security-specialist to scan"
    
    echo -e "\n${GREEN}3. Azure Architecture:${NC}"
    echo "   Task: 'Design Azure infrastructure for web app'"
    echo "   Agent: azure-cloud-architect"
    echo "   Command: Use Task tool with azure-cloud-architect"
    
    echo -e "\n${GREEN}4. GitHub Operations:${NC}"
    echo "   Task: 'Create PR with multiple commits'"
    echo "   Agent: github-ops-specialist"
    echo "   Command: Use Task tool with github-ops-specialist"
    
    echo -e "\n${GREEN}5. Performance Analysis:${NC}"
    echo "   Task: 'Analyze session performance'"
    echo "   Agent: performance-auditor"
    echo "   Command: Use Task tool with performance-auditor"
}

function agent_tips() {
    echo -e "\n${YELLOW}Pro Tips:${NC}\n"
    echo "1. Always use specialized agents for their domains"
    echo "2. Launch multiple agents in parallel for complex tasks"
    echo "3. Chain agent outputs for workflows"
    echo "4. Use work-summary-agent after completing tasks"
    echo "5. Run framework-auditor regularly for consistency"
}

function quick_launch() {
    echo -e "\n${YELLOW}Quick Launch Commands:${NC}\n"
    echo "For Go development:"
    echo -e "  ${CYAN}Task: go-expert 'implement REST API with authentication'${NC}"
    echo ""
    echo "For security review:"
    echo -e "  ${CYAN}Task: security-specialist 'scan for vulnerabilities'${NC}"
    echo ""
    echo "For Azure tasks:"
    echo -e "  ${CYAN}Task: azure-cloud-architect 'design scalable architecture'${NC}"
    echo ""
    echo "For test creation:"
    echo -e "  ${CYAN}Task: test-automation-engineer 'create comprehensive test suite'${NC}"
}

# Main menu
print_header
echo -e "\nOptions:"
echo "1) List all agents"
echo "2) Show usage examples"
echo "3) Quick launch commands"
echo "4) Agent tips"
echo "5) Show all"

read -p "Choice [1-5]: " choice

case $choice in
    1) list_agents ;;
    2) show_examples ;;
    3) quick_launch ;;
    4) agent_tips ;;
    5) 
        list_agents
        show_examples
        quick_launch
        agent_tips
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo -e "\n${GREEN}Ready to use agents!${NC}"
echo "Remember: Use the Task tool in Claude to launch agents"