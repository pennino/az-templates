﻿#region Login
$cred = Get-Credential
Login-AzureRmAccount -Credential $cred
#endregion

#region Create Resource Group
$rg = "test-keyvault-rg"
$location = "westeurope"

try {
     $rg = Get-AzureRmResourceGroup -name $rg -Location $location -ea stop
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

$templateFilePath = join-path $root "VM-VaultKeys-Template.json"
$parametersFilePath = join-path $root "VM-VaultKeys-Template-Params.json"

try {
    Test-AzureRmResourceGroupDeployment -ResourceGroupName $rg.ResourceGroupName `
    -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -verbose -ea Stop

    New-AzureRmResourceGroupDeployment -ResourceGroupName $rg.ResourceGroupName  -TemplateFile $templateFilePath `
    -TemplateParameterFile $parametersFilePath -verbose   
}
catch {
    write-host -ForegroundColor red "Check Deployment Status"
}

#endregion

