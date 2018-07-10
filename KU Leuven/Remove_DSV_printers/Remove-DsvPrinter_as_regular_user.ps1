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

<# Helper function to easily switch between -Confirm (for testing) or -Verbose behaviour.
Rest of the script call this function.  #>
function My-RemoveItem([string]$LiteralPath, [bool]$Recurse) {
    #Remove-Item -LiteralPath $LiteralPath -Recurse:$Recurse -Confirm

    Remove-Item -LiteralPath $LiteralPath -Recurse:$Recurse -Verbose
}

function My-RemoveItemProperty([string]$LiteralPath, [string]$Name) {
    #Remove-ItemProperty -LiteralPath $LiteralPath -Name $Name -Confirm

    Remove-ItemProperty -LiteralPath $LiteralPath -Name $Name -Verbose
}

function RemoveItemPropertyThatStartsWithPrintServerName($LiteralPath) {
    Write-Verbose "Cleaning up : $LiteralPath"

    foreach ($printServer in $DSV_PRINT_SERVERS) {
        if (DoesItemPropertyExist $LiteralPath "\\$printServer*") {
            My-RemoveItemProperty $LiteralPath "\\$printServer*"
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
                My-RemoveItem $_.PSPath $true
            }
        }
    }
}

CleanUpPrinterConnections
RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Printers\Settings'
RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Devices'
RemoveItemPropertyThatStartsWithPrintServerName 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts'