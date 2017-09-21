-- ===========================================================================
-- File: Create-DB-User.sql
-- By:   Phil Huhn
-- Date: 2017-09-12
-- Description:
--   This is a simple T-SQL script to create a database and SQL user account.
--   This intended to be used in a development environment on a developer's
--   workstation.  Create a website and set permissions, as follows:
--   * creates a database,
--   * create a login database account,
--   * add a login account to database,
--   * grant the above account user owner/read/write permissions to the
--     database,
--   * grant the 'site user' account owner/read/write permissions to the
--     database. 
-- ===========================================================================
-- 2017-09-21  Phil  Updated the closing message
-- ===========================================================================
USE master;
DECLARE
	@dbName	VARCHAR(50) = '$(dbName)',	-- database name
	@uName	VARCHAR(50) = '$(uName)',	-- user name
	@uPwd	VARCHAR(50) = '$(uPwd)',	-- user password
	@siteUser VARCHAR(50) = '$(siteUser)', -- The user account the site should run as
	@sql	NVARCHAR(255) = '',
	@sql2	NVARCHAR(4000) = '',
	@sql3	NVARCHAR(4000) = '',
	@sql4	NVARCHAR(4000) = '';
--
SET @siteUser = RTRIM( @siteUser )
IF ( @siteUser = '_' ) SET @siteUser = '' -- fake empty value
IF ( @uName	= '_' )    SET @uName = '' -- fake empty value
--
--	Create the database
--
IF NOT EXISTS ( SELECT database_id FROM sys.databases WHERE [name] = @dbName )
BEGIN
 SET @sql = 'CREATE DATABASE ' + QUOTENAME(@dbName)
 PRINT @sql
 EXEC (@sql)
END
--
--	Create the instance user
--
IF ( @uName <> '' )
BEGIN
 IF NOT EXISTS ( SELECT [name] FROM sys.sql_logins WHERE [name] = @uName )
 BEGIN
  SET @sql = 'CREATE LOGIN ' + QUOTENAME(@uName) + ' WITH PASSWORD =''' + @uPwd + '''';
  PRINT @sql
  EXEC (@sql);
  --
  SET @sql2 = N'
 CREATE USER ' + QUOTENAME(@uName) + ' FOR LOGIN ' + QUOTENAME(@uName) + ' WITH DEFAULT_SCHEMA = dbo;
 EXEC sp_addrolemember @rolename=''db_owner'',      @membername = ' + QUOTENAME(@uName) + ';
 EXEC sp_addrolemember @rolename=''db_datareader'', @membername = ' + QUOTENAME(@uName) + ';
 EXEC sp_addrolemember @rolename=''db_datawriter'', @membername = ' + QUOTENAME(@uName) + ';
 --
';
 END
END
--
--	Create the database user with owner, read and write permissions.
--
IF ( @siteUser <> '' )
BEGIN
 IF NOT EXISTS (  SELECT loginname FROM master..syslogins WHERE isntname = 1 AND hasaccess = 1 AND loginname = @siteUser )
 BEGIN
  SET @sql = 'CREATE LOGIN ' + QUOTENAME(@siteUser) + 'FROM WINDOWS WITH DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english]';
  PRINT @sql
  EXEC (@sql);
 END
 SET @sql3 = N'
 CREATE USER ' + QUOTENAME(@siteUser) + ' FOR LOGIN ' + QUOTENAME(@siteUser) + ' WITH DEFAULT_SCHEMA=dbo;
 EXEC sp_addrolemember @rolename=''db_owner'',      @membername = ' + QUOTENAME(@siteUser) + ';
 EXEC sp_addrolemember @rolename=''db_datareader'', @membername = ' + QUOTENAME(@siteUser) + ';
 EXEC sp_addrolemember @rolename=''db_datawriter'', @membername = ' + QUOTENAME(@siteUser) + ';
';
END
SET @sql4 = N'
 USE ' +  QUOTENAME(@dbName) + ';
 ' + @sql2 + @sql3;
--
PRINT @sql4
EXEC (@sql4);

PRINT '
!*!*  If this is for WordPress...
!*!*   1) R-click server instance => Properties => Security => 
!*!*      turn on "SQL Server and Windows Authentication mode". 
!*!*   2) paste the following into the wp-config.php '

PRINT '

// ** SQL Server settings ** //
define(''DB_NAME'', ''' + @dbName + ''');  /** The name of the database */
define(''DB_USER'', ''' + @uName + ''');  /** SQL database username */
define(''DB_PASSWORD'', ''' + @uPwd + '''); /** SQL database password */
define(''DB_HOST'', ''' + @@servername + '''); /** SQL hostname */
'
--
