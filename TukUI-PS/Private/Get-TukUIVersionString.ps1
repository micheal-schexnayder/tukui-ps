function Get-TukUIVersionString{
    [cmdletbinding()]
    param()

    $versionHash = (get-module -ListAvailable | Where-Object{ $_.name -eq 'TukUI' }).Version

    if ($null -eq $versionHash){ throw "TukUI is NOT in the list of available modules and/or NOT on the `$PSModulePath" }
    else { $versionHash.ToString() }
}