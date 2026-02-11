# Requires admin permissions

param (
    [Parameter(Mandatory=$true)]
    [String]$SourceDirectory, # C:\Users\Simeo\Perforce\Simeon_Laptop\client-projects\GameFeatures\Dashboard

    [Parameter(Mandatory=$true)]
    [String]$TargetDirectory # C:\Users\Simeo\Perforce\Simeon_Laptop\client-projects\XRDashboard\Plugins\GameFeatures
)

function New-Link ($RealDirectory, $LinkDirectory) {
    New-Item -Path $LinkDirectory -ItemType SymbolicLink -Value $RealDirectory
}

try {
    $Children = Get-ChildItem -Path $SourceDirectory    
    foreach ($Child in $Children)
    {
        $ChildName = $Child 
        $ChildSourcePath = $Child.FullName

        $ChildLinkPath = Join-Path $TargetDirectory $ChildName
        New-Link -RealDirectory $ChildSourcePath -LinkDirectory $ChildLinkPath
    }
}
catch {
    Write-Error $_.Exception.Message
}

