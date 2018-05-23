$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$source = $here -replace '\\Tests', ''
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '.Tests.', '.'

. "$here\..\..\SourceClasses.ps1"
. "$source\$sut"

Describe 'Private.Size.Configuration.ValidateUnit' {
    It 'Returns true for valid unit' {
        ValidateUnit 'MiB' | Should Be $true
    }
    It 'Throws for invalid unit' {
        { ValidateUnit 'Bla' } | Should Throw
    }
}

Describe 'Private.Size.Configuration.GetUnitForName' {
    It 'Returns a unit for valid name' {
        $unit = GetUnitForName 'MiB'
        $unit | Should Not be $null
        $unit | Should BeOfType [Unit]
    }
    It 'Throws for invalid name' {
        { GetUnitForName 'Bla' } | Should Throw
    }
}

Describe 'Private.Size.Configuration.GetUnitsForUnitType' {
    $units = GetUnitsForUnitType ([UnitType]::BYTE)
    It 'Returns the expected type' {
        # Should BeOfType incorrectly asserts type and inconsistently processes type information : 
        # https://github.com/pester/Pester/issues/386
        $units | Should Not Be $null
        $units | Should BeOfType [Unit]
    }
    It 'Returns the expected number of units' {
        $units.Length | Should Be (8 + 8 + 1)
    }
}

Describe 'Private.Size.Configuration.GetUnitsForTypes' {
    $units = GetUnitsForTypes ([PrefixType]::BINARY) ([UnitType]::BYTE)
    It 'Returns the expected type' {
        $units | Should Not Be $null
        $units | Should BeOfType [Unit]
    }
    It 'Returns the expected number of units' {
        $units.Length | Should Be (8 + 1)
    }
}

Describe 'Private.Size.Configuration.GetAllUnitsAsString' {
    $s = GetAllUnitsAsString
    Write-Host $s
    It 'returns the expected value' {
        $s | Should BeExactly 'bit, byte, Kib, KiB, Mib, MiB, Gib, GiB, Tib, TiB, Pib, PiB, Eib, EiB, Zib, ZiB, Yib, YiB, Kb, KB, Mb, MB, Gb, GB, Tb, TB, Pb, PB, Eb, EB, Zb, ZB, Yb, YB'
    }
}