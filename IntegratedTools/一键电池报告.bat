@echo off
chcp 65001 >nul
title Battery Report

:: --- Request administrator privileges (powercfg battery report needs them) ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================
echo             Battery Report
echo ========================================
echo.
echo Generating battery health report...
echo.

powershell -NoProfile -Command ^
  "$dest=Join-Path ([Environment]::GetFolderPath('Desktop')) 'battery-report.html';" ^
  "$null=powercfg /batteryreport /output $dest;" ^
  "if(Test-Path -LiteralPath $dest){ Write-Host ('Report saved to ' + $dest); Start-Process $dest } else { Write-Host 'Could not generate a report. This device may have no battery (e.g. a desktop PC).' }"

echo.
pause
