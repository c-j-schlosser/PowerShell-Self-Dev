# ---------------------------------------------------------------------------------------------------------------------------------------
# Creator: Cody Schlosser
# Last Edited: 6/6/2017
# Comments: This acts a general search of Active Directory for a computer name.  It creates a text file in the local directory
# puts the information from the search into that text document and then spits out the information to the console window.
# Accepts the string paramater filter name which it will then plug in to a LDAP Filter
# THIS ONLY WORKS WHEN SEARCHING COMPUTER NAME AS IT APPEARS IN ACTIVE DIRECTORY
# ---------------------------------------------------------------------------------------------------------------------------------------
param([String[]] $filterName)

#Stores the desired filename as a string
$fileName = "RetrievedComputers.txt"

#If filter name is empty ask for the computer name
if(!$filterName){
$filterName = Read-Host -Prompt "Please enter computer name(s) to search for"
}

#Create RetrievedComputers.txt in the local directory
If(Test-Path $PSScriptRoot\$fileName){
    $var = Read-Host -Prompt "$fileName already exists in this directory. It will be deleted if you continue. Is that ok? y = yes, n = no"
    if($var -eq "y"){
        Remove-Item $fileName
    }else{
    exit
    }  
}
New-Item $fileName

Write-Host "Searching Active Directory......"

#Get the requested Computer(s) and put them into RetrievedComputers.txt
Get-ADComputer -LDAPFilter "(name=$filterName)" > $fileName

Write-Host "Search Complete"

#Count the number of lines in the file for cat purposes

#Output the text file to standard out
Write-Host "Information read from: $PSScriptRoot\$fileName"

#Truncate to 21 lines of the file.
Write-Host "First 21 Lines:"
Get-Content $fileName -TotalCount 20

pause



 