param appName string
param planName string
param location string = resourceGroup().location
param registryLoginServer string = ''
param imageName string = ''
param appInsightsConnectionString string = ''

resource plan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: planName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    capacity: 1
  }
  properties: {
    reserved: true
  }
}

resource web 'Microsoft.Web/sites@2021-02-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: (empty(registryLoginServer) || empty(imageName)) ? '' : 'DOCKER|' + registryLoginServer + '/' + imageName
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
      ]
    }
  }
}

output webAppId string = web.id
output principalId string = web.identity.principalId
output defaultHostName string = web.properties.defaultHostName
