# default loader file for module

# variables
$Global:ConfigPath = "$env:USERPROFILE\AppData\Roaming\TukUI\tukui_config.json"
$Global:InstallDrive = "C:\"

# functions from files (function name should match filename)
$Public  = @( Get-ChildItem -Path "$PSScriptRoot\Public"  -Filter '*.ps1' -Recurse )
$Private = @( Get-ChildItem -Path "$PSScriptRoot\Private" -Filter '*.ps1' -Recurse )
$Scripts = @( Get-ChildItem -Path "$PSScriptRoot\Scripts" -Filter '*.ps1' -Recurse )

# dot source the files 
foreach ($type in ($Public, $Private, $Scripts)){
    foreach ($file in $type) {
        try { . $file.FullName }
        catch { Write-Error -Message "Failed to import function: $($file.Fullname) : $_"}
    }
}

Export-ModuleMember -Function $Public.Basename
Export-ModuleMember -Function $Scripts.Basename

if (-not (Test-Path $Global:ConfigPath)){ 
    Write-Host "Module configuration file not found. Creating. Please wait..."; New-TukConfig 
}