# See : https://superuser.com/questions/248315/list-of-hidden-virtual-windows-user-accounts

# Standard Win32_Accounts.
# The usual users, groups and builtin accounts.
get-wmiobject -class "win32_account" -namespace "root\cimv2" | 
	sort caption | 
	format-table caption, __CLASS, FullName

# Windows Service Accounts (also called virtual accounts)
get-service | foreach {Write-Host NT Service\$($_.Name)}

# IIS Application Pools
Get-WebConfiguration system.applicationHost/applicationPools/* /* | 
	where {$_.ProcessModel.identitytype -eq 'ApplicationPoolIdentity'} | 
	foreach {Write-Host IIS APPPOOL\$($_.Name)}

# Hyper-V Virtual Machines
get-vm | 
	foreach {Write-Host NT VIRTUAL MACHINE\$($_.Id) - $($_.VMName)}

# Desktop Window Manager
# The dwm.exe process (Desktop Window Manager) runs under a user Windows Manager\DWM-1

