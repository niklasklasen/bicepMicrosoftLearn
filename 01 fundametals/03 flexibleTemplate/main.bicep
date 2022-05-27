@description('The Azure regions in which the resources should be deployed')
param locations array = [
  'westeurope'
  'eastus2'
]

@secure()
@description('Admin login username for SQL server')
param sqlServerAdministratorLogin string

@secure()
@description('Admin password for SQL server')
param sqlServerAdministratorPassword string

module databases 'modules/database.bicep' = [for location in locations: {
  name: 'database-${location}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorPassword: sqlServerAdministratorPassword
  }
}]
