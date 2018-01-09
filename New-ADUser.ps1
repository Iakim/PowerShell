###########################################################################
# NOME: Cria��o de Conta no AD e Exchange
# AUTOR: Isaac de Moraes
# COMENT�RIO: Este script faz a cria��o de usuarios no Active Directory
# e no Exchange
# HIST�RICO DE VERS�O: 1.0
# 1.0 | 02/06/2017 - Vers�o inicial - Isaac de Moraes
############################################################################
## Ser� solicitado usu�rio e senha
## Para que a credencial funcione ser� necess�rio liberar* o servidor a ser 
## acessado, com o comando "Enable-PSRemoting -Force", "Set-Item 
## WSMan:\localhost\client\TrustedHosts [IP do servidor a s er liberado]",
## e "Restart-Service WinRM". *O Windows Server 2012 j� vem com a libera��o.
############################################################################

# Importando m�dulo Active Directory

Import-Module ActiveDirectory

# Armazenando usu�rios listados em New-ADUserUsers.csv

$CreateUser = Import-Csv "C:\PowerShell\New-ADUserUsers.csv"

# Para cada usu�rios armazenado na vari�vel $CreateUser, sera criado o usuario no  Active Directory.

$CreateUser | ForEach-Object {

    New-ADUser -Path 'OU=Usuarios,DC=contoso,DC=com,DC=br' -SamAccountName $_.Loginpre -UserPrincipalName $_.Login -DisplayName $_.DN -GivenName $_.FirstName -Name $_.Name -Surname $_.LastName -Office $_.OfficeName -Description $_.Description -Company $_.Company -Department $_.Department -Title $_.Title -OfficePhone $_.Phone -AccountPassword (ConvertTo-SecureString -AsPlainText $_.Password -Force) -ChangePasswordAtLogon $True -Enabled $True

}

# Importa-se o arquivo New-ADUserUsers.csv para a vari�vel extension

$extension = Import-Csv "C:\PowerShell\New-ADUserUsers.csv"

# Para cada indece armazenado na vari�vel $extension fa�a o retorno do usuario � modifica  sua extens�o.

$extension | ForEach-Object {

    $Attribute1 = Get-ADUser -Identity $_.Loginpre -Properties extensionAttribute1
    Set-ADUser -Identity $Attribute1 -Add @{"extensionAttribute1"="Normal"} 

}

# Importa-se o arquivo New-ADUserUsers.csv para a vari�vel $Group

$Group = Import-Csv "C:\PowerShell\New-ADUserUsers.csv"

# Vetor com duas posi�oes, aramzenado as seguintes strings "grupo1","grupo2"

$Folder = @("grupo1","grupo2")

# Para cada objeto armazenado na vari�vel $Group adiciona os sequinte grupos equipeabdi, 
# equipeabdiinterna que correspondem respectivamente a Folder[0], Folder[1]

$Group | ForEach-Object {

    ADD-ADGroupMember -Identity $Folder[0] -Members $_.Loginpre
    ADD-ADGroupMember -Identity $Folder[1] -Members $_.Loginpre

}
# Inicia-se uma sess�o com http://excserver.com.br/PowerShell/

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://excserver.com.br/PowerShell/ -Authentication Kerberos -Credential domain\

# Importa para vari�vel sess�o

Import-PSSession $Session

# Importa-se o arquivo New-ADUserUsers.csv para a vari�vel $MailUser

$MailUser = Import-Csv "C:\PowerShell\New-ADUserUsers.csv"

# Para cada obejto da variavel $MailUser, cria��o de um e-mail com os sequinte parametro Login

$MailUser | ForEach-Object {

    Enable-Mailbox -Identity $_.Login -Database MBX_Funcionarios -Alias $_.Alias
    # MBX_Funcionarios
    # MBX_Prestadores
}

# Encerra a sess�o

Remove-PSSession $Session