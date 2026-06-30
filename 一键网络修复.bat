@echo off
chcp 65001 >nul
title Network Repair

:: --- Request administrator privileges (needed for winsock / ip reset) ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:menu
cls
echo ========================================
echo             Network Repair
echo ========================================
echo.
echo   [1] Quick fix  (flush DNS cache)
echo   [2] Full reset (flush DNS + renew IP + reset Winsock/TCP-IP)
echo   [3] Show current IP configuration
echo   [0] Exit
echo.
set /p choice=Enter your choice (0-3):

if "%choice%"=="1" goto quick
if "%choice%"=="2" goto full
if "%choice%"=="3" goto showip
if "%choice%"=="0" exit
goto menu

:quick
echo.
echo Flushing DNS cache...
ipconfig /flushdns
echo.
echo Done.
pause
goto menu

:full
echo.
echo Flushing DNS cache...
ipconfig /flushdns
echo Releasing IP address...
ipconfig /release
echo Renewing IP address...
ipconfig /renew
echo Resetting Winsock catalog...
netsh winsock reset
echo Resetting TCP/IP stack...
netsh int ip reset
echo.
echo Done. A RESTART is recommended for the reset to fully take effect.
pause
goto menu

:showip
echo.
ipconfig /all | more
pause
goto menu
