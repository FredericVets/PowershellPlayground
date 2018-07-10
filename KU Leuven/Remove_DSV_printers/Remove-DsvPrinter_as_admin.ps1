<#
Run as ADMINISTRATOR !!!

This will remove any references to the DSV print servers : \\dsv-p-prt01' and '\\dsv-s-prt in the 
'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\' registry path.

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

$hklmClientPrintProvider = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider'
if (Test-Path -Path $hklmClientPrintProvider) {
	Remove-Item -Path $hklmClientPrintProvider -Recurse -Confirm
}

$hklmConnections = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Connections'
Get-ChildItem $hklmConnections |
    ForEach-Object {
        if (-Not (DoesItemPropertyExist $_.PSPath 'Server')) {
            return
        }

        $printServer = Get-ItemPropertyValue -Path $_.PSPath -Name 'Server'
        if ($printServer -in $DSV_PRINT_SERVERS) {
            Remove-Item -Path $_.PSPath -Recurse -Confirm
        }
    }

# Restart the spooler service.
Get-Service Spooler | Start-Service