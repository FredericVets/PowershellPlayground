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

function GetPrefixConfig([string]$prefix) {
    $config = $PREFIXES_CONFIG | Where-Object Name -ceq $prefix
    if ($config -eq $null) {
        throw [System.ArgumentException]::new("Invalid prefix : $prefix")
    }

    return $config
}

filter PrefixConfigTypeFilter([string]$prefixType) {
    # Case insensitive comparison.
    # $_ is a [PSObject] that represents a prefixConfig.
    if ($prefixType -eq $PREFIX_TYPE_BINARY -and (IsBinaryPrefixConfig $_)) {
        return $_
    }
    if ($prefixType -eq $PREFIX_TYPE_DECIMAL -and (IsDecimalPrefixConfig $_)) {
        return $_
    }
    if ($prefixType -eq $PREFIX_TYPE_BOTH) {
        return $_
    }
}

function IsBinaryPrefixConfig([PSObject]$prefixConfig) {
    return $prefixConfig.Base -eq $BINARY_BASE
}

function IsDecimalPrefixConfig([PSObject]$prefixConfig) {
    return $prefixConfig.Base -eq $DECIMAL_BASE
}

function GetPrefix([string]$unit) {
    if (-not (HasPrefix $unit)) {
        throw [System.ArgumentException]::new("Unit : $unit has no prefix.")
    }

    return $unit.Remove($unit.Length - 1)
}

function HasPrefix([string]$unit) {
    # In the example below, a return in the For-Each object doesn't terminate the function, just the current 
    # For-Each script block ...
    # Makes sense since you're plugged into the pipeline.
    # $PREFIXES_CONFIG |
    # ForEach-Object {
    #     if ($unit -clike "$($_.Name)*") {
    #         return $true
    #     }
    # }
    foreach ($prefix in $PREFIXES_CONFIG) {
        if ($unit -clike "$($prefix.Name)*") {
            return $true
        }
    }

    return $false
}

function HasBinaryPrefix([string]$unit) {
    $prefix = GetPrefix $unit
    $prefixConfig = GetPrefixConfig $prefix

    return IsBinaryPrefixConfig $prefixConfig
}

function HasDecimalPrefix([string]$unit) {
    $prefix = GetPrefix $unit
    $prefixConfig = GetPrefixConfig $prefix

    return IsDecimalPrefixConfig $prefixConfig
}

function GetAllUnits {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $prefixType,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $unitType
    )
    $PREFIXES_CONFIG |
    PrefixConfigTypeFilter $prefixType |
    ForEach-Object -Begin {
        if (IsUnitTypeBit $unitType) {
            $UNIT_TYPE_BIT.Name
        }
        if (IsUnitTypeByte $unitType) {
            $UNIT_TYPE_BYTE.Name
        }
    } -Process {
        if (IsUnitTypeBit $unitType) {
            $_.Name + $UNIT_TYPE_BIT.Symbol
        }
        if (IsUnitTypeByte $unitType) {
            $_.Name + $UNIT_TYPE_BYTE.Symbol
        }
    }
}

function GetAllUnitsAsString() {
    $allUnits = GetAllUnits $PREFIX_TYPE_BOTH $UNIT_TYPE_BOTH
    
    return [System.String]::Join(", ", $allUnits)
}

function ValidateUnit {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Unit
    )

    $allUnits = GetAllUnits $PREFIX_TYPE_BOTH $UNIT_TYPE_BOTH
    if ($allUnits -ccontains $Unit) {
        return $true
    }

    throw [System.ArgumentException]::new("$Unit is not in the list of valid units : $allUnits.")
}

function IsMeaningfulForBinaryUnit([double]$size) {
    return ($size -ge 1) -and ($size -lt $DECIMAL_BASE)
}

function IsMeaningfulForDecimalUnit([double]$size) {
    return ($size -ge 1) -and ($size -lt $DECIMAL_BASE)
}

function IsUnitTypeBit([string]$unitType) {
    return $unitType -in $UNIT_TYPE_BOTH, $UNIT_TYPE_BIT.Name
}

function IsUnitTypeByte([string]$unitType) {
    return $unitType -in $UNIT_TYPE_BOTH, $UNIT_TYPE_BYTE.Name
}

function GetUnitType([string]$unit) {
    # Case for bit and byte units.
    if ($unit -ceq $UNIT_TYPE_BIT.Name) {
        return $UNIT_TYPE_BIT
    }
    if ($unit -ceq $UNIT_TYPE_BYTE.Name) {
        return $UNIT_TYPE_BYTE
    }

    # Case for *b and *B units.
    # Check length of unit.
    if (-not ($unit.Length -ge 2) -and ($unit.Length -le 3)) {
        throw [System.ArgumentException]::new("Invalid unit : $unit.")    
    }
    # Check last character.
    $unitType = $unit[-1]
    if ($unitType -ceq $UNIT_TYPE_BIT.Symbol) {
        return $UNIT_TYPE_BIT
    }
    if ($unitType -ceq $UNIT_TYPE_BYTE.Symbol) {
        return $UNIT_TYPE_BYTE
    }

    throw [System.ArgumentException]::new("Invalid unit : $unit.")
}