#!/bin/bash

# Azure ARM Template Deployment Script
# This script deploys ARM templates to Azure

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to check if Azure CLI is installed
check_azure_cli() {
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install it first."
        exit 1
    fi
    print_info "Azure CLI is installed"
}

# Function to login to Azure
azure_login() {
    print_info "Checking Azure login status..."
    if ! az account show &> /dev/null; then
        print_warning "Not logged in to Azure. Initiating login..."
        az login
    else
        print_info "Already logged in to Azure"
        CURRENT_SUBSCRIPTION=$(az account show --query name -o tsv)
        print_info "Current subscription: $CURRENT_SUBSCRIPTION"
    fi
}

# Function to deploy ARM template
deploy_template() {
    local RESOURCE_GROUP=$1
    local TEMPLATE_FILE=$2
    local PARAMETERS_FILE=$3
    local DEPLOYMENT_NAME=$4
    
    print_info "Starting deployment: $DEPLOYMENT_NAME"
    print_info "Resource Group: $RESOURCE_GROUP"
    print_info "Template: $TEMPLATE_FILE"
    
    if [ -z "$PARAMETERS_FILE" ]; then
        az deployment group create \
            --name "$DEPLOYMENT_NAME" \
            --resource-group "$RESOURCE_GROUP" \
            --template-file "$TEMPLATE_FILE" \
            --verbose
    else
        print_info "Parameters: $PARAMETERS_FILE"
        az deployment group create \
            --name "$DEPLOYMENT_NAME" \
            --resource-group "$RESOURCE_GROUP" \
            --template-file "$TEMPLATE_FILE" \
            --parameters "@$PARAMETERS_FILE" \
            --verbose
    fi
    
    if [ $? -eq 0 ]; then
        print_info "✓ Deployment completed successfully!"
    else
        print_error "✗ Deployment failed!"
        exit 1
    fi
}

# Main script
main() {
    print_info "=== Azure ARM Template Deployment Script ==="
    
    # Check prerequisites
    check_azure_cli
    azure_login
    
    # Get input parameters
    read -p "Enter Resource Group name: " RESOURCE_GROUP
    read -p "Enter Azure region (e.g., eastus): " LOCATION
    read -p "Enter template file path: " TEMPLATE_FILE
    read -p "Enter parameters file path (leave empty if none): " PARAMETERS_FILE
    
    # Generate deployment name with timestamp
    DEPLOYMENT_NAME="deployment-$(date +%Y%m%d-%H%M%S)"
    
    # Check if resource group exists
    print_info "Checking if resource group exists..."
    if ! az group show --name "$RESOURCE_GROUP" &> /dev/null; then
        print_warning "Resource group does not exist. Creating..."
        az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
        print_info "✓ Resource group created"
    else
        print_info "Resource group already exists"
    fi
    
    # Validate template
    print_info "Validating ARM template..."
    if [ -z "$PARAMETERS_FILE" ]; then
        az deployment group validate \
            --resource-group "$RESOURCE_GROUP" \
            --template-file "$TEMPLATE_FILE"
    else
        az deployment group validate \
            --resource-group "$RESOURCE_GROUP" \
            --template-file "$TEMPLATE_FILE" \
            --parameters "@$PARAMETERS_FILE"
    fi
    
    if [ $? -eq 0 ]; then
        print_info "✓ Template validation successful"
    else
        print_error "✗ Template validation failed"
        exit 1
    fi
    
    # Deploy template
    deploy_template "$RESOURCE_GROUP" "$TEMPLATE_FILE" "$PARAMETERS_FILE" "$DEPLOYMENT_NAME"
    
    # Show deployment outputs
    print_info "Fetching deployment outputs..."
    az deployment group show \
        --name "$DEPLOYMENT_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --query properties.outputs
    
    print_info "=== Deployment Complete ==="
}

# Run main function
main
