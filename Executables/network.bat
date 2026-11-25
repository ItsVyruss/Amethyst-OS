@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "$nic = Get-NetAdapter -Physical | Where-Object Status -eq 'Up' | Select-Object -First 1; if ($null -eq $nic) { Write-Host 'No active physical NIC found.'; exit 1 }; Write-Host ('Using NIC: ' + $nic.Name); $ids = @('ms_lldp','ms_rspndr','ms_lltdio','ms_hyperv','vmware_bridge','ms_msclient','ms_server','ms_tcpip6','ms_implat'); foreach ($id in $ids) { Write-Host ('Disabling: ' + $id); Disable-NetAdapterBinding -Name $nic.Name -ComponentID $id -ErrorAction SilentlyContinue }"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-NetOffloadGlobalSetting -ReceiveSegmentCoalescing Enable -ErrorAction SilentlyContinue"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-NetOffloadGlobalSetting -PacketCoalescingFilter Disable -ErrorAction SilentlyContinue"


:: Get the active physical NIC description
for /f "delims=" %%A in ('powershell -NoProfile -Command "(Get-NetAdapter -Physical | Where-Object Status -eq 'Up' | Select-Object -First 1).InterfaceDescription"') do set "nicDesc=%%A"

echo.
echo NIC: %nicDesc%


:: Find the matching driver registry key using DriverDesc
set "adapterKey="

for /f "delims=" %%K in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}" /s /v DriverDesc 2^>nul ^| findstr /i /c:"HKEY_LOCAL_MACHINE"') do (
    for /f "tokens=2,*" %%A in ('reg query "%%K" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
        if /i "%%B"=="%nicDesc%" (
            set "adapterKey=%%K"
            goto :found
        )
    )
)

echo.
echo ERROR: Could not find registry key for active NIC.
goto :done


:found

echo.
echo Adapter registry key:
echo %adapterKey%
echo.


:: Determine manufacturer
echo %nicDesc% | findstr /i "Realtek" >nul
if not errorlevel 1 goto :realtek

echo %nicDesc% | findstr /i "Intel" >nul
if not errorlevel 1 goto :intel

echo Unsupported NIC manufacturer.
goto :done


:intel

echo Intel key:
echo %adapterKey%

reg add "%adapterKey%" /v "*SpeedDuplex" /t REG_SZ /d "6" /f
reg add "%adapterKey%" /v "*RSS" /t REG_SZ /d "1" /f
reg add "%adapterKey%" /v "*NumRssQueues" /t REG_SZ /d "2" /f
reg add "%adapterKey%" /v "*ReceiveBuffers" /t REG_SZ /d "256" /f
reg add "%adapterKey%" /v "*TransmitBuffers" /t REG_SZ /d "256" /f
reg add "%adapterKey%" /v "*DeviceSleepOnDisconnect" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*FlowControl" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
reg add "%adapterKey%" /v "*InterruptModeration" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*TCPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
reg add "%adapterKey%" /v "*TCPChecksumOffloadIPv6" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*UDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
reg add "%adapterKey%" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*WakeOnPattern" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "SipsEnabled" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "WakeOnFastStartup" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "SSIdleTimeoutMS" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*JumboPacket" /t REG_SZ /d "1514" /f
reg add "%adapterKey%" /v "*EEE" /t REG_SZ /d "0" /f
goto :done

:realtek
echo Realtek key:
echo %adapterKey%

reg add "%adapterKey%" /v "*SpeedDuplex" /t REG_SZ /d "6" /f
reg add "%adapterKey%" /v "*RSS" /t REG_SZ /d "1" /f
reg add "%adapterKey%" /v "*NumRssQueues" /t REG_SZ /d "2" /f
reg add "%adapterKey%" /v "*ReceiveBuffers" /t REG_SZ /d "256" /f
reg add "%adapterKey%" /v "*TransmitBuffers" /t REG_SZ /d "256" /f
reg add "%adapterKey%" /v "*DeviceSleepOnDisconnect" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*FlowControl" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
reg add "%adapterKey%" /v "*InterruptModeration" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*TCPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
reg add "%adapterKey%" /v "*TCPChecksumOffloadIPv6" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*UDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f
reg add "%adapterKey%" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*WakeOnPattern" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "ASPM" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "CLKREQ" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "EEEPlus" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "EnableAspm" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "DynamicLTR" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "GigaLite" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "PowerDownPll" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "PowerSavingMode" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*SelectiveSuspend" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "EnableGreenEthernet" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "S4WakeOnLan" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "WakeOnLinkChg" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*JumboPacket" /t REG_SZ /d "1514" /f
reg add "%adapterKey%" /v "*IdleRestriction" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*VMQ" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "VMQSupported" /t REG_SZ /d "0" /f
reg add "%adapterKey%" /v "*EEE" /t REG_SZ /d "0" /f

goto :done

:done

echo.
echo done
