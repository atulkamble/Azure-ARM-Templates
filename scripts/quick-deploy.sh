#!/bin/bash

# Quick deployment script with common scenarios
# Usage: ./quick-deploy.sh [scenario-number]

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

show_menu() {
    echo ""
    echo "=========================================="
    echo "   Azure ARM Template Quick Deploy"
    echo "=========================================="
    echo "1. Deploy Windows VM"
    echo "2. Deploy Linux VM"
    echo "3. Deploy Web App"
    echo "4. Deploy Function App"
    echo "5. Deploy Storage Account"
    echo "6. Deploy SQL Database"
    echo "7. Deploy Cosmos DB"
    echo "8. Deploy AKS Cluster"
    echo "9. Deploy Container Registry"
    echo "10. Deploy Key Vault"
    echo "11. Deploy Virtual Network"
    echo "12. Deploy Log Analytics Workspace"
    echo "0. Exit"
    echo "=========================================="
}

deploy_resource() {
    local template_file=$1
    local resource_name=$2
    
    print_info "Deploying: $resource_name"
    
    read -p "Enter Resource Group name: " RG_NAME
    read -p "Enter Azure region (e.g., eastus): " LOCATION
    
    # Check if resource group exists
    if ! az group show --name "$RG_NAME" &> /dev/null; then
        print_info "Creating resource group..."
        az group create --name "$RG_NAME" --location "$LOCATION"
    fi
    
    # Generate deployment name
    DEPLOYMENT_NAME="${resource_name}-$(date +%Y%m%d-%H%M%S)"
    
    # Deploy
    az deployment group create \
        --name "$DEPLOYMENT_NAME" \
        --resource-group "$RG_NAME" \
        --template-file "$template_file"
    
    print_info "✓ Deployment completed!"
}

# Main script
main() {
    # Check if Azure CLI is installed
    if ! command -v az &> /dev/null; then
        echo "Error: Azure CLI is not installed"
        exit 1
    fi
    
    # Login check
    if ! az account show &> /dev/null; then
        print_info "Logging in to Azure..."
        az login
    fi
    
    # Get script directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    BASE_DIR="$(dirname "$SCRIPT_DIR")"
    
    while true; do
        show_menu
        read -p "Enter your choice [0-12]: " choice
        
        case $choice in
            1) deploy_resource "$BASE_DIR/compute/windows-vm.json" "windows-vm" ;;
            2) deploy_resource "$BASE_DIR/compute/linux-vm.json" "linux-vm" ;;
            3) deploy_resource "$BASE_DIR/compute/app-service-plan-webapp.json" "webapp" ;;
            4) deploy_resource "$BASE_DIR/compute/function-app.json" "function-app" ;;
            5) deploy_resource "$BASE_DIR/storage/storage-account.json" "storage-account" ;;
            6) deploy_resource "$BASE_DIR/databases/sql-database.json" "sql-database" ;;
            7) deploy_resource "$BASE_DIR/databases/cosmos-db.json" "cosmos-db" ;;
            8) deploy_resource "$BASE_DIR/containers/aks-cluster.json" "aks-cluster" ;;
            9) deploy_resource "$BASE_DIR/containers/container-registry.json" "container-registry" ;;
            10) deploy_resource "$BASE_DIR/security/key-vault.json" "key-vault" ;;
            11) deploy_resource "$BASE_DIR/networking/virtual-network.json" "virtual-network" ;;
            12) deploy_resource "$BASE_DIR/monitoring/log-analytics-workspace.json" "log-analytics" ;;
            0) print_info "Exiting..."; exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
        
        read -p "Press Enter to continue..."
    done
}

main
