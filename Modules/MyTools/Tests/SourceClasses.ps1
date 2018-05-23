$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host "Sourcing classes."

. "$here\..\Classes\Size\PrefixType.ps1"
. "$here\..\Classes\Size\UnitType.ps1"
. "$here\..\Classes\Size\Prefix.ps1"
. "$here\..\Classes\Size\Unit.ps1"

Write-Host 'Classes are sourced.'