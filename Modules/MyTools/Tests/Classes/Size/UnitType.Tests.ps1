$here = Split-Path -Parent $MyInvocation.MyCommand.Path
# Remove the Tests directory.
$source = $here -replace '\\Tests', ''
# Get-Whatever.Tests.ps1 -> Get-Whatever.ps1
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '.Tests.', '.'

. "$source\$sut"

Describe 'Classes.Size.UnitType' {
    $unitType = [UnitType]::new('whatever', 'Si')
    
    It 'has the expected name' {
        $unitType.Name | Should BeExactly 'whatever'
    }
    It 'has the expected symbol' {
        $unitType.Symbol | Should BeExactly 'Si'
    }
    It 'has a correct ToString() representation' {
        $unitType | Should BeExactly 'whatever'
    }
}