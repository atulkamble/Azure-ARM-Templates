# Quick Reference Guide

## 🚀 Common Commands

### Azure Login
```bash
az login
az account show
az account list --output table
```

### Resource Group Management
```bash
# Create resource group
az group create --name MyRG --location eastus

# List resource groups
az group list --output table

# Delete resource group
az group delete --name MyRG --yes --no-wait
```

### Template Deployment
```bash
# Deploy template
az deployment group create \
  --resource-group MyRG \
  --template-file template.json \
  --parameters @parameters.json

# Validate template
az deployment group validate \
  --resource-group MyRG \
  --template-file template.json

# What-if (preview changes)
az deployment group what-if \
  --resource-group MyRG \
  --template-file template.json
```

### Deployment Management
```bash
# List deployments
az deployment group list \
  --resource-group MyRG \
  --output table

# Show deployment details
az deployment group show \
  --resource-group MyRG \
  --name deployment-name

# Show outputs
az deployment group show \
  --resource-group MyRG \
  --name deployment-name \
  --query properties.outputs
```

## 📋 Template Quick Starts

### Deploy Windows VM
```bash
./scripts/quick-deploy.sh
# Select option 1
```

### Deploy Linux VM
```bash
az deployment group create \
  --resource-group MyRG \
  --template-file compute/linux-vm.json \
  --parameters adminUsername=azureuser \
  --parameters adminPasswordOrKey="$(cat ~/.ssh/id_rsa.pub)" \
  --parameters authenticationType=sshPublicKey
```

### Deploy Web App
```bash
az deployment group create \
  --resource-group MyRG \
  --template-file compute/app-service-plan-webapp.json \
  --parameters webAppName=myapp-$RANDOM
```

### Deploy Storage Account
```bash
az deployment group create \
  --resource-group MyRG \
  --template-file storage/storage-account.json
```

### Deploy SQL Database
```bash
az deployment group create \
  --resource-group MyRG \
  --template-file databases/sql-database.json \
  --parameters @parameters/sql-database.parameters.json
```

### Deploy AKS Cluster
```bash
az deployment group create \
  --resource-group MyRG \
  --template-file containers/aks-cluster.json \
  --parameters clusterName=myaks \
  --parameters nodeCount=3
```

## 🔍 Resource Queries

### List Resources
```bash
# All resources in resource group
az resource list --resource-group MyRG --output table

# Specific resource type
az vm list --resource-group MyRG --output table
az storage account list --resource-group MyRG --output table
az network vnet list --resource-group MyRG --output table
```

### Show Resource Details
```bash
# VM details
az vm show --resource-group MyRG --name myVM

# Storage account details
az storage account show --resource-group MyRG --name mystorageacct

# SQL database details
az sql db show --resource-group MyRG --server myserver --name mydb
```

### Get Connection Strings and Keys
```bash
# Storage account keys
az storage account keys list \
  --resource-group MyRG \
  --account-name mystorageacct

# SQL connection string
az sql db show-connection-string \
  --client ado.net \
  --server myserver \
  --name mydb

# Cosmos DB connection string
az cosmosdb keys list \
  --resource-group MyRG \
  --name mycosmosdb \
  --type connection-strings
```

## 🎯 Script Usage

### Interactive Deployment
```bash
./scripts/deploy.sh
# Follow prompts for:
# - Resource group name
# - Location
# - Template file
# - Parameters file (optional)
```

### Quick Deploy Menu
```bash
./scripts/quick-deploy.sh
# Select from menu:
# 1-12: Deploy specific resource
# 0: Exit
```

### Validate Templates
```bash
# Single template
./scripts/validate-templates.sh compute/windows-vm.json

# All templates in directory
./scripts/validate-templates.sh compute/
```

### Cleanup Resources
```bash
./scripts/cleanup.sh
# Options:
# 1: List resource groups
# 2: Show deployment history
# 3: Delete specific resource group
# 4: Delete all (DANGEROUS!)
```

