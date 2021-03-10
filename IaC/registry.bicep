param registryName string
param registrySku string = 'Standard'

resource registry 'Microsoft.ContainerRegistry/registries@2017-10-01' = {
  name: registryName
  location: resourceGroup().location  
  sku: {
    name: registrySku
  }
  properties: {
    adminUserEnabled: true
  }
}

output registryLoginServer string = registry.properties.loginServer
