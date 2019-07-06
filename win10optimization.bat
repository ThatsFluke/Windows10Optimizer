@echo off

Title Windows 10 Optimization Script

echo Do you want to start the Optimize Script?

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOOPTIMIZE

echo "Disabling Error Reporting" & echo.

reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f





echo Disabling Consumer Features (apps downloading automatically) & echo.

reg add HKLM\Software\Policies\Microsoft\Windows\CloudContent /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f





echo Disabling how to use windows (popups) & echo.

reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f



echo Blocking junk apps & echo.

reg load HKLM\DEFAULT c:\users\default\ntuser.dat

reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v PreInstalledAppsEnabled /t REG_DWORD /d 0 /f 

reg add "HKLM\DEFAULT\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OemPreInstalledAppsEnabled /t REG_DWORD /d 0 /f 

reg unload HKLM\DEFAULT



echo Removing useless windows components & echo.

dism /online /norestart /disable-feature /featurename:Printing-PrintToPDFServices-Features

dism /online /norestart /disable-feature /featurename:Printing-XPSServices-Features

dism /online /norestart /disable-feature /featurename:WorkFolders-Client

dism /online /norestart /disable-feature /featurename:WindowsMediaPlayer

dism /online /norestart /disable-feature /featurename:Printing-Foundation-Features

dism /online /norestart /disable-feature /featurename:Printing-Foundation-InternetPrinting-Client

dism /online /norestart /disable-feature /featurename:MSRDC-Infrastructure



REM Small changes

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableFirstLogonAnimation /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\InternetExplorer\Main" /v DisableFirstRunCustomize /t REG_DWORD /d 1 /f



echo Disable NTFS Last Access Timestamps & echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f



echo Disable Memory Dump Creation & echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v CrashDumpEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v LogEvent /t REG_DWORD /d 0 /f

reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v SendAlert /t REG_DWORD /d 0 /f



echo Minor Changes.

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLowDiskSpaceChecks /t REG_DWORD /d 1 /f

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v LinkResolveIgnoreLinkInfo /t REG_DWORD /d 1 /f"

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoResolveSearch /t REG_DWORD /d 1 /f"

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoResolveTrack /t REG_DWORD /d 1 /f"

reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoInternetOpenWith /t REG_DWORD /d 1 /f"

reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v MenuShowDelay /t REG_DWORD /d 0 /f"



echo Would you like to disable automatic app updates? & echo.



setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NO

echo Disabling automatic app updates & echo.

reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v AutoDownload /t REG_WORD /d 2 /f



:NO

endlocal



echo Disabling Hibernation to free up extra disk space & echo.

powercfg -h off

echo Do you want to disable and delete OneDrive?
echo. 

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOONEDRIVE

taskkill /f /im OneDrive.exe

%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall

takeown /R /F %SystemRoot%\SysWOW64\OneDriveSetup.*

icacls %SystemRoot%\SysWOW64\OneDriveSetup.exe /grant %username%:F

:NOONEDRIVE

echo Disabling Superfetch & echo.

sc config "SysMain" start= disabled

sc stop "SysMain"



echo Disabling Windows 10 Experiments & echo.

reg add  "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\System" /v AllowExperimentation /t REG_WORD /d 0 /f



echo Disabling Delivery Optimizations (P2P Updates) & echo.

sc config "DoSvc" start= disabled

sc stop "DoSvc"

echo Do you want to disable Geolocation services? 
echo.

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOGEO

echo Disabling Geolocation services & echo.

sc config "lfsvc" start= disabled

sc stop "lfsvc"

:NOGEO

echo Disabling Biometric service & echo.

sc config "WbioSrvc" start= disabled

sc stop "WbioSrvc"

echo Do you want to disable Windows Mobile Hotspot Services?
echo.

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOHOTSPOT

echo Disabling the Windows Mobile Hotspot service& echo.

sc config "icssvc" start= disabled

sc stop "icssvc"

:NOHOTSPOT

echo Disabling Downloaded Maps Manager & echo.

sc config "MapsBroker" start= disabled

sc stop "MapsBroker"



echo Disabling Windows Media Player Network Sharing Service & echo.

sc config "WMPNetworkSvc" start= disabled

sc stop "WMPNetworkSvc"



echo Disabling Diagnostic Policy Service & echo.

sc config "DPS" start= disabled

sc stop "DPS"



echo Disabling Connected User Experiences and Telemetry & echo.

sc config "DiagTrack" start= disabled

sc stop "DiagTrack"

echo Do you want to disable the remote Registry?
echo. 

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOREG

echo Disabling Remote Registry & echo.

sc config "RemoteRegistry" start= disabled

sc stop "RemoteRegistry"

:NOREG

echo Do you want to disable Windows Error Reporting?
echo.

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOREPORT

echo Disabling Windows Error Reporting Service & echo.

sc config "WerSvc" start= disabled

sc stop "WerSvc"

:NOREPORT

echo Disabling Shared PC Account Manager & echo.

sc config "shpamsvc" start= disabled

sc stop "shpamsvc"



echo Disabling Windows Event Collector & echo.

sc config "Wecsvc" start= disabled

sc stop "Wecsvc"

echo Do you want to disable Auto Time Zone Updater/y?
echo.

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOTIME

echo Disabling Auto Time Zone Updatery & echo.

sc config "tzautoupdate" start= disabled

sc stop "tzautoupdate"

:NOTIME

echo Disabling Hyper-V Volume Shadow Copy Requestor & echo.

sc config "vmicvss" start= disabled

sc stop "vmicvss"



echo  Hyper-V PowerShell Direct Service & echo.

sc config "vmictimesync" start= disabled

sc stop "vmictimesync"

echo Do you want to disable Time Sync Service?
echo.

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOSYNC

echo Disabling Hyper-V Time Synchronization Service & echo.

sc config "vmicvmsession" start= disabled

sc stop "vmicvmsession"

:NOSYNC

echo Do you want to disable Hyper-V Remote Desktop Virtualization?

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOVIRTUAL

echo Disabling Hyper-V Remote Desktop Virtualization Service & echo.

sc config "vmicrdv" start= disabled

sc stop "vmicrdv"

:NOVIRTUAL

echo Disabling Hyper-V Data Exchange Service & echo.

sc config "vmickvpexchange" start= disabled

sc stop "vmickvpexchange"



echo Disabling Hyper-V Heartbeat Service & echo.

sc config "vmicheartbeat" start= disabled

sc stop "vmicheartbeat"



echo Disabling Net.Tcp Port Sharing Service & echo.

sc config "NetTcpPortSharing" start= disabled

sc stop "NetTcpPortSharing"



echo Disabling OpenSSH Authentication Agent & echo.

sc config "ssh-agent" start= disabled

sc stop "ssh-agent"

echo Do you want to disable the Phone service?
echo.

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOPHONE

echo Disabling Phone Service & echo.

sc config "PhoneSvc" start= disabled

sc stop "PhoneSvc"



echo Disabling Remote Procedure Call (RPC) Locator & echo.

sc config "RpcLocator" start= disabled

sc stop "RpcLocator"

:NOPHONE

echo Disabling Routing and Remote Access & echo.

sc config "RemoteAccess" start= disabled

sc stop "RemoteAccess"



echo Disabling Sensor Service & echo.

sc config "SensorService" start= disabled

sc stop "SensorService"

echo Do you want to disable the Themes service?

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOTHEMES

echo Disabling Themes Service & echo.

sc config "Themes" start= disabled

sc stop "Themes"

:NOTHEMES

echo Do you want to disable Windows Push Notifications System Service? (Not Recommnended)
echo.

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NONOTIF

echo Disabling Window Push Notifications System Service & echo.

sc config "WpnService" start= disabled

sc stop "WpnService"

:NONOTIF

REM These are all Windows out-of-the-box bloatware, not 3rd party

echo.

echo Removing Non 3rd party bloatware/useless apps

echo.

echo Removing BingFinance

powershell -command " get-appxpackage -allusers 'Microsoft.BingFinance' | remove-appxpackage "

echo.

echo Removing BingFoodAndDrink

