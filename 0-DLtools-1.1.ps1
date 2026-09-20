param (
    [Parameter(Mandatory=$true)]
    [string]$FolderToAnalyze
)

Write-host "Welcome to : MyEzGui"
Write-host "===================="

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin)
	{
	Write-Host "Droits d'administrateur non détectés. Relance du script avec élévation..." -ForegroundColor Yellow
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -FolderToAnalyze `"$FolderToAnalyze`"" -WorkingDirectory "$PSScriptRoot" -Verb RunAs
        Exit
	}
	else
	{
	# Test if Tools folder exist (Utilisation d'un chemin absolu avec $PSScriptRoot pour éviter System32)
	$toolpath = "$PSScriptRoot\tools"

	$Toolavailable = Test-Path -Path $toolpath -PathType Container

	if (!$Toolavailable)
		{
		write-host -fore red "Tools are unavailable : download and install it"
		write-host -fore red "==============================================="


		############################### Folder generation ##############################
		New-Item -path $toolpath -ItemType Directory
		cd $toolpath
		############################### Eric Zimmerman Tools ##############################
		#Download EZTools et DotNET9
		Invoke-WebRequest `
		  -Uri "https://download.ericzimmermanstools.com/Get-ZimmermanTools.zip" `
		  -OutFile "$PWD\Get-ZimmermanTools.zip" `
		  -UseBasicParsing
		Expand-Archive Get-ZimmermanTools.zip -DestinationPath EZTools
		cd EZTools
		Unblock-File -Path .\Get-ZimmermanTools.ps1
		.\Get-ZimmermanTools.ps1
		del ../Get-ZimmermanTools.zip
		$tools="$PWD\EZTools\net9"

		############################### DotNet ##############################
		cd $toolpath
		# Installation via Winget
		winget install Microsoft.DotNet.DesktopRuntime.9 --silent --accept-package-agreements --accept-source-agreements
		
		############################### HINDSIGHT ##############################
		#Download 
		cd $toolpath
		Invoke-WebRequest `
		  -Uri "https://github.com/obsidianforensics/hindsight/releases/download/v2026.01/hindsight.exe" `
		  -OutFile "$PWD\hindsight.exe" `
		  -UseBasicParsing
	  
		############################### DBBrowserForSQLITE ##############################
		cd $toolpath
		write-host -fore red Agree on the other window
		winget install -e --id DBBrowserForSQLite.DBBrowserForSQLite  --silent --accept-package-agreements --accept-source-agreements
	
		#Create ShortCut
		$Shell = New-Object -ComObject Wscript.Shell
		$Shortcut = $Shell.CreateShortcut("$PWD\DB Browser for SQLite.lnk")
		$Shortcut.TargetPath = (Resolve-Path "C:\Program Files\DB Browser for SQLite\DB Browser for SQLite.exe").providerpath
		$Shortcut.Save()
	
		############################### NIRSOFT ##############################
		cd $toolpath
		
		mkdir NIRSOFT
		CD NIRSOFT
		
		Invoke-WebRequest `
		  -Uri "https://www.nirsoft.net/utils/userassistview.zip" `
		  -OutFile "$PWD\userassistview.zip" `
		  -UseBasicParsing
		Expand-Archive userassistview.zip -DestinationPath userassistview
		del userassistview.zip
	
		Invoke-WebRequest `
		  -Uri "https://www.nirsoft.net/utils/browsinghistoryview-x64.zip" `
		  -OutFile "$PWD\browsinghistoryview-x64.zip" `
		  -UseBasicParsing
		Expand-Archive browsinghistoryview-x64.zip -DestinationPath browsinghistoryview-x64
		del browsinghistoryview-x64.zip
	
		Invoke-WebRequest `
		  -Uri "https://www.nirsoft.net/utils/chromehistoryview.zip" `
		  -OutFile "$PWD\chromehistoryview.zip" `
		  -UseBasicParsing
		Expand-Archive chromehistoryview.zip -DestinationPath chromehistoryview
		del chromehistoryview.zip
	
	
		Invoke-WebRequest `
		  -Uri "https://www.nirsoft.net/utils/chromecacheview.zip" `
		  -OutFile "$PWD\chromecacheview.zip" `
		  -UseBasicParsing
		Expand-Archive chromecacheview.zip -DestinationPath chromecacheview
		del chromecacheview.zip

#TaskSchedulerView v1.74
#LastActivityView v1.37
#ShadowCopyView v1.16
#VaultPasswordView v1.12
#MadPassExt v1.00
#Remote Desktop PassView v1.02
#LSASecretsView v1.26
#LSASecretsDump v1.21
#WifiHistoryView v1.66
#NetworkOpenedFiles v1.63 ?
#ImageCacheViewer v1.34
#WebCacheImageInfo v1.36
#BrowserAutoFillView v1.00
#WebBrowserBookmarksView v1.13
#BrowserDownloadsView v1.51
#BrowserAddonsView v1.30
#MyLastSearch v1.66
#FavoritesView v1.32

#RegFileExport v1.11

#AlternateStreamView v1.58

#USBDeview v3.10
#USBDriveLog v1.15

#WinDefLogView v1.05
#WinDefThreatsView v1.15

#OpenedFilesView v1.91
#FolderChangesView v2.37

#ShadowCopyView v1.16
#PreviousFilesRecovery v1.10
#LastActivityView v1.37
#OpenSaveFilesView v1.16
#ExecutedProgramsList v1.15

#TaskSchedulerView v1.74
#LoadedDllsView v1.06

#SecuritySoftView v1.00

#FolderTimeUpdate v1.75
#AppCompatibilityView v1.10
#JumpListsView v1.16

#BatteryHistoryView v1.06
#WhatInStartup v1.35

#WinPrefetchView v1.37
#AppCrashView v1.35

#TurnedOnTimesView v1.46
#WinLogOnView v1.41

#OfflineRegistryView v1.05
#OfflineRegistryFinder v1.12

#MUICacheView v1.01
#ShellBagsView v1.35
#UserAssistView v1.02
#FullEventLogView v1.81
#MyEventViewer v2.25
#EventLogSourcesView v1.00

#RecentFilesView v1.33
#InjectedDLL v1.00
#ServiWin v1.72

#ESEDatabaseView v1.79
#ExifDataView v1.15
#CSVFileView v2.66

#HashMyFiles v2.51

#https://download.nirsoft.net/nirsoft_package_enc_1.30.25.zip
# nirsoft9876$

#?winget install --id NirSoft.NirLauncher -e --source winget --accept-package-agreements --accept-source-agreements

		############################### GIT ##############################
		winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements --silent


		############################### SysInternals ##############################
		cd $toolpath
		mkdir SYSINTERNALS
		CD SYSINTERNALS
		Invoke-WebRequest `
		  -Uri "https://download.sysinternals.com/files/SysinternalsSuite.zip" `
		  -OutFile "$PWD\SysinternalsSuite.zip" `
		  -UseBasicParsing
		Expand-Archive SysinternalsSuite.zip -DestinationPath SysinternalsSuite
		del SysinternalsSuite.zip



		}
	# Working...
	write-host "WORKING..."
	sleep
	}






