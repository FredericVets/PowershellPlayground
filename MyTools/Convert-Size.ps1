<#
.Synopsis
Converts a size from one specific unit to another unit. Supports decimal and binary unit types.
.Description
Decimal units :     Based on 10^3 (1000)
                    A part of the International System of Units (SI), the modern metric system.
                    e.g. KB for kilobyte
Binary units :      Based on 2^10 (1024)
                    Not a part of the SI.
                    e.g. KiB for kibibyte

Optionally you can specify the precision of the result.
.Parameter Value
The value(s) to be converted. Accepts a single value or an array.
.Parameter From
The source unit. This is the unit of the Value parameter.
Supported values : 'b', 'bit', 'B', 'Byte', 'KB', 'KiB', 'MB', 'MiB', 'GB', 'GiB', 'TB', 'TiB', 'PB', 'PiB'
Case-sensitive.
.Parameter To
The target unit. This is the unit the result will be in.
Supported values : 'b', 'bit', 'B', 'Byte', 'KB', 'KiB', 'MB', 'MiB', 'GB', 'GiB', 'TB', 'TiB', 'PB', 'PiB'
Case-sensitive.
.Parameter Precision
The number of decimals to include in the result.
Defaults to 4.
.Example
Convert-Size -Value 8 -From b -To B
1
.Example
Convert-Size -Value 1 -From GiB -To KiB
1048576
.Example
Convert-Size -Value 1 -From MiB -To MB -Precision 6
1,048576
.Inputs
System.Double[]
.Notes
Prefixes for binary multiples
Factor      Name 	Symbol  Origin	                Derivation 
2^10	    kibi	Ki	    kilobinary: (2^10)^1	kilo: (10^3)^1
2^20	    mebi	Mi	    megabinary: (2^10)^2 	mega: (10^3)^2
2^30	    gibi	Gi	    gigabinary: (2^10)^3	giga: (10^3)^3
2^40	    tebi	Ti	    terabinary: (2^10)^4	tera: (10^3)^4
2^50	    pebi	Pi	    petabinary: (2^10)^5	peta: (10^3)^5
2^60	    exbi	Ei	    exabinary: (2^10)^6	    exa: (10^3)^6
 
Examples and comparisons with SI prefixes
one kibibit	    1 Kibit = 2^10 bit  = 1024 bit
one kilobit	    1 kbit  = 10^3 bit  = 1000 bit
one mebibyte	1 MiB   = 2^20 B    = 1 048 576 B
one megabyte	1 MB    = 10^6 B    = 1 000 000 B
one gibibyte	1 GiB   = 2^30 B    = 1 073 741 824 B
one gigabyte	1 GB    = 10^9 B    = 1 000 000 000 B
.Link
Get-Size
.Link
Get-SizeConverted
.Link
https://physics.nist.gov/cuu/Units/binary.html
.Link
https://en.wikipedia.org/wiki/Binary_prefix
#>
function Convert-Size {
	[CmdletBinding()]
	[OutputType([double])]
	Param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[double[]]
		$Value,
		[Parameter(Mandatory=$true)]
		[ValidateSet('b', 'bit', 'B', 'Byte', 'KB', 'KiB', 'MB', 'MiB', 'GB', 'GiB', 'TB', 'TiB', 'PB', 'PiB', IgnoreCase=$false)]
		[string]
		$From,
		[Parameter(Mandatory=$true)]
		[ValidateSet('b', 'bit', 'B', 'Byte', 'KB', 'KiB', 'MB', 'MiB', 'GB', 'GiB', 'TB', 'TiB', 'PB', 'PiB', IgnoreCase=$false)]
		[string]
		$To,
		[int]
		$Precision = 4
	)
	Process {
        New-Variable -Name BINARY_BASE -Value 1024 -Option Constant
        New-Variable -Name DECIMAL_BASE -Value 1000 -Option Constant

		foreach ($size in $Value) {
			Write-Verbose "Converting $size $From to $To."

			if ($From -ceq $To) {
				return $size
			}
		
			$bytes = ConvertToByte $size $From
			$result = ConvertFromByte $bytes $To
		
			Write-Verbose "Non rounded result : $result"
			[System.Math]::Round($result, $Precision)
		}
	}
}

function ConvertToByte([double]$size, [string]$sourceUnit) {
    switch -CaseSensitive ($sourceUnit) {
        'b' { $size / 8 }
        'bit' { $size / 8 }
        'B' { $size }
        'Byte' { $size }
        'KB' { $size * $DECIMAL_BASE }
        'MB' { $size * $DECIMAL_BASE * $DECIMAL_BASE }
        'GB' { $size * $DECIMAL_BASE * $DECIMAL_BASE * $DECIMAL_BASE }
        'TB' { $size * $DECIMAL_BASE * $DECIMAL_BASE * $DECIMAL_BASE * $DECIMAL_BASE }
        'PB' { $size * $DECIMAL_BASE * $DECIMAL_BASE * $DECIMAL_BASE * $DECIMAL_BASE * $DECIMAL_BASE }
        'KiB' { $size * $BINARY_BASE }
        'MiB' { $size * $BINARY_BASE * $BINARY_BASE }
        'GiB' { $size * $BINARY_BASE * $BINARY_BASE * $BINARY_BASE }
        'TiB' { $size * $BINARY_BASE * $BINARY_BASE * $BINARY_BASE * $BINARY_BASE }
        'PiB' { $size * $BINARY_BASE * $BINARY_BASE * $BINARY_BASE * $BINARY_BASE * $BINARY_BASE }
        Default 
        { 
            # Script terminating error
            throw [System.ArgumentException]::new("Unsupported format: $From") 
        }
    }
}

function ConvertFromByte([double]$bytes, [string]$targetUnit) {
    switch -CaseSensitive ($targetUnit) {
        'b' { $bytes * 8 }
        'bit' { $bytes * 8 }
        'B' { $bytes }
        'Byte' { $bytes }
        'KB' { $bytes / $DECIMAL_BASE }
        'MB' { $bytes / $DECIMAL_BASE / $DECIMAL_BASE }
        'GB' { $bytes / $DECIMAL_BASE / $DECIMAL_BASE / $DECIMAL_BASE }
        'TB' { $bytes / $DECIMAL_BASE / $DECIMAL_BASE / $DECIMAL_BASE / $DECIMAL_BASE }
        'PB' { $bytes / $DECIMAL_BASE / $DECIMAL_BASE / $DECIMAL_BASE / $DECIMAL_BASE / $DECIMAL_BASE }
        'KiB' { $bytes / $BINARY_BASE }
        'MiB' { $bytes / $BINARY_BASE / $BINARY_BASE }
        'GiB' { $bytes / $BINARY_BASE / $BINARY_BASE / $BINARY_BASE }
        'TiB' { $bytes / $BINARY_BASE / $BINARY_BASE / $BINARY_BASE / $BINARY_BASE }
        'PiB' { $bytes / $BINARY_BASE / $BINARY_BASE / $BINARY_BASE / $BINARY_BASE / $BINARY_BASE }
        Default 
        { 
            # Statement terminating error.
            throw [System.ArgumentException]::new("Unsupported format: $To") 
        }
    }
}