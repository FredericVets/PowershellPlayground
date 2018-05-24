$here = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Verbose 'Sourcing classes ...'

# Order matters!
. "$here\..\Classes\Size\PrefixType.ps1"
. "$here\..\Classes\Size\UnitType.ps1"
. "$here\..\Classes\Size\Prefix.ps1"
. "$here\..\Classes\Size\Unit.ps1"

Write-Verbose 'Classes are sourced.'