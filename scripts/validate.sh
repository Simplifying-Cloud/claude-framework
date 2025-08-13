#!/bin/bash
# Claude Framework Validation Script
# Comprehensive validation of all framework components

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
ERRORS=0
WARNINGS=0

# Functions
print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  Claude Framework Validation${NC}"
    echo -e "${BLUE}============================================${NC}"
    echo
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Validation Functions

validate_json_files() {
    echo "Validating JSON files..."
    
    for file in $(find "$FRAMEWORK_DIR" -name "*.json" 2>/dev/null); do
        if jq . "$file" > /dev/null 2>&1; then
            print_success "Valid JSON: $(basename "$file")"
        else
            print_error "Invalid JSON: $file"
        fi
    done
    echo
}

validate_yaml_files() {
    echo "Validating YAML files..."
    
    if command -v python3 &> /dev/null; then
        for file in $(find "$FRAMEWORK_DIR/agents" -name "*.yaml" -o -name "*.yml" 2>/dev/null); do
            if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
                print_success "Valid YAML: $(basename "$file")"
            else
                print_error "Invalid YAML: $file"
            fi
        done
    else
        print_warning "Python3 not found, skipping YAML validation"
    fi
    echo
}

validate_agent_structure() {
    echo "Validating agent configurations..."
    
    for agent in "$FRAMEWORK_DIR/agents"/**/*.yaml; do
        if [ -f "$agent" ]; then
            # Check required fields
            name=$(grep "^name:" "$agent" 2>/dev/null | head -1)
            desc=$(grep "^description:" "$agent" 2>/dev/null | head -1)
            tools=$(grep "^tools:" "$agent" 2>/dev/null | head -1)
            
            if [ -z "$name" ]; then
                print_error "Missing 'name' field in $(basename "$agent")"
            elif [ -z "$desc" ]; then
                print_error "Missing 'description' field in $(basename "$agent")"
            elif [ -z "$tools" ]; then
                print_warning "Missing 'tools' field in $(basename "$agent")"
            else
                print_success "Valid structure: $(basename "$agent")"
            fi
        fi
    done
    echo
}

validate_mcp_configs() {
    echo "Validating MCP server configurations..."
    
    for config in "$FRAMEWORK_DIR/mcp-servers/configs"/*.json; do
        if [ -f "$config" ]; then
            # Check for required fields using jq
            if command -v jq &> /dev/null; then
                name=$(jq -r '.name // empty' "$config" 2>/dev/null)
                server=$(jq -r '.server // empty' "$config" 2>/dev/null)
                
                if [ -z "$name" ]; then
                    print_error "Missing 'name' field in $(basename "$config")"
                elif [ -z "$server" ]; then
                    print_error "Missing 'server' field in $(basename "$config")"
                else
                    print_success "Valid MCP config: $(basename "$config")"
                fi
            fi
        fi
    done
    echo
}

validate_scripts() {
    echo "Validating shell scripts..."
    
    for script in "$FRAMEWORK_DIR/scripts"/*.sh; do
        if [ -f "$script" ]; then
            if bash -n "$script" 2>/dev/null; then
                print_success "Valid syntax: $(basename "$script")"
            else
                print_error "Syntax error in: $(basename "$script")"
            fi
            
            # Check if executable
            if [ ! -x "$script" ]; then
                print_warning "Not executable: $(basename "$script")"
            fi
        fi
    done
    echo
}

validate_directory_structure() {
    echo "Validating directory structure..."
    
    # Required directories
    required_dirs=(
        "agents"
        "mcp-servers"
        "settings"
        "scripts"
        "hooks"
        "templates"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$FRAMEWORK_DIR/$dir" ]; then
            print_success "Directory exists: $dir/"
        else
            print_error "Missing directory: $dir/"
        fi
    done
    echo
}

check_documentation_consistency() {
    echo "Checking documentation consistency..."
    
    # Check if README mentions existing directories
    if [ -f "$FRAMEWORK_DIR/README.md" ]; then
        # Check for common discrepancies
        if grep -q "examples/" "$FRAMEWORK_DIR/README.md" && [ ! -d "$FRAMEWORK_DIR/examples" ]; then
            print_warning "README mentions 'examples/' but directory doesn't exist"
        fi
        
        if grep -q "docs/" "$FRAMEWORK_DIR/README.md" && [ ! -d "$FRAMEWORK_DIR/docs" ]; then
            print_warning "README mentions 'docs/' but directory doesn't exist"
        fi
        
        print_info "Documentation check complete"
    else
        print_error "README.md not found"
    fi
    echo
}

validate_dependencies() {
    echo "Checking dependencies..."
    
    # Check for required commands
    commands=("git" "jq" "bash")
    
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            print_success "Found: $cmd"
        else
            print_warning "Missing optional dependency: $cmd"
        fi
    done
    
    # Check for optional but recommended commands
    optional=("python3" "npm" "go")
    
    for cmd in "${optional[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            print_info "Optional tool available: $cmd"
        fi
    done
    echo
}

# Main validation process
main() {
    print_header
    
    # Run all validations
    validate_directory_structure
    validate_json_files
    validate_yaml_files
    validate_agent_structure
    validate_mcp_configs
    validate_scripts
    check_documentation_consistency
    validate_dependencies
    
    # Summary
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  Validation Summary${NC}"
    echo -e "${BLUE}============================================${NC}"
    
    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}✓ All validations passed!${NC}"
        exit 0
    else
        if [ $ERRORS -gt 0 ]; then
            echo -e "${RED}Errors: $ERRORS${NC}"
        fi
        if [ $WARNINGS -gt 0 ]; then
            echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
        fi
        
        if [ $ERRORS -gt 0 ]; then
            echo -e "${RED}Validation failed with errors${NC}"
            exit 1
        else
            echo -e "${YELLOW}Validation passed with warnings${NC}"
            exit 0
        fi
    fi
}

# Handle arguments
case "${1:-}" in
    -h|--help)
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  -h, --help     Show this help message"
        echo "  -v, --verbose  Verbose output"
        echo "  -q, --quiet    Quiet mode (errors only)"
        echo ""
        echo "This script validates all Claude Framework components:"
        echo "  - Directory structure"
        echo "  - JSON configuration files"
        echo "  - YAML agent definitions"
        echo "  - Shell scripts syntax"
        echo "  - MCP server configurations"
        echo "  - Documentation consistency"
        exit 0
        ;;
    *)
        main
        ;;
esac