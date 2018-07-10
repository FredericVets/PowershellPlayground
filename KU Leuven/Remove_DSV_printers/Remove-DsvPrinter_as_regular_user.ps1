<#
Run as REGULAR USER !!!

This will remove any references to the DSV print servers : \\dsv-p-prt01' and '\\dsv-s-prt in the 
'HKCU:\' hive.

Written by u0122713 @ 09/07/2018
#>

$DSV_PRINT_SERVERS = @('\\dsv-p-prt01', '\\dsv-s-prt')

<# 
Tests if a registry value exists. Supports wild cards in the name parameter.
#>
function DoesItemPropertyExist($Path, $Name) {
    if( -not (Test-Path -Path $Path -PathType Container) ) {
        return $false
    }

    $properties = Get-ItemProperty -Path $Path 
    if( -not $properties ) {
        return $false
    }

    $member = Get-Member -InputObject $properties -Name $Name
    if( $member ) {
        return $true
    }

    return $false
}

function RemoveItemPropertyThatStartsWithPrintServerName($Path) {
    foreach ($printServer in $DSV_PRINT_SERVERS) {
        if (DoesItemPropertyExist $Path "$printServer*") {
            Remove-ItemProperty -Path $Path -Name "$printServer*" -Confirm
        }
    }
}

Get-ChildItem "HKCU:\Printers\Connections\" |
    ForEach-Object {
        $printServer = Get-ItemPropertyValue -Path $_.PSPath -Name "Server"
        if ($printServer -in $DSV_PRINT_SERVERS) {
            Remove-Item -Path $_.PSPath -Recurse -Confirm
        }
    }

RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Printers\Settings'
RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Devices'
RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts'