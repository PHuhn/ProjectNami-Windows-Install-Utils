# ProjectNami-Windows-Install-Utils
Some support utilities for project nami (clone of WordPress for Windows and SQL Server and IIS).


## README.MD
	This document.

## Create-DB-User-Parms-ReadMe.txt
	Instructions for using Create-DB-User-Parms.ps1 powershell script.

## Create-DB-User-Cmd.cmd
	Alternate way to execute Create-DB-User-Parms.sql T-SQL script.

## Create-DB-User-Parms.ps1
	Powershell frontend to execute Create-DB-User-Parms.sql T-SQL script.
	I am using Powershell 5.1.  You can find your version with the following command:
```
		$PSVersionTable.PSVersion
```
	Powershell security policy may need to be changed.  I executed the following:
```
		Set-ExecutionPolicy  -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Create-DB-User-Parms.sql
	T-SQL script to create a database, SQL login user and site user.

## WebSite-ReadMe.txt
	Instructions for using WebSite.ps1 powershell script.

## WebSite.ps1
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
