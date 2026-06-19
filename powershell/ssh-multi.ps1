param (
    [String]$remoteCommand,
    [String]$privateKeyPath,
    [Array]$destinationHosts
)

if (-not $(Test-Path $privateKeyPath))
{
    Write-Error "$privateKeyPath does not exist"
    exit 1
}

foreach ($destinationHost in $destinationHosts)
{
    ssh -i "$privateKeyPath" -o stricthostkeychecking=no user@"$destinationHost" "$remoteCommand"
}

