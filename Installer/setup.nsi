# Auto-generated by EclipseNSIS Script Wizard
# Aug 23, 2011 9:22:47 AM

Name "3D Repository"

!include StrFunc.nsh
!include EnvVarUpdate.nsh

!include java.nsi
!include DotNet.nsi
!include defines.nsh
!include InstallOptions.nsh
!include FileReplace.nsi
!include Upgrade.nsi
RequestExecutionLevel highest

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 1.0
!define COMPANY ADL
!define URL www.adlnet.gov

!define FileCopy `!insertmacro FileCopy`
!macro FileCopy FilePath TargetDir
  CreateDirectory `${TargetDir}`
  CopyFiles `${FilePath}` `${TargetDir}`
!macroend

# MUI Symbol Definitions
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-colorful.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
#!define MUI_FINISHPAGE_RUN $ADMINTOOLS
#!define MUI_FINISHPAGE_SHOWREADME $ADMINTOOLS
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-colorful.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE



!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_INFO ""
!define MUI_COMPONENTSPAGE_TEXT_COMPLIST "Choose which components to install. If you do not wish to set up Fedora Commons or MySql on this computer, you must supply connection information so the 3DR can connect to the databases."

# Included files
!include Sections.nsh
!include MUI2.nsh
!define MUI_COMPONENTSPAGE_SMALLDESC

# Installer pages
!define MUI_PAGE_CUSTOMFUNCTION_PRE skipIfUpgrade
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_CUSTOMFUNCTION_PRE skipIfUpgrade
!insertmacro MUI_PAGE_LICENSE "creative comons.txt"
!define MUI_PAGE_CUSTOMFUNCTION_PRE skipIfUpgrade
!insertmacro MUI_PAGE_DIRECTORY
!define MUI_PAGE_CUSTOMFUNCTION_PRE DisableComponentsIfNecessary
!insertmacro MUI_PAGE_COMPONENTS
Page Custom UpgradeEnter UpgradeLeave
!insertmacro MUI_PAGE_INSTFILES



function skipIfUpgrade
	${if} $isUpgrade == "true"
		ABORT
	${endif}
functionend


Page Custom FedoraConnectionEnter FedoraConnectionLeave
Page Custom MySQLConnectionEnter MySQLConnectionLeave
Page Custom SettingsEnter SettingsLeave
Page Custom Settings2Enter Settings2Leave
Page Custom Settings3Enter Settings3Leave

!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile "3DR_setup_%BUILDNUMBER%.exe"
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


InstType /COMPONENTSONLYONCUSTOM
InstType "Full install on local machine" 

# Installer sections
Section -Main SEC0000
	LogSet on
	SectionIn 1
    SetOutPath $INSTDIR
    SetOverwrite on
    File /a /r /x *.git* /x *.svn* /x 3dr_setup* /x IISConfigure /x vwardal /x 3d.service.implementation /x assemblies /x away3D_viewer /x build_tools /x config /x ConverterWrapper /x DMG_Forums_3-2 /x FederatedAPI /x FederatedAPI.implementation /x OrbitOne.OpenId.Controls /x OrbitOne.OpenId.MembershipProvider /x _UpgradeReport_Files /x *vwarsolution.* /x SimpleMySqlProvider /x testing /x vwar.uploader ..\*
    File /a /oname=$INSTDIR\Vwarweb\web.config ..\VwarWeb\web.config.installer.template
    File /a /oname=$INSTDIR\3d.service.host\web.config ..\3d.service.host\web.config.installer.template
    SetOutPath $INSTDIR\Vwarweb\Bin
    File /a ..\..\..\adlsvn.adlnet.gov\3DTools\trunk\bin\*.dll  
    SetOutPath $INSTDIR\Vwarweb\Bin\osgPlugins-2.9.12
    File /a ..\..\..\adlsvn.adlnet.gov\3DTools\trunk\bin\osgPlugins-2.9.12\*.dll  
    
    
     
    WriteRegStr HKLM "${REGKEY}\Components" Main 1

SectionEnd

