#!/bin/bash

# Script to clean up Azure resources
# WARNING: This will delete resources!

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to list resource groups
list_resource_groups() {
    print_info "Listing all resource groups..."
    az group list --output table
}

# Function to delete resource group
delete_resource_group() {
    local rg_name=$1
    
    print_warning "This will DELETE the resource group: $rg_name"
    print_warning "All resources in this group will be permanently deleted!"
    
    read -p "Are you sure? (yes/no): " confirmation
    
    if [ "$confirmation" = "yes" ]; then
        print_info "Deleting resource group: $rg_name"
        az group delete --name "$rg_name" --yes --no-wait
        print_info "✓ Deletion initiated (running in background)"
    else
        print_info "Deletion cancelled"
    fi
}

# Function to show deployment history
show_deployments() {
    local rg_name=$1
    
    print_info "Showing deployments for: $rg_name"
    az deployment group list \
        --resource-group "$rg_name" \
        --output table \
        --query "[].{Name:name, State:properties.provisioningState, Timestamp:properties.timestamp}"
}

# Main menu
main() {
    print_warning "=== Azure Resource Cleanup Tool ==="
    
    if ! az account show &> /dev/null; then
        print_info "Logging in to Azure..."
        az login
    fi
    
    while true; do
        echo ""
        echo "1. List all resource groups"
        echo "2. Show deployment history"
        echo "3. Delete a resource group"
        echo "4. Delete all resource groups (BE CAREFUL!)"
        echo "0. Exit"
        echo ""
        read -p "Enter your choice: " choice
        
        case $choice in
            1)
                list_resource_groups
                ;;
            2)
                read -p "Enter resource group name: " rg_name
                show_deployments "$rg_name"
                ;;
            3)
                read -p "Enter resource group name to delete: " rg_name
                delete_resource_group "$rg_name"
                ;;
            4)
                print_error "DANGER: This will delete ALL resource groups!"
                read -p "Type 'DELETE ALL' to confirm: " confirmation
                if [ "$confirmation" = "DELETE ALL" ]; then
                    az group list --query "[].name" -o tsv | while read -r rg; do
                        print_info "Deleting: $rg"
                        az group delete --name "$rg" --yes --no-wait
                    done
                    print_info "All deletions initiated"
                else
                    print_info "Cancelled"
                fi
                ;;
            0)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid choice"
                ;;
        esac
    done
}

main
