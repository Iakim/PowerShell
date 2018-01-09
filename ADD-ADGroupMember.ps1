###########################################################################
# NOME: Script para adicionar ou remover usuários de grupos
# AUTOR: Isaac de Moraes
# COMENTÁRIO: Este script adiciona ou remove usuários de um ou mais grupos 
# de uma lista CSV em "Members of".
# HISTÓRICO DE VERSÃO: 1.0
# 1.0 | 02/06/2017 - Versão inicial - Isaac de Moraes
############################################################################
## Será solicitado usuário e senha
## Para que a credencial funcione será necessário liberar* o servidor a ser 
## acessado, com o comando "Enable-PSRemoting -Force", "Set-Item 
## WSMan:\localhost\client\TrustedHosts [IP do servidor a s er liberado]",
## e "Restart-Service WinRM". *O Windows Server 2012 já vem com a liberação.
############################################################################


#Conectando no Active Directory.

Enter-PSSession -ComputerName adserver.contoso.com -Credential domain\

#Importando o módulo Active Directory.

Import-Module ActiveDirectory

#Define que caso ocorra algum erro o script pare de executar.

$ErrorActionPreference = "Stop"

#Definindo variáveis para o arquivo CSV.

$Users = Get-Content "C:\PowerShell\ADD-ADGroupMemberUsers.csv"

#Definindo os grupos que serão removidos ou adicionados em "Member of".

$Folder = @("grupo1","grupo2")

#Define que para cada usuário listado no arquivo ADD-ADGroupMemberUsers.csv o comando seja repetido.

$Group | ForEach-Object {

#Para executar o comando de adição de usuários aos grupos é necessáio descomentar a linha "ADD-ADGroupMember...".

#Adicionando usuários aos grupos, que correspondem respectivamente a Folder[0] e Folder[1].

#ADD-ADGroupMember -Identity $Folder[0] -Members $Users
#ADD-ADGroupMember -Identity $Folder[1] -Members $Users

#Para executar o comando de remoção de usuários aos grupos é necessário descomentar a linha "Remove-ADGroupMember...".

#Removendo usuários aos grupos equipeabdi e equipeabdiinterna, que correspondem respectivamente a Folder[0] e Folder[1]. 

#Remove-ADGroupMember -Identity $Folder[0] -Members $Users -Confirm:$false
#Remove-ADGroupMember -Identity $Folder[1] -Members $Users -Confirm:$false

}

#Desconectando do Active Directory.

Exit-PSSession