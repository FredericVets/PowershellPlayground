# Tests the exported function Get-Size.
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$module = Resolve-Path "$here\..\*\*.psd1"

Describe 'MyTools.Get-Size exported function' {
    Import-Module -Name $module

    $testPath = 'TestDrive:\test.txt'
    Set-Content -Path $testPath -Value 'random fskjfsjkfsdfjksff'

    It 'gets the expected size in bytes' {
        $actual = Get-Size -LiteralPath $testPath
        $actual | Should Be 26
    }
}