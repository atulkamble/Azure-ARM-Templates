# Azure ARM Template Deployment Script (PowerShell)
# This script deploys ARM templates to Azure

param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName,
    
    [Parameter(Mandatory=$false)]
    [string]$Location,
    
    [Parameter(Mandatory=$false)]
    [string]$TemplateFile,
    
    [Parameter(Mandatory=$false)]
    [string]$ParametersFile
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to check if Azure PowerShell module is installed
function Test-AzureModule {
    Write-ColorOutput "[INFO] Checking Azure PowerShell module..." -Color Green
    
    if (Get-Module -ListAvailable -Name Az) {
        Write-ColorOutput "[INFO] Azure PowerShell module is installed" -Color Green
        return $true
    } else {
        Write-ColorOutput "[ERROR] Azure PowerShell module is not installed" -Color Red
        Write-ColorOutput "[INFO] Install it using: Install-Module -Name Az -AllowClobber -Scope CurrentUser" -Color Yellow
        return $false
    }
}

# Function to connect to Azure
function Connect-ToAzure {
    Write-ColorOutput "[INFO] Checking Azure connection..." -Color Green
    
    try {
        $context = Get-AzContext
        if ($null -eq $context) {
            Write-ColorOutput "[WARNING] Not connected to Azure. Initiating login..." -Color Yellow
            Connect-AzAccount
        } else {
            Write-ColorOutput "[INFO] Already connected to Azure" -Color Green
            Write-ColorOutput "[INFO] Current subscription: $($context.Subscription.Name)" -Color Cyan
        }
    } catch {
        Write-ColorOutput "[ERROR] Failed to connect to Azure: $_" -Color Red
        exit 1
    }
}

# Function to create resource group if it doesn't exist
function New-ResourceGroupIfNotExists {
    param(
        [string]$ResourceGroupName,
        [string]$Location
    )
    
    Write-ColorOutput "[INFO] Checking if resource group exists..." -Color Green
    
    $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    
    if ($null -eq $rg) {
        Write-ColorOutput "[WARNING] Resource group does not exist. Creating..." -Color Yellow
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        Write-ColorOutput "[INFO] ✓ Resource group created" -Color Green
    } else {
        Write-ColorOutput "[INFO] Resource group already exists" -Color Green
    }
}

# Function to validate ARM template
function Test-ARMTemplate {
    param(
        [string]$ResourceGroupName,
        [string]$TemplateFile,
        [string]$ParametersFile
    )
    
    Write-ColorOutput "[INFO] Validating ARM template..." -Color Green
    
    try {
        if ([string]::IsNullOrEmpty($ParametersFile)) {
            Test-AzResourceGroupDeployment `
                -ResourceGroupName $ResourceGroupName `
                -TemplateFile $TemplateFile
        } else {
            Test-AzResourceGroupDeployment `
                -ResourceGroupName $ResourceGroupName `
                -TemplateFile $TemplateFile `
                -TemplateParameterFile $ParametersFile
        }
        
        Write-ColorOutput "[INFO] ✓ Template validation successful" -Color Green
        return $true
    } catch {
        Write-ColorOutput "[ERROR] ✗ Template validation failed: $_" -Color Red
        return $false
    }
}

# Function to deploy ARM template
function Deploy-ARMTemplate {
    param(
        [string]$ResourceGroupName,
        [string]$TemplateFile,
        [string]$ParametersFile,
        [string]$DeploymentName
    )
    
    Write-ColorOutput "[INFO] Starting deployment: $DeploymentName" -Color Green
    Write-ColorOutput "[INFO] Resource Group: $ResourceGroupName" -Color Cyan
    Write-ColorOutput "[INFO] Template: $TemplateFile" -Color Cyan
    
    try {
        if ([string]::IsNullOrEmpty($ParametersFile)) {
            $deployment = New-AzResourceGroupDeployment `
                -Name $DeploymentName `
                -ResourceGroupName $ResourceGroupName `
                -TemplateFile $TemplateFile `
                -Verbose
        } else {
            Write-ColorOutput "[INFO] Parameters: $ParametersFile" -Color Cyan
            $deployment = New-AzResourceGroupDeployment `
                -Name $DeploymentName `
                -ResourceGroupName $ResourceGroupName `
                -TemplateFile $TemplateFile `
                -TemplateParameterFile $ParametersFile `
                -Verbose
        }
        
        Write-ColorOutput "[INFO] ✓ Deployment completed successfully!" -Color Green
        return $deployment
    } catch {
        Write-ColorOutput "[ERROR] ✗ Deployment failed: $_" -Color Red
        exit 1
    }
}

# Main script execution
Write-ColorOutput "=== Azure ARM Template Deployment Script ===" -Color Cyan

# Check prerequisites
if (-not (Test-AzureModule)) {
    exit 1
}

# Connect to Azure
Connect-ToAzure

# Get input parameters if not provided
if ([string]::IsNullOrEmpty($ResourceGroupName)) {
    $ResourceGroupName = Read-Host "Enter Resource Group name"
}

if ([string]::IsNullOrEmpty($Location)) {
    $Location = Read-Host "Enter Azure region (e.g., eastus)"
}

if ([string]::IsNullOrEmpty($TemplateFile)) {
    $TemplateFile = Read-Host "Enter template file path"
}

if ([string]::IsNullOrEmpty($ParametersFile)) {
    $ParametersFile = Read-Host "Enter parameters file path (leave empty if none)"
}

# Generate deployment name with timestamp
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$DeploymentName = "deployment-$timestamp"

# Create resource group if it doesn't exist
New-ResourceGroupIfNotExists -ResourceGroupName $ResourceGroupName -Location $Location

# Validate template
if (-not (Test-ARMTemplate -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -ParametersFile $ParametersFile)) {
    exit 1
}

# Deploy template
$deployment = Deploy-ARMTemplate `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $TemplateFile `
    -ParametersFile $ParametersFile `
    -DeploymentName $DeploymentName

# Show deployment outputs
if ($deployment.Outputs) {
    Write-ColorOutput "`n[INFO] Deployment Outputs:" -Color Green
    $deployment.Outputs | Format-Table -AutoSize
}

Write-ColorOutput "`n=== Deployment Complete ===" -Color Cyan
