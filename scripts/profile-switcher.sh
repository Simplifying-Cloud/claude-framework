#!/bin/bash

# Profile Switcher - Manage different Claude configurations
# Switch between personal, work, and client profiles

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
PROFILES_DIR="$CLAUDE_DIR/profiles"

function print_header() {
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}    Claude Profile Manager${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
}

function get_current_profile() {
    if [ -f "$SETTINGS_FILE" ]; then
        current=$(grep -o '"default": *"[^"]*"' "$SETTINGS_FILE" | cut -d'"' -f4)
        echo "$current"
    else
        echo "personal"
    fi
}

function list_profiles() {
    echo -e "\n${YELLOW}Available Profiles:${NC}"
    echo "─────────────────────"
    
    CURRENT=$(get_current_profile)
    
    echo -e "1) ${GREEN}personal${NC} - Personal projects and learning"
    if [ "$CURRENT" = "personal" ]; then
        echo "   ${GREEN}[ACTIVE]${NC}"
    fi
    
    echo -e "2) ${BLUE}work${NC} - Professional development"
    if [ "$CURRENT" = "work" ]; then
        echo "   ${GREEN}[ACTIVE]${NC}"
    fi
    
    echo -e "3) ${YELLOW}client${NC} - Client-specific configurations"
    if [ "$CURRENT" = "client" ]; then
        echo "   ${GREEN}[ACTIVE]${NC}"
    fi
}

function create_profile_configs() {
    mkdir -p "$PROFILES_DIR"
    
    # Create personal profile
    cat > "$PROFILES_DIR/personal.json" << 'EOF'
{
  "name": "personal",
  "description": "Personal projects and learning",
  "settings": {
    "temperature": 0.0,
    "max_tokens": 8192,
    "tools": {
      "parallel_execution": true,
      "max_parallel_calls": 10
    },
    "logging": {
      "level": "info"
    }
  },
  "preferred_agents": [
    "go-expert",
    "meta-agent",
    "framework-auditor"
  ]
}
EOF

    # Create work profile
    cat > "$PROFILES_DIR/work.json" << 'EOF'
{
  "name": "work",
  "description": "Professional development",
  "settings": {
    "temperature": 0.0,
    "max_tokens": 8192,
    "tools": {
      "parallel_execution": true,
      "max_parallel_calls": 15
    },
    "logging": {
      "level": "debug",
      "audit_security_events": true
    },
    "security": {
      "disable_dangerous_commands": true
    }
  },
  "preferred_agents": [
    "azure-cloud-architect",
    "security-specialist",
    "github-ops-specialist",
    "documentation-maintainer"
  ]
}
EOF

    # Create client profile
    cat > "$PROFILES_DIR/client.json" << 'EOF'
{
  "name": "client",
  "description": "Client-specific configurations",
  "settings": {
    "temperature": 0.0,
    "max_tokens": 8192,
    "tools": {
      "parallel_execution": true,
      "max_parallel_calls": 20
    },
    "logging": {
      "level": "info",
      "audit_security_events": true
    },
    "security": {
      "disable_dangerous_commands": true,
      "require_confirmation": [
        "rm -rf",
        "git push --force",
        "DROP TABLE",
        "DELETE FROM"
      ]
    }
  },
  "preferred_agents": [
    "prd-writer",
    "requirements-verifier",
    "qa-testing-coordinator",
    "stakeholder-alignment-coordinator"
  ]
}
EOF
}

function switch_profile() {
    local profile=$1
    
    echo -e "\n${YELLOW}Switching to $profile profile...${NC}"
    
    # Update settings.json
    if [ -f "$SETTINGS_FILE" ]; then
        # Update the default profile
        sed -i.bak "s/\"default\": \"[^\"]*\"/\"default\": \"$profile\"/" "$SETTINGS_FILE"
        echo -e "${GREEN}✓ Profile switched to: $profile${NC}"
        
        # Show profile details
        if [ -f "$PROFILES_DIR/$profile.json" ]; then
            echo -e "\n${CYAN}Profile Configuration:${NC}"
            grep "preferred_agents" -A 10 "$PROFILES_DIR/$profile.json" | head -15
        fi
    else
        echo -e "${RED}Settings file not found${NC}"
    fi
}

function show_profile_details() {
    local profile=$1
    
    if [ -f "$PROFILES_DIR/$profile.json" ]; then
        echo -e "\n${CYAN}Profile: $profile${NC}"
        echo "─────────────────────"
        cat "$PROFILES_DIR/$profile.json" | python3 -m json.tool | head -30
    else
        echo -e "${YELLOW}Profile configuration not found. Creating...${NC}"
        create_profile_configs
        show_profile_details "$profile"
    fi
}

# Initialize profiles if they don't exist
if [ ! -d "$PROFILES_DIR" ]; then
    create_profile_configs
fi

# Main menu
print_header
echo -e "\nCurrent profile: ${GREEN}$(get_current_profile)${NC}"

echo -e "\nOptions:"
echo "1) List profiles"
echo "2) Switch to personal"
echo "3) Switch to work"
echo "4) Switch to client"
echo "5) Show profile details"
echo "6) Exit"

read -p "Choice [1-6]: " choice

case $choice in
    1) list_profiles ;;
    2) switch_profile "personal" ;;
    3) switch_profile "work" ;;
    4) switch_profile "client" ;;
    5)
        read -p "Which profile? (personal/work/client): " profile
        show_profile_details "$profile"
        ;;
    6) exit 0 ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "\n${GREEN}✓ Profile management complete${NC}"