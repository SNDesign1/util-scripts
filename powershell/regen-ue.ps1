try {
    . .\get-childitemexpand

    $UprojectList = Get-ChildItemExpand -Path $PWD -Filter "*.uproject"
    if ($UprojectList.Length -eq 0) {
        throw "Failed to find uproject file"
    }

    $Uproject = ($UprojectList -split " ")[0]
    $UprojectPath = $Uproject
    $EngineVersion = Get-Content -Raw -Path "$Uproject" | ConvertFrom-Json | Select-Object -ExpandProperty EngineAssociation
    Write-Host "Found engine version $EngineVersion" -ForegroundColor Green

    $DefaultEngineInstallDirectory = "C:\Program Files\Epic Games\UE_"
    $EngineInstallPath = "$DefaultEngineInstallDirectory$EngineVersion"
    if (-not $(Test-Path -Path $EngineInstallPath)) {
        throw "$EngineInstallPath does not exist"
    }

    $BatchFilesPath = "$EngineInstallPath\Engine\Build\BatchFiles"
    Write-Host "Searching for Build.bat in $BatchFilesPath" -ForegroundColor Yellow
    $ChildItems = Get-ChildItem -Path "$BatchFilesPath" -Filter "Build.bat" -Recurse

    $BuildPath = $ChildItems[0].FullName
    Write-Host "Found BuildPath $BuildPath" -ForegroundColor Green

    $UprojectPath = $Uproject.FullName

    & "$BuildPath" -projectfiles -project="$UprojectPath" -game -rocket -progress
}
catch {
    Write-Error $_.Exception.Message
}