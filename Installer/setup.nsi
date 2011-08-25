# Auto-generated by EclipseNSIS Script Wizard
# Aug 23, 2011 9:22:47 AM

Name "3D Repository"

!include java.nsi
!include DotNet.nsi
!include defines.nsh
!include InstallOptions.nsh
!include FileReplace.nsi
RequestExecutionLevel highest

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 1.0
!define COMPANY ADL
!define URL www.adlnet.gov

# MUI Symbol Definitions
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-colorful.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
#!define MUI_FINISHPAGE_RUN $ADMINTOOLS
#!define MUI_FINISHPAGE_SHOWREADME $ADMINTOOLS
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-colorful.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include Sections.nsh
!include MUI2.nsh

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "creative comons.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

Page Custom FedoraConnectionEnter FedoraConnectionLeave
Page Custom MySQLConnectionEnter MySQLConnectionLeave
Page Custom SettingsEnter SettingsLeave


!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile 3DR_setup.exe
InstallDir "$ProgramFiles\3D Repository"
CRCCheck on
XPStyle on
ShowInstDetails show
VIProductVersion 1.0.0.0
VIAddVersionKey ProductName "3D Repository"
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show



Function InstallFedora

  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to install Fedora Commons on this computer?" IDNO FedoraDone IDYES StartFedora

  StartFedora:
  IfFileExists $INSTDIR\installer\Prerequisites\fcrepo-installer-3.5.jar InstallFedora DownloadFedora
  DownloadFedora:      
        SetOutPath $INSTDIR\installer\Prerequisites
        StrCpy $0  "fcrepo-installer-3.5.jar"
        NSISdl::download http://downloads.sourceforge.net/fedora-commons/fcrepo-installer-3.5.jar $0
  InstallFedora:
        StrCpy $0 "$INSTDIR\installer\Prerequisites\fcrepo-installer-3.5.jar"
  
  Call GetJRE
  Pop $R0
  
  ; change for your purpose (-jar etc.)
  ${GetParameters} $1
  StrCpy $0 '"$R0" -jar "$0"'
  
  SetOutPath $INSTDIR\installer
  ExecWait $0
  
  FedoraDone:
        
FunctionEnd

Function InstallMySQL

  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to install MySQL on this computer?" IDNO MySQLDone IDYES StartMySQL

  StartMySQL:
  IfFileExists $INSTDIR\installer\Prerequisites\mysql-5.5.15-win32.msi InstallMySQL DownloadMySQL
  DownloadMySQL:      
        SetOutPath $INSTDIR\installer\Prerequisites
        StrCpy $0  "mysql-5.5.15-win32.msi"
        NSISdl::download http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.15-win32.msi/from/http://mysql.he.net/ $0
  InstallMySQL:
  
  SetOutPath $INSTDIR\installer
  StrCpy $0 '"$INSTDIR\installer\Prerequisites\mysql-5.5.15-win32.msi"'
  StrCpy $0 '"msiexec" /i $0'
 
  
  ExecWait $0
  
  MySQLDone:
        
FunctionEnd

Function InstallMySQLConnector

  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to install MySQL ODBC Connector on this computer?" IDNO MySQLConnectorDone IDYES StartMySQLConnector

  StartMySQLConnector:
  IfFileExists $INSTDIR\installer\Prerequisites\mysql-connector-odbc-5.1.8-win32.msi InstallMySQLConnector DownloadMySQLConnector
  DownloadMySQLConnector:      
        SetOutPath $INSTDIR\installer\Prerequisites
        StrCpy $0  "mysql-connector-odbc-5.1.8-win32.msi"
        NSISdl::download http://www.mysql.com/get/Downloads/Connector-ODBC/5.1/mysql-connector-odbc-5.1.8-win32.msi/from/http://mysql.he.net/ $0
  InstallMySQLConnector:
  
  SetOutPath $INSTDIR\installer
  StrCpy $0 '"$INSTDIR\installer\Prerequisites\mysql-connector-odbc-5.1.8-win32.msi"'
  StrCpy $0 '"msiexec" /i $0'
  
  
  ExecWait $0
  
  MySQLConnectorDone:
        
FunctionEnd

Function InstallMySQLWorkbench

  MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to install MySQL on this computer?" IDNO MySQLWorkbenchDone IDYES StartMySQLWorkbench

  StartMySQLWorkbench:
  IfFileExists $INSTDIR\installer\Prerequisites\mysql-workbench-gpl-5.2.34.2-win32.msi InstallMySQLWorkbench DownloadMySQLWorkbench
  DownloadMySQLWorkbench:      
        SetOutPath $INSTDIR\installer\Prerequisites
        StrCpy $0  "mysql-workbench-gpl-5.2.34.2-win32.msi"
        NSISdl::download http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-gpl-5.2.34.2-win32.msi/from/http://mysql.he.net/ $0
  InstallMySQLWorkbench:
  
  SetOutPath $INSTDIR\installer
  StrCpy $0 '"$INSTDIR\installer\Prerequisites\mysql-workbench-gpl-5.2.34.2-win32.msi"'
  StrCpy $0 '"msiexec" /i $0'
 
  
  ExecWait $0
  
  MySQLWorkbenchDone:
        
