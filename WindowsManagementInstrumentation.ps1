get-wmiobject -class "win32_account" -namespace "root\cimv2" | sort caption | format-table caption, __CLASS, FullName

Get-WmiObject -Class "win32_logicaldisk" -Filter "deviceid='c:'" |
select PSComputerName, 
    DeviceID, 
    @{ n = "FreeGb"; e = { $_.FreeSpace / 1Gb }  }, 
    @{ n = "SizeGb"; e = { $_Size / 1Gb }  }