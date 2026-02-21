. ./get-childitemexpand.ps1

try
{
    $sw = [System.Diagnostics.Stopwatch]::StartNew()

    $UprojectList = Get-ChildItemExpand -Path $PWD -Filter "*.uproject"
    if ($UprojectList.Length -eq 0)
    {
        throw "Failed to find uproject file"
    }

    $Uproject = ($UprojectList -split " ")[0]
    $EngineVersion = Get-Content -Raw -Path "$Uproject" | ConvertFrom-Json | Select-Object -ExpandProperty EngineAssociation

    $DefaultEngineInstallDirectory = "C:\Program Files\Epic Games\UE_"
    $EngineInstallPath = "$DefaultEngineInstallDirectory$EngineVersion"
    if (-not $(Test-Path -Path $EngineInstallPath))
    {
        throw "$EngineInstallPath does not exist"
    }

    $ChildItems = Get-ChildItem -Path "$EngineInstallPath" -Filter "RunUAT.bat" -Recurse
    $RunUATPath = $ChildItems[0].FullName
    $UprojectPath = $Uproject
    $BuildPath = Split-Path $UprojectPath -Parent
    $BuildPath = Join-Path $BuildPath "Builds"

    $Arguments = @(
        "BuildCookRun", 
        "-Build",
        "-Cook",
        "-Stage",
        "-Package",
        "-Project=$UprojectPath",
        "-TargetPlatform=Win64",
        "-ClientConfig=Development",
        "-Archive",
        "-ArchiveDirectory=$BuildPath"
    )

    Write-Host "BuildPath: $BuildPath" -ForegroundColor Yellow 
    Write-Host "CMD: $RunUATPath $Arguments" -ForegroundColor Blue

    & "$RunUATPath" $Arguments

    $FinalBuildPath = "$BuildPath"
    $Children = Get-ChildItem -Path $BuildPath -Recurse -Filter "*.exe"
    if ($Children.Length -gt 0)
    {
        $FinalBuildPath = $Children[0].FullName
        $FinalBuildPath += ". "
    }
    else {
        throw "Build failed."
    }

    $sw.Stop()
    Write-Host "$FinalBuildPath'Completed build in $($sw.Elapsed)" -ForegroundColor Green
}
catch {
    Write-Error $_.Exception.Message        # error message
    Write-Host $_.ScriptStackTrace          # PowerShell script stack trace
    Write-Host $_.Exception.StackTrace      # .NET stack trace
}
