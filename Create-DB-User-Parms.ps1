<#

.SYNOPSIS
	VERSION 2.0.0
	This is a simple T-SQL script to create a database and SQL user account.  This intended to be used
	in a development environment on a developer's workstation.

.DESCRIPTION
	Create a website and set permissions. This is a simple PowerShell script that creates a generic website, as follows:
	* creates a database,
	* create a login database account,
	* grant the above account user owner/read/write permissions to the database,
	* grant the 'site user' account owner/read/write permissions to the database. 


.EXAMPLE
	PS> .\Create-DB-User-Parms.ps1 -server ".\Express" -userPwd "WP!000001"

.EXAMPLE
	PS> .\Create-DB-User-Parms.ps1 -server ".\Express" -dbName "WordPress008" -userName "WordPress008" -userPwd "WP!000001"

.EXAMPLE
	PS> .\Create-DB-User-Parms.ps1 -server ".\Express" -dbName "WordPress008" -userName "WordPress008" -userPwd "WP!000001" -siteUser "NT AUTHORITY\NETWORK SERVICE"


.PARAMETER	server
		SQL Server instance name, . can be used for local instance or .\SQLExpress for default instance name for Express version.

.PARAMETER	dbName
		database name,

.PARAMETER	userName
		For WordPress sites and others sites that run as SQL Server login account.  User name for login database account, 

.PARAMETER	userPwd
		Password for login database account,

.PARAMETER	siteUser
		The user account the site should run as (normally NT AUTHORITY\IUSR),


.NOTES
	siteUser user is optional.
	The default values for -userPwd and -siteUser are empty string.  Other default values are as follows:
		-server		.\SQLExpress
		-dbName         WordPress
		-userName       WPUser


.LINK
	https://github.com/ProjectNami/

#>

param( [string]$server = ".\SQLExpress", [string]$dbName = "WordPress", [string]$userName = "WPUser", [string]$userPwd, [string]$siteUser = "" )
# Required imports ...
# 
  #
  if( $userPwd -ne "" ) {
    #
    # https://docs.microsoft.com/en-us/powershell/module/sqlps/invoke-sqlcmd?view=sqlserver-ps
    # Invoke-Sqlcmd
    #       [[-Query] <String>]
    #       [-AbortOnError]
    #       [-ConnectionTimeout <Int32>]
    #       [-Database <String>]
    #       [-DedicatedAdministratorConnection]
    #       [-DisableCommands]
    #       [-DisableVariables]
    #       [-EncryptConnection]
    #       [-ErrorLevel <Int32>]
    #       [-HostName <String>]
    #       [-IgnoreProviderContext]
    #       [-IncludeSqlUserErrors]
    #       [-InputFile <String>]
    #       [-MaxBinaryLength <Int32>]
    #       [-MaxCharLength <Int32>]
    #       [-NewPassword <String>]
    #       [-OutputSqlErrors <Boolean>]
    #       [-Password <String>]
    #       [-QueryTimeout <Int32>]
    #       [-ServerInstance <PSObject>]
    #       [-SeverityLevel <Int32>]
    #       [-SuppressProviderContextWarning]
    #       [-Username <String>]
    #       [-Variable <String[]>]
    #       [<CommonParameters>]
    #
    if( $siteUser -eq "" ) { $siteUser = "_" } # fake empty value
    if( $server -ne "" -and $dbName -ne "" -and $userName -ne "" ) {
      $varArray = @("dbName=$dbName", "uName=$userName", "uPwd=$userPwd", "siteUser=$siteUser")
      Write-Host "Server:" $server"," $varArray
      Invoke-Sqlcmd -ServerInstance $server -Verbose -InputFile ".\Create-DB-User-Parms.sql" -Variable $varArray
    } else {
      # Error, missing parameter value
      Write-Host ""
      Write-Host "All parameters require a value."
    }
    #
  } else {
    # Error, missing parameter value
    Write-Host ""
    Write-Host "The login user account $userName requires a password."
    Write-Host "example:"
    Write-Host '	-userPwd "WP!p@ssw0rd" '
  }
#
