Configuration Main
{

[CmdletBinding()]

Param (
	[string] $NodeName,
	[string] $domainName,
	[System.Management.Automation.PSCredential]$domainAdminCredentials
)

Import-DscResource -ModuleName PSDesiredStateConfiguration, xActiveDirectory

[System.Management.Automation.PSCredential ]$DomainCreds = New-Object System.Management.Automation.PSCredential ("$DomainName\$($domainAdminCredentials.UserName)", $domainAdminCredentials.Password)

Node $AllNodes.NodeName
    {
        LocalConfigurationManager
		{
			ConfigurationMode = ApplyOnly
			RebootNodeIfNeeded = $true
			ActionAfterReboot = 'ContinueConfiguration'
			AllowModuleOverwrite = $true
		}

		WindowsFeature DNS_RSAT
		{ 
			Ensure = "Present" 
			Name = "RSAT-DNS-Server"
		}

		WindowsFeature ADDS_Install 
		{ 
			Ensure = 'Present' 
			Name = 'AD-Domain-Services' 
		} 

		WindowsFeature RSAT_AD_AdminCenter 
		{
			Ensure = 'Present'
			Name   = 'RSAT-AD-AdminCenter'
		}

		WindowsFeature RSAT_ADDS 
		{
			Ensure = 'Present'
			Name   = 'RSAT-ADDS'
		}

		WindowsFeature RSAT_AD_PowerShell 
		{
			Ensure = 'Present'
			Name   = 'RSAT-AD-PowerShell'
		}

		WindowsFeature RSAT_AD_Tools 
		{
			Ensure = 'Present'
			Name   = 'RSAT-AD-Tools'
		}

		WindowsFeature RSAT_Role_Tools 
		{
			Ensure = 'Present'
			Name   = 'RSAT-Role-Tools'
		}      

		WindowsFeature RSAT_GPMC 
		{
			Ensure = 'Present'
			Name   = 'GPMC'
		} 
		xADDomain CreateForest 
		{ 
			DomainName = $domainName            
			DomainAdministratorCredential = $DomainCreds
			SafemodeAdministratorPassword = $DomainCreds
			DatabasePath = "C:\Windows\NTDS"
			LogPath = "C:\Windows\NTDS"
			SysvolPath = "C:\Windows\Sysvol"
			DependsOn = '[WindowsFeature]ADDS_Install'
		}
    }
}