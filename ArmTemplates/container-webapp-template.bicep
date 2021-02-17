param webAppName string
param hostingPlanName string
param appInsightsLocation string
param sku string = 'Standard'
param registryName string
param imageName string
param registryLocation string
param registrySku string = 'Standard'
param startupCommand string = ''

resource webAppName_resource 'Microsoft.Web/sites@2016-03-01' = {
  name: webAppName
  location: resourceGroup().location
  tags: {
    'hidden-related:/subscriptions/${subscription().subscriptionId}/resourcegroups/${resourceGroup().name}/providers/Microsoft.Web/serverfarms/${hostingPlanName}': 'empty'
  }
  properties: {
    name: webAppName
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${reference('Microsoft.ContainerRegistry/registries/${registryName}').loginServer}'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: listCredentials('Microsoft.ContainerRegistry/registries/${registryName}', '2017-10-01').username
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: listCredentials('Microsoft.ContainerRegistry/registries/${registryName}', '2017-10-01').passwords[0].value
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(Microsoft_Insights_components_webAppName.id, '2015-05-01').InstrumentationKey
        }
      ]
      appCommandLine: startupCommand
      linuxFxVersion: 'DOCKER|${reference('Microsoft.ContainerRegistry/registries/${registryName}').loginServer}/${imageName}'
    }
    serverFarmId: '/subscriptions/${subscription().subscriptionId}/resourcegroups/${resourceGroup().name}/providers/Microsoft.Web/serverfarms/${hostingPlanName}'
    hostingEnvironment: ''
  }
  dependsOn: [
    hostingPlanName_resource
  ]
}

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

resource hostingPlanName_resource 'Microsoft.Web/serverfarms@2016-09-01' = {
  sku: {
    tier: first(skip(split(sku, ' '), 1))
    name: first(split(sku, ' '))
  }
  kind: 'linux'
  name: hostingPlanName
  location: resourceGroup().location
  properties: {
    name: hostingPlanName
    workerSizeId: '0'
    reserved: true
    numberOfWorkers: '1'
    hostingEnvironment: ''
  }
}

resource Microsoft_Insights_components_webAppName 'Microsoft.Insights/components@2014-04-01' = {
  name: webAppName
  location: appInsightsLocation
  tags: {
    'hidden-link:${resourceGroup().id}/providers/Microsoft.Web/sites/${webAppName}': 'Resource'
  }
  properties: {
    applicationId: webAppName
    Request_Source: 'AzureTfsExtensionAzureProject'
  }
}