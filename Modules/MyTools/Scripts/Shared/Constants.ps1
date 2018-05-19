New-Variable -Name BINARY_BASE -Value 1024 -Option ReadOnly
New-Variable -Name DECIMAL_BASE -Value 1000 -Option ReadOnly

New-Variable -Name PREFIX_TYPE_BINARY -Value 'Binary' -Option ReadOnly
New-Variable -Name PREFIX_TYPE_DECIMAL -Value 'Decimal' -Option ReadOnly
New-Variable -Name PREFIX_TYPE_BOTH -Value 'Both' -Option ReadOnly

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

New-Variable -Name UNIT_TYPE_BIT -Option ReadOnly -Value @{ Name = 'bit'; Symbol = 'b' }
New-Variable -Name UNIT_TYPE_BYTE -Option ReadOnly -Value @{ Name = 'byte'; Symbol = 'B' }
New-Variable -Name UNIT_TYPE_BOTH -Value 'Both' -Option ReadOnly

# Remove-Variable -Force -Name BINARY_BASE, DECIMAL_BASE, PREFIX_TYPE_BINARY, PREFIX_TYPE_DECIMAL, PREFIX_TYPE_BOTH, PREFIXES_CONFIG, UNIT_TYPE_BIT, UNIT_TYPE_BYTE, UNIT_TYPE_BOTH