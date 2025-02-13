$ResourceGroupName = Read-Host "Enter Your Resource Group Name"
$ResourcePrefix = Read-Host "Enter a short prefix for your Azure Resources (lowercase with no spaces)"
$DatabasePassword = Read-Host "Enter a password for your database"

az deployment group create `
    --resource-group $ResourceGroupName `
    --template-file scenario.bicep `
    --parameters resourcePrefix=$ResourcePrefix administratorLoginPassword=$DatabasePassword

sqlcmd `
    -S $ResourcePrefix-non-iac-sqlserver.database.windows.net `
    -d $ResourcePrefix-non-iac-db `
    -U dbadmin `
    -P $DatabasePassword `
    -i db_setup.sql
