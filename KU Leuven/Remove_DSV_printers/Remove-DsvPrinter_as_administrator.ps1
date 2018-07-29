<#
Run as ADMINISTRATOR !!!

This will remove any references to the DSV print servers : 'dsv-p-prt01' and 'dsv-s-prt' in the 
'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\' registry hive.

Written by u0122713 @ 09/07/2018
#>

# Show Write-Verbose statements
$VerbosePreference = 'Continue'

$DSV_PRINT_SERVERS = @('dsv-p-prt01', 'dsv-s-prt')

<#
Tests if a registry value exists. Supports wild cards in the name PropertyName parameter.
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

<#
Registry structure :
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider\
    sid
    ...
    sid
        Printers
            Connections
                ,,ICTS-S-PRT1.luna.kuleuven.be,CRD.PRT00770 (example)
    Servers
        dsv-p-prt01.luna.kuleuven.be                        (example)
#>
function CleanUpClientSideRendering() {
    $hklmClientPrintProvider = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider'
    if (-Not (Test-Path -LiteralPath $hklmClientPrintProvider -PathType Container)) {
        return
    }

    Write-Verbose "Cleaning up : $hklmClientPrintProvider"

    Get-ChildItem $hklmClientPrintProvider |
    ForEach-Object {
        if ($_.Name -like '*\Servers') {
            Write-Verbose "Cleaning up : $($_.Name)"

            Get-ChildItem $_.PSPath |
            ForEach-Object {
                Write-Verbose "Cleaning up : $($_.Name)"
                foreach ($p in $DSV_PRINT_SERVERS) {
                    if ($_.Name -like "*$p*") {
                        My-RemoveItem $_.PSPath $true
                    }
                }

                return
            }
        }

        # Check the different sid subfolders.
        if (-not (Test-Path -LiteralPath "$($_.PSPath)\Printers\Connections" -PathType Container)) {
            return
        }

        Get-ChildItem "$($_.PSPath)\Printers\Connections" |
        ForEach-Object {
            Write-Verbose "Cleaning up : $($_.Name)"
            foreach ($p in $DSV_PRINT_SERVERS) {
                if ($_.Name -like "*$p*") {
                    My-RemoveItem $_.PSPath $true
                }
            }
        }
    }
}

function CleanUpPrintConnections() {
    $hklmConnections = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Connections'
    if (-Not (Test-Path -LiteralPath $hklmConnections -PathType Container)) {
        return
    }

    Write-Verbose "Cleaning up : $hklmConnections"
    Get-ChildItem $hklmConnections |
    ForEach-Object {
        if (-Not (DoesItemPropertyExist $_.PSPath 'Server')) {
            return
        }

        $printServer = Get-ItemPropertyValue -LiteralPath $_.PSPath -Name 'Server'
        foreach ($p in $DSV_PRINT_SERVERS) {
            if ($printServer -like "*$p*") {
                My-RemoveItem $_.PSPath $true
            }
        }
    }
}

Stop-Service Spooler

CleanUpClientSideRendering
CleanUpPrintConnections

Start-Service Spooler
