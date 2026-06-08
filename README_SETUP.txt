# Pomidor automatic release

This is the final simple release setup.

It avoids local GitHub CLI release publishing.

## Files

Copy into repository:

.github/workflows/release.yml
scripts/release.sh

## How to release from MSYS2 UCRT64

cd /c/Users/mihai/source/repos/pomidor-c
chmod +x ./scripts/release.sh
./scripts/release.sh 0.4.1

## What happens

1. release.sh updates version in src/main.c.
2. release.sh commits changes.
3. release.sh creates tag v0.4.1.
4. release.sh pushes main and tag.
5. GitHub Actions starts automatically.
6. GitHub Actions builds dist/pomidor.exe.
7. GitHub Actions creates dist/pomidor-windows-x64.zip.
8. GitHub Actions attaches pomidor-windows-x64.zip to GitHub Release.

Pomidor IDE can then download:

https://github.com/MihailKashintsev/pomidor-c/releases/latest/download/pomidor-windows-x64.zip

The ZIP contains pomidor.exe in the archive root.
