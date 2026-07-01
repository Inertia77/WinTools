# Windows 一键启动 App 的 BAT 定制流程总结

## 目标

在 Windows 电脑上制作一个 `.bat` 批处理文件，双击后可以一键打开常用 App。

本次目标 App 包括：

```text
Microsoft Edge
メモ帳 / Notepad
Microsoft To Do
Outlook
OneNote
Excel
PowerPoint
Claude
MySQL Workbench
Visual Studio Code
Microsoft Teams
Google Chrome
```

---

## 今天遇到的问题

一开始尝试从任务栏图标、开始菜单里找 App 的路径，但很多 App 找不到：

```text
ファイルの場所を開く
打开文件位置
```

原因是这些 App 不一定是传统 `.exe` 程序，有些可能是：

```text
Microsoft Store App
Windows App
新版 Teams
新版 Outlook
新版 Notepad
Electron App
```

所以不能只靠右键找路径。

---

## 正确思路

以后不要死找 `.exe` 路径，要用三种方式综合查：

1. **优先查任务栏固定图标背后的快捷方式**
2. **其次用 `Get-StartApps` 查 Windows AppID**
3. **最后用 `Get-Command` 查传统 exe**

这样可以覆盖大部分 App。

---

## 下次换电脑时直接用的 Prompt

可以把下面这段直接发给 ChatGPT：

```text
我想在这台 Windows 电脑上做一个一键启动常用 App 的 BAT 文件。

目标 App 有：
- Microsoft Edge
- メモ帳 / Notepad
- Microsoft To Do
- Outlook
- OneNote
- Excel
- PowerPoint
- Claude
- MySQL Workbench
- Visual Studio Code
- Microsoft Teams
- Google Chrome

请帮我生成一个 PowerShell 脚本，要求：

1. 先读取任务栏固定图标的快捷方式：
%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar

2. 如果任务栏快捷方式存在，就优先使用它的 TargetPath 和 Arguments。

3. 如果 Target 是 explorer.exe 且 Arguments 里包含 shell:AppsFolder\，就用：
start "" explorer.exe "shell:AppsFolder\xxxx"

4. 如果任务栏快捷方式没找到，就用：
Get-StartApps
查 AppID。

5. 如果 Get-StartApps 也没找到，就用：
Get-Command
尝试查普通 exe，比如：
msedge.exe
notepad.exe
outlook.exe
onenote.exe
excel.exe
powerpnt.exe
code.exe
chrome.exe

6. 最后在桌面生成：
Start_Apps.bat
Start_Apps_Check_Result.txt

7. BAT 文件里每个 App 之间加：
timeout /t 1 /nobreak >nul

8. 检查结果 txt 里要写清楚每个 App 是通过什么方式找到的，如果没找到也要列出来。
```

---

## 今天用到的核心 PowerShell 查询方法

### 1. 查 Windows AppID

```powershell
Get-StartApps | Where-Object { $_.Name -match "OneNote|Teams|Claude|メモ帳|Notepad" } | Format-Table Name, AppID -Auto
```

查到 AppID 后，BAT 里这样启动：

```bat
start "" explorer.exe "shell:AppsFolder\这里放AppID"
```

例如：

```bat
start "" explorer.exe "shell:AppsFolder\Microsoft.WindowsNotepad_8wekyb3d8bbwe!App"
```

---

### 2. 查任务栏固定图标

```powershell
$ws = New-Object -ComObject WScript.Shell
Get-ChildItem "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar" -Filter *.lnk |
ForEach-Object {
    $s = $ws.CreateShortcut($_.FullName)
    [PSCustomObject]@{
        Name = $_.BaseName
        Target = $s.TargetPath
        Arguments = $s.Arguments
    }
} | Format-Table -Auto
```

这个方法很关键，因为任务栏上固定的 App，即使开始菜单找不到路径，它背后也可能有启动信息。

---

### 3. 普通 exe 启动方式

有些传统程序可以直接写：

```bat
start "" notepad.exe
start "" msedge.exe
start "" chrome.exe
start "" code.exe
start "" excel.exe
start "" powerpnt.exe
```

老方法虽然土，但土法炼钢有时候真炼得出钢。😄

---

## BAT 文件基本格式

最终 `.bat` 大概长这样：

```bat
@echo off
chcp 65001 >nul
echo 正在启动常用软件...

rem Microsoft Edge
start "" msedge.exe
timeout /t 1 /nobreak >nul

rem メモ帳 / Notepad
start "" notepad.exe
timeout /t 1 /nobreak >nul

rem OneNote
start "" explorer.exe "shell:AppsFolder\这里换成OneNote的AppID"
timeout /t 1 /nobreak >nul

rem Microsoft Teams
start "" explorer.exe "shell:AppsFolder\这里换成Teams的AppID"
timeout /t 1 /nobreak >nul

rem Claude
start "" explorer.exe "shell:AppsFolder\这里换成Claude的AppID"
timeout /t 1 /nobreak >nul

echo 启动完成。
exit
```

---

## 自动生成 BAT 的 PowerShell 脚本思路

下次可以让 PowerShell 自动完成：

1. 读取任务栏固定图标目录
2. 解析 `.lnk` 快捷方式的 `TargetPath` 和 `Arguments`
3. 如果是 `shell:AppsFolder\...`，生成 Windows App 启动命令
4. 如果是普通 `.exe`，直接生成 exe 启动命令
5. 查不到时，再用 `Get-StartApps`
6. 仍然查不到时，再用 `Get-Command`
7. 输出：
   - `Start_Apps.bat`
   - `Start_Apps_Check_Result.txt`

---

## 注意事项

以后换电脑时，不要直接复制旧电脑的路径，因为：

```text
用户名不同
安装位置不同
Office 版本不同
Teams / Outlook / Notepad 可能是新版 App
Claude 安装方式可能不同
```

所以正确做法是：

```text
先查 → 生成报告 → 再生成 BAT → 测试 → 补没找到的 App
```

---

## 一句话总结

**不要猜路径，让 PowerShell 先把 Windows 的“藏东西癖”揪出来，再自动生成 BAT。** 🪓
