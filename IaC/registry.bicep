param registry string
param registrySku string = 'Standard'

resource acr 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: registry
  location: resourceGroup().location  
  sku: {
    name: registrySku
  }
  properties: {
    adminUserEnabled: true
  }
}

output acrName string = acr.name