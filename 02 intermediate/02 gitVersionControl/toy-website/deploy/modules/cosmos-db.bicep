@description('The Azure region where the resources should be deployed.')
param location string

@description('The type of environment, must be nonprod or prod')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@description('The name of the cosmos DB, must be globaly unique')
param cosmosDBAccountName string

var cosmosDBDatabaseName = 'ProductCatalog'
var cosmosDBDatabaseThroughput = (environmentType == 'prod') ? 1000 : 400
var cosmosDBContainerName = 'Products'
var cosmosDBContainerPartitionKey = '/productid'
