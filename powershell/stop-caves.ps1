$keyPath = "C:\Users\Simeo\Documents\Setup-Ssh\Holosphere"

0..3 | ForEach-Object {
    $ip = "10.1.0.1$_"
    Write-Host "--- Stopping UnrealEditor on $ip ---"
    ssh -i $keyPath user@$ip "powershell.exe -Command Stop-Process -Name *VisualStudio* -Force"
}