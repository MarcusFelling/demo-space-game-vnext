// Web App
param servicePlanName string
param appServiceName string
param appSku string = 'S1'
param startupCommand string = ''
param acrResourceGroupName string
param registry string
param imageName string
param tag string
param sqlServer string
param dbName string
param dbUserName string
@secure()
param dbPassword string
param devEnv string // Used in condition for deployment slots

resource servicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  kind: 'linux'
  name: servicePlanName
  location: resourceGroup().location
  sku: {
    name: appSku
  }
  properties: {
    reserved:true
  }
}

// Reference existing ACR for docker app settings.
// This resource will not be deployed by this file, but the declaration provides access to properties on the existing resource.
resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' existing = {
  name: registry
  scope: resourceGroup(acrResourceGroupName)
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceName
  location: resourceGroup().location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'          
          value: acr.properties.loginServer
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: listCredentials(acr.id, acr.apiVersion).username
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: listCredentials(acr.id, acr.apiVersion).passwords[0].value
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
      ]
      appCommandLine: startupCommand
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/${imageName}:${tag}'
    }
    serverFarmId: '${servicePlan.id}'    
  }
}

resource connectionString 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${appService.name}/connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Data Source=tcp:${sqlServer},1433;Initial Catalog=${dbName};User Id=${dbUserName}@${sqlServer};Password=${dbPassword};'
      type: 'SQLAzure'
    }
  }
}

// Create deployment slot if it's not a dev environment
resource deploySlot 'Microsoft.Web/sites/slots@2020-06-01' = if(devEnv == 'false') {
  name: '${appService.name}/swap'
  location: resourceGroup().location
  kind: 'linux'
  properties: {
    enabled: true
    serverFarmId: '${servicePlan.id}'
  }
}

