@echo off
chcp 65001 >nul
title Clean Temporary Files

:: --- Request administrator privileges (needed for Windows\Temp and Prefetch) ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================
echo         Clean Temporary Files
echo ========================================
echo.
echo This will delete the contents of:
echo   - %%TEMP%%               (your user temp)
echo   - C:\Windows\Temp        (system temp)
echo   - C:\Windows\Prefetch    (prefetch cache)
echo.
echo Files currently in use are skipped automatically.
echo.
choice /c YN /n /m "Proceed? (Y/N)"
if %errorlevel% neq 1 (
    echo Operation cancelled.
    pause
    exit /b
)

echo.
echo Cleaning...
powershell -NoProfile -Command ^
  "$ErrorActionPreference='SilentlyContinue';" ^
  "$targets=@($env:TEMP,'C:\Windows\Temp','C:\Windows\Prefetch');" ^
  "$before=0;" ^
  "foreach($t in $targets){ $before += (Get-ChildItem -LiteralPath $t -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum }" ^
  "foreach($t in $targets){ Get-ChildItem -LiteralPath $t -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue }" ^
  "$after=0;" ^
  "foreach($t in $targets){ $after += (Get-ChildItem -LiteralPath $t -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum }" ^
  "$freed=[math]::Round((($before-$after)/1MB),1);" ^
  "Write-Host ('  Freed approximately ' + $freed + ' MB')"

echo.
echo Done.
echo.
pause
