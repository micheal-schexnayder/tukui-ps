Function Get-WoWEditionDetails {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet([WoWEdition],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
        [string]$WoWEdition
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $msgheader = "[$($MyInvocation.MyCommand)]" 

    $EditionDetails = @{
        'MetaData' = $null;
        'WoWPath' = $null;
    }

    switch ($WoWEdition) {
        'Classic' { 
            $EditionDetails.Metadata = Get-TUKAddon -Name ElvUI -WoWEdition Classic  
            $EditionDetails.WoWPath = (Get-TUKConfig).wowinstalls.classic.path
        }
        'WotLK' { 
            $EditionDetails.Metadata = Get-TUKAddon -Name ElvUI -WoWEdition WotLK
            $EditionDetails.WoWPath = (Get-TUKConfig).wowinstalls.wotlk.path
        }
        Default { 
            # default is Retail
            $EditionDetails.Metadata = Get-TUKAddon -Name ElvUI -WoWEdition Retail 
            $EditionDetails.WoWPath = (Get-TUKConfig).wowinstalls.retail.path
        }
    }

    return $EditionDetails
}