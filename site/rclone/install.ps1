# Installation de 014drive-rclone sous Windows (PowerShell) :
#   irm https://update-014drive.pages.dev/rclone/install.ps1 | iex
# Binaire dans %LOCALAPPDATA%\014drive-rclone (ajouté au PATH de l'utilisateur) ; empreinte SHA-256 vérifiée.
$ErrorActionPreference = 'Stop'
$base = 'https://update-014drive.pages.dev/rclone'
$dest = Join-Path $env:LOCALAPPDATA '014drive-rclone'
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$latest = Invoke-RestMethod "$base/latest.json"
$asset = $latest.platforms.'windows-x86_64'
$exe = Join-Path $dest '014drive-rclone.exe'
$tmp = "$exe.download"
Invoke-WebRequest -UseBasicParsing "$base/014drive-rclone-windows-x86_64.exe" -OutFile $tmp
if ((Get-FileHash $tmp -Algorithm SHA256).Hash.ToLower() -ne $asset.sha256.ToLower()) {
  Remove-Item $tmp
  throw 'Empreinte incorrecte : installation annulée'
}
Move-Item -Force $tmp $exe

$path = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($path -split ';') -notcontains $dest) {
  [Environment]::SetEnvironmentVariable('Path', ($path.TrimEnd(';') + ';' + $dest), 'User')
  $env:Path += ";$dest"
}
Write-Host "014drive-rclone $($latest.version) installé dans $dest."
if (-not (Get-Command rclone -ErrorAction SilentlyContinue)) {
  Write-Host "rclone n'est pas installé : winget install Rclone.Rclone (ou https://rclone.org/downloads/)"
}
Write-Host 'Ensuite, dans un nouveau terminal : 014drive-rclone setup'
