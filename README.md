# Powershell für Linux
Download: https://github.com/PowerShell/PowerShell

Installation:

```
sudo dpkg -i powershell_6.2.0-1.ubuntu.18.04_amd64.deb
sudo apt -f install
```
Alternativ binden Sie das Microsoft-Repositorium in die Ubuntu-Paketquellen ein. Sie erhalten dann automatisch Updates, wenn diese verfügbar sind.
```
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo add-apt-repository universe
sudo apt install -y powershell
```

Nach der Installation starten Sie die Powershell in einem Terminalfenster mit
```
pwsh
```

Durch Eingabe von exit gefolgt von der Enter-Taste verlassen Sie die Powershell wieder.

## Visual Studio Code unter Linux installieren
Download: https://code.visualstudio.com/Download

Installieren Sie das heruntergeladene DEB-Paket in einem Terminalfenster mit
```
sudo dpk -i code_1.33.1-1554971066_amd64.deb
```

## Profildatei
Wo Ihre persönliche Profildatei liegen muss, erfahren Sie in der Powershell über 

```powershell
$profile
```
Profildatei erstellen:
```powershell
if (!(Test-Path -Path $profile )) { New-Item -Type File -Path $profile -Force }
```
Profildatei im Editor öffnen (Visual Studio Code):
```powershell
code $profile
```

## Beispiele
In der Profildatei "/home/[User]/.config/powershell/Microsoft.PowerShell_profile.ps1":
Die Funktion „FindBig“ sucht im angegeben Ordner und seinen Unterordnern mit „Get-ChildItem“ (Alias: gci) nach Dateien. Das Ergebnis wird absteigend nach der Größe sortiert, davon nimmt die Funktion die ersten zehn Dateien, rundet und formatiert die Größe in Megabyte und gibt das Resultat mit „Format-List“ als Liste aus.

„LastTenFiles“ zeigt die neuesten zehn Datei an. Mit „Format-Table“ erfolgt die formatierte Ausgabe im Fenster der Powershell.

„FolderSizes“ schließlich ermittelt Ordnergrößen, die Ausgabe wird in der Datei „ErgebnisDerZaehlung.txt“ gespeichert und automatisch mit Gedit geöffnet.
Alle Funktionen erwarten einen Pfad als Parameter. Fehlt dieser, wird in „$home“ gesucht, dem Profilordner des aktuellen Benutzers.

Die folgend Scripte müssen im Ordner "/home/[User]/Dokumente/WindowsPowerShell" liegen und aus diesem gestartet werden:

```
cd ~/Dokumente/WindowsPowerShell
./Script.ps1
```

**E-Mails versenden:** Powershell bringt die Funktion „Send-MailMessage“ (inzwischen veraltet) mit, über die Sie Emails an einen oder mehrere Empfänger versenden können, bei Bedarf auch mit Anhang. Unser Script „Send-Mail.ps1“ ist nützlich, wenn Sie regelmäßig E-Mails automatisiert an bestimmte Empfänger versenden müssen. Öffnen Sie das Skript in einem Editor und konfigurieren Sie den SMTP-Server (siehe Kommentare). In der Datei „empf.txt“ erwartet das Skript eine Liste mit E-Mail-Adressen (eine pro Zeile). Die Datei „SubjBody.txt“ muss in der ersten Zeile den Betreff und in den folgenden Zeilen den Nachrichtentext enthalten. Zum Start verwenden Sie die Batch-Datei „Send-Mails-to-list.bat“. Bei ersten Aufruf werden Sie nach dem SMTP-Passwort gefragt, das verschlüsselt in der Datei „secret.txt“ gespeichert wird.

**Ordner in ZIP-Archive packen:** Powershell bietet standardmäßig die Funktion „Compress-Archive“, die für einfache ZIP-Archive ausreicht. Ein Beispiel zeigt das Skript „ZipCompressFolder.ps1“. Sie rufen es mit
```
./ZIPCompressFolder.ps1 $home/Dokumente $home/Backup/
```
auf, um ein Backup des Orderns „MeineBriefe“ in einer ZIP-Datei zu erstellen. Die ZIP-Datei landet im Ordner „Documents“ und trägt als Namen das aktuelle Datum sowie die Uhrzeit.

**IP-Adressen ermitteln:*** Das Skript „GetIP.ps1“ zeigt Ihnen die IPv4-Adressen aller Netzwerkadapter und die öffentliche IP des Routers an. 

