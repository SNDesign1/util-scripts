$nodes = @(
    @{ IP = "10.1.0.10"; Client = "WS_HOLOCAVE-1" },
    @{ IP = "10.1.0.11"; Client = "WS_HOLOCAVE-2" },
    @{ IP = "10.1.0.12"; Client = "WS_HOLOCAVE-3" },
    @{ IP = "10.1.0.13"; Client = "WS_HOLOCAVE-4" }
)

$cred = Get-Credential
$depotPath = "//playground/SimTest/lcc_test/..."

$results = foreach ($node in $nodes)
{
    Invoke-Command -ComputerName $node.IP -Credential $cred -ScriptBlock {
        param($depot, $client)

        $result = & p4 -c $client sync $depot 2>&1

        [PSCustomObject]@{
            Node   = $env:COMPUTERNAME
            Client = $client
            Output = $result -join "`n"
        }
    } -ArgumentList $depotPath, $node.Client
}

$results | Format-Table -AutoSize -Wrap