@echo off
chcp 65001 >nul
title Clear Screenshots and Downloads

echo ========================================
echo    Clear Screenshots and Downloads
echo ========================================
echo.
echo The contents of the following folders will be sent to the
echo Recycle Bin (recoverable). The folders themselves are kept.
echo.

:: --- Show the target folders and their current item counts ---
:: Paths are resolved from the registry so non-ASCII folder names
:: (e.g. the Japanese Screenshots folder) never appear in this file.
powershell -NoProfile -Command ^
  "$k='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders';" ^
  "$p=Get-ItemProperty -Path $k;" ^
  "$dl=[Environment]::ExpandEnvironmentVariables($p.'{374DE290-123F-4565-9164-39C4925E467B}');" ^
  "$ss=[Environment]::ExpandEnvironmentVariables($p.'{B7BEDE81-DF94-4682-A7D8-57A52620B86F}');" ^
  "$sc=@(Get-ChildItem -LiteralPath $ss -Force -ErrorAction SilentlyContinue).Count;" ^
  "$dc=@(Get-ChildItem -LiteralPath $dl -Force -ErrorAction SilentlyContinue).Count;" ^
  "Write-Host ('  Screenshots: ' + $ss + '  (' + $sc + ' items)');" ^
  "Write-Host ('  Downloads  : ' + $dl + '  (' + $dc + ' items)')"

echo.
choice /c YN /n /m "Send the contents of BOTH folders to the Recycle Bin? (Y/N)"
if %errorlevel% neq 1 (
    echo.
    echo Operation cancelled. Nothing was deleted.
    echo.
    pause
    exit /b
)

echo.
echo Working...
echo.

:: --- Move each child item to the Recycle Bin (folders are preserved) ---
powershell -NoProfile -Command ^
  "$ErrorActionPreference='SilentlyContinue';" ^
  "Add-Type -AssemblyName Microsoft.VisualBasic;" ^
  "$k='HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders';" ^
  "$p=Get-ItemProperty -Path $k;" ^
  "$dl=[Environment]::ExpandEnvironmentVariables($p.'{374DE290-123F-4565-9164-39C4925E467B}');" ^
  "$ss=[Environment]::ExpandEnvironmentVariables($p.'{B7BEDE81-DF94-4682-A7D8-57A52620B86F}');" ^
  "$ui=[Microsoft.VisualBasic.FileIO.UIOption]::OnlyErrorDialogs;" ^
  "$rb=[Microsoft.VisualBasic.FileIO.RecycleOption]::SendToRecycleBin;" ^
  "foreach($t in @($ss,$dl)){" ^
  "  if(-not (Test-Path -LiteralPath $t)){ Write-Host ('  Not found: ' + $t); continue }" ^
  "  $n=0;" ^
  "  foreach($it in @(Get-ChildItem -LiteralPath $t -Force)){" ^
  "    try{" ^
  "      if($it.PSIsContainer){ [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($it.FullName,$ui,$rb) }" ^
  "      else{ [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($it.FullName,$ui,$rb) }" ^
  "      $n=$n+1;" ^
  "    } catch { Write-Host ('  Skipped (in use): ' + $it.Name) }" ^
  "  }" ^
  "  Write-Host ('  Removed ' + $n + ' item(s) from ' + $t);" ^
  "}"

echo.
echo Done. Deleted items are in the Recycle Bin if you need them back.
echo.
pause
