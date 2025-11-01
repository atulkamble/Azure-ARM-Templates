# 📑 Azure ARM Templates - Complete File Index

## 📊 Repository Statistics
- **Total Files**: 32
- **Total Size**: 320 KB
- **Directories**: 10
- **ARM Templates**: 16
- **Scripts**: 5
- **Documentation**: 6

---

## 📁 Complete Directory Structure

```
Azure-ARM-Templates/
│
├── 📖 DOCUMENTATION
│   ├── README.md                    # Main repository documentation
│   ├── GETTING_STARTED.md          # Beginner's guide
│   ├── BEST_PRACTICES.md           # Advanced best practices
│   ├── QUICK_REFERENCE.md          # Command cheat sheet
│   ├── CHANGELOG.md                # Version history
│   ├── PROJECT_SUMMARY.md          # This creation summary
│   └── INDEX.md                    # This file index
│
├── 💻 COMPUTE TEMPLATES (compute/)
│   ├── windows-vm.json             # Windows Server VM + Infrastructure
│   ├── linux-vm.json               # Ubuntu Linux VM + Infrastructure
│   ├── app-service-plan-webapp.json # Web App + App Service Plan
│   └── function-app.json           # Azure Functions + App Insights
│
├── 🌐 NETWORKING TEMPLATES (networking/)
│   ├── virtual-network.json        # VNet with multiple subnets
│   ├── network-security-group.json # NSG with security rules
│   └── load-balancer.json          # Standard Load Balancer
│
├── 💾 STORAGE TEMPLATES (storage/)
│   ├── storage-account.json        # Storage Account v2
│   └── blob-container.json         # Blob Storage + Container
│
├── 🗄️ DATABASE TEMPLATES (databases/)
│   ├── sql-database.json           # Azure SQL Database + Server
│   └── cosmos-db.json              # Cosmos DB (SQL API)
│
├── 📦 CONTAINER TEMPLATES (containers/)
│   ├── aks-cluster.json            # Azure Kubernetes Service
│   └── container-registry.json     # Azure Container Registry
│
├── 🔐 SECURITY TEMPLATES (security/)
│   └── key-vault.json              # Azure Key Vault
│
├── 📊 MONITORING TEMPLATES (monitoring/)
│   ├── log-analytics-workspace.json # Log Analytics Workspace
│   └── application-insights.json    # Application Insights
│
├── 📋 PARAMETER FILES (parameters/)
│   ├── windows-vm.parameters.json   # Windows VM parameters
│   ├── linux-vm.parameters.json     # Linux VM parameters
│   └── sql-database.parameters.json # SQL Database parameters
│
├── 🔧 DEPLOYMENT SCRIPTS (scripts/)
│   ├── deploy.sh ⚡                # Main deployment script (Bash)
│   ├── deploy.ps1 ⚡               # Main deployment script (PowerShell)
│   ├── quick-deploy.sh ⚡          # Interactive menu deployment
│   ├── validate-templates.sh ⚡    # Template validation utility
│   └── cleanup.sh ⚡               # Resource cleanup tool
│
└── ⚙️ CONFIGURATION
    ├── .gitignore                  # Git ignore rules
    └── LICENSE                     # MIT License

⚡ = Executable script (chmod +x applied)
```

---

## 📚 Documentation Files

### Core Documentation
| File | Purpose | Audience |
|------|---------|----------|
| `README.md` | Main documentation, quick start, deployment methods | All users |
| `GETTING_STARTED.md` | Step-by-step beginner guide | Beginners |
| `BEST_PRACTICES.md` | Advanced patterns and best practices | Intermediate/Advanced |
| `QUICK_REFERENCE.md` | Command reference and cheat sheet | All users |
| `CHANGELOG.md` | Version history and roadmap | All users |
| `PROJECT_SUMMARY.md` | Creation summary and overview | All users |

---

## 💻 ARM Templates by Category

### Compute Resources (4 templates)

#### 1. windows-vm.json
**Purpose**: Deploy Windows Server VM with complete infrastructure  
**Includes**: VM, VNet, Subnet, NSG, NIC, Public IP  
**Parameters**: vmName, adminUsername, adminPassword, vmSize, windowsOSVersion  
**Outputs**: publicIP, vmName  
**Use Case**: Windows-based applications, Active Directory, IIS servers

#### 2. linux-vm.json
**Purpose**: Deploy Ubuntu Linux VM with complete infrastructure  
**Includes**: VM, VNet, Subnet, NSG, NIC, Public IP  
**Parameters**: vmName, adminUsername, authenticationType, adminPasswordOrKey, vmSize  
**Outputs**: publicIP, sshCommand  
**Use Case**: Web servers, development environments, Docker hosts

