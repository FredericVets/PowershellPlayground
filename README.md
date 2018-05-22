# PowershellPlayground
In the Modules folder you'll find my modules.
### The MyTools module :
Contains some handy cmdLets that I think should be included by default.
* Get-Size : itterate through a directory and return the total size (in bytes).
* Convert-Size : converts a size from one unit to another. E.g. x KiB (kibibytes) -> y MB (megabytes)
* Get-SizeConverted : Combination of the 2 above. Supports the _-ShowOnlyRelevant_ switch, to automatically pick the most meaningful unit for that specific size.
* Update-File : the PowerShell equivalent of the unix touch command.
* Suspend-Computer and Hibernate-Computer : suspend / hibernate the local machine.
* Get-ConfirmImpact : displays the value of the ConfirmImpact property of the cmdLet binding metadata attribute.

See the cmdLet specific _Get-Help_ pages for detailed info.