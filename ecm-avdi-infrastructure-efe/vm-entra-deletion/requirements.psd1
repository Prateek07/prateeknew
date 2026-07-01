@{
    # Required for Connect-AzAccount and Azure context handling
    'Az.Accounts' = '5.*'

    # Required for resource/tag operations
    'Az.Resources' = '9.*'

    # Required for Storage Account CSV read/write
    'Az.Storage' = '8.*'

    # Required to read VM inventory details
    'Az.Compute' = '11.*'

    # Required for AVD host pool/session host operations
    'Az.DesktopVirtualization' = '5.*'

    # Required for your first automation using Microsoft Graph
    'Microsoft.Graph.Authentication' = '2.*'
    'Microsoft.Graph.Identity.DirectoryManagement' = '2.*'
    'Microsoft.Graph.DeviceManagement' = '2.*'
}

