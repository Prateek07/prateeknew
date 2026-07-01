param(
    [Parameter(Mandatory = $true)]
    $Message,

    $TriggerMetadata
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'
$ProgressPreference = 'SilentlyContinue'

function Write-LogInfo {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Message
    )

    Write-Information $Message -InformationAction Continue
}

function Write-LogWarning {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Message
    )

    if ($null -eq $script:NotificationWarnings) {
        $script:NotificationWarnings = @()
    }

    $script:NotificationWarnings += $Message

    Write-Warning $Message
}

function Get-AppSetting {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [string] $DefaultValue = $null,

        [switch] $Required
    )

    $value = [Environment]::GetEnvironmentVariable($Name)

    if ([string]::IsNullOrWhiteSpace($value)) {
        if ($Required) {
            throw "Missing required app setting: $Name"
        }

        return $DefaultValue
    }

    return $value.Trim()
}

function Get-BoolAppSetting {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [bool] $DefaultValue
    )

    $raw = Get-AppSetting -Name $Name -DefaultValue $null

    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $DefaultValue
    }

    switch -Regex ($raw.Trim().ToLowerInvariant()) {
        '^(true|1|yes|y)$' {
            return $true
        }
        '^(false|0|no|n)$' {
            return $false
        }
        default {
            throw "Invalid boolean app setting '$Name'. Value='$raw'. Use true or false."
        }
    }
}

function Get-IntAppSetting {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [int] $DefaultValue
    )

    $raw = Get-AppSetting -Name $Name -DefaultValue $null

    if ([string]::IsNullOrWhiteSpace($raw)) {
        return $DefaultValue
    }

    [int] $parsed = 0

    if (-not [int]::TryParse($raw, [ref] $parsed)) {
        throw "Invalid integer app setting '$Name'. Value='$raw'."
    }

    return $parsed
}

function Get-CsvAppSetting {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name
    )

    $raw = Get-AppSetting -Name $Name -DefaultValue $null

    if ([string]::IsNullOrWhiteSpace($raw)) {
        return @()
    }

    return @(
        $raw -split ',' |
            ForEach-Object { $_.Trim() } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    )
}

function ConvertTo-QueryString {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable] $Query
    )

    $pairs = @()

    foreach ($key in $Query.Keys) {
        $value = $Query[$key]

        if ($null -eq $value) {
            continue
        }

        if ([string]::IsNullOrWhiteSpace([string] $value)) {
            continue
        }

        $encodedKey = [Uri]::EscapeDataString([string] $key)
        $encodedValue = [Uri]::EscapeDataString([string] $value)

        $pairs += "$encodedKey=$encodedValue"
    }

    return ($pairs -join '&')
}

function Escape-ODataString {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Value
    )

    return $Value.Replace("'", "''")
}

function Get-PropertyValue {
    param(
        $Object,

        [Parameter(Mandatory = $true)]
        [string[]] $Names
    )

    if ($null -eq $Object) {
        return $null
    }

    if ($Object -is [System.Collections.IDictionary]) {
        foreach ($name in $Names) {
            if ($Object.Contains($name)) {
                return $Object[$name]
            }

            foreach ($key in $Object.Keys) {
                if (([string] $key).Equals($name, [System.StringComparison]::OrdinalIgnoreCase)) {
                    return $Object[$key]
                }
            }
        }
    }

    foreach ($name in $Names) {
        $property = $Object.PSObject.Properties[$name]

        if ($null -ne $property) {
            return $property.Value
        }
    }

    foreach ($name in $Names) {
        foreach ($property in $Object.PSObject.Properties) {
            if ($property.Name.Equals($name, [System.StringComparison]::OrdinalIgnoreCase)) {
                return $property.Value
            }
        }
    }

    return $null
}

function ConvertTo-MessageText {
    param(
        [Parameter(Mandatory = $true)]
        $InputObject
    )

    if ($InputObject -is [byte[]]) {
        return [System.Text.Encoding]::UTF8.GetString($InputObject)
    }

    if ($InputObject -is [string]) {
        return $InputObject
    }

    return ($InputObject | ConvertTo-Json -Depth 100 -Compress)
}

function ConvertFrom-MessageText {
    param(
        [Parameter(Mandatory = $true)]
        [string] $MessageText
    )

    if ([string]::IsNullOrWhiteSpace($MessageText)) {
        throw "Service Bus message body is empty."
    }

    try {
        $json = $MessageText | ConvertFrom-Json -Depth 100
    }
    catch {
        throw "Failed to parse Service Bus message body as JSON. Error='$($_.Exception.Message)'"
    }

    if ($json -is [array]) {
        return @($json)
    }

    return @($json)
}

function Parse-AzureVmResourceId {
    param(
        [Parameter(Mandatory = $true)]
        [string] $ResourceId
    )

    $cleanResourceId = $ResourceId.Trim().TrimEnd('/')
    $pattern = '(?i)^/subscriptions/([^/]+)/resourceGroups/([^/]+)/providers/Microsoft\.Compute/virtualMachines/([^/]+)$'

    if ($cleanResourceId -notmatch $pattern) {
        return $null
    }

    return [pscustomobject]@{
        SubscriptionId = $Matches[1]
        ResourceGroup = $Matches[2]
        VmName        = [Uri]::UnescapeDataString($Matches[3])
        ResourceId    = $cleanResourceId
    }
}

function Test-StringInListIgnoreCase {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Value,

        [AllowEmptyCollection()]
        [string[]] $List = @()
    )

    foreach ($item in $List) {
        if ($Value.Equals($item, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }

    return $false
}

function Test-StartsWithAnyIgnoreCase {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Value,

        [AllowEmptyCollection()]
        [string[]] $Prefixes = @()
    )

    foreach ($prefix in $Prefixes) {
        if ($Value.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }

    return $false
}

function Get-NameCandidates {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Name
    )

    $ordered = [ordered]@{}

    foreach ($candidate in @($Name, $Name.ToUpperInvariant(), $Name.ToLowerInvariant())) {
        if ([string]::IsNullOrWhiteSpace($candidate)) {
            continue
        }

        $key = $candidate.ToLowerInvariant()

        if (-not $ordered.Contains($key)) {
            $ordered[$key] = $candidate
        }
    }

    return @($ordered.Values)
}

function Add-UniqueObjectById {
    param(
        [AllowEmptyCollection()]
        [object[]] $Items = @(),

        [Parameter(Mandatory = $true)]
        [string] $IdProperty
    )

    $map = @{}

    foreach ($item in @($Items)) {
        if ($null -eq $item) {
            continue
        }

        $id = [string] $item.$IdProperty

        if ([string]::IsNullOrWhiteSpace($id)) {
            continue
        }

        $map[$id] = $item
    }

    return @($map.Values)
}

