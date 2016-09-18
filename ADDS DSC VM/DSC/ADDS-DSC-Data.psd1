# Configuration Data for AD  
@{
	AllNodes = @(
		@{
			NodeName="*"
			RetryCount = 20
			RetryIntervalSec = 30
			PSDscAllowDomainUser = $true
		},
		@{ 
			Nodename = "localhost" 
			Role = "DC" 
		}
	)
}