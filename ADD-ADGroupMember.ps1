###########################################################################
# NOME: Script para adicionar ou remover usu�rios de grupos
# AUTOR: Isaac de Moraes
# COMENT�RIO: Este script adiciona ou remove usu�rios de um ou mais grupos 
# de uma lista CSV em "Members of".
# HIST�RICO DE VERS�O: 1.0
# 1.0 | 02/06/2017 - Vers�o inicial - Isaac de Moraes
############################################################################
## Ser� solicitado usu�rio e senha
## Para que a credencial funcione ser� necess�rio liberar* o servidor a ser 
## acessado, com o comando "Enable-PSRemoting -Force", "Set-Item 
## WSMan:\localhost\client\TrustedHosts [IP do servidor a s er liberado]",
## e "Restart-Service WinRM". *O Windows Server 2012 j� vem com a libera��o.
############################################################################


#Conectando no Active Directory.

Enter-PSSession -ComputerName adserver.contoso.com -Credential domain\

#Importando o m�dulo Active Directory.

Import-Module ActiveDirectory

#Define que caso ocorra algum erro o script pare de executar.

$ErrorActionPreference = "Stop"

#Definindo vari�veis para o arquivo CSV.

$Users = Get-Content "C:\PowerShell\ADD-ADGroupMemberUsers.csv"

#Definindo os grupos que ser�o removidos ou adicionados em "Member of".

$Folder = @("grupo1","grupo2")

#Define que para cada usu�rio listado no arquivo ADD-ADGroupMemberUsers.csv o comando seja repetido.

$Group | ForEach-Object {

#Para executar o comando de adi��o de usu�rios aos grupos � necess�io descomentar a linha "ADD-ADGroupMember...".

#Adicionando usu�rios aos grupos, que correspondem respectivamente a Folder[0] e Folder[1].

#ADD-ADGroupMember -Identity $Folder[0] -Members $Users
#ADD-ADGroupMember -Identity $Folder[1] -Members $Users

#Para executar o comando de remo��o de usu�rios aos grupos � necess�rio descomentar a linha "Remove-ADGroupMember...".

#Removendo usu�rios aos grupos equipeabdi e equipeabdiinterna, que correspondem respectivamente a Folder[0] e Folder[1]. 

#Remove-ADGroupMember -Identity $Folder[0] -Members $Users -Confirm:$false
#Remove-ADGroupMember -Identity $Folder[1] -Members $Users -Confirm:$false

}

#Desconectando do Active Directory.

Exit-PSSession