$id = 1503
$name = "System"
$new = "C:\new.txt"
$old = "C:\old.txt"

Get-EventLog -InstanceId $id -LogName $name -Newest 1 | Select-Object "Index" | Out-File C:\new.txt

if (Test-Path $old){
echo "Arquivo old.txt existe"
}
else {
New-Item $old -ItemType file
echo "
Iakim
-----
Isaac
Moraes" > $old
echo "Arquivo old.txt criado"
}

if (Compare-Object -ReferenceObject $(Get-Content $new) -DifferenceObject $(Get-Content $old)) {
Remove-Item -Path $old
Rename-Item -NewName "old.txt" -Path $new
echo "Alterado"
start "C:\zbx1.bat"
}
else{
echo "Não alterado"
start "C:\zbx0.bat"
}
