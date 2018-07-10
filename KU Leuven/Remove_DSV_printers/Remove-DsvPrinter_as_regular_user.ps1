<#
Run as REGULAR USER !!!

This will remove any references to the DSV print servers : 'dsv-p-prt01' and 'dsv-s-prt' in the 
'HKCU:\' registry hive.

Written by u0122713 @ 09/07/2018
#>

$DSV_PRINT_SERVERS = @('dsv-p-prt01', 'dsv-s-prt')

<# 
Tests if a registry value exists. Supports wild cards in the name parameter.
#>
function DoesItemPropertyExist([string]$LiteralPath, [string]$PropertyName) {
    if( -not (Test-Path -LiteralPath $LiteralPath -PathType Container) ) {
        return $false
    }

    $properties = Get-ItemProperty -LiteralPath $LiteralPath 
    if( -not $properties ) {
        return $false
    }

    $member = Get-Member -InputObject $properties -Name $PropertyName
    if( $member ) {
        return $true
    }

    return $false
}

function RemoveItemPropertyThatStartsWithPrintServerName($LiteralPath) {
    Write-Verbose "Cleaning up : $LiteralPath"

    foreach ($printServer in $DSV_PRINT_SERVERS) {
        if (DoesItemPropertyExist $LiteralPath "\\$printServer*") {
            Remove-ItemProperty -LiteralPath $LiteralPath -Name "\\$printServer*" -Verbose -Confirm
        }
    }
}

function CleanUpPrinterConnections() {
    $hkcuConnections = 'HKCU:\Printers\Connections\'
    if (-Not (Test-Path -LiteralPath $hkcuConnections -PathType Container)) {
        return
    }

    Write-Verbose "Cleaning up : $hkcuConnections"

    Get-ChildItem $hkcuConnections |
    ForEach-Object {
        $printServer = Get-ItemPropertyValue -LiteralPath $_.PSPath -Name "Server"
        foreach ($p in $DSV_PRINT_SERVERS) {
            if ($printServer -like "\\$p*") {
                Remove-Item -LiteralPath $_.PSPath -Recurse -Verbose -Confirm
            }
        }
    }
}

CleanUpPrinterConnections
RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Printers\Settings'
RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Devices'
RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts'