@echo off
set "scriptPath=%~dp0m365qt_script.ps1"
start "" "C:\Program Files\PowerShell\7\pwsh.exe" -NoExit -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; & '%scriptPath%'"
