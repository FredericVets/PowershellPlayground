# Tests the exported function Get-SizeConverted.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = Resolve-Path "$here\..\*\*.psd1"

Describe 'MyTools.Get-SizeConverted exported function' {
    Import-Module -Name $module

    $testPath = 'TestDrive:\test.txt'
    # Create a file of 2600 bytes (B).
    for ($i = 0; $i -lt 100; $i++) {
        Add-Content -Path $testPath -Value 'random fskjfsjkfsdfjksff'
    }

    Context 'binary prefix type' {
        It 'shows only the meaningful unit' {
            $actual = Get-SizeConverted -LiteralPath $testPath -PrefixType Binary

            $actual.KiB | Should Be 2.5391
            $actual.LiteralPath | Should Be $testPath
        }
        It 'shows all the units' {
            $actual = Get-SizeConverted -LiteralPath $testPath -PrefixType Binary -ShowAllUnits

            $actual.B | Should Be 2600
            $actual.KiB | Should Be 2.5391
            $actual.MiB | Should Be .0025
            $actual.GiB | Should Be 0
            $actual.TiB | Should Be 0
            $actual.PiB | Should Be 0
            $actual.EiB | Should Be 0
            $actual.ZiB | Should Be 0
            $actual.YiB | Should Be 0
            $actual.LiteralPath | Should Be $testPath
        }
    }
    Context 'decimal prefix' {
        It 'shows only the meaningful unit' {
            $actual = Get-SizeConverted -LiteralPath $testPath -PrefixType Decimal

            $actual.KB | Should Be 2.6
            $actual.LiteralPath | Should Be $testPath
        }
        It 'shows all the units' {
            $actual = Get-SizeConverted -LiteralPath $testPath -PrefixType Decimal -ShowAllUnits

            $actual.B | Should Be 2600
            $actual.KB | Should Be 2.6
            $actual.MB | Should Be .0026
            $actual.GB | Should Be 0
            $actual.TB | Should Be 0
            $actual.PB | Should Be 0
            $actual.EB | Should Be 0
            $actual.ZB | Should Be 0
            $actual.YB | Should Be 0
            $actual.LiteralPath | Should Be $testPath
        }
    }
}