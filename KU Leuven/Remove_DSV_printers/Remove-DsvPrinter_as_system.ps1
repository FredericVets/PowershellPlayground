<#
Run as SYSTEM !!!
(Use ".\PsExec.exe -i -s PowerShell.exe" to start a Powershell session as the System user).

This will remove any references to the DSV print servers : 'dsv-p-prt01' and 'dsv-s-prt' in the 
'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM' registry hive.

Written by u0122713 @ 09/07/2018
#>

$DSV_PRINT_SERVERS = @('dsv-p-prt01', 'dsv-s-prt')

<# 
Tests if a registry value exists. Supports wild cards in the PropertyName parameter.
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

function CleanUpPrintEnum() {
    $hklmPrinterEnum = 'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM'
    if (-Not (Test-Path -LiteralPath $hklmPrinterEnum -PathType Container)) {
        return
    }

    Write-Verbose "Cleaning up : $hklmPrinterEnum"

    Get-ChildItem $hklmPrinterEnum |
    ForEach-Object {
        if (-Not (DoesItemPropertyExist $_.PSPath 'FriendlyName')) {
            return
        }

        $friendlyName = Get-ItemPropertyValue -LiteralPath $_.PSPath -Name 'FriendlyName'
        foreach ($printServer in $DSV_PRINT_SERVERS) {
            if ($friendlyName -like "\\$printServer*") {
                Remove-Item -LiteralPath $_.PSPath -Recurse -Verbose -Confirm
            }
        }
    }
}

# Stop the spooler service.
Stop-Service Spooler

CleanUpPrintEnum

# Restart the spooler service.
Start-Service Spooler