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

class WoWEdition : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() { 
        $Global:Editions = @('Classic','WotLK','Retail')
        return $Global:Editions
    }
}

$Global:ConfigPath = "$env:USERPROFILE\AppData\Roaming\TukUI\tukui_config.json"
$Global:InstallDrive = "C:\"

# functions from files (function name should match filename)
$subDirs = @('Public','Private','Scripts')
$subDirs | ForEach-Object { New-Variable -Name $_ -Value @( Get-ChildItem -Path "$tukuiRoot\$_"  -Filter '*.ps1' -Recurse ) }

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