Section -Upgrade UPGRADESEC
	LogSet on
	
	Execwait '$instdir\installer\IISConfigure.exe /stop'
	sleep 5000
	${FileCopy} "$INSTDIR\Vwarweb\web.config" "$INSTDIR\Backups\Vwarweb\"
	${FileCopy} "$INSTDIR\3d.service.host\web.config" "$INSTDIR\Backups\3d.service.host\"
	
	SetOverwrite on
	strcpy $INSTDIR $UpgradePath
	SetOutPath $INSTDIR
    File /a /r /x *.git* /x *.svn* /x 3dr_setup* /x IISConfigure /x vwardal /x 3d.service.implementation /x assemblies /x away3D_viewer /x build_tools /x config /x ConverterWrapper /x DMG_Forums_3-2 /x FederatedAPI /x FederatedAPI.implementation /x OrbitOne.OpenId.Controls /x OrbitOne.OpenId.MembershipProvider /x _UpgradeReport_Files /x *vwarsolution.* /x SimpleMySqlProvider /x testing /x vwar.uploader ..\*
    File /a /oname=$INSTDIR\Vwarweb\web.config ..\VwarWeb\web.config.installer.template
    File /a /oname=$INSTDIR\3d.service.host\web.config ..\3d.service.host\web.config.installer.template
    SetOutPath $INSTDIR\Vwarweb\Bin
    File /a ..\..\..\adlsvn.adlnet.gov\3DTools\trunk\bin\*.dll  
    SetOutPath $INSTDIR\Vwarweb\Bin\osgPlugins-2.9.12
    File /a ..\..\..\adlsvn.adlnet.gov\3DTools\trunk\bin\osgPlugins-2.9.12\*.dll  
    
    Execwait '$instdir\installer\IISConfigure.exe /start'
SectionEnd
var fedorabatchfile
Section "Fedora Commons" SECTIONFEDORA
	SectionIn 1
	CALL InstallJDK
    CALL InstallFedora   
    SetOutPath  "C:\fedora\tomcat\bin\"
    
     strcpy $0 "C:\fedora\tomcat\bin\startup.bat"
		  
	 FileOpen $fedorabatchfile "$InstDir\fedstart.bat" w
	 FileWrite $fedorabatchfile $0
	 FileClose $fedorabatchfile
		  
	 ExecWait "$InstDir\fedstart.bat" 
	 Delete "$InstDir\fedstart.bat"
		  
    
    
   EXEC "C:\fedora\tomcat\bin\startup.bat"
   
   WriteRegStr HKLM "software\microsoft\windows\currentversion\run" "FedoraCommons" "cmd.exe /c C:\fedora\tomcat\bin\startup.bat"  
   SetRebootFlag true
SectionEnd

Section "MySQL Database" SECTIONMYSQL
	SectionIn 1
    CALL InstallMySQL
    CALL InstallMySQLConnector
SectionEnd

Section "MySQL WorkBench" SECTIONMYSQLWORKBENCH
	SectionIn 1
    CALL InstallMySQLWorkbench
SectionEnd

Section "IIS Configuration" SECTIONIIS
	SectionIn 1
	Call ConfigureIIS7
	execwait "$WINDIR\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe -i"
SectionEnd

Section "VC++ Redistributable" SECTIONVPPREDIST
	 SectionIn 1
	 CALL InstallMSMCRT
SectionEnd

Section -post SEC0001
	SectionIn 1
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
SectionEnd

LangString DESC_SECTIONVPPREDIST ${LANG_ENGLISH} "These Windows system components are required for 3D file format conversion."
LangString DESC_SECTIONIIS ${LANG_ENGLISH} "This will attempt to configure the local IIS Server to run the 3DR."
LangString DESC_SECTIONMYSQLWORKBENCH ${LANG_ENGLISH} "This is a useful tool for administration of MySQL databases. Recomended but not required."
LangString DESC_SECTIONMYSQL ${LANG_ENGLISH} "This database will contain the metadata and user information used by the 3DR."
LangString DESC_SECTIONFEDORA ${LANG_ENGLISH} "This repository software will host the content files posted to the 3DR."
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SECTIONVPPREDIST} $(DESC_SECTIONVPPREDIST)
  !insertmacro MUI_DESCRIPTION_TEXT ${SECTIONIIS} $(DESC_SECTIONIIS)
  !insertmacro MUI_DESCRIPTION_TEXT ${SECTIONMYSQLWORKBENCH} $(DESC_SECTIONMYSQLWORKBENCH)
  !insertmacro MUI_DESCRIPTION_TEXT ${SECTIONMYSQL} $(DESC_SECTIONMYSQL)
  !insertmacro MUI_DESCRIPTION_TEXT ${SECTIONFEDORA} $(DESC_SECTIONFEDORA)
  !insertmacro MUI_DESCRIPTION_TEXT ${SECDOTNET} $(DESC_LONGDOTNET)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

