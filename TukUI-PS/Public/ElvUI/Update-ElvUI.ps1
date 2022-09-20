Function Update-ElvUI {
    [cmdletbinding()]
    param(
        [ValidateSet([WoWEdition],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]
        [string]$Edition,
        [switch]$Force
    )

    # not implemented

}