powershell -command " get-appxpackage -allusers 'Microsoft.BingFoodAndDrink' | remove-appxpackage "

echo.

echo Removing BingHealthAndFitness

powershell -command " get-appxpackage -allusers 'Microsoft.BingHealthAndFitness' | remove-appxpackage "

echo.

echo Removing BingMaps

powershell -command " get-appxpackage -allusers 'Microsoft.BingMaps' | remove-appxpackage "

echo.

echo Removing BingNews

powershell -command " get-appxpackage -allusers 'Microsoft.BingNews' | remove-appxpackage "

echo.

echo Removing BingSports

powershell -command " get-appxpackage -allusers 'Microsoft.BingSports' | remove-appxpackage "

echo.

echo Removing BingTranslator

powershell -command " get-appxpackage -allusers 'Microsoft.BingTranslator' | remove-appxpackage "

echo.

echo Removing BingTravel

powershell -command " get-appxpackage -allusers 'Microsoft.BingTravel' | remove-appxpackage "

echo.

echo Removing ConnectivityStore

powershell -command " get-appxpackage -allusers 'Microsoft.ConnectivityStore' | remove-appxpackage "

echo.

echo Removing DiagnosticDataViewer

powershell -command " get-appxpackage -allusers 'Microsoft.DiagnosticDataViewer' | remove-appxpackage "

echo.

echo Removing GetHelp

powershell -command " get-appxpackage -allusers 'Microsoft.GetHelp' | remove-appxpackage "

echo.

echo Removing Getstarted

powershell -command " get-appxpackage -allusers 'Microsoft.Getstarted' | remove-appxpackage "

echo.

echo Removing HelpAndTips

powershell -command " get-appxpackage -allusers 'Microsoft.HelpAndTips' | remove-appxpackage "

echo.

echo Removing Messaging

powershell -command " get-appxpackage -allusers 'Microsoft.Messaging' | remove-appxpackage "

echo.

echo Removing MicrosoftJackpot

powershell -command " get-appxpackage -allusers 'Microsoft.MicrosoftJackpot' | remove-appxpackage "

echo.

echo Removing MicrosoftJigsaw

powershell -command " get-appxpackage -allusers 'Microsoft.MicrosoftJigsaw' | remove-appxpackage "

echo.

echo Removing MicrosoftMahjong

powershell -command " get-appxpackage -allusers 'Microsoft.MicrosoftMahjong' | remove-appxpackage "

echo.

echo Removing MicrosoftOfficeHub

powershell -command " get-appxpackage -allusers 'Microsoft.MicrosoftOfficeHub' | remove-appxpackage "

echo.

echo Removing MicrosoftPowerBIForWindows

powershell -command " get-appxpackage -allusers 'Microsoft.MicrosoftPowerBIForWindows' | remove-appxpackage "

echo.

echo Removing MicrosoftSudoku

powershell -command " get-appxpackage -allusers 'Microsoft.MicrosoftSudoku' | remove-appxpackage "

echo.

echo Removing MovieMoments

powershell -command " get-appxpackage -allusers 'Microsoft.MovieMoments' | remove-appxpackage "

echo.

echo Removing NetworkSpeedTest

powershell -command " get-appxpackage -allusers 'Microsoft.NetworkSpeedTest' | remove-appxpackage "

echo.

echo Removing OneConnect

powershell -command " get-appxpackage -allusers 'Microsoft.OneConnect' | remove-appxpackage "

echo.

echo Do you want to remove People?

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOPEOPLE

echo Removing People

powershell -command " get-appxpackage -allusers 'Microsoft.People' | remove-appxpackage "

echo.

:NOPEOPLE

echo Do you want to remove Skype?

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOSKYPE

echo Removing SkypeApp

powershell -command " get-appxpackage -allusers 'Microsoft.SkypeApp' | remove-appxpackage "

echo.

echo Removing SkypeWiFi

powershell -command " get-appxpackage -allusers 'Microsoft.SkypeWiFi' | remove-appxpackage "

echo.

:NOSKYPE

echo Do you want to remove Windows Feedback Hub?

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOFEED

echo Removing WindowsFeedbackHub

powershell -command " get-appxpackage -allusers 'Microsoft.WindowsFeedbackHub' | remove-appxpackage "

echo.

:NOFEED

echo Removing WindowsReadingList

powershell -command " get-appxpackage -allusers 'Microsoft.WindowsReadingList' | remove-appxpackage "

echo.

echo Removing WorldNationalParks

powershell -command " get-appxpackage -allusers 'Microsoft.WorldNationalParks' | remove-appxpackage "

echo.

echo Removing ContactSupport

powershell -command " get-appxpackage -allusers 'Windows.ContactSupport' | remove-appxpackage "

echo.

echo Removing Wordament

powershell -command " get-appxpackage -allusers 'Microsoft.Studios.Wordament' | remove-appxpackage "

REM powershell -command " get-appxpackage -allusers 'Microsoft.Advertising.JavaScript' | remove-appxpackage "

REM powershell -command " get-appxpackage -allusers 'Microsoft.Advertising.Xaml' | remove-appxpackage "



echo.

echo ----------------------------------------------------------------------------------------------------------------------------------------------

echo Following commands are from the script named "Tron" and will  be used to disable telemetry and serverices for better performance and security.

echo ----------------------------------------------------------------------------------------------------------------------------------------------

timeout -t 6 > nul



echo.

echo Removing bad updates

