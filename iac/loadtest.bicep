@description('Application name - used as prefix for resource names')
param appName string

resource loadtest 'Microsoft.LoadTestService/loadTests@2021-12-01-preview' = {
  name: '${appName}-loadtest'
  location: 'EastUS' // public preview not available in WestUS
  properties: {
    description: 'Load test for ${appName}'
  }
}
