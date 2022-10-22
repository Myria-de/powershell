
if ($PSVersionTable.PSVersion.Major -lt 6) {
# In earlier versions of PowerShell (<6), the history of the commands in the current session is not being saved after it is closed. Using the up/down keys, you can scroll through the command history of the current Powershell session only or list the entire command history using the Get-History cmdlet.
# This code stores the history in a file.

$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
Write-Host "Use history path: $HistoryFilePath"
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) { Import-Clixml $HistoryFilePath | Add-History }
# if you don't already have this configured...
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
}

function sudo
{
	if($args[0] -eq '!!')
	{
		sudo $((Get-History ((Get-History).Count))[0].CommandLine) 
		return
	}
	. $(which sudo) pwsh -NoProfile -Command ". $PROFILE 2>&1 /dev/null; $args"
}

Function ge {Set-Location -Path $home/Dokumente; gedit $args[0]}

         Function FindBig {
            if ($args[0]){
             $loc=$args[0]
            } else {
             $loc=$home }
             Write-Host "Suche in Pfad: $loc" 
             Set-Location $loc
             #Ausgabe in GB
             #gci -r|sort -descending -property length | select -first 10 name, @{Name="Gigabytes";Expression={[Math]::round($_.length / 1GB, 2)}} | Out-GridView

             #Ausgabe in MB
             gci -r|Sort-Object -descending -property length | Select-Object -first 10 directory,name,@{Name="Megabytes";Expression={[Math]::round($_.length / 1MB, 2)}} | Format-List
    }

        Function LastTenFiles {
         if ($args[0]){
        $loc=$args[0]
        } else {
        $loc=$home }
        
        Get-ChildItem $loc -Recurse | Sort-Object -Property LastWriteTime -Descending | Where-Object {$_.Mode -notlike "d*"} | Select-Object -First 10 | Format-Table -Property LastWriteTime,FullName -AutoSize
        }
    

        Function AddFolderObject {
            Param ( 
                [string]$FolderName,
                [long]$FolderSize			
            )
            $Object = New-Object PSObject -Property @{
                'Ordner Name' = $Foldername
                Size = $FolderSize
            }
            Return $Object
    }
    
    Function FolderSizes {
    $Report = @()
    if ($args[0]){
    $rootPath=$args[0]
    } else {
    $rootPath=$home }
    "Bitte warten..."
    Write-Output "Ordnergrößen: $rootPath" > /tmp/ErgebnisDerZaehlung.txt
    $colItems1 = Get-ChildItem -dir $rootPath | Sort-Object
    foreach ($i in $colItems1)
    {
    $colItems = (Get-ChildItem -file -recurse $i.FullName | Measure-Object -property length -Sum)
    $Report += AddFolderObject  $i.FullName $colItems.sum 
    }
    $ReportSorted = $Report | Sort-Object -Property Size -Descending
    $ReportSorted | Select-Object "Ordner Name" ,@{Name='Größe (MB)';Expression={"{0,10:N2}" -f ($_.Size / 1MB)}} >> /tmp/ErgebnisDerZaehlung.txt
    . $(which gedit)  /tmp/ErgebnisDerZaehlung.txt
    }
    
    # Alternative Funktion
    Function FolderSizes2 {
            if ($args[0]){
            $rootPath=$args[0]
            } else {
            $rootPath=$home }
            "Bitte warten..."
            Write-Output "Ordnergrößen: $rootPath" > /tmp/ErgebnisDerZaehlung.txt
           
            $startDirectory = $rootPath
 
#gets a list of folders under the $startDirectory directory
$directoryItems = Get-ChildItem $startDirectory | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
 
#loops throught he list, calculating the size of each directory
    foreach ($i in $directoryItems)
       {
         $subFolderItems = Get-ChildItem $i.FullName -recurse -force | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object -property Length -sum | Select-Object Sum
         $i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
       }
  }
