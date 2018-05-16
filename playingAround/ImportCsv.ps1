<# The difference between "Constant" and "ReadOnly" is that a read-only variable can be removed (and then re-created) via
    Remove-Variable test -Force
    whereas a constant variable can't be removed (even with -Force).
#>
Set-Variable CSV_FILE -Option ReadOnly -Value ".\input.csv"
$data = Import-Csv $CSV_FILE -Delimiter ';'

$totalNumber = 0
$data |
ForEach-Object {
    Write-Host "Name: " $_.Name -ForegroundColor $_.Color
    $totalNumber += $_.Number
}

"Total number: $totalNumber"