# Debug build-release.ps1

Replace:

scripts/build-release.ps1

Then run:

Unblock-File .\scripts\build-release.ps1
.\scripts\build-release.ps1 0.4.0

If GCC fails again, send the output shown under:

GCC output:

or the file:

dist\build-gcc.log
