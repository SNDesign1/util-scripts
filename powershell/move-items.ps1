param(
    [Parameter(Mandatory=$true)]
    [String]$Filter,

    [Parameter(Mandatory=$true)]
    [String]$StartDirectory,

    [Parameter(Mandatory=$true)]
    [String]$DestinationDirectory
)

filter Assert-FolderExists
{
    $exists = Test-Path -Path $_ -PathType Container
    if (!$exists) { 
        throw "$_ does not exist."
    }
}

try {
    $StartDirectory, $DestinationDirectory | Assert-FolderExists
   
    Get-ChildItem -Path $StartDirectory -Filter $Filter -Recurse -FollowSymlink | 
    Move-Item -Destination $DestinationDirectory -Force
}
catch {
    Write-Error $_.Exception.Message
}

