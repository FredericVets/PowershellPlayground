$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceSUTs = Resolve-Path "$here\..\..\SourceSubjectsUnderTest.ps1"

Describe 'Classes.Size.PrefixType' {
    . $sourceSUTs
    . SourceClasses

    $prefixType = [PrefixType]::new('whatever', 1024)

    It 'has the expected name' {
        $prefixType.Name | Should BeExactly 'whatever'
    }
    It 'has the expected base' {
        $prefixType.Base | Should Be 1024
    }
    It 'detects a binary prefix type' {
        $prefixType.IsBinary() | Should Be $true
    }
    It "doesn't detect a decimal prefix type" {
        $prefixType.IsDecimal() | Should Be $false
    }
    It 'has a correct ToString() representation' {
        $prefixType | Should BeExactly 'whatever'
    }
}