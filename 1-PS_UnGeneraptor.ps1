#Powershell
$Desktop = [Environment]::GetFolderPath("Desktop")
cd $Desktop\w

$zipFile = Get-ChildItem "./generaptor/*.zip" | Out-GridView -Title "Sélectionnez le ZIP" -PassThru | Select-Object -ExpandProperty Name




if ($zipFile) {
    # CORRECTIF ROBUSTE : Résout le chemin absolu du dossier generaptor automatiquement
    $DossierGeneraptor = (Get-Item "./generaptor").FullName
    $ZipPath = Join-Path $DossierGeneraptor $zipFile

    Write-Host "Analyse du fichier : $ZipPath" -ForegroundColor Cyan

    try {
        # 2. Ouvrir l'archive ZIP en lecture seule
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $Zip = [System.IO.Compression.ZipFile]::OpenRead($ZipPath)

        # 3. Chercher le fichier metadata.json à l'intérieur
        $MetadataFile = $Zip.Entries | Where-Object { $_.Name -eq "metadata.json" }
        if ($MetadataFile) {
            # 4. Lire le contenu du fichier JSON
            $Stream = $MetadataFile.Open()
            $Reader = New-Object System.IO.StreamReader($Stream)
            $JsonContent = $Reader.ReadToEnd()

            # Fermer les flux
            $Reader.Close()
            $Stream.Close()
            
            # 5. Convertir le texte en objet JSON
            $JsonObject = $JsonContent | ConvertFrom-Json
            
            # 6. Récupérer et afficher la valeur de fingerprint_hex
            if ($JsonObject.fingerprint_hex) {
                Write-Host "`n[SUCCÈS] Empreinte trouvée :" -ForegroundColor Green
                Write-Host $JsonObject.fingerprint_hex -ForegroundColor Yellow
            } else {
                Write-Warning "Le fichier metadata.json existe, mais la clé 'fingerprint_hex' est introuvable."
            }
        } else {
            Write-Error "Le fichier 'metadata.json' est introuvable à l'intérieur du ZIP."
        }
    }
    catch {
        Write-Error "Une erreur est survenue lors de la lecture du ZIP : $_"
    }
    finally {
        if ($Zip) { $Zip.Dispose() }
    }
} else {
    Write-Warning "Aucun fichier n'a été sélectionné."
}

# Si un fichier a été choisi, on lance la commande dans WSL 
if ($zipFile) {
    # 1. On extrait proprement la valeur de l'empreinte pour éviter les bugs de syntaxe
    $Fingerprint = $JsonObject.fingerprint_hex
    
    # 2. On convertit le chemin absolu Windows du ZIP pour que WSL le comprenne (ex: /mnt/c/...)
    $WslZipPath = wsl wslpath ($ZipPath -replace '\\', '/')

    # 3. On récupère le chemin WSL du dossier generaptor pour s'y positionner
    $WslDir = wsl wslpath ($DossierGeneraptor -replace '\\', '/')

    # 4. On exécute le tout dans WSL
    wsl bash -c "cd '$WslDir' && source ~/.generaptor_env/bin/activate && generaptor extract '${Fingerprint}.key.pem' '$WslZipPath'"
}
