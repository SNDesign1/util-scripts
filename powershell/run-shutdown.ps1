param (
    [Parameter(Mandatory=$true)]
    [String]$IpAddress,

    [Parameter(Mandatory=$false)]
    [String]$Username,

    [Parameter(Mandatory=$false)]
    [String]$Password
)

# Establish authenticated connection
net use "\\$IpAddress\IPC$" /user:$Username $Password
    
# Execute shutdown
shutdown /s /m "\\$IpAddress" /t 0 /f /c "Remote shutdown"