REM All commands below are from Tron, I take no credit for this and all credit goes to the taltented people behind the Tron script. https://github.com/bmrf/tron

	REM KB 2902907 (https://support.microsoft.com/en-us/kb/2902907)

	start /wait "" wusa /uninstall /kb:2902907 /norestart /quiet

	REM KB 2922324 (https://support.microsoft.com/en-us/kb/2922324)

	start /wait "" wusa /uninstall /kb:2922324 /norestart /quiet

	REM KB 2952664 (https://support.microsoft.com/en-us/kb/2952664)

	start /wait "" wusa /uninstall /kb:2952664 /norestart /quiet

	REM KB 2976978 (https://support.microsoft.com/en-us/kb/2976978)

	start /wait "" wusa /uninstall /kb:2976978 /norestart /quiet

	REM KB 2977759 (https://support.microsoft.com/en-us/kb/2977759)

	start /wait "" wusa /uninstall /kb:2977759 /norestart /quiet

	REM KB 2990214 (https://support.microsoft.com/en-us/kb/2990214)

	start /wait "" wusa /uninstall /kb:2990214 /norestart /quiet

	REM KB 3012973 (https://support.microsoft.com/en-us/kb/3012973)

	start /wait "" wusa /uninstall /kb:3012973 /norestart /quiet

	REM KB 3014460 (https://support.microsoft.com/en-us/kb/3014460)

	start /wait "" wusa /uninstall /kb:3014460 /norestart /quiet

	REM KB 3015249 (https://support.microsoft.com/en-us/kb/3015249)

	start /wait "" wusa /uninstall /kb:3015249 /norestart /quiet

	REM KB 3021917 (https://support.microsoft.com/en-us/kb/3021917)

	start /wait "" wusa /uninstall /kb:3021917 /norestart /quiet

	REM KB 3022345 (https://support.microsoft.com/en-us/kb/3022345)

	start /wait "" wusa /uninstall /kb:3022345 /norestart /quiet

	REM KB 3035583 (https://support.microsoft.com/en-us/kb/3035583)

	start /wait "" wusa /uninstall /kb:3035583 /norestart /quiet

	REM KB 3044374 (https://support.microsoft.com/en-us/kb/3044374)

	start /wait "" wusa /uninstall /kb:3044374 /norestart /quiet

	REM KB 3050265 (https://support.microsoft.com/en-us/kb/3050265)

	start /wait "" wusa /uninstall /kb:3050265 /norestart /quiet

	REM KB 3050267 (https://support.microsoft.com/en-us/kb/3050267)

	start /wait "" wusa /uninstall /kb:3050267 /norestart /quiet

	REM KB 3065987 (https://support.microsoft.com/en-us/kb/3065987)

	start /wait "" wusa /uninstall /kb:3065987 /norestart /quiet

	REM KB 3068708 (https://support.microsoft.com/en-us/kb/3068708)

	start /wait "" wusa /uninstall /kb:3068708 /norestart /quiet

	REM KB 3075249 (https://support.microsoft.com/en-us/kb/3075249)

	start /wait "" wusa /uninstall /kb:3075249 /norestart /quiet

	REM KB 3075851 (https://support.microsoft.com/en-us/kb/3075851)

	start /wait "" wusa /uninstall /kb:3075851 /norestart /quiet

	REM KB 3075853 (https://support.microsoft.com/en-us/kb/3075853)

	start /wait "" wusa /uninstall /kb:3075853 /norestart /quiet

	REM KB 3080149 (https://support.microsoft.com/en-us/kb/3080149)

	start /wait "" wusa /uninstall /kb:3080149 /norestart /quiet

	REM Additional KB entries removed by Microsoft; originally associated with telemetry

	start /wait "" wusa /uninstall /kb:2976987 /norestart /quiet

	start /wait "" wusa /uninstall /kb:3068707 /norestart /quiet

	

echo.

echo Blocking/deleting telemetry tasks

REM All commands below are from Tron, I take no credit for this and all credit goes to the taltented people behind the Tron script. https://github.com/bmrf/tron

	schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"

	schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater"

	schtasks /delete /F /TN "\Microsoft\Windows\Autochk\Proxy"

	schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"

	schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"

	schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"

	schtasks /delete /F /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"

	schtasks /delete /F /TN "\Microsoft\Windows\PI\Sqm-Tasks"

	schtasks /delete /F /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"

	schtasks /delete /F /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting"

	schtasks /delete /f /tn "\Microsoft\Windows\application experience\Microsoft compatibility appraiser"

	schtasks /delete /f /tn "\Microsoft\Windows\application experience\aitagent"

	schtasks /delete /f /tn "\Microsoft\Windows\application experience\programdataupdater"

	schtasks /delete /f /tn "\Microsoft\Windows\autochk\proxy"

	schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\consolidator"

	schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\kernelceiptask"

	schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\usbceip"

	schtasks /delete /f /tn "\Microsoft\Windows\diskdiagnostic\Microsoft-Windows-diskdiagnosticdatacollector"

	schtasks /delete /f /tn "\Microsoft\Windows\maintenance\winsat"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\activateWindowssearch"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\configureinternettimeservice"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\dispatchrecoverytasks"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\ehdrminit"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\installplayready"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\mcupdate"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\mediacenterrecoverytask"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\objectstorerecoverytask"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\ocuractivate"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\ocurdiscovery"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscovery">nul 2>&1

	schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscoveryw1"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscoveryw2"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\pvrrecoverytask"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\pvrscheduletask"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\registersearch"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\reindexsearchroot"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\sqlliterecoverytask"

	schtasks /delete /f /tn "\Microsoft\Windows\media center\updaterecordpath"



echo.

echo Blocking serverices

REM All commands below are from Tron, I take no credit for this and all credit goes to the taltented people behind the Tron script. https://github.com/bmrf/tron

	:: Diagnostic Tracking; changed delete to disable on 2017-08-28 per https://www.reddit.com/r/TronScript/comments/6vjeap/connected_user_experience_and_telemetry_service/dm2dv3d/?context=3

	sc stop Diagtrack

	sc config Diagtrack start= disabled



	:: Remote Registry (disable only)

	sc config remoteregistry start= disabled

	sc stop remoteregistry



	:: Retail Demo

	sc stop RetailDemo

	sc delete RetailDemo



	:: "WAP Push Message Routing Service"

	sc stop dmwappushservice

	sc config dmwappushservice start= disabled



	:: Windows Event Collector Service (disable only)

	sc stop Wecsvc

	sc config Wecsvc start= disabled



	:: Xbox Live services

	sc stop XblAuthManager

	sc stop XblGameSave

	sc stop XboxNetApiSvc

	sc stop XboxGipSvc

	sc stop xbgm

	sc config XblAuthManager start= disabled

	sc config XblGameSave start= disabled

	sc config XboxNetApiSvc start= disabled

	sc config XboxGipSvc start= disabled

	sc config xbgm start= disabled

	

echo.

echo Blocking serverices

REM All commands below are from Tron, I take no credit for this and all credit goes to the taltented people behind the Tron script. https://github.com/bmrf/tron

	REG add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f

	REG add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f

	

	REM Keylogger

	REG add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f

	

	REM Wifi sense; this is a nasty one, privacy-wise

	REG add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisensecredshared" /t REG_DWORD /d "0" /f

	REG add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisenseopen" /t REG_DWORD /d "0" /f

	

	REM Windows Defender sample reporting

	REG add "HKLM\software\microsoft\windows defender\spynet" /v "spynetreporting" /t REG_DWORD /d "0" /f

	REG add "HKLM\software\microsoft\windows defender\spynet" /v "submitsamplesconsent" /t REG_DWORD /d "0" /f

	

	REM SkyDrive

	REG add "HKLM\software\policies\microsoft\windows\skydrive" /v "disablefilesync" /t REG_DWORD /d "1" /f

	

	REM Kill OneDrive from hooking into Explorer even when disabled

	REG add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f

	REG add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f

	

	REM DiagTrack service

	REG add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f

	

	REM "WAP Push Message Routing Service"

	REG add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f

	

	REM Disable Cortana globally

	REG add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f

	REG add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f

	REG add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f



	REM Disable "Search online and include web results"

	REG add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f

	REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f

	

echo.

echo Blocking bad hosts

REM All commands below are from Tron, I take no credit for this and all credit goes to the taltented people behind the Tron script. https://github.com/bmrf/tron

	:: a-0001.a-msedge.net

	route -p add 204.79.197.200/32 0.0.0.0

	:: a23-218-212-69.deploy.static.akamaitechnologies.com

	route -p add 23.218.212.69/32 0.0.0.0

	:: a.ads1.msn.com

	route -p add 204.160.124.125/32 0.0.0.0

	route -p add 8.253.14.126/32 0.0.0.0

	route -p add 8.254.25.126/32 0.0.0.0

	:: a.ads2.msads.net

	route -p add 93.184.215.200/32 0.0.0.0

	:: a.ads2.msn.com

	route -p add 198.78.194.252/32 0.0.0.0

	route -p add 198.78.209.253/32 0.0.0.0

	route -p add 8.254.23.254/32 0.0.0.0

	:: ac3.msn.com

	route -p add 131.253.14.76/32 0.0.0.0

	:: ads1.msads.net

	route -p add 23.201.58.73/32 0.0.0.0

	:: ads1.msn.com

	route -p add 204.160.124.125/32 0.0.0.0

	route -p add 8.253.14.126/32 0.0.0.0

	route -p add 8.254.25.126/32 0.0.0.0

	:: adsmockarc.azurewebsites.net

	route -p add 191.236.16.12/32 0.0.0.0

	:: ads.msn.com

	route -p add 157.56.91.82/32 0.0.0.0

	:: auth.gfx.ms

	route -p add 23.61.72.70/32 0.0.0.0

	:: b.ads1.msn.com

	route -p add 204.160.124.125/32 0.0.0.0

	route -p add 8.253.14.126/32 0.0.0.0

	route -p add 8.254.25.126/32 0.0.0.0

	:: b.ads2.msads.net

	route -p add 93.184.215.200/32 0.0.0.0

	:: df.telemetry.microsoft.com

	route -p add 65.52.100.7/32 0.0.0.0

	:: help.bingads.microsoft.com

	route -p add 207.46.202.114/32 0.0.0.0

	:: oca.telemetry.microsoft.com

	route -p add 65.55.252.63/32 0.0.0.0

	:: oca.telemetry.microsoft.com.nsatc.net

	route -p add 65.55.252.63/32 0.0.0.0

	:: pre.footprintpredict.com

	route -p add 204.79.197.200/32 0.0.0.0

	:: reports.wes.df.telemetry.microsoft.com

	route -p add 65.52.100.91/32 0.0.0.0

	:: sb.scorecardresearch.com

	route -p add 104.79.156.195/32 0.0.0.0

	:: services.wes.df.telemetry.microsoft.com

	route -p add 65.52.100.92/32 0.0.0.0

	:: settings-win.data.microsoft.com

	route -p add 65.55.44.108/32 0.0.0.0

	:: s.gateway.messenger.live.com

	route -p add 157.56.106.210/32 0.0.0.0

	:: sgmetrics.cloudapp.net

	route -p add 168.62.11.145/32 0.0.0.0

	:: spynet2.microsoft.com

	route -p add 23.96.212.225/32 0.0.0.0

	:: spynetalt.microsoft.com

	route -p add 23.96.212.225/32 0.0.0.0

	:: sqm.df.telemetry.microsoft.com

	route -p add 65.52.100.94/32 0.0.0.0

	:: sqm.telemetry.microsoft.com

	route -p add 65.55.252.93/32 0.0.0.0

	:: sqm.telemetry.microsoft.com.nsatc.net

	route -p add 65.55.252.93/32 0.0.0.0

	:: statsfe1.ws.microsoft.com

	route -p add 134.170.115.60/32 0.0.0.0

	route -p add 207.46.114.61/32 0.0.0.0

	:: statsfe2.update.microsoft.com.akadns.net

	route -p add 65.52.108.153/32 0.0.0.0

	:: statsfe2.ws.microsoft.com

	route -p add 64.4.54.22/32 0.0.0.0

	:: storeedgefd.dsx.mp.microsoft.com // Disabled for Tron, required for the Microsoft App Store to connect

	:: route -p add 104.79.153.53/32 0.0.0.0

	:: telecommand.telemetry.microsoft.com

	route -p add 65.55.252.92/32 0.0.0.0

	:: telecommand.telemetry.microsoft.com.nsatc.net

	route -p add 65.55.252.92/32 0.0.0.0

	:: telemetry.appex.bing.net

	route -p add 168.62.187.13/32 0.0.0.0

	:: telemetry.microsoft.com

	route -p add 65.52.100.9/32 0.0.0.0

	:: telemetry.urs.microsoft.com

	route -p add 131.253.40.37/32 0.0.0.0

	:: vortex.data.microsoft.com

	route -p add 64.4.54.254/32 0.0.0.0

	:: vortex-sandbox.data.microsoft.com

	route -p add 64.4.54.32/32 0.0.0.0

	:: vortex-win.data.microsoft.com

	route -p add 64.4.54.254/32 0.0.0.0

	:: watson.live.com

	route -p add 207.46.223.94/32 0.0.0.0

	:: watson.microsoft.com

	route -p add 65.55.252.71/32 0.0.0.0

	:: watson.ppe.telemetry.microsoft.com

	route -p add 65.52.100.11/32 0.0.0.0

	:: watson.telemetry.microsoft.com

	route -p add 65.52.108.29/32 0.0.0.0

	:: watson.telemetry.microsoft.com.nsatc.net

	route -p add 65.52.108.29/32 0.0.0.0

	:: wes.df.telemetry.microsoft.com

	route -p add 65.52.100.93/32 0.0.0.0

	

echo.

echo Other tasks

REM All commands below are from Tron, I take no credit for this and all credit goes to the taltented people behind the Tron script. https://github.com/bmrf/tron



:: Kill pending tracking reports

if not exist %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\ mkdir %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\ >NUL 2>&1

echo. > %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl 2>NUL

echo y|cacls.exe "%programdata%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /d SYSTEM >NUL 2>&1



:: Kill "show fun tips, hints and tricks" on the lock screen

REG load HKLM\defuser %USERPROFILES%\default\ntuser.dat >NUL 2>&1

REG add "HKLM\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /V RotatingLockScreenOverlayEnabled /T REG_DWORD /D 00000000 /F >NUL 2>&1

REG unload HKLM\defuser >NUL 2>&1



:: Disable "Occasionally show suggestions in Start"...sigh

REG ADD HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f



echo.

echo -------------------------------------------------------------------------

echo Following commands have an unknown origin, so credit cannon be provided. 

echo -------------------------------------------------------------------------

timeout -t 6 > nul



rem *** Disable Some Service ***

sc stop DiagTrack

sc stop diagnosticshub.standardcollector.service

sc stop dmwappushservice

sc stop WMPNetworkSvc

sc stop WSearch



sc config DiagTrack start= disabled

sc config diagnosticshub.standardcollector.service start= disabled

sc config dmwappushservice start= disabled

sc config RemoteRegistry start= disabled

REM sc config TrkWks start= disabled

sc config WMPNetworkSvc start= disabled

sc config WSearch start= disabled

REM sc config SysMain start= disabled



REM *** SCHEDULED TASKS tweaks ***

REM schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable

schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable

schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable

schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /Disable

schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable

schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable

schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable

schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Uploader" /Disable

schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyUpload" /Disable

schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable

schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable

schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable



schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable

schtasks /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /Disable

REM schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable

REM schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable *** Not sure if should be disabled, maybe related to S.M.A.R.T.

schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable

schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable

REM schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable

REM schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable

REM The stubborn task Microsoft\Windows\SettingSync\BackgroundUploadTask can be Disabled using a simple bit change. I use a REG file for that (attached to this post).

schtasks /Change /TN "Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /Disable

REM schtasks /Change /TN "Microsoft\Windows\Time Synchronization\SynchronizeTime" /Disable

schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable

schtasks /Change /TN "Microsoft\Windows\WindowsUpdate\Automatic App Update" /Disable



rem *** Remove Telemetry & Data Collection ***

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontOfferThroughWUAU /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f

reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f



REM Settings -> Privacy -> General -> Let apps use my advertising ID...

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f

REM - SmartScreen Filter for Store Apps: Disable

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 0 /f

REM - Let websites provide locally...

reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f



REM WiFi Sense: HotSpot Sharing: Disable

reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d 0 /f

REM WiFi Sense: Shared HotSpot Auto-Connect: Disable

reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f



REM Change Windows Updates to "Notify to schedule restart"

reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v UxOption /t REG_DWORD /d 1 /f

REM Disable P2P Update downlods outside of local network

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f





REM *** Hide the search box from taskbar. You can still search by pressing the Win key and start typing what you're looking for ***

REM 0 = hide completely, 1 = show only icon, 2 = show long search box

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 1 /f



REM *** Disable MRU lists (jump lists) of XAML apps in Start Menu ***

reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f



REM *** Set Windows Explorer to start on This PC instead of Quick Access ***

REM 1 = This PC, 2 = Quick access

reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f



rem NOW JUST SOME TWEAKS

REM *** Show hidden files in Explorer ***

REM reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f

 

REM *** Show super hidden system files in Explorer ***

REM reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f



REM *** Show file extensions in Explorer ***

reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t  REG_DWORD /d 0 /f



REM *** Uninstall OneDrive ***

echo Do you want to uninstall OneDrive?
echo.

setlocal

SET AREYOUSURE=N

SET /P AREYOUSURE=Are you sure (Y/[N])?

IF /I "%AREYOUSURE%" NEQ "Y" GOTO NOONEDRIVEA

rd C:\OneDriveTemp /Q /S >NUL 2>&1

rd "%USERPROFILE%\OneDrive" /Q /S >NUL 2>&1

rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S >NUL 2>&1

rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S >NUL 2>&1

reg add "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /f /v Attributes /t REG_DWORD /d 0 >NUL 2>&1

reg add "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /f /v Attributes /t REG_DWORD /d 0 >NUL 2>&1

start /wait TASKKILL /F /IM explorer.exe

start explorer.exe

:NOONEDRIVEA

echo.

echo -------------------------------------------------------------------------

echo Following commands are from W4RH4WK's Debloat-Windows-10 repository

echo -------------------------------------------------------------------------

timeout -t 6 > nul



REM https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/optimize-user-interface.ps1

echo Disable Game DVR and Game Bar

powershell -command Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" "AllowgameDVR" 0



echo Disable easy access keyboard stuff

powershell -command Set-ItemProperty "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" "506"

powershell -command Set-ItemProperty "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "122"

powershell -command Set-ItemProperty "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" "58"



echo Disable Aero-Shake Minimize feature (Do people use this??)

powershell -command Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisallowShaking" 1



REM https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/optimize-windows-update.ps1

echo Disable automatic download and installation of Windows updates

powershell -command Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "NoAutoUpdate" 0

powershell -command Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "AUOptions" 2

powershell -command Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "ScheduledInstallDay" 0

powershell -command Set-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\WindowsUpdate\AU" "ScheduledInstallTime" 3

powershell -command Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" "DODownloadMode" 0



echo.

echo -------------------------------------------------------------------------

echo Following commands are from IAreKyleW00t's windows-tweaks repository

echo -------------------------------------------------------------------------

timeout -t 6 > nul



REM https://github.com/IAreKyleW00t/windows-tweaks/blob/master/windows10/privacy-patcher.bat

:: The following section will update Windows firewall to block multiple IP's that

:: are known to harvest/request user data from within Windows 10. These IP's belong

:: to Akamai, United States Superior Edgar Rental Corp., and Microsoft itself.

:: This will block any requests from these IP's on any protocol.

:STEP_2

ECHO.

<NUL SET /P o="[2] Updating Windows Firewall... "

netsh advfirewall firewall add rule name="Block Microsoft IP (Akamai)" dir=out protocol=any remoteip="2.22.61.43" profile=any action=block >NUL 2>&1

netsh advfirewall firewall add rule name="Block Microsoft IP (Akamai)" dir=out protocol=any remoteip="2.22.61.66" profile=any action=block >NUL 2>&1

netsh advfirewall firewall add rule name="Block Microsoft IP (Akamai)" dir=out protocol=any remoteip="23.218.212.69" profile=any action=block >NUL 2>&1

netsh advfirewall firewall add rule name="Block Microsoft IP (SEC)" dir=out protocol=any remoteip="65.39.117.230" profile=any action=block >NUL 2>&1

netsh advfirewall firewall add rule name="Block Microsoft IP" dir=out protocol=any remoteip="65.55.108.23" profile=any action=block >NUL 2>&1

netsh advfirewall firewall add rule name="Block Microsoft IP" dir=out protocol=any remoteip="134.170.30.202" profile=any action=block >NUL 2>&1

netsh advfirewall firewall add rule name="Block Microsoft IP" dir=out protocol=any remoteip="137.116.81.24" profile=any action=block >NUL 2>&1

netsh advfirewall firewall add rule name="Block Microsoft IP" dir=out protocol=any remoteip="157.56.106.189" profile=any action=block >NUL 2>&1

netsh advfirewall firewall add rule name="Block Microsoft IP" dir=out protocol=any remoteip="204.79.197.200" profile=any action=block >NUL 2>&1

ECHO DONE!



:: The following section will diable Telemetry within Windows via the registry.

:: Even if this wasn't disabled, blocking the hostnames and IP's would prevent any

:: information from being sent.

:STEP_3

ECHO.

<NUL SET /P o="[3] Disabling Telemetry... "

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0 >NUL 2>&1

reg add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection" /f /v "AllowTelemetry" /t REG_DWORD /d 0 >NUL 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /f /v "Start" /t REG_DWORD /d 4 >NUL 2>&1

reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /f /v "Start" /t REG_DWORD /d 4 >NUL 2>&1

ECHO DONE!



:: The following section will disable any services that are soley for collecting data.

:: To be safe, we disable instead of deleting them.

:STEP_4

ECHO.

<NUL SET /P o="[4] Disabling Data Collecting Services... "

net stop DiagTrack >NUL 2>&1

net stop dmwappushservice >NUL 2>&1

net stop Wecsvc >NUL 2>&1

sc config dmwappushservice start= disabled >NUL 2>&1

sc config diagtrack start= disabled >NUL 2>&1

sc config Wecsvc start= disabled >NUL 2>&1

ECHO DONE!



:: The following section will block the SYSTEM from modifying the DiagTrack Log

:: file and then clears the file entirely.

:STEP_5

ECHO.

<NUL SET /P o="[5] Disabling and Clearing DiagTrack Log... "

takeown /f %PROGRAMDATA%\Microsoft\Diagnosis\ETLLogs\Autologger\Autologger-Diagtrack-Listener.etl >NUL 2>&1

icacls %PROGRAMDATA%\Microsoft\Diagnosis\ETLLogs\Autologger\Autologger-Diagtrack-Listener.etl /grant administrators:F >NUL 2>&1

ECHO Y|cacls %PROGRAMDATA%\Microsoft\Diagnosis\ETLLogs\Autologger\Autologger-Diagtrack-Listener.etl /d SYSTEM >NUL 2>&1

BREAK>%PROGRAMDATA%\Microsoft\Diagnosis\ETLLogs\Autologger\Autologger-Diagtrack-Listener.etl

ECHO DONE!



:: The following section will apply "safe" optimizations to the Windows services.

:: These are known to be safe for all users and should not cause issues.

:SAFE

ECHO.

ECHO Now applying SAFE service optimizations -- This shouldn't take long...

ECHO    ^> AxInstSV set to DEMAND & sc config AxInstSV start=demand >NUL 2>&1

ECHO    ^> AJRouter set to DEMAND & sc config AJRouter start=demand >NUL 2>&1

ECHO    ^> AppReadiness set to DEMAND & sc config AppReadiness start=demand >NUL 2>&1

ECHO    ^> AppHostSvc set to DISABLED & sc config AppHostSvc start=disabled >NUL 2>&1

ECHO    ^> AppIDSvc set to DEMAND & sc config AppIDSvc start=demand >NUL 2>&1

ECHO    ^> Appinfo set to DEMAND & sc config Appinfo start=demand >NUL 2>&1

ECHO    ^> ALG set to DEMAND & sc config ALG start=demand >NUL 2>&1

ECHO    ^> AppMgmt set to DEMAND & sc config AppMgmt start=demand >NUL 2>&1

ECHO    ^> AppXSVC set to DEMAND & sc config AppXSVC start=demand >NUL 2>&1

ECHO    ^> aspnet_state set to DISABLED & sc config aspnet_state start=disabled >NUL 2>&1

ECHO    ^> BITS set to DELAYED-AUTO & sc config BITS start=delayed-auto >NUL 2>&1

ECHO    ^> BrokerInfrastructure set to AUTO & sc config BrokerInfrastructure start=auto >NUL 2>&1

ECHO    ^> BFE set to AUTO & sc config BFE start=auto >NUL 2>&1

ECHO    ^> BDESVC set to DEMAND & sc config BDESVC start=demand >NUL 2>&1

ECHO    ^> wbengine set to DEMAND & sc config wbengine start=demand >NUL 2>&1

ECHO    ^> BthHFSrv set to DEMAND & sc config BthHFSrv start=demand >NUL 2>&1

ECHO    ^> bthserv set to DEMAND & sc config bthserv start=demand >NUL 2>&1

ECHO    ^> PeerDistSvc set to DISABLED & sc config PeerDistSvc start=disabled >NUL 2>&1

ECHO    ^> CDPSvc set to DEMAND & sc config CDPSvc start=demand >NUL 2>&1

ECHO    ^> CertPropSvc set to DEMAND & sc config CertPropSvc start=demand >NUL 2>&1

ECHO    ^> c2wts set to DEMAND & sc config c2wts start=demand >NUL 2>&1

ECHO    ^> NfsClnt set to DISABLED & sc config NfsClnt start=disabled >NUL 2>&1

ECHO    ^> ClipSVC set to DEMAND & sc config ClipSVC start=demand >NUL 2>&1

ECHO    ^> KeyIso set to DEMAND & sc config KeyIso start=demand >NUL 2>&1

ECHO    ^> EventSystem set to AUTO & sc config EventSystem start=auto >NUL 2>&1

ECHO    ^> COMSysApp set to DEMAND & sc config COMSysApp start=demand >NUL 2>&1

ECHO    ^> Browser set to DEMAND & sc config Browser start=demand >NUL 2>&1

ECHO    ^> CoreUIRegistrar set to AUTO & sc config CoreUIRegistrar start=auto >NUL 2>&1

ECHO    ^> VaultSvc set to DEMAND & sc config VaultSvc start=demand >NUL 2>&1

ECHO    ^> CryptSvc set to AUTO & sc config CryptSvc start=auto >NUL 2>&1

ECHO    ^> DsSvc set to DEMAND & sc config DsSvc start=demand >NUL 2>&1

ECHO    ^> DcpSvc set to DEMAND & sc config DcpSvc start=demand >NUL 2>&1

ECHO    ^> DcomLaunch set to AUTO & sc config DcomLaunch start=auto >NUL 2>&1

ECHO    ^> DoSvc set to DELAYED-AUTO & sc config DoSvc start=delayed-auto >NUL 2>&1

ECHO    ^> DeviceAssociationService set to DEMAND & sc config DeviceAssociationService start=demand >NUL 2>&1

ECHO    ^> DeviceInstall set to DEMAND & sc config DeviceInstall start=demand >NUL 2>&1

ECHO    ^> DmEnrollmentSvc set to DEMAND & sc config DmEnrollmentSvc start=demand >NUL 2>&1

ECHO    ^> DsmSVC set to DEMAND & sc config DsmSVC start=demand >NUL 2>&1

ECHO    ^> DevQueryBroker set to DEMAND & sc config DevQueryBroker start=demand >NUL 2>&1

ECHO    ^> Dhcp set to AUTO & sc config Dhcp start=auto >NUL 2>&1

ECHO    ^> DPS set to AUTO & sc config DPS start=auto >NUL 2>&1

ECHO    ^> WdiServiceHost set to DEMAND & sc config WdiServiceHost start=demand >NUL 2>&1

ECHO    ^> WdiSystemHost set to DEMAND & sc config WdiSystemHost start=demand >NUL 2>&1

ECHO    ^> DiagTrack set to AUTO & sc config DiagTrack start=auto >NUL 2>&1

ECHO    ^> TrkWks set to AUTO & sc config TrkWks start=auto >NUL 2>&1

ECHO    ^> MSDTC set to DEMAND & sc config MSDTC start=demand >NUL 2>&1

ECHO    ^> dmwappushsvc set to DISABLED & sc config dmwappushsvc start=disabled >NUL 2>&1

ECHO    ^> Dnscache set to AUTO & sc config Dnscache start=auto >NUL 2>&1

ECHO    ^> MapsBroker set to DELAYED-AUTO & sc config MapsBroker start=delayed-auto >NUL 2>&1

ECHO    ^> DsRoleSvc set to DISABLED & sc config DsRoleSvc start=disabled >NUL 2>&1

ECHO    ^> embeddedmode set to DEMAND & sc config embeddedmode start=demand >NUL 2>&1

ECHO    ^> EFS set to DEMAND & sc config EFS start=demand >NUL 2>&1

ECHO    ^> EntAppSvc set to DISABLED & sc config EntAppSvc start=disabled >NUL 2>&1

ECHO    ^> EapHost set to DEMAND & sc config EapHost start=demand >NUL 2>&1

ECHO    ^> Fax set to DISABLED & sc config Fax start=disabled >NUL 2>&1

ECHO    ^> fhsvc set to DEMAND & sc config fhsvc start=demand >NUL 2>&1

ECHO    ^> fdPHost set to DEMAND & sc config fdPHost start=demand >NUL 2>&1

ECHO    ^> FDResPub set to DEMAND & sc config FDResPub start=demand >NUL 2>&1

ECHO    ^> fsvc set to DISABLED & sc config fsvc start=disabled >NUL 2>&1

ECHO    ^> gpsvc set to AUTO & sc config gpsvc start=auto >NUL 2>&1

ECHO    ^> hkmsvc set to DEMAND & sc config hkmsvc start=demand >NUL 2>&1

ECHO    ^> HomeGroupListener set to DEMAND & sc config HomeGroupListener start=demand >NUL 2>&1

ECHO    ^> HomeGroupProvider set to DEMAND & sc config HomeGroupProvider start=demand >NUL 2>&1

ECHO    ^> hidserv set to DEMAND & sc config hidserv start=demand >NUL 2>&1

ECHO    ^> vmickvpexchange set to DISABLED & sc config vmickvpexchange start=disabled >NUL 2>&1

ECHO    ^> vmicguestinterface set to DISABLED & sc config vmicguestinterface start=disabled >NUL 2>&1

ECHO    ^> vmicshutdown set to DISABLED & sc config vmicshutdown start=disabled >NUL 2>&1

ECHO    ^> vmicheartbeat set to DISABLED & sc config vmicheartbeat start=disabled >NUL 2>&1

ECHO    ^> vmicrdv set to DISABLED & sc config vmicrdv start=disabled >NUL 2>&1

ECHO    ^> vmictimesync set to DISABLED & sc config vmictimesync start=disabled >NUL 2>&1

ECHO    ^> vmicvmsession set to DISABLED & sc config vmicvmsession start=disabled >NUL 2>&1

ECHO    ^> vmicvss set to DISABLED & sc config vmicvss start=disabled >NUL 2>&1

ECHO    ^> IISADMIN set to DISABLED & sc config IISADMIN start=disabled >NUL 2>&1

ECHO    ^> IKEEXT set to DEMAND & sc config IKEEXT start=demand >NUL 2>&1

ECHO    ^> cphs set to DEMAND & sc config cphs start=demand >NUL 2>&1

ECHO    ^> UI0Detect set to DEMAND & sc config UI0Detect start=demand >NUL 2>&1

ECHO    ^> SharedAccess set to DISABLED & sc config SharedAccess start=disabled >NUL 2>&1

ECHO    ^> IEEtwCollectorService set to DEMAND & sc config IEEtwCollectorService start=demand >NUL 2>&1

ECHO    ^> iphlpsvc set to AUTO & sc config iphlpsvc start=auto >NUL 2>&1

ECHO    ^> PolicyAgent set to DEMAND & sc config PolicyAgent start=demand >NUL 2>&1

ECHO    ^> KtmRm set to DEMAND & sc config KtmRm start=demand >NUL 2>&1

ECHO    ^> lltdsvc set to DEMAND & sc config lltdsvc start=demand >NUL 2>&1

ECHO    ^> LSM set to AUTO & sc config LSM start=auto >NUL 2>&1

ECHO    ^> LPDSVC set to DISABLED & sc config LPDSVC start=disabled >NUL 2>&1

ECHO    ^> MSMQ set to DISABLED & sc config MSMQ start=disabled >NUL 2>&1

ECHO    ^> MSMQTriggers set to DISABLED & sc config MSMQTriggers start=disabled >NUL 2>&1

ECHO    ^> diagnosticshub.standardcollector.service set to DEMAND & sc config diagnosticshub.standardcollector.service start=demand >NUL 2>&1

ECHO    ^> wlidsvc set to DEMAND & sc config wlidsvc start=demand >NUL 2>&1

ECHO    ^> ftpsvc set to DISABLED & sc config ftpsvc start=disabled >NUL 2>&1

ECHO    ^> MSiSCSI set to DISABLED & sc config MSiSCSI start=disabled >NUL 2>&1

ECHO    ^> NgcSvc set to DEMAND & sc config NgcSvc start=demand >NUL 2>&1

ECHO    ^> NgcCtnrSvc set to DEMAND & sc config NgcCtnrSvc start=demand >NUL 2>&1

ECHO    ^> swprv set to DEMAND & sc config swprv start=demand >NUL 2>&1

ECHO    ^> smphost set to DEMAND & sc config smphost start=demand >NUL 2>&1

ECHO    ^> SmsRouter set to DISABLED & sc config SmsRouter start=disabled >NUL 2>&1

ECHO    ^> NetMsmqActivator set to DISABLED & sc config NetMsmqActivator start=disabled >NUL 2>&1

ECHO    ^> NetPipeActivator set to DISABLED & sc config NetPipeActivator start=disabled >NUL 2>&1

ECHO    ^> NetTcpActivator set to DISABLED & sc config NetTcpActivator start=disabled >NUL 2>&1

ECHO    ^> NetTcpPortSharing set to DISABLED & sc config NetTcpPortSharing start=disabled >NUL 2>&1

ECHO    ^> Netlogon set to DEMAND & sc config Netlogon start=demand >NUL 2>&1

ECHO    ^> NcdAutoSetup set to DEMAND & sc config NcdAutoSetup start=demand >NUL 2>&1

ECHO    ^> NcbService set to DEMAND & sc config NcbService start=demand >NUL 2>&1

ECHO    ^> Netman set to DEMAND & sc config Netman start=demand >NUL 2>&1

ECHO    ^> NcaSVC set to DEMAND & sc config NcaSVC start=demand >NUL 2>&1

ECHO    ^> netprofm set to DEMAND & sc config netprofm start=demand >NUL 2>&1

ECHO    ^> NlaSvc set to AUTO & sc config NlaSvc start=auto >NUL 2>&1

ECHO    ^> NetSetupSvc set to DEMAND & sc config NetSetupSvc start=demand >NUL 2>&1

ECHO    ^> nsi set to AUTO & sc config nsi start=auto >NUL 2>&1

ECHO    ^> CscService set to DEMAND & sc config CscService start=demand >NUL 2>&1

ECHO    ^> defragsvc set to DEMAND & sc config defragsvc start=demand >NUL 2>&1

ECHO    ^> PNRPsvc set to DEMAND & sc config PNRPsvc start=demand >NUL 2>&1

ECHO    ^> p2psvc set to DEMAND & sc config p2psvc start=demand >NUL 2>&1

ECHO    ^> p2pimsvc set to DEMAND & sc config p2pimsvc start=demand >NUL 2>&1

ECHO    ^> pla set to DEMAND & sc config pla start=demand >NUL 2>&1

ECHO    ^> PlugPlay set to DEMAND & sc config PlugPlay start=demand >NUL 2>&1

ECHO    ^> PNRPAutoReg set to DEMAND & sc config PNRPAutoReg start=demand >NUL 2>&1

ECHO    ^> WPDBusEnum set to DEMAND & sc config WPDBusEnum start=demand >NUL 2>&1

ECHO    ^> Power set to AUTO & sc config Power start=auto >NUL 2>&1

ECHO    ^> Spooler set to AUTO & sc config Spooler start=auto >NUL 2>&1

ECHO    ^> PrintNotify set to DEMAND & sc config PrintNotify start=demand >NUL 2>&1

ECHO    ^> wercplsupport set to DEMAND & sc config wercplsupport start=demand >NUL 2>&1

ECHO    ^> PcaSvc set to DEMAND & sc config PcaSvc start=demand >NUL 2>&1

ECHO    ^> QWAVE set to DEMAND & sc config QWAVE start=demand >NUL 2>&1

ECHO    ^> RasAuto set to DEMAND & sc config RasAuto start=demand >NUL 2>&1

ECHO    ^> RasMan set to DEMAND & sc config RasMan start=demand >NUL 2>&1

ECHO    ^> SessionEnv set to DEMAND & sc config SessionEnv start=demand >NUL 2>&1

ECHO    ^> TermService set to DEMAND & sc config TermService start=demand >NUL 2>&1

ECHO    ^> UmRdpService set to DEMAND & sc config UmRdpService start=demand >NUL 2>&1

ECHO    ^> RpcSs set to AUTO & sc config RpcSs start=auto >NUL 2>&1

ECHO    ^> RpcLocator set to DISABLED & sc config RpcLocator start=disabled >NUL 2>&1

ECHO    ^> RemoteRegistry set to DISABLED & sc config RemoteRegistry start=disabled >NUL 2>&1

ECHO    ^> RetailDemo set to DISABLED & sc config RetailDemo start=disabled >NUL 2>&1

ECHO    ^> iprip set to DISABLED & sc config iprip start=disabled >NUL 2>&1

ECHO    ^> RemoteAccess set to DISABLED & sc config RemoteAccess start=disabled >NUL 2>&1

ECHO    ^> RpcEptMapper set to AUTO & sc config RpcEptMapper start=auto >NUL 2>&1

ECHO    ^> seclogon set to DEMAND & sc config seclogon start=demand >NUL 2>&1

ECHO    ^> SstpSvc set to DEMAND & sc config SstpSvc start=demand >NUL 2>&1

ECHO    ^> SamSs set to AUTO & sc config SamSs start=auto >NUL 2>&1

ECHO    ^> wscsvc set to DELAYED-AUTO & sc config wscsvc start=delayed-auto >NUL 2>&1

ECHO    ^> SensorDataService set to DISABLED & sc config SensorDataService start=disabled >NUL 2>&1

ECHO    ^> SensrSvc set to DISABLED & sc config SensrSvc start=disabled >NUL 2>&1

ECHO    ^> SensorService set to DISABLED & sc config SensorService start=disabled >NUL 2>&1

ECHO    ^> LanmanServer set to AUTO & sc config LanmanServer start=auto >NUL 2>&1

ECHO    ^> ShellHWDetection set to AUTO & sc config ShellHWDetection start=auto >NUL 2>&1

ECHO    ^> simptcp set to DISABLED & sc config simptcp start=disabled >NUL 2>&1

ECHO    ^> SCardSvr set to DISABLED & sc config SCardSvr start=disabled >NUL 2>&1

ECHO    ^> ScDeviceEnum set to DISABLED & sc config ScDeviceEnum start=disabled >NUL 2>&1

ECHO    ^> SCPolicySvc set to DISABLED & sc config SCPolicySvc start=disabled >NUL 2>&1

ECHO    ^> SNMP set to DISABLED & sc config SNMP start=disabled >NUL 2>&1

ECHO    ^> SNMPTRAP set to DISABLED & sc config SNMPTRAP start=disabled >NUL 2>&1

ECHO    ^> sppsvc set to DELAYED-AUTO & sc config sppsvc start=delayed-auto >NUL 2>&1

ECHO    ^> svsvc set to DEMAND & sc config svsvc start=demand >NUL 2>&1

ECHO    ^> SSDPSRV set to DEMAND & sc config SSDPSRV start=demand >NUL 2>&1

ECHO    ^> StateRepository set to DEMAND & sc config StateRepository start=demand >NUL 2>&1

ECHO    ^> WiaRpc set to DEMAND & sc config WiaRpc start=demand >NUL 2>&1

ECHO    ^> StorSvc set to DEMAND & sc config StorSvc start=demand >NUL 2>&1

ECHO    ^> SysMain set to AUTO & sc config SysMain start=auto >NUL 2>&1

ECHO    ^> SENS set to AUTO & sc config SENS start=auto >NUL 2>&1

ECHO    ^> SystemEventsBroker set to AUTO & sc config SystemEventsBroker start=auto >NUL 2>&1

ECHO    ^> Schedule set to AUTO & sc config Schedule start=auto >NUL 2>&1

ECHO    ^> lmhosts set to DEMAND & sc config lmhosts start=demand >NUL 2>&1

ECHO    ^> TapiSrv set to DEMAND & sc config TapiSrv start=demand >NUL 2>&1

ECHO    ^> Themes set to AUTO & sc config Themes start=auto >NUL 2>&1

ECHO    ^> tiledatamodelsvc set to AUTO & sc config tiledatamodelsvc start=auto >NUL 2>&1

ECHO    ^> TimeBroker set to DEMAND & sc config TimeBroker start=demand >NUL 2>&1

ECHO    ^> TabletInputService set to DEMAND & sc config TabletInputService start=demand >NUL 2>&1

ECHO    ^> UsoSvc set to DEMAND & sc config UsoSvc start=demand >NUL 2>&1

ECHO    ^> upnphost set to DEMAND & sc config upnphost start=demand >NUL 2>&1

ECHO    ^> UserManager set to AUTO & sc config UserManager start=auto >NUL 2>&1

ECHO    ^> ProfSvc set to AUTO & sc config ProfSvc start=auto >NUL 2>&1

ECHO    ^> vds set to DEMAND & sc config vds start=demand >NUL 2>&1

ECHO    ^> VSS set to DEMAND & sc config VSS start=demand >NUL 2>&1

ECHO    ^> W3LOGSVC set to DISABLED & sc config W3LOGSVC start=disabled >NUL 2>&1

ECHO    ^> WalletService set to DEMAND & sc config WalletService start=demand >NUL 2>&1

ECHO    ^> WMSVC set to DISABLED & sc config WMSVC start=disabled >NUL 2>&1

ECHO    ^> WebClient set to DEMAND & sc config WebClient start=demand >NUL 2>&1

ECHO    ^> AudioSrv set to AUTO & sc config AudioSrv start=auto >NUL 2>&1

ECHO    ^> AudioEndpointBuilder set to AUTO & sc config AudioEndpointBuilder start=auto >NUL 2>&1

ECHO    ^> SDRSVC set to DEMAND & sc config SDRSVC start=demand >NUL 2>&1

ECHO    ^> WbioSrvc set to DEMAND & sc config WbioSrvc start=demand >NUL 2>&1

ECHO    ^> WcsPlugInService set to DEMAND & sc config WcsPlugInService start=demand >NUL 2>&1

ECHO    ^> wcncsvc set to DEMAND & sc config wcncsvc start=demand >NUL 2>&1

ECHO    ^> Wcmsvc set to AUTO & sc config Wcmsvc start=auto >NUL 2>&1

ECHO    ^> WdNisSvc set to DEMAND & sc config WdNisSvc start=demand >NUL 2>&1

ECHO    ^> WinDefend set to AUTO & sc config WinDefend start=auto >NUL 2>&1

ECHO    ^> wudfsvc set to DEMAND & sc config wudfsvc start=demand >NUL 2>&1

ECHO    ^> WEPHOSTSVC set to DEMAND & sc config WEPHOSTSVC start=demand >NUL 2>&1

ECHO    ^> WerSvc set to DEMAND & sc config WerSvc start=demand >NUL 2>&1

ECHO    ^> Wecsvc set to DEMAND & sc config Wecsvc start=demand >NUL 2>&1

ECHO    ^> EventLog set to AUTO & sc config EventLog start=auto >NUL 2>&1

ECHO    ^> MpsSvc set to AUTO & sc config MpsSvc start=auto >NUL 2>&1

ECHO    ^> FontCache set to AUTO & sc config FontCache start=auto >NUL 2>&1

ECHO    ^> StiSvc set to DEMAND & sc config StiSvc start=demand >NUL 2>&1

ECHO    ^> msiserver set to DEMAND & sc config msiserver start=demand >NUL 2>&1

ECHO    ^> LicenseManager set to DEMAND & sc config LicenseManager start=demand >NUL 2>&1

ECHO    ^> Winmgmt set to AUTO & sc config Winmgmt start=auto >NUL 2>&1

ECHO    ^> WMPNetworkSvc set to DISABLED & sc config WMPNetworkSvc start=disabled >NUL 2>&1

ECHO    ^> icssvc set to DISABLED & sc config icssvc start=disabled >NUL 2>&1

ECHO    ^> TrustedInstaller set to DEMAND & sc config TrustedInstaller start=demand >NUL 2>&1

ECHO    ^> Wms set to AUTO & sc config Wms start=auto >NUL 2>&1

ECHO    ^> WmsRepair set to AUTO & sc config WmsRepair start=auto >NUL 2>&1

ECHO    ^> FontCache3.0.0.0 set to DISABLED & sc config FontCache3.0.0.0 start=disabled >NUL 2>&1

ECHO    ^> WAS set to DISABLED & sc config WAS start=disabled >NUL 2>&1

ECHO    ^> WpnService set to DEMAND & sc config WpnService start=demand >NUL 2>&1

ECHO    ^> WinRM set to DISABLED & sc config WinRM start=disabled >NUL 2>&1

ECHO    ^> WSearch set to DELAYED-AUTO & sc config WSearch start=delayed-auto >NUL 2>&1

ECHO    ^> WSService set to DEMAND & sc config WSService start=demand >NUL 2>&1

ECHO    ^> W32Time set to DEMAND & sc config W32Time start=demand >NUL 2>&1

ECHO    ^> wuauserv set to DEMAND & sc config wuauserv start=demand >NUL 2>&1

ECHO    ^> WinHttpAutoProxySvc set to DEMAND & sc config WinHttpAutoProxySvc start=demand >NUL 2>&1

ECHO    ^> dot3svc set to DEMAND & sc config dot3svc start=demand >NUL 2>&1

ECHO    ^> WlanSvc set to DEMAND & sc config WlanSvc start=demand >NUL 2>&1

ECHO    ^> wmiApSrv set to DEMAND & sc config wmiApSrv start=demand >NUL 2>&1

ECHO    ^> workfolderssvc set to DISABLED & sc config workfolderssvc start=disabled >NUL 2>&1

ECHO    ^> LanmanWorkstation set to AUTO & sc config LanmanWorkstation start=auto >NUL 2>&1

ECHO    ^> W3SVC set to DISABLED & sc config W3SVC start=disabled >NUL 2>&1

ECHO    ^> XblAuthManager set to DEMAND & sc config XblAuthManager start=DEMAND >NUL 2>&1

ECHO    ^> XblGameSave set to DEMAND & sc config XblGameSave start=DEMAND >NUL 2>&1

ECHO    ^> XboxNetApiSvc set to DEMAND & sc config XboxNetApiSvc start=DEMAND >NUL 2>&1



echo.

echo -------------------------------------------------------------------------

echo Following commands are from DrEmpiricism's Optimize-Offline repository

echo -------------------------------------------------------------------------

timeout -t 6 > nul



powershell -command Remove-ItemProperty -LiteralPath "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth" -Force -ErrorAction SilentlyContinue



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpyNetReporting /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableBehaviorMonitoring /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableOnAccessProtection /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableScanOnRealtimeEnable /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager" /v AllowBehaviorMonitoring /t REG_DWORD /d 2 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager" /v AllowCloudProtection /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager" /v AllowRealtimeMonitoring /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Policy Manager" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v Notification_Suppress /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontOfferThroughWUAU /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontReportInfectionInformation /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v HideSystray /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Microsoft\Windows Security Health\State" /v AccountProtection_MicrosoftAccount_Disconnected /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v SmartScreenEnabled /t REG_MULTI_SZ /d "Off" /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_MULTI_SZ /d "Off" /f

reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_MULTI_SZ /d "Off" /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AudioCaptureEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v CursorCaptureEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v AllowPrelaunch /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v PreventTabPreloading /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v DoNotTrack /t REG_DWORD /d 1 /f

	

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CanCortanaBeEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v CortanaInAmbientMode /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v HistoryViewEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v DeviceHistoryEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v HasAboveLockTips /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v VoiceActivationEnableAboveLockscreen /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v DisableVoice /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableTailoredExperiencesWithDiagnosticData /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisableInventory /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v CEIPEnable /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" /v value /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackDocs /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableThirdPartySuggestions /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v NoToastApplicationNotification /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v NoToastApplicationNotificationOnLockScreen /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v AllowWindowsInkWorkspace /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v AllowSuggestedAppsInWindowsInkWorkspace /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Microsoft\Windows\CurrentVersion\PushNotifications" /v NoCloudApplicationNotification /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v TurnOffSets /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v DisableAutoplay /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v SaveZoneInformation /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f



reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f



reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v EnableFeaturedSoftware /t REG_DWORD /d 0 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUPowerManagement /t REG_DWORD /d 0 /f



echo.

echo Ensuring memory compression is enabled (330MB at idle repoted! Thanks hojnikb)

powershell -command Enable-MMAgent -MemoryCompression

echo.
Title Thank you for using Windows10Optimizer!
echo -------------------------------------------------------------------------------------------------

echo Windows 10 has now been optimized and sped up, you've also freed up a bunch of space, yay!

echo -------------------------------------------------------------------------------------------------

:NOOPTIMIZE

echo Press any key to exit

pause >nul