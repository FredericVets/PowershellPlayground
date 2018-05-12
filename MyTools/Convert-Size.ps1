<#
.Synopsis
Converts a size from a specific format to another format.
Supports formats based on 10^3 (SI notation, e.g. KB) and on 2^10 (binary notation, e.g. KiB).
.Notes
(From https://physics.nist.gov/cuu/Units/binary.html)
Prefixes for binary multiples
 Factor 	Name 	Symbol 	Origin	Derivation 
 210	kibi	Ki	kilobinary: (210)1	kilo: (103)1
 220	mebi	Mi	megabinary: (210)2 	mega: (103)2
 230	gibi	Gi	gigabinary: (210)3	giga: (103)3
 240	tebi	Ti	terabinary: (210)4	tera: (103)4
 250	pebi	Pi	petabinary: (210)5	peta: (103)5
 260	exbi	Ei	exabinary: (210)6	exa: (103)6
 
Examples and comparisons with SI prefixes
one kibibit	 1 Kibit = 210 bit = 1024 bit
one kilobit	 1 kbit = 103 bit = 1000 bit
one mebibyte	 1 MiB = 220 B = 1 048 576 B
one megabyte	 1 MB = 106 B = 1 000 000 B
one gibibyte	 1 GiB = 230 B = 1 073 741 824 B
one gigabyte	 1 GB = 109 B = 1 000 000 000 B
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
        foreach ($item in $Value) {
            Write-Verbose "Converting $item $From to $To."

            if ($From -ceq $To) {
                return $item
            }
        
            # Convert input to bytes (B).
            $bytes = switch -CaseSensitive ($From) {
                'b' { $item / 8 }
                'bit' { $item / 8 }
                'B' { $item }
                'Byte' { $item }
                'KB' { $item * 1000 }
                'MB' { $item * 1000 * 1000 }
                'GB' { $item * 1000 * 1000 * 1000 }
                'TB' { $item * 1000 * 1000 * 1000 * 1000 }
                'PB' { $item * 1000 * 1000 * 1000 * 1000 * 1000 }
                'KiB' { $item * 1024 }
                'MiB' { $item * 1024 * 1024 }
                'GiB' { $item * 1024 * 1024 * 1024 }
                'TiB' { $item * 1024 * 1024 * 1024 * 1024 }
                'PiB' { $item * 1024 * 1024 * 1024 * 1024 * 1024 }
                Default 
                { 
                    # Script terminating error
                    throw [System.ArgumentException]::new("Unsupported format: $From") 
                }
            }
            # Convert bytes (B) to the requested To format.
            $result = switch -CaseSensitive ($To) {
                'b' { $bytes * 8 }
                'bit' { $bytes * 8 }
                'B' { $bytes }
                'Byte' { $bytes }
                'KB' { $bytes / 1000 }
                'MB' { $bytes / 1000 / 1000 }
                'GB' { $bytes / 1000 / 1000 / 1000 }
                'TB' { $bytes / 1000 / 1000 / 1000 / 1000 }
                'PB' { $bytes / 1000 / 1000 / 1000 / 1000 / 1000 }
                'KiB' { $bytes / 1024 }
                'MiB' { $bytes / 1024 / 1024 }
                'GiB' { $bytes / 1024 / 1024 / 1024 }
                'TiB' { $bytes / 1024 / 1024 / 1024 / 1024 }
                'PiB' { $bytes / 1024 / 1024 / 1024 / 1024 / 1024 }
                Default 
                { 
                    # Statement terminating error.
                    throw [System.ArgumentException]::new("Unsupported format: $To") 
                }
            }
        
            Write-Verbose "Non rounded result : $result"
            [System.Math]::Round($result, $Precision)
        }
    }
}