$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)

. "$here\..\..\SourceClasses.ps1"

Describe 'Classes.Size.Unit' {
    $u = [Unit]::new(
        [Prefix]::new(
            'kibi', 
            'Ki', 
            1,
            [PrefixType]::new('Binary', 1024)
        ),
        [unitType]::new('byte', 'B')
    )
    It 'detects the prefix' {
        $u.HasPrefix() | Should Be $true
    }
    It 'detects a binary prefix type' {
        $u.IsBinary() | Should Be $true
    }
    It "doesn't detect a decimal prefix type" {
        $u.IsDecimal() | Should Be $false
    }
    It 'is meaningful for 1' {
        $u.IsMeaningfulFor(1) | Should Be $true
    }
    It 'is meaningful for 1000' {
        $u.IsMeaningfulFor(1000) | Should Be $true
    }
    It 'is not meaningful for 1024' {
        $u.IsMeaningfulFor(1024) | Should Be $true
    }
    It 'has a correct ToString() representation' {
        $u | should be 'KiB'
    }
}