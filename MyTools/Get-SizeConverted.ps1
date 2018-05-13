<#
Pass through precision

.Link
Get-Size
Convert-Size
#>
function Get-SizeConverted {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [Alias('Path')]
        [string[]]
        $LiteralPath,
        [switch]
        [Alias('Human')]
        $ShowOnlyMeaningfull,
        [ValidateSet('Both', 'Binary', 'Decimal')]
        [string]
        $PrefixType = 'Both'
    )
    Process {
        foreach ($item in $LiteralPath) {
            $sizeBytes = Get-Size $item

            $allSizes = ConvertToAllSizes $sizeBytes
            if ($ShowOnlyMeaningfull) {
                $meaningfullSizes = GetMeaningfullSizes $allSizes $PrefixType
                CreateSizeObject $item $meaningfullSizes

                continue
            }

            # Show full size info.
            $filteredSizes = FilterForPrefixType $allSizes $PrefixType
            CreateSizeObject $item $filteredSizes
        }
    }
}

function ConvertToAllSizes([long]$sizeBytes) {
    return [Ordered]@{
        Bits = Convert-Size -From B -To b -Value $sizeBytes
        Bytes = $sizeBytes
        KiB = Convert-Size -From B -To KiB -Value $sizeBytes
        MiB = Convert-Size -From B -To MiB -Value $sizeBytes
        GiB = Convert-Size -From B -To GiB -Value $sizeBytes
        TiB = Convert-Size -From B -To TiB -Value $sizeBytes
        PiB = Convert-Size -From B -To PiB -Value $sizeBytes
        KB = Convert-Size -From B -To KB -Value $sizeBytes
        MB = Convert-Size -From B -To MB -Value $sizeBytes
        GB = Convert-Size -From B -To GB -Value $sizeBytes
        TB = Convert-Size -From B -To TB -Value $sizeBytes
        PB = Convert-Size -From B -To PB -Value $sizeBytes
    }
}

function GetMeaningfullSizes($allSizes, [string]$prefixType) {
    # Always add Bytes.
    $relevant = [Ordered]@{ 'Bytes' = $allSizes.Bytes }

    [bool]$addBinary = AddBinaryPrefix $prefixType
    [bool]$addDecimal = AddDecimalPrefix $prefixType
    if (IsSizeMeaningfullForPrefix $prefixType $allSizes.KiB $allSizes.KB) {
        if ($addBinary) { $relevant.Add('KiB', $allSizes.KiB) }
        if ($addDecimal) { $relevant.Add('KB', $allSizes.KB) }

        return $relevant
    }
    if (IsSizeMeaningfullForPrefix $prefixType $allSizes.MiB $allSizes.MB) {
        if ($addBinary) { $relevant.Add('MiB', $allSizes.MiB) }
        if ($addDecimal) { $relevant.Add('MB', $allSizes.MB) }

        return $relevant
    }
    if (IsSizeMeaningfullForPrefix $prefixType $allSizes.GiB $allSizes.GB) {
        if ($addBinary) { $relevant.Add('GiB', $allSizes.GiB) }
        if ($addDecimal) { $relevant.Add('GB', $allSizes.GB) }

        return $relevant
    }
    if (IsSizeMeaningfullForPrefix $prefixType $allSizes.TiB $allSizes.TB) {
        if ($addBinary) { $relevant.Add('TiB', $allSizes.TiB) }
        if ($addDecimal) { $relevant.Add('TB', $allSizes.TB) }

        return $relevant
    }
    if (IsSizeMeaningfullForPrefix $prefixType $allSizes.PiB $allSizes.PB) {
        if ($addBinary) { $relevant.Add('PiB', $allSizes.PiB) }
        if ($addDecimal) { $relevant.Add('PB', $allSizes.PB) }
    }

    return $relevant
}

function IsSizeMeaningfullForPrefix(
    [ValidateSet('Both', 'Binary', 'Decimal')][string]$prefixType,
    [double]$sizeBinary,
    [double]$sizeDecimal) {
    if ($prefix -in 'Both', 'Binary') {
        return ($sizeBinary -ge 1) -and ($sizeBinary -lt 1024)
    }

    return ($sizeDecimal -ge 1) -and ($sizeDecimal -lt 1000)
}

function AddBinaryPrefix([ValidateSet('Both', 'Binary', 'Decimal')][string]$prefixType) {
    return $prefixType -in 'Both', 'Binary'
}

function AddDecimalPrefix([ValidateSet('Both', 'Binary', 'Decimal')][string]$prefixType) {
    return $prefixType -in 'Both', 'Decimal'
}

function CreateSizeObject([string]$literalPath, $sizes) {
    $obj = New-Object -TypeName PSObject -Property $sizes
    $obj | Add-Member -MemberType NoteProperty -Name "LiteralPath" -Value $literalPath

    return $obj
}

function FilterForPrefixType(
    $allSizes, 
    [ValidateSet('Both', 'Binary', 'Decimal')][string]$prefixType) {
    if ($prefixType -eq 'Both') {
        return $allSizes
    }

    if ($prefixType -eq 'Binary') {
        return [Ordered]@{
            'Bits' = $allSizes.Bits
            'Bytes' = $allSizes.Bytes
            'KiB' = $allSizes.KiB
            'MiB' = $allSizes.MiB
            'GiB' = $allSizes.GiB
            'TiB' = $allSizes.TiB
            'PiB' = $allSizes.PiB
        }
    }

    # Decimal
    return [Ordered]@{
        'Bits' = $allSizes.Bits
        'Bytes' = $allSizes.Bytes
        'KB' = $allSizes.KB
        'MB' = $allSizes.MB
        'GB' = $allSizes.GB
        'TB' = $allSizes.TB
        'PB' = $allSizes.PB
    }
}