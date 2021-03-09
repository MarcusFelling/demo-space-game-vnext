// Web App
param servicePlanName string
param appServiceName string
param appSku string = 'S1'
param startupCommand string = ''
param registryName string
param registrySku string = 'Standard'
param imageName string
param sqlServer string
param dbName string
param dbUserName string
param dbPassword string {
  secure: true
}
param devEnv string // Used in condition for deployment slots

// Create registry where app image is stored
resource registry 'Microsoft.ContainerRegistry/registries@2017-10-01' = {
  name: registryName
  location: resourceGroup().location  
  sku: {
    name: registrySku
  }
  properties: {
    adminUserEnabled: 'true'
  }
}

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

