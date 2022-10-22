 Function Send-Mail {
 <#   
.SYNOPSIS   
    E-Mail versenden
.DESCRIPTION   
    Dieses Script sendet E-Mails bei Bedarf auch mit Anhängen an einen oder mehrere Empfänger
.PARAMETER toAddress 
    Test Test
.PARAMETER Attachment
    Test Test
.PARAMETER Subject 
    Test Test
.PARAMETER Body 
    Test Test
.INPUTS 
.OUTPUTS     
.NOTES   
    Name: Send-Mail
    Author: Thorsten Eggeling
    DateCreated: 23/03/2019
.EXAMPLE   
    Send-Mail -toAddress user@host.de -Subject 'test' -Body 'test1 test2'
    Sendet eine E-Mail an den Benutzer user@host.de
.EXAMPLE   
    Send-Mail -toAddress user@host.de -Subject 'test' -Body 'test1 test2' -Attachment 'C:\Test\Test1.zip'
    Sendet eine E-Mail an den Benutzer user@host.de mit dem Anhang 'C:\Test\Test1.zip'
.EXAMPLE   
    Send-Mail -Subject 'test' -Body 'test1 test2'
    Sendet E-Mails an Empfänger aus der Datei empf.txt
.EXAMPLE   
    Send-Mail -Subject 'test' -Body 'test1 test2'
    Sendet E-Mails an Empfänger aus der Datei empf.txt	
	
#> 



	[CmdletBinding(
    	SupportsShouldProcess=$True,
        ConfirmImpact="Low"
    )]	

	Param
	(
    [Parameter(Mandatory=$false,ValueFromPipeline=$true)] 
    [String]$toAddress,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true)] 
    [String]$Attachment,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true)] 
    [String]$Subject,
    [Parameter(Mandatory=$false,ValueFromPipeline=$true)] 
    [String]$Body

    )

########## Konfiguration Anfang ###############
write-host "AAA"

$emailSmtpServer = "smtp.server.com"
$emailSmtpServerPort = "587"
$emailSmtpUser = "email@server.com"
$pwdFile= $PSScriptRoot + "\secret.txt"
$RecpFile= $PSScriptRoot + "\empf.txt"
$BodyFile= $PSScriptRoot + "\SubjBody.txt"

########## Konfiguration Ende ###############

if (!(Test-Path -path $pwdFile)) { Store-myCreds }

If (!$toAddress) {
 $Recip = "";
   if (Test-Path -path $RecpFile) {
     $RecipientFile = (Get-Content $RecpFile);
     foreach ($Recipient in $RecipientFile)
      {
       $Recip = $Recip + $Recipient.Trim() + ","
      }
$Recip = $Recip.TrimEnd(",")
$toAddressMulti = $Recip.Split(",")
Write-Output $toAddressMulti
   }
}
 
If (!$Subject -AND !$Body) {
  if (Test-Path -path $BodyFile) {
   $Subject=Get-Content $BodyFile | Select-Object -First 1
   $Body=Get-Content $BodyFile | Select-Object -Skip 1 | out-string
}
}



$param = @{
    SmtpServer = $emailSmtpServer
    Port = $emailSmtpServerPort
    UseSsl = $true
    Credential  = Get-myCreds
    From = 'jemad@host.de'
    Subject = $Subject
    Body = $Body

}
#To = $toAddress

 if (!$toAddress -AND $toAddressMulti.Count -eq 0) {
  Write-Host "Warnung: To-Adresse fehlt"
  } else {
    if ($Attachment) {
    $param["Attachments"]=$Attachment
    }

    if ($toAddress) {
    $param["To"]=$toAddress
    } else {
    if (!$toAddressMulti.Count -eq 0) {
    $param["To"]=$toAddressMulti
    }
    }
}

#Send-MailMessage -To $toAddress -From sender@example.com -Subject MultipleRecipients -SmtpServer smtp@example.com
$enc  = New-Object System.Text.utf8encoding

#Send-MailMessage @param  -Encoding ([System.Text.Encoding]::UTF8)
Send-MailMessage @param  -Encoding $enc

}


function Store-myCreds {
Write-Host  $emailSmtpUser
$Credential = Get-Credential -Credential $emailSmtpUser
$Credential.Password | ConvertFrom-SecureString | Set-Content $pwdFile
}

function Get-myCreds {
$User = $emailSmtpUser
$Password = Get-Content $pwdFile | ConvertTo-SecureString
$Credential = New-Object System.Management.Automation.PsCredential($User,$Password)
$Credential
}


function Get-ScriptDirectory { $PSScriptRoot | Split-Path }

function Get-ScriptDirectory2
    {
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
	Write-Host $Invocation
    Split-Path $Invocation.Send-Mail.Path
    }


 
 
