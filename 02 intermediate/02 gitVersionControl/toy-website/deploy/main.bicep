@description('Region that the resources should be deployed')
param loaction string = resourceGroup().location

@description('The type of environment, must be nonprod or prod')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@description('The name of the App Service, must be globaly unique.')
param appServiceAppName string = 'toyweb-${uniqueString(resourceGroup().id)}'

module appService 'modules/app-service.bicep' = {
  name: 'app-service'
  params: {
    appServiceAppName: appServiceAppName
    environmentType: environmentType
    location: loaction
  }
}
