Const HKEY_CURRENT_USER = &H80000001

strComputer = "."

set objshell = createobject("wscript.shell")
 
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _ 
    strComputer & "\root\default:StdRegProv")
 
strKeyPath = "C:\Program Files\"

  strValueName = "Install Name Program"

oReg.GetExpandedStringValue HKEY_CURRENT_USER,strKeyPath,strValueName,strValue
 
if isnull(strvalue) Then
   objshell.run "\\domain.local\netlogon\install.msi /quiet"
Else
   Wscript.Echo  "O Valor da variavel é: " & strValue
End if
