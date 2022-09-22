class WoWEdition : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() { 
        $Global:Editions = @('Classic','WotLK','Retail')
        return $Global:Editions
    }
}

#[ValidateSet([WoWEdition],ErrorMessage="Value '{0}' is invalid. Try one of: {1}")]