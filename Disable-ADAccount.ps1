###########################################################################
# NOME:                Script para desabilitar usuários.
# AUTOR:               Isaac de Moraes
# COMENTÁRIO:          Este script desabilita os usuários de uma lista CSV,
#		       remove os grupos menos de "Domain Users", move o
#		       usuário para uma OU de desabilitados e remove da GAL. 
# HISTÓRICO DE VERSÃO: 1.1
# 1.0 | 30/05/2017 - Versão inicial - Isaac de Moraes
# 1.1 | 02/06/2017 - Alterando local do arquivo - Isaac de Moraes
############################################################################
## Será solicitado usuário e senha
## Para que a credencial funcione será necessário liberar* o servidor a ser 
## acessado, com o comando "Enable-PSRemoting -Force", "Set-Item 
## WSMan:\localhost\client\TrustedHosts [IP do servidor a s er liberado]",
## e "Restart-Service WinRM". *O Windows Server 2012 já vem com a liberação.
############################################################################

# Definindo que ao primeiro erro o script pare de executar. 

$ErrorActionPreference = "Stop"

# Definindo variáveis para o arquivo CSV e para a OU a ser movida.

$Users = Get-Content "C:\PowerShell\Disable-ADAccountUsers.csv"
$OU = "OU=Desabilitados,OU=Usuarios,DC=contoso,DC=com,DC=br"

# Conectando no Active Directory.

Enter-PSSession -ComputerName adserver.contoso.com -Credential contoso\

# Importando o módulo Active Directory.

Import-Module ActiveDirectory

# Repetindo o comando para o número de linhas do arquivo Users.csv

foreach ($Users in $Users){

# Obter os dados dos usuários em Users.csv para acompanhamento

Get-ADUser -Identity $Users -Properties DisplayName,Office

# Desabilitando a conta do usuário em Users.csv

Disable-ADAccount -Identity $Users

# Removendo os grupos do usuário, menos "Domain Users", sem confirmação

Get-ADGroup -Filter {name -notlike "*Domain Users*"}  | Remove-ADGroupMember -Members $Users -Confirm:$False

# Movendo o usuário para a OU definida em $OU

Get-ADUser $Users | Move-ADObject -TargetPath $OU

}

# Mensagem informando que o script foi executado com sucesso.

echo "O script foi executado com sucesso, consulte os usuários alterados acima."

# Desconectando do AD.

Exit-PSSession

# Conectando no Exchange.

$session=New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://excserver.com.br/PowerShell/ -Authentication Kerberos -Credential contoso\

# Importando a sessão.

Import-PSSession $session

# Definindo variáveis para o arquivo CSV.

$Users = Get-Content "C:\PowerShell\Disable-ADAccountUsers.csv"

# Repetindo o comando para o número de linhas do arquivo Users.csv.

foreach ($Users in $Users){

# Obter os dados dos usuários em Users.csv para acompanhamento.

Get-Mailbox -Identity $Users

# Removendo o usuário do GlobalAddressList.

Set-Mailbox -Identity $Users -HiddenFromAddressListsEnabled $true

}

# Mensagem informando que o script foi executado com sucesso.

echo "O script foi executado com sucesso, consulte os usuários alterados acima."

# Desconectando do Exchange.

Remove-PSSession $Session