function Test-Function {
    [CmdletBinding()]
    Param(
        $Bla
    )

    Get-Item -Path ".\IDontExist"
    Write-Output "Finished"
}

<#
Test-Function -ErrorAction SilentlyContinue
Test-Function -ErrorAction Continue # The default
Test-Function -ErrorAction Inquire
Test-Function -ErrorAction Ignore
Test-Function -ErrorAction Stop
Test-Function -ErrorAction Suspend  # Only in Workflow
#>