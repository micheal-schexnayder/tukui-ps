Function Get-TUKAddonList {
    [cmdletbinding()]
    param(
        [Parameter( ParameterSetName='Name',Mandatory=$true,Position=1,
                    ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true )]
        [string]$Name,
        [Parameter(ParameterSetName='Name')]
        [switch]$Match,
        [ValidateSet('Classic','Classic-WoTLK','Retail')]
        [string]$WoWEdition = 'Retail',
        [Parameter(ParameterSetName='All',Position=1)]
        [switch]$All
    )

    Begin {
        $msgheader = "[$($MyInvocation.MyCommand)]"
        $addonlist = @()

        $TukUIBaseUrl = "https://www.tukui.org"

        Write-Verbose "$msgheader Getting all AddOns for $WoWEdition World of Warcraft"
        #see https://www.tukui.org/api.php
        $allAddonsUrl = Switch ($WoWEdition){
                            'Classic'       { "$TukUIBaseUrl/api.php?classic-addons" };
                            'Classic-WoTLK' { "$TukUIBaseUrl/api.php?classic-tbc-addons"}
                            'Retail'        { "$TukUIBaseUrl/api.php?addons" };
                        }

        $alladdons = Invoke-RestMethod -uri $allAddonsUrl -Method Get | Sort-Object -Property Id
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
                if ($match){
                    $addonlist += $alladdons | Where-Object { $_.Name -match $Name } 
                    Write-Verbose "$msgheader Returning all addons that containing $Name ($(@($addonlist).count))"
                }
                else {
                    $addonlist += $alladdons | Where-Object { $_.Name -eq $Name } 
                    Write-Verbose "$msgheader Returning all addons that match $Name ($(@($addonlist).count))"
                }
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