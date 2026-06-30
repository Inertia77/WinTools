@echo off
chcp 65001 >nul
title Open Website Collection

:: ============================================================
::  Open Website Collection
::  Edit the list below: one "start" line per site.
::  - Add a site:    start "" "https://example.com"
::  - Disable a site: put :: in front of the line
:: ============================================================

start "" "https://www.google.com"
:: start "" "https://github.com"
:: start "" "https://mail.google.com"
:: start "" "https://www.youtube.com"

exit
