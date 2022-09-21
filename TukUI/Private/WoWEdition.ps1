class WoWEdition : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() { 
        $Global:Editions = @('Classic','WotLK','Retail')
        return $Global:Editions
    }
}