<#
.SYNOPSIS
	This is a simple Powershell script to generate a generic website.  This intended to be
	used in a development environment on a developer's workstation.

.DESCRIPTION
	Create a website and set permissions. This is a simple PowerShell script that creates
	a generic website, as follows: 
	 * create a website folder,
	 * creates an IIS Website (and app-pool with same name),
	 * grants the website user read/execute permissions to the website folder,
	 * if WordPress site then creates wp-content and wp-includes folders 
	   and grants the website user modify permissions to the these folders,
	 * optionally grants owner permissions to the website folder to a developer. 

.EXAMPLE
	PS> .\website.ps1 "C:\inetpub\" "WSite007" "IUSR" "9127" "PNH" 0

.EXAMPLE
	PS> .\website.ps1 "C:\inetpub\" "WPress006" "IUSR" "9126" "PNH"

.EXAMPLE
	PS> .\website.ps1 -siteName WordPress009 -portNum "9129" -owner PNH


.PARAMETER	baseDir
		Root folder (should already exist)

.PARAMETER	siteName
		name of the website and appPool in IIS manager, also file system folder name.
		Default values are WPress or WebSite, dependent on wordPress parameter.

.PARAMETER	siteUser
		The user account the site should run as (normally IUSR), 

.PARAMETER	portNum
		Port # (should not conflict with other sites), 

.PARAMETER	owner
		Developer's user account (if empty then ignored), 

.PARAMETER	wordPress
		Boolean value (0 = false/ 1 = true)

.NOTES
	Set-ExecutionPolicy will need to be configured.
	This will need to be run as an administrator account.
	The $owner user account referenced in the variables is not an administrator account.
	If you set it to empty string it will be ignored.
	If wordpress is true it will create wp-includes and wp-content directories
	and set siteUser permissions to modify.

.LINK
	https://github.com/ProjectNami/

#>

param( [string]$baseDir = "C:\inetpub\", [string]$siteName, [string]$siteUser = "IUSR", [string]$portNum = "8000", [string]$owner = "", [string]$wordPress = "true" )
# Required imports ...
Import-Module "WebAdministration"
#
# ============================================================================
# https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-creating-web-sites-web-applications-virtual-directories-and-application-pools
#           By: Phil Huhn
# Updated Date: 2017-09-10
# Versions:
#  1.0.0	basic pasting script
#  1.1.0	refactored set-DirPermissions
#  1.2.0	refactored create-WebSite
#  2.0.0	converted to command line
#  2.0.1	corrected typos and changed help
#  2.0.2	corrected baseDir trailing slash
# ============================================================================
### functions section ###
##
## Set a directory's permission ##
function set-DirPermissions ( [string]$dir, [string]$user, [string]$perm )
{
	# set access for user to directory
	# not null and not empty
	if( ( $dir ) -and ( $dir -ne "" ) -and ( $user ) -and ( $user -ne "" ) )
	{
		Write-Host "set-DirPermissions, directory: " $dir ", user: " $user ", perm: " $perm
		$acl = Get-Acl $dir
		$aclNew = New-Object System.Security.AccessControl.FileSystemAccessRule(
			$user, $perm, "ContainerInherit,ObjectInherit", "None", "Allow")
		$acl.SetAccessRule( $aclNew )
		Set-Acl $dir $acl
	}
}
##
## create an IIS web-site and set a directory's permission ##
function create-WebSite ( [string]$baseDir, [string]$siteName, [string]$portNum, [string]$siteUser, [string]$owner, [bool]$wordPress )
{

	if( ( $baseDir ) -and ( $baseDir -ne "" ) `
		-and ( $siteName ) -and ( $siteName -ne "" ) `
		-and ( $siteUser ) -and ( $siteUser -ne "" ) `
		-and ( $portNum ) -and ( $owner ) ) # not null and not empty
	{
		# echo back the variables being used
		Write-Host $baseDir $siteName $siteUser $poolNum $owner $wordPress
		# ------------------------------------------------------------
		# construct variables based on the above values
		$siteDir = ("{0}{1}" -f $baseDir, $siteName )
		$site = ("\Sites\{0}" -f $siteName )
		$appPool = ("\AppPools\{0}" -f $siteName )
		$poolName = $siteName
		$portParm = ("*:{0}:" -f $portNum )
		Write-Host $siteDir $site $appPool $poolName $portParm
		# ------------------------------------------------------------
		# Start work .....
		#
		# create site directory and set IUSR permissions
		#
		New-Item $siteDir -type Directory
		#
		# In IIS create the web-site
		#
		New-Item IIS:$appPool
		New-Item IIS:$site -bindings @{protocol="http"; bindingInformation=$portParm} -physicalPath $siteDir
		Set-ItemProperty IIS:$site -name applicationPool -value $poolName
		#
		# set read-only access for IUSR to site directory
		#
		set-DirPermissions $siteDir $siteUser "ReadAndExecute"
		if( $wordPress )
		{
			#
			# create site wp-includes directory and set IUSR permissions
			#
			New-Item $siteDir"\wp-includes" -type Directory
			# set modify access for IUSR to site directory
			set-DirPermissions $siteDir"\wp-includes" $siteUser "Modify"
			#
			# create site wp-content directory and set IUSR permissions
			#
			New-Item $siteDir"\wp-content"  -type Directory
			# set modify access for IUSR to site directory
			set-DirPermissions $siteDir"\wp-content" $siteUser "Modify"
		}
		#
		set-DirPermissions $siteDir $owner "FullControl"
		#
	}
}
### end-of-functions-section ###
# ============================================================================
  ### main section, this will receive the 1st line's parameters ###
  # set default values...
  [bool]$wp = 0
  # $wp = 0 false = 1 true
  if( ( $wordPress -eq "" ) -or ( $wordPress -like "true" ) -or ( $wordPress -eq "1" ) )  { $wp = 1 }
  # name of site/folder name and appPool name
  if( $siteName -eq "" )  { $siteName = if( $wp ) {"WPress"} else { "WebSite" } }
  # fix baseDir
  if( $baseDir.substring($baseDir.Length-1,1) -ne "\" ) { $baseDir = ("{0}\" -f $baseDir ) }
  #
  create-WebSite $baseDir $siteName $portNum $siteUser $owner $wp
  #
  Write-Host ""
  if( $siteUser -ne "IUSR" -and $wp -eq 1 ) {
	Write-Host "Running the WordPress site as user $siteUser will require additional configuration."
	Write-Host "Minimally, you will need to change the Anonymous Authentication identity to $siteUser."
  } else {
	Write-Host "The $siteName site may require additional configuration from the"
	Write-Host "'Internet Information Services (IIS) Manager' console."
  }
  ### end-of-main-section ###
# end-of-script
