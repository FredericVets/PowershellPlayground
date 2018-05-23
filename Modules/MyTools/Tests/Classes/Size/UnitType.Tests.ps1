$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$source = $here -replace '\\Tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '.Tests.', '.'

. "$source\$sut"

Describe 'Classes.Size.UnitType' {
    $u = [UnitType]::new('whatever', 'si')
    
    It 'has a correct ToString() representation' {
        $u | Should Be 'whatever'
    }
}