$PREFIXES = @(
    [Prefix]::new('kibi', 'Ki', 1, [PrefixType]::BINARY),
    [Prefix]::new('mebi', 'Mi', 2, [PrefixType]::BINARY),
    [Prefix]::new('gibi', 'Gi', 3, [PrefixType]::BINARY),
    [Prefix]::new('tebi', 'Ti', 4, [PrefixType]::BINARY),
    [Prefix]::new('pebi', 'Pi', 5, [PrefixType]::BINARY),
    [Prefix]::new('exbi', 'Ei', 6, [PrefixType]::BINARY),
    [Prefix]::new('zebi', 'Zi', 7, [PrefixType]::BINARY),
    [Prefix]::new('yobi', 'Yi', 8, [PrefixType]::BINARY),

    [Prefix]::new('kilo', 'K', 1, [PrefixType]::DECIMAL),
    [Prefix]::new('mega', 'M', 2, [PrefixType]::DECIMAL),
    [Prefix]::new('giga', 'G', 3, [PrefixType]::DECIMAL),
    [Prefix]::new('tera', 'T', 4, [PrefixType]::DECIMAL),
    [Prefix]::new('peta', 'P', 5, [PrefixType]::DECIMAL),
    [Prefix]::new('exa', 'E', 6, [PrefixType]::DECIMAL),
    [Prefix]::new('zetta', 'Z', 7, [PrefixType]::DECIMAL),
    [Prefix]::new('yotta', 'Y', 8, [PrefixType]::DECIMAL)
)
$UNITS = $PREFIXES |
    ForEach-Object -Begin {
        # Add bit and byte.
        [Unit]::new([UnitType]::BIT)
        [Unit]::new([UnitType]::BYTE)
    } -Process {
        # Compose the units.
        # Example : Ki + B = KiB
        [Unit]::new($_, [UnitType]::BIT)
        [Unit]::new($_, [UnitType]::BYTE)
    }

function ValidateUnit {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$unit
    )
    # Select -ExpandProperty obviously only works for properties and not for methods.
    [string[]]$allUnits = $UNITS | ForEach-Object ToString
    
    if ($allUnits -ccontains $unit) {
        return $true
    }

    throw [System.ArgumentException]::new("$unit is not in the list of valid units : $allUnits.")
}

function GetUnitForName {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $unit
    )

    [Unit]$unit = $UNITS | Where-Object { $_.ToString() -ceq $unit }
    if ($unit -eq $null) {
        throw [System.ArgumentException]::new("Invalid unit : $unit.")
    }

    return $unit
}

function GetUnitsForUnitType {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [UnitType]
        $unitType
    )
    return $UNITS |
        UnitTypeFilter $unitType
}

function GetUnitsForTypes {
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [PrefixType]
        $prefixType,
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [UnitType]
        $unitType
    )
    return $UNITS | 
        PrefixTypeFilter $prefixType |
        UnitTypeFilter $unitType
}

<# Include bit and byte, although they don't have a prefix. #>
filter PrefixTypeFilter([PrefixType]$prefixType) {
    # $_ is a [Unit] instance.
    if (-not $_.HasPrefix()) {
        # Case for bit and byte unit.
        return $_
    }
    if ($_.Prefix.PrefixType -eq $prefixType) {
        return $_
    }
}

filter UnitTypeFilter([UnitType]$unitType) {
    # $_ is a [Unit] instance.
    if ($_.UnitType -eq $unitType) {
        return $_
    }
}
function GetAllUnitsAsString {
    [string[]]$allUnits = $UNITS | ForEach-Object ToString

    return [System.String]::Join(', ', $allUnits)
}