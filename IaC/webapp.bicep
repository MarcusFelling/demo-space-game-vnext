// PARAMETERS
@description('Environment name')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string
@description('Primary location for resources')
param location string = resourceGroup().location
@description('Application name - used as prefix for resource names')
param appName string
@description('Source branch of PR - passed in via pipeline for dev environment')
param branchName string = ''
@description('App Service Plan SKU')
@allowed([
  'S1'
  'S2'
  'S3'
])
param appSku string = 'S2'
@description('Name of shared registry')
param registry string
@description('Container image tag - uses commit SHA passed in via pipeline')
param tag string
@description('Name of SQL Server instance - default is %appName%-%environmentName%-sql')
param sqlServer string
@description('Name of database - default is %appName%database')
param dbName string
@description('Database user name')
param dbUserName string
@description('Database password - passed in via GitHub secret')
@secure()
param dbPassword string
@description('Boolean for Dev environments - Used in conditions for resources that are skipped in dev (deploy slots, app insights, etc)')
param devEnv bool = false

// RESOURCES
resource servicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  kind: 'linux'
  name: '${appName}-${environmentName}-plan'
  location: location
  sku: {
    name: appSku
  }
  properties: {
    reserved: true
  }
}

// Reference existing ACR for docker app settings.
// This resource will not be deployed by this file, but the declaration provides access to properties on the existing resource.
resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' existing = {
  name: registry
  scope: resourceGroup('${appName}-ACR-rg')
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: '${appName}-${environmentName}${branchName}'
  location: location
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
      linuxFxVersion: 'DOCKER|${acr.properties.loginServer}/${appName}:${tag}'
    }
    serverFarmId: '${servicePlan.id}'
  }

  resource connectionString 'config@2020-06-01' = {
    name: 'connectionstrings'
    properties: {
      DefaultConnection: {
        value: 'Data Source=tcp:${sqlServer},1433;Initial Catalog=${dbName};User Id=${dbUserName}@${sqlServer};Password=${dbPassword};'
        type: 'SQLAzure'
      }
    }
  }

  // Create deployment slot if it's not a dev environment
  resource deploySlot 'slots@2020-06-01' = if (!devEnv) {
    name: 'swap'
    location: location
    kind: 'linux'
    properties: {
      enabled: true
      serverFarmId: '${servicePlan.id}'
    }
  }
}

// Creat app insights if it's not a dev environment
resource appInsights 'Microsoft.Insights/components@2018-05-01-preview' = if (!devEnv) {
  name: '${appService.name}-monitor'
  location: location
  tags: {
    'hidden-link:${appService.id}': 'Resource'
    displayName: 'AppInsightsComponent'
  }
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}
