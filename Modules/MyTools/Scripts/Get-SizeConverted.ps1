<#
.Synopsis
Gets the size for a file or directory. Displays the resulting size in different units.
.Description
Gets the size for a file or directory.
In case of directory : itterates recursively through the directory structure and returns the accumulated file sizes.

The resulting size can be returned in units with different prefix types : binary, decimal or both.
By default both the prefix types are returned.
You can specify to return only the relevant units (ShowOnlyMeaningful switch).

All units have the unit type byte.

For more info see the Get-Help Convert-Size page.
.Parameter LiteralPath
A path to a file / directory. Interpreted as a literalpath.
Accepts a single value or an array.
.Parameter ShowOnlyMeaningful
Show only the sizes that hold meaning.
.Parameter PrefixType
Specifies the prefix type the sizes will be in. Possible values : 'Both', 'Binary', 'Decimal'.
Defaults to Both.
.Parameter Precision
The number of decimals to include in the results.
Defaults to 4.
.Example
Get-SizeConverted $HOME\Downloads

Bit         : 2479838095336
Byte        : 309979761917
KiB         : 302714611,2471
MiB         : 295619,7375
GiB         : 288,6911
TiB         : 0,2819
PiB         : 0,0003
KB          : 309979761,917
MB          : 309979,7619
GB          : 309,9798
TB          : 0,31
PB          : 0,0003
LiteralPath : C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -UnitType Decimal

Bit         : 2479838095336
Byte        : 309979761917
KB          : 309979761,917
MB          : 309979,7619
GB          : 309,9798
TB          : 0,31
PB          : 0,0003
LiteralPath : C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -ShowOnlyMeaningful

GiB         GB          LiteralPath
---         --          -----------
288,6911    309,9798    C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -ShowOnlyMeaningful -PrefixType Binary

GiB         LiteralPath
---         -----------
288,6911    C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -ShowOnlyMeaningful -PrefixType Decimal -Precision 6

GB          LiteralPath
--          -----------
309,979762  C:\Users\Frederic\Downloads
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
		[ValidateScript({ Test-Path -LiteralPath $_ })]
		[Alias('Path')]
		[string[]]
		$LiteralPath,
        [Alias('Human', 'HumanReadable')]
        [switch]
		$ShowOnlyMeaningful,
		[ValidateSet('Both', 'Binary', 'Decimal')]
		[string]
        $PrefixType = 'Both',
        [int]
		$Precision = 4
    )
   	Process {       
        foreach ($path in $LiteralPath) {
			[long]$sizeInByte = Get-Size -LiteralPath $path
			$sizes = ConvertToSizesForPrefixType $PrefixType $sizeInByte $Precision $ShowOnlyMeaningful
            
            CreateResultObject $path $sizes
		}
	}
}

function ConvertToSizesForPrefixType([string]$prefixType, [long]$sizeInByte, [int]$precision, [bool]$onlyMeaningful) {
    # By default Powershell hashtables @{} are case insensitive.
    # To get a case sensitive hashtable : explicitly use New-Object -TypeName System.Collections.Hashtable and use the 
    # index or dot notation.
    $sizes = [Ordered]@{}

    # Only use unit type byte.
    $units = GetAllUnits $prefixType $UNIT_TYPE_BYTE.Name
    foreach ($unit in $units) {
        $converted = Convert-Size -Value $sizeInByte -From byte -To $unit -Precision $precision
        if (-not $onlyMeaningful) {
            $sizes[$unit] = $converted

            continue
        }
        if (IsMeaningfulForUnit $unit $converted) { 
            $sizes[$unit] = $converted
        }
    }

    return $sizes
}

function CreateResultObject([string]$literalPath, $sizes) {
    # When literalPath == '.', expand it to full path.
    $literalPath = Resolve-Path -LiteralPath $literalPath

	$obj = New-Object -TypeName PSObject -Property $sizes
	$obj | Add-Member -MemberType NoteProperty -Name "LiteralPath" -Value $literalPath

	return $obj
}

function IsMeaningfulForUnit([string]$unit, [double]$size) {
    if (-not (HasPrefix $unit)) {
        # case for b and B, compare as decimal prefix type.
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