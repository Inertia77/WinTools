@echo off
chcp 65001 >nul
title Find Large Files

echo ========================================
echo             Find Large Files
echo ========================================
echo.

set "scan=%USERPROFILE%"
set /p scan=Folder to scan [default: %USERPROFILE%]:
if "%scan%"=="" set "scan=%USERPROFILE%"

set "minmb=100"
set /p minmb=Minimum size in MB [default: 100]:
if "%minmb%"=="" set "minmb=100"

echo.
echo Scanning... (this can take a while for large folders)
echo.

powershell -NoProfile -Command ^
  "$root=$env:scan; $min=[double]$env:minmb * 1MB;" ^
  "if(-not (Test-Path -LiteralPath $root)){ Write-Host ('Folder not found: ' + $root); exit };" ^
  "Get-ChildItem -LiteralPath $root -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.Length -ge $min } | Sort-Object Length -Descending | Select-Object -First 30 @{N='Size(MB)';E={[math]::Round($_.Length/1MB,1)}}, FullName | Format-Table -AutoSize"

echo.
pause
