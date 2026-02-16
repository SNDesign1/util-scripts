# Requires admin permissions

param (
    [Parameter(Mandatory=$true)]
    [String]$SourceDirectory, 

    [Parameter(Mandatory=$true)]
    [String]$TargetDirectory 
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

