<#
.Synopsis
Returns your publicly visible ip address. For this it uses the ipify.org service.
.Link
https://www.ipify.org/
#>
function Get-MyPublicIP {
    [CmdLetBinding()]
    Param()

    Begin {
        $URL = 'https://api.ipify.org?format=json'
    }
    Process {
        $response = Invoke-WebRequest -Uri $URL -Method Get
        $parsed = ConvertFrom-Json $response.Content

        return $parsed.ip
    }
}