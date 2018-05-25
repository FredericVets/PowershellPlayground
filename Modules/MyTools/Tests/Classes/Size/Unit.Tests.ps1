$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceSUTs = Resolve-Path "$here\..\..\SourceSubjectsUnderTest.ps1"

Describe 'Classes.Size.Unit' {
    . $sourceSUTs
    . SourceClasses

    $prefix = [Prefix]::new(
        'kibi', 
        'Ki', 
        1,
        [PrefixType]::new('Binary', 1024))
    
    $unitType = [unitType]::new('byte', 'B')

    Context 'Unit with prefix' {
        $unit = [Unit]::new($prefix, $unitType)
        
        It 'has the expected prefix' {
            $unit.Prefix | Should Be $prefix
        }
        It 'has the expected unit type' {
            $unit.UnitType | Should Be $unitType
        }
        It 'has the expected name' {
            $unit.Name() | Should BeExactly 'kibibyte'
        }
        It 'has the expected symbol' {
            $unit.Symbol() | Should BeExactly 'KiB'
        }
        It 'detects the prefix' {
            $unit.HasPrefix() | Should Be $true
        }
        It 'detects a binary prefix type' {
            $unit.IsBinary() | Should Be $true
        }
        It "doesn't detect a decimal prefix type" {
            $unit.IsDecimal() | Should Be $false
        }

        It 'is meaningful for size 1' {
            $unit.IsMeaningfulFor(1) | Should Be $true
        }
        It 'is meaningful for size 1000' {
            $unit.IsMeaningfulFor(1000) | Should Be $true
        }
        It 'is not meaningful for size 1024' {
            $unit.IsMeaningfulFor(1024) | Should Be $true
        }

        It 'has a correct ToString() representation' {
            $unit | Should BeExactly 'KiB'
        }
    }
    Context 'Unit without prefix' {
        $unit = [Unit]::new($unitType)

        It 'has no prefix' {
            $unit.Prefix | Should BeNullOrEmpty
        }
        It 'has the expected unit type' {
            $unit.UnitType | Should Be $unitType
        }
        It 'has the expected name' {
            $unit.Name() | Should BeExactly 'byte'
        }
        It 'has the expected symbol' {
            $unit.Symbol() | Should BeExactly 'B'
        }
        It "doesn't detect the prefix" {
            $unit.HasPrefix() | Should Be $false
        }
        It "doesn't detect a binary prefix type" {
            $unit.IsBinary() | Should Be $false
        }
        It "doesn't detect a decimal prefix type" {
            $unit.IsDecimal() | Should Be $false
        }
    
        It 'is meaningful for size 1' {
            $unit.IsMeaningfulFor(1) | Should Be $true
        }
        It 'is meaningful for size 1000' {
            $unit.IsMeaningfulFor(1000) | Should Be $true
        }
        It 'is not meaningful for size 1024' {
            $unit.IsMeaningfulFor(1024) | Should Be $false
        }
    
        It 'has a correct ToString() representation' {
            $unit | Should BeExactly 'B'
        }     
    }
}