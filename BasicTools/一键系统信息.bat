@echo off
chcp 65001 >nul
title System Information

powershell -NoProfile -Command ^
  "$os=Get-CimInstance Win32_OperatingSystem;" ^
  "$cs=Get-CimInstance Win32_ComputerSystem;" ^
  "$cpu=Get-CimInstance Win32_Processor | Select-Object -First 1;" ^
  "$up=(Get-Date)-$os.LastBootUpTime;" ^
  "$r=@();" ^
  "$r+='======== System Information ========';" ^
  "$r+=('Computer      : ' + $cs.Name);" ^
  "$r+=('User          : ' + $env:USERNAME);" ^
  "$r+=('OS            : ' + $os.Caption + ' (build ' + $os.BuildNumber + ')');" ^
  "$r+=('CPU           : ' + $cpu.Name.Trim());" ^
  "$r+=('Cores/Threads : ' + $cpu.NumberOfCores + ' / ' + $cpu.NumberOfLogicalProcessors);" ^
  "$r+=('RAM           : ' + [math]::Round($cs.TotalPhysicalMemory/1GB,1) + ' GB');" ^
  "$r+=('Uptime        : ' + [int]$up.TotalHours + 'h ' + $up.Minutes + 'm');" ^
  "$r+='';" ^
  "$r+='-- Disks --';" ^
  "$r+=(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object { '  ' + $_.DeviceID + '  ' + [math]::Round($_.FreeSpace/1GB,1) + ' GB free / ' + [math]::Round($_.Size/1GB,1) + ' GB total' });" ^
  "$r+='';" ^
  "$r+='-- Network (IPv4) --';" ^
  "$r+=(Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object { $_.IPAddress -ne '127.0.0.1' } | ForEach-Object { '  ' + $_.InterfaceAlias + ' : ' + $_.IPAddress });" ^
  "$r | ForEach-Object { Write-Host $_ };" ^
  "Write-Host '';" ^
  "$ans=Read-Host 'Save this report to your Desktop? (Y/N)';" ^
  "if($ans -match '^[Yy]'){ $f=Join-Path ([Environment]::GetFolderPath('Desktop')) 'system-info.txt'; $r | Out-File -LiteralPath $f -Encoding UTF8; Write-Host ('Saved to ' + $f) }"

echo.
pause
