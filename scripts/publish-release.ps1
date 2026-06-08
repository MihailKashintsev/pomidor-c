param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

$CleanVersion = $Version
if ($CleanVersion.StartsWith("v")) {
    $CleanVersion = $CleanVersion.Substring(1)
}

if ($CleanVersion -notmatch '^\d+\.\d+\.\d+$') {
    Write-Error "Version must be like 0.4.0 or v0.4.0"
    exit 1
}

$Tag = "v$CleanVersion"
$Repo = "MihailKashintsev/pomidor-c"

if (-not (Test-Path "dist\pomidor.exe")) {
    Write-Error "dist\pomidor.exe not found. Build it first."
    exit 1
}

New-Item -ItemType Directory -Force "dist" | Out-Null

Push-Location dist
Compress-Archive -Path ".\pomidor.exe" -DestinationPath ".\pomidor-windows-x64.zip" -Force
Pop-Location

$ZipPath = "dist\pomidor-windows-x64.zip"

if (-not (Test-Path $ZipPath)) {
    Write-Error "ZIP was not created: $ZipPath"
    exit 1
}

$ZipList = tar -tf $ZipPath

Write-Host "Archive content:"
Write-Host $ZipList

if ($ZipList -notcontains "pomidor.exe") {
    Write-Error "Invalid ZIP. pomidor.exe must be in archive root."
    exit 1
}

$ExistingTag = git tag --list $Tag

if ($ExistingTag -ne $Tag) {
    git tag $Tag
    git push origin $Tag
}

$ReleaseExists = $false

try {
    gh release view $Tag --repo $Repo | Out-Null
    $ReleaseExists = $true
} catch {
    $ReleaseExists = $false
}

if (-not $ReleaseExists) {
    gh release create $Tag `
        $ZipPath `
        --repo $Repo `
        --title "Pomidor $CleanVersion" `
        --notes "Pomidor $CleanVersion release."
} else {
    gh release upload $Tag $ZipPath --repo $Repo --clobber
}

Write-Host ""
Write-Host "Done."
Write-Host "Release: https://github.com/$Repo/releases/tag/$Tag"
Write-Host "Asset: pomidor-windows-x64.zip"
