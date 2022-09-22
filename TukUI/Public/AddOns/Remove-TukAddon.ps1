Function Remove-TUKAddon {
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

        $Edition    = Get-WoWEditionDetails -Name $Name -WoWEdition $WoWEdition
        $AddonsPath = "$($Edition.WoWPath)\Interface\Addons"
    }

    Process {

        if ($Name -eq "ElvUI"){
            $subDirs = @('ElvUI','ElvUI_OptionsUI')
            foreach ($subDir in $subDirs){
                $pathToDelete = "{0}\$subDir" -f $AddonsPath

                if ($PSCmdlet.ShouldProcess("$pathToDelete")){
                    Write-Verbose "$msgheader Deleting: $pathToDelete"
                    Remove-Item -Path "$pathToDelete" -Recurse -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
                }

            }
        }
        else {

            $pathToDelete = "{0}\$Name" -f $AddonsPath

            if ($PSCmdlet.ShouldProcess("$pathToDelete")){
                Write-Verbose "$msgheader Deleting: $pathToDelete"
                Remove-Item -Path "$pathToDelete" -Recurse -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
            }

        }

    }

    End {}
}