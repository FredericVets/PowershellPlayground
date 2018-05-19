New-Variable -Name PREFIXES_CONFIG -Option ReadOnly -Value @(
    # Wrapped in PSObject instances, otherwise '| select Name' doesn't work.
    # Binary prefixes.
    (New-Object -TypeName PSObject -Property @{ Name = 'Ki'; Base = $BINARY_BASE; Exponent = 1 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Mi'; Base = $BINARY_BASE; Exponent = 2 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Gi'; Base = $BINARY_BASE; Exponent = 3 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Ti'; Base = $BINARY_BASE; Exponent = 4 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Pi'; Base = $BINARY_BASE; Exponent = 5 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Ei'; Base = $BINARY_BASE; Exponent = 6 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Zi'; Base = $BINARY_BASE; Exponent = 7 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Yi'; Base = $BINARY_BASE; Exponent = 8 } ),
    # Decimal prefixes.
    (New-Object -TypeName PSObject -Property @{ Name = 'K'; Base = $DECIMAL_BASE; Exponent = 1 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'M'; Base = $DECIMAL_BASE; Exponent = 2 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'G'; Base = $DECIMAL_BASE; Exponent = 3 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'T'; Base = $DECIMAL_BASE; Exponent = 4 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'P'; Base = $DECIMAL_BASE; Exponent = 5 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'E'; Base = $DECIMAL_BASE; Exponent = 6 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Z'; Base = $DECIMAL_BASE; Exponent = 7 } ),
    (New-Object -TypeName PSObject -Property @{ Name = 'Y'; Base = $DECIMAL_BASE; Exponent = 8 } )
)

function GetPrefixConfig([string]$prefix) {
    $config = $PREFIXES_CONFIG | Where-Object Name -ceq $prefix
    if ($config -eq $null) {
        throw [System.ArgumentException]::new("Invalid prefix : $prefix")
    }

    return $config
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
    # In the commented example below, a return in the For-Each object doesn't terminate the function, just the current 
    # For-Each script block ...
    # Makes sense since you're plugged into the pipeline.
    #
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