# Getting Started with Azure ARM Templates

This guide will help you get started with deploying Azure resources using ARM templates.

## Prerequisites

Before you begin, ensure you have:

1. **Azure Account**: [Create a free account](https://azure.microsoft.com/free/)
2. **Azure CLI**: [Installation guide](https://docs.microsoft.com/cli/azure/install-azure-cli)
3. **Text Editor**: VS Code (recommended) or any text editor

## Your First Deployment

### Step 1: Install Azure CLI

**macOS:**
```bash
brew install azure-cli
```

**Windows:**
```powershell
winget install Microsoft.AzureCLI
```

**Linux:**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Step 2: Login to Azure

```bash
az login
```

This will open a browser window for authentication.

### Step 3: Create a Resource Group

```bash
az group create \
  --name MyFirstResourceGroup \
  --location eastus
```

### Step 4: Deploy Your First Template

Let's deploy a simple storage account:

```bash
az deployment group create \
  --resource-group MyFirstResourceGroup \
  --template-file storage/storage-account.json
```

### Step 5: Verify the Deployment

```bash
# List all resources in the resource group
az resource list \
  --resource-group MyFirstResourceGroup \
  --output table

# Show deployment details
az deployment group show \
  --resource-group MyFirstResourceGroup \
  --name <deployment-name>
```

## Understanding ARM Template Structure

Every ARM template has these key sections:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Input values for the template
  },
  "variables": {
    // Values computed within the template
  },
  "resources": [
    // Azure resources to deploy
  ],
  "outputs": {
    // Values to return after deployment
  }
}
```

### Parameters

Define values that can be customized during deployment:

```json
"parameters": {
  "storageAccountName": {
    "type": "string",
    "metadata": {
      "description": "Name of the storage account"
    }
  }
}
```

### Variables

Define values used within the template:

```json
"variables": {
  "location": "[resourceGroup().location]",
  "uniqueName": "[concat('storage', uniqueString(resourceGroup().id))]"
}
```

### Resources

Define the Azure resources to deploy:

```json
"resources": [
  {
    "type": "Microsoft.Storage/storageAccounts",
    "apiVersion": "2021-08-01",
    "name": "[parameters('storageAccountName')]",
    "location": "[variables('location')]",
    "sku": {
      "name": "Standard_LRS"
    },
    "kind": "StorageV2"
  }
]
```

### Outputs

Return values after deployment:

```json
"outputs": {
  "storageAccountId": {
    "type": "string",
    "value": "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
  }
}
```

## Common ARM Template Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `concat()` | Concatenate strings | `concat('vm-', parameters('vmName'))` |
| `uniqueString()` | Generate unique string | `uniqueString(resourceGroup().id)` |
| `resourceGroup()` | Get resource group info | `resourceGroup().location` |
| `parameters()` | Access parameter value | `parameters('adminUsername')` |
| `variables()` | Access variable value | `variables('storageAccountName')` |
| `resourceId()` | Get resource ID | `resourceId('Microsoft.Network/virtualNetworks', 'myVNet')` |

## Parameter Files

Instead of passing parameters inline, use parameter files:

**parameters.json:**
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageAccountName": {
      "value": "mystorageaccount123"
    }
  }
}
```

**Deploy with parameter file:**
```bash
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file template.json \
  --parameters @parameters.json
```

## Validation and What-If

### Validate Template

Before deploying, validate your template:

```bash
az deployment group validate \
  --resource-group MyResourceGroup \
  --template-file template.json \
  --parameters @parameters.json
```

### What-If Operation

Preview what changes will be made:

```bash
az deployment group what-if \
  --resource-group MyResourceGroup \
  --template-file template.json \
  --parameters @parameters.json
```

## Troubleshooting

### Common Errors

**Error: Resource name already exists**
```bash
# Solution: Use unique names with uniqueString()
"name": "[concat('storage', uniqueString(resourceGroup().id))]"
```

**Error: Template validation failed**
```bash
# Solution: Check JSON syntax and required properties
# Use JSON validator: https://jsonlint.com/
```

**Error: Insufficient permissions**
```bash
# Solution: Ensure you have Contributor role
az role assignment list --assignee <your-email>
```

### View Deployment Errors

```bash
# List deployments
az deployment group list \
  --resource-group MyResourceGroup \
  --output table

# Show deployment errors
az deployment group show \
  --resource-group MyResourceGroup \
  --name <deployment-name> \
  --query properties.error
```

## Next Steps

1. **Explore Templates**: Browse the templates in this repository
2. **Modify Parameters**: Customize templates for your needs
3. **Create Complex Deployments**: Link multiple templates together
4. **Learn Bicep**: Modern alternative to ARM JSON templates
5. **CI/CD Integration**: Automate deployments with Azure DevOps or GitHub Actions

## Resources

- [ARM Template Documentation](https://docs.microsoft.com/azure/azure-resource-manager/templates/)
- [ARM Template Best Practices](https://docs.microsoft.com/azure/azure-resource-manager/templates/best-practices)
- [ARM Template Reference](https://docs.microsoft.com/azure/templates/)
- [Azure Quickstart Templates](https://github.com/Azure/azure-quickstart-templates)

## Getting Help

- Check the [main README](README.md) for detailed documentation
- Review example parameter files in the `parameters/` directory
- Use the interactive `quick-deploy.sh` script for guided deployment
- Validate templates with `validate-templates.sh` before deploying

Happy deploying! 🚀
