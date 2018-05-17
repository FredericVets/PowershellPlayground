function Test-ValidateSet {
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateSet('Low', 'Medium', 'High')]
        [string]
        $Detail
    )

    Process {
        "You entered $Detail"
    }
}

$ACCEPTED_VALUES = 'Low', 'Medium', 'High'
function Test-ValidateScript {
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateScript({ 
            # $ACCEPTED_VALUES -contains $_ 
            if ($ACCEPTED_VALUES -contains $_) {
                return $true
            }
            throw [System.ArgumentException]::new("$_ is not in the list of supported values : $ACCEPTED_VALUES.")
        })]
        [string]
        $Detail
    )

    Process {
        "You entered $Detail"
    }
}