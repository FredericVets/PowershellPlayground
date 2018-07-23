<#
This script will create a .reg file that will contain the DSV printer settings that will be removed by the
Remove-DsvPrinter_as_system.ps1 script.
#>

# Show Write-Verbose statements
$VerbosePreference = "Continue"

$BACKUP_FOLDER = 'Backup'

if (-Not (Test-Path $BACKUP_FOLDER)) {
    mkdir $BACKUP_FOLDER
}

function CreateBackupForSystemScript {
    if (Test-Path -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM' -PathType Container) {
        reg export 'HKLM\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM' "$BACKUP_FOLDER\HKLM_SYSTEM_PRINTENUM.reg"
    }
}

CreateBackupForSystemScript