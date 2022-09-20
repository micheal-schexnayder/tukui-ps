Function Get-TUKAddonList {
    [cmdletbinding()]
    param(
        [Parameter( ParameterSetName='Name',Mandatory=$true,Position=1,
                    ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true )]
        [string]$Name,
        [Parameter(ParameterSetName='Name')]
        [switch]$Match,
        [ValidateSet([WoWEdition],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
        [string]$WoWEdition = 'Retail',
        [Parameter(ParameterSetName='All',Position=1)]
        [switch]$All
    )

    Begin {

        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        $msgheader = "[$($MyInvocation.MyCommand)]"
        $addonlist = @()

        Write-Verbose "$msgheader Getting all AddOns for $WoWEdition World of Warcraft"
        
        $allAddonsUrl = Switch ($WoWEdition){
                            'Classic'   { $tukInfo.classicApiUrl };
                            'WoTLK'     { $tukInfo.wotlkApiUrl };
                            'Retail'    { $tukInfo.retailApiUrl };
                        }

        $alladdons = Invoke-RestMethod -uri $allAddonsUrl -Method Get | Sort-Object -Property name
        Write-Verbose "$msgheader Found: $($alladdons.count) addons"
    }    

    Process {
        Write-Verbose "$msgheader using $($PSCmdlet.ParameterSetName) to determine return set"
        switch ($PSCmdlet.ParameterSetName){

            'All'   { 
                $addonlist = $alladdons 
                Write-Verbose "$msgheader Returning all addons ($($addonlist.count))"
            }

            'Name'  { 
                $addonlist += $alladdons | Where-Object { $_.Name -eq $Name } 
                Write-Verbose "$msgheader Returning all addons that equals $Name ($(@($addonlist).count))"
            }

            default { Write-Warning "$msgheader We've hit a block we shouldn't have been able to! Oops! " }
        }
    }

    End {
        if ( @($addonlist).count -gt 0 ){
            Write-Verbose "$msgheader Returning ($(@($addonlist).count))"
            return $addonlist
        }
    }
}

#Get-TUKAddOnList -All -Verbose