# -----------------------------------------------------------------------------------------------------
# Author: Cody Schlosser
# Last Edited: 5/24/2017
# Comments: This script searches the Active directory for specific users and provides the users name, Description & email
# Examples: 
# 1.) From Powershell: ActiveDirectoryUserSearch.ps1 -Names cschlos.  This will search the Active Directory for cschlos, and will return:
#     Name: cschlos
#     Description: Engineering Student
#     Email: cschlos@siue.edu
# 2.) ActiveDirectoryUserSearch.ps1 -Names cschlos,kpenrod,branpar.  This search will return the three users listed like:
#     Name: cschlos
#     Description: Engineering Student
#     Email: cschlos@siue.edu
#
#     Name: kpenrod
#     Description: kpenrod logged on to LB0005-B1XWWZ1 4/27/2016 12:41:53 PM.
#     Email: kpenrod@siue.edu
#
#     Name: branpar
#     Description: branpar logged on to LB0005M-DTM0Z12 6/2/2016 8:22:43 AM.
#     Email: branpar@siue.edu
#
# -----------------------------------------------------------------------------------------------------
param([String[]] $Names)


if(!$Names){
$Names = Read-Host -Prompt "Please enter the username you are searching for"
}

foreach($i in $Names){
# Code taken from: https://technet.microsoft.com/en-us/library/ff730967.aspx
$strFilter = "(&(objectCategory=User)(Name=$i))"

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000
$objSearcher.Filter = $strFilter
$objSearcher.SearchScope = "Subtree"

$colProplist = "name", "description", "mail" 
foreach ($i in $colProplist){$objSearcher.PropertiesToLoad.Add($i) | Out-Null}

$colResults = $objSearcher.FindAll()

foreach ($objResult in $colResults)
    {$objItem = $objResult.Properties 
                "Name: " + $objItem.name
                "Description: " + $objItem.description
                "Email: " + $objItem.mail + "`n"}

#End of technet code

}

pause