#### 3. app-service-plan-webapp.json
**Purpose**: Deploy Web App with App Service Plan  
**Includes**: App Service Plan, Web App  
**Parameters**: webAppName, appServicePlanName, sku, runtime, location  
**Outputs**: webAppURL, webAppName  
**Use Case**: Web applications, APIs, containerized apps

#### 4. function-app.json
**Purpose**: Deploy Azure Functions with monitoring  
**Includes**: Function App, Storage Account, App Service Plan, Application Insights  
**Parameters**: functionAppName, storageAccountName, runtime, location  
**Outputs**: functionAppName, functionAppURL  
**Use Case**: Serverless applications, event processing, scheduled tasks

---

### Networking Resources (3 templates)

#### 1. virtual-network.json
**Purpose**: Create VNet with multiple subnets  
**Includes**: Virtual Network, Subnets  
**Parameters**: vnetName, vnetAddressPrefix, subnet names and prefixes  
**Outputs**: vnetId, subnet IDs  
**Use Case**: Network infrastructure, isolation, multi-tier applications

#### 2. network-security-group.json
**Purpose**: Configure network security rules  
**Includes**: Network Security Group with pre-configured rules  
**Parameters**: nsgName, location  
**Outputs**: nsgId  
**Use Case**: Network security, firewall rules, access control

#### 3. load-balancer.json
**Purpose**: Deploy Standard Load Balancer  
**Includes**: Load Balancer, Public IP, Health Probe, Backend Pool  
**Parameters**: loadBalancerName, publicIPName, location  
**Outputs**: loadBalancerId, publicIP  
**Use Case**: High availability, load distribution, scalability

---

### Storage Resources (2 templates)

#### 1. storage-account.json
**Purpose**: Create secure Storage Account  
**Includes**: Storage Account v2 with security features  
**Parameters**: storageAccountName, storageAccountType, location  
**Outputs**: storageAccountName, storageAccountId, primaryEndpoints  
**Use Case**: Blob storage, file shares, application data

#### 2. blob-container.json
**Purpose**: Deploy Blob Storage with container  
**Includes**: Storage Account, Blob Service, Container  
**Parameters**: storageAccountName, containerName, publicAccess  
**Outputs**: storageAccountName, blobEndpoint, containerName  
**Use Case**: Object storage, backups, static content

---

### Database Resources (2 templates)

#### 1. sql-database.json
**Purpose**: Deploy Azure SQL Database  
**Includes**: SQL Server, SQL Database, Firewall Rules  
**Parameters**: sqlServerName, sqlDatabaseName, admin credentials, databaseSku  
**Outputs**: sqlServerFQDN, databaseName  
**Use Case**: Relational databases, OLTP applications, data warehouses

#### 2. cosmos-db.json
**Purpose**: Deploy Cosmos DB with SQL API  
**Includes**: Cosmos DB Account, Database, Container  
**Parameters**: accountName, databaseName, containerName, throughput  
**Outputs**: cosmosDBEndpoint, accountName  
**Use Case**: NoSQL databases, globally distributed apps, low-latency data

---

### Container Resources (2 templates)

#### 1. aks-cluster.json
**Purpose**: Deploy Azure Kubernetes Service  
**Includes**: AKS Cluster with system node pool  
**Parameters**: clusterName, dnsPrefix, nodeCount, vmSize, kubernetesVersion  
**Outputs**: clusterName, controlPlaneFQDN  
**Use Case**: Container orchestration, microservices, cloud-native apps

#### 2. container-registry.json
**Purpose**: Deploy Azure Container Registry  
**Includes**: Container Registry  
**Parameters**: acrName, acrSku, location  
**Outputs**: loginServer, acrName  
**Use Case**: Docker image storage, CI/CD pipelines, private registries

---

### Security Resources (1 template)

#### 1. key-vault.json
**Purpose**: Deploy Azure Key Vault  
**Includes**: Key Vault with access policies  
**Parameters**: keyVaultName, tenantId, objectId, enablement flags  
**Outputs**: keyVaultName, vaultUri  
**Use Case**: Secret management, key storage, certificate management

---

### Monitoring Resources (2 templates)

#### 1. log-analytics-workspace.json
**Purpose**: Create Log Analytics Workspace  
**Includes**: Log Analytics Workspace  
**Parameters**: workspaceName, sku, retentionInDays  
**Outputs**: workspaceId, workspaceName  
**Use Case**: Log aggregation, monitoring, security analytics

#### 2. application-insights.json
**Purpose**: Deploy Application Insights  
**Includes**: Application Insights component  
**Parameters**: appInsightsName, applicationType, location  
**Outputs**: instrumentationKey, connectionString  
**Use Case**: Application monitoring, performance tracking, diagnostics

---

## 🔧 Deployment Scripts

### Bash Scripts

#### 1. deploy.sh
**Purpose**: Interactive deployment script  
**Features**: Login check, validation, resource group creation, deployment  
**Usage**: `./scripts/deploy.sh`