## 🔑 Parameter File Format

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "parameterName": {
      "value": "parameterValue"
    }
  }
}
```

## 🏷️ Common Parameter Patterns

### Inline Parameters
```bash
--parameters key1=value1 key2=value2
```

### From File
```bash
--parameters @parameters.json
```

### Mixed
```bash
--parameters @parameters.json key1=override-value
```

### From Key Vault
```json
{
  "parameters": {
    "adminPassword": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.KeyVault/vaults/{vault}"
        },
        "secretName": "adminPassword"
      }
    }
  }
}
```

## 📊 Useful Queries (JMESPath)

### Get All VM Names
```bash
az vm list --query "[].name" --output tsv
```

### Get VM Public IPs
```bash
az vm list-ip-addresses \
  --resource-group MyRG \
  --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" \
  --output tsv
```

### Get Storage Account Endpoints
```bash
az storage account list \
  --query "[].{Name:name, BlobEndpoint:primaryEndpoints.blob}" \
  --output table
```

### Get AKS Credentials
```bash
az aks get-credentials \
  --resource-group MyRG \
  --name myAKS
```

## 🔧 Troubleshooting Commands

### View Activity Log
```bash
az monitor activity-log list \
  --resource-group MyRG \
  --offset 1h
```

### View Deployment Errors
```bash
az deployment group show \
  --resource-group MyRG \
  --name deployment-name \
  --query properties.error
```

### View Deployment Operations
```bash
az deployment operation group list \
  --resource-group MyRG \
  --name deployment-name
```

### Test Network Connectivity
```bash
# VM network test
az network watcher test-connectivity \
  --resource-group MyRG \
  --source-resource myVM \
  --dest-address example.com \
  --dest-port 443
```

## 📈 Cost Management

### Estimate Costs
```bash
# List current costs
az consumption usage list \
  --start-date 2025-11-01 \
  --end-date 2025-11-30

# Show budget
az consumption budget list
```

### Resource Tags (for cost tracking)
```bash
# Tag resource
az resource tag \
  --tags Environment=Dev CostCenter=IT \
  --ids /subscriptions/{sub}/resourceGroups/{rg}/providers/{provider}/{resource}

# Query by tag
az resource list \
  --tag Environment=Dev \
  --output table
```

## 🔐 Security Commands

### Key Vault Operations
```bash
# Create secret
az keyvault secret set \
  --vault-name myKeyVault \
  --name adminPassword \
  --value "MySecurePassword"

# Get secret
az keyvault secret show \
  --vault-name myKeyVault \
  --name adminPassword \
  --query value -o tsv
```

### Managed Identity
```bash
# Assign system identity to VM
az vm identity assign \
  --resource-group MyRG \
  --name myVM

# Get identity details
az vm identity show \
  --resource-group MyRG \
  --name myVM
```

## 🌐 Region and Location

### List Available Regions
```bash
az account list-locations --query "[].{Name:name, DisplayName:displayName}" --output table
```

### Check Resource Availability
```bash
az vm list-skus \
  --location eastus \
  --size Standard_D \
  --output table
```

## 💾 Export Templates

### Export Resource Group Template
```bash
az group export \
  --resource-group MyRG \
  --output-file exported-template.json
```

### Export Specific Resource
```bash
az resource show \
  --ids /subscriptions/{sub}/resourceGroups/{rg}/providers/{type}/{name} \
  --output json > resource.json
```

## 📱 Useful Aliases (Add to ~/.bashrc or ~/.zshrc)

```bash
# Azure CLI shortcuts
alias azl='az login'
alias azls='az account list --output table'
alias azrg='az group list --output table'
alias azdep='az deployment group'

# Common deployments
alias deploy-vm='az deployment group create --resource-group MyRG --template-file'
alias validate='az deployment group validate --resource-group MyRG --template-file'
alias whatif='az deployment group what-if --resource-group MyRG --template-file'

# Resource queries
alias list-vms='az vm list --output table'
alias list-storage='az storage account list --output table'
alias list-networks='az network vnet list --output table'
```

## 🎓 Learning Resources

- **Azure CLI Reference**: https://docs.microsoft.com/cli/azure/
- **ARM Template Reference**: https://docs.microsoft.com/azure/templates/
- **JMESPath Tutorial**: https://jmespath.org/tutorial.html
- **Azure Pricing Calculator**: https://azure.microsoft.com/pricing/calculator/

---

**Tip**: Save this file and keep it handy for quick reference!
