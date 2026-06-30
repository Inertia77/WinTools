@echo off
chcp 65001 >nul
title Archive Screenshots by Date

echo ========================================
echo        Archive Screenshots by Date
echo ========================================
echo.
echo Moves screenshots into yyyy-MM subfolders by their date.
echo Nothing is deleted - files are only reorganized.
echo.
choice /c YN /n /m "Proceed? (Y/N)"
if %errorlevel% neq 1 (
    echo Operation cancelled.
    pause
    exit /b
)

echo.
:: Screenshots folder is resolved from the registry (handles the
:: localized folder name without writing it into this file).
powershell -NoProfile -Command ^
  "$k='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders';" ^
  "$ss=[Environment]::ExpandEnvironmentVariables((Get-ItemProperty -Path $k).'{B7BEDE81-DF94-4682-A7D8-57A52620B86F}');" ^
  "if(-not (Test-Path -LiteralPath $ss)){ Write-Host ('Screenshots folder not found: ' + $ss); exit };" ^
  "$files=Get-ChildItem -LiteralPath $ss -File;" ^
  "$n=0;" ^
  "foreach($f in $files){ $sub=Join-Path $ss ($f.LastWriteTime.ToString('yyyy-MM')); if(-not (Test-Path -LiteralPath $sub)){ New-Item -ItemType Directory -Path $sub | Out-Null }; Move-Item -LiteralPath $f.FullName -Destination $sub -Force; $n++ };" ^
  "Write-Host ('Archived ' + $n + ' file(s) under ' + $ss)"

echo.
pause
