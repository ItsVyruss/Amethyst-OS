etlocal

>nul fltmc || (
    powershell -c "Start-Process '%~f0' -Verb RunAs"
    exit /b
)


logman stop "8696EAC4-1288-4288-A4EE-49EE431B0AD9" -ets >nul 2>&1

logman stop "1DSListener" -ets >nul 2>&1

logman stop "AppModel" -ets >nul 2>&1

logman stop "AutoLogger-Diagtrack-Listener" -ets >nul 2>&1

logman stop "Circular Kernel Context Logger" -ets >nul 2>&1

logman stop "CimFSUnionFS-Filter" -ets >nul 2>&1

logman stop "DefenderApiLogger" -ets >nul 2>&1

logman stop "DefenderAuditLogger" -ets >nul 2>&1

logman stop "DiagLog" -ets >nul 2>&1

logman stop "Diagtrack-Listener" -ets >nul 2>&1

logman stop "RadioMgr" -ets >nul 2>&1

logman stop "WindowsUpdate_trace_log" -ets >nul 2>&1

logman stop "NVIDIA-NVTOPPS-NOCAT" -ets >nul 2>&1

logman stop "NVIDIA-NVTOPPS-FILTER" -ets >nul 2>&1

logman stop "SleepStudyTraceSession" -ets >nul 2>&1

logman stop "UpdateSessionOrchestration" -ets >nul 2>&1

logman stop "MoUxCoreWorker" -ets >nul 2>&1
