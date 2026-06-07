$ErrorActionPreference = "Stop"

$Repo = "MihailKashintsev/pomidor-c"
$InstallDir = Join-Path $HOME ".pomidor"
$BinDir = Join-Path $InstallDir "bin"
$ZipPath = Join-Path $env:TEMP "pomidor-windows-x64.zip"
$ExtractDir = Join-Path $env:TEMP "pomidor-install"
$Url = "https://github.com/$Repo/releases/latest/download/pomidor-windows-x64.zip"

Write-Host "Pomidor: установка/обновление..."
New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

if (Test-Path $ExtractDir) { Remove-Item $ExtractDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $ExtractDir | Out-Null

Invoke-WebRequest -UseBasicParsing $Url -OutFile $ZipPath
Expand-Archive -Path $ZipPath -DestinationPath $ExtractDir -Force

$Exe = Get-ChildItem -Path $ExtractDir -Recurse -Filter "pomidor.exe" | Select-Object -First 1
if (-not $Exe) { throw "pomidor.exe не найден в архиве релиза" }
Copy-Item $Exe.FullName (Join-Path $BinDir "pomidor.exe") -Force

$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$BinDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$BinDir", "User")
    Write-Host "PATH обновлён. Перезапусти терминал."
}

Write-Host "Pomidor установлен в $BinDir"
Write-Host "Проверка: pomidor --version"
