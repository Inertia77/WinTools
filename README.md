# Basic Windows Tools / 常用 Windows 工具集

A collection of one-click `.bat` utilities for everyday PC use.
日常使用的一键式 Windows 批处理小工具集合。

Each tool is a single `.bat` file — just **double-click to run**. Tools that change
system settings will ask for administrator rights automatically.
每个工具都是单独的 `.bat` 文件，**双击即可运行**。需要修改系统设置的工具会自动请求管理员权限。

## Tools / 工具列表

| File / 文件 | What it does / 功能 | Admin / 管理员 | Notes / 说明 |
|---|---|---|---|
| `一键清空截图和下载.bat` | Empties your **Screenshots** and **Downloads** folders | No | Files go to the **Recycle Bin** (recoverable); asks to confirm first. 删除到回收站，可恢复 |
| `一键清理垃圾箱.bat` | Empties the Recycle Bin | No | Permanent. 永久删除 |
| `一键清理临时文件.bat` | Clears `%TEMP%`, `C:\Windows\Temp`, Prefetch | **Yes** | Files in use are skipped automatically. 占用中的文件自动跳过 |
| `一键休眠或关机.bat` | Shutdown / restart / hibernate / **sleep** / **lock**, with timers | No | Cancel a scheduled shutdown via the menu. |
| `一键网络修复.bat` | Flush DNS, renew IP, reset Winsock/TCP-IP | **Yes** | A restart is advised after a full reset. 完整重置后建议重启 |
| `一键查看WiFi密码.bat` | Lists saved Wi-Fi networks and their passwords | **Yes** | Reads exported profile XML (works on localized Windows). |
| `一键系统信息.bat` | One-page report: OS, CPU, RAM, disks, IP, uptime | No | Can save the report to your Desktop. |
| `一键切换隐藏文件.bat` | Toggle hidden files and file extensions in Explorer | No | Restarts Explorer to apply (taskbar will flash briefly). 会重启资源管理器 |
| `一键截图归档.bat` | Moves screenshots into `yyyy-MM` subfolders by date | No | Only reorganizes — nothing is deleted. 只整理不删除 |
| `一键电池报告.bat` | Generates a battery health report and opens it | **Yes** | Desktops without a battery are handled gracefully. |
| `一键查找大文件.bat` | Lists the largest files under a folder you choose | No | Read-only. Default: home folder, files ≥ 100 MB. |
| `一键打开网站集.bat` | Opens a list of websites at once | No | Edit the `start` lines inside to add your own sites. 编辑文件内的网址 |

## How to use / 使用方法

1. Double-click a `.bat` file. 双击 `.bat` 文件。
2. For tools marked **Admin**, accept the User Account Control (UAC) prompt.
   标记 **管理员** 的工具会弹出 UAC 提示，点击「是」。
3. Follow the on-screen menu / prompts. 按屏幕菜单或提示操作。

## Notes / 说明

- **Encoding / 编码**: This PC uses code page 932 (Japanese). To stay safe, every `.bat`
  keeps its *content* ASCII-only and resolves localized folder names (e.g. the Japanese
  Screenshots folder `スクリーンショット`) from the Windows registry **at runtime** instead of
  hard-coding them. Chinese file *names* are fine. 为兼容本机 CP932 编码，批处理内容均为纯
  ASCII，本地化文件夹路径在运行时从注册表读取，不写死在脚本里。
- The Screenshots and Downloads folder locations are read from the registry, so the cleaner
  and archiver keep working even if you move those folders. 截图/下载文件夹路径取自注册表，
  即使移动这些文件夹也能正常工作。
