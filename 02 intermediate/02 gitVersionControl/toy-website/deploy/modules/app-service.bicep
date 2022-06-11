@description('The Azure region wehere the resources should be depolyed.')
param location string 

@description('The the type of environment, must be nonprod or prod.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@description('The name of the App Service app, must be globaly unique')
param appServiceAppName string

var appServicePlanName = 'toy-website-plan'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'
var appServicePlanTierName = (environmentType == 'prod') ? 'PremiumV3' : 'Free'

