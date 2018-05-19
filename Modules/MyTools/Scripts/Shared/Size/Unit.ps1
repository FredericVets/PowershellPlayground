New-Variable -Name BINARY_BASE -Value 1024 -Option ReadOnly
New-Variable -Name DECIMAL_BASE -Value 1000 -Option ReadOnly

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

function IsMeaningfulForUnit([string]$unit, [double]$size) {
    if (-not (HasPrefix $unit)) {
        # case for bit and byte, compare as decimal prefix type.
        return IsMeaningfulForDecimalUnit $size
    }
    if (HasBinaryPrefix $unit) {
        return IsMeaningfulForBinaryUnit $size
    }
    if (HasDecimalPrefix $unit) {
        return IsMeaningfulForDecimalUnit $size
    }

    throw [System.ArgumentException]::new("Unknown unit: $unit")
}

function IsMeaningfulForBinaryUnit([double]$size) {
    return ($size -ge 1) -and ($size -lt $BINARY_BASE)
}

function IsMeaningfulForDecimalUnit([double]$size) {
    return ($size -ge 1) -and ($size -lt $DECIMAL_BASE)
}