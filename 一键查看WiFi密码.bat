@echo off
chcp 65001 >nul
title Show Saved Wi-Fi Passwords

:: --- Request administrator privileges (needed to read saved keys) ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================
echo         Saved Wi-Fi Passwords
echo ========================================
echo.

:: Export each profile to XML (key=clear) and read the keyMaterial tag.
:: XML tags are the same in every Windows language, so this works on a
:: localized (e.g. Japanese) system where netsh text labels are translated.
powershell -NoProfile -Command ^
  "$ErrorActionPreference='SilentlyContinue';" ^
  "$tmp=Join-Path $env:TEMP ('wlan_' + [guid]::NewGuid().ToString());" ^
  "New-Item -ItemType Directory -Path $tmp -Force | Out-Null;" ^
  "$fa='folder=' + $tmp;" ^
  "netsh wlan export profile key=clear $fa | Out-Null;" ^
  "$rows=Get-ChildItem -LiteralPath $tmp -Filter *.xml | ForEach-Object { [xml]$x=Get-Content -LiteralPath $_.FullName; [pscustomobject]@{ SSID=$x.WLANProfile.name; Password=$x.WLANProfile.MSM.security.sharedKey.keyMaterial } };" ^
  "Remove-Item -LiteralPath $tmp -Recurse -Force;" ^
  "if($rows){ $rows | Sort-Object SSID | Format-Table -AutoSize } else { Write-Host '  No saved Wi-Fi profiles found.' }"

echo.
pause
