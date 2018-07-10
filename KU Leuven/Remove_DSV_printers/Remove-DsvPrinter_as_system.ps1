<#
Run as SYSTEM !!!
(Use ".\PsExec.exe -i -s PowerShell.exe" to start a Powershell session as the System user).

This will remove any references to the DSV print servers : \\dsv-p-prt01' and '\\dsv-s-prt in the 
'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM' registry path.

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

# Stop the spooler service.
Get-Service Spooler | Stop-Service

Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM' |
    ForEach-Object {
        if (-Not (DoesItemPropertyExist $_.PSPath 'FriendlyName')) {
            return
        }

	    $friendlyName = Get-ItemPropertyValue -Path $_.PSPath -Name 'FriendlyName'
        foreach ($printServer in $DSV_PRINT_SERVERS) {
            if ($friendlyName -like "$printServer*") {
                Remove-Item -Path $_.PSPath -Recurse -Confirm
            }
        }
    }

# Restart the spooler service.
Get-Service Spooler | Start-Service