<#
This script will create .reg files that will contain the DSV printer settings that will be removed by the
Remove-DsvPrinter_as_administrator.ps1 script.
#>

# Show Write-Verbose statements
$VerbosePreference = "Continue"

$BACKUP_FOLDER = 'Backup\Administrator'

if (-Not (Test-Path $BACKUP_FOLDER)) {
    mkdir $BACKUP_FOLDER
}

function CreateBackupForAdministratorScript {
    if (Test-Path -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider' -PathType Container) {
        reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider' "$BACKUP_FOLDER\HKLM_SOFTWARE_Print_Providers.reg"
    }

    if (Test-Path -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Connections' -PathType Container) {
        reg export 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Connections' "$BACKUP_FOLDER\HKLM_SOFTWARE_Print_Connections.reg"
    }
}

CreateBackupForAdministratorScript