# 🔧 Azure ARM Templates - Complete Collection

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Azure](https://img.shields.io/badge/Azure-ARM%20Templates-blue)](https://azure.microsoft.com)

A comprehensive collection of **Azure Resource Manager (ARM) Templates** for deploying various Azure resources. This repository contains production-ready templates, deployment scripts, and parameter files organized by service category.

## 📚 Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Available Templates](#available-templates)
- [Quick Start](#quick-start)
- [Deployment Methods](#deployment-methods)
- [Prerequisites](#prerequisites)
- [Usage Examples](#usage-examples)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This repository provides:
- ✅ **Production-ready ARM templates** for common Azure services
- ✅ **Automated deployment scripts** (Bash & PowerShell)
- ✅ **Parameter files** for different environments
- ✅ **Validation and cleanup utilities**
- ✅ **Best practices** and security considerations

## 📁 Repository Structure

```
Azure-ARM-Templates/
├── compute/                    # Compute resources
│   ├── windows-vm.json
│   ├── linux-vm.json
│   ├── app-service-plan-webapp.json
│   └── function-app.json
├── networking/                 # Networking resources
│   ├── virtual-network.json
│   ├── network-security-group.json
│   └── load-balancer.json
├── storage/                    # Storage resources
│   ├── storage-account.json
│   └── blob-container.json
├── databases/                  # Database resources
│   ├── sql-database.json
│   └── cosmos-db.json
├── containers/                 # Container resources
│   ├── aks-cluster.json
│   └── container-registry.json
├── security/                   # Security & Identity
│   └── key-vault.json
├── monitoring/                 # Monitoring resources
│   ├── log-analytics-workspace.json
│   └── application-insights.json
├── parameters/                 # Parameter files
│   ├── windows-vm.parameters.json
│   ├── linux-vm.parameters.json
│   └── sql-database.parameters.json
└── scripts/                    # Deployment scripts
    ├── deploy.sh              # Bash deployment script
    ├── deploy.ps1             # PowerShell deployment script
    ├── quick-deploy.sh        # Interactive deployment menu
    ├── validate-templates.sh  # Template validation
    └── cleanup.sh             # Resource cleanup utility
```

## 🚀 Available Templates

### Compute Resources
| Template | Description | Key Features |
|----------|-------------|--------------|
| `windows-vm.json` | Windows Virtual Machine | Auto-creates VNet, NSG, Public IP, NIC |
| `linux-vm.json` | Linux Virtual Machine (Ubuntu) | SSH or password authentication |
| `app-service-plan-webapp.json` | Web App + App Service Plan | Multiple runtime stacks supported |
| `function-app.json` | Azure Functions | Includes Application Insights & Storage |

### Networking Resources
| Template | Description | Key Features |
|----------|-------------|--------------|
| `virtual-network.json` | Virtual Network with subnets | Customizable address spaces |
| `network-security-group.json` | Network Security Group | Pre-configured security rules |
| `load-balancer.json` | Standard Load Balancer | Health probes & backend pools |

### Storage & Databases
| Template | Description | Key Features |
|----------|-------------|--------------|
| `storage-account.json` | Storage Account (v2) | HTTPS-only, TLS 1.2 minimum |
| `blob-container.json` | Blob Storage with container | Soft delete enabled |
| `sql-database.json` | Azure SQL Database + Server | Firewall rules included |
| `cosmos-db.json` | Cosmos DB (SQL API) | Auto-configured with container |

### Containers & Orchestration
| Template | Description | Key Features |
|----------|-------------|--------------|
| `aks-cluster.json` | Azure Kubernetes Service | System-assigned identity, RBAC enabled |
| `container-registry.json` | Azure Container Registry | Basic/Standard/Premium SKUs |

### Security & Monitoring
| Template | Description | Key Features |
|----------|-------------|--------------|
| `key-vault.json` | Azure Key Vault | Access policies configured |
| `log-analytics-workspace.json` | Log Analytics Workspace | Customizable retention |
| `application-insights.json` | Application Insights | Web & API monitoring |

## 🏁 Quick Start

### Method 1: Interactive Quick Deploy (Recommended for Beginners)

```bash
# Clone the repository
git clone https://github.com/yourusername/Azure-ARM-Templates.git
cd Azure-ARM-Templates

# Run the interactive deployment menu
./scripts/quick-deploy.sh
```

### Method 2: Direct Deployment with Azure CLI

```bash
# Login to Azure
az login

# Create a resource group
az group create --name MyResourceGroup --location eastus

# Deploy a template
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file compute/linux-vm.json \
  --parameters @parameters/linux-vm.parameters.json
```

### Method 3: Using Deployment Scripts

**Bash:**
```bash
./scripts/deploy.sh
# Follow the interactive prompts
```

**PowerShell:**
```powershell
.\scripts\deploy.ps1 `
  -ResourceGroupName "MyResourceGroup" `
  -Location "eastus" `
  -TemplateFile ".\compute\windows-vm.json" `
  -ParametersFile ".\parameters\windows-vm.parameters.json"
```

## 📋 Prerequisites

### Required Tools

- **Azure CLI** (2.0 or later)
  ```bash
  # macOS
  brew install azure-cli
  
  # Windows
  winget install Microsoft.AzureCLI
  
  # Linux
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  ```

- **Azure PowerShell** (for PowerShell scripts)
  ```powershell
  Install-Module -Name Az -AllowClobber -Scope CurrentUser
  ```

- **jq** (for template validation script)
  ```bash
  # macOS
  brew install jq
  
  # Ubuntu/Debian
  sudo apt-get install jq
  ```

### Azure Permissions

Ensure your Azure account has:
- **Contributor** role or higher on the subscription/resource group
- Permissions to create resources in the target subscription

## 💡 Usage Examples

### Example 1: Deploy a Linux Web Server

```bash
# 1. Create resource group
az group create --name WebServerRG --location eastus

# 2. Deploy the template
az deployment group create \
  --resource-group WebServerRG \
  --template-file compute/linux-vm.json \
  --parameters adminUsername=azureuser \
  --parameters adminPasswordOrKey="$(cat ~/.ssh/id_rsa.pub)" \
  --parameters authenticationType=sshPublicKey

# 3. Get the public IP
az deployment group show \
  --resource-group WebServerRG \
  --name <deployment-name> \
  --query properties.outputs.publicIP.value
```

### Example 2: Deploy a Complete Web Application Stack

```bash
# Deploy storage account
az deployment group create \
  --resource-group MyAppRG \
  --template-file storage/storage-account.json

# Deploy SQL database
az deployment group create \
  --resource-group MyAppRG \
  --template-file databases/sql-database.json \
  --parameters @parameters/sql-database.parameters.json

# Deploy web app
az deployment group create \
  --resource-group MyAppRG \
  --template-file compute/app-service-plan-webapp.json
```

### Example 3: Validate Templates Before Deployment

```bash
# Validate a single template
./scripts/validate-templates.sh compute/windows-vm.json

# Validate all templates in a directory
./scripts/validate-templates.sh compute/
```

## 🚀 Deployment Methods

### 1️⃣ Azure CLI

```bash
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file <template-file.json> \
  --parameters @<parameters-file.json>
```

### 2️⃣ Azure PowerShell

```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName <resource-group-name> `
  -TemplateFile <template-file.json> `
  -TemplateParameterFile <parameters-file.json>
```

### 3️⃣ Azure Portal

1. Navigate to [Azure Portal](https://portal.azure.com)
2. Search for **"Deploy a custom template"**
3. Click **"Build your own template in the editor"**
4. Paste your JSON template
5. Fill in the parameters
6. Click **Review + Create** → **Create**

### 4️⃣ Azure DevOps Pipeline

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: AzureResourceManagerTemplateDeployment@3
  inputs:
    deploymentScope: 'Resource Group'
    azureResourceManagerConnection: '<service-connection>'
    subscriptionId: '<subscription-id>'
    action: 'Create Or Update Resource Group'
    resourceGroupName: '<resource-group>'
    location: 'East US'
    templateLocation: 'Linked artifact'
    csmFile: 'compute/linux-vm.json'
    csmParametersFile: 'parameters/linux-vm.parameters.json'
```

### 5️⃣ GitHub Actions

```yaml
name: Deploy ARM Template

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - name: Azure Login
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}
    
    - name: Deploy ARM Template
      uses: azure/arm-deploy@v1
      with:
        subscriptionId: ${{ secrets.AZURE_SUBSCRIPTION }}
        resourceGroupName: myResourceGroup
        template: ./compute/linux-vm.json
        parameters: ./parameters/linux-vm.parameters.json
```

## 🛡️ Best Practices

### Security
- ✅ Always use **HTTPS** and **TLS 1.2+**
- ✅ Store secrets in **Azure Key Vault**
- ✅ Use **Managed Identities** instead of service principals when possible
- ✅ Enable **diagnostic logging** for all resources
- ✅ Implement **Network Security Groups (NSGs)** and **Private Endpoints**
- ✅ Never commit passwords or secrets to Git

### Template Design
- ✅ Use **parameters** for environment-specific values
- ✅ Define **outputs** for important resource properties
- ✅ Implement **dependsOn** for correct deployment order
- ✅ Use **variables** for repeated values
- ✅ Add meaningful **metadata descriptions**
- ✅ Follow **naming conventions** (e.g., `resourceType-purpose-environment`)

### Cost Optimization
- ✅ Use appropriate **SKUs** (start with Basic/Free tiers for dev/test)
- ✅ Enable **auto-shutdown** for VMs in dev environments
- ✅ Implement **auto-scaling** for production workloads
- ✅ Use **Azure Cost Management** to monitor spending
- ✅ Clean up unused resources regularly

### Testing & Validation
- ✅ Always **validate** templates before deployment
- ✅ Test in a **non-production** environment first
- ✅ Use **what-if operations** to preview changes
- ✅ Implement **CI/CD pipelines** for automated testing
- ✅ Version your templates in **Git**

## � Common Commands

### Resource Management
```bash
# List all resource groups
az group list --output table

# Show deployment status
az deployment group list --resource-group <rg-name> --output table

# Show deployment outputs
az deployment group show \
  --resource-group <rg-name> \
  --name <deployment-name> \
  --query properties.outputs

# Delete a resource group (careful!)
az group delete --name <rg-name> --yes --no-wait
```

### Template Operations
```bash
# Validate template
az deployment group validate \
  --resource-group <rg-name> \
  --template-file <template.json>

# What-if operation (preview changes)
az deployment group what-if \
  --resource-group <rg-name> \
  --template-file <template.json>

# Export template from existing resources
az group export \
  --resource-group <rg-name> \
  --resource-ids <resource-id>
```

## 🧹 Cleanup

To remove all deployed resources:

```bash
# Using the cleanup script
./scripts/cleanup.sh

# Or manually
az group delete --name <resource-group-name> --yes --no-wait
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow existing template structure
- Add parameter descriptions
- Include example parameter files
- Test templates before submitting
- Update documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support & Resources

- [Azure ARM Template Documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/)
- [Azure Quickstart Templates](https://github.com/Azure/azure-quickstart-templates)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/azure/)

## ⭐ Acknowledgments

- Microsoft Azure Documentation
- Azure Quickstart Templates Community
- Contributors and maintainers

---

**Made with ❤️ for the Azure community**

*Last Updated: November 2025*