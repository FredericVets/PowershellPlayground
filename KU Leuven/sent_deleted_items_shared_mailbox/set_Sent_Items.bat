@echo off

REM De verzonden en verwijderde items van de administratieve mailbox komen in mijn eigen mailbox ipv in de administratieve mailbox te blijven. 
REM Hoe los ik dit op?


REM The following script will fix this for Outlook 2016.
REM DelegateSentItemsStyle

powershell.exe -Command "IF (!(Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Office\16.0\outlook\preferences | Select-Object DelegateSentItemsStyle)) {New-ItemProperty -Path hkcu:\software\Microsoft\Office\16.0\Outlook\Preferences -PropertyType DWORD -Value 1 -name DelegateSentItemsStyle}"

powershell.exe -Command "IF (Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Office\16.0\outlook\preferences | Select-Object DelegateSentItemsStyle) {Set-ItemProperty -Path hkcu:\software\Microsoft\Office\16.0\Outlook\Preferences -Value 1 -name DelegateSentItemsStyle}"

echo Sent items fixed.


REM DelegateWastebasketStyle

powershell.exe -Command "IF (!(Get-Item hkcu:\software\Microsoft\Office\16.0\Outlook\Options\General -ErrorAction SilentlyContinue)) {New-Item -Path hkcu:\software\Microsoft\Office\16.0\Outlook\Options\General}"

powershell.exe -Command "IF (!(Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Office\16.0\outlook\Options\General | Select-Object DelegateWastebasketStyle)) {New-ItemProperty -Path hkcu:\software\Microsoft\Office\16.0\Outlook\Options\General -PropertyType DWORD -Value 4 -name DelegateWastebasketStyle}"

powershell.exe -Command "IF (Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Office\16.0\outlook\Options\General | Select-Object DelegateWastebasketStyle) {Set-ItemProperty -Path hkcu:\software\Microsoft\Office\16.0\Outlook\Options\General -Value 4 -name DelegateWastebasketStyle}"

echo Deleted items fixed.

pause
