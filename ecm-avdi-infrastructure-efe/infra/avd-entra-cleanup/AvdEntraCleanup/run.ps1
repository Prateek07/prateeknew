param($ServiceBusMessage, $TriggerMetadata)

$ErrorActionPreference = "Stop"

function Get-StringValue {
    param([object]$Value)

    if ($null -eq $Value) {
        return $null
    }

    if ($Value -is [string]) {
        return $Value
    }

    return ($Value | ConvertTo-Json -Depth 100 -Compress)
}

function ConvertTo-EventList {
    param([object]$Message)

    $body = Get-StringValue -Value $Message

    if ([string]::IsNullOrWhiteSpace($body)) {
        throw "Service Bus message body is empty."
    }

    Write-Host "Received Service Bus message body: $body"

    $payload = $body | ConvertFrom-Json -Depth 100

    if ($payload -is [System.Array]) {
        return @($payload)
    }

    return @($payload)
}

function Get-VmNameFromResourceId {
    param([string]$ResourceId)

    if ([string]::IsNullOrWhiteSpace($ResourceId)) {
        return $null
    }

    $parts = $ResourceId.Split('/', [System.StringSplitOptions]::RemoveEmptyEntries)

    for ($i = 0; $i -lt $parts.Length; $i++) {
        if ($parts[$i].ToLowerInvariant() -eq "virtualmachines" -and ($i + 1) -lt $parts.Length) {
            return $parts[$i + 1]
        }
    }

    return $null
}

function Test-AllowedVmName {
    param([string]$VmName)

    $prefixSetting = $env:ALLOWED_VM_PREFIXES

    if ([string]::IsNullOrWhiteSpace($prefixSetting)) {
        Write-Warning "ALLOWED_VM_PREFIXES is empty. No VM names will be processed."
        return $false
    }

    $prefixes = $prefixSetting.Split(',', [System.StringSplitOptions]::RemoveEmptyEntries) |
        ForEach-Object { $_.Trim().ToLowerInvariant() } |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    foreach ($prefix in $prefixes) {
        if ($VmName.ToLowerInvariant().StartsWith($prefix)) {
            return $true
        }
    }

    return $false
}

function Get-ManagedIdentityGraphToken {
    $graphResource = if ([string]::IsNullOrWhiteSpace($env:GRAPH_RESOURCE)) {
        "https://graph.microsoft.com"
    }
    else {
        $env:GRAPH_RESOURCE
    }

    if ([string]::IsNullOrWhiteSpace($env:IDENTITY_ENDPOINT) -or [string]::IsNullOrWhiteSpace($env:IDENTITY_HEADER)) {
        throw "Managed identity endpoint variables are missing. Confirm managed identity is enabled on the Function App."
    }

    $encodedResource = [System.Uri]::EscapeDataString($graphResource)
    $tokenUri = "$($env:IDENTITY_ENDPOINT)?resource=$encodedResource&api-version=2019-08-01"

    if (-not [string]::IsNullOrWhiteSpace($env:MANAGED_IDENTITY_CLIENT_ID)) {
        $encodedClientId = [System.Uri]::EscapeDataString($env:MANAGED_IDENTITY_CLIENT_ID)
        $tokenUri = "$tokenUri&client_id=$encodedClientId"
    }

    $headers = @{
        "X-IDENTITY-HEADER" = $env:IDENTITY_HEADER
    }

    $tokenResponse = Invoke-RestMethod -Method GET -Uri $tokenUri -Headers $headers -TimeoutSec 30
    return $tokenResponse.access_token
}

function Find-EntraDeviceByDisplayName {
    param(
        [string]$VmName,
        [string]$AccessToken
    )

    $graphRoot = if ([string]::IsNullOrWhiteSpace($env:GRAPH_ROOT)) {
        "https://graph.microsoft.com/v1.0"
    }
    else {
        $env:GRAPH_ROOT.TrimEnd('/')
    }

    $escapedVmName = $VmName.Replace("'", "''")
    $filter = "displayName eq '$escapedVmName'"
    $query = '$filter=' + [System.Uri]::EscapeDataString($filter) + '&$select=id,deviceId,displayName,trustType,operatingSystem'
    $uri = "$graphRoot/devices?$query"

    $headers = @{
        Authorization      = "Bearer $AccessToken"
        ConsistencyLevel   = "eventual"
    }

    $response = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers -TimeoutSec 30
    return @($response.value)
}

