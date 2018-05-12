Set-Location C:\Users\Frederic\Documents\PowershellProjects\PowershellPlayground

# Possibilities :
#    Export-Clixml
#    Export-Csv
Get-Process | Export-Clixml -Path ".\processes.xml"

# When the reference processes file is created, run the following to compare based on the Name Property.
#    Import-Clixml
#    Import-Csv
Compare-Object -ReferenceObject (Import-Clixml .\processes.xml) -DifferenceObject (Get-Process) -Property Name

#Get-Process | ConvertTo-Xml | Out-File -FilePath .\processes.csv
#Get-Process | ConvertTo-Csv | Out-File -FilePath .\processes.csv
#Get-Process | ConvertTo-Html -Property Name, Path | Out-File -FilePath .\processes.html
#Get-Process |ConvertTo-Json | Out-File -FilePath .\processes.json

Get-Service | Export-Csv -Path .\services.csv


Get-Service | Export-Clixml -Path services.xml

# Cast to an XmlDocument.
$servicesXml = [xml](Get-Content .\services.xml)
$servicesXml.GetType()

# Get data from the first Obj element
$servicesXml.Objs.Obj[0].Props.B
# Get data from _ALL_ the Obj elements
$servicesXml.Objs.Obj.Props.B