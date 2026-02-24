# Infra: Azure Bicep scaffold

This folder contains a minimal Bicep scaffold to provision the development
infrastructure for the `ZavaStorefront` app in `westus3`.

Included:
- `bicep/main.bicep` — orchestration that deploys ACR, App Service, App Insights,
  and a placeholder for Microsoft Foundry.
- `bicep/modules/*` — modular resource definitions.

How to deploy (local with `az`):

```bash
# login: use Azure CLI or a service principal
az login

# create resource group
az group create -n zavastorefront-rg -l westus3

# deploy bicep
az deployment group create \
  --resource-group zavastorefront-rg \
  --template-file infra/bicep/main.bicep \
  --parameters registryName=zavastorefrontacr appName=zavastorefront-app location=westus3
```

Notes:
- App Service is created with a system-assigned managed identity. The
  `roleAssignment` module grants the `AcrPull` role on ACR to that identity so
  App Service can pull images without credentials.
- The `foundry` module is a placeholder — Microsoft Foundry APIs may require
  tenant-specific provisioning and quota requests; follow your subscription
  onboarding steps to enable GPT-4 and Phi in `westus3`.
- CI (GitHub Actions) builds and pushes the Docker image to ACR, then updates
  the App Service container configuration. Developers do not need to run
  Docker locally.
