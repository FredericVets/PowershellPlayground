<#
.Synopsis
Itterates recursively through a directory structure and returns the accumulated file size in bytes.
.Link
Convert-Size
Get-SizeConverted
#>
function Get-Size {
    [CmdletBinding()]
    [OutputType([long])]
    Param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({ Test-Path -LiteralPath $_ })]
        [Alias("Path")]
        [string[]]
        $LiteralPath
    )
    Process {
        foreach ($item in $LiteralPath) {
            [long]$totalLength = 0

            Write-Verbose "Starting to get size of : $item"
            # Include hidden directories.
            $dirs = Get-ChildItem -LiteralPath $item -Directory -Force
            foreach ($d in $dirs) {
                # Recursive call.
                $d = Get-Size $d.FullName
                Write-Verbose "Get-Size returned $d"
                $totalLength += $d
            }

            # Include hidden files.
            $files = Get-ChildItem -LiteralPath $item -File -Force
            foreach ($f in $files) {
                Write-Verbose "Adding size of : $($f.FullName)"
                $totalLength += $f.Length
            }

            Write-Verbose "Total size of = $totalLength"
            Write-Output $totalLength
        }
    }
}