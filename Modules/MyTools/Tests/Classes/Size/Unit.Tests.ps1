$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '.Tests.', '.'

. "$here\PrefixType.ps1"
. "$here\UnitType.ps1"
. "$here\Prefix.ps1"
. "$here\$sut"

Describe "Unit" {
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
        $u.HasPrefix() | should be $true
    }
    It 'detects a binary prefix type' {
        $u.IsBinary() | should be $true
    }
    It "doesn't detect a decimal prefix type" {
        $u.IsDecimal() | should be $false
    }
    It 'is meaningful for 1' {
        $u.IsMeaningfulFor(1) | should be $true
    }
    It 'is meaningful for 1000' {
        $u.IsMeaningfulFor(1000) | should be $true
    }
    It 'is not meaningful for 1024' {
        $u.IsMeaningfulFor(1024) | should be $true
    }
    It 'has a correct ToString() representation' {
        $u | should be 'KiB'
    }
}