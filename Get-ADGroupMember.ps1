Import-Module ActiveDirectory

$Group = Import-Csv "C:\Get-ADgroupMemberGroup.csv"

$Group | ForEach-Object {

    Get-ADGroupMember -Identity $_.Group | ft Name,SamAccountName -AutoSize |Out-File "c:\$($_.Group).txt"

}