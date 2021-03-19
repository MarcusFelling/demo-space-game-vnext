// Creates all infrastructure for Space Game
targetScope = 'subscription' // switch to sub scope to create resource group

param appName string // Used as base name of resources
param environmentName string
param branchName string = ''
param appSku string
param registryName string
param imageName string
param tag string
param registrySku string
param dbUserName string
@secure()
param dbPassword string
param devEnv string // Used for conditionals on features like deployment slots

// Create resource group for webapp and db
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${appName}-${environmentName}-rg'
  location: deployment().location
}

// Create resource group for ACR
resource acrrg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${appName}-ACR-rg'
  location: deployment().location
}

// Create registry
module registry 'registry.bicep' = {
  name: '${appName}-registry-${environmentName}-${uniqueString(acrrg.name)}'
  scope: acrrg
  params:{
    registry: registryName
    registrySku: registrySku
  }
}

// Create database infrastructure
module db 'db.bicep' = {
  name: '${appName}-db-${environmentName}-${uniqueString(rg.name)}'
  scope: rg
  params:{
    sqlServerName: '${appName}-${environmentName}-sql'
    dbName: '${appName}database'   
    dbUserName: dbUserName
    dbPassword: dbPassword         
  }
}

// Create web app infrastructure
module webapp 'webapp.bicep' = {
  name: '${appName}-webapp-${environmentName}-${uniqueString(rg.name)}'
  scope: rg
  params:{
    environmentName: environmentName
    appName: '${appName}${branchName}'
    appSku: appSku
    registry: registry.outputs.acrName
    imageName: imageName
    tag: tag
    // Use output from db module to set connection string
    sqlServer: db.outputs.sqlServerFQDN
    dbName: db.outputs.databaseName 
    dbUserName: db.outputs.userName 
    dbPassword: dbPassword
    devEnv: devEnv
    }
}    
