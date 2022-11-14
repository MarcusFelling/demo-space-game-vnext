// Creates all infrastructure for Space Game
targetScope = 'subscription' // switch to sub scope to create resource group

// PARAMETERS
@description('Application name - used as prefix for resource names')
param appName string
@description('Environment name')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string
@description('Source branch passed in via pipeline for dev environment')
param branch string = ''
@description('Primary location for all resources')
param location string = deployment().location
@description('Name of shared registry')
param registryName string
@description('Container image tag - uses commit SHA passed in via pipeline')
param tag string
@description('Database user name')
param dbUserName string
@description('Database password - passed in via GitHub secret')
@secure()
param dbPassword string
@description('Boolean for Dev environments - Used in conditions for resources that are skipped in dev (deploy slots, app insights, etc)')
param devEnv bool = false

// RESOURCES
// Create resource group for webapp and db
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${appName}-${environmentName}-rg'
  location: location
}

// Create resource group for ACR
resource acrrg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${appName}-ACR-rg'
  location: location
}

// Create resource group for Azure Load Testing
resource loadtestrg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${appName}-loadtest-rg'
  location: 'EastUS' // public preview not available in west US
}

// Create shared registry
module registry 'registry.bicep' = {
  name: '${appName}-registry-${uniqueString(acrrg.name)}'
  scope: acrrg
  params: {
    registry: registryName
    registrySku: 'Standard'
    location: location
  }
}

// Create database infrastructure
module db 'db.bicep' = {
  name: '${appName}-db-${environmentName}-${uniqueString(rg.name)}'
  scope: rg
  params: {
    sqlServerName: '${appName}-${environmentName}-sql'
    dbName: '${appName}database'
    dbUserName: dbUserName
    dbPassword: dbPassword
    location: location
  }
}

// Create web app infrastructure
module webapp 'webapp.bicep' = {
  name: '${appName}-webapp-${environmentName}-${uniqueString(rg.name)}'
  scope: rg
  params: {
    environmentName: environmentName
    appName: appName
    branch: branch
    appSku: 'S2'
    registry: registry.outputs.acrName
    tag: tag
    devEnv: devEnv
    // Use output from db module to set connection string
    sqlServer: db.outputs.sqlServerFQDN
    dbName: db.outputs.databaseName
    dbUserName: db.outputs.userName
    dbPassword: dbPassword
    location: location
  }
}

// Create Azure Load Test infrastructure
module loadtest 'loadtest.bicep' = {
  name: '${appName}-loadtest-${uniqueString(loadtestrg.name)}'
  scope: loadtestrg
  params: {
    appName: appName
  }
}
