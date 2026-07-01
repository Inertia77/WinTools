@echo off
chcp 65001 >nul
title Computer Shutdown Tool

:menu
cls
echo ========================================
echo           Computer Shutdown Tool
echo ========================================
echo.
echo Please choose an option:
echo.
echo   [1] Shutdown now
echo   [2] Shutdown in 10 minutes
echo   [3] Shutdown in 30 minutes
echo   [4] Shutdown in 1 hour
echo   [5] Restart computer
echo   [6] Cancel scheduled shutdown
echo   [7] Hibernate
echo   [8] Sleep
echo   [9] Lock screen
echo   [0] Exit
echo.
set /p choice=Enter your choice (0-9):

if "%choice%"=="1" goto shutdown_now
if "%choice%"=="2" goto shutdown_10min
if "%choice%"=="3" goto shutdown_30min
if "%choice%"=="4" goto shutdown_1hour
if "%choice%"=="5" goto restart
if "%choice%"=="6" goto cancel
if "%choice%"=="7" goto hibernate
if "%choice%"=="8" goto sleep
if "%choice%"=="9" goto lock
if "%choice%"=="0" exit

echo Invalid choice, please press any key to try again...
pause >nul
goto menu

:shutdown_now
echo.
choice /c YN /n /m "Are you sure you want to shutdown now? (Y/N)"
if %errorlevel% equ 1 (
    echo Shutting down, goodbye!
    shutdown /s /f /t 0
) else (
    echo Operation cancelled.
    pause
    goto menu
)

:shutdown_10min
echo.
echo Shutdown scheduled in 10 minutes.
echo To cancel, run this tool and select option 6.
shutdown /s /t 600
pause
goto menu

:shutdown_30min
echo.
echo Shutdown scheduled in 30 minutes.
echo To cancel, run this tool and select option 6.
shutdown /s /t 1800
pause
goto menu

:shutdown_1hour
echo.
echo Shutdown scheduled in 1 hour.
echo To cancel, run this tool and select option 6.
shutdown /s /t 3600
pause
goto menu

:restart
echo.
choice /c YN /n /m "Are you sure you want to restart? (Y/N)"
if %errorlevel% equ 1 (
    echo Restarting computer...
    shutdown /r /f /t 0
) else (
    echo Operation cancelled.
    pause
    goto menu
)

:cancel
echo.
shutdown /a >nul 2>&1
echo Scheduled shutdown has been cancelled.
pause
goto menu

:hibernate
echo.
choice /c YN /n /m "Are you sure you want to hibernate? (Y/N)"
if %errorlevel% equ 1 (
    echo Hibernating computer...
    shutdown /h
) else (
    echo Operation cancelled.
    pause
    goto menu
)

:sleep
echo.
choice /c YN /n /m "Are you sure you want to sleep? (Y/N)"
if %errorlevel% equ 1 (
    echo Going to sleep...
    rem Note: if hibernation is enabled, this may hibernate instead of sleep.
    rundll32.exe powrprof.dll,SetSuspendState 0,1,0
    goto menu
) else (
    echo Operation cancelled.
    pause
    goto menu
)

:lock
echo.
echo Locking screen...
rundll32.exe user32.dll,LockWorkStation
goto menu
