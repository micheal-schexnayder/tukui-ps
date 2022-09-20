Function Remove-ElvUI {
    [cmdletbinding()]
    param(
        [string]$AddOnsPath
    )

    Begin {

        Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

        $msgheader = "[$($MyInvocation.MyCommand)]"

    }

    Process {
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
    }

    End {

    }

}
