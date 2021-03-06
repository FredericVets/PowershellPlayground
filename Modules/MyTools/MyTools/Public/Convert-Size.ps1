<#
.Synopsis
Converts a size from one specific unit to another unit. Supports decimal and binary prefix types.
Optionally you can specify the precision of the result.
.Description
The size of a file system object can be specified in a unit. E.g. 10 KiB (kibibyte).

An actual unit is the combination of a prefix and a unit type.

E.g. 10 KiB :   _ prefix = Ki (This is a binary prefix type.)
                _ unit type = B (byte)

There are 2 prefix types :  _ binary    :   E.g. Ki (kibi), Mi (mebi)
                                            Based on 2^10 (1024).
                                            (A part of the IEC International Standard names and symbols for prefixes 
                                            for binary multiples for use in the fields of data processing and data 
                                            transmission.)

                            _ decimal   :   E.g. K (kilo), M (mega).
                                            Based on 10^3 (1000).
                                            (A part of the International System of Units (SI), the modern metric system.)
There are 2 unit types  :   _ bit (b)
                            _ byte (B)

See The description for the From and To parameters to see a list of all supported units.

Windows displays decimal prefixes, but they actually should be binary prefixes.
1 GB in Windows is actually 1 GiB.
.Parameter Value
The value(s) to be converted. Accepts a single value or an array.
.Parameter From
The source unit. This is the unit of the Value parameter.
Supported values : b, B, Kib, KiB, Mib, MiB, Gib, GiB, Tib, TiB, Pib, PiB, Eib, EiB, Zib, ZiB, Yib, YiB, Kb, KB, Mb, MB, Gb, GB, Tb, TB, Pb, PB, Eb, EB, Zb, ZB, Yb, YB.
Case-sensitive.
.Parameter To
The target unit. This is the unit the result will be in.
Supported values : b, B, Kib, KiB, Mib, MiB, Gib, GiB, Tib, TiB, Pib, PiB, Eib, EiB, Zib, ZiB, Yib, YiB, Kb, KB, Mb, MB, Gb, GB, Tb, TB, Pb, PB, Eb, EB, Zb, ZB, Yb, YB.
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
.Example
Convert-Size -Value 1 -From Kib -to b -Verbose
VERBOSE: Converting 1 Kib to b.
VERBOSE: Unit : Kib has prefix : Ki.
VERBOSE: Unit : b has no prefix.
VERBOSE: Same unit type : bit.
VERBOSE: Non rounded result : 1024.
VERBOSE: Rounding result to 4 decimals.
1024
.Inputs
System.Double[]
.Notes
Prefixes for binary multiples
Factor      Name 	Symbol  Origin                          Derivation 
2^10        kibi	Ki	    kilobinary:     (2^10)^1        kilo: (10^3)^1
2^20        mebi	Mi	    megabinary:     (2^10)^2        mega: (10^3)^2
2^30        gibi	Gi	    gigabinary:     (2^10)^3        giga: (10^3)^3
2^40	    tebi	Ti	    terabinary:     (2^10)^4        tera: (10^3)^4
2^50	    pebi	Pi	    petabinary:     (2^10)^5        peta: (10^3)^5
2^60	    exbi	Ei	    exabinary:      (2^10)^6         exa: (10^3)^6
2^70	    zebi	Zi	    zettabinary:    (2^10)^7       zetta: (10^3)^7
2^80	    yobi	Yi	    yottabinary:    (2^10)^8       yotta: (10^3)^8
 
Examples and comparisons with SI prefixes
one kibibit     1 Kibit = 2^10 bit  = 1024 bit
one kilobit     1 kbit  = 10^3 bit  = 1000 bit
one mebibyte    1 MiB   = 2^20 B    = 1 048 576 B
one megabyte    1 MB    = 10^6 B    = 1 000 000 B
one gibibyte    1 GiB   = 2^30 B    = 1 073 741 824 B
one gigabyte    1 GB    = 10^9 B    = 1 000 000 000 B
.Link
Get-Size
.Link
Get-SizeConverted
.Link
http://members.optus.net/alexey/prefBin.xhtml
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
        [ValidateNotNull()]
		[double[]]
        $Value,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # TODO : make dynamic?
        [ValidateScript({ ValidateUnit $_ })]
		[string]
        $From,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        # TODO : make dynamic?
        [ValidateScript({ ValidateUnit $_ })]
		[string]
        $To,

        [Parameter()]
        [ValidateScript({ $_ -ge 1 })]
		[int]
		$Precision = 4
    )
	Process {
		foreach ($size in $Value) {
			Write-Verbose "Converting $size $From to $To."

			if ($From -ceq $To) {
                Write-Verbose "From equals To, no conversion required."

				return $size
            }

            [unit]$fromUnit = GetUnitForName $From
            [unit]$toUnit = GetUnitForName $To

            $expandSizeAction = ExpandSizeForPrefixScriptBlock
            $reduceSizeAction = ReduceSizeForPrefixScriptBlock
            
            $expandedSize = ChangeSize $size $fromUnit $expandSizeAction
            $reducedSize = ChangeSize $expandedSize $toUnit $reduceSizeAction

            $result = ConvertUnitType $reducedSize $fromUnit $toUnit
            Write-Verbose "Non rounded result : $result."
            Write-Verbose "Rounding result to $Precision decimals."
            
            return [System.Math]::Round($result, $Precision)
		}
	}
}

<#  This will expand the size by multiplying the size with the value the prefix represents.
    E.g. 100 KiB -> 102400 B
#>
function ExpandSizeForPrefixScriptBlock() {
    return { 
        param([double]$size, [Unit]$unit)

        return $size * [System.Math]::Pow($unit.Prefix.PrefixType.Base, $unit.Prefix.Exponent)
    }
}

<#  This will reduce the size by dividing the size with the value the prefix represents.
    E.g. 102400 B -> 100 KiB
#>
function ReduceSizeForPrefixScriptBlock() {
    return { 
        param([double]$size, [Unit]$unit)

        return $size / [System.Math]::Pow($unit.Prefix.PrefixType.Base, $unit.Prefix.Exponent)
    }
}

function ChangeSize([double]$size, [unit]$unit, [ScriptBlock]$action) {
    if ($unit.HasPrefix()) {
        Write-Verbose ('Unit : {0} has prefix : {1}.' -f $unit.ToString(), $unit.Prefix.Symbol)
        
        # Call the action with 2 parameters using the call operator.
        return &$action $size $unit
    }

    # Just bit and byte units have no prefix.
    Write-Verbose ('Unit : {0} has no prefix.' -f $unit.ToString())
    
    return $size
}

function ConvertUnitType([double]$size, [Unit]$fromUnit, [Unit]$toUnit) {
    # Reference equality for HashTable instance.
    if ($fromUnit.UnitType -eq $toUnit.UnitType) {
        Write-Verbose ('Same unit type : {0}.' -f $fromUnit.UnitType)

        return $size
    }
    # Reference equality.
    if ($fromUnit.UnitType -eq [UnitType]::BIT) {
        Write-Verbose 'From bit to byte : / 8.'

        return $size / 8
    }

    Write-Verbose 'From byte to bit : * 8.'

    return $size * 8
}