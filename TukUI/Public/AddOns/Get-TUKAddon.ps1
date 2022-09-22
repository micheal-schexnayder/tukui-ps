Function Get-TUKAddon {
    [cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [ValidateSet('Classic','WotLK','Retail')]
        [string]$WoWEdition = "Retail"
    )

    Begin {

        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState 

        $msgheader = "[$($MyInvocation.MyCommand)]"
        $baseUrl = (Get-TUKConfig -Verbose:$VerbosePreference).baseUrl
        Write-Verbose "$msgheader Base URL: $baseUrl"
        $OutputPath = "$env:USERPROFILE\Downloads"
        Write-Verbose "$msgheader Download path: $OutputPath"

    }

    Process {
        if ($WoWEdition -eq 'Retail' -and $Name -in ("ElvUI","TukUI")){
            # figured out that the TukUI and ElvUI addon's are a part of the 'classic' api
            Write-Verbose "$msgheader Executing: Get-TUKAddonList -Name $Name -WoWEdition $WoWEdition"
            $addonmetadata = Get-TUKAddonList -Name $Name -WoWEdition Classic
        }
        else {
            Write-Verbose "$msgheader Executing: Get-TUKAddonList -Name $Name -WoWEdition $WoWEdition"
            $addonmetadata = Get-TUKAddonList -Name $Name -WoWEdition $WoWEdition
        }
        
        switch (@($addonmetadata).count){
            0 { Write-Warning "$msgheader No packages found with Name: $Name"; break; }

            1 {
                $packageName = "$($addonmetadata.name).$($addonmetadata.version).zip"
                $downloadPath = "$OutputPath\$packageName"
                $addonmetadata | Add-Member -MemberType NoteProperty -Name 'DownloadPath' -Value $downloadPath

                if (Test-Path $downloadPath){
                    Write-Verbose "$msgheader $($addonmetadata.name) $($addonmetadata.version) already downloaded. Found file: $downloadpath"
                }
                else {
                    try {
                        if ($PSCmdlet.ShouldProcess("$($addonmetadata.name) $($addonmetadata.version)")){
                            Write-Verbose "$msgheader Downloading $($addonmetadata.name) $($addonmetadata.version)"
                            Invoke-RestMethod -Uri $addonmetadata.url -Method Get -OutFile $downloadPath -ErrorAction Stop
                        }
                    }
                    catch {
                        $_.ErrorDetails.Message
                    }
                }
                
                if (Test-Path $downloadPath){
                    $addonmetadata | Add-Member -MemberType NoteProperty -Name 'DownloadStatus' -Value "Successful"
                    $addonmetadata | Add-Member -MemberType NoteProperty -Name 'DownloadedOn' -Value $(Get-Date -Format o)
                } 
                
            }

            { $_ -gt 1 } {
                Write-Warning "$msgHeader Too many results returned"
            }

            default { Write-Warning "$msgheader We've hit a block we shouldn't have been able to! Oops! " }
        }

    }

    End {
        Return $addonmetadata
    }
}
