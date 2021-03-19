// SQL
param sqlServerName string
param dbName string
param dbUserName string
@secure()
param dbPassword string

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: resourceGroup().location
  properties: {
    administratorLogin: dbUserName
    administratorLoginPassword: dbPassword
    version: '12.0'
  }
}

resource database 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqlServer.name}/${dbName}'
  location: resourceGroup().location
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    autoPauseDelay: 60
    storageAccountType: 'GRS'
    minCapacity: 1
  }
}

resource firewallAllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2015-05-01-preview' = {
  name: '${sqlServer.name}/AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

// Use outputs for connection string in web app module
output sqlServerFQDN string = sqlServer.properties.fullyQualifiedDomainName
output databaseName string = database.name
output userName string = sqlServer.properties.administratorLogin
output password string = sqlServer.properties.administratorLoginPassword
