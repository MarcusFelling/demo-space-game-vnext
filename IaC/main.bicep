// Creates all infrastructure for Space Game
targetScope = 'subscription' // switch to sub scope to create resource group
param environmentName string
param resourceGroupName string
param acrResourceGroupName string
param appServiceName string
param servicePlanName string
param appSku string
param registryName string
param imageName string
param tag string
param registrySku string
param startupCommand string = ''
param sqlServerName string
param dbName string
param dbUserName string
@secure()
param dbPassword string
param devEnv string // Used for conditionals on features like deployment slots

// Create resource group for webapp and db
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: deployment().location
}

// Create resource group for ACR
resource acrrg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: acrResourceGroupName
  location: deployment().location
}

// Create registry
module registry 'registry.bicep' = {
  name: 'spacegame-registry-${environmentName}'
  scope: acrrg
  params:{
    registry: registryName
    registrySku: registrySku
  }
}

// Create database infrastructure
module db 'db.bicep' = {
  name: 'spacegame-db-${environmentName}'
  scope: rg
  params:{
    sqlServerName: sqlServerName
    dbName: dbName   
    dbUserName: dbUserName
    dbPassword: dbPassword         
  }
}

// Create web app infrastructure
module webapp 'webapp.bicep' = {
  name: 'spacegame-webapp-${environmentName}'
  scope: rg
  params:{
    servicePlanName: servicePlanName
    appServiceName: appServiceName
    appSku: appSku
    acrResourceGroupName: acrrg.name
    registry: registry.outputs.acrName
    imageName: imageName
    tag: tag
    sqlServer: db.outputs.sqlServerFQDN // Use output from db module to set connection string
    dbName: dbName // Used for connection string
    dbUserName: dbUserName // Used for connection string
    dbPassword: dbPassword // Used for connection string
    devEnv: devEnv
    }
}    
