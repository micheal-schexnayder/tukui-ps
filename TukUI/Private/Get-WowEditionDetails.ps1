using module Tukui
Function Get-WoWEditionDetails {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet([WoWEdition],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
        [string]$WoWEdition = "Retail"
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $msgheader = "[$($MyInvocation.MyCommand)]" 

    $EditionDetails = @{
        'MetaData' = (Get-TUKAddon -Name $Name -WoWEdition $WoWEdition);
        'WoWPath' = $null;
    }

    switch ($WoWEdition) {
        'Classic' {  
            $EditionDetails.WoWPath = (Get-TUKConfig).wowinstalls.classic.path
        }
        'WotLK' { 
            $EditionDetails.WoWPath = (Get-TUKConfig).wowinstalls.wotlk.path
        }
        Default { 
            # default is Retail
            $EditionDetails.WoWPath = (Get-TUKConfig).wowinstalls.retail.path
        }
    }

    return $EditionDetails
}