function Remove-EntraDevice {
    param(
        [string]$DeviceObjectId,
        [string]$AccessToken
    )

    $graphRoot = if ([string]::IsNullOrWhiteSpace($env:GRAPH_ROOT)) {
        "https://graph.microsoft.com/v1.0"
    }
    else {
        $env:GRAPH_ROOT.TrimEnd('/')
    }

    $uri = "$graphRoot/devices/$DeviceObjectId"

    $headers = @{
        Authorization = "Bearer $AccessToken"
    }

    try {
        Invoke-RestMethod -Method DELETE -Uri $uri -Headers $headers -TimeoutSec 30 | Out-Null
    }
    catch {
        $statusCode = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $statusCode = [int]$_.Exception.Response.StatusCode
        }

        if ($statusCode -eq 404) {
            Write-Warning "Device object $DeviceObjectId was already deleted."
            return
        }

        throw
    }
}

$dryRun = $true
if (-not [string]::IsNullOrWhiteSpace($env:DRY_RUN)) {
    $dryRun = $env:DRY_RUN.ToLowerInvariant() -ne "false"
}

$events = ConvertTo-EventList -Message $ServiceBusMessage

foreach ($event in $events) {
    $eventType = $event.eventType
    $operationName = $event.data.operationName
    $status = $event.data.status
    $resourceId = $event.data.resourceUri

    if ([string]::IsNullOrWhiteSpace($resourceId)) {
        $resourceId = $event.subject
    }

    if ($eventType -ne "Microsoft.Resources.ResourceDeleteSuccess") {
        Write-Host "Skipping eventType '$eventType'."
        continue
    }

    if ($operationName.ToLowerInvariant() -ne "microsoft.compute/virtualmachines/delete") {
        Write-Host "Skipping operationName '$operationName'."
        continue
    }

    if (-not [string]::IsNullOrWhiteSpace($status) -and $status.ToLowerInvariant() -ne "succeeded") {
        Write-Host "Skipping status '$status'."
        continue
    }

    $vmName = Get-VmNameFromResourceId -ResourceId $resourceId

    if ([string]::IsNullOrWhiteSpace($vmName)) {
        throw "Could not extract VM name from resource id '$resourceId'."
    }

    Write-Host "Processing deleted VM '$vmName'."

    if (-not (Test-AllowedVmName -VmName $vmName)) {
        Write-Host "Skipping VM '$vmName' because it does not match ALLOWED_VM_PREFIXES '$($env:ALLOWED_VM_PREFIXES)'."
        continue
    }

    $accessToken = Get-ManagedIdentityGraphToken
    $devices = Find-EntraDeviceByDisplayName -VmName $vmName -AccessToken $accessToken

    if ($devices.Count -eq 0) {
        Write-Host "No Entra device found for VM '$vmName'. Treating as already cleaned up."
        continue
    }

    if ($devices.Count -gt 1) {
        $deviceList = ($devices | ForEach-Object { "$($_.displayName) [$($_.id)]" }) -join ", "
        throw "Multiple Entra devices found for VM '$vmName': $deviceList. Manual review required."
    }

    $device = $devices[0]
    Write-Host "Matched Entra device displayName='$($device.displayName)', objectId='$($device.id)', deviceId='$($device.deviceId)', trustType='$($device.trustType)'."

    if ($dryRun) {
        Write-Host "DRY_RUN=true. Not deleting Entra device for VM '$vmName'."
        continue
    }

    Remove-EntraDevice -DeviceObjectId $device.id -AccessToken $accessToken
    Write-Host "Deleted Entra device for VM '$vmName'. ObjectId='$($device.id)'."
}
