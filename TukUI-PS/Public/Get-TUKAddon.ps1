Function Get-TUKAddon {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [ValidateSet('Classic','Classic-WoTLK','Retail')]
        [string]$WoWEdition = "Retail"
    )

    Begin {

        $msgheader = "[$($MyInvocation.MyCommand)]"
        $baseUrl = (Get-TUKConfig -Verbose:$VerbosePreference).baseUrl
        Write-Verbose "$msgheader Base URL: $baseUrl"
        $OutputPath = "$env:USERPROFILE\Downloads"
        Write-Verbose "$msgheader Download path: $OutputPath"

    }

    Process {
        if ($WoWEdition -eq 'Retail' -and $Name -eq "ElvUI"){
            # have to do this craziness since the retail version of ElvUI doesn't show up in the addon listing in the api 
            Write-Verbose "$msgheader Downloading ElvUI for WoW retail"
            $welcome = invoke-webrequest -uri "$baseUrl/welcome.php" -Method Get

            $dldata = (($welcome.links | select-string 'downloads/elvui' ) -Split " " | ?{ $_ -match 'href' })[0]
            $dlurl = $dldata.Split('=')[1].Replace('"','')
            Write-Verbose "`$dlurl: $dlurl"
            
            $start = $($dlurl.LastIndexOf('/')+1)
            $length = $($dlurl.Length - $start - ($dlurl.Length - $dlurl.IndexOf('.zip')))
            $pkginfo = $dlurl.Substring($start,$length).Split('-')

            $addonmetadata = @{
                "url"     = $baseUrl + $dlurl;
                "name"    = $pkginfo[0];
                "version" = $pkginfo[1];
            }
        }
        else {
            Write-Verbose "$msgheader Executing: Get-TUKAddonList -Name $Name -WoWEdition $WoWEdition"
            $addonmetadata = Get-TUKAddonList -Name $Name -WoWEdition $WoWEdition -Verbose:$VerbosePreference
        }
        
        $downloadSuccessful = $false
        
        switch (@($addonmetadata).count){
            0 { Write-Warning "$msgheader No packages found with Name: $Name"; break; }

            1 {
                $packageName = "$($addonmetadata.name).$($addonmetadata.version)-$WoWEdition.zip"
                $downloadPath = "$OutputPath\$packageName"

                if (Test-Path $downloadPath){
                    Write-Verbose "$msgheader $($addonmetadata.name) $($addonmetadata.version) already downloaded. Found file: $downloadpath"
                }
                else {
                    try {
                        Write-Verbose "$msgheader Downloading $($addonmetadata.name) $($addonmetadata.version)"
                        Invoke-RestMethod -Uri $addonmetadata.url -Method Get -OutFile $downloadPath -Verbose:$VerbosePreference -ErrorAction Stop
                        $downloadSuccessful = $true
                    }
                    catch {
                        $_
                    }
                }
                
                if (Test-Path $downloadPath){
                    $addonmetadata | Add-Member -MemberType NoteProperty -Name 'DownloadStatus' -Value "Successful"
                    $addonmetadata | Add-Member -MemberType NoteProperty -Name 'DownloadPath' -Value $downloadPath
                    $addonmetadata | Add-Member -MemberType NoteProperty -Name 'DownloadedOn' -Value $(Get-Date -Format o)
                } 
                
            }

            { $_ -gt 1 } {

            }

            default { Write-Warning "$msgheader We've hit a block we shouldn't have been able to! Oops! " }
        }

    }

    End {
        Return $addonmetadata
    }
}
