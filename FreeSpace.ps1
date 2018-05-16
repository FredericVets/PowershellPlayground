function GetSpaceInGb([System.Management.Automation.PSDriveInfo]$drive)
{
    # return an array
    # return @($usedGb, $freeGb, $totalGb)
    # return a tuple
    # return [System.Tuple]::Create($usedGb, $freeGb, $totalGb)

    # return Hashable
    return @{ 
        "Used" = $drive.Used / 1Gb;
        "Free" = $drive.Free / 1Gb;
        "Total" = ($drive.Free + $drive.Used) / 1Gb }
}

Get-PSDrive |
where { $_.Free -gt 1 } |
ForEach-Object { $totalFree = 0 } { 
    $spaceInGb = GetSpaceInGb $_
    $_.Name + ": Used: {0:N2} Free: {1:N2} Total: {2:N2}" -f $spaceInGb.Used, $spaceInGb.Free, $spaceInGb.Total
    $totalFree += $_.Free 
} { "Total Free Space: {0:N2}" -f ($totalFree / 1Gb) }