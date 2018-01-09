###########################################################################
# NOME: Criação de Conta no AD e Exchange
# AUTOR: Isaac de Moraes
# COMENTÁRIO: Este script faz a criação de usuarios no Active Directory
# e no Exchange
# HISTÓRICO DE VERSÃO: 1.0
# 1.0 | 02/06/2017 - Versão inicial - Isaac de Moraes
############################################################################
## Será solicitado usuário e senha
## Para que a credencial funcione será necessário liberar* o servidor a ser 
## acessado, com o comando "Enable-PSRemoting -Force", "Set-Item 
## WSMan:\localhost\client\TrustedHosts [IP do servidor a s er liberado]",
## e "Restart-Service WinRM". *O Windows Server 2012 já vem com a liberação.
############################################################################

# Importando módulo Active Directory

Import-Module ActiveDirectory

# Armazenando usuários listados em New-ADUserUsers.csv

$CreateUser = Import-Csv "C:\PowerShell\New-ADUserUsers.csv"

# Para cada usuários armazenado na variável $CreateUser, sera criado o usuario no  Active Directory.

$CreateUser | ForEach-Object {

    New-ADUser -Path 'OU=Usuarios,DC=contoso,DC=com,DC=br' -SamAccountName $_.Loginpre -UserPrincipalName $_.Login -DisplayName $_.DN -GivenName $_.FirstName -Name $_.Name -Surname $_.LastName -Office $_.OfficeName -Description $_.Description -Company $_.Company -Department $_.Department -Title $_.Title -OfficePhone $_.Phone -AccountPassword (ConvertTo-SecureString -AsPlainText $_.Password -Force) -ChangePasswordAtLogon $True -Enabled $True

}

# Importa-se o arquivo New-ADUserUsers.csv para a variável extension

$extension = Import-Csv "C:\PowerShell\New-ADUserUsers.csv"

# Para cada indece armazenado na variável $extension faça o retorno do usuario é modifica  sua extensão.

$extension | ForEach-Object {

    $Attribute1 = Get-ADUser -Identity $_.Loginpre -Properties extensionAttribute1
    Set-ADUser -Identity $Attribute1 -Add @{"extensionAttribute1"="Normal"} 

}

# Importa-se o arquivo New-ADUserUsers.csv para a variável $Group

$Group = Import-Csv "C:\PowerShell\New-ADUserUsers.csv"

# Vetor com duas posiçoes, aramzenado as seguintes strings "grupo1","grupo2"

$Folder = @("grupo1","grupo2")

# Para cada objeto armazenado na variável $Group adiciona os sequinte grupos equipeabdi, 
# equipeabdiinterna que correspondem respectivamente a Folder[0], Folder[1]

$Group | ForEach-Object {

    ADD-ADGroupMember -Identity $Folder[0] -Members $_.Loginpre
    ADD-ADGroupMember -Identity $Folder[1] -Members $_.Loginpre

}
# Inicia-se uma sessão com http://excserver.com.br/PowerShell/

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://excserver.com.br/PowerShell/ -Authentication Kerberos -Credential domain\

# Importa para variável sessão

Import-PSSession $Session

# Importa-se o arquivo New-ADUserUsers.csv para a variável $MailUser

$MailUser = Import-Csv "C:\PowerShell\New-ADUserUsers.csv"

# Para cada obejto da variavel $MailUser, criação de um e-mail com os sequinte parametro Login

$MailUser | ForEach-Object {

    Enable-Mailbox -Identity $_.Login -Database MBX_Funcionarios -Alias $_.Alias
    # MBX_Funcionarios
    # MBX_Prestadores
}

# Encerra a sessão

Remove-PSSession $Session