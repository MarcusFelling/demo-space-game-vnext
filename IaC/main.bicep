// Creates all infrastructure for Space Game
targetScope = 'subscription' // switch to sub scope to create resource group

param resourceGroupName string
param appServiceName string
param servicePlanName string
param appSku string
param registryName string
param imageName string
param registrySku string
param startupCommand string = ''
param sqlServerName string
param dbName string
param dbUserName string
param dbPassword string {
  secure: true
}
param devEnv string // Used for conditionals on features like deployment slots

// Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: resourceGroupName
  location: deployment().location
}

// Create registry
module registry 'registry.bicep' = {
  name: 'registry'
  scope: rg
  params:{
    registryName: registryName
    registrySku: registrySku
  }
}

// Create sql
module sql 'sql.bicep' = {
  name: 'sql'
  scope: rg
  params:{
    sqlServerName: sqlServerName
    dbName: dbName   
    dbUserName: dbUserName
    dbPassword: dbPassword         
  }
}

// Create web app 
module webapp 'webapp.bicep' = {
  name: 'webapp'
  scope: rg
  params:{
    servicePlanName: servicePlanName
    appServiceName: appServiceName
    appSku: appSku
    registryName: registryName
    imageName: imageName
    sqlServer: sql.outputs.sqlServerFQDN // Use output from sql module to set connection string
    dbName: dbName // Used for connection string
    dbUserName: dbUserName // Used for connection string
    dbPassword: dbPassword // Used for connection string
    devEnv: devEnv
    }
}    
