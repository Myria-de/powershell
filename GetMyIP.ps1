# Das Script gibt die aktuelle IPv4-Adresse unter Linux und Windows zurück
Function GetPublicIP {
        write-Host "$(Get-Date) [PUBLICIP] Getting public IP address" -ForegroundColor cyan
        Try {
            $request = Invoke-WebRequest https://ipv4.icanhazip.com/ -DisableKeepAlive -UseBasicParsing -ErrorAction Stop
            $myIP = $request.content.trim()
        }
        Catch {
            $myIP = "Unknown"
        }
        $myIP
}

$IP = if ($IsLinux -or $IsMacOS)
{
    # veraltete
    # $ipInfo = ifconfig | Select-String 'inet'
    # neu: ip addr statt ifconfig
    $ipInfo = ip addr | Select-String 'inet'
    $ipInfo = [regex]::matches($ipInfo,"inet \b(?:\d{1,3}\.){3}\d{1,3}\b") | ForEach-Object value
    foreach ($ip in $ipInfo) {
        $ip.Replace('inet ','')
    }
}
else
{
    # Windows
    Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4'} | ForEach-Object IPAddress
}

# Loopback-Adresse entfernen
Write-Output ("Aktuelle IP: " + ($IP | Where-Object {$_ -ne '127.0.0.1'}))
$PublicIP=GetPublicIP
Write-Output ("Öffentliche IP: " + $PublicIP)


