@echo off
chcp 65001 >nul
echo 正在启动常用软件...

rem Microsoft Edge  [Taskbar shortcut / Microsoft Edge]
start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --profile-directory=Default
timeout /t 1 /nobreak >nul

rem メモ帳 / Notepad  [Get-StartApps / メモ帳]
start "" explorer.exe "shell:AppsFolder\Microsoft.WindowsNotepad_8wekyb3d8bbwe!App"
timeout /t 1 /nobreak >nul

rem Microsoft To Do  [Get-StartApps / Microsoft To Do]
start "" explorer.exe "shell:AppsFolder\Microsoft.Todos_8wekyb3d8bbwe!App"
timeout /t 1 /nobreak >nul

rem Outlook  [Taskbar shortcut / Outlook (classic)]
start "" "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
timeout /t 1 /nobreak >nul

rem OneNote  [Taskbar shortcut / OneNote]
start "" "C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE"
timeout /t 1 /nobreak >nul

rem Excel  [Taskbar shortcut / Excel]
start "" "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE"
timeout /t 1 /nobreak >nul

rem PowerPoint  [Taskbar shortcut / PowerPoint]
start "" "C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE"
timeout /t 1 /nobreak >nul

rem Claude  [Get-StartApps / Claude]
start "" explorer.exe "shell:AppsFolder\Claude_pzs8sxrjxfjjc!Claude"
timeout /t 1 /nobreak >nul

rem MySQL Workbench  [Taskbar shortcut / MySQL Workbench 8.0 CE]
start "" "C:\Program Files\MySQL\MySQL Workbench 8.0 CE\MySQLWorkbench.exe"
timeout /t 1 /nobreak >nul

rem Visual Studio Code  [Taskbar shortcut / Visual Studio Code]
start "" "C:\Users\daixin.tan\AppData\Local\Programs\Microsoft VS Code\Code.exe"
timeout /t 1 /nobreak >nul

rem Microsoft Teams  [Get-StartApps / Microsoft Teams]
start "" explorer.exe "shell:AppsFolder\MSTeams_8wekyb3d8bbwe!MSTeams"
timeout /t 1 /nobreak >nul

rem Google Chrome  [Get-StartApps / Google Chrome]
start "" explorer.exe "shell:AppsFolder\Chrome"
timeout /t 1 /nobreak >nul

echo 启动完成。
exit
