# RunSQLCommand
Command line SQL query tool for SQL Server written in Powershell

This designed to be a basic tool for quick lookups. Its primary audience sroduction application support admins.
It only allows queries starting with SELECT  and they need to be short enough to be written on a single command line.

The tool can ouput to either the console (default) or windows style grid control. Note that the number of rows and columns that the grid can display is limited by the version of powershell you use.

[More info on the powershell grid control](https://technet.microsoft.com/en-us/library/ff730930.aspx)

This will run on a machine WITHOUT SQL Server installed on it (it doesn't use PSSQL)

## REQUIREMENTS
1. Microsoft Windows 7 or better 
2. Powershell
3. Powershell installed with IDE (for grid )


## INSTALL
1. Download runSQLcmd.ps1 into the directory of your choice
2. Run powershell command line as administrator
3. Check the execution policy -- (If you don't know whats going on here see your system administrator)

`PS> get-executionPolicy`

if it returns "Restricted", run the following command

`PS> set-executionPolicy RemoteSigned`


4. Exit out of the administrator powershell window

## CONFIGURATION
open runSQLcmd.ps1 in an editor and go the config section change as required


````
############################
###  config             ####
#############################
$sqlServer="mypc\sqlexpress" -- this is the sever where the SQL SERVER IS
$database="AdventureWorks2014" -- Database on the server
$trusted="YES" # Use a trusted connection (YES) or SQL Server Authentication (NO)
$user="script_user" #only required for SQL server authentication if trusted equal 'NO'
$pass="script_pass"  #only required for SQL server authentication if trusted equal 'NO'
````


## RUNNING THE PROGRAM

### From a powershell window:

````
PS> cd <full path the directory where you put the runSQLcmd.ps1>`
PS> .\RunSQLCommand.PS1 
````


### From the command promt

`C:\> powershell  <full path to the directory where you put the runSQLcmd.ps1>\runSQLCmd.ps1`

### To setup a shortcut
1. Create a new shortcut
2. Paste the following into the Location field of the shortcut:

`powershell  <full path to the directory where you put the runSQLcmd.ps1>\runSQLCmd.ps1`

## USING THE TOOL
### Help Text

```
quit -- terminate the program.
help -- display this message.
def <tablename> --- lists all the rows for one arbitrary record so you can see the columnnames.
output <console | screen> -- toggles query output between the console and a grid window
select ..... -- runs a valid T-SQL select statment.
===
The interpreter will ignore statements that do not start with commands listed above 
```

### Examples

List the the column names in a table:

`--> def person.address`

### Run a query

`--> select * from person.address`


### Toggle ouput to grid 

`--> output grid`

### Toggle to output to console

`--> output console`

### Check to see output mode 

`--> output`


#

### Version History
July 9, 2016 -- V.01 -- Created
January 1, 2017 V.02 -- Added Grid


For more information, questions or suggestions email github AT jeffspillerconsulting.com

