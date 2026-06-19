$cred = Get-Credential  # enter the local admin username/password for the nodes

$nodes = @("10.1.0.10", "10.1.0.11", "10.1.0.12", "10.1.0.13")

Invoke-Command -ComputerName $nodes -Credential $cred -ScriptBlock {
    @(41001, 41002, 41003, 41004) | ForEach-Object {
        New-NetFirewallRule `
            -DisplayName "nDisplay Port $_" `
            -Direction Inbound `
            -Protocol TCP `
            -LocalPort $_ `
            -Action Allow `
            -Profile Any
    }
}