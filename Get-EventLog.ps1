$targetDate = [DateTime]::Today.AddDays(-1)

Get-EventLog -LogName System -EntryType Error | where TimeGenerated -GE $targetDate | select -Property *



Set-Alias -Name gel -Value Get-EventLog -Confirm
gel -LogName Application -EntryType Error | where TimeGenerated -GE $targetDate

gsv | sort Name | Format-Table -Property Name, DisplayName, Status -AutoSize
