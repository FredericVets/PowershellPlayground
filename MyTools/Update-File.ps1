<#
.Synopsis
Simulates the behavior of the Unix touch command.
If the provided path(s) exist, the LastWriteTime will be set to the current time. Otherwise a new file will be created 
at the specified path.
.Notes
Supports -WhatIf and -Confirm.
(Directly or through $WhatIfPreference and $ConfirmPreference.)
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