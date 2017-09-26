# ProjectNami-Windows-Install-Utils
Some support utilities for project nami (clone of WordPress for Windows and SQL Server and IIS).


## Overview
This has three basic funtions, as follows:
- SQL Server (Powershell as an administrator):
  - creates a database,
  - create a SQL Server account login,
    - create this account as a user of the database,
    - grant this account owner/read/write permissions to the database,
  - grant the 'site user' account owner/read/write permissions to the database.
- IIS (Powershell as an administrator):
  - create a website folder,
  - creates an IIS Website (and app-pool with same name),
  - grants the website user read/execute permissions to the website folder,
  - if WordPress site:
    - creates wp-content and wp-includes folders,
    - grants the website user modify permissions to the these folders,
  - optionally grants owner permissions to the website folder to a developer,
- web.config:
  - denial of service attack prevention,
  - not allow file requests for:
    - specific sequences,
    - file extensions,
  - disabled directory browsing,
  - disabled caching for PHP files,
  - enable URL rewrite.

To display help from PowerShell execute the following:
```
 get-help .\Create-DB-User-Parms.ps1 -full
 get-help .\website.ps1 -full
```

Example of creating SQL Server database:
```
 .\Create-DB-User-Parms.ps1 -server ".\Express" -dbName "WP__01" -userName "WP__01" -userPwd "WP1!01!" -siteUser "NT AUTHORITY\IUSR"
```

Example of creating IIS website:
```
 .\website.ps1 -siteName WPress01 -portNum "9129" -owner PNH
```
The above assumes default values of:
- -baseDir "C:\inetpub\"
- -siteUser "IUSR"
- -wordPress "true"

## Content
This is synopsis of the files contained in this repository.

### README.MD
This document.

### Create-DB-User-Parms-ReadMe.txt
Instructions for using Create-DB-User-Parms.ps1 powershell script.

### Create-DB-User-Cmd.cmd
Alternate way to execute Create-DB-User-Parms.sql T-SQL script.

### Create-DB-User-Parms.ps1
Powershell frontend to execute Create-DB-User-Parms.sql T-SQL script.
I am using Powershell 5.1.  You can find your version with the following command:
```
	$PSVersionTable.PSVersion
```
Powershell security policy may need to be changed.  I executed the following:
```
	Set-ExecutionPolicy  -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Create-DB-User-Parms.sql
T-SQL script to create a database, SQL login user and site user.

### WebSite-ReadMe.txt
Instructions for using WebSite.ps1 powershell script.

### WebSite.ps1
Powershell script to create a Project Nami WordPress website.
This script needs to be run as an Administrator.
I am using Powershell 5.1.  You can find your version with the following command:
```
	$PSVersionTable.PSVersion
```
Powershell security policy may need to be changed.  I executed the following:
```
	Set-ExecutionPolicy  -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### web.config
An IIS website configuration files, similar to htaccess file.
In the security section of the web.config
1. Denial of service attack prevention,
2. Do not allow requests for specific sequences and file extensions.
In the Rewrite section enable 'Permalink Setting', rewrite the URL line.
