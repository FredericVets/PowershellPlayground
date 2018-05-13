<#
.Synopsis
Simulates the behavior of the Unix touch command.
If the provided path(s) exist, the LastWriteTime will be set to the current time. Otherwise a new file will be created 
at the specified path.
.Notes
Supports -WhatIf and -Confirm.
(Directly or through $WhatIfPreference and $ConfirmPreference.)
.Example
Update-File test.txt
.Example
Update-File -Path test.txt
.Example
Update-File idontexist.txt -WhatIf
What if: Performing the operation "Creating file." on target "idontexist.txt".
.Example
Update-File iDOexist.txt -WhatIf
What if: Performing the operation "Setting LastWriteTime to current timestamp." on target "iDOexist.txt".
#>
function Update-File {
	[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
	Param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
		[ValidateNotNullOrEmpty()]
		[string[]]
		$Path
	)
	Process {
		foreach($item in $Path) {
			if (Test-Path $item) {
				if ($PSCmdlet.ShouldProcess($item, 'Setting LastWriteTime to current timestamp.')) {
					(Get-Item -Path $item).LastWriteTime = Get-Date
				}

				continue
			}

			if ($PSCmdlet.ShouldProcess($item, 'Creating file.')) {
				# Same as echo $null >> $item.
				Add-Content -Path $item -Value $null
			}
		}
	}
}