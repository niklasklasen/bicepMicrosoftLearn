@description('Name of the environment. Must be dev, test or prod')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('Name of the soulution. This is used to ensure that resources are unique.')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The number of App Serivce Plan instances')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('Then name and tier of the App Service Plan SKU.')
param appServicePlanSku object

@description('The region where the Azure resources should be deployed')
param location string = 'westus3'

@secure()
@description('Admin login username for the SQL Server')
param sqlServerAdministratorLogin string

@secure()
@description('Password for the admin login')
param sqlServerAdministratorPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'
var sqlServerName = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
   administratorLogin: sqlServerAdministratorLogin
   administratorLoginPassword: sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
}
