@echo off
for /f "skip=9 tokens=1,2 delims=:" %%i in ('netsh wlan show profiles') do (
    set "ssid=%%j"
    setlocal enabledelayedexpansion
    if "!ssid:~0,1!"==" " set "ssid=!ssid:~1!"
    echo !ssid!
    netsh wlan show profile name="!ssid!" key=clear
    endlocal
)
pause
