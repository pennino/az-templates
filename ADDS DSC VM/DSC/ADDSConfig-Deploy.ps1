 # Copy Configuration Data files into staging directory
	
If ($psISE){
    $DSCSourceFolder  = split-path $psISE.CurrentFile.FullPath
}

Get-ChildItem $DSCSourceFolder -File -Filter '*.psd1' | Copy-Item -Destination $ArtifactStagingDirectory -Force

# Create DSC configuration archive

if (Test-Path -Path $DSCSourceFolder)
{
	Get-ChildItem -Path $DSCSourceFolder -Filter *.ps1 | ForEach-Object {

		$archiveName = $_.BaseName + '.ps1.zip'
		$archivePath = Join-Path -Path $DSCSourceFolder -ChildPath $archiveName
		
		# Create the .ps1.zip file DSC Archive
		Publish-AzureRmVMDscConfiguration -ConfigurationPath $_.FullName `
			-OutputArchivePath $archivePath `
			-Force `
			-Verbose
	}
}