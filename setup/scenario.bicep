@description('Prefix for Resources (should be lowercase with no spaces)')
param resourcePrefix string

@description('The administrator password of the SQL logical server.')
@secure()
param administratorLoginPassword string 

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The administrator username of the SQL logical server.')
param administratorLogin string = 'dbadmin'

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: '${resourcePrefix}-non-iac-sqlserver'
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: '${resourcePrefix}-non-iac-db'
  location: location
  sku: {
    name: 'Basic'
  }
}

resource sqlServerFirewallRule 'Microsoft.Sql/servers/firewallRules@2024-05-01-preview' = {
  parent: sqlServer
  name: '${resourcePrefix}-FirewallRule1'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: '${resourcePrefix}-non-iac-asp'
  location: location
  kind: 'app,linux,container'
  properties: {
    reserved: true
  }	
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
}

resource website 'Microsoft.Web/sites@2024-04-01' = {
  name: '${resourcePrefix}-non-iac-app'
  location: location
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|corndeldevopscourse/mod12app:latest'
      appSettings: [
        {
          name: 'CONNECTION_STRING'
          value: 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${sqlDB.name};Persist Security Info=False;User ID=${administratorLogin};Password=${administratorLoginPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
        }
      ]
    }
  }
}
