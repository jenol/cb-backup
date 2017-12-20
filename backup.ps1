#$ErrorActionPreference = "Stop"

$server = "10.120.2.23"
$backupPath = "C:\Users\jlaszlo\Desktop\a"

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

try{
cd $scriptPath

./backup.cmd $server C:\Users\jlaszlo\Desktop\a
}
catch{}

cd $scriptPath

$dayFolderPath = (ls $backupPath | ?{ $_.PSIsContainer } | Sort-Object CreationTime -Descending | Select -First 1).FullName
$lastBackupFolderPath = (ls $dayFolderPath | ?{ $_.PSIsContainer } | Sort-Object CreationTime -Descending | Select -First 1).FullName
$fullCbbPath = ls $lastBackupFolderPath -Recurse | where {$_.extension -eq ".cbb"} | % { $_.FullName } 
$path = split-path -parent $fullCbbPath
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

$csvMsgPath = "$path\cbb_msg.csv"
$csvMetaPath = "$path\cbb_meta.csv"


if(Test-Path $csvMsgPath){
    Remove-Item $csvMsgPath
}

if(Test-Path $csvMetaPath){
    Remove-Item $csvMetaPath
}

#https://sqlite.org/cli.html

./sqlite3 -header -csv $path\data-0000.cbb "select * from cbb_msg;" | Out-File -FilePath "$csvMsgPath" -Encoding utf8 -Force -NoClobber 
./sqlite3 -header -csv $path\data-0000.cbb "select * from cbb_meta;" | Out-File -FilePath "$csvMetaPath" -Encoding utf8 -Force -NoClobber 

