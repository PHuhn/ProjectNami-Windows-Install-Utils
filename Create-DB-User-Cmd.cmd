@REM By Phil Huhn 2017-09-12
@REM ========================================================
@REM sqlcmd
@REM	-a packet_size  
@REM	-A (dedicated administrator connection)  
@REM	-b (terminate batch job if there is an error)  
@REM	-c batch_terminator  
@REM	-C (trust the server certificate)  
@REM	-d db_name  
@REM	-e (echo input)  
@REM	-E (use trusted connection)  
@REM	-f codepage | i:codepage[,o:codepage] | o:codepage[,i:codepage] 
@REM	-g (enable column encryption) 
@REM	-G (use Azure Active Directory for authentication)
@REM	-h rows_per_header  
@REM	-H workstation_name  
@REM	-i input_file  
@REM	-I (enable quoted identifiers)  
@REM	-j (Print raw error messages)
@REM	-k[1 | 2] (remove or replace control characters)  
@REM	-K application_intent  
@REM	-l login_timeout  
@REM	-L[c] (list servers, optional clean output)  
@REM	-m error_level  
@REM	-M multisubnet_failover  
@REM	-N (encrypt connection)  
@REM	-o output_file  
@REM	-p[1] (print statistics, optional colon format)  
@REM	-P password  
@REM	-q "cmdline query"  
@REM	-Q "cmdline query" (and exit)  
@REM	-r[0 | 1] (msgs to stderr)  
@REM	-R (use client regional settings)  
@REM	-s col_separator  
@REM	-S [protocol:]server[instance_name][,port]  
@REM	-t query_timeout  
@REM	-u (unicode output file)  
@REM	-U login_id  
@REM	-v var = "value"  
@REM	-V error_severity_level  
@REM	-w column_width  
@REM	-W (remove trailing spaces)  
@REM	-x (disable variable substitution)  
@REM	-X[1] (disable commands, startup script, environment variables, optional exit)  
@REM	-y variable_length_type_display_width  
@REM	-Y fixed_length_type_display_width  
@REM	-z new_password
@REM	-Z new_password (and exit)  
@REM	-? (usage)
@REM https://blogs.msdn.microsoft.com/ssehgal/2009/04/03/passing-parameters-to-sql-script-using-batch-files/
@REM @dbName	VARCHAR(50) = $(dbName),	-- database name
@REM @uName	VARCHAR(50) = $(uName),		-- user name
@REM @uPwd	VARCHAR(50) = $(uPwd),		-- user password
@REM @siteUser	VARCHAR(50) = $(siteUser), 	-- The user account the site should run as
@REM EXAMPLE:
@REM  Create-DB-User .\Express .\log.txt  WordPress008  WordPress008  WordPress008!Xyz2020  "NT AUTHORITY\IUSR"
@REM
@IF %6x==x (
 SET susr="_"
) ELSE (
 SET susr=%6
)
@IF NOT %5x==x (
 SQLCMD -S %1 -o %2 -i Create-DB-User-Parms.sql -v dbName=%3 uName=%4 uPwd=%5 siteUser=%susr%
 TYPE %2
) ELSE (
 @ECHO[
 @ECHO Parameters:
 @ECHO  1 = instance
 @ECHO  2 = log file
 @ECHO  3 = database name
 @ECHO  4 = login user name
 @ECHO  5 = login user password
 @ECHO  6 = website user account
 @ECHO[
 @ECHO Examples command...
 @ECHO  Create-DB-User-Cmd .\SQLExpress .\log.txt WordPress008 WordPress008 WP008!Xyz2020 "NT AUTHORITY\NETWORK SERVICE"
 @ECHO  Create-DB-User-Cmd .\SQLExpress .\log.txt WordPress008 WordPress008 WP008!Xyz2020
 @ECHO[
)
