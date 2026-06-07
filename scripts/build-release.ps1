$ErrorActionPreference = "Stop"

$Root = Resolve-Path "$PSScriptRoot\.."
$Build = Join-Path $Root "build-release"
$Dist = Join-Path $Root "dist"
$Pkg = Join-Path $Dist "pomidor-windows-x64"

if (Test-Path $Build) { Remove-Item $Build -Recurse -Force }
if (Test-Path $Dist) { Remove-Item $Dist -Recurse -Force }
New-Item -ItemType Directory -Force -Path $Pkg | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Pkg "bin") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Pkg "examples") | Out-Null

cmake -S $Root -B $Build
cmake --build $Build --config Release

Copy-Item (Join-Path $Build "Release\pomidor.exe") (Join-Path $Pkg "bin\pomidor.exe") -Force
Copy-Item (Join-Path $Root "examples\*.pom") (Join-Path $Pkg "examples") -Force
Copy-Item (Join-Path $Root "README.md") $Pkg -Force
Copy-Item (Join-Path $Root "LICENSE") $Pkg -Force

Compress-Archive -Path $Pkg -DestinationPath (Join-Path $Dist "pomidor-windows-x64.zip") -Force
Copy-Item (Join-Path $Root "scripts\install.ps1") (Join-Path $Dist "install.ps1") -Force

Write-Host "Готово: $Dist"