function DisableComponentsIfNecessary
	${if} $isUpgrade == "true"
		ABORT
	${endif}
	call FindMySQL
	${if} $r3 != "not found"
		${UnSelectSection2} ${SECTIONMYSQL}
	${endif}
	
	SearchPath $r3 "fedora-rebuild.sh"
	strcmp $r3 "" needit dontneedit
	dontneedit:
		${UnSelectSection2} ${SECTIONFEDORA}
	needit:
	
	ReadRegDWORD $r3 HKLM "SOFTWARE\Microsoft\InetStp" "MajorVersion"
	
	IntCmp $r3 7 continue disable continue
	
	disable:
		${UnSelectSection2} ${SECTIONIIS}
	continue:
	
	
	
functionend

var FedoraJar
Function DownloadFedora

  StartFedora:
  IfFileExists $INSTDIR\installer\Prerequisites\fcrepo-installer-3.5.jar InstallFedora1 DownloadFedora
  DownloadFedora:      
        SetOutPath $INSTDIR\installer\Prerequisites
        StrCpy $0  "fcrepo-installer-3.5.jar"
        NSISdl::download http://downloads.sourceforge.net/fedora-commons/fcrepo-installer-3.5.jar $0
  InstallFedora1:
        StrCpy $FedoraJar "$INSTDIR\installer\Prerequisites\fcrepo-installer-3.5.jar"
  
FunctionEnd

Function GetJDKPath

strcpy $0 "Not Found"

IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0_20" JDK16_20_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0_20" JDK16_20 0

  IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0_21" JDK16_21_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0_21" JDK16_21 0

  IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0_22" JDK16_22_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0_22" JDK16_22 0

  IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0_23" JDK16_23_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0_23" JDK16_23 0

  IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0_24" JDK16_24_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0_24" JDK16_24 0
  
  IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0_25" JDK16_25_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0_25" JDK16_25 0
    
  IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0_26" JDK16_26_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0_26" JDK16_26 0
  
  IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0_27" JDK16_27_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0_27" JDK16_27 0
  
  IfFileExists "c:\Program Files (x86)\Java\jdk1.6.0" JDK16_86 0
  IfFileExists "c:\Program Files\Java\jdk1.6.0" JDK16 0
  
  IfFileExists "c:\Program Files (x86)\Java\jdk1.7.0" JDK17_86 0
  IfFileExists "c:\Program Files\Java\jdk1.7.0" JDK17 0
  
    JDK16_20_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0_20"
  	goto VARSDONE
  	JDK16_20:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0_20"
  	goto VARSDONE
     JDK16_21_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0_21"
  	goto VARSDONE
  	JDK16_21:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0_21"
  	goto VARSDONE
     JDK16_22_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0_22"
  	goto VARSDONE
  	JDK16_22:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0_22"
  	goto VARSDONE
     JDK16_23_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0_23"
  	goto VARSDONE
  	JDK16_23:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0_23"
  	goto VARSDONE
     JDK16_24_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0_24"
  	goto VARSDONE
  	JDK16_24:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0_24"
  	goto VARSDONE
     JDK16_25_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0_25"
  	goto VARSDONE
  	JDK16_25:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0_25"
  	goto VARSDONE
     JDK16_26_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0_26"
  	goto VARSDONE
  	JDK16_26:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0_26"
  	goto VARSDONE
    JDK16_27_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0_27"
  	goto VARSDONE
  	JDK16_27:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0_27"
  	goto VARSDONE
  	JDK16_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.6.0"
  	goto VARSDONE
  	JDK16:
  	strcpy $0 "c:\Progra~1\Java\jdk1.6.0"
  	goto VARSDONE
  	JDK17_86:
  	strcpy $0 "c:\Progra~2\Java\jdk1.7.0"
  	goto VARSDONE
  	JDK17:
  	strcpy $0 "c:\Progra~1\Java\jdk1.7.0"
  	
  	VARSDONE:

