$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceClasses = Resolve-Path "$here\..\..\SourceClasses.ps1"

. $sourceClasses

Describe 'Classes.Size.Prefix' {
    $pt = [PrefixType]::new('whatever', 1024)
    $p = [Prefix]::new(
            'whatever', 
            'Si',
            1,
            $pt)

    It 'has the expected name' {
        $p.Name | Should BeExactly 'whatever'
    }
    It 'has the expected symbol' {
        $p.Symbol | Should BeExactly 'Si'
    }
    It 'has the expected exponent' {
        $p.Exponent | Should Be 1
    }
    It 'has the expected prefix type' {
        $p.PrefixType | Should Be $pt
    }
    It 'has a correct ToString() representation' {
        $p | Should BeExactly 'whatever'
    }
}