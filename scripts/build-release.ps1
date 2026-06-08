param(
    [string]$Version = "0.4.0"
)

$ErrorActionPreference = "Stop"

Write-Host "Building Pomidor Windows release asset for Pomidor IDE..."

if (-not (Test-Path "src\main.c")) {
    Write-Error "src\main.c not found. Run this script from the repository root."
    exit 1
}

if (Test-Path "dist") {
    Remove-Item "dist" -Recurse -Force
}

New-Item -ItemType Directory -Force "dist" | Out-Null

$exeOut = "dist\pomidor.exe"
$logFile = "dist\build-gcc.log"

$cmake = Get-Command cmake -ErrorAction SilentlyContinue

if ($cmake) {
    Write-Host "CMake found. Building with CMake..."

    $cmakeArgs = @("-S", ".", "-B", "build", "-DCMAKE_BUILD_TYPE=Release")
    if ($Version -ne "") {
        $cmakeArgs += "-DPOMIDOR_VERSION=$Version"
    }

    cmake @cmakeArgs
    cmake --build build --config Release

    $exe = "build\Release\pomidor.exe"
    if (-not (Test-Path $exe)) {
        $exe = "build\pomidor.exe"
    }

    if (-not (Test-Path $exe)) {
        Write-Error "pomidor.exe not found after CMake build"
        exit 1
    }

    Copy-Item $exe $exeOut -Force
}
else {
    Write-Host "CMake not found. Trying GCC fallback..."

    $gccCandidates = @(
        "C:\msys64\ucrt64\bin\gcc.exe",
        "C:\msys64\mingw64\bin\gcc.exe",
        "C:\msys64\clang64\bin\gcc.exe"
    )

    $gcc = $null

    foreach ($candidate in $gccCandidates) {
        if (Test-Path $candidate) {
            $gcc = $candidate
            break
        }
    }

    if (-not $gcc) {
        $gccCommand = Get-Command gcc -ErrorAction SilentlyContinue
        if ($gccCommand) {
            $gcc = $gccCommand.Source
        }
    }

    if (-not $gcc) {
        Write-Error "Neither CMake nor GCC was found. Install CMake or MSYS2 GCC."
        exit 1
    }

    Write-Host "Using GCC: $gcc"

    $sourceFiles = Get-ChildItem -Path "src" -Filter "*.c" | Sort-Object Name | ForEach-Object { $_.FullName }

    if ($sourceFiles.Count -eq 0) {
        Write-Error "No .c files found in src"
        exit 1
    }

    Write-Host "Source files:"
    foreach ($file in $sourceFiles) {
        Write-Host "  $file"
    }

    $defineArg = "-DPOMIDOR_VERSION=`"$Version`""

    $args = @(
        "-std=c11",
        "-O2",
        "-Wall",
        "-Wextra",
        "-I", "src",
        "-finput-charset=UTF-8",
        "-fexec-charset=UTF-8",
        $defineArg
    )

    foreach ($file in $sourceFiles) {
        $args += $file
    }

    $args += @("-o", $exeOut)

    Write-Host ""
    Write-Host "GCC command:"
    Write-Host "`"$gcc`" $($args -join ' ')"
    Write-Host ""

    $output = & $gcc @args 2>&1
    $exitCode = $LASTEXITCODE

    $output | Out-File -FilePath $logFile -Encoding UTF8

    if ($output) {
        Write-Host "GCC output:"
        $output | ForEach-Object { Write-Host $_ }
        Write-Host ""
    }

    if ($exitCode -ne 0) {
        Write-Host "Full GCC log saved to: $logFile"
        Write-Error "GCC build failed with exit code $exitCode"
        exit 1
    }
}

if (-not (Test-Path $exeOut)) {
    Write-Error "dist\pomidor.exe was not created"
    exit 1
}

Write-Host ""
Write-Host "Checking version:"
& ".\dist\pomidor.exe" --version

Push-Location dist
Compress-Archive -Path ".\pomidor.exe" -DestinationPath ".\pomidor-windows-x64.zip" -Force
Pop-Location

Write-Host ""
Write-Host "Archive content:"
$zipList = tar -tf "dist\pomidor-windows-x64.zip"
Write-Host $zipList

if ($zipList -notcontains "pomidor.exe") {
    Write-Error "Invalid archive: pomidor.exe must be in archive root"
    exit 1
}

if (Test-Path "scripts\install.ps1") {
    Copy-Item "scripts\install.ps1" "dist\install.ps1" -Force
}

Write-Host ""
Write-Host "Done:"
Write-Host "dist\pomidor.exe"
Write-Host "dist\pomidor-windows-x64.zip"
Write-Host ""
Write-Host "This ZIP is the asset required by Pomidor IDE."