function Initialize-Settings {
    $script:TargetSubscriptionId = (Get-AppSetting -Name 'AZURE_SUBSCRIPTION_ID' -Required).ToLowerInvariant()
    $script:ManagedIdentityClientId = Get-AppSetting -Name 'MANAGED_IDENTITY_CLIENT_ID' -DefaultValue $null

    $script:DryRun = Get-BoolAppSetting -Name 'DRY_RUN' -DefaultValue $true
    $script:DeleteEntraDevice = Get-BoolAppSetting -Name 'DELETE_ENTRA_DEVICE' -DefaultValue $true
    $script:DeleteIntuneDevice = Get-BoolAppSetting -Name 'DELETE_INTUNE_DEVICE' -DefaultValue $true
    $script:SkipIntuneWhenNotApplicable = Get-BoolAppSetting -Name 'SKIP_INTUNE_WHEN_NOT_APPLICABLE' -DefaultValue $true

    # Teams group chat notification settings. TEAMS_WEBHOOK_URL is a Teams Workflows webhook URL.
    $script:TeamsNotificationEnabled = Get-BoolAppSetting -Name 'TEAMS_NOTIFICATION_ENABLED' -DefaultValue $false
    $script:TeamsWebhookUrl = Get-AppSetting -Name 'TEAMS_WEBHOOK_URL' -DefaultValue $null

    $script:MaxMatchesToDelete = Get-IntAppSetting -Name 'MAX_MATCHES_TO_DELETE' -DefaultValue 1

    if ($script:MaxMatchesToDelete -lt 1) {
        throw "MAX_MATCHES_TO_DELETE must be 1 or greater."
    }

    $script:AllowedResourceGroups = Get-CsvAppSetting -Name 'ALLOWED_RESOURCE_GROUPS'
    $script:AllowedVmNames = Get-CsvAppSetting -Name 'ALLOWED_VM_NAMES'
    $script:AvdVmNamePrefixes = Get-CsvAppSetting -Name 'AVD_VM_NAME_PREFIXES'
    $script:AvdVmNameRegex = Get-AppSetting -Name 'AVD_VM_NAME_REGEX' -DefaultValue $null
    $script:AllowAllVmNamesInSubscription = Get-BoolAppSetting -Name 'ALLOW_ALL_VM_NAMES_IN_SUBSCRIPTION' -DefaultValue $false

    $script:GraphBaseUri = (Get-AppSetting -Name 'GRAPH_BASE_URI' -DefaultValue 'https://graph.microsoft.com/v1.0').TrimEnd('/')
    $script:GraphTimeoutSeconds = Get-IntAppSetting -Name 'GRAPH_REQUEST_TIMEOUT_SECONDS' -DefaultValue 60
    $script:GraphRetryMaxAttempts = Get-IntAppSetting -Name 'GRAPH_RETRY_MAX_ATTEMPTS' -DefaultValue 3

    if ($script:GraphRetryMaxAttempts -lt 1) {
        $script:GraphRetryMaxAttempts = 1
    }

    $script:IntuneApiNotApplicable = $false

    $hasResourceGroupFilter = @($script:AllowedResourceGroups).Count -gt 0
    $hasVmNameFilter = @($script:AllowedVmNames).Count -gt 0
    $hasPrefixFilter = @($script:AvdVmNamePrefixes).Count -gt 0
    $hasRegexFilter = -not [string]::IsNullOrWhiteSpace($script:AvdVmNameRegex)

    if (
        -not $script:AllowAllVmNamesInSubscription -and
        -not $hasResourceGroupFilter -and
        -not $hasVmNameFilter -and
        -not $hasPrefixFilter -and
        -not $hasRegexFilter
    ) {
        throw "Safety guard missing. Configure AVD_VM_NAME_PREFIXES, AVD_VM_NAME_REGEX, ALLOWED_VM_NAMES, or ALLOWED_RESOURCE_GROUPS. To allow every VM name in this subscription, set ALLOW_ALL_VM_NAMES_IN_SUBSCRIPTION=true."
    }

    Write-LogInfo "Using app setting AZURE_SUBSCRIPTION_ID."
    Write-LogInfo "Safety settings: DRY_RUN='$script:DryRun', DELETE_ENTRA_DEVICE='$script:DeleteEntraDevice', DELETE_INTUNE_DEVICE='$script:DeleteIntuneDevice', SKIP_INTUNE_WHEN_NOT_APPLICABLE='$script:SkipIntuneWhenNotApplicable', MAX_MATCHES_TO_DELETE='$script:MaxMatchesToDelete'"
    Write-LogInfo "Teams notification enabled='$script:TeamsNotificationEnabled'"

    if ($script:TeamsNotificationEnabled -and [string]::IsNullOrWhiteSpace($script:TeamsWebhookUrl)) {
        Write-LogWarning "TEAMS_NOTIFICATION_ENABLED is true but TEAMS_WEBHOOK_URL is not configured. Cleanup will continue, but Teams notifications will be skipped."
    }

    if (-not [string]::IsNullOrWhiteSpace($script:ManagedIdentityClientId)) {
        Write-LogInfo "Using user-assigned managed identity client id."
    }
    else {
        Write-LogInfo "MANAGED_IDENTITY_CLIENT_ID not configured. Using system-assigned managed identity."
    }
}

function Get-GraphAccessToken {
    $nowUtc = (Get-Date).ToUniversalTime()

    if (
        -not [string]::IsNullOrWhiteSpace($script:GraphAccessToken) -and
        $null -ne $script:GraphAccessTokenExpiresOnUtc -and
        $script:GraphAccessTokenExpiresOnUtc -gt $nowUtc.AddMinutes(5)
    ) {
        return $script:GraphAccessToken
    }

    $resource = 'https://graph.microsoft.com/'

    if (-not [string]::IsNullOrWhiteSpace($env:IDENTITY_ENDPOINT) -and -not [string]::IsNullOrWhiteSpace($env:IDENTITY_HEADER)) {
        $query = @{
            'api-version' = '2019-08-01'
            'resource'    = $resource
        }

        if (-not [string]::IsNullOrWhiteSpace($script:ManagedIdentityClientId)) {
            $query['client_id'] = $script:ManagedIdentityClientId
        }

        $uri = "$($env:IDENTITY_ENDPOINT)?$(ConvertTo-QueryString -Query $query)"
        $headers = @{
            'X-IDENTITY-HEADER' = $env:IDENTITY_HEADER
        }

        $tokenResponse = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers -TimeoutSec $script:GraphTimeoutSeconds
    }
    elseif (-not [string]::IsNullOrWhiteSpace($env:MSI_ENDPOINT) -and -not [string]::IsNullOrWhiteSpace($env:MSI_SECRET)) {
        $query = @{
            'resource' = $resource
        }

        if (-not [string]::IsNullOrWhiteSpace($script:ManagedIdentityClientId)) {
            $query['clientid'] = $script:ManagedIdentityClientId
        }

        $uri = "$($env:MSI_ENDPOINT)?$(ConvertTo-QueryString -Query $query)"
        $headers = @{
            'Secret' = $env:MSI_SECRET
        }

        $tokenResponse = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers -TimeoutSec $script:GraphTimeoutSeconds
    }
    else {
        throw "Managed identity endpoint environment variables were not found. Confirm managed identity is enabled on the Function App."
    }

    if ([string]::IsNullOrWhiteSpace($tokenResponse.access_token)) {
        throw "Managed identity token response did not contain access_token."
    }

    $script:GraphAccessToken = $tokenResponse.access_token
    $expiresOnUtc = $nowUtc.AddMinutes(45)

    if (-not [string]::IsNullOrWhiteSpace([string] $tokenResponse.expires_on)) {
        [long] $epochSeconds = 0

        if ([long]::TryParse([string] $tokenResponse.expires_on, [ref] $epochSeconds)) {
            $expiresOnUtc = [DateTimeOffset]::FromUnixTimeSeconds($epochSeconds).UtcDateTime
        }
    }
    elseif (-not [string]::IsNullOrWhiteSpace([string] $tokenResponse.expires_in)) {
        [int] $expiresInSeconds = 2700

        if ([int]::TryParse([string] $tokenResponse.expires_in, [ref] $expiresInSeconds)) {
            $expiresOnUtc = $nowUtc.AddSeconds($expiresInSeconds)
        }
    }

    $script:GraphAccessTokenExpiresOnUtc = $expiresOnUtc

    return $script:GraphAccessToken
}

