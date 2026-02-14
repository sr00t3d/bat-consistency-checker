@echo off
setlocal enabledelayedexpansion
title DNS Pointing Check

echo =========================================
echo       DNS Configuration Check
echo =========================================
echo.
echo The process will start in 5 seconds...
timeout /t 5 /nobreak >nul

:: Flush/Renew DNS cache (requires admin privileges for best results)
ipconfig /flushdns
:: ipconfig /release
:: ipconfig /renew

echo.
set /p DOMAIN=Enter your full domain (e.g., domain.com): 
set "MAIL=mail.%DOMAIN%"

echo.
echo Testing ping to %MAIL%...
ping -n 1 %MAIL%

echo.
echo Resolving IPs... please wait.

:: 1) IP resolved via Google DNS (8.8.8.8) - Treated as the "Global/Correct" IP
set "IP_GOOGLE="
for /f "tokens=2 delims=: " %%A in ('nslookup %MAIL% 8.8.8.8 ^| findstr /I "Address"') do set "IP_GOOGLE=%%A"
:: Trim whitespace
for /f "tokens=* delims= " %%B in ("!IP_GOOGLE!") do set "IP_GOOGLE=%%B"

:: 2) IP resolved by Local DNS (ISP/Router)
set "IP_LOCAL="
for /f "tokens=2 delims=: " %%A in ('nslookup %MAIL% ^| findstr /I "Address"') do set "IP_LOCAL=%%A"
:: Trim whitespace
for /f "tokens=* delims= " %%B in ("!IP_LOCAL!") do set "IP_LOCAL=%%B"

:: 3) Client Public IP (via OpenDNS)
set "IP_PUB="
for /f "tokens=2 delims=: " %%A in ('nslookup myip.opendns.com resolver1.opendns.com ^| findstr /I "Address"') do set "IP_PUB=%%A"
:: Trim whitespace
for /f "tokens=* delims= " %%B in ("!IP_PUB!") do set "IP_PUB=%%B"

echo.
echo =========================================
echo Check Results:
echo.
echo Target Host .................: %MAIL%
echo.
echo IP (Global/Google DNS 8.8.8.8): !IP_GOOGLE!
echo IP (Local DNS Provider) .....: !IP_LOCAL!
echo Client Public WAN IP ........: !IP_PUB!
echo =========================================
echo.

:: Validation Logic
if "!IP_LOCAL!"=="" (
    echo [ERROR] Could not resolve IP via Local DNS.
) else if "!IP_GOOGLE!"=="" (
    echo [ERROR] Could not resolve IP via Google DNS.
) else (
    if "!IP_LOCAL!"=="!IP_GOOGLE!" (
        echo [OK] Local DNS matches Global DNS. Propagation looks good.
    ) else (
        echo [ALERT] Local DNS does NOT match Global DNS.
        echo         - Possible DNS propagation delay.
        echo         - Possible local cache issue (try restarting modem/PC).
        echo         - Possible 'hosts' file conflict.
    )
)

echo.
pause
endlocal
exit /b
