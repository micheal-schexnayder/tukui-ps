Function Install-ElvUI {
    [cmdletbinding()]
    param(
        [ValidateSet('Classic','Classic-WoTLK','Retail')]
        [string]$Edition,
        [switch]$Force
    )

    Begin {
        $msgheader = "[$($MyInvocation.MyCommand)]"
        switch ($Edition) {
            'Classic' { 
                $Metadata = Get-TUKAddon -Name ElvUI -WoWEdition Classic -Verbose:$VerbosePreference 
                $WoWPath = (Get-TUKConfig).wowinstalls.classic.path
            }
            'Classic-WoTLK' { 
                $Metadata = Get-TUKAddon -Name ElvUI -WoWEdition Classic-WoTLK -Verbose:$VerbosePreference 
                $WoWPath = (Get-TUKConfig).wowinstalls.'classic-wotlk'.path
            }
            Default { 
                $Metadata = Get-TUKAddon -Name ElvUI -WoWEdition Retail -Verbose:$VerbosePreference 
                $WoWPath = (Get-TUKConfig).wowinstalls.retail.path
            }
        }

        $lastSuccessFullInstall = ""
    }

    Process {

        $AddonsPath         = "$WoWPath\Interface\Addons"
        $existingdata       = "$AddonsPath\ElvUi\metadata.json"
        $installNew         = $true
        $installSucceeded   = $false
        $currentVersion     = ""
        $newversion         = $Metadata.Version

        if (Test-Path $Metadata.DownloadPath){

            # check to see if the latest version is already installed (metadata.json)
            if  (Test-Path $existingdata){
                $existingMetadata = Get-Content -RAW -Path $existingdata -Verbose:$VerbosePreference | ConvertFrom-json
                $currentVersion = $existingMetadata.version
                if ($currentVersion -eq $newversion -and $Force -eq $false){
                    Write-Output "$msgheader Latest version: $newversion, already installed"; 
                    $installNew = $false;  $installSucceeded = $true; $lastSuccessFullInstall = $existingMetadata.InstalledOn;
                    Write-Verbose $existingMetadata.InstalledOn
                } 
                else { Write-Output "$msgheader Currently installed version of ElvUI: $currentVersion, is out of date." }
            }
            else { Write-Output "$msgheader Installing new version of ElvUI ($newversion) to $AddonsPath" }

            if ($installNew){
                $ElvUIPath = "$AddonsPath\ElvUI"
                if (Test-Path "$ElvUIPath"){ 
                    Write-Verbose "$msgheader Deleting: $ElvUIPath"
                    Remove-Item -Path "$ElvUIPath" -Recurse -Force
                }

                $ElvUIOptionsUIPath = "$AddonsPath\ElvUI_OptionsUI"
                if (Test-Path "$ElvUIOptionsUIPath"){ 
                    Write-Verbose "$msgheader Deleting: $ElvUIOptionsUIPath"
                    Remove-Item -Path $ElvUIOptionsUIPath -Recurse -Force 
                }
                # extract the file to the temporary space (testing the zip file before modifying system)
                try   { Expand-Archive -Path $Metadata.DownloadPath -DestinationPath $AddonsPath -Force -ErrorAction Stop }
                catch { Write-Error "$msgheader Error expanding zip file: $($Metadata.DownloadPath) to $AddonsPath"; throw }

                $lastSuccessFullInstall = Get-Date -Format o
                $Metadata | Add-Member -MemberType NoteProperty -Name 'InstalledOn' -Value $lastSuccessFullInstall
                $Metadata | Add-Member -MemberType NoteProperty -Name "InstalledTo" -Value $AddonsPath

                # write out the new metadata.json file
                Write-Verbose "$msgheader Writing new metadata to $existingdata"
                $Metadata | Convertto-json -depth 10 | Out-file $existingdata

                $installSucceeded = $true
            }

        }
        else {
            Write-Error "$msgheader Download FILE NOT FOUND"
        }
    }

    End {
        if ($installSucceeded){ Write-Output "$msgheader Successfully installed ElvUI $newversion on $(Get-Date $lastSuccessFullInstall)"}
        else { Write-Warning "$msgheader Something went wrong. You may need to manually update the addon" }
     }
}