$project = if ($args[0]) { $args[0] } else { "//internal-projects/LCC_CAVE/..." }
$keyPath = "C:\Users\Simeo\Documents\Setup-Ssh\Holosphere"

0..3 | ForEach-Object {
    $i = $_
    $ip = "10.1.0.1$i"
    $i = $i + 1
    $client = "WS_HOLOCAVE-$i"
    $psCmd = "`$env:P4CLIENT='$client'; p4 sync $project"
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($psCmd))
    
    Write-Host "--- Syncing $client on $ip ---"
    ssh -i $keyPath user@$ip "powershell.exe -EncodedCommand $encoded"
}