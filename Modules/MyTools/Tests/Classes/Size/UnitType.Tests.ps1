$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '.Tests.', '.'

. "$here\$sut"

Describe 'UnitType' {
    $u = [UnitType]::new('whatever', 'si')
    
    It 'has a correct ToString() representation' {
        $u | should be 'whatever'
    }
}