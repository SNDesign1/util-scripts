param (
    [String]$item,
    [String]$destinationLocation,
    [String]$privateKeyPath,
    [Array]$destinationHosts
)

if (-not $(Test-Path $item))
{
    Write-Error "$item does not exist"
    exit 1
}

if (-not $(Test-Path $privateKeyPath))
{
    Write-Error "$privateKeyPath does not exist"
    exit 1
}

foreach ($destinationHost in $destinationHosts)
{
    scp -i "$privateKeyPath" -o stricthostkeychecking=no "$item" user@"$destinationHost":"$destinationLocation"
}

