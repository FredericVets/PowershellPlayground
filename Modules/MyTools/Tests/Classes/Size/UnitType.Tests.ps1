$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceSUTs = Resolve-Path "$here\..\..\SourceSubjectsUnderTest.ps1"

. $sourceSUTs
. SourceClasses

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