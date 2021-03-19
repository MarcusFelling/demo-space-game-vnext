// Web App
param environmentName string
param appName string
param branchName string = '' // only passed in for dev environment
param appSku string = 'S1'
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
  name: '${appName}-${environmentName}-plan'
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
  scope: resourceGroup('${appName}-ACR-rg')
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: '${appName}${branchName}'
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

// Monitor
resource appInsights 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: 'AppInsights${appService.name}'
  location: resourceGroup().location
  tags: {
    'hidden-link:${appService.id}': 'Resource'
    displayName: 'AppInsightsComponent'
  }
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

