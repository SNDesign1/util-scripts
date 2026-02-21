function Get-ChildItemExpand
{
    param(
        [Parameter(Mandatory = $true)]
        [String]$Path,

        [Parameter(Mandatory = $true)]
        [String]$Filter,

        [Parameter(Mandatory = $false)]
        [String]$MaxDepth = 5
    )

    for ($Index = 0; $Index -lt $MaxDepth; $Index++) {
        $Path = Split-Path -parent $Path
        $Files = Get-ChildItem -Path $Path -Recurse -Filter $Filter
        if ($Files.Length -gt 0) {
            foreach ($File in $Files) {
                $FilePath = $File.FullName
                Write-Output $FilePath
                # Write-Host $FilePath
            }
            return
        }
    }
}