$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '.Tests.', '.'

. "$here\$sut"

Describe 'PrefixType' {
    $p = [PrefixType]::new('whatever', 1024)

    It 'detects a binary prefix type' {
        $p.IsBinary() | should be $true
    }
    It "doesn't detect a decimal prefix type" {
        $p.IsDecimal() | should be $false
    }
    It 'has a correct ToString() representation' {
        $p | should be 'whatever'
    }
}