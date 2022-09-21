# default loader file for module

# variables
#see https://www.tukui.org/api.php
$tukInfo = @{
    "baseUrl"       = "https://www.tukui.org";
    "classicApiUrl" = "https://www.tukui.org/api.php?classic-addons";
    "wotlkApiUrl"   = "https://www.tukui.org/api.php?classic-wotlk-addons";
    "retailApiUrl"  = "https://www.tukui.org/api.php?addons";
}

$tukuiRoot = $PSScriptRoot

$Global:ConfigPath = "$env:USERPROFILE\AppData\Roaming\TukUI\tukui_config.json"
$Global:InstallDrive = "C:\"

# functions from files (function name should match filename)
$Public  = @( Get-ChildItem -Path "$tukuiRoot\Public"  -Filter '*.ps1' -Recurse )
$Private = @( Get-ChildItem -Path "$tukuiRoot\Private"  -Filter '*.ps1' -Recurse )
$Scripts = @( Get-ChildItem -Path "$tukuiRoot\Scripts"  -Filter '*.ps1' -Recurse )

# dot source the files 
foreach ($type in ($Public, $Private, $Scripts)){
    foreach ($file in $type) {
        try { . $file.FullName }
        catch { Write-Error -Message "Failed to import function: $($file.Fullname) : $_"}
    }
}

Export-ModuleMember -Function $Public.Basename
Export-ModuleMember -Function $Scripts.Basename
Export-ModuleMember -Variable $tukuiRoot

if (-not (Test-Path $Global:ConfigPath)){ 
    Write-Verbose "Module configuration file not found. Creating. Please wait..."; New-TukConfig 
}