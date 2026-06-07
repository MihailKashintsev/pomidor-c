# Fixed Pomidor release script

This is a safe ASCII-only PowerShell release script.

Replace your current file:

scripts/release.ps1

Then run from the repository root:

```powershell
Unblock-File .\scripts\release.ps1
.\scripts\release.ps1 0.4.0
```

If `git commit` says there is nothing to commit, use a new version number, for example:

```powershell
.\scripts\release.ps1 0.4.1
```
