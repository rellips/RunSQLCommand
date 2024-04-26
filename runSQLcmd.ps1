# runSQLcmd.ps1
# Simple command line SQL interpreter for Microsoft SQL Server
# More info https://github.com/rellips/RunSQLCommand

# Licenced under the "BSD 2 Clause" License  https://opensource.org/licenses/BSD-2-Clause

# Copyright 2024 Jeff Spiller. All rights reserved.
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#############################
###  config             ####
#############################
#$sqlServer="mypc\sqlexpress"
$database="AdventureWorks2014"
$sqlServer="lenovo-pc"
$trusted="YES" # Use a trusted connection (YES) or SQL Server Authentication (NO)
$user="script_user" #only required for SQL server authentication if trusted equal 'NO'
$pass="script_pass"  #only required for SQL server authentication if trusted equal 'NO'

#############################
###   Help Text         ####
#############################
$helptext=@"
quit -- terminate the program.
help -- display this message.
def <tablename> --- lists all the rows for one arbitrary record so you can see the columnnames.
output <console | grid> -- toggles query output between the console and a grid window
select ..... -- runs a valid T-SQL select statment.
===
The interpreter will ignore statements that do not start with commands  listed above 
"@

#############################
###   Config Vars        ####
#############################

$script:outputType="CONSOLE"
$version=".02"



#############################
###   Functions         ####
#############################



function CloseProgram {
    $sqlConnection.Close()
    exit

}


function handleError($location,$errObj) {
     write-host 'ERROR: '$errObj' AT: '$location
     $error.Clear() #clear error object so I can always pop the current error off of the top
  
}


function runQuery ($sqlCmd) {

    $sqlCommand.CommandText=$sqlCmd

    $sqlReader = $sqlCommand.ExecuteReader()
    if ( $error) { handleError "SQL STMT: " $error[0] }
    $dataTable = New-Object System.Data.DataTable
    $dataTable.Load($sqlReader)
    Write-host $script:outputType
    if ($script:outputType -eq "CONSOLE" ) {
        $dataTable | format-table -AutoSize
    } elseif ($script:outputType -eq "GRID" ) {
        $dataTable  | out-gridview
    }
   
  
   
    
}


function setOutput ($outSet) {
   
    $oSet = $outSet -replace "output",""
    if ($oSet.contains("CONSOLE") ) {
        $script:outputType="CONSOLE"
        write-host "Output Type set to " $script:outputType
    } elseif ($oSet.contains("GRID") ) {
          $script:outputType="GRID"
           write-host "Output Type set to " $script:outputType
    } else {
        write-host "Output Type set to  " $script:outputType 
        write-host "Valid Options are  'output console' or 'output grid' "

    }

   
        
}


function runDef ($intbl) {
   
    $tbl = $intbl -replace "def",""
   
    $sqlCommand.CommandText="select top 1 * from $tbl"

    $sqlReader = $sqlCommand.ExecuteReader()
    if ( $error) { handleError "SQL STMT: " $error[0] }
    $datatable = New-Object System.Data.DataTable
    $dataTable.Load($sqlReader)
    
    $Datatable | Format-List -Force 
   
    
}


function procInput ( $inval )   {
   
    if ($inval -eq "QUIT" ) { 
        closeProgram 
    }
    if ($inval.StartsWith("SELECT","CurrentCultureIgnoreCase") ){
        runQuery $inval
    }

    if ($inval.StartsWith("DEF","CurrentCultureIgnoreCase") ){
        runDef $inval
    }
    
    if ($inval.StartsWith("OUTPUT","CurrentCultureIgnoreCase") ){
        setOutput $inval
    }

    if ($inval -eq "HELP" ) { 
        Write-host $helptext
    }


}

 #############################
 ###      MAIN     ####
 #############################

$error.clear()

###SQL Connection
if ($trusted -eq 'YES') {
    $sqlConnection = new-object System.Data.SqlClient.SqlConnection "server=$sqlServer;database=$database;Integrated Security=SSPI" #TRUSTED AUTHENTICATION
} else { 
    $sqlConnection = new-object System.Data.SqlClient.SqlConnection "server=$sqlServer;database=$database;User Id=$user;Password=$pass" #SQL SERVER AUTHENTICTION
}

$sqlConnection.Open()
$sqlCommand = $sqlConnection.CreateCommand()
if ( $error) { handleError "DBConnect" $error[0]; exit  } 



### main Looop
write-host "runSQLcmd SQL Command Line V" $version
write-host " http://jeffspillerconsulting.github.io/RunSQLCommand/"
write-host "Type quit to exit, help for more information."
While (1 -eq 1 ) {
write-host -NoNewline  -->
$input=read-host
procInput($input.ToUpper())




}
