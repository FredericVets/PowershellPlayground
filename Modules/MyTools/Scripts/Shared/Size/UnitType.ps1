New-Variable -Name UNIT_TYPE_BIT -Option ReadOnly -Value @{ Name = 'bit'; Symbol = 'b' }
New-Variable -Name UNIT_TYPE_BYTE -Option ReadOnly -Value @{ Name = 'byte'; Symbol = 'B' }
New-Variable -Name UNIT_TYPE_BOTH -Value 'Both' -Option ReadOnly

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
    if (-not (($unit.Length -ge 2) -and ($unit.Length -le 3))) {
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