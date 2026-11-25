@echo off
for %%i in (
	"EnhancedPowerManagementEnabled"
	"AllowIdleIrpInD3"
	"DeviceSelectiveSuspended"
	"DeviceResetNotificationEnabled"
	"SelectiveSuspendEnabled"
        "EnableSelectiveSuspend"
	"DeviceSelectiveSuspended"
	"SelectiveSuspendEnabled"
	"SelectiveSuspendOn"
        "EnumerationRetryCount"
	"WaitWakeEnabled"
	"D3ColdSupported"
	"DisableD3Cold"
	"WdfDirectedPowerTransitionEnable"
	"EnableIdlePowerManagement"
	"IdleInWorkingState"
	"IdleTimeoutInMS"
	"MinimumIdleTimeoutInMS"
	"EnableHIPM"
	"EnableHDDParking"
	"EnableDIPM"
        "DmaRemappingCompatible"
	"DmaRemappingCompatibleSelfhost"
) do (
    for /f "delims=" %%k in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%~i" ^| findstr "HK"') do (
        reg add "%%k" /v "%%~i" /t reg_dword /d 0 /f > nul 2>&1
    )
)

for %%i in (
	"DisableIdlePowerManagement"
	"DisableRuntimePowerManagement"
) do (
    for /f "delims=" %%k in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "%%~i" ^| findstr "HK"') do (
        reg add "%%k" /v "%%~i" /t reg_dword /d 1 /f > nul 2>&1
    )
)