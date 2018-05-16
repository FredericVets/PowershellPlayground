# Notice that a mere declaration is insufficient when using static typing. 
# You also have to assign values to the variable. 
# If the data types don’t match, PowerShell will throw an error.
[int[]] $a = 1, 2, 3, 4, 5, 6, 7, 8, 9

# More elegantly.
[int[]] $a = 1..9

# Under normal circumstances, you would want to avoid the additional effort of this notation. 
# However, it helps you understand why you can create an empty array in PowerShell with this command.
$colors = @()
$colors = 'red', 'green', 'yellow'

# Whether the output of a cmdLet is an array, can be tested like this :
(Get-Process) -is [array]

# If you only want to store specific properties in the variables, and not the entire output of the command, 
# you can filter the properties with the Select-Object:
$mac = Get-NetAdapter | select MacAddress

# Add elements to an array :
$colors += 'orange'

# Combine two arrays :
$combined = $colors + $a

# Accessing elements of an array :
$combined[0]
$combined[-1]
$combined[1, 4, 7]
$combined[2..6]
$combined[-1..-4]

# Finding elements. You don't have to itterate through them. You can apply various comparison operators directly to the array.
$colors -like '*ee*'
$colors -match 'e{2}'
$colors[1, 3] -match 'e{2}'

# Sort
$colors = $colors | Sort-Object

# Deleting
# Entire array :
Remove-Variable -Name colors
# No convincing solution exists for removing specific elements, you can filter and reassign.
$even = $a | where { $_ % 2 -eq 0 }