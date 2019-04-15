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
