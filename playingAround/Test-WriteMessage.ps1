<#
Stream #	Description	        Introduced in
1	        Success Stream	    PowerShell 2.0
2	        Error Stream	    PowerShell 2.0
3	        Warning Stream	    PowerShell 3.0
4	        Verbose Stream	    PowerShell 3.0
5	        Debug Stream	    PowerShell 3.0
6	        Information Stream	PowerShell 5.0
*	        All Streams	        PowerShell 3.0

see Get-Help about_redirection
#>


# Write-Host is the same as Write-Information since PowerShell 5.0
# Only success, error and warning are shown by default.
$VerbosePreference = "Continue"
$InformationPreference = "Continue"

function Foo {
    Write-Warning "inner warning"
    Write-Verbose "inner verbose"
    Write-Information "inner information"
}

Write-Warning "inner warning"
Write-Verbose "inner verbose"
Write-Information "outer information"

Foo