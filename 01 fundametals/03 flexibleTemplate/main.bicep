@description('The Azure regions in which the resources should be deployed')
param locations array = [
  'eastus'
  'eastus2'
  'eastasia'
]

@secure()
@description('Admin login username for SQL server')
param sqlServerAdministratorLogin string

@secure()
@description('Admin password for SQL server')
param sqlServerAdministratorPassword string

@description('IP address range for all virtual networks to use.')
param virtualNetworkAddressPrefix string = '10.10.0.0/16'

@description('The name and IP address fro each subnet in the virtual networks')
param subnets array = [
  {
    name: 'frontend'
    ipAddressRange : '10.10.5.9/24'
  }
  {
    name: 'backend'
    ipAddressRange: '10.10.10.0/24'
  }
]

var subnetProperties = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

module databases 'modules/database.bicep' = [for location in locations: {
  name: 'database-${location}'
  params: {
    location: location
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorPassword: sqlServerAdministratorPassword
  }
}]

resource virtualNetworks 'Microsoft.Network/virtualnetworks@2015-05-01-preview' = [for location in locations: {
  name: 'tedybear-${location}'
  location: location
  properties: {
    addressSpace:{
      addressPrefixes:[
        virtualNetworkAddressPrefix
      ]
    }
    subnets: subnetProperties
  }
}]

output serverInfo array = [for i in range(0,length(locations)): {
  name: databases[i].outputs.serverName
  location: databases[i].outputs.serverFullyQualifiedDomainName
}]
