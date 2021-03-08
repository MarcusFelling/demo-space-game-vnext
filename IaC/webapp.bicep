// Web App
param servicePlanName string
param appServiceName string
param appSku string = 'Standard'
param startupCommand string = ''
param registryName string
param registryLoginServer string
param imageName string
param sqlServer string
param dbName string
param dbUserName string
param dbPassword string {
  secure: true
}
param devEnv string // Used in condition for deployment slots

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
          value: registryLoginServer
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
      value: 'Data Source=tcp:${sqlServer},1433;Initial Catalog=${dbName};User Id=${dbUserName}@${sqlServer};Password=${dbPassword};'
      type: 'SQLAzure'
    }
  }
}

// Create deployment slot if it's not a dev environment
resource deploySlot 'Microsoft.Web/sites/slots@2018-11-01' = if(devEnv == 'false') {
  name: '${appService.name}/swap'
  location: resourceGroup().location
  kind: 'linux'
  properties: {
    enabled: true
    serverFarmId: '${servicePlan.id}'
  }
}

