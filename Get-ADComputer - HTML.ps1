# HTML
Import-Module ActiveDirectory
$a = "<style>"
$a = $a + "BODY{font-family: Calibri, Arial, Helvetica, sans-serif; font-size:10;font-color: #000000}"
$a = $a + "TABLE{margin-left:auto;margin-right:auto;width: 800px;border-width: 1px;border-style:solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color: #F9F9F9;text-align:center;}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;text-align:center}"
$a = $a + "</style>"

#EXPORT
$b = "<center><font face='Calibri' size='5'>Relatório de Computadores Active Directory</font></center><br>"
Get-ADComputer -Filter * | select Name, Enabled |Sort Enabled, name| ConvertTo-Html -head $a -body $b | Out-File "C:\Get-ADComputer.html"