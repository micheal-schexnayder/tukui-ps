Function Get-WoWEditionDetails {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Classic','WotLK','Retail')]
        [string]$WoWEdition
    )

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $msgheader = "[$($MyInvocation.MyCommand)]" 

    $EditionDetails = @{
        'MetaData' = (Get-TUKAddon -Name $Name -WoWEdition $WoWEdition);
        'WoWPath' = $null;
    }

    Write-Verbose "$msgheader Metadata: $($EditionDetails.MetaData)"

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

    Write-Verbose "$msgheader WoWPath: $($EditionDetails.WoWPath)"

    return $EditionDetails
}