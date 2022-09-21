using module Tukui
Function Test-AddOnVersion {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [ValidateSet([WoWEdition],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
        [string]$WoWEdition,
        [Parameter(Mandatory=$true)]
        [double]$Version
    )

    $msgHeader = "[$($MyInvocation.MyCommand)]"
    $refData = Get-Content "$moduleRoot/data/addon-data.json" -Raw | ConvertFrom-Json
    $addOn = $refData | Where-Object { $_.Name -eq $Name -and $_.WoWEdition -eq $WoWEdition }
    [double]$min = $addOn.minVersion
    [double]$max = $addOn.maxVersion


    if ($addOn){
        if ( $Version -ge $min -and $Version -le $max ){
            return $true
        }
        else {
            Write-Warning "$msgHeader $Name $Version ($WoWEdition) not within valid ranges: $min - $max"
            Write-Warning "$msgHeader $($addOn.referenceUrl)"
            return $false
        }
    }
    else { 
        return $true
    }
    
    
}