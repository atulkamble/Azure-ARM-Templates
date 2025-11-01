#!/bin/bash

# Script to validate ARM templates
# This script checks ARM templates for syntax errors and best practices

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to validate a single template
validate_template() {
    local template_file=$1
    
    print_info "Validating: $template_file"
    
    # Check if file exists
    if [ ! -f "$template_file" ]; then
        print_error "File not found: $template_file"
        return 1
    fi
    
    # Validate JSON syntax
    if ! jq empty "$template_file" 2>/dev/null; then
        print_error "Invalid JSON syntax in $template_file"
        return 1
    fi
    
    # Check required properties
    if ! jq -e '.["$schema"]' "$template_file" > /dev/null; then
        print_error "Missing \$schema property in $template_file"
        return 1
    fi
    
    if ! jq -e '.contentVersion' "$template_file" > /dev/null; then
        print_error "Missing contentVersion property in $template_file"
        return 1
    fi
    
    if ! jq -e '.resources' "$template_file" > /dev/null; then
        print_error "Missing resources property in $template_file"
        return 1
    fi
    
    print_info "✓ $template_file is valid"
    return 0
}

# Main script
main() {
    print_info "=== ARM Template Validation Script ==="
    
    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed. Please install it first."
        print_info "macOS: brew install jq"
        print_info "Ubuntu: sudo apt-get install jq"
        exit 1
    fi
    
    # Get directory to validate
    if [ -z "$1" ]; then
        read -p "Enter directory or file to validate: " TARGET
    else
        TARGET=$1
    fi
    
    # Validate
    if [ -f "$TARGET" ]; then
        validate_template "$TARGET"
    elif [ -d "$TARGET" ]; then
        print_info "Validating all JSON files in: $TARGET"
        find "$TARGET" -name "*.json" -type f | while read -r file; do
            validate_template "$file"
        done
    else
        print_error "Invalid path: $TARGET"
        exit 1
    fi
    
    print_info "=== Validation Complete ==="
}

main "$@"