FUNCTIONEND



var JREHOME
FUNCTION SetEnvVars

  WriteRegExpandStr ${hkcu_current_user} "SYSTEM\CurrentControlSet\Control\Session Manager\Environment\FEDORA_HOME" ""
  WriteRegExpandStr ${hkcu_current_user} "SYSTEM\CurrentControlSet\Control\Session Manager\Environment\CATALINA_HOME" ""
  WriteRegExpandStr ${hkcu_current_user} "SYSTEM\CurrentControlSet\Control\Session Manager\Environment\JAVA_HOME" ""
  
  
  ${EnvVarUpdate}  $0 "FEDORA_HOME" "A" "HKLM" "C:\Fedora"
  ${EnvVarUpdate}  $0 "CATALINA_HOME" "A" "HKLM" "C:\Fedora\tomcat"
  ${EnvVarUpdate}  $0 "PATH" "A" "HKLM" "%FEDORA_HOME%\server\bin"
  ${EnvVarUpdate}  $0 "PATH" "A" "HKLM" "$JREHOME"
  
  CALL GetJDKPath
  ${EnvVarUpdate}  $0 "JAVA_HOME" "A" "HKLM" "$0"
  FUNCTIONEND

Function InstallFedora

  #MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to install Fedora Commons on this computer?" IDNO FedoraDone1 IDYES 0
  CALL DownloadFedora
  Call GetJRE
  Pop $R0
  strcpy $JREHOME $r0
  ${StrRep} $JREHOME $r0 "\bin" ""
  ; change for your purpose (-jar etc.)
  ${GetParameters} $1
  
  StrCpy $0 '"$R0" -jar "$FedoraJar"'
  
  SetOutPath $INSTDIR\installer
  Sleep 1000
  ExecWait $0
  
  CALL SetEnvVars

  FedoraDone1:
        
FunctionEnd

Function InstallMySQL

 # MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to install MySQL on this computer?" IDNO MySQLDone IDYES StartMySQL

  StartMySQL:
  IfFileExists $INSTDIR\installer\Prerequisites\mysql-5.5.15-win32.msi InstallMySQL DownloadMySQL
  DownloadMySQL:      
        SetOutPath $INSTDIR\installer\Prerequisites
        StrCpy $0  "mysql-5.5.15-win32.msi"
        NSISdl::download http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.15-win32.msi/from/http://mysql.he.net/ $0
  InstallMySQL:
  
  SetOutPath $INSTDIR\installer
  StrCpy $0 '"$INSTDIR\installer\Prerequisites\mysql-5.5.15-win32.msi"'
  StrCpy $0 '"msiexec" /i $0 /quiet'
 
 
  
  ExecWait $0
  
  CALL FindMySQL
  ${StrRep} $r2 $r3 "\bin" "" 
  strcpy $4 '$r3\MySQLInstanceConfig.exe' # -i -q "-lC:\mysql_install_log.txt" "-nMySQL Server 5.5" "-p$r2" -v5.5.15 "-t$r2\my-template.ini" "-c$r2\My.ini" ServerType=DEVELOPMENT DatabaseType=MIXED ConnectionUsage=DSS Port=$MySQLPort ServiceName=MySQL55 RootPassword=$MySQLPassword'
  
  execwait $4
  MySQLDone:
        
FunctionEnd

