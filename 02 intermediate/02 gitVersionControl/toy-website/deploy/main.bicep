@description('Region that the resources should be deployed')
param loaction string = resourceGroup().location

@description('The type of environment, must be nonprod or prod')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
