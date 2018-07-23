<#
This script will create multiple .reg files that contain the DSV printer settings that will be removed by the 3 scripts.

Written by u0122713 @ 23/07/2018

// TODO : split up in 3 different scripts that should be run as the regular user, system or administrator.
#>

# Show Write-Verbose statements
$VerbosePreference = "Continue"

function CreateBackupForSystemScript {
    if (Test-Path -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM' -PathType Container) {
        reg export 'HKLM\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM' 'HKLM_SYSTEM_PRINTENUM.reg'
    }
}

function CreateBackupForAdministratorScript {
    if (Test-Path -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider' -PathType Container) {
        reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider' 'HKLM_SOFTWARE_Print_Providers.reg'
    }

    if (Test-Path -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Connections' -PathType Container) {
        reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Connections' 'HKLM_SOFTWARE_Print_Connections.reg'
    }
}

function CreateBackupForUserScript {
    if (Test-Path -LiteralPath 'HKCU:\Printers\Connections\' -PathType Container) {
        reg export 'HKCU\Printers\Connections\' 'HKCU_Printers_Connections.reg'
    }

    if (Test-Path -LiteralPath 'HKCU:\Printers\Settings' -PathType Container) {
        reg export 'HKCU\Printers\Settings' 'HKCU_Printers_Settings.reg'
    }

    if (Test-Path -LiteralPath 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Devices' -PathType Container) {
        reg export 'HKCU\Software\Microsoft\Windows NT\CurrentVersion\Devices' 'HKCU_Software_Devices.reg'
    }

    if (Test-Path -LiteralPath 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts' -PathType Container) {
        reg export 'HKCU\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts' 'HKCU_Software_PrinterPorts.reg'
    }
}

CreateBackupForSystemScript
CreateBackupForAdministratorScript
CreateBackupForUserScript