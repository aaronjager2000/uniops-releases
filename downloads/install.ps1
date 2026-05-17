# UniOps Desktop installer for Windows (internal testing build)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$InstallerUrl = 'https://raw.githubusercontent.com/aaronjager2000/uniops-releases/main/downloads/uniops-windows-x64.exe'

$arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
if ($arch -ne 'X64') {
  Write-Host "[!] UniOps internal-testing builds currently support 64-bit Windows only." -ForegroundColor Yellow
  Write-Host "    Detected: $arch" -ForegroundColor Yellow
  exit 1
}

$tmpExe = Join-Path $env:TEMP "UniOps-Setup.exe"
Write-Host "-> Downloading UniOps Windows installer..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $InstallerUrl -OutFile $tmpExe -UseBasicParsing

Write-Host "-> Removing Mark-of-the-Web..." -ForegroundColor Cyan
try { Unblock-File -Path $tmpExe -ErrorAction Stop } catch { }

Write-Host "-> Running installer..." -ForegroundColor Cyan
$proc = Start-Process -FilePath $tmpExe -ArgumentList '/S' -PassThru -Wait
if ($proc.ExitCode -ne 0) {
  Write-Host "[X] Installer exited with code $($proc.ExitCode)." -ForegroundColor Red
  Write-Host "    Installer saved at $tmpExe" -ForegroundColor Red
  exit $proc.ExitCode
}

Remove-Item $tmpExe -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "[OK] UniOps installed. Look for it in your Start menu." -ForegroundColor Green
