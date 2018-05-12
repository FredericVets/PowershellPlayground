<#
Full, ShowOnlyRelevant
SI, Binary, Both
#>
function Get-SizeFormatted {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [Alias("Path")]
        [string[]]
        $LiteralPath
    )
    Process {
        foreach ($item in $LiteralPath) {
            $size = Get-Size $item

            New-SizeObject $item $size
        }
    }
}

function New-SizeObject([string]$literalPath, [long]$sizeBytes) {
    $props = [Ordered]@{
        LiteralPath = $literalPath
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

    return New-Object -TypeName PSObject -Property $props
}