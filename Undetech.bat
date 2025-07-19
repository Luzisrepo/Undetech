@echo off
:: Minecraft scanner bypass by ._rayzz! :P
setlocal EnableDelayedExpansion

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

set "userName=%userName%" (%USERNAME)
set "currentDate=%DATE%"
set "currentTime=%TIME%"

for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set "ip=%%A"
    set "ip=!ip:~1!"
)

color 5
pause
cls

echo.
echo Logged in as: %userName%
echo Date: %currentDate%
echo Time: %currentTime%
echo IP Address: %ip%
echo.
type ascii.txt
echo.
echo YOU WILL HAVE 30 SECONDS TO INJECT THE CHEAT AFTER CLICKING ENTER, AFTER THAT THE TRACES WILL BE CLEANSED.
pause4

:: Write hta
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

:: Launch
echo [*] Launching %APP_TO_RUN% silently via mshta...

start "" mshta.exe "%CD%\temp.hta"
cls

echo [*] Waiting 30 seconds before cleanup...
timeout /t 30 >nul

:: Clean hta
del temp.hta >nul 2>&1

:: Start cleanup
echo [*] Starting enhanced privacy cleanup...


taskkill /IM brave.exe /F >nul 2>&1
taskkill /IM opera.exe /F >nul 2>&1
cls
echo    - Clearing Prefetch...

del /F /Q %SystemRoot%\Prefetch\*.* >nul 2>&1
cls
echo    - Clearing Run history...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f >nul 2>&1
cls
echo    - Clearing Recent Documents...
del /F /Q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
cls
echo    - Clearing Jump Lists...
del /F /Q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*" >nul 2>&1
del /F /Q "%APPDATA%

\Microsoft\Windows\Recent\CustomDestinations\*" >nul 2>&1

:: Explorer Search Terms
echo    - Clearing Explorer search history...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery" /f >nul 2>&1
cls
echo    - Clearing TEMP files...
del /F /Q "%TEMP%\*.*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
del /F /Q "%SystemRoot%\Temp\*.*" >nul 2>&1
for /d %%D in ("%SystemRoot%\Temp\*") do rd /s /q "%%D" >nul 2>&1

:: WER (Windows Error Reporting)

echo    - Clearing WER logs...
del /F /Q "%ProgramData%\Microsoft\Windows\WER\*.*" >nul 2>&1
for /d %%D in ("%ProgramData%\Microsoft\Windows\WER\*") do rd /s /q "%%D" >nul 2>&1


echo    - Clearing Event Logs...
for /f "tokens=*" %%G in ('wevtutil el') do wevtutil cl "%%G" >nul 2>&1

:: ShellBags
echo    - Clearing ShellBags...
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU" /f >nul 2>&1
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags" /f >nul 2>&1

:: Explorer Typed Paths
echo    - Clearing Explorer address bar...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths" /f >nul 2>&1

:: Search Assistant
echo    - Clearing search assistant...
reg delete "HKCU\Software\Microsoft\Search Assistant" /f >nul 2>&1

:: Internet Explorer/Edge Legacy
echo    - Clearing IE/Edge legacy cache...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255 >nul 2>&1

:: Quick Access
echo    - Clearing Quick Access recent 

items...
del /F /Q "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1

:: OpenSave Dialog
echo    - Clearing Open/Save dialog...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU" /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU" /f >nul 2>&1

::  Brave Browser
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

:: Opera Browser
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

:: === DONE ===
echo.
echo [✓] All traces cleaned successfully!
pause
