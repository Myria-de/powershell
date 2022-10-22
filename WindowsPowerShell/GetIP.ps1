<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Untitled
#>

   Function GetPublicIP($URL) {
        #write-Host "$(Get-Date) [PUBLICIP] Getting public IP address" -ForegroundColor cyan
        Try {
            $request = Invoke-WebRequest $URL -DisableKeepAlive -UseBasicParsing -ErrorAction Stop
            $myIP = $request.content.trim()
        }
        Catch {
            $myIP = "Unknown"
        }
        $myIP
        #Write-Host ('Öffentliche IPv6: ' + $myIP)
   } #close GetPublicIP


if ([System.Environment]::OSVersion.Platform -eq 'Unix') {
#Write-Host "Linux"
  $ifaces =(ip -br l | awk '$1 { print $1}')
    foreach ($i in $ifaces) {
      $ipaddr = (ip a show $i | awk '/inet / { print $2 }')
      Write-Host $i": "$ipaddr
    }
Write-Host 'Öffentliche IPv6: ' $(GetPublicIP("https://ipv6.icanhazip.com/"))
Write-Host 'Öffentliche IPv4: ' $(GetPublicIP("https://ipv4.icanhazip.com/"))

#Write-Host ('Öffentliche IPv6: ' + $PublicIP)
#Write-Host ('Öffentliche IPv6: ' + $PublicIP)
#Write-Host ('Öffentliche IPvv: ' + $PublicIP)



} else {
#Write-Host "Windows"


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '518,259'
$Form.text                       = "IP-Adressen ermitteln"
$Form.TopMost                    = $false

$btnGetIP                        = New-Object system.Windows.Forms.Button
$btnGetIP.text                   = "IP-Adressen einlesen"
$btnGetIP.width                  = 215
$btnGetIP.height                 = 30
$btnGetIP.location               = New-Object System.Drawing.Point(147,217)
$btnGetIP.Font                   = 'Microsoft Sans Serif,10'

$ListBox1                        = New-Object system.Windows.Forms.ListBox
$ListBox1.text                   = "listBox"
$ListBox1.width                  = 491
$ListBox1.height                 = 189
$ListBox1.location               = New-Object System.Drawing.Point(13,12)

$Form.controls.AddRange(@($btnGetIP,$ListBox1))

$btnGetIP.Add_Click({
    write-Host "$(Get-Date) [LOCALIP] Getting IP address(es)" -ForegroundColor cyan
    $addresses = (Get-netipaddress -AddressFamily IPv4).where( { $_.IPv4Address -notmatch "^(127)|(169)"})
    Foreach ($item in $addresses) {
        $adapter = Get-NetAdapter -InterfaceIndex $item.InterfaceIndex
        $config = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -filter "description='$($adapter.InterfaceDescription)'"
        $a = $adapter.interfacedescription.replace('#', '_').replace('(', '[').replace(')', ']')
        $ListBox1.Items.Add( 'Name: ' +  $item.InterfaceAlias + ' IP: ' + $item.IPAddress)
		}
		
    $PublicIP=GetPublicIP
	$ListBox1.Items.Add('')
	$ListBox1.Items.Add('Öffentliche IP: ' + $PublicIP)
	
  })



[void]$Form.ShowDialog()
}

