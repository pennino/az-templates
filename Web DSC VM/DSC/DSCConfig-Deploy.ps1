 # Copy Configuration Data files into staging directory
	
If ($psISE){
    $DSCSourceFolder  = split-path $psISE.CurrentFile.FullPath
}

if (Test-Path -Path $DSCSourceFolder)
{
	Get-ChildItem -Path $DSCSourceFolder -Filter *.ps1 | ? { $_.BaseName -notmatch "Deploy"} | ForEach-Object {

		$archiveName = $_.BaseName + '.ps1.zip'
		$archivePath = Join-Path -Path $DSCSourceFolder -ChildPath $archiveName
		
		# Create the .ps1.zip file DSC Archive
		Publish-AzureRmVMDscConfiguration -ConfigurationPath $_.FullName `
			-OutputArchivePath $archivePath `
			-Force `
			-verbose
	}
}