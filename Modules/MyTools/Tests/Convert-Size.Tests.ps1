# Tests the exported function Convert-Size.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = Resolve-Path "$here\..\*\*.psd1"

Describe 'MyTools.Convert-Size exported function' {
    Import-Module -Name $module
    
    Context 'with default precision' {
        It 'converts 8 bit to B (byte)' {
            $actual = Convert-Size -Value 8 -From b -To B 
            $actual | Should Be 1
        }
        It 'converts 1 GiB to KiB' {
            $actual = Convert-Size -Value 1 -From GiB -To KiB
            $actual | Should Be 1048576
        }
    }
    Context 'with precision of 6' {
        It 'converts 1 MiB to MB' {
            $actual = Convert-Size -Value 1 -From MiB -To MB -Precision 6
            $actual | Should Be 1.048576
        }
        It 'converts 1 Kib to b (bit)' {
            $actual = Convert-Size -Value 1 -From Kib -to b -Precision 6
            $actual | Should Be 1024
        }
    }
}