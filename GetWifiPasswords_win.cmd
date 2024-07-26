@echo off
for /f "skip=9 tokens=1,2 delims=:" %%i in ('netsh wlan show profiles') do (
    set "ssid=%%j"
    setlocal enabledelayedexpansion
    if "!ssid:~0,1!"==" " set "ssid=!ssid:~1!"
    for /f "tokens=2 delims=:" %%k in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (
        set "key=%%k"
        if "!key:~0,1!"==" " set "key=!key:~1!"
        echo !ssid!: !key!
    )
    endlocal
)
pause
