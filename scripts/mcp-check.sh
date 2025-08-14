#!/bin/bash

# MCP Server Readiness Checker
# Verifies MCP server configuration and environment

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}    MCP Server Readiness Check${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}"

# Azure MCP Check
echo -e "\n${YELLOW}🔷 Azure MCP Server${NC}"
echo "─────────────────────"

AZURE_READY=true
if [ -z "$AZURE_SUBSCRIPTION_ID" ]; then
    echo -e "${RED}✗${NC} AZURE_SUBSCRIPTION_ID not set"
    AZURE_READY=false
else
    echo -e "${GREEN}✓${NC} AZURE_SUBSCRIPTION_ID: ${AZURE_SUBSCRIPTION_ID:0:8}..."
fi

if [ -z "$AZURE_TENANT_ID" ]; then
    echo -e "${RED}✗${NC} AZURE_TENANT_ID not set"
    AZURE_READY=false
else
    echo -e "${GREEN}✓${NC} AZURE_TENANT_ID: ${AZURE_TENANT_ID:0:8}..."
fi

if [ -z "$AZURE_CLIENT_ID" ]; then
    echo -e "${RED}✗${NC} AZURE_CLIENT_ID not set"
    AZURE_READY=false
else
    echo -e "${GREEN}✓${NC} AZURE_CLIENT_ID: ${AZURE_CLIENT_ID:0:8}..."
fi

if [ -z "$AZURE_CLIENT_SECRET" ]; then
    echo -e "${RED}✗${NC} AZURE_CLIENT_SECRET not set"
    AZURE_READY=false
else
    echo -e "${GREEN}✓${NC} AZURE_CLIENT_SECRET: [HIDDEN]"
fi

if [ "$AZURE_READY" = true ]; then
    echo -e "${GREEN}✓ Azure MCP Server is ready!${NC}"
    echo "Available tools: 50+ Azure management tools"
else
    echo -e "${RED}✗ Azure MCP Server is not configured${NC}"
    echo "To configure, add to your shell profile (~/.bashrc or ~/.zshrc):"
    echo "  export AZURE_SUBSCRIPTION_ID='your-subscription-id'"
    echo "  export AZURE_TENANT_ID='your-tenant-id'"
    echo "  export AZURE_CLIENT_ID='your-client-id'"
    echo "  export AZURE_CLIENT_SECRET='your-client-secret'"
fi

# GitHub MCP Check
echo -e "\n${YELLOW}🐙 GitHub MCP Server${NC}"
echo "─────────────────────"

if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "${RED}✗${NC} GITHUB_TOKEN not set"
    echo -e "${RED}✗ GitHub MCP Server is not configured${NC}"
    echo "To configure, add to your shell profile:"
    echo "  export GITHUB_TOKEN='your-github-personal-access-token'"
    echo "Create token at: https://github.com/settings/tokens"
    echo "Required scopes: repo, workflow, read:org"
else
    echo -e "${GREEN}✓${NC} GITHUB_TOKEN: ${GITHUB_TOKEN:0:7}..."
    echo -e "${GREEN}✓ GitHub MCP Server is ready!${NC}"
    echo "Available tools: Repository management, PRs, Issues, etc."
fi

# Configuration files check
echo -e "\n${YELLOW}📁 Configuration Files${NC}"
echo "─────────────────────"

if [ -f "$HOME/.claude/mcp-servers/configs/azure.json" ]; then
    echo -e "${GREEN}✓${NC} Azure config exists"
else
    echo -e "${RED}✗${NC} Azure config missing"
fi

if [ -f "$HOME/.claude/mcp-servers/configs/github.json" ]; then
    echo -e "${GREEN}✓${NC} GitHub config exists"
else
    echo -e "${RED}✗${NC} GitHub config missing"
fi

# Summary
echo -e "\n${BLUE}════════════════════════════════════════${NC}"
if [ "$AZURE_READY" = true ] && [ -n "$GITHUB_TOKEN" ]; then
    echo -e "${GREEN}✓ All MCP servers are configured!${NC}"
else
    echo -e "${YELLOW}⚠ Some MCP servers need configuration${NC}"
    echo "See ~/.claude/MCP_SETUP.md for detailed instructions"
fi