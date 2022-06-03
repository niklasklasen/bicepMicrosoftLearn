param cosmosDBAccountName string = 'toyrnd-${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-02-15-preview' = {
  name: cosmosDBAccountName
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
      }
    ]
  }
}
