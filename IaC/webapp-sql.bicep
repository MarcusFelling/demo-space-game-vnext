param appServiceName string
param servicePlanName string
param appSku string = 'Standard'
param registryName string
param imageName string
param registrySku string = 'Standard'
param startupCommand string = ''
param sqlServerName string
param dbName string
param dbUserName string
param dbPassword string {
  secure: true
}

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

// Web App
resource servicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  kind: 'linux'
  name: servicePlanName
  location: resourceGroup().location
  sku: {
    tier: first(skip(split(appSku, ' '), 1))
    name: first(split(appSku, ' '))
  }
  properties: {
    reserved:true
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceName
  location: resourceGroup().location
  properties: {
    siteConfig: {
      netFrameworkVersion: 'v5.0'
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'          
          value: registry.properties.loginServer
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: listCredentials('Microsoft.ContainerRegistry/registries/${registryName}', '2017-10-01').username
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: listCredentials('Microsoft.ContainerRegistry/registries/${registryName}', '2017-10-01').passwords[0].value
        }
      ]
      appCommandLine: startupCommand
      linuxFxVersion: 'DOCKER|${reference('Microsoft.ContainerRegistry/registries/${registryName}').loginServer}/${imageName}'
    }
    serverFarmId: '${servicePlan.id}'
  }
}

resource connectionString 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${appService.name}/connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Data Source=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${dbName};User Id=${dbUserName}@${sqlServer.properties.fullyQualifiedDomainName};Password=${dbPassword};'
      type: 'SQLAzure'
    }
  }
}

// Registry
resource registry 'Microsoft.ContainerRegistry/registries@2017-10-01' = {
  name: registryName
  location: resourceGroup().location  
  sku: {
    name: registrySku
  }
}
