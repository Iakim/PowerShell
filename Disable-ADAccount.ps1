###########################################################################
# NOME:                Script para desabilitar usu�rios.
# AUTOR:               Isaac de Moraes
# COMENT�RIO:          Este script desabilita os usu�rios de uma lista CSV,
#		       remove os grupos menos de "Domain Users", move o
#		       usu�rio para uma OU de desabilitados e remove da GAL. 
# HIST�RICO DE VERS�O: 1.1
# 1.0 | 30/05/2017 - Vers�o inicial - Isaac de Moraes
# 1.1 | 02/06/2017 - Alterando local do arquivo - Isaac de Moraes
############################################################################
## Ser� solicitado usu�rio e senha
## Para que a credencial funcione ser� necess�rio liberar* o servidor a ser 
## acessado, com o comando "Enable-PSRemoting -Force", "Set-Item 
## WSMan:\localhost\client\TrustedHosts [IP do servidor a s er liberado]",
## e "Restart-Service WinRM". *O Windows Server 2012 j� vem com a libera��o.
############################################################################

# Definindo que ao primeiro erro o script pare de executar. 

$ErrorActionPreference = "Stop"

# Definindo vari�veis para o arquivo CSV e para a OU a ser movida.

$Users = Get-Content "C:\PowerShell\Disable-ADAccountUsers.csv"
$OU = "OU=Desabilitados,OU=Usuarios,DC=contoso,DC=com,DC=br"

# Conectando no Active Directory.

Enter-PSSession -ComputerName adserver.contoso.com -Credential contoso\

# Importando o m�dulo Active Directory.

Import-Module ActiveDirectory

# Repetindo o comando para o n�mero de linhas do arquivo Users.csv

foreach ($Users in $Users){

# Obter os dados dos usu�rios em Users.csv para acompanhamento

Get-ADUser -Identity $Users -Properties DisplayName,Office

# Desabilitando a conta do usu�rio em Users.csv

Disable-ADAccount -Identity $Users

# Removendo os grupos do usu�rio, menos "Domain Users", sem confirma��o

Get-ADGroup -Filter {name -notlike "*Domain Users*"}  | Remove-ADGroupMember -Members $Users -Confirm:$False

# Movendo o usu�rio para a OU definida em $OU

Get-ADUser $Users | Move-ADObject -TargetPath $OU

}

# Mensagem informando que o script foi executado com sucesso.

echo "O script foi executado com sucesso, consulte os usu�rios alterados acima."

# Desconectando do AD.

Exit-PSSession

# Conectando no Exchange.

$session=New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://excserver.com.br/PowerShell/ -Authentication Kerberos -Credential contoso\

# Importando a sess�o.

Import-PSSession $session

# Definindo vari�veis para o arquivo CSV.

$Users = Get-Content "C:\PowerShell\Disable-ADAccountUsers.csv"

# Repetindo o comando para o n�mero de linhas do arquivo Users.csv.

foreach ($Users in $Users){

# Obter os dados dos usu�rios em Users.csv para acompanhamento.

Get-Mailbox -Identity $Users

# Removendo o usu�rio do GlobalAddressList.

Set-Mailbox -Identity $Users -HiddenFromAddressListsEnabled $true

}

# Mensagem informando que o script foi executado com sucesso.

echo "O script foi executado com sucesso, consulte os usu�rios alterados acima."

# Desconectando do Exchange.

Remove-PSSession $Session