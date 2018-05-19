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
E.g. Instead of displaying 1025 KiB, 1,001 Mib will be shown.
.Parameter PrefixType
Specifies the prefix type the sizes will be in. Possible values : 'Both', 'Binary', 'Decimal'.
Defaults to Both.
.Parameter Precision
The number of decimals to include in the results.
Defaults to 4.
.Example
Get-SizeConverted $HOME\Downloads

byte        : 153996151031
KiB         : 150386866,2412
MiB         : 146862,1741
GiB         : 143,4201
TiB         : 0,1401
PiB         : 0,0001
EiB         : 0
ZiB         : 0
YiB         : 0
KB          : 153996151,031
MB          : 153996,151
GB          : 153,9962
TB          : 0,154
PB          : 0,0002
EB          : 0
ZB          : 0
YB          : 0
LiteralPath : C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -PrefixType Decimal

byte        : 153996151031
KB          : 153996151,031
MB          : 153996,151
GB          : 153,9962
TB          : 0,154
PB          : 0,0002
EB          : 0
ZB          : 0
YB          : 0
LiteralPath : C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -ShowOnlyMeaningful

GiB         GB          LiteralPath
---         --          -----------
143,4201    153,9962    C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -ShowOnlyMeaningful -PrefixType Binary

GiB         LiteralPath
---         -----------
143,4201    C:\Users\Frederic\Downloads
.Example
Get-SizeConverted $HOME\Downloads -ShowOnlyMeaningful -PrefixType Decimal -Precision 6

GB          LiteralPath
--          -----------
153,996151  C:\Users\Frederic\Downloads
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
        [Alias('Human', 'HumanReadable')]
        [switch]
        $ShowOnlyMeaningful,
        # hard-coded, no ValidateScript since these values are a simple set and I want to keep tab- completion enabled.
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