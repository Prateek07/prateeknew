Import-Module Az.Accounts -ErrorAction Stop

Disable-AzContextAutosave -Scope Process | Out-Null

$tenantId = $env:AZURE_TENANT_ID
$subscriptionId = $env:AZURE_SUBSCRIPTION_ID

# Use the exact app setting name where you stored the user-assigned MI client ID
$managedIdentityClientId = $env:MANAGED_IDENTITY_CLIENT_ID
# or, if your app setting is named AZURE_CLIENT_ID:
# $managedIdentityClientId = $env:AZURE_CLIENT_ID

if ([string]::IsNullOrWhiteSpace($managedIdentityClientId)) {
    throw "Managed Identity Client ID app setting is empty or missing."
}

Connect-AzAccount `
    -Identity `
    -AccountId $managedIdentityClientId `
    -Tenant $tenantId `
    -Subscription $subscriptionId `
    -ErrorAction Stop | Out-Null

Set-AzContext `
    -SubscriptionId $subscriptionId `
    -TenantId $tenantId `
    -ErrorAction Stop | Out-Null