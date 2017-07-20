# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Script: AddDataBackup[NoZip].ps1
# Author: Cody Schlosser
# Last Edited: 5/17/2017
# This script backs up a user's Local and Roaming Appdata for Chrome and Firefox
# It puts this information where the user either selects via a Folder Browser Window or where they set the location inline
# Comments:Before running this script you have to access the user folder as an administrator while you are logged in as an administrator
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
param([string[]]$user,[string[]]$BackupLocation)
#Variables

#Functions
Function Get-BackupLocation(){
    Add-Type -AssemblyName System.Windows.Forms

    $OpenFolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog

    [void]$OpenFolderBrowser.ShowDialog()
    $OpenFolderBrowser.SelectedPath
    If(!$OpenFolderBrowser.SelectedPath){
    Write-Host "You have cancelled selecting a Backup Location. Now Exiting."
    exit
    }
}

Function Make-Copy($FilePath, $FolderName) {
Copy-Item C:\Users\$user\$FilePath -Destination $BackupLocation\$FolderName -Recurse -Force
}


#Prompt if the user variable does not already exist
If(!$user){
    $user = Read-Host -Prompt "Please Enter the eid of the user"
}

#Set Backup Folder location to either where user navigates to it in Folder Browser or to the inline location
if(!$BackupLocation){
Write-Host "Backup Location has not been set"
$BackupLocation = Get-BackupLocation

$BackupLocation = "$BackupLocation\$user Backup"
mkdir $BackupLocation

Write-Host "Backup Folder is located at $BackupLocation"
}else{
    Write-Host "Backup Location has been set inline"
    $BackupLocation = "$BackupLocation\$user Backup"
    mkdir $BackupLocation
    
    Write-Host "Backup Folder is located at $BackupLocation"
}

If(!$BackupLocation){
Write-Host "Backup Location failed to set"
exit
}
$start = Get-Date
Write-Host "Time Started: " $start
#kill chrome
Stop-process -Name "chrome"
#Copy Appdata and Favorites to the Backup Location
Write-Progress -Activity Copying Favorites -PercentComplete 0
#Favorites for Internet Explorer
Make-Copy -FilePath Favorites -FolderName Favorites
#Copy-Item C:\Users\$user\Favorites -Destination $BackupLocation\Favorites -Recurse -Force

Write-Progress -Activity Copying Mozilla -PercentComplete 25
#Roaming Mozilla Data
Make-Copy -FilePath "Appdata\Roaming\Mozilla" -FolderName "Mozilla\Roaming"

Write-Progress -Activity Copying Mozilla -PercentComplete 50
#Local Mozilla Data
Make-Copy -FilePath "Appdata\Local\Mozilla" -FolderName "Mozilla\Local"

Write-Progress -Activity Copying Google -PercentComplete 75
#Local Google Data
Make-Copy -FilePath "Appdata\Local\Google" -FolderName Google
$end = Get-Date
Write-Host "Time Ended: " $end