Project Nami IIS WebSite Create

Version: 2.0.1

NAME
    WebSite.ps1


SYNOPSIS
    This is a simple Powershell script to generate a generic website.  This intended to be used
    in a development environment on a developer's workstation.


SYNTAX
    C:\Dat\nsg\Talks\Web\WordPress\AddOns\scripts\WebSite.ps1 [[-baseDir] <String>] [[-siteName] <String>] 
    [[-siteUser] <String>] [[-portNum] <String>] [[-owner] <String>] [[-wordPress] <String>] 
    [<CommonParameters>]


DESCRIPTION
    Create a website and set permissions. This is a simple PowerShell script that creates
    a generic website, as follows:
    * create a website folder,
    * creates an IIS Website (and app-pool with same name),
    * grants the website user read/execute permissions to the website folder,
    * if WordPress site then creates wp-content and wp-includes folders 
      and grants the website user modify permissions to the these folders,
    * optionally grants owner permissions to the website folder to a developer. 


PARAMETERS
    -baseDir <String>
        Root folder (should already exist)
        
        Required?                    false
        Position?                    1
        Default value                C:\inetpub\
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -siteName <String>
        name of the website and appPool in IIS manager, also file system folder name.
        Default values are WPress or WebSite, dependent on wordPress parameter.
        
        Required?                    false
        Position?                    2
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -siteUser <String>
        The user account the site should run as (normally IUSR),
        
        Required?                    false
        Position?                    3
        Default value                IUSR
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -portNum <String>
        Port # (should not conflict with other sites),
        
        Required?                    false
        Position?                    4
        Default value                8000
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -owner <String>
        Developer's user account (if empty then ignored),
        
        Required?                    false
        Position?                    5
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -wordPress <String>
        Boolean value (0 = false/ 1 = true)
        
        Required?                    false
        Position?                    6
        Default value                true
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 

NOTES
        Set-ExecutionPolicy will need to be configured.
        This will need to be run as an administrator account.
        The owner user account referenced in the variables is not an administrator account.
        If you set owner to empty string it will be ignored.
        If wordpress is true it will create wp-includes and wp-content directories
        and set siteUser permissions to modify.


    -------------------------- EXAMPLE 1 --------------------------

    PS>.\website.ps1 "C:\inetpub\" "WSite007" "IUSR" "9127" "PNH" 0


    -------------------------- EXAMPLE 2 --------------------------

    PS>.\website.ps1 "C:\inetpub\" "WPress006" "IUSR" "9126" "PNH"


    -------------------------- EXAMPLE 3 --------------------------

    PS>.\website.ps1 -siteName WordPress009 -portNum "9129" -owner PNH


RELATED LINKS
    https://github.com/ProjectNami/


EXAMPLE EXCUTION
    PS C:\Talks\Web\WordPress\scripts> .\website.ps1 -siteName WordPress009 -portNum "9129" -owner PNH
    C:\inetpub\ WordPress009 IUSR  PNH True
    C:\inetpub\WordPress009 \Sites\WordPress009 \AppPools\WordPress009 WordPress009 *:9129:


        Directory: C:\inetpub


    Mode                LastWriteTime         Length Name 
    ----                -------------         ------ ---- 
    d-----        9/11/2017  10:30 AM                WordPress009 

    Name  : WordPress009
    State : Started


    Name         : WordPress009
    ID           : 6
    State        : Started
    PhysicalPath : C:\inetpub\WordPress009
    Bindings     : Microsoft.IIs.PowerShell.Framework.ConfigurationElement

    set-DirPermissions, directory:  C:\inetpub\WordPress009 , user:  IUSR , perm:  ReadAndExecute


        Directory: C:\inetpub\WordPress009


    Mode                LastWriteTime         Length Name 
    ----                -------------         ------ ---- 
    d-----        9/11/2017  10:30 AM                wp-includes 
    set-DirPermissions, directory:  C:\inetpub\WordPress009\wp-includes , user:  IUSR , perm:  Modify
    d-----        9/11/2017  10:30 AM                wp-content 
    set-DirPermissions, directory:  C:\inetpub\WordPress009\wp-content , user:  IUSR , perm:  Modify
    set-DirPermissions, directory:  C:\inetpub\WordPress009 , user:  PNH , perm:  FullControl

    The WordPress009 site may require additional configuration from the
    'Internet Information Services (IIS) Manager' console.



    PS C:\Talks\Web\WordPress\scripts> 
