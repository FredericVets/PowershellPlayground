function Get-Size ([string[]]$Path, [int]$Itteration=0) {
    $totalLength = 0
    foreach ($item in $Path) {
        Write-verbose "$Itteration:: Starting to get size of : $item"
        # Include hidden directories.
        $dirs = Get-ChildItem -Path $item -Directory -Force
        foreach ($d in $dirs) {
            # Recursive call.
            $d = Get-Size $d.FullName $($Itteration + 1)
            Write-Verbose "$Itteration:: Get-Size returned $d"
            $totalLength += $d
        }

        # Include hidden files.
        $files = Get-ChildItem -Path $item -File -Force
        foreach ($f in $files) {
            Write-Verbose "$Itteration:: Adding size of : $($f.FullName), $($f.Length) to $totalLength"
            $totalLength += $f.Length
        }
    }
   
    Write-Verbose "$Itteration:: Total size = $totalLength"
    return $totalLength
}

function Bla{
    [CmdletBinding()]
    Param()
    "bla"
    1
    Write-Verbose bla
}

function Test-Binding {
    [CmdletBinding()]
    [OutputType([double])]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [double]
        $Value
    )

    Process {
        $Value
        return $Value
    }
}