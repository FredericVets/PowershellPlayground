$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$source = $here -replace '\\Tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '.Tests.', '.'

. "$source\$sut"

Describe 'Classes.Size.PrefixType' {
    $p = [PrefixType]::new('whatever', 1024)

    It 'detects a binary prefix type' {
        $p.IsBinary() | Should Be $true
    }
    It "doesn't detect a decimal prefix type" {
        $p.IsDecimal() | Should Be $false
    }
    It 'has a correct ToString() representation' {
        $p | Should Be 'whatever'
    }
}