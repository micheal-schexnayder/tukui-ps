function New-TUKConfigWoWInstallation {
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true)]
        [validateset("Classic","WotLK","Retail")]
        [string]$Edition,
        [string]$InstallDrive = $Global:InstallDrive
    )

    $msgheader = "[$($MyInvocation.MyCommand)]" 

    Write-Verbose "$msgheader Finding World of Warcraft: $Edition installations on $InstallDrive drive...please wait"
    switch ($Edition){
        'Classic' { $found = Get-ChildItem -Path $InstallDrive -Filter "wowclassic.exe" -recurse -Force -ErrorAction SilentlyContinue -Verbose:$VerbosePreference}
        'Retail'  { $found = Get-ChildItem -Path $InstallDrive -Filter "wow.exe" -recurse -Force -ErrorAction SilentlyContinue -Verbose:$VerbosePreference}
    }
    
    if ($found){
        $thisinstall = @{
            'installed' = $true;
            'path' = $found.Directory.FullName;
        }
    } 
    else {
        Write-Warning "$msgheader $Edition of World of Warcraft installation NOT found"
        $thisinstall = @{
            'installed' = $false;
            'path' = '';
        }
    }

    return $thisinstall
}