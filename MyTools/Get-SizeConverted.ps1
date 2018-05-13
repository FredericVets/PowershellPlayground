<#
Choice for SI, Binary, Both?
#>
function Get-SizeConverted {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [Alias("Path")]
        [string[]]
        $LiteralPath,
        [switch]
        [Alias("Human")]
        $ShowOnlyRelevant
    )
    Process {
        foreach ($item in $LiteralPath) {
            $size = Get-Size $item

            $allSizes = ConvertToAllSizes $size
            if ($ShowOnlyRelevant) {
                $relevantSizes = GetRelevantSizes $allSizes
                CreateSizeObject $item $relevantSizes

                continue
            }

            # Show full size info.
            CreateSizeObject $item $allSizes
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
        KB = Convert-Size -From B -To KB -Value $sizeBytes
        MB = Convert-Size -From B -To MB -Value $sizeBytes
        GB = Convert-Size -From B -To GB -Value $sizeBytes
        TB = Convert-Size -From B -To TB -Value $sizeBytes
    }
}

function GetRelevantSizes($allSizes) {
    # Always add Bytes.
    $relevant = [Ordered]@{ "Bytes" = $allSizes.Bytes }

    if (IsRelevantForBinaryUnit($allSizes.KiB)) {
        $relevant.Add("KiB", $allSizes.KiB)
        $relevant.Add("KB", $allSizes.KB)

        return $relevant
    }
    if (IsRelevantForBinaryUnit($allSizes.MiB)) {
        $relevant.Add("MiB", $allSizes.MiB)
        $relevant.Add("MB", $allSizes.MB)

        return $relevant
    }
    if (IsRelevantForBinaryUnit($allSizes.GiB)) {
        $relevant.Add("GiB", $allSizes.GiB)
        $relevant.Add("GB", $allSizes.GB)

        return $relevant
    }
    if (IsRelevantForBinaryUnit($allSizes.TiB)) {
        $relevant.Add("TiB", $allSizes.TiB)
        $relevant.Add("TB", $allSizes.TB)

        return $relevant
    }

    return $relevant
}

function CreateSizeObject([string]$literalPath, $sizes) {
    $obj = New-Object -TypeName PSObject -Property $sizes
    $obj | Add-Member -MemberType NoteProperty -Name "LiteralPath" -Value $literalPath

    return $obj
}

function IsRelevantForBinaryUnit([double]$size) {
    return ($size -ge 1) -and ($size -lt 1024)
}