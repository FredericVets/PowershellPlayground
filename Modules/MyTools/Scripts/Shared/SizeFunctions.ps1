function GetPrefixConfig([string]$prefix) {
    $config = $PREFIXES_CONFIG | where Name -ceq $prefix
    if ($config -eq $null) {
        throw [System.ArgumentException]::new("Invalid prefix : $prefix")
    }

    return $config
}

function GetAllPrefixConfigsForType([string]$prefixType) {
    $configs = @()
    if ($prefixType -cin $PREFIX_TYPE_BINARY, $PREFIX_TYPE_BOTH) {
        $configs = $PREFIXES_CONFIG | where Base -eq $BINARY_BASE
    }
    if ($prefixType -cin $PREFIX_TYPE_DECIMAL, $PREFIX_TYPE_BOTH) {
        $configs += $PREFIXES_CONFIG | where Base -eq $DECIMAL_BASE
    }

    return $configs
}

function GetAllUnitsForPrefixType([string]$prefixType) {
    GetAllPrefixConfigsForType $prefixType |
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