# 1. ByValue
# 2. ByPropertyName
# 3. What if my property doesn't match - Customize it.
# 4. The parenthetical - when all else fails
# See Get-Help about_pipelines
# See video : https://youtu.be/kmYd522ydkU?list=PLsrZV8shpwjMXYBmmGodMMQV86xsSz1si

# ByValue example :
# -----------------
Get-Process | Stop-Process -WhatIf

# ByPropertyName example :
# ------------------------
# Start calc.exe
Get-Process -Name Calculator | Get-ChildItem
# gci shows the executable's file system location.
# How so?
#     -> Get-Process returns System.Diagnostics.Process instances, these have a Path property.
#     -> Get-ChildItem has a -Path parameter (of type string), which accepts pipeline input ByValue and ByPropertyName.
#     -> ByValue isn't going to work because Process instances are pushed into the pipe and they don't match.
#        Get-ChildItem only accepts ByValue for the -Path parameter and it must be strings.
#     -> ByProperty will connect the -Path parameter.
#     -> Get-ChildItem shows the output.

# NoteProperty or calculated Property
#    Create a new property called Blabla, which maps to the existing Name property.
#    Use this for ByPropertyName binding when the PropertyName doesn't match the ParameterName.
Get-Process | select -Property @{ Name='Blabla'; Expression={$_.Name} }

# Don't return Selected.System.Diagnostics.Process instances, but strings.
Get-Process | select -ExpandProperty Name

Get-WmiObject -Class win32_bios -ComputerName 'HP-Pavilion'

# Get-WmiObject doesn't support the pipeline.
# But I want to pass in computernames ...
$computerInfo = Get-ComputerInfo
# Type : Microsoft.PowerShell.Commands.ComputerInfo
# ComputerInfo.LogonServer is the name of the computer prepended with \\

# Option 1 :
Get-WmiObject -Class win32_bios -ComputerName ($computerInfo | select -ExpandProperty LogonServer).SubString(2)
# Option 2 :
Get-WmiObject -Class win32_bios -ComputerName $computerInfo.LogonServer.Substring(2)
# Option 3 : with script parameter
# Takes the value of the current object and assigns it to $_
# See end of mentioned video.
_some_cmdLet_that_returns_ComputerInfo_objects_ | Get-WmiObject -Class win32_bios -ComputerName {$_.LogonServer.SubString(2)}