<#
.Synopsis
A wrapper function around the Get-WmiObject cmdLet.
#>
function Get-MyWmiObject{
    [CmdletBinding()]
    Param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Enter the computer name.")]
        [ValidateNotNullOrEmpty()]
        [string]
        $ComputerName,
        [Parameter(
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Enter the primary disk.")]
        [ValidatePattern("^[a-zA-Z]:$")]
        [string]
        $PrimaryDisk
    )
    Begin { Write-Verbose "< Beginning." }
    Process {
        # TODO : Grab 'win32_OperatingSystem', add a switch for this, lose the $PrimaryDisk parameter (change to switch?).
        # Change ComputerName to Array.
        Write-Verbose "Processing."
        
        Write-Verbose "Getting win32_Bios data."
        $bios = Get-WmiObject -Class "win32_Bios"
        #With or without [Ordered]
        $props = @{
            "SerialNumber" = $bios.SerialNumber
            "Version" = $bios.Version
        }
        
        if ($PrimaryDisk) {
            Write-Verbose "Getting win32_LogicalDisk data."
            $logicalDisk = Get-WmiObject -Class "win32_LogicalDisk" -Filter "deviceId='$PrimaryDisk'"

            $freeSpaceGb = $logicalDisk.FreeSpace / 1Gb
            $totalSpaceGb = $logicalDisk.Size / 1Gb

            $props.Add("FreeSpaceGb", $freeSpaceGb.ToString("N2"))
            $props.Add("TotalSpaceGb", $totalSpaceGb.ToString("N2"))
        }
        
        $obj = New-Object -TypeName PSObject -Property $props
        Write-Output $obj
    }
    End { Write-Verbose "/> Ending." }
}

<# Some test code. #>
Write-Host "Testing ByValue." -ForegroundColor Blue
$list = "localhost", "HP-Pavilion"
$list | Get-MyWmiObject -Verbose

Write-Host "Testing ByPropertyName with the ComputerName property." -ForegroundColor Blue
$obj = New-Object -TypeName PSObject -Property @{ 'ComputerName' = 'HP-Pavilion' }
$obj, $obj | Get-MyWmiObject -Verbose

Write-Host "Testing ByPropertyName with both 2 property." -ForegroundColor Blue
$obj = New-Object -TypeName PSObject -Property @{ 
    'ComputerName' = 'localhost'
    'PrimaryDisk' = 'c:' }
$obj, $obj | Get-MyWmiObject -Verbose

$array1 = $obj, $obj, $obj
$array2 = @($obj, $obj, $obj)
$array1.GetType()   # Object[]
$array2.GetType()   # Object[]
$array1 | Get-Member -Name ComputerName
$array2.ComputerName | Get-Member -Name ComputerName