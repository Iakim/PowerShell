###########################################################################
# NOME: Script para adicionar ou remover usuários de grupos
# AUTOR: Isaac de Moraes
# COMENTÁRIO: Este script renomeia o displayname de um ou mais usuários.
# HISTÓRICO DE VERSÃO: 1.0
# 1.0 | 06/02/2018 - Versão inicial - Isaac de Moraes
############################################################################

$SessionAD = New-PSSession -ComputerName serverAD -Credential domain\user
Import-Module activedirectory

$old = Get-Content "C:\PowerShell\old.csv"
$new = Get-Content "C:\PowerShell\new.csv"

ForEach-Object {

Rename-ADObject $old[0] -NewName $new[0]
Rename-ADObject $old[1] -NewName $new[1]

}

Remove-PSSession $SessionAD
