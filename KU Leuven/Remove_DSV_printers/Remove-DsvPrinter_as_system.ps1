<#
Run as SYSTEM !!!
(Use ".\PsExec.exe -i -s PowerShell.exe" to start a Powershell session as the System user).

This will remove any references to the DSV print servers : 'dsv-p-prt01' and 'dsv-s-prt' in the 
'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM' registry hive.

Written by u0122713 @ 09/07/2018
#>

# Show Write-Verbose statements
$VerbosePreference = "Continue"

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

<# Helper function to easily switch between -Confirm (for testing) or -Verbose behaviour.
Rest of the script call this function.  #>
function My-RemoveItem([string]$LiteralPath, [bool]$Recurse) {
    #Remove-Item -LiteralPath $LiteralPath -Recurse:$Recurse -Confirm

    Remove-Item -LiteralPath $LiteralPath -Recurse:$Recurse -Verbose
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
                My-RemoveItem $_.PSPath $true
            }
        }
    }
}

Stop-Service Spooler

CleanUpPrintEnum

Start-Service Spooler