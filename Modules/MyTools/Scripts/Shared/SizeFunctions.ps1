function GetPrefixConfig([string]$prefix) {
    $config = $PREFIXES_CONFIG | Where-Object Name -ceq $prefix
    if ($config -eq $null) {
        throw [System.ArgumentException]::new("Invalid prefix : $prefix")
    }

    return $config
}

filter PrefixConfigForTypeFilter([string]$prefixType) {
    # Case insensitive comparison.
    if ($prefixType -eq $PREFIX_TYPE_BINARY -and $_.Base -eq $BINARY_BASE) {
        return $_
    }
    if ($prefixType -eq $PREFIX_TYPE_DECIMAL -and $_.Base -eq $DECIMAL_BASE) {
        return $_
    }

    return $_
}

function GetAllUnitsForPrefixType([string]$prefixType) {
    $PREFIXES_CONFIG |
    PrefixConfigForTypeFilter $prefixType |
    ForEach-Object -Begin {
        # Include single bit and single byte.
        'b'
        'B'
    } -Process {
        $_.Name + 'b'
        $_.Name + 'B'
    }
}

function GetAllUnitsAsString() {
    $allUnits = GetAllUnitsForPrefixType 'Both'
    
    return [System.String]::Join(", ", $allUnits)
}

function ValidateUnit {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Unit
    )

    $allUnits = GetAllUnitsForPrefixType $PREFIX_TYPE_BOTH
    if ($allUnits -ccontains $Unit) {
        return $true
    }

    throw [System.ArgumentException]::new("$Unit is not in the list of valid units : $allUnits.")
}

function ValidatePrefixType {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PrefixType
    )
    $allPrefixtypes = $PREFIX_TYPE_BINARY, $PREFIX_TYPE_DECIMAL, $PREFIX_TYPE_BOTH
    if ($allPrefixtypes -contains $PrefixType) {
        return $true
    }

    throw [System.ArgumentException]::new("$PrefixType is not in the list of valid prefix types : $allPrefixtypes.")
}