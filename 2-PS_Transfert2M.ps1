Get-ChildItem -Path "./extracted" -Directory | Out-GridView -Title "Choisir les dossiers à copier vers M:" -PassThru | ForEach-Object { Copy-Item $_.FullName -Destination "M:\" -Recurse -Verbose }
