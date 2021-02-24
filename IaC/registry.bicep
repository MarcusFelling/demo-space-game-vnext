param registryName string
param registryLocation string
param registrySku string = 'Standard'

resource registryName_resource 'Microsoft.ContainerRegistry/registries@2017-10-01' = {
  sku: {
    name: registrySku
  }
  name: registryName
  location: registryLocation
  properties: {
    adminUserEnabled: 'true'
  }
}