function Get-GraphErrorDetails {
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord] $ErrorRecord,

        [Parameter(Mandatory = $true)]
        [string] $Method,

        [Parameter(Mandatory = $true)]
        [string] $Uri
    )

    $statusCode = $null
    $responseBody = $ErrorRecord.ErrorDetails.Message
    $graphCode = $null
    $graphMessage = $null

    if ($null -ne $ErrorRecord.Exception.Response) {
        try {
            $statusCode = [int] $ErrorRecord.Exception.Response.StatusCode.value__
        }
        catch {
            try {
                $statusCode = [int] $ErrorRecord.Exception.Response.StatusCode
            }
            catch {
                $statusCode = $null
            }
        }
    }

    if ([string]::IsNullOrWhiteSpace($responseBody)) {
        $responseBody = ''
    }

    try {
        $parsedError = $responseBody | ConvertFrom-Json -Depth 20

        if ($null -ne $parsedError.error) {
            $graphCode = [string] $parsedError.error.code
            $graphMessage = [string] $parsedError.error.message
        }
    }
    catch {
        $graphCode = $null
        $graphMessage = $null
    }

    return [pscustomobject]@{
        Method        = $Method
        Uri           = $Uri
        StatusCode    = $statusCode
        GraphCode     = $graphCode
        GraphMessage  = $graphMessage
        ExceptionText = $ErrorRecord.Exception.Message
        Body          = $responseBody
    }
}

function Format-GraphErrorMessage {
    param(
        [Parameter(Mandatory = $true)]
        $Details
    )

    return "Graph request failed. Method='$($Details.Method)', Uri='$($Details.Uri)', StatusCode='$($Details.StatusCode)', GraphCode='$($Details.GraphCode)', GraphMessage='$($Details.GraphMessage)', Error='$($Details.ExceptionText)', Body='$($Details.Body)'"
}

function Test-IsTransientStatusCode {
    param(
        $StatusCode
    )

    if ($null -eq $StatusCode) {
        return $false
    }

    [int] $code = [int] $StatusCode

    if ($code -eq 408 -or $code -eq 429 -or $code -ge 500) {
        return $true
    }

    return $false
}

function Invoke-GraphRequest {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('GET', 'DELETE')]
        [string] $Method,

        [Parameter(Mandatory = $true)]
        [string] $PathOrUri,

        [hashtable] $Query = @{},

        [hashtable] $ExtraHeaders = @{},

        [switch] $IgnoreNotFound
    )

    $accessToken = Get-GraphAccessToken

    if ($PathOrUri -match '^https?://') {
        $uri = $PathOrUri
    }
    else {
        $path = $PathOrUri

        if (-not $path.StartsWith('/')) {
            $path = "/$path"
        }

        $queryString = ConvertTo-QueryString -Query $Query
        $uri = "$script:GraphBaseUri$path"

        if (-not [string]::IsNullOrWhiteSpace($queryString)) {
            $uri = "$uri`?$queryString"
        }
    }

    $headers = @{
        'Authorization' = "Bearer $accessToken"
        'Accept'        = 'application/json'
    }

    foreach ($key in $ExtraHeaders.Keys) {
        $headers[$key] = $ExtraHeaders[$key]
    }

    $maxAttempts = [Math]::Max(1, [int] $script:GraphRetryMaxAttempts)

    for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        try {
            if ($Method -eq 'GET') {
                return Invoke-RestMethod -Method Get -Uri $uri -Headers $headers -TimeoutSec $script:GraphTimeoutSeconds
            }

            if ($Method -eq 'DELETE') {
                Invoke-RestMethod -Method Delete -Uri $uri -Headers $headers -TimeoutSec $script:GraphTimeoutSeconds | Out-Null
                return $null
            }
        }
        catch {
            $details = Get-GraphErrorDetails -ErrorRecord $_ -Method $Method -Uri $uri

            if ($IgnoreNotFound -and $details.StatusCode -eq 404) {
                Write-LogWarning "Graph returned 404 for DELETE. Treating as already removed. Uri='$uri'"
                return $null
            }

            if ((Test-IsTransientStatusCode -StatusCode $details.StatusCode) -and $attempt -lt $maxAttempts) {
                $delaySeconds = [Math]::Min(30, [Math]::Pow(2, ($attempt - 1)))
                Write-LogWarning "Transient Graph error. Attempt='$attempt', MaxAttempts='$maxAttempts', DelaySeconds='$delaySeconds', StatusCode='$($details.StatusCode)', GraphMessage='$($details.GraphMessage)'"
                Start-Sleep -Seconds $delaySeconds
                continue
            }

            throw (Format-GraphErrorMessage -Details $details)
        }
    }
}

function Invoke-GraphGetPaged {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [hashtable] $Query
    )

    $items = @()
    $response = Invoke-GraphRequest -Method GET -PathOrUri $Path -Query $Query

    while ($null -ne $response) {
        $propertyNames = @($response.PSObject.Properties.Name)

        if ($propertyNames -contains 'value') {
            $items += @($response.value)
        }
        else {
            $items += $response
        }

        $nextLink = Get-PropertyValue -Object $response -Names @('@odata.nextLink')

        if ([string]::IsNullOrWhiteSpace($nextLink)) {
            break
        }

        $response = Invoke-GraphRequest -Method GET -PathOrUri $nextLink
    }

    return @($items)
}

function Test-IsIntuneNotApplicableError {
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord] $ErrorRecord
    )

    $text = @(
        [string] $ErrorRecord.Exception.Message,
        [string] $ErrorRecord.ErrorDetails.Message,
        [string] $ErrorRecord.ToString()
    ) -join ' '

    if ($text -match 'Request not applicable to target tenant') {
        return $true
    }

    return $false
}

function Set-IntuneNotApplicableAndLog {
    param(
        [Parameter(Mandatory = $true)]
        [string] $VmName
    )

    $script:IntuneApiNotApplicable = $true

    Write-LogWarning "INTUNE NOT APPLICABLE TO TARGET TENANT: Microsoft Graph returned 'Request not applicable to target tenant' while processing VmName='$VmName'. Intune lookup/delete will be skipped and the Service Bus message will be completed. If this tenant should use Intune, verify the Function App managed identity is in the same tenant that has Intune enabled and has the required Microsoft Graph application permissions. If this tenant does not use Intune, set DELETE_INTUNE_DEVICE=false."
}

