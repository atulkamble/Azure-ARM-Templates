# Azure ARM Templates - Best Practices Guide

This document outlines best practices for creating and deploying Azure ARM templates.

## Table of Contents

1. [Template Design](#template-design)
2. [Security](#security)
3. [Naming Conventions](#naming-conventions)
4. [Parameters and Variables](#parameters-and-variables)
5. [Resource Dependencies](#resource-dependencies)
6. [Outputs](#outputs)
7. [Error Handling](#error-handling)
8. [Performance](#performance)
9. [Testing](#testing)
10. [Documentation](#documentation)

## Template Design

### Keep Templates Modular

✅ **DO**: Create separate templates for different resource types
```
compute/
├── vm.json
├── vmss.json
└── app-service.json
```

❌ **DON'T**: Put all resources in one massive template

### Use Template Linking

✅ **DO**: Link templates for complex deployments
```json
{
  "type": "Microsoft.Resources/deployments",
  "apiVersion": "2021-04-01",
  "name": "linkedTemplate",
  "properties": {
    "mode": "Incremental",
    "templateLink": {
      "uri": "https://mystorageaccount.blob.core.windows.net/templates/storage.json"
    }
  }
}
```

### Version Your Templates

✅ **DO**: Use version control (Git) for all templates
✅ **DO**: Tag releases (e.g., v1.0.0, v1.1.0)
✅ **DO**: Document breaking changes

## Security

### Never Hardcode Secrets

❌ **DON'T**:
```json
"adminPassword": {
  "value": "P@ssw0rd123!"  // Never do this!
}
```

✅ **DO**: Use secure parameters
```json
"adminPassword": {
  "type": "securestring",
  "metadata": {
    "description": "Admin password"
  }
}
```

### Use Key Vault References

✅ **DO**: Reference secrets from Azure Key Vault
```json
"parameters": {
  "adminPassword": {
    "reference": {
      "keyVault": {
        "id": "/subscriptions/{subscription}/resourceGroups/{rg}/providers/Microsoft.KeyVault/vaults/{vault}"
      },
      "secretName": "adminPassword"
    }
  }
}
```

### Enable Security Features

✅ **DO**: Always enable these security features:
- HTTPS-only traffic
- Minimum TLS version 1.2
- Managed identities instead of service principals
- Network security groups
- Diagnostic logging
- Azure Policy compliance

```json
{
  "type": "Microsoft.Storage/storageAccounts",
  "properties": {
    "supportsHttpsTrafficOnly": true,
    "minimumTlsVersion": "TLS1_2"
  }
}
```

## Naming Conventions

### Resource Naming Pattern

Use a consistent naming pattern:
```
<resourceType>-<workload>-<environment>-<region>-<instance>
```

Examples:
- `vm-webapp-prod-eastus-001`
- `st-logs-dev-westus-001`
- `kv-secrets-prod-eastus-001`

### Resource Type Abbreviations

| Resource | Abbreviation |
|----------|-------------|
| Virtual Machine | vm |
| Storage Account | st |
| Virtual Network | vnet |
| Subnet | snet |
| Network Security Group | nsg |
| Public IP | pip |
| Load Balancer | lb |
| Key Vault | kv |
| App Service Plan | asp |
| Function App | func |
| Log Analytics Workspace | law |

### Use Variables for Names

✅ **DO**:
```json
"variables": {
  "storageAccountName": "[concat('st', parameters('workload'), parameters('environment'), uniqueString(resourceGroup().id))]",
  "vmName": "[concat('vm-', parameters('workload'), '-', parameters('environment'))]"
}
```

## Parameters and Variables

### Parameter Best Practices

✅ **DO**: Provide default values when appropriate
```json
"parameters": {
  "vmSize": {
    "type": "string",
    "defaultValue": "Standard_B2s",
    "allowedValues": [
      "Standard_B1s",
      "Standard_B2s",
      "Standard_D2s_v3"
    ],
    "metadata": {
      "description": "Size of the virtual machine"
    }
  }
}
```

✅ **DO**: Use allowedValues to restrict choices
✅ **DO**: Always include metadata descriptions
✅ **DO**: Use appropriate parameter types (string, int, bool, securestring, object, array)

### Variable Best Practices

✅ **DO**: Use variables for computed or repeated values
```json
"variables": {
  "location": "[resourceGroup().location]",
  "nicName": "[concat(parameters('vmName'), '-nic')]",
  "publicIPName": "[concat(parameters('vmName'), '-pip')]"
}
```

❌ **DON'T**: Use variables for simple one-time values

## Resource Dependencies

### Explicit Dependencies

✅ **DO**: Use `dependsOn` when necessary
```json
{
  "type": "Microsoft.Compute/virtualMachines",
  "name": "[parameters('vmName')]",
  "dependsOn": [
    "[resourceId('Microsoft.Network/networkInterfaces', variables('nicName'))]"
  ]
}
```

### Implicit Dependencies

✅ **DO**: Understand that using `reference()` or `resourceId()` creates implicit dependencies

### Avoid Circular Dependencies

❌ **DON'T**: Create circular dependency chains
```
Resource A depends on B
Resource B depends on C
Resource C depends on A  // Circular!
```

## Outputs

### Provide Useful Outputs

✅ **DO**: Return important values
```json
"outputs": {
  "vmPublicIP": {
    "type": "string",
    "value": "[reference(resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))).ipAddress]"
  },
  "vmFQDN": {
    "type": "string",
    "value": "[reference(resourceId('Microsoft.Network/publicIPAddresses', variables('publicIPName'))).dnsSettings.fqdn]"
  },
  "resourceGroupId": {
    "type": "string",
    "value": "[resourceGroup().id]"
  }
}
```

### Output Sensitive Data Carefully

❌ **DON'T**: Output secrets or sensitive data
```json
// Never do this!
"outputs": {
  "adminPassword": {
    "type": "string",
    "value": "[parameters('adminPassword')]"
  }
}
```

## Error Handling

### Validate Before Deploying

✅ **DO**: Always validate templates
```bash
az deployment group validate \
  --resource-group MyRG \
  --template-file template.json
```

### Use What-If

✅ **DO**: Preview changes before deploying
```bash
az deployment group what-if \
  --resource-group MyRG \
  --template-file template.json
```

### Handle Deployment Modes

✅ **DO**: Understand deployment modes
- **Incremental** (default): Adds/updates resources, leaves others unchanged
- **Complete**: Deletes resources not in template

```json
{
  "mode": "Incremental"  // Safer for most scenarios
}
```

## Performance

### Optimize Template Size

✅ **DO**: Keep templates under 4 MB
✅ **DO**: Use linked templates for large deployments
✅ **DO**: Minimize nested deployments

### Parallel Deployments

✅ **DO**: Let Azure deploy resources in parallel when possible
- Don't add unnecessary `dependsOn` clauses

### Use Copy Loops Wisely

✅ **DO**: Use copy loops for multiple similar resources
```json
"copy": {
  "name": "vmCopy",
  "count": "[parameters('vmCount')]"
},
"name": "[concat('vm-', copyIndex(1))]"
```

## Testing

### Test in Non-Production First

✅ **DO**: Always test in dev/test environment
✅ **DO**: Use separate subscriptions/resource groups for testing
✅ **DO**: Automate testing with CI/CD pipelines

### Validation Checklist

- [ ] JSON syntax is valid
- [ ] All required parameters have values
- [ ] Resource names are valid and unique
- [ ] API versions are current
- [ ] Dependencies are correct
- [ ] Security best practices are followed
- [ ] Costs are estimated and acceptable

### Test Scenarios

1. **New deployment** (empty resource group)
2. **Update deployment** (existing resources)
3. **Idempotency** (deploy same template twice)
4. **Rollback** (deploy previous version)
5. **Parameter variations** (different parameter values)

## Documentation

### Document Your Templates

✅ **DO**: Include README for each template
✅ **DO**: Document parameters and their purpose
✅ **DO**: Provide example parameter files
✅ **DO**: Explain prerequisites and dependencies

### Template Comments

✅ **DO**: Add meaningful metadata
```json
"metadata": {
  "description": "Deploys a Windows VM with all required networking components",
  "author": "Your Name",
  "version": "1.0.0",
  "lastUpdated": "2025-11-01"
}
```

### Parameter Documentation

✅ **DO**: Document each parameter
```json
"vmSize": {
  "type": "string",
  "metadata": {
    "description": "Size of the VM. Choose based on workload requirements. B-series for burstable, D-series for general purpose."
  }
}
```

## API Versions

### Use Recent API Versions

✅ **DO**: Use recent stable API versions
✅ **DO**: Update API versions regularly
❌ **DON'T**: Use preview API versions in production

### Check for Breaking Changes

✅ **DO**: Review release notes when updating API versions
✅ **DO**: Test thoroughly after API version updates

## Cost Optimization

### Right-Size Resources

✅ **DO**: Start with smaller SKUs and scale up
✅ **DO**: Use auto-scaling for production workloads
✅ **DO**: Implement auto-shutdown for dev/test VMs

### Use Cost-Effective Options

✅ **DO**: Use spot instances for non-critical workloads
✅ **DO**: Use reserved instances for predictable workloads
✅ **DO**: Use storage tiers appropriately (Hot/Cool/Archive)

### Monitor Costs

✅ **DO**: Set up Azure Cost Management alerts
✅ **DO**: Tag resources for cost tracking
✅ **DO**: Review costs regularly

## Idempotency

### Design for Redeployment

✅ **DO**: Ensure templates can be deployed multiple times safely
✅ **DO**: Use `Incremental` mode for updates
✅ **DO**: Test redeployment scenarios

### Avoid Destructive Updates

❌ **DON'T**: Change properties that force resource recreation
- Check Azure documentation for properties that trigger recreation

## Monitoring and Logging

### Enable Diagnostics

✅ **DO**: Configure diagnostic settings
```json
{
  "type": "Microsoft.Insights/diagnosticSettings",
  "properties": {
    "workspaceId": "[parameters('logAnalyticsWorkspaceId')]",
    "logs": [...],
    "metrics": [...]
  }
}
```

### Use Tags

✅ **DO**: Tag all resources
```json
"tags": {
  "Environment": "[parameters('environment')]",
  "Owner": "[parameters('owner')]",
  "CostCenter": "[parameters('costCenter')]",
  "Application": "[parameters('applicationName')]"
}
```

## Bicep Alternative

### Consider Bicep

✅ **DO**: Consider using Bicep for new templates
- Cleaner syntax
- Better tooling support
- Automatic dependency management
- Easier to read and maintain

**ARM JSON:**
```json
{
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "2021-08-01",
  "name": "[parameters('name')]",
  "location": "[resourceGroup().location]",
  "sku": {
    "name": "Standard_LRS"
  }
}
```

**Bicep:**
```bicep
resource storage 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: name
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
}
```

## Checklist for Production Deployments

- [ ] Template validated successfully
- [ ] Tested in non-production environment
- [ ] Security review completed
- [ ] Cost estimate approved
- [ ] Backup plan in place
- [ ] Rollback procedure documented
- [ ] Monitoring and alerts configured
- [ ] Documentation updated
- [ ] Change management approval obtained
- [ ] Deployment window scheduled

---

Following these best practices will help you create reliable, secure, and maintainable ARM templates. Happy deploying! 🚀
