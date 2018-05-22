<#
.Synopsis
Gets the size in bytes for a file or directory.
In case of directory : itterates recursively through the directory structure and returns the accumulated file size in bytes.
.Parameter LiteralPath
A path to a file / directory. Interpreted as a literalpath.
Accepts a single value or an array.
.Example
Get-Size $home\downloads
309979761917
.Example
Get-Size $HOME\downloads, $HOME\Documents
309979761917
463858051
.Inputs
System.String[]
.Link
Convert-Size
.Link
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

			# Include hidden directories.
			$dirs = Get-ChildItem -LiteralPath $item -Directory -Force
			foreach ($d in $dirs) {
                if (-not (IsDirectory $d)) {
                    continue
                }

				# Recursive call.
				$totalLength += Get-Size $d.FullName
			}

			# Include hidden files.
			$files = Get-ChildItem -LiteralPath $item -File -Force
			foreach ($f in $files) {
				Write-Verbose ("Adding size of : {0}" -f $f.FullName)
				$totalLength += $f.Length
			}

			Write-Verbose "Total size of = $totalLength"
			Write-Output $totalLength
        }
	}
}

<#
This is confusing.
Suppose I have a file named file.txt.
If I enter 'Get-ChildItem -Path .\file.txt -Directory', I get a result although it's not a directory ...
This can lead to an infinite loop in the script above.
#>
function IsDirectory($fileSystemItem) {
    return $fileSystemItem.Mode -like 'd*'
}