function Test-VmAllowedByScope {
    param(
        [Parameter(Mandatory = $true)]
        [string] $VmName,

        [Parameter(Mandatory = $true)]
        [string] $ResourceGroup
    )

    if (@($script:AllowedResourceGroups).Count -gt 0) {
        if (-not (Test-StringInListIgnoreCase -Value $ResourceGroup -List $script:AllowedResourceGroups)) {
            Write-LogWarning "Skipped VM because resource group is not allowed. ResourceGroup='$ResourceGroup', VmName='$VmName'"
            return $false
        }
    }

    if ($script:AllowAllVmNamesInSubscription) {
        return $true
    }

    if (@($script:AllowedVmNames).Count -gt 0) {
        if (Test-StringInListIgnoreCase -Value $VmName -List $script:AllowedVmNames) {
            return $true
        }
    }

    if (@($script:AvdVmNamePrefixes).Count -gt 0) {
        if (Test-StartsWithAnyIgnoreCase -Value $VmName -Prefixes $script:AvdVmNamePrefixes) {
            return $true
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($script:AvdVmNameRegex)) {
        if ($VmName -match $script:AvdVmNameRegex) {
            return $true
        }
    }

    if (@($script:AllowedResourceGroups).Count -gt 0) {
        return $true
    }

    Write-LogWarning "Skipped VM because it does not match configured AVD scope filters. VmName='$VmName'"
    return $false
}

function Get-EventId {
    param($Event)

    $eventId = Get-PropertyValue -Object $Event -Names @('id', 'eventId')

    if ([string]::IsNullOrWhiteSpace([string] $eventId)) {
        return 'unknown'
    }

    return [string] $eventId
}

function Get-EventType {
    param($Event)

    $eventType = Get-PropertyValue -Object $Event -Names @('eventType', 'type')

    if ([string]::IsNullOrWhiteSpace([string] $eventType)) {
        return 'unknown'
    }

    return [string] $eventType
}

function Get-EventSubject {
    param($Event)

    $candidates = @(
        (Get-PropertyValue -Object $Event -Names @('subject')),
        (Get-PropertyValue -Object $Event.data -Names @('resourceUri', 'resourceId', 'id')),
        (Get-PropertyValue -Object $Event.data.resourceInfo -Names @('resourceUri', 'resourceId', 'id'))
    )

    foreach ($candidate in $candidates) {
        if (-not [string]::IsNullOrWhiteSpace([string] $candidate)) {
            return [string] $candidate
        }
    }

    return $null
}

function Test-IsDeletedResourceEvent {
    param(
        [Parameter(Mandatory = $true)]
        [string] $EventType
    )

    $allowedTypes = @(
        'Microsoft.ResourceNotifications.Resources.Deleted',
        'Microsoft.Resources.ResourceDeleteSuccess'
    )

    foreach ($allowedType in $allowedTypes) {
        if ($EventType.Equals($allowedType, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
    }

    return $false
}

function Find-EntraDevicesByVmName {
    param(
        [Parameter(Mandatory = $true)]
        [string] $VmName
    )

    $rawMatches = @()

    foreach ($candidateName in (Get-NameCandidates -Name $VmName)) {
        $escapedName = Escape-ODataString -Value $candidateName
        $filter = "displayName eq '$escapedName'"

        Write-LogInfo "Searching Entra devices by displayName='$candidateName'."

        $query = @{
            '$select' = 'id,deviceId,displayName,accountEnabled,operatingSystem,trustType'
            '$filter' = $filter
            '$top'    = '25'
        }

        $rawMatches += Invoke-GraphGetPaged -Path '/devices' -Query $query
    }

    $matches = @(
        $rawMatches |
            Where-Object {
                -not [string]::IsNullOrWhiteSpace([string] $_.displayName) -and
                ([string] $_.displayName).Equals($VmName, [System.StringComparison]::OrdinalIgnoreCase)
            }
    )

    return Add-UniqueObjectById -Items $matches -IdProperty 'id'
}

function Find-IntuneManagedDevicesByVmName {
    param(
        [Parameter(Mandatory = $true)]
        [string] $VmName,

        [AllowEmptyCollection()]
        [string[]] $AzureAdDeviceIds = @()
    )

    if ($script:IntuneApiNotApplicable) {
        Write-LogWarning "Skipping Intune lookup because Intune was already marked not applicable for this invocation. VmName='$VmName'"
        return @()
    }

    $rawMatches = @()

    try {
        foreach ($candidateName in (Get-NameCandidates -Name $VmName)) {
            $escapedName = Escape-ODataString -Value $candidateName
            $filter = "deviceName eq '$escapedName'"

            Write-LogInfo "Searching Intune managed devices by deviceName='$candidateName'."

            $query = @{
                '$select' = 'id,deviceName,azureADDeviceId,operatingSystem,complianceState,lastSyncDateTime,userPrincipalName'
                '$filter' = $filter
                '$top'    = '25'
            }

            $rawMatches += Invoke-GraphGetPaged -Path '/deviceManagement/managedDevices' -Query $query
        }

        foreach ($azureAdDeviceId in @($AzureAdDeviceIds)) {
            if ([string]::IsNullOrWhiteSpace($azureAdDeviceId)) {
                continue
            }

            $escapedAzureAdDeviceId = Escape-ODataString -Value $azureAdDeviceId
            $filter = "azureADDeviceId eq '$escapedAzureAdDeviceId'"

            Write-LogInfo "Searching Intune managed devices by azureADDeviceId='$azureAdDeviceId'."

            $query = @{
                '$select' = 'id,deviceName,azureADDeviceId,operatingSystem,complianceState,lastSyncDateTime,userPrincipalName'
                '$filter' = $filter
                '$top'    = '25'
            }

            $rawMatches += Invoke-GraphGetPaged -Path '/deviceManagement/managedDevices' -Query $query
        }
    }
    catch {
        if ((Test-IsIntuneNotApplicableError -ErrorRecord $_) -and $script:SkipIntuneWhenNotApplicable) {
            Set-IntuneNotApplicableAndLog -VmName $VmName
            return @()
        }

        throw
    }

    $matches = @(
        $rawMatches |
            Where-Object {
                $nameMatches = (
                    -not [string]::IsNullOrWhiteSpace([string] $_.deviceName) -and
                    ([string] $_.deviceName).Equals($VmName, [System.StringComparison]::OrdinalIgnoreCase)
                )

                $idMatches = $false

                foreach ($azureAdDeviceId in @($AzureAdDeviceIds)) {
                    if (
                        -not [string]::IsNullOrWhiteSpace($azureAdDeviceId) -and
                        -not [string]::IsNullOrWhiteSpace([string] $_.azureADDeviceId) -and
                        ([string] $_.azureADDeviceId).Equals($azureAdDeviceId, [System.StringComparison]::OrdinalIgnoreCase)
                    ) {
                        $idMatches = $true
                        break
                    }
                }

                $nameMatches -or $idMatches
            }
    )

    return Add-UniqueObjectById -Items $matches -IdProperty 'id'
}

function Remove-IntuneManagedDevices {
    param(
        [AllowEmptyCollection()]
        [object[]] $Devices = @(),

        [Parameter(Mandatory = $true)]
        [string] $VmName
    )

    if ($script:IntuneApiNotApplicable) {
        Write-LogWarning "INTUNE DELETE SKIPPED: Intune Graph API is not applicable to the target tenant. VmName='$VmName'"
        return
    }

    $deviceArray = @($Devices)

    if ($deviceArray.Count -eq 0) {
        Write-LogInfo "DEVICE NOT FOUND IN INTUNE: VmName='$VmName'"
        return
    }

    if ($deviceArray.Count -gt $script:MaxMatchesToDelete) {
        throw "Safety stop. Intune matches '$($deviceArray.Count)' exceed MAX_MATCHES_TO_DELETE '$script:MaxMatchesToDelete' for VmName='$VmName'."
    }

    foreach ($device in $deviceArray) {
        Write-LogInfo "Intune match: managedDeviceId='$($device.id)', deviceName='$($device.deviceName)', azureADDeviceId='$($device.azureADDeviceId)', complianceState='$($device.complianceState)'"

        if ($script:DryRun) {
            Write-LogInfo "DRY RUN: Would delete Intune managed device. managedDeviceId='$($device.id)', deviceName='$($device.deviceName)'"
            continue
        }

        $managedDeviceId = [Uri]::EscapeDataString([string] $device.id)

        try {
            Invoke-GraphRequest -Method DELETE -PathOrUri "/deviceManagement/managedDevices/$managedDeviceId" -IgnoreNotFound
        }
        catch {
            if ((Test-IsIntuneNotApplicableError -ErrorRecord $_) -and $script:SkipIntuneWhenNotApplicable) {
                Set-IntuneNotApplicableAndLog -VmName $VmName
                return
            }

            throw
        }

        Write-LogInfo "Deleted Intune managed device. managedDeviceId='$($device.id)', deviceName='$($device.deviceName)'"
    }
}

function Remove-EntraDevices {
    param(
        [AllowEmptyCollection()]
        [object[]] $Devices = @(),

        [Parameter(Mandatory = $true)]
        [string] $VmName
    )

    $deviceArray = @($Devices)

    if ($deviceArray.Count -eq 0) {
        Write-LogInfo "DEVICE NOT FOUND IN ENTRA: VmName='$VmName'"
        return
    }

    if ($deviceArray.Count -gt $script:MaxMatchesToDelete) {
        throw "Safety stop. Entra device matches '$($deviceArray.Count)' exceed MAX_MATCHES_TO_DELETE '$script:MaxMatchesToDelete' for VmName='$VmName'."
    }

    foreach ($device in $deviceArray) {
        Write-LogInfo "Entra match: objectId='$($device.id)', deviceId='$($device.deviceId)', displayName='$($device.displayName)', accountEnabled='$($device.accountEnabled)', trustType='$($device.trustType)'"

        if ($script:DryRun) {
            Write-LogInfo "DRY RUN: Would delete Entra device. objectId='$($device.id)', deviceId='$($device.deviceId)', displayName='$($device.displayName)'"
            continue
        }

        $deviceObjectId = [Uri]::EscapeDataString([string] $device.id)

        Invoke-GraphRequest -Method DELETE -PathOrUri "/devices/$deviceObjectId" -IgnoreNotFound

        Write-LogInfo "Deleted Entra device. objectId='$($device.id)', deviceId='$($device.deviceId)', displayName='$($device.displayName)'"
    }
}


function Send-TeamsNotification {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Title,

        [Parameter(Mandatory = $true)]
        [string] $Message
    )

    $enabled = $script:TeamsNotificationEnabled

    if ($null -eq $enabled) {
        $rawEnabled = [Environment]::GetEnvironmentVariable('TEAMS_NOTIFICATION_ENABLED')

        if ([string]::IsNullOrWhiteSpace($rawEnabled)) {
            $enabled = $false
        }
        else {
            switch -Regex ($rawEnabled.Trim().ToLowerInvariant()) {
                '^(true|1|yes|y)$' {
                    $enabled = $true
                }
                '^(false|0|no|n)$' {
                    $enabled = $false
                }
                default {
                    Write-LogWarning "Invalid boolean app setting 'TEAMS_NOTIFICATION_ENABLED'. Value='$rawEnabled'. Teams notification skipped."
                    return
                }
            }
        }
    }

    if (-not $enabled) {
        return
    }

    $webhookUrl = $script:TeamsWebhookUrl

    if ([string]::IsNullOrWhiteSpace($webhookUrl)) {
        $webhookUrl = [Environment]::GetEnvironmentVariable('TEAMS_WEBHOOK_URL')
    }

    if ([string]::IsNullOrWhiteSpace($webhookUrl)) {
        Write-LogWarning "Teams notification is enabled but TEAMS_WEBHOOK_URL is not configured."
        return
    }

    $timestampUtc = (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm:ssZ')

    $payload = @{
        type = 'message'
        attachments = @(
            @{
                contentType = 'application/vnd.microsoft.card.adaptive'
                contentUrl  = $null
                content     = @{
                    '$schema' = 'http://adaptivecards.io/schemas/adaptive-card.json'
                    type      = 'AdaptiveCard'
                    version   = '1.2'
                    msteams   = @{
                        width = 'Full'
                    }
                    body      = @(
                        @{
                            type   = 'TextBlock'
                            text   = $Title
                            weight = 'Bolder'
                            size   = 'Medium'
                            wrap   = $true
                        },
                        @{
                            type = 'TextBlock'
                            text = $Message
                            wrap = $true
                        },
                        @{
                            type     = 'TextBlock'
                            text     = "Timestamp UTC: $timestampUtc"
                            isSubtle = $true
                            wrap     = $true
                            spacing  = 'Small'
                        }
                    )
                }
            }
        )
    }

    try {
        Invoke-RestMethod `
            -Method Post `
            -Uri $webhookUrl `
            -ContentType 'application/json' `
            -Body ($payload | ConvertTo-Json -Depth 30 -Compress) `
            -TimeoutSec 30 | Out-Null

        Write-LogInfo "Teams notification sent. Title='$Title'"
    }
    catch {
        Write-LogWarning "Teams notification failed. Error='$($_.Exception.Message)'"
    }
}

function Format-NotificationSettingList {
    param(
        [AllowEmptyCollection()]
        [string[]] $Values = @(),

        [string] $EmptyText = 'Not configured'
    )

    $cleanValues = @(
        @($Values) |
            ForEach-Object { [string] $_ } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    )

    if ($cleanValues.Count -eq 0) {
        return $EmptyText
    }

    return ($cleanValues -join ', ')
}

function Get-RegionFromVmInfo {
    param(
        $VmInfo
    )

    $texts = @()

    if ($null -ne $VmInfo) {
        $texts += [string] $VmInfo.ResourceGroup
        $texts += [string] $VmInfo.VmName
    }

    foreach ($text in $texts) {
        if ([string]::IsNullOrWhiteSpace($text)) {
            continue
        }

        if ($text -match '(?i)(^|[-_])(eus2|eus|wus2|wus|cus|scus|neu|weu|uks|ukw|cac|eau|sea)([-_]|$)') {
            return $Matches[2].ToUpperInvariant()
        }

        if ($text -match '(?i)(eastus2|eastus|westus2|westus|centralus|southcentralus|northeurope|westeurope|uksouth|ukwest|canadacentral|australiaeast|southeastasia)') {
            return $Matches[1]
        }
    }

    return 'Unknown'
}

function Format-EntraDeviceList {
    param(
        [AllowEmptyCollection()]
        [object[]] $Devices = @()
    )

    $deviceArray = @($Devices)

    if ($deviceArray.Count -eq 0) {
        return @('None')
    }

    $lines = @()

    foreach ($device in ($deviceArray | Select-Object -First 10)) {
        $lines += "- DisplayName: $($device.displayName); ObjectId: $($device.id); DeviceId: $($device.deviceId); TrustType: $($device.trustType); AccountEnabled: $($device.accountEnabled)"
    }

    if ($deviceArray.Count -gt 10) {
        $lines += "- Additional Entra matches omitted from Teams card. Total Entra matches: $($deviceArray.Count)"
    }

    return $lines
}

function Format-IntuneDeviceList {
    param(
        [AllowEmptyCollection()]
        [object[]] $Devices = @()
    )

    $deviceArray = @($Devices)

    if ($deviceArray.Count -eq 0) {
        return @('None')
    }

    $lines = @()

    foreach ($device in ($deviceArray | Select-Object -First 10)) {
        $lines += "- DeviceName: $($device.deviceName); ManagedDeviceId: $($device.id); AzureADDeviceId: $($device.azureADDeviceId); ComplianceState: $($device.complianceState); LastSync: $($device.lastSyncDateTime); User: $($device.userPrincipalName)"
    }

    if ($deviceArray.Count -gt 10) {
        $lines += "- Additional Intune matches omitted from Teams card. Total Intune matches: $($deviceArray.Count)"
    }

    return $lines
}

function Get-NotificationWarningDetails {
    $warningDetails = @(
        @($script:NotificationWarnings) |
            Where-Object { -not [string]::IsNullOrWhiteSpace([string] $_) } |
            Select-Object -Unique
    )

    return @($warningDetails)
}

function Set-CurrentCleanupContext {
    param(
        [string] $VmName = 'Unknown',
        [string] $ResourceGroup = 'Unknown',
        [string] $SubscriptionId = 'Unknown',
        [string] $Region = 'Unknown',
        [string] $EventId = 'unknown',
        [string] $EventType = 'unknown',
        [string] $Subject = $null
    )

    $script:CurrentCleanupContext = [ordered]@{
        VmName         = $VmName
        ResourceGroup  = $ResourceGroup
        SubscriptionId = $SubscriptionId
        Region         = $Region
        EventId        = $EventId
        EventType      = $EventType
        Subject        = $Subject
    }
}

function Send-CleanupScenarioTeamsNotification {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Title,

        [Parameter(Mandatory = $true)]
        [string] $Status,

        [Parameter(Mandatory = $true)]
        [string] $Scenario,

        [string] $VmName = 'Unknown',
        [string] $Region = 'Unknown',
        [string] $ResourceGroup = 'Unknown',
        [string] $SubscriptionId = 'Unknown',
        [string] $EventId = 'unknown',
        [string] $EventType = 'unknown',
        [string] $Reason = $null,
        [string] $ActionTaken = $null,
        [string] $ManualActionRequired = 'No',
        [string] $RecommendedNextStep = $null,
        [string] $EntraOutcome = 'Not started',
        [string] $IntuneOutcome = 'Not started',

        [AllowEmptyCollection()]
        [object[]] $EntraDevices = @(),

        [AllowEmptyCollection()]
        [object[]] $IntuneDevices = @(),

        [switch] $IncludeDeviceDetails,
        [string] $ErrorMessage = $null
    )

    $lines = @(
        "Status: $Status"
        "Scenario: $Scenario"
        "VM: $VmName"
        "Region: $Region"
        "ResourceGroup: $ResourceGroup"
        "SubscriptionId: $SubscriptionId"
        "DryRun: $script:DryRun"
        "Entra cleanup: $EntraOutcome"
        "Intune cleanup: $IntuneOutcome"
        "EntraMatches: $(@($EntraDevices).Count)"
        "IntuneMatches: $(@($IntuneDevices).Count)"
        "DeleteEntraDevice: $script:DeleteEntraDevice"
        "DeleteIntuneDevice: $script:DeleteIntuneDevice"
    )

    if (-not [string]::IsNullOrWhiteSpace($Reason)) {
        $lines += ''
        $lines += 'Reason:'
        $lines += $Reason
    }

    if (-not [string]::IsNullOrWhiteSpace($ActionTaken)) {
        $lines += ''
        $lines += 'Action taken:'
        $lines += $ActionTaken
    }

    $lines += ''
    $lines += "Manual action required: $ManualActionRequired"

    if (-not [string]::IsNullOrWhiteSpace($RecommendedNextStep)) {
        $lines += ''
        $lines += 'Recommended next step:'
        $lines += $RecommendedNextStep
    }

    if ($IncludeDeviceDetails) {
        $lines += ''
        $lines += 'Matching Entra devices:'
        $lines += Format-EntraDeviceList -Devices $EntraDevices

        $lines += ''
        $lines += 'Matching Intune devices:'
        $lines += Format-IntuneDeviceList -Devices $IntuneDevices
    }

    $warningDetails = @(Get-NotificationWarningDetails)

    if ($warningDetails.Count -gt 0) {
        $lines += ''
        $lines += 'Warnings:'

        foreach ($warning in ($warningDetails | Select-Object -First 5)) {
            $warningText = [string] $warning

            if ($warningText.Length -gt 450) {
                $warningText = $warningText.Substring(0, 450) + '...'
            }

            $lines += "- $warningText"
        }

        if ($warningDetails.Count -gt 5) {
            $lines += "- Additional warnings omitted from Teams card. Total warnings: $($warningDetails.Count)"
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($ErrorMessage)) {
        $lines += ''
        $lines += 'Error message:'
        $lines += $ErrorMessage
    }

    $lines += ''
    $lines += 'Technical details:'
    $lines += "EventId: $EventId"
    $lines += "EventType: $EventType"
    $lines += "ServiceBusMessageId: $script:CurrentServiceBusMessageId"
    $lines += "DeliveryCount: $script:CurrentServiceBusDeliveryCount"

    Send-TeamsNotification -Title $Title -Message ($lines -join "`n")
}

function Process-DeletedVmEvent {
    param(
        [Parameter(Mandatory = $true)]
        $Event
    )

    # Reset per-event warning collection so the Teams card explains only this event.
    $script:NotificationWarnings = @()

    $eventId = Get-EventId -Event $Event
    $eventType = Get-EventType -Event $Event
    $subject = Get-EventSubject -Event $Event

    Set-CurrentCleanupContext -EventId $eventId -EventType $eventType -Subject $subject

    Write-LogInfo "EventId='$eventId', EventType='$eventType', Subject='$subject'"

    if (-not (Test-IsDeletedResourceEvent -EventType $eventType)) {
        $reason = "The event type '$eventType' is not a supported VM deleted event."
        Write-LogWarning "Skipped event because it is not a supported deleted resource event. EventType='$eventType'"

        Send-CleanupScenarioTeamsNotification `
            -Title 'AVD VM cleanup skipped - unsupported event type' `
            -Status 'Skipped' `
            -Scenario 'Unsupported deleted resource event' `
            -EventId $eventId `
            -EventType $eventType `
            -Reason $reason `
            -ActionTaken 'No Entra or Intune lookup was performed.' `
            -ManualActionRequired 'No, unless this event was expected to be processed.' `
            -RecommendedNextStep 'Confirm the Event Grid or Service Bus subscription is sending only supported VM deleted events.'

        return
    }

    if ([string]::IsNullOrWhiteSpace($subject)) {
        $reason = 'The event did not include a resource ID or subject, so the automation could not identify the deleted VM.'
        Write-LogWarning "Skipped event because subject/resource id is empty. EventId='$eventId'"

        Send-CleanupScenarioTeamsNotification `
            -Title 'AVD VM cleanup skipped - missing resource ID' `
            -Status 'Skipped' `
            -Scenario 'Missing VM resource ID' `
            -EventId $eventId `
            -EventType $eventType `
            -Reason $reason `
            -ActionTaken 'No Entra or Intune lookup was performed.' `
            -ManualActionRequired 'Yes, if a VM was deleted and cleanup was expected.' `
            -RecommendedNextStep 'Review the event payload and confirm it contains the deleted VM resource ID.'

        return
    }

    $vmInfo = Parse-AzureVmResourceId -ResourceId $subject

    if ($null -eq $vmInfo) {
        $reason = "The event subject is not a Microsoft.Compute/virtualMachines resource ID. Subject: $subject"
        Write-LogWarning "Skipped event because subject is not a Microsoft.Compute/virtualMachines resource id. Subject='$subject'"

        Send-CleanupScenarioTeamsNotification `
            -Title 'AVD VM cleanup skipped - not a VM resource' `
            -Status 'Skipped' `
            -Scenario 'Deleted resource is not a VM' `
            -EventId $eventId `
            -EventType $eventType `
            -Reason $reason `
            -ActionTaken 'No Entra or Intune lookup was performed.' `
            -ManualActionRequired 'No, unless this resource should have been handled by another cleanup process.' `
            -RecommendedNextStep 'No action is required for this VM cleanup automation.'

        return
    }

    $region = Get-RegionFromVmInfo -VmInfo $vmInfo
    Set-CurrentCleanupContext `
        -VmName $vmInfo.VmName `
        -ResourceGroup $vmInfo.ResourceGroup `
        -SubscriptionId $vmInfo.SubscriptionId `
        -Region $region `
        -EventId $eventId `
        -EventType $eventType `
        -Subject $subject

    Write-LogInfo "Deleted VM parsed. SubscriptionId='$($vmInfo.SubscriptionId)', ResourceGroup='$($vmInfo.ResourceGroup)', VmName='$($vmInfo.VmName)'"

    if (-not $vmInfo.SubscriptionId.Equals($script:TargetSubscriptionId, [System.StringComparison]::OrdinalIgnoreCase)) {
        $reason = "Event subscription ID '$($vmInfo.SubscriptionId)' does not match configured AZURE_SUBSCRIPTION_ID '$script:TargetSubscriptionId'."
        Write-LogWarning "Skipped VM because subscription does not match AZURE_SUBSCRIPTION_ID. EventSubscriptionId='$($vmInfo.SubscriptionId)', TargetSubscriptionId='$script:TargetSubscriptionId', VmName='$($vmInfo.VmName)'"

        Send-CleanupScenarioTeamsNotification `
            -Title 'AVD VM cleanup skipped - subscription mismatch' `
            -Status 'Skipped' `
            -Scenario 'Subscription does not match configured cleanup subscription' `
            -VmName $vmInfo.VmName `
            -Region $region `
            -ResourceGroup $vmInfo.ResourceGroup `
            -SubscriptionId $vmInfo.SubscriptionId `
            -EventId $eventId `
            -EventType $eventType `
            -Reason $reason `
            -ActionTaken 'No Entra or Intune lookup was performed.' `
            -ManualActionRequired 'Review required only if this subscription should be processed.' `
            -RecommendedNextStep 'If this subscription should be processed, update AZURE_SUBSCRIPTION_ID or route events to the correct Function App.'

        return
    }

    if (-not (Test-VmAllowedByScope -VmName $vmInfo.VmName -ResourceGroup $vmInfo.ResourceGroup)) {
        $avdVmNameRegexText = if ([string]::IsNullOrWhiteSpace($script:AvdVmNameRegex)) { 'Not configured' } else { $script:AvdVmNameRegex }

        $configuredScope = @(
            "AllowedResourceGroups: $(Format-NotificationSettingList -Values $script:AllowedResourceGroups)"
            "AllowedVmNames: $(Format-NotificationSettingList -Values $script:AllowedVmNames)"
            "AvdVmNamePrefixes: $(Format-NotificationSettingList -Values $script:AvdVmNamePrefixes)"
            "AvdVmNameRegex: $avdVmNameRegexText"
            "AllowAllVmNamesInSubscription: $script:AllowAllVmNamesInSubscription"
        ) -join "`n"

        $reason = "The VM name or resource group does not match the configured cleanup scope.`n`nConfigured scope:`n$configuredScope"

        Send-CleanupScenarioTeamsNotification `
            -Title 'AVD VM cleanup skipped - scope or prefix mismatch' `
            -Status 'Skipped' `
            -Scenario 'VM name/resource group did not match allowed cleanup scope' `
            -VmName $vmInfo.VmName `
            -Region $region `
            -ResourceGroup $vmInfo.ResourceGroup `
            -SubscriptionId $vmInfo.SubscriptionId `
            -EventId $eventId `
            -EventType $eventType `
            -Reason $reason `
            -ActionTaken 'No Entra or Intune lookup was performed. No device record was deleted.' `
            -ManualActionRequired 'Review required only if this VM should have been processed.' `
            -RecommendedNextStep 'If this VM should be cleaned up automatically, update AVD_VM_NAME_PREFIXES, AVD_VM_NAME_REGEX, ALLOWED_VM_NAMES, or ALLOWED_RESOURCE_GROUPS.'

        return
    }

    if (-not $script:DeleteEntraDevice -and -not $script:DeleteIntuneDevice) {
        $reason = 'Both DELETE_ENTRA_DEVICE and DELETE_INTUNE_DEVICE are false.'
        Write-LogWarning 'Both DELETE_ENTRA_DEVICE and DELETE_INTUNE_DEVICE are false. Nothing to do.'

        Send-CleanupScenarioTeamsNotification `
            -Title 'AVD VM cleanup skipped - cleanup disabled' `
            -Status 'Skipped' `
            -Scenario 'Both cleanup targets are disabled' `
            -VmName $vmInfo.VmName `
            -Region $region `
            -ResourceGroup $vmInfo.ResourceGroup `
            -SubscriptionId $vmInfo.SubscriptionId `
            -EventId $eventId `
            -EventType $eventType `
            -Reason $reason `
            -ActionTaken 'No Entra or Intune lookup/delete was performed.' `
            -ManualActionRequired 'Yes, if cleanup was expected.' `
            -RecommendedNextStep 'Set DELETE_ENTRA_DEVICE=true and/or DELETE_INTUNE_DEVICE=true if cleanup should run.'

        return
    }

    Write-LogInfo 'Connecting to Microsoft Graph using managed identity.'
    [void] (Get-GraphAccessToken)
    Write-LogInfo 'Connected to Microsoft Graph.'

    $entraDevices = @()
    $intuneDevices = @()

    if ($script:DeleteEntraDevice) {
        $entraDevices = @(Find-EntraDevicesByVmName -VmName $vmInfo.VmName)
        Write-LogInfo "Entra device matches found: '$($entraDevices.Count)'"
    }

    $azureAdDeviceIds = @(
        $entraDevices |
            ForEach-Object { [string] $_.deviceId } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    )

    if ($script:DeleteIntuneDevice) {
        $intuneDevices = @(Find-IntuneManagedDevicesByVmName -VmName $vmInfo.VmName -AzureAdDeviceIds $azureAdDeviceIds)
        Write-LogInfo "Intune managedDevice matches found: '$($intuneDevices.Count)'"
    }

    $entraMatchCount = @($entraDevices).Count
    $intuneMatchCount = @($intuneDevices).Count

    if ($entraMatchCount -gt $script:MaxMatchesToDelete -or $intuneMatchCount -gt $script:MaxMatchesToDelete) {
        $reason = "Multiple matching records were found. EntraMatches='$entraMatchCount', IntuneMatches='$intuneMatchCount', MAX_MATCHES_TO_DELETE='$script:MaxMatchesToDelete'. Deletion was skipped to avoid deleting the wrong device."

        Send-CleanupScenarioTeamsNotification `
            -Title 'AVD VM cleanup manual action required - multiple matches' `
            -Status 'Manual Action Required' `
            -Scenario 'Multiple matching devices found' `
            -VmName $vmInfo.VmName `
            -Region $region `
            -ResourceGroup $vmInfo.ResourceGroup `
            -SubscriptionId $vmInfo.SubscriptionId `
            -EventId $eventId `
            -EventType $eventType `
            -Reason $reason `
            -ActionTaken 'No device record was deleted.' `
            -ManualActionRequired 'Yes' `
            -RecommendedNextStep 'Manually validate the listed Entra and Intune records, then delete only the device that belongs to the deleted VM.' `
            -EntraOutcome 'Skipped because multiple or ambiguous matches were found' `
            -IntuneOutcome 'Skipped because multiple or ambiguous matches were found' `
            -EntraDevices $entraDevices `
            -IntuneDevices $intuneDevices `
            -IncludeDeviceDetails

        Write-LogWarning "Safety stop. Matching device count exceeds MAX_MATCHES_TO_DELETE for VmName='$($vmInfo.VmName)'. EntraMatches='$entraMatchCount', IntuneMatches='$intuneMatchCount', MAX_MATCHES_TO_DELETE='$script:MaxMatchesToDelete'. Deletion skipped and Service Bus message will be completed."
        return
    }

    if ($script:DeleteIntuneDevice) {
        Remove-IntuneManagedDevices -Devices $intuneDevices -VmName $vmInfo.VmName
    }

    if ($script:DeleteEntraDevice) {
        Remove-EntraDevices -Devices $entraDevices -VmName $vmInfo.VmName
    }

    if (-not $script:DeleteEntraDevice) {
        $entraOutcome = 'Skipped because DELETE_ENTRA_DEVICE=false'
    }
    elseif ($entraMatchCount -eq 0) {
        $entraOutcome = 'No matching Entra device found'
    }
    elseif ($script:DryRun) {
        $entraOutcome = "Dry run only. Would delete $entraMatchCount matching Entra device(s)"
    }
    else {
        $entraOutcome = "Deleted $entraMatchCount matching Entra device(s)"
    }

    if (-not $script:DeleteIntuneDevice) {
        $intuneOutcome = 'Skipped because DELETE_INTUNE_DEVICE=false'
    }
    elseif ($script:IntuneApiNotApplicable) {
        $intuneOutcome = 'Skipped because Intune Graph API is not applicable to this tenant'
    }
    elseif ($intuneMatchCount -eq 0) {
        $intuneOutcome = 'No matching Intune managed device found'
    }
    elseif ($script:DryRun) {
        $intuneOutcome = "Dry run only. Would delete $intuneMatchCount matching Intune managed device(s)"
    }
    else {
        $intuneOutcome = "Deleted $intuneMatchCount matching Intune managed device(s)"
    }

    $status = 'Completed'
    $scenario = 'Configured cleanup completed'
    $title = 'AVD VM cleanup completed'
    $manualActionRequired = 'No'
    $recommendedNextStep = 'No further action is required.'
    $actionTaken = 'The automation completed the configured cleanup actions.'
    $reason = $null

    if ($script:DryRun) {
        $status = 'Dry Run'
        $scenario = 'Cleanup simulation completed. No device records were deleted.'
        $title = 'AVD VM cleanup dry run completed'
        $actionTaken = 'No records were deleted because DRY_RUN=true.'
        $recommendedNextStep = 'Review the matched device records. If the results look correct, set DRY_RUN=false for production deletion.'
    }
    elseif ($script:DeleteIntuneDevice -and $script:IntuneApiNotApplicable) {
        $status = 'Completed with Warning'
        $scenario = 'Intune cleanup skipped because Intune API is not applicable to this tenant'
        $title = 'AVD VM cleanup completed with warning - Intune skipped'
        $manualActionRequired = 'Review required'
        $reason = "Microsoft Graph returned 'Request not applicable to target tenant' for Intune. Entra cleanup may still have completed, but Intune cleanup was skipped."
        $actionTaken = 'The automation completed the available cleanup actions and skipped Intune cleanup.'
        $recommendedNextStep = 'If this tenant does not use Intune, set DELETE_INTUNE_DEVICE=false. If it should use Intune, verify the Function App managed identity tenant and Graph permissions.'
    }
    elseif ($script:DeleteEntraDevice -and $script:DeleteIntuneDevice -and $entraMatchCount -gt 0 -and $intuneMatchCount -gt 0) {
        $status = 'Success'
        $scenario = 'Deleted from both Microsoft Entra ID and Microsoft Intune'
        $title = 'AVD VM cleanup successful - Entra and Intune deleted'
        $actionTaken = 'Matching device records were deleted from both Microsoft Entra ID and Microsoft Intune.'
    }
    elseif ($script:DeleteEntraDevice -and $script:DeleteIntuneDevice -and $entraMatchCount -gt 0 -and $intuneMatchCount -eq 0) {
        $status = 'Partial Success'
        $scenario = 'Entra device deleted, but no matching Intune device was found'
        $title = 'AVD VM cleanup partial success - Entra deleted, Intune not found'
        $manualActionRequired = 'No, unless an Intune record was expected.'
        $reason = 'A matching Entra device was found, but no matching Intune managed device was found.'
        $actionTaken = 'The Entra device cleanup was completed. No Intune record was deleted because none was found.'
        $recommendedNextStep = 'No action is required unless the VM should have an Intune managed device record. If expected, validate manually in Intune.'
    }
    elseif ($script:DeleteEntraDevice -and $script:DeleteIntuneDevice -and $entraMatchCount -eq 0 -and $intuneMatchCount -gt 0) {
        $status = 'Partial Success'
        $scenario = 'Device existed in Intune but was not found in Entra ID'
        $title = 'AVD VM cleanup partial success - Intune only device found'
        $manualActionRequired = 'No, if the Intune record was deleted successfully. Review required if this was unexpected.'
        $reason = 'No matching Entra device was found, but a matching Intune managed device was found.'
        $actionTaken = 'The Intune cleanup action was performed for the matching Intune record. No Entra record was deleted because none was found.'
        $recommendedNextStep = 'Review only if the device was expected to exist in Entra ID.'
    }
    elseif ($entraMatchCount -eq 0 -and $intuneMatchCount -eq 0) {
        $status = 'No Action Required'
        $scenario = 'Device not found in Entra ID or Intune'
        $title = 'AVD VM cleanup completed - no device records found'
        $actionTaken = 'No records were deleted because no matching Entra or Intune device records were found.'
        $recommendedNextStep = 'No action is required. The device may have already been cleaned up or may never have been registered.'
    }
    elseif ($script:DeleteEntraDevice -and -not $script:DeleteIntuneDevice -and $entraMatchCount -gt 0) {
        $status = 'Success'
        $scenario = 'Configured Entra cleanup completed. Intune cleanup is disabled.'
        $title = 'AVD VM cleanup completed - Entra cleanup only'
        $actionTaken = 'The matching Entra device record was deleted. Intune cleanup was skipped because DELETE_INTUNE_DEVICE=false.'
        $recommendedNextStep = 'No action is required unless Intune cleanup was expected.'
    }
    elseif (-not $script:DeleteEntraDevice -and $script:DeleteIntuneDevice -and $intuneMatchCount -gt 0) {
        $status = 'Success'
        $scenario = 'Configured Intune cleanup completed. Entra cleanup is disabled.'
        $title = 'AVD VM cleanup completed - Intune cleanup only'
        $actionTaken = 'The matching Intune managed device record was deleted. Entra cleanup was skipped because DELETE_ENTRA_DEVICE=false.'
        $recommendedNextStep = 'No action is required unless Entra cleanup was expected.'
    }

    Send-CleanupScenarioTeamsNotification `
        -Title $title `
        -Status $status `
        -Scenario $scenario `
        -VmName $vmInfo.VmName `
        -Region $region `
        -ResourceGroup $vmInfo.ResourceGroup `
        -SubscriptionId $vmInfo.SubscriptionId `
        -EventId $eventId `
        -EventType $eventType `
        -Reason $reason `
        -ActionTaken $actionTaken `
        -ManualActionRequired $manualActionRequired `
        -RecommendedNextStep $recommendedNextStep `
        -EntraOutcome $entraOutcome `
        -IntuneOutcome $intuneOutcome `
        -EntraDevices $entraDevices `
        -IntuneDevices $intuneDevices `
        -IncludeDeviceDetails

    Write-LogInfo "Function completed successfully for VmName='$($vmInfo.VmName)', ResourceGroup='$($vmInfo.ResourceGroup)', DryRun='$script:DryRun'."
}

try {
    Initialize-Settings

    $messageId = Get-PropertyValue -Object $TriggerMetadata -Names @('MessageId', 'messageId')
    $deliveryCount = Get-PropertyValue -Object $TriggerMetadata -Names @('DeliveryCount', 'deliveryCount')

    $script:CurrentServiceBusMessageId = [string] $messageId
    $script:CurrentServiceBusDeliveryCount = [string] $deliveryCount

    Write-LogInfo "=============================="
    Write-LogInfo "Service Bus trigger fired. MessageId='$messageId', DeliveryCount='$deliveryCount'"

    $messageText = ConvertTo-MessageText -InputObject $Message
    $events = ConvertFrom-MessageText -MessageText $messageText

    foreach ($event in $events) {
        Process-DeletedVmEvent -Event $event
    }
}
catch {
    $exceptionMessage = $_.Exception.Message

    $ctx = $script:CurrentCleanupContext

    if ($null -eq $ctx) {
        $ctx = [ordered]@{
            VmName         = 'Unknown'
            ResourceGroup  = 'Unknown'
            SubscriptionId = 'Unknown'
            Region         = 'Unknown'
            EventId        = 'unknown'
            EventType      = 'unknown'
            Subject        = $null
        }
    }

    try {
        Send-CleanupScenarioTeamsNotification `
            -Title 'AVD VM cleanup failed' `
            -Status 'Failed' `
            -Scenario 'Cleanup failed due to API, permission, authentication, network, or script error' `
            -VmName ([string] $ctx.VmName) `
            -Region ([string] $ctx.Region) `
            -ResourceGroup ([string] $ctx.ResourceGroup) `
            -SubscriptionId ([string] $ctx.SubscriptionId) `
            -EventId ([string] $ctx.EventId) `
            -EventType ([string] $ctx.EventType) `
            -Reason 'The automation stopped before cleanup could complete.' `
            -ActionTaken 'Cleanup did not complete successfully. Some records may not have been deleted.' `
            -ManualActionRequired 'Yes' `
            -RecommendedNextStep 'Review the Function App logs, Microsoft Graph permissions, managed identity configuration, and network connectivity. Then manually validate the Entra and Intune device records.' `
            -EntraOutcome 'Unknown - failure occurred before final cleanup result was confirmed' `
            -IntuneOutcome 'Unknown - failure occurred before final cleanup result was confirmed' `
            -ErrorMessage $exceptionMessage
    }
    catch {
        Write-Warning "Failed to send Teams failure notification. Error='$($_.Exception.Message)'"
    }

    Write-Error "EXCEPTION: $exceptionMessage"
    throw
}