FunctionEnd

var FedoraPassword
var FedoraUrl
var FedoraUsername
var MySQLIP
var MySQLUsername
var MySQLPassword
var MySQLPort
var SiteName
var CompanyName
var CompanyEmail
var SupportEmail
var Namespace




var password1
var password2



Function CheckIISVersion
 
    ClearErrors
    ReadRegDWORD $0 HKLM "SOFTWARE\Microsoft\InetStp" "MajorVersion"
    ReadRegDWORD $1 HKLM "SOFTWARE\Microsoft\InetStp" "MinorVersion"
 
    IfErrors 0 NoAbort
     Abort "Setup could not detect Microsoft Internet Information Server v5 or later; this is required for installation. Setup will continue, but you will have to configure your webserver manually."
 
    IntCmp $0 5 NoAbort IISMajVerLT5 NoAbort
 
    NoAbort:
        DetailPrint "Found Microsoft Internet Information Server v$0.$1"
        Goto ExitFunction
 
    IISMajVerLT5:
        Abort "Setup could not detect Microsoft Internet Information Server v5 or later; this is required for installation. Setup will continue, but you will have to configure your webserver manually."
 
    ExitFunction:
 
FunctionEnd


  
Function MySQLConnectionEnter
!insertmacro MUI_HEADER_TEXT "MySQL Setup" "The 3DR will need these values to connect to your MySQL database"
  # If you need to skip the page depending on a condition, call Abort.
  ReserveFile "MySQLConnection.ini"
  !insertmacro INSTALLOPTIONS_EXTRACT "MySQLConnection.ini"
  !insertmacro INSTALLOPTIONS_DISPLAY "MySQLConnection.ini"
FunctionEnd
 
Function MySQLConnectionLeave
  # Form validation here. Call Abort to go back to the page.
  # Use !insertmacro MUI_INSTALLOPTIONS_READ $Var "InstallOptionsFile.ini" ...
  # to get values.
  !insertmacro INSTALLOPTIONS_READ $MySQLIP "MySQLConnection.ini" "Field 1" "State"
  !insertmacro INSTALLOPTIONS_READ $MySQLUsername "MySQLConnection.ini" "Field 2" "State"
  !insertmacro INSTALLOPTIONS_READ $MySQLPort "MySQLConnection.ini" "Field 10" "State"
  !insertmacro INSTALLOPTIONS_READ $password1 "MySQLConnection.ini" "Field 3" "State"
  !insertmacro INSTALLOPTIONS_READ $password2 "MySQLConnection.ini" "Field 4" "State"
  ${if} $password1 == $password2
        StrCpy $MySQLPassword $password1
  ${else}
        MessageBox MB_OK "Passwords do not match"
        abort
  ${endif}       
   
 
FunctionEnd


Function SettingsEnter
!insertmacro MUI_HEADER_TEXT "MySQL Setup" "The 3DR will need these values to connect to your MySQL database"
  # If you need to skip the page depending on a condition, call Abort.
  ReserveFile "SiteSettings.ini"
  !insertmacro INSTALLOPTIONS_EXTRACT "SiteSettings.ini"
  !insertmacro INSTALLOPTIONS_DISPLAY "SiteSettings.ini"
FunctionEnd
 
var batchfile
Function SettingsLeave
  # Form validation here. Call Abort to go back to the page.
  # Use !insertmacro MUI_INSTALLOPTIONS_READ $Var "InstallOptionsFile.ini" ...
  # to get values.
  !insertmacro INSTALLOPTIONS_READ $SiteName "SiteSettings.ini" "Field 1" "State"
  !insertmacro INSTALLOPTIONS_READ $CompanyName "SiteSettings.ini" "Field 2" "State"
  !insertmacro INSTALLOPTIONS_READ $CompanyEmail "SiteSettings.ini" "Field 3" "State"
  !insertmacro INSTALLOPTIONS_READ $SupportEmail "SiteSettings.ini" "Field 4" "State"
  !insertmacro INSTALLOPTIONS_READ $Namespace "SiteSettings.ini" "Field 5" "State"
  ${if} $Namespace == "adl"
        MessageBox MB_OK "The namespace ADL is reserved. Please enter a unique 3 letter string."
        abort
  ${endif}       
    ${if} $Namespace == "ADL"
        MessageBox MB_OK "The namespace ADL is reserved. Please enter a unique 3 letter string."
        abort
  ${endif}     
    ${if} $Namespace == "Adl"
        MessageBox MB_OK "The namespace ADL is reserved. Please enter a unique 3 letter string."
        abort
  ${endif}  
    ${if} $Namespace == ""
        MessageBox MB_OK "The namespace can not be blank. Please enter a unique 3 letter string."
        abort
  ${endif}        
   
  CALL WriteConfigFile

  ${if} $MySQLIP == "localhost"
  
	  Call FindMySQL
	  
	  ExecWait "$R3\mysqld.exe"
	  strcpy $0 '"$R3\mysql.exe" --user=$MySQLUsername --password=$MySQLPassword < "$InstDir\Database\setup.sql"'
	  
	  FileOpen $batchfile "$InstDir\sql.bat" w
	  FileWrite $batchfile $0
	  FileClose $batchfile
	  
	  ExecWait "$InstDir\sql.bat" 
	  Delete "$InstDir\sql.bat"
  
  ${else}
    MessageBox MB_OK "If the MySQL server is not this machine, you will have to run the create_tables.sql script manually."
  ${endif}
      
