Write-host -fore red "A lancer en Utilisateur a la racine de la collecte (où devrons se mettre les raccourcis)"

Write-host -fore red "Definir la toolbox"
#Avoir défini $tool avant (pour TimeLineExplorer et RegistryExplorer
	$tools="D:\W\EZgui\Get-ZimmermanTools\net9"


Sleep


	
	$Shell = New-Object -ComObject Wscript.Shell
	$Shortcut = $Shell.CreateShortcut("$PWD\__Rac_C.lnk")
	$Shortcut.TargetPath = (Resolve-Path "./uploads/auto/C%3A/").providerpath
	$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 266"
	$Shortcut.Save()
	
	$Shortcut = $Shell.CreateShortcut("$PWD\__Rac_Tasks.lnk")
	$Shortcut.TargetPath = (Resolve-Path "./uploads/auto/C%3A/Windows/Tasks").providerpath
	$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 266"
	$Shortcut.Save()
	
	$Shortcut = $Shell.CreateShortcut("$PWD\__Rac_Users.lnk")
	$Shortcut.TargetPath = (Resolve-Path "./uploads/auto/C%3A/Users").providerpath
	$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 266"
	$Shortcut.Save()
	
	$Shortcut = $Shell.CreateShortcut("$PWD\__Rac_evtx.lnk")
	$Shortcut.TargetPath = (Resolve-Path "./uploads/auto/C%3A/Windows/System32/winevt/Logs").providerpath
	$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 266"
	$Shortcut.Save()
	
	$Shortcut = $Shell.CreateShortcut("$PWD\__Rac_Bdr.lnk")
	$Shortcut.TargetPath = (Resolve-Path "./uploads/auto/C%3A/Windows/System32/config").providerpath
	$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 266"
	$Shortcut.Save()
	
	$Shortcut = $Shell.CreateShortcut("$PWD\__Tool_RegistryExpl.lnk")
	$Shortcut.TargetPath = (Resolve-Path $tools"\RegistryExplorer\RegistryExplorer.exe").providerpath
	$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 265"
	$Shortcut.Save()
	
	$Shortcut = $Shell.CreateShortcut("$PWD\__Tool_TimeLineExpl.lnk")
	$Shortcut.TargetPath = (Resolve-Path $tools"\TimelineExplorer\TimelineExplorer.exe").providerpath
	$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 265"
	$Shortcut.Save()
	
	$Shortcut = $Shell.CreateShortcut("$PWD\__Tool_Nirsoft_BrowsingHistoryView.lnk")
	$Shortcut.TargetPath = (Resolve-Path $tools"\..\..\..\browsinghistoryview-x64\BrowsingHistoryView.exe").providerpath
	$Shortcut.IconLocation = "%SystemRoot%\System32\SHELL32.dll, 265"
	$Shortcut.Save()

sleep