Function InstallMySQLConnector

 # MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to install MySQL ODBC Connector on this computer?" IDNO MySQLConnectorDone IDYES StartMySQLConnector

  StartMySQLConnector:
  IfFileExists $INSTDIR\installer\Prerequisites\mysql-connector-odbc-5.1.8-win32.msi InstallMySQLConnector DownloadMySQLConnector
  DownloadMySQLConnector:      
        SetOutPath $INSTDIR\installer\Prerequisites
        StrCpy $0  "mysql-connector-odbc-5.1.8-win32.msi"
        NSISdl::download http://www.mysql.com/get/Downloads/Connector-ODBC/5.1/mysql-connector-odbc-5.1.8-win32.msi/from/http://mysql.he.net/ $0
  InstallMySQLConnector:
  
  SetOutPath $INSTDIR\installer
  StrCpy $0 '"$INSTDIR\installer\Prerequisites\mysql-connector-odbc-5.1.8-win32.msi"'
  StrCpy $0 '"msiexec" /i $0 /quiet'
  
  
  ExecWait $0
  
  MySQLConnectorDone:
        
FunctionEnd

Function InstallJDK


  CALL GetJDKPath
  ${if} $0 == "Not Found"
	  StartJDK:
	  IfFileExists $INSTDIR\installer\Prerequisites\jre-1_5_0_16-windows-i586-p.exe InstallJDK DownloadJDK
	  DownloadJDK:      
	        SetOutPath $INSTDIR\installer\Prerequisites
	        StrCpy $0  "jre-1_5_0_16-windows-i586-p.exe"
	        NSISdl::download "http://javadl.sun.com/webapps/download/AutoDL?BundleId=22933&/jre-1_5_0_16-windows-i586-p.exe" $0
	  InstallJDK:
	  
	  SetOutPath $INSTDIR\installer
	  StrCpy $0 '"$INSTDIR\installer\Prerequisites\jre-1_5_0_16-windows-i586-p.exe"'
	  StrCpy $0 '$0 /s'
  ExecWait $0
  ${endif}
  
  

FunctionEND

Function InstallMySQLWorkbench

  #MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to install MySQL Administrator on this computer? (Recomended but not required)" IDNO MySQLWorkbenchDone IDYES StartMySQLWorkbench

  StartMySQLWorkbench:
  IfFileExists $INSTDIR\installer\Prerequisites\mysql-gui-tools-5.0-r17-win32.msi InstallMySQLWorkbench DownloadMySQLWorkbench
  DownloadMySQLWorkbench:      
        SetOutPath $INSTDIR\installer\Prerequisites
        StrCpy $0  "mysql-gui-tools-5.0-r17-win32.msi"
        NSISdl::download http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-gui-tools-5.0-r17-win32.msi/from/http://mysql.he.net/ $0
  InstallMySQLWorkbench:
  
  SetOutPath $INSTDIR\installer
  StrCpy $0 '"$INSTDIR\installer\Prerequisites\mysql-gui-tools-5.0-r17-win32.msi"'
  StrCpy $0 '"msiexec" /i $0 /quiet'
 
  
  ExecWait $0
  
  MySQLWorkbenchDone:
        
FunctionEnd

Function InstallMSMCRT

push $0
  SetOutPath $INSTDIR\installer
  StrCpy $0 'msiexec /i "$INSTDIR\installer\Prerequisites\MSM.msi" /quiet'

  ExecWait $0
pop $0

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

var _3DRAdminUsername
var _3DRAdminPassword

var SMTPServer
var SMTPUsername
var SMTPPassword

var password1
var password2

var batchfile

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


function UpgradeEnter
	${if} $isUpgrade != "true"
		${UnSelectSection} ${UPGRADESEC}
		ABORT
	${else}
		
	${endif}
	
	ReserveFile "SiteSettings.ini"
   !insertmacro INSTALLOPTIONS_EXTRACT "upgrade.ini"
   !insertmacro INSTALLOPTIONS_DISPLAY "upgrade.ini"
	
    ${UnSelectSection} ${SECDOTNET}
	${UnSelectSection} ${SECTIONFEDORA}
	${UnSelectSection} ${SECTIONMYSQL}
	${UnSelectSection} ${SECTIONIIS}
	${UnSelectSection} ${SECTIONVPPREDIST}
	${UnSelectSection} ${SEC0000}
	${UnSelectSection} ${SECTIONMYSQLWORKBENCH}
	${SelectSection} ${UPGRADESEC}
	
