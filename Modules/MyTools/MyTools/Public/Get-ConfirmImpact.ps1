<#
.Synopsis
If present, displays the value of the ConfirmImpact property of the cmdLet binding metadata attribute.
.Link
http://tahirhassan.blogspot.be/2017/01/powershell-get-confirmimpact-function.html
#>
Function Get-ConfirmImpact {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]$Command
    )
    
    Begin {
        $ErrorActionPreference = 'Stop';
    }
    
    Process {
        $commandObj = (Get-Command $Command);
        
        if ($commandObj.CommandType -eq 'Alias') {
            return Get-ConfirmImpact $commandObj.Definition;
        }

        $attrs = if ($commandObj.ImplementingType) {
            $commandObj.ImplementingType.GetCustomAttributes($true);
        } elseif ($commandObj.ScriptBlock) {
            $commandObj.ScriptBlock.Attributes
        }
        
        $attrs | 
            Where-Object { $_ -is [System.Management.Automation.CmdletCommonMetadataAttribute] } | 
            ForEach-Object ConfirmImpact;
    }
}