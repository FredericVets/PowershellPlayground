<#
.Synopsis
Suspends or hibernates the system, or requests that the system be suspended or hibernated.
.Parameter PowerState
A PowerState indicating the power activity mode to which to transition (Hibernate, Suspend).
.Parameter DisableWake
true to disable restoring the system's power status to active on a wake event, false to enable restoring the system's 
power status to active on a wake event.
.Parameter Force
true to force the suspended mode immediate.
false to cause Windows to send a suspend request to every application.
.Example
Set-PowerState -PowerState Suspend -WhatIf -Verbose
VERBOSE: PowerState = Suspend
VERBOSE: DisableWake = False
VERBOSE: Force = False
What if: Performing the operation "Changing powerState to Suspend." on target "HP-PAVILION".
.Example
Set-PowerState -PowerState Hibernate -DisableWake -Force -WhatIf -Verbose
VERBOSE: PowerState = Hibernate
VERBOSE: DisableWake = True
VERBOSE: Force = True
What if: Performing the operation "Changing powerState to Hibernate." on target "HP-PAVILION".
.Notes
If an application does not respond to a suspend request within 20 seconds, Windows determines that it is in a 
non-responsive state, and that the application can either be put to sleep or terminated. Once an application responds to 
a suspend request, however, it can take whatever time it needs to clean up resources and shut down active processes.
.Link
https://stackoverflow.com/questions/20713782/suspend-or-hibernate-from-powershell
.Link
https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms.application.setsuspendstate?view=netframework-4.6.1
#>
function Set-PowerState {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    Param(
        [Parameter(Mandatory=$true)]
        [System.Windows.Forms.PowerState]
        $PowerState,
        [switch]
        $DisableWake=$false,
        [switch]
        $Force=$false
    )
    Process {
        Write-Verbose "PowerState = $PowerState"
        Write-Verbose "DisableWake = $DisableWake"
        Write-Verbose "Force = $Force"

        $computerName = $env:COMPUTERNAME
        if ($PSCmdlet.ShouldProcess($computerName, "Changing powerState to $PowerState.")) {
            [System.Windows.Forms.Application]::SetSuspendState($PowerState, $Force, $DisableWake)
        }
    }
}

<#
.Synopsis
Just a wrapper function for Set-PowerState -PowerState Suspend
Since aliases can't include parameters.
.Link
Set-PowerState
#>
function Suspend-Computer {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    Param(
        [switch]
        $DisableWake=$false,
        [switch]
        $Force=$false
    )
    Process {
        Set-PowerState -PowerState Suspend -DisableWake:$DisableWake -Force:$Force
    }
}

<#
.Synopsis
Just a wrapper function for Set-PowerState -PowerState Hibernate
Since aliases can't include parameters.
.Link
Set-PowerState
#>
function Hibernate-Computer {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    Param(
        [switch]
        $DisableWake=$false,
        [switch]
        $Force=$false
    )
    Process {
        Set-PowerState -PowerState Hibernate -DisableWake:$DisableWake -Force:$Force
    }
}