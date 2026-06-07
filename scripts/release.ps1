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
    Write-Error "Version must be in format 0.4.0 or v0.4.0"
    exit 1
}

$Tag = "v$CleanVersion"

Write-Host "Pomidor release: $Tag"

if (-not (Test-Path "src/main.c")) {
    Write-Error "src/main.c not found. Run this script from the repository root."
    exit 1
}

git status --short | Out-String | ForEach-Object {
    if ($_.Trim().Length -gt 0) {
        Write-Host "Repository has local changes:"
        Write-Host $_
        Write-Host "They will be included in the release commit."
    }
}

$MainPath = "src/main.c"
$MainText = Get-Content $MainPath -Raw -Encoding UTF8

if ($MainText -match '#define\s+POMIDOR_VERSION\s+"[^"]+"') {
    $MainText = $MainText -replace '#define\s+POMIDOR_VERSION\s+"[^"]+"', "#define POMIDOR_VERSION `"$CleanVersion`""
} else {
    $MainText = "#define POMIDOR_VERSION `"$CleanVersion`"`r`n" + $MainText
}

Set-Content -Path $MainPath -Value $MainText -Encoding UTF8

git add .
git commit -m "Release $Tag"

$ExistingTag = git tag --list $Tag
if ($ExistingTag -eq $Tag) {
    Write-Error "Tag $Tag already exists. Choose another version or delete the old tag."
    exit 1
}

git tag $Tag
git push origin main
git push origin $Tag

Write-Host ""
Write-Host "Done."
Write-Host "GitHub Actions should now build and publish release $Tag."
Write-Host "Open: https://github.com/MihailKashintsev/pomidor-c/actions"
