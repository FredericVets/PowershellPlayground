<#
This script will create .reg files that will contain the DSV printer settings that will be removed by the
Remove-DsvPrinter_as_regular_user.ps1 script.
#>

# Show Write-Verbose statements
$VerbosePreference = "Continue"

$BACKUP_FOLDER = 'Backup\User'

if (-Not (Test-Path $BACKUP_FOLDER)) {
    mkdir $BACKUP_FOLDER
}

function CreateBackupForUserScript {
    if (Test-Path -LiteralPath 'HKCU:\Printers\Connections\' -PathType Container) {
        reg export 'HKCU\Printers\Connections\' "$BACKUP_FOLDER\HKCU_Printers_Connections.reg"
    }

    if (Test-Path -LiteralPath 'HKCU:\Printers\Settings' -PathType Container) {
        reg export 'HKCU\Printers\Settings' "$BACKUP_FOLDER\HKCU_Printers_Settings.reg"
    }

    if (Test-Path -LiteralPath 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Devices' -PathType Container) {
        reg export 'HKCU\Software\Microsoft\Windows NT\CurrentVersion\Devices' "$BACKUP_FOLDER\HKCU_Software_Devices.reg"
    }

    if (Test-Path -LiteralPath 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts' -PathType Container) {
        reg export 'HKCU\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts' "$BACKUP_FOLDER\HKCU_Software_PrinterPorts.reg"
    }
}

CreateBackupForUserScript