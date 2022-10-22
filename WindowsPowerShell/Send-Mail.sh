cd ~/Dokumente/WindowsPowerShell
pwsh -command "& { . .\Send-Mail.ps1; Send-Mail -toAddress jemand@host.de -Subject 'test' -Body 'test1 test2'}"
