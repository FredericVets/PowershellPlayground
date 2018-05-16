<#
.Synopsis
Gets the size for a file or directory. Displays the resulting size in different units.
.Description
Gets the size for a file or directory.
In case of directory : itterates recursively through the directory structure and returns the accumulated file size.

The resulting size can be returned in different unit types : Binary units, Decimal units or both.
By default all different size units are returned.
You can specify to return only the relevant units.
.Parameter LiteralPath
A path to a file / directory. Interpreted as a literalpath.
Accepts a single value or an array.
.Parameter ShowOnlyMeaningful
Show only the sizes that hold meaning.
.Parameter UnitType
Specifies the unit type the sizes will be in. Possible values : 'Both', 'Binary', 'Decimal'.
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
Get-SizeConverted $HOME\Downloads -ShowOnlyMeaningful -UnitType Binary

GiB         LiteralPath
---         -----------
288,6911    C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -ShowOnlyMeaningful -UnitType Decimal -Precision 6

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
        $UnitType = 'Both',
        [int]
		$Precision = 4
    )
    Begin {
        <#  These constants are created in the local scope. 
            When a function is executed from within this scope, a new child scope is created. Inside of this new 
            scope, these constants are visible from it's parent or ancestor scopes.
        #>
        New-Variable -Name BINARY_UNITS -Value 'KiB', 'MiB', 'GiB', 'TiB', 'PiB' -Option Constant
        New-Variable -Name DECIMAL_UNITS -Value 'KB', 'MB', 'GB', 'TB', 'PB' -Option Constant
        New-Variable -Name BINARY_BASE -Value 1024 -Option Constant
        New-Variable -Name DECIMAL_BASE -Value 1000 -Option Constant
    }
	Process {       
        foreach ($path in $LiteralPath) {
			[long]$sizeInByte = Get-Size -LiteralPath $path
			$sizes = ConvertToSizesForUnitType $UnitType $sizeInByte $Precision $ShowOnlyMeaningful
            
            CreateResultObject $path $sizes
		}
	}
}

function ConvertToSizesForUnitType([string]$unitType, [long]$sizeInByte, [int]$precision, [bool]$onlyMeaningful) {
    $sizes = CreateSizesHashTable $onlyMeaningful $sizeInByte
    $units = GetUnitsFor $unitType
    foreach ($unit in $units) {
        $converted = Convert-Size -Value $sizeInByte -From Byte -To $unit -Precision $precision
        if (-not $onlyMeaningful) {
            $sizes.Add($unit, $converted)

            continue
        }
        if (IsMeaningfulForUnit $unit $converted) { 
            $sizes.Add($unit, $converted) 
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

function CreateSizesHashTable([bool]$onlyMeaningful, [long]$sizeInByte) {
    if ($onlyMeaningful) {
        return [Ordered]@{ }
    }

    return [Ordered]@{
        'Bit' = Convert-Size -From Byte -To bit -Value $sizeInByte
        'Byte' = $sizeInByte
    }
}

function GetUnitsFor([string]$unitType) {
    if ($unitType -eq 'Binary') {
        return $BINARY_UNITS
    }
    if ($unitType -eq 'Decimal') {
        return $DECIMAL_UNITS
    }
    if ($unitType -eq 'Both') {
        return $BINARY_UNITS + $DECIMAL_UNITS
    }
}

function IsMeaningfulForUnit([string]$unit, [double]$size) {
    if ($BINARY_UNITS -contains $unit) {
        return ($size -ge 1) -and ($size -lt $BINARY_BASE)
    }
    if ($DECIMAL_UNITS -contains $unit) {
        return ($size -ge 1) -and ($size -lt $DECIMAL_BASE)
    }

    throw [System.ArgumentException]::new("Unknown unit: $unit")
}