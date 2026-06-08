# Pomidor IDE release asset patch

Replace/add these files in pomidor-c:

.github/workflows/release.yml
scripts/build-release.ps1
scripts/build-release.sh
scripts/release.ps1

The release workflow now attaches:

pomidor-windows-x64.zip

The archive contains:

pomidor.exe

directly in the archive root.

Local check:

Unblock-File .\scripts\build-release.ps1
.\scripts\build-release.ps1 0.4.0
tar -tf .\dist\pomidor-windows-x64.zip

Correct output:

pomidor.exe

Publish:

Unblock-File .\scripts\release.ps1
.\scripts\release.ps1 0.4.1