functionend
function UpgradeLeave

	
    
functionend

Function SettingsEnter
!insertmacro MUI_HEADER_TEXT "Site Settings" "These settings will be used to customize your website."
  # If you need to skip the page depending on a condition, call Abort.
  ReserveFile "SiteSettings.ini"
  !insertmacro INSTALLOPTIONS_EXTRACT "SiteSettings.ini"
  !insertmacro INSTALLOPTIONS_DISPLAY "SiteSettings.ini"
FunctionEnd
 

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
         
FunctionEnd 



Function Settings2Enter
!insertmacro MUI_HEADER_TEXT "Administrator Account" "This user name and account will be the default administrator login and password."
  # If you need to skip the page depending on a condition, call Abort.
  ReserveFile "SiteSettings2.ini"
  !insertmacro INSTALLOPTIONS_EXTRACT "SiteSettings2.ini"
  !insertmacro INSTALLOPTIONS_DISPLAY "SiteSettings2.ini"
FunctionEnd
 
Function Settings2Leave
  # Form validation here. Call Abort to go back to the page.
  # Use !insertmacro MUI_INSTALLOPTIONS_READ $Var "InstallOptionsFile.ini" ...
  # to get values.
  !insertmacro INSTALLOPTIONS_READ $_3DRAdminUsername "SiteSettings2.ini" "Field 1" "State"
  !insertmacro INSTALLOPTIONS_READ $password1 "SiteSettings2.ini" "Field 2" "State"
  !insertmacro INSTALLOPTIONS_READ $password2 "SiteSettings2.ini" "Field 3" "State"
  ${if} $password1 != $password2
        MessageBox MB_OK "The passwords do not match."
        abort
  ${endif}        
  strcpy $_3DRAdminPassword $password1   
    
FunctionEnd 

Function Settings3Enter
!insertmacro MUI_HEADER_TEXT "Email Settings" "The 3DR will need these values to send emails to users."
  # If you need to skip the page depending on a condition, call Abort.
  ReserveFile "SiteSettings3.ini"
  !insertmacro INSTALLOPTIONS_EXTRACT "SiteSettings3.ini"
  !insertmacro INSTALLOPTIONS_DISPLAY "SiteSettings3.ini"
FunctionEnd
 
Function Settings3Leave
  # Form validation here. Call Abort to go back to the page.
  # Use !insertmacro MUI_INSTALLOPTIONS_READ $Var "InstallOptionsFile.ini" ...
  # to get values.
  !insertmacro INSTALLOPTIONS_READ $SMTPUsername "SiteSettings3.ini" "Field 1" "State"
  !insertmacro INSTALLOPTIONS_READ $password1 "SiteSettings3.ini" "Field 2" "State"
  !insertmacro INSTALLOPTIONS_READ $password2 "SiteSettings3.ini" "Field 3" "State"
  !insertmacro INSTALLOPTIONS_READ $SMTPServer "SiteSettings3.ini" "Field 4" "State"
  ${if} $password1 != $password2
        MessageBox MB_OK "The passwords do not match."
        abort
  ${endif}        
  strcpy $SMTPPassword $password1   
  CALL PostSettings   
FunctionEnd 