FunctionEnd 
 
Function FedoraConnectionEnter
!insertmacro MUI_HEADER_TEXT "Fedora Commons Setup" "The 3DR will need these values to connect to your Fedora Commons Repository"
  # If you need to skip the page depending on a condition, call Abort.
  ReserveFile "fedoraConnection.ini"
  !insertmacro INSTALLOPTIONS_EXTRACT "fedoraConnection.ini"
  !insertmacro INSTALLOPTIONS_DISPLAY "fedoraConnection.ini"
FunctionEnd
 

Function FedoraConnectionLeave
  # Form validation here. Call Abort to go back to the page.
  !insertmacro INSTALLOPTIONS_READ $FedoraUrl "fedoraConnection.ini" "Field 1" "State"
  !insertmacro INSTALLOPTIONS_READ $FedoraUsername "fedoraConnection.ini" "Field 2" "State"
  !insertmacro INSTALLOPTIONS_READ $password1 "fedoraConnection.ini" "Field 3" "State"
  !insertmacro INSTALLOPTIONS_READ $password2 "fedoraConnection.ini" "Field 4" "State"
  ${if} $password1 == $password2
        StrCpy $FedoraPassword $password1
  ${else}
        MessageBox MB_OK "Passwords do not match"
        abort
  ${endif}       
   
  
  # to get values.
FunctionEnd

Function FindMySQL
    
    strcpy $3 "$PROGRAMFILES\MySQL\MySQL Server 5.5\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES\MySQL\MySQL Server 5.4\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES\MySQL\MySQL Server 5.3\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES\MySQL\MySQL Server 5.2\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES\MySQL\MySQL Server 5.1\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES\MySQL\MySQL Server 5.0\bin"
    IFFileExists  "$3\mysqld.exe" done
    
    strcpy $3 "$PROGRAMFILES64\MySQL\MySQL Server 5.5\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES64\MySQL\MySQL Server 5.4\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES64\MySQL\MySQL Server 5.3\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES64\MySQL\MySQL Server 5.2\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES64\MySQL\MySQL Server 5.1\bin"
    IFFileExists  "$3\mysqld.exe" done
    strcpy $3 "$PROGRAMFILES64\MySQL\MySQL Server 5.0\bin"
    IFFileExists  "$3\mysqld.exe" done
    
    strcpy $3 "not found"

    done:
     strcpy $r3 $3
     
     ${if} $r3 == "not found"
        MessageBox MB_OK "Could not locate MySql installation"
     ${endif}
FunctionEnd

var ConfigFile
Function WriteConfigFile
    
        
       
        #!macro _ReplaceInFile SOURCE_FILE SEARCH_TEXT REPLACEMENT
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[FedoraUsername]]" $FedoraUsername
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[FedoraPassword]]" $FedoraUsername
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[FedoraUrl]]" $FedoraURL
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[MySQLIP]]" $MySQLIP
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[MySQLPort]]" $MySQLPort
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[MySQLAdmin]]" $MySQLUsername
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[MySQLPassword]]" $MySQLPassword
        
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[SiteName]]" $SiteName
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[CompanyName]]" $CompanyName
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[CompanyEmail]]" $CompanyEmail
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[SupportEmail]]" $SupportEmail
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[FedoraNamespace]]" $Namespace
        
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[3DToolsDir]]" "$Instdir\Vwarweb\Bin"
        
   
    
FunctionEnd



# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r /x *.svn* ..\*
    File /oname=$INSTDIR\Vwarweb\web.config ..\VwarWeb\web.config.installer.template 
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
    CALL InstallMySQL
    CALL InstallFedora
    CALL InstallMySQLConnector
    CALL InstallMySQLWorkbench
SectionEnd


Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o -un.Main UNSEC0000
    RmDir /r /REBOOTOK $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $INSTDIR
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
    Call SetupDotNetSectionIfNeeded
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd
