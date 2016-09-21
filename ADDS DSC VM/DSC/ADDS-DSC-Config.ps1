Configuration Main
{

[CmdletBinding()]

Param (
	[string] $NodeName,
	[string] $domainName,
	[System.Management.Automation.PSCredential]$domainAdminCredentials,
	[Int]$RetryCount=20,
	[Int]$RetryIntervalSec=30	
	
)

Import-DscResource -ModuleName PSDesiredStateConfiguration
Import-DscResource -ModuleName xActiveDirectory, xStorage

[System.Management.Automation.PSCredential]$DomainCreds = New-Object System.Management.Automation.PSCredential ("$DomainName\$($domainAdminCredentials.UserName)", $domainAdminCredentials.Password)

Node $AllNodes.NodeName
    {
        LocalConfigurationManager
		{
			ConfigurationMode = 'ApplyOnly'
			RebootNodeIfNeeded = $true
			ActionAfterReboot = 'ContinueConfiguration'
			AllowModuleOverwrite = $true
		}

        xWaitforDisk Disk2
        {
             DiskNumber = 2
             RetryIntervalSec =$RetryIntervalSec
             RetryCount = $RetryCount
        }

        xDisk ADDataDisk
        {
            DiskNumber = 2
            DriveLetter = 'F'
			FSLabel = 'DATA'
			AllocationUnitSize = 64kb
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

        xADDomain FirstDS 
        {
            DomainName = $DomainName
            DomainAdministratorCredential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            DatabasePath = 'F:\ADDS\NTDS'
            LogPath = 'F:\ADDS\LOGS'
            SysvolPath = 'F:\ADDS\SYSVOL'
            #DependsOn = "[WindowsFeature]ADDSInstall","[xDnsServerAddress]DnsServerAddress","[cDiskNoRestart]ADDataDisk"
            DependsOn = "[WindowsFeature]ADDSInstall","[xDisk]ADDataDisk"
        }	

    }
}