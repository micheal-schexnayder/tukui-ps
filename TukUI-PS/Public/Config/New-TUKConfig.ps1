Function New-TUKConfig {
    [cmdletbinding()]
    param(
        [parameter(HelpMessage="The Drive letter (or specific path to find World of Warcraft installations (Default: C:\)")]
        [string]$InstallDrive = $Global:InstallDrive
    )

    $msgheader = "[$($MyInvocation.MyCommand)]" 
    $ConfigFile = $Global:ConfigPath
    $CreateNew = $true

    if (Test-Path $ConfigFile){ 
        Write-Warning "$msgheader File found! $Configfile"
        $continueloop = $true
        while($continueloop){
            $answer = Read-Host "$msgheader Are you sure you want to recreate it? (Y/N)"
            switch ($answer){
                'Y'     { Remove-Item -Path $ConfigFile -Force -ErrorAction SilentlyContinue; $continueloop = $false; break;}
                'N'     { Write-Output "$msgheader Config file creation stopped."; $continueloop = $false; $CreateNew = $false; break; }
                default { break; }
            }
        }
    }

    if ($CreateNew){
        $config = [ordered]@{
            "version" = Get-TukuiVersionString -Verbose:$VerbosePreference;
            "baseUrl" = "https://www.tukui.org";
            "wowinstalls" = "";
        }
        
        $installs = New-Object System.Collections.ArrayList

        foreach ($install in ("Classic","Retail")){
            $thisinstall = @{
                "$install" = New-TUKConfigWoWInstallation -Edition $install -Verbose:$VerbosePreference
            }
            $installs.Add($thisinstall) | Out-Null 
        }

        $config.wowinstalls = $installs
        $config | ConvertTo-Json -Depth 10 | Out-File $ConfigFile
        write-Output "$msgheader New TukUI configurations written to $ConfigFile"
    }

}