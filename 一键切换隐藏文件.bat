@echo off
chcp 65001 >nul
title Toggle Hidden Files and Extensions

:menu
cls
echo ========================================
echo    Toggle Hidden Files and Extensions
echo ========================================
echo.
echo   [1] Show  hidden files AND file extensions
echo   [2] Hide  hidden files AND file extensions (Windows default)
echo   [3] Flip current setting
echo   [0] Exit
echo.
set /p choice=Enter your choice (0-3):

if "%choice%"=="1" goto show
if "%choice%"=="2" goto hide
if "%choice%"=="3" goto flip
if "%choice%"=="0" exit
goto menu

:show
powershell -NoProfile -Command ^
  "$a='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced';" ^
  "Set-ItemProperty -Path $a -Name Hidden -Value 1;" ^
  "Set-ItemProperty -Path $a -Name HideFileExt -Value 0;" ^
  "Stop-Process -Name explorer -Force"
echo Now showing hidden files and extensions.
timeout /t 2 >nul
goto menu

:hide
powershell -NoProfile -Command ^
  "$a='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced';" ^
  "Set-ItemProperty -Path $a -Name Hidden -Value 2;" ^
  "Set-ItemProperty -Path $a -Name HideFileExt -Value 1;" ^
  "Stop-Process -Name explorer -Force"
echo Now hiding hidden files and extensions.
timeout /t 2 >nul
goto menu

:flip
powershell -NoProfile -Command ^
  "$a='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced';" ^
  "$cur=(Get-ItemProperty -Path $a -Name Hidden).Hidden;" ^
  "if($cur -eq 1){ $h=2; $e=1; $msg='Hiding hidden files and extensions.' } else { $h=1; $e=0; $msg='Showing hidden files and extensions.' };" ^
  "Set-ItemProperty -Path $a -Name Hidden -Value $h;" ^
  "Set-ItemProperty -Path $a -Name HideFileExt -Value $e;" ^
  "Write-Host $msg;" ^
  "Stop-Process -Name explorer -Force"
timeout /t 2 >nul
goto menu
