Function Get-TUKConfig {
    [cmdletbinding()]
    param()

    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState

    $msgheader = "[$($MyInvocation.MyCommand)]" 

    if (Test-Path $Global:ConfigPath){ Get-Content -Path $Global:ConfigPath -Raw | ConvertFrom-Json }
    else { 
        Write-Host "$msgheader Module configuration file not found."
        $continueloop = $true
        while ($continueloop){
            $answer = Read-Host "$msgheader Would you like to create it now? (Y/N)"
            switch ($answer){
                'Y'     { 
                          New-TUKConfig -InstallDrive $Global:InstallDrive; $continueloop = $false;  
                          Get-Content -Path $Global:ConfigPath -Raw | ConvertFrom-Json
                          break;
                        }
                'N'     { Write-Verbose "$msgheader Config file creation stopped."; $continueloop = $false; break; }
                default { break; }
            }
        }   
    }
}