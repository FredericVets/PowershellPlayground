New-Variable -Name PREFIX_TYPE_BINARY -Value 'Binary' -Option ReadOnly
New-Variable -Name PREFIX_TYPE_DECIMAL -Value 'Decimal' -Option ReadOnly
New-Variable -Name PREFIX_TYPE_BOTH -Value 'Both' -Option ReadOnly

function ValidatePrefixType {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PrefixType
    )
    $allPrefixTypes = $PREFIX_TYPE_BINARY, $PREFIX_TYPE_DECIMAL, $PREFIX_TYPE_BOTH
    if ($allPrefixTypes -contains $PrefixType) {
        return $true
    }

    throw [System.ArgumentException]::new("$PrefixType is not in the list of valid prefix types : $allPrefixTypes.")
}

filter PrefixConfigTypeFilter([string]$prefixType) {
    # Case insensitive comparison.
    # $_ is a [PSObject] instance that represents a prefixConfig.
    if (($prefixType -eq $PREFIX_TYPE_BINARY) -and (IsBinaryPrefixConfig $_)) {
        return $_
    }
    if (($prefixType -eq $PREFIX_TYPE_DECIMAL) -and (IsDecimalPrefixConfig $_)) {
        return $_
    }
    if ($prefixType -eq $PREFIX_TYPE_BOTH) {
        return $_
    }
}