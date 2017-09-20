Project Nami Windows Install Utils

Version: 2.0.0

NAME
    Create-DB-User-Parms.ps1
    
SYNOPSIS
    This is a simple T-SQL script to create a database and SQL user account.  This intended to be used
    in a development environment on a developer's workstation.


SYNTAX
    C:\Dat\nsg\Talks\Web\WordPress\scripts\Create-DB-User-Parms.ps1 [[-server] <String>] [[-dbName] <String>] 
    [[-userName] <String>] [[-userPwd] <String>] [[-siteUser] <String>] [<CommonParameters>]


DESCRIPTION
    Create a website and set permissions. This is a simple PowerShell script that creates a generic website, 
    as follows:
    * creates a database,
    * create a login database account,
    * grant the above account user owner/read/write permissions to the database,
    * grant the 'site user' account owner/read/write permissions to the database.


PARAMETERS
    -server <String>
        SQL Server instance name, . can be used for local instance or .\SQLExpress for default instance name 
        for Express version.
        
        Required?                    false
        Position?                    1
        Default value                .\SQLExpress
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -dbName <String>
        database name,
        
        Required?                    false
        Position?                    2
        Default value                WordPress
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -userName <String>
        For WordPress sites and others sites that run as SQL Server login account.  User name for login 
        database account,
        
        Required?                    false
        Position?                    3
        Default value                WPUser
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -userPwd <String>
        Password for login database account,
        
        Required?                    false
        Position?                    4
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -siteUser <String>
        The user account the site should run as (normally NT AUTHORITY\IUSR),
        
        Required?                    false
        Position?                    5
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 


INPUTS
    
OUTPUTS
    
NOTES
        siteUser user is optional.
        The default values for -userPwd and -siteUser are empty string.  Other default values are as follows:
        	-server		.\SQLExpress
        	-dbName         WordPress
        	-userName       WPUser


    -------------------------- EXAMPLE 1 --------------------------
    
    PS>.\Create-DB-User-Parms.ps1 -server ".\Express" -userPwd "WP!000001"

    -------------------------- EXAMPLE 2 --------------------------
    
    PS>.\Create-DB-User-Parms.ps1 -server ".\Express" -dbName "WordPress008" -userName "WordPress008" -userPwd 
    "WP!000001"

    -------------------------- EXAMPLE 3 --------------------------
    
    PS>.\Create-DB-User-Parms.ps1 -server ".\Express" -dbName "WordPress008" -userName "WordPress008" -userPwd 
    "WP!000001" -siteUser "NT AUTHORITY\NETWORK SERVICE"


RELATED LINKS
    https://github.com/ProjectNami/


EXAMPLE EXCUTION
    PS C:\Talks\Web\WordPress\scripts> .\Create-DB-User-Parms.ps1 -server '.\Express' -dbName "WordPress008" -userName "WordPress008" -userPwd "WP!000001" -siteUser "NT AUTHORITY\NETWORK SERVICE"
    Server: .\Express, dbName=WordPress008 uName=WordPress008 uPwd=WP!000001 siteUser=NT AUTHORITY\NETWORK SERVICE
    VERBOSE: Changed database context to 'master'.
    VERBOSE: CREATE DATABASE [WordPress008]
    VERBOSE: CREATE LOGIN [WordPress008] WITH PASSWORD ='WP!000001'
    VERBOSE: 
     USE [WordPress008];
 
     CREATE USER [WordPress008] FOR LOGIN [WordPress008] WITH DEFAULT_SCHEMA = dbo;
     EXEC sp_addrolemember @rolename='db_owner',      @membername = [WordPress008];
     EXEC sp_addrolemember @rolename='db_datareader', @membername = [WordPress008];
     EXEC sp_addrolemember @rolename='db_datawriter', @membername = [WordPress008];
     --

     CREATE USER [NT AUTHORITY\NETWORK SERVICE] FOR LOGIN [NT AUTHORITY\NETWORK SERVICE] WITH DEFAULT_SCHEMA=dbo;
     EXEC sp_addrolemember @rolename='db_owner',      @membername = [NT AUTHORITY\NETWORK SERVICE];
     EXEC sp_addrolemember @rolename='db_datareader', @membername = [NT AUTHORITY\NETWORK SERVICE];
     EXEC sp_addrolemember @rolename='db_datawriter', @membername = [NT AUTHORITY\NETWORK SERVICE];

    VERBOSE:  
    VERBOSE: !*!*  If the is for WordPress, paste the following into the wp-config.php  *!*!
    VERBOSE: 

    // ** SQL Server settings - You can get this info from your web host ** //
    define('DB_NAME', 'WordPress008');  /** The name of the database */
    define('DB_USER', 'WordPress008');  /** SQL database username */
    define('DB_PASSWORD', 'WP!000001'); /** SQL database password */
    define('DB_HOST', 'COLONY7\EXPRESS'); /** SQL hostname */


    PS C:\Talks\Web\WordPress\scripts> 
