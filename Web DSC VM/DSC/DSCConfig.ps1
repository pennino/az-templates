Configuration Test {

[CmdletBinding()]

Param (
	[string] $NodeName
)

Import-DscResource -ModuleName 'PSDesiredStateConfiguration' 
		  
Node $NodeName		  
    {
	
        LocalConfigurationManager
		{
			ConfigurationMode = 'ApplyAndAutoCorrect'
			RebootNodeIfNeeded = $true
			ActionAfterReboot = 'ContinueConfiguration'
			AllowModuleOverwrite = $true
		}	

        WindowsFeature IIS{
            Name = 'web-server'
            Ensure = 'Present'
        }
   
        Log myMessage
        {
               
        Message = "The Web Service Role is installed"
        DependsOn = "[WindowsFeature]IIS"  
        }  
    }
 
}