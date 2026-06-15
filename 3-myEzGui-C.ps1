	cd .\uploads\auto\C%3A\
	$in = $PWD.Path
	$out = $in + "\..\..\..\out"
	mkdir  $out
	#Preparer les répertoires
	$tools="D:\W\EZgui\Get-ZimmermanTools\net9"

	#MFT
		$in2 = $in + "\..\..\ntfs\%5C%5C.%5CC%3A\`$MFT"
		start-process -filePath "$tools\MFTECmd.exe" -argumentlist @('-f',$in2,'--csv',$out,'--csvf', 'mft.csv') -NoNewWindow -Wait
		
		#USNJRNL (Besoin de la MFT)
		$in3 = $in + "\..\..\ntfs\%5C%5C.%5CC%3A\`$Extend\`$UsnJrnl%3A`$J"
		start-process -filePath "$tools\MFTECmd.exe" -ArgumentList @('-f', $IN3, '-m', $IN2,'--csv', $out,'--csvf', 'usnjrnl.csv')   -NoNewWindow -Wait
		
#EVTX Principaux
		$inevtx=$in+"\Windows\System32\winevt\Logs\System.evtx"
		start-process -filePath "$tools\EvtxeCmd\EvtxECmd.exe" -argumentlist @('-f',$inevtx,'--csv',$out,'--csvf', 'evtx_system.csv') -NoNewWindow -Wait
		
		
		$inevtx=$in+"\Windows\System32\winevt\Logs\Application.evtx"
		start-process -filePath "$tools\EvtxeCmd\EvtxECmd.exe" -argumentlist @('-f',$inevtx,'--csv',$out,'--csvf', 'evtx_application.csv') -NoNewWindow -Wait
		
		
		$inevtx=$in+"\Windows\System32\winevt\Logs\Security.evtx"
		start-process -filePath "$tools\EvtxeCmd\EvtxECmd.exe" -argumentlist @('-f',$inevtx,'--csv',$out,'--csvf', 'evtx_security.csv') -NoNewWindow -Wait
		
		$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-Windows Defender%254Operational.evtx"
		Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_defender(1116-1117-1119-5001).csv" -NoNewWindow -Wait
			
		
		$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-TerminalServices-RemoteConnectionManager%254Operational.evtx"
		Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_TSRemote(1149).csv" -NoNewWindow -Wait
		
		$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-TerminalServices-LocalSessionManager%254Operational.evtx"
		Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_TSlocal(21-24-25).csv" -NoNewWindow -Wait
		
		$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%254Operational.evtx"
		Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_RDpCoreTS(131-102-140).csv" -NoNewWindow -Wait
		
$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-TerminalServices-RDPClient%254Operational.evtx"
		Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_RDPClinet(1024-1025-1026-1029).csv" -NoNewWindow -Wait

		
		$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-PowerShell%254Operational.evtx"
		Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_PowerShell(4104).csv" -NoNewWindow -Wait
		
		$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-TaskScheduler%254Operational.evtx"
		Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_TaskSchedul(106-140-141).csv" -NoNewWindow -Wait


		
$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-Windows Defender%254Operational.evtx"
Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_defender(1116-1117-1119).csv" -NoNewWindow -Wait

	$inevtx=$in+"\Windows\System32\winevt\Logs\Microsoft-Windows-User Profile Service%254Operational.evtx"
Start-Process "$tools\EvtxeCmd\EvtxECmd.exe" -ArgumentList "-f `"$inevtx`" --csv `"$out`" --csvf evtx_SessionsUser(2-4).csv" -NoNewWindow -Wait

#Prefetch - check ok : pecmd - 
$inprefetch=$in+"\Windows\Prefetch"
start-process -filePath "$tools\PECmd.exe" -argumentlist @('-d',$inprefetch,'--csv',$out,'--csvf', 'prefetch.csv') -NoNewWindow -Wait

#Amcache
$inamcache=$in+"\Windows\appcompat\Programs\amcache.hve"
start-process -filePath "$tools\amcacheparser.exe" -argumentlist @('-f',$inamcache,'--csv',$out,'--csvf', 'amcache.csv') -NoNewWindow -Wait

#Appcompatcache En Admin
$inappcompatcache=$in+"\windows\system32\config\SYSTEM"
start-process -filePath "$tools\AppCompatCacheParser.exe" -argumentlist @('-f',$inappcompatcache,'--csv',$out,'--csvf', 'appcompatcache.csv') -NoNewWindow -Wait

#LNK
$listeUser = (gci $in/Users).Name
$listeUser | %{
	$inlnk=$in+"\Users\"+$_+"\AppData\Roaming\Microsoft\Windows\Recent"
	$filenameOut = "lnk_"+$_+".csv"
	start-process -filePath "$tools\lecmd.exe" -argumentlist @('-d',$inlnk,'--csv',$out,'--csvf',$filenameOut) -NoNewWindow -Wait
}

#JUMPLIST : jlecmd
$listeUser = (gci $in/Users).Name
$listeUser | %{
	$injumplist=$in+"\Users\"+$_+"\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations"
	$filenameOut = "jumplist_"+$_+"_Automatic.csv"
	start-process -filePath "$tools\jlecmd.exe" -argumentlist @('-d',$injumplist,'--csv',$out,'--csvf',$filenameOut) -NoNewWindow -Wait

	$injumplist=$in+"\Users\"+$_+"\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations"
	$filenameOut = "jumplist_"+$_+"_Custom.csv"
	start-process -filePath "$tools\jlecmd.exe" -argumentlist @('-d',$injumplist,'--csv',$out,'--csvf',$filenameOut) -NoNewWindow -Wait
}

#ShellBag:SBECmd+SumECmd.exe
$listeUser = (gci $in/Users).Name
$listeUser | %{
	$inshellbag=$in+"\Users\"+$_+"\AppData\Local\Microsoft\Windows\"
	$filenameOut = "shellbag_"+$_+".csv"
	start-process -filePath "$tools\SBEcmd.exe" -argumentlist @('-d',$inshellbag,'--csv',$out,'--csvf',$filenameOut) -NoNewWindow -Wait
}

#SRUM : SrumECmd.exe (~30 jours (variable))(>Win8)((Granularité limitée (~heure))
$insrudb=$in+"\windows\system32\sru\SRUDB.dat"
start-process -filePath "$tools\SrumECmd.exe" -argumentlist @('-f',$insrudb,'--csv',$out) -NoNewWindow -Wait


