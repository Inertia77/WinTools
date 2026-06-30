@echo off
chcp 65001 >nul
title Recycle Bin Cleaner

echo Cleaning Recycle Bin...
echo.

:: Use PowerShell to clear the Recycle Bin.
:: -ErrorAction SilentlyContinue avoids an error when it is already empty.
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

echo.
echo Recycle Bin cleaned successfully!
echo.
pause
