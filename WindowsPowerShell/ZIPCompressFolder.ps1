# Aufruf mit [Skriptname] -Source [Quellordner] -Target [Zielordner]
Param(
    $Source,
    $Target
)

if (-not($Source)) 
{
# Quellordner
#$Source = "$env:USERPROFILE\Documents\ZIP-Ordner"
$Source = "$home/Dokumente/ZIP-Ordner"

}
if (-not($Target)) 
{
#Zielordner
#$Target = "$env:USERPROFILE\Documents\"
$Target = "$home/Dokumente/"
}
$Target = $Target.TrimEnd('/') + '/'

Write-Output "Komprimiere: $Target"
$filename = $Target + $(get-date -f yyyy-MM-dd-HH-mm-ss) + ".zip"
#LogFile bei Bedarf ($filename) | Out-File "$home/log.txt" -Append
Write-Output "Erstelle ZIP-Datei: $filename"
Compress-Archive -Path $Source -DestinationPath $filename
Write-Output "Fertig"