Function PostSettings


  CALL WriteConfigFile

 # ${if} $MySQLIP == "localhost"
  
	  Call FindMySQL
	  
	 
  	  ${if} $IsUpgrade != "true"
	  	  ExecWait "$R3\mysqld.exe"
		  strcpy $0 '"$PLUGINSDIR\mysql.exe" --host=$MySQLIP --port=$MYSQLPORT --user=$MySQLUsername --password=$MySQLPassword < "$InstDir\Database\setup.sql"'
		  
		  FileOpen $batchfile "$InstDir\sql.bat" w
		  FileWrite $batchfile $0
		  FileClose $batchfile
		  
		  ExecWait "$InstDir\sql.bat" 
		  Delete "$InstDir\sql.bat"
  	  ${else}
  	      ExecWait "$r3\mysqld.exe"
  	      
  	      strcpy $0 '"$PLUGINSDIR\mysqldump.exe" --host=$MySQLIP --port=$MYSQLPORT --user=$MySQLUsername --password=$MySQLPassword 3dr > "$InstDir\Backups\Database.bak.sql"'
		  strcpy $1 '"$PLUGINSDIR\mysql.exe" --host=$MySQLIP --port=$MYSQLPORT --user=$MySQLUsername --password=$MySQLPassword < "$InstDir\Database\upgrade.sql"'
		  
		  FileOpen $batchfile "$InstDir\sql.bat" w
		  FileWrite $batchfile $0
		  FileClose $batchfile
		  
		  ExecWait "$InstDir\sql.bat" 
		  Delete "$InstDir\sql.bat"
		  
		  FileOpen $batchfile "$InstDir\sql.bat" w
		  FileWrite $batchfile $1
		  FileClose $batchfile
		  
		  ExecWait "$InstDir\sql.bat" 
		  Delete "$InstDir\sql.bat"
  	  ${endif}
  	  
  #${else}
  #  MessageBox MB_OK "If the MySQL server is not this machine, you will have to run the create_tables.sql script manually."
  #${endif}
  
	ExecWait 'icacls "$instdir" /T /grant IIS_IUSRS:(f)'

FunctionEnd 
 
Function FedoraConnectionEnter
!insertmacro MUI_HEADER_TEXT "Fedora Commons Setup" "The 3DR will need these values to connect to your Fedora Commons Repository. Use the same values you used when installing Fedora. If you used the 'Quick' Fedora install option, you only need to enter the password below."
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
     
   #  ${if} $r3 == "not found"
   #     MessageBox MB_OK "Could not locate MySql installation"
   #  ${endif}
FunctionEnd

var ConfigFile
Function WriteConfigFile
    
        
       
        #!macro _ReplaceInFile SOURCE_FILE SEARCH_TEXT REPLACEMENT
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[FedoraUsername]]" $FedoraUsername
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[FedoraPassword]]" $FedoraPassword
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
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[DefaultAdminName]]" $_3DRAdminUsername
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[DefaultAdminPassword]]" $_3DRAdminPassword
        
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[SMTPUsername]]" $SMTPUsername
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[SMTPPassword]]" $SMTPPassword
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[SMTPServer]]" $SMTPServer        
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[3DToolsDir]]" "$Instdir\Vwarweb\Bin"
        
        !insertmacro _ReplaceInFile "$INSTDIR\Vwarweb\web.config" "[[APILocation]]" "http://localhost/API/_3DRAPI.svc/"
        
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[FedoraUsername]]" $FedoraUsername
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[FedoraPassword]]" $FedoraPassword
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[FedoraUrl]]" $FedoraURL
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[MySQLIP]]" $MySQLIP
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[MySQLPort]]" $MySQLPort
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[MySQLAdmin]]" $MySQLUsername
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[MySQLPassword]]" $MySQLPassword
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[FedoraNamespace]]" $Namespace
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[DefaultAdminName]]" $_3DRAdminUsername
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[3DToolsDir]]" "$Instdir\Vwarweb\Bin"
        
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[OrganizationName]]" $CompanyName
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[OrganizationPOCEmail]]" $SupportEmail
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[OrganizationURL]]" $CompanyName
        !insertmacro _ReplaceInFile "$INSTDIR\3d.service.host\web.config" "[[OrganizationPOC]]" $SupportEmail
       
		
        ExecWait 'icacls "$INSTDIR\3d.service.host\web.config" /grant IIS_IUSRS:(f)'
        ExecWait 'icacls "$INSTDIR\Vwarweb\web.config" /grant IIS_IUSRS:(f)'
    
FunctionEnd
#broken!
Function ConfigureIIS7
	
	Execwait '$instdir\installer\IISConfigure.exe /i "$instdir"'
   

	ConfigIISDone:

FunctionEnd



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
    SetOutPath "$PLUGINSDIR"
    File "mysql.EXE"
    File "mysqldump.EXE"
    Call SetupDotNetSectionIfNeeded
    Call SetupUpgradeSectionIfNeeded 
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

