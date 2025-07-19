@echo off
:: USE THIS SCRIPT IF UR BROWSER ISNT MENTIONED IN THE MAIN FILE !

:: BRave
echo    - Clearing Brave browser data...
set "BRAVE_PATH=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default"
call :ClearBrowser "%BRAVE_PATH%"

:: Opera
echo    - Clearing Opera browser data...
set "OPERA_PATH=%APPDATA%\Opera Software\Opera Stable"
call :ClearBrowser "%OPERA_PATH%"

:: Edge
echo    - Clearing Microsoft Edge browser data...
set "EDGE_PATH=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default"
call :ClearBrowser "%EDGE_PATH%"

:: Chrome
echo    - Clearing Google Chrome browser data...
set "CHROME_PATH=%LOCALAPPDATA%\Google\Chrome\User Data\Default"
call :ClearBrowser "%CHROME_PATH%"

:: Vivaldi
echo    - Clearing Vivaldi browser data...
set "VIVALDI_PATH=%LOCALAPPDATA%\Vivaldi\User Data\Default"
call :ClearBrowser "%VIVALDI_PATH%"

echo    - All done!
pause
exit /b

:ClearBrowser
set "BROWSER_PATH=%~1"
del /F /Q "%BROWSER_PATH%\History" >nul 2>&1
del /F /Q "%BROWSER_PATH%\Cookies" >nul 2>&1
del /F /Q "%BROWSER_PATH%\Login Data" >nul 2>&1
del /F /Q "%BROWSER_PATH%\Web Data" >nul 2>&1
del /F /Q "%BROWSER_PATH%\Top Sites" >nul 2>&1
del /F /Q "%BROWSER_PATH%\Visited Links" >nul 2>&1
rd /s /q "%BROWSER_PATH%\Cache" >nul 2>&1
rd /s /q "%BROWSER_PATH%\Code Cache" >nul 2>&1
rd /s /q "%BROWSER_PATH%\GPUCache" >nul 2>&1
rd /s /q "%BROWSER_PATH%\Media Cache" >nul 2>&1
exit /b
