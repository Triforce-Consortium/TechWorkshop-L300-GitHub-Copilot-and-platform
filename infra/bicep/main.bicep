@description('Name of the resource group (uses current RG when deploying with az)')
param resourceGroupName string = resourceGroup().name
param location string = 'westus3'

@description('Container registry name (unique within subscription)')
param registryName string = 'zavastorefrontacr'

@description('App Service plan name')
param planName string = 'zavastorefront-plan'

@description('App Service name')
param appName string = 'zavastorefront-app'

@description('Application Insights name')
param appInsightsName string = appName + '-ai'

@description('Foundry workspace name (placeholder)')
param foundryName string = appName + '-foundry'

// Deploy ACR
module acr './modules/acr.bicep' = {
  name: 'acrModule'
  params: {
    registryName: registryName
    location: location
  }
}

// Deploy App Insights
module ai './modules/appinsights.bicep' = {
  name: 'appInsightsModule'
  params: {
    appInsightsName: appInsightsName
    location: location
  }
}

// Deploy App Service Plan + Web App (system-assigned identity)
module appsvc './modules/appservice.bicep' = {
  name: 'appServiceModule'
  params: {
    appName: appName
    planName: planName
    location: location
    registryLoginServer: acr.outputs.loginServer
    // imageName intentionally empty now; CI will update web app to image tag
    imageName: ''
    appInsightsConnectionString: ai.outputs.connectionString
  }
}

// Assign AcrPull role on ACR to the web app's system identity
module roleAssign './modules/roleAssignment.bicep' = {
  name: 'roleAssignModule'
  params: {
    principalId: appsvc.outputs.principalId
    scope: acr.outputs.registryId
  }
  dependsOn: [appsvc, acr]
}

// Placeholder Foundry module
module foundry './modules/foundry.bicep' = {
  name: 'foundryModule'
  params: {
    foundryWorkspaceName: foundryName
    location: location
  }
}

output webAppHostName string = appsvc.outputs.defaultHostName
output acrLoginServer string = acr.outputs.loginServer
output appInsightsConnection string = ai.outputs.connectionString