#### 2. quick-deploy.sh
**Purpose**: Menu-driven deployment for common scenarios  
**Features**: 12 pre-configured deployment options  
**Usage**: `./scripts/quick-deploy.sh`

#### 3. validate-templates.sh
**Purpose**: Validate ARM template syntax  
**Features**: JSON validation, required property checks  
**Usage**: `./scripts/validate-templates.sh <file-or-directory>`  
**Requires**: jq

#### 4. cleanup.sh
**Purpose**: Resource and deployment management  
**Features**: List, view, delete resources  
**Usage**: `./scripts/cleanup.sh`

### PowerShell Scripts

#### 1. deploy.ps1
**Purpose**: PowerShell deployment script  
**Features**: Module check, validation, deployment  
**Usage**: `.\scripts\deploy.ps1`  
**Requires**: Az PowerShell module

---

## 📋 Parameter Files

### Example Parameter Files
- `windows-vm.parameters.json` - Windows VM deployment parameters
- `linux-vm.parameters.json` - Linux VM deployment parameters
- `sql-database.parameters.json` - SQL Database deployment parameters

**Note**: These are examples. Create your own parameter files with actual values.

---

## ⚙️ Configuration Files

### .gitignore
Ignores:
- Deployment outputs
- Local parameter files
- Temporary files
- IDE configurations
- Secrets

### LICENSE
- MIT License
- Open source
- Free to use and modify

---

## 🎯 Quick Navigation Guide

### I want to deploy a...

**Virtual Machine**
- Windows: `compute/windows-vm.json`
- Linux: `compute/linux-vm.json`

**Web Application**
- Web App: `compute/app-service-plan-webapp.json`
- Serverless: `compute/function-app.json`

**Database**
- SQL: `databases/sql-database.json`
- NoSQL: `databases/cosmos-db.json`

**Networking**
- VNet: `networking/virtual-network.json`
- Security: `networking/network-security-group.json`
- Load Balancer: `networking/load-balancer.json`

**Storage**
- General: `storage/storage-account.json`
- Blob: `storage/blob-container.json`

**Containers**
- Kubernetes: `containers/aks-cluster.json`
- Registry: `containers/container-registry.json`

**Security**
- Key Vault: `security/key-vault.json`

**Monitoring**
- Logs: `monitoring/log-analytics-workspace.json`
- APM: `monitoring/application-insights.json`

---

## 📖 Documentation Navigation

**New to ARM Templates?**  
→ Start with `GETTING_STARTED.md`

**Ready to deploy?**  
→ Check `README.md` for deployment methods

**Need quick commands?**  
→ Use `QUICK_REFERENCE.md`

**Want to learn best practices?**  
→ Read `BEST_PRACTICES.md`

**Looking for version history?**  
→ See `CHANGELOG.md`

**Want project overview?**  
→ Read `PROJECT_SUMMARY.md`

---

## 🔍 Finding What You Need

### By Use Case
| Use Case | Templates | Documentation |
|----------|-----------|---------------|
| Web Hosting | app-service-plan-webapp.json, linux-vm.json | GETTING_STARTED.md |
| Databases | sql-database.json, cosmos-db.json | BEST_PRACTICES.md (Security) |
| Containers | aks-cluster.json, container-registry.json | README.md |
| Networking | All networking/* | QUICK_REFERENCE.md |
| Security | key-vault.json, network-security-group.json | BEST_PRACTICES.md |
| Monitoring | monitoring/* | README.md |

### By Complexity
| Level | Templates | Start Here |
|-------|-----------|------------|
| Beginner | storage-account.json, virtual-network.json | GETTING_STARTED.md |
| Intermediate | *-vm.json, app-service-plan-webapp.json | README.md |
| Advanced | aks-cluster.json, load-balancer.json | BEST_PRACTICES.md |

---

## 🎓 Learning Path

1. **Day 1**: Read GETTING_STARTED.md
2. **Day 2**: Deploy storage-account.json
3. **Day 3**: Deploy linux-vm.json
4. **Day 4**: Read BEST_PRACTICES.md
5. **Day 5**: Deploy app-service-plan-webapp.json
6. **Week 2**: Explore advanced templates
7. **Week 3**: Create custom templates
8. **Week 4**: Implement CI/CD

---

## 📞 Getting Help

- **Can't find something?** Check this INDEX.md
- **Deployment failing?** See QUICK_REFERENCE.md (Troubleshooting)
- **Security questions?** Read BEST_PRACTICES.md (Security section)
- **New to Azure?** Start with GETTING_STARTED.md
- **Need commands?** Use QUICK_REFERENCE.md

---

**Last Updated**: November 1, 2025  
**Repository Version**: 1.0.0  
**Total Resources**: 32 files, 10 directories

---

*This index is automatically maintained. For the latest file count, run:*
```bash
find . -type f -not -path '*/\.git/*' | wc -l
```
