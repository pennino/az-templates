#region Login
$cred = Get-Credential
Login-AzureRmAccount -Credential $cred
#endregion

#region Create Resource Group
$rg = "lab-sql-rg"
$location = "westeurope"

try {
    Get-AzureRmResourceGroup -name $rg -Location $location -ea stop
}
catch {
    write-host -ForegroundColor Yellow ("Creating Resource Group '{0}'" -f $rg)
    $rg = New-AzureRmResourceGroup -name $rg -Location $location
}
#endregion


#region deploy resources

If ($psISE){
    $root = split-path $psISE.CurrentFile.FullPath
}

$templateFilePath = join-path $root "sql_server_2014.json"
$templateFileParams = join-path $root "sql_server_2014-params.json"

try {
    Test-AzureRmResourceGroupDeployment -ResourceGroupName $rg.ResourceGroupName `
    -TemplateFile $templateFilePath -TemplateParameterFile $templateFileParams -verbose -ea Stop

    New-AzureRmResourceGroupDeployment -ResourceGroupName $rg.ResourceGroupName `
     -TemplateFile $templateFilePath -TemplateParameterFile $templateFileParams -verbose   
}
catch {
    write-host -ForegroundColor red "Check Deployment Status"
}

#endregion