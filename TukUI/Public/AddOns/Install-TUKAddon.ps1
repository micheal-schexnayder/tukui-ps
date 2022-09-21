Function Install-TUKAddon {
    [cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [ValidateSet([WoWEdition],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
        [string]$WoWEdition = "Retail",
        [switch]$Force
    )

    Begin {

        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        $msgheader = "[$($MyInvocation.MyCommand)]"

        $lastSuccessFullInstall = ""
    }

    Process {

        $Edition = Get-WoWEditionDetails -Name $Name -WoWEdition $WoWEdition

        $AddonsPath         = "$($Edition.WoWPath)\Interface\Addons"
        $existingdata       = "$AddonsPath\$Name\metadata.json"
        $installNew         = $false
        $installSucceeded   = $false
        $currentVersion     = ""
        $newversion         = $Edition.Metadata.Version

        if (Test-Path $Edition.Metadata.DownloadPath){

            # check to see if the latest version is already installed (metadata.json)
            if  (Test-Path $existingdata){
                $existingMetadata = Get-Content -RAW -Path $existingdata | ConvertFrom-json
                $currentVersion = $existingMetadata.version
                if ($currentVersion -eq $newversion){
                    Write-Output "$msgheader Latest version: $newversion, already installed"; 
                    if ($Force){ $installNew = $true }  
                    $installSucceeded = $true; $lastSuccessFullInstall = $existingMetadata.InstalledOn;
                    Write-Verbose $existingMetadata.InstalledOn
                } 
                else { 
                    Write-Output "$msgheader Currently installed version of $Name : $currentVersion, is out of date." 
                    $installNew = $true
                }
            }
            else { 
                Write-Output "$msgheader Currently installed version of $Name, was not installed by this module. Re-installing latest version" 
                $installNew = $true
            }

            if ($installNew){

                # extract the file to the temporary space (testing the zip file before modifying system)
                $tempPath  = "$env:TEMP\WoWAddonTest"
                $validFile = $true
                try   { Expand-Archive -Path $Edition.Metadata.DownloadPath -DestinationPath $tempPath -Force -ErrorAction Stop }
                catch { Write-Warning "Something is wrong with the downloaded file. System will not be modified"
                        $validFile = $false 
                    }

                
                if ($PSCmdlet.ShouldProcess("$($Edition.Metadata.name) $($Edition.Metadata.version)")){
                    if ($validFile){
                        Write-Output "$msgheader Installing new version of $Name ($newversion) to $AddonsPath" 
                        Remove-ElvUI -AddOnsPath $AddonsPath
                        try   { 
                            Expand-Archive -Path $Edition.Metadata.DownloadPath -DestinationPath $AddonsPath -Force -ErrorAction Stop 
                            $installSucceeded = $true
                        }
                        catch { Write-Error "$msgheader Error expanding zip file: $($Edition.Metadata.DownloadPath) to $AddonsPath" -ErrorAction Stop }
                    }
                    else { Write-Verbose "ERROR: The incoming file is not valid. No system changes occurred."}
                }

                if ($installSucceeded){ 
                    $lastSuccessFullInstall = Get-Date -Format o
                    $Edition.Metadata | Add-Member -MemberType NoteProperty -Name 'InstalledOn' -Value $lastSuccessFullInstall
                    $Edition.Metadata | Add-Member -MemberType NoteProperty -Name "InstalledTo" -Value $AddonsPath

                    # write out the new metadata.json file
                    Write-Verbose "$msgheader Writing new metadata to $existingdata"
                    $Edition.Metadata | Convertto-json -depth 10 | Out-file $existingdata

                    Write-Output "$msgheader Successfully installed $Name $newversion on $(Get-Date $lastSuccessFullInstall)"
                }
                else { 
                    Write-Warning "$msgheader Something went wrong. You may need to manually update the addon" 
                }
            }
        }

    }

    End { }
}