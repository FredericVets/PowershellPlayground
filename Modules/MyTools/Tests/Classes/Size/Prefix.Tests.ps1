$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '.Tests.', '.'

. "$here\PrefixType.ps1"
. "$here\$sut"

Describe 'Prefix' {
    It 'has a correct ToString() representation' {
        $p = [Prefix]::new(
            'whatever', 
            'si',
            1,
            [PrefixType]::new('whatever', 1024))

        $p | should be 'whatever'
    }
}