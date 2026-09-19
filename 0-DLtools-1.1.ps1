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
		}
	# Working...
	write-host "WORKING..."
	sleep
	}






