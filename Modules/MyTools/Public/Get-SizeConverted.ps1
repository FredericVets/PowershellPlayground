<#
.Synopsis
Gets the size for a file or directory. Displays the resulting size in different units.
.Description
Gets the size for a file or directory.
In case of directory : itterates recursively through the directory structure and returns the accumulated file sizes.

The resulting size can be returned in units with different prefix types : binary, decimal or both.
By default units for both the prefix types are returned.
By default only the meaningful units are returned. E.g. Instead of displaying 1025 KiB, 1.001 Mib will be shown.

For more info see the Get-Help Convert-Size page.
.Parameter LiteralPath
A path to a file / directory. Interpreted as a literalpath, so no wildcards allowed.
Accepts a single value or an array.
.Parameter PrefixType
Specifies the prefix type of the units. Possible values : 'Both', 'Binary', 'Decimal'.
Defaults to Both.
.Parameter ShowAllUnits
All units for the specified prefix type will be returned.
This can come in handy when you use the result in a script. This way you can be sure that a specific unit will always 
be present.
.Parameter Precision
The number of decimals to include in the results.
Defaults to 4.
.Parameter Force
Gets hidden files and folders. By default, hidden files and folder are excluded.
.Example
Get-SizeConverted $HOME\Downloads

GiB         GB          LiteralPath
---         --          -----------
150,3439    161,4305    C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -PrefixType Decimal
GB          LiteralPath
--          -----------
161,4305    C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -ShowAllUnits

byte        : 161430549119
KiB         : 157647020,624
MiB         : 153952,1686
GiB         : 150,3439
TiB         : 0,1468
PiB         : 0,0001
EiB         : 0
ZiB         : 0
YiB         : 0
KB          : 161430549,119
MB          : 161430,5491
GB          : 161,4305
TB          : 0,1614
PB          : 0,0002
EB          : 0
ZB          : 0
YB          : 0
LiteralPath : C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -PrefixType Binary -ShowAllUnits

byte        : 161430549119
KiB         : 157647020,624
MiB         : 153952,1686
GiB         : 150,3439
TiB         : 0,1468
PiB         : 0,0001
EiB         : 0
ZiB         : 0
YiB         : 0
LiteralPath : C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -PrefixType Decimal -ShowAllUnits -Precision 6

byte        : 161430549119
KB          : 161430549,119
MB          : 161430,549119
GB          : 161,430549
TB          : 0,161431
PB          : 0,000161
EB          : 0
ZB          : 0
YB          : 0
LiteralPath : C:\Users\Frederic\Downloads
.Inputs
System.String[]
.Link
Get-Size
.Link
Convert-Size
#>
function Get-SizeConverted {
    [CmdletBinding()]
	Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
		[ValidateScript({ Test-Path -LiteralPath $_ })]
		[Alias('Path')]
		[string[]]
        $LiteralPath,

        [Parameter()]
        # hard-coded, no ValidateScript since these values are a simple set and I want to keep tab- completion enabled.
		[ValidateSet('Both', 'Binary', 'Decimal')]
		[string]
        $PrefixType = 'Both',

        [Parameter()]
        [Alias('Full')]
        [switch]
        $ShowAllUnits,

        [Parameter()]
        [int]
        $Precision = 4,
        
        [Parameter()]
        [switch]
        $Force
    )
   	Process {       
        foreach ($path in $LiteralPath) {
            $params = @{
                'LiteralPath' = $path
                'Force' = $Force
            }
			[long]$sizeInByte = Get-Size @params
			$sizes = ConvertToSizesForPrefixType $PrefixType $sizeInByte $Precision $ShowAllUnits
            
            CreateResultObject $path $sizes
		}
	}
}

function ConvertToSizesForPrefixType([string]$prefixType, [long]$sizeInByte, [int]$precision, [bool]$showAllUnits) {
    # By default Powershell hashtables @{} are case insensitive.
    # To get a case sensitive hashtable : explicitly use New-Object -TypeName System.Collections.Hashtable and use the 
    # index or dot notation.
    $sizes = [Ordered]@{}
    $convertParams = @{
        'From' = [UnitType]::BYTE.Symbol
        'Precision' = $precision
        'Value' = $sizeInByte
    }

    # Only use unit type byte.
    $units = GetByteUnits $prefixType
    foreach ($unit in $units) {
        $convertParams['To'] = $unit.ToString()
        
        # Use splatting.
        $converted = Convert-Size @convertParams
        if ($showAllUnits) {
            $sizes[$unit.ToString()] = $converted

            continue
        }
        
        # Only include the meaningful units.
        if ($unit.IsMeaningFulFor($converted)) { 
            $sizes[$unit] = $converted
        }
    }

    return $sizes
}

<# We only care for units that have unit type -eq byte. #>
function GetByteUnits([string]$prefixType) {
    switch ($prefixType) {
        'Binary' { return GetUnitsForTypes ([Prefixtype]::BINARY) ([UnitType]::BYTE)  }
        'Decimal' { return GetUnitsForTypes ([Prefixtype]::DECIMAL) ([UnitType]::BYTE)  }
        'Both' { return GetUnitsForUnitType ([UnitType]::BYTE) }
    }

    throw [System.ArgumentException]::new("Invalid prefix type : $prefixType.")
}

function CreateResultObject([string]$literalPath, $sizes) {
    # When literalPath == '.', expand it to full path.
    $literalPath = Resolve-Path -LiteralPath $literalPath

	$obj = New-Object -TypeName PSObject -Property $sizes
	$obj | Add-Member -MemberType NoteProperty -Name "LiteralPath" -Value $literalPath

	return $obj
}