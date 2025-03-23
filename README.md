
---

# 🔧 Azure ARM Templates – Common Scenarios + How to Run Them

Here are some useful **Azure ARM Template** samples that cover common scenarios and can help you in your IaC (Infrastructure as Code) projects. Each example includes a brief explanation and can be modified as needed.

---

## 🧩 ARM Template Samples (Arranged in Logical Sequence)

### ✅ 1. **Create a Resource Group**
> Note: ARM templates cannot create resource groups. You create a resource group using CLI or PowerShell **before** deploying the template.

```bash
az group create --name MyResourceGroup --location eastus
```

---

### ✅ 2. **Create a Virtual Network**
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2020-06-01",
      "name": "myVnet",
      "location": "[resourceGroup().location]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": ["10.0.0.0/16"]
        },
        "subnets": [
          {
            "name": "mySubnet",
            "properties": {
              "addressPrefix": "10.0.0.0/24"
            }
          }
        ]
      }
    }
  ]
}
```

---

### ✅ 3. **Deploy a Storage Account**
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "apiVersion": "2021-02-01",
      "name": "mystorageacct12345",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "StorageV2",
      "properties": {}
    }
  ]
}
```

---

### ✅ 4. **Deploy an App Service (Web App + App Service Plan)**
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Web/serverfarms",
      "apiVersion": "2020-12-01",
      "name": "myAppServicePlan",
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "F1",
        "tier": "Free"
      },
      "properties": {}
    },
    {
      "type": "Microsoft.Web/sites",
      "apiVersion": "2020-12-01",
      "name": "myWebApp12345",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "myAppServicePlan"
      ],
      "properties": {
        "serverFarmId": "[resourceId('Microsoft.Web/serverfarms', 'myAppServicePlan')]"
      }
    }
  ]
}
```

---

### ✅ 5. **Deploy a Windows Virtual Machine**
```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUsername": {
      "type": "string"
    },
    "adminPassword": {
      "type": "securestring"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Compute/virtualMachines",
      "apiVersion": "2021-03-01",
      "name": "myVM",
      "location": "[resourceGroup().location]",
      "properties": {
        "hardwareProfile": {
          "vmSize": "Standard_B1s"
        },
        "osProfile": {
          "computerName": "myVM",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsServer",
            "offer": "WindowsServer",
            "sku": "2019-Datacenter",
            "version": "latest"
          },
          "osDisk": {
            "createOption": "FromImage"
          }
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces', 'myNic')]"
            }
          ]
        }
      }
    }
  ]
}
```

---

## 🚀 How to Run ARM Templates

### 🖥️ Step-by-Step Using Azure CLI

#### 📁 1. Prepare Your Files
- Template: `template.json`
- Parameters (optional): `parameters.json`

#### 🔐 2. Login to Azure
```bash
az login
```

#### 🏗️ 3. Create a Resource Group
```bash
az group create --name MyResourceGroup --location eastus
```

#### 🚀 4. Deploy the Template
**Without parameters file:**
```bash
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file template.json
```

**With parameters file:**
```bash
az deployment group create \
  --resource-group MyResourceGroup \
  --template-file template.json \
  --parameters @parameters.json
```

**Inline parameters:**
```bash
--parameters adminUsername=atul adminPassword=MySecureP@ssw0rd!
```

---

### 💻 Using Azure PowerShell
```powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "MyResourceGroup" `
  -TemplateFile "template.json"
```

---

### 🌐 Using Azure Portal
1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **"Deploy a custom template"**
3. Choose **"Build your own template in the editor"**
4. Paste your template JSON
5. Fill in parameters > Review + Create > Deploy

---

Would you like this whole thing converted into a **Markdown README**, **GitHub repo**, or even a **PDF for sharing**?
