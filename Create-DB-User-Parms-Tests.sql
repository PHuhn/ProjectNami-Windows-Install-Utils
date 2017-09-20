/*
	.\Create-DB-User-Parms.ps1 -server ".\Express" -dbName "WordPress008" -userName "WordPress008" -userPwd "WP!000001"
	.\Create-DB-User-Parms.ps1 -server ".\Express" -dbName "WordPress008" -userName "WordPress008" -userPwd "WP!000001" -siteUser "NT AUTHORITY\NETWORK SERVICE"

	.\Create-DB-User-Cmd .\Express .\log.txt WordPress008 WordPress008 WP008!Xyz2020 "NT AUTHORITY\NETWORK SERVICE"
	.\Create-DB-User-Cmd .\Express .\log.txt WordPress008 WordPress008 WP008!Xyz2020
*/
use master
DROP DATABASE [WordPress008]
DROP LOGIN [WordPress008]
GO
/*	Test different DB and User names ...
	.\Create-DB-User-Parms.ps1 -server ".\Express" -userPwd "WP!000001"

	.\Create-DB-User-Cmd .\Express .\log.txt WordPress WPUser WP008!Xyz2020
*/
use master
DROP DATABASE [WordPress]
DROP LOGIN [WPUser]
GO
/* Errors ...
	.\Create-DB-User-Parms.ps1 -server ".\Express" -dbName "WordPress008" -userName "WordPress008"

	.\Create-DB-User-Cmd .\Express .\log.txt WordPress008 WordPress008
*/