; -------------------------------
; Start
 
 
  Name "Graylog Collector Sidecar"
  !define VERSION "0.0.9"
  !define MUI_FILE "savefile"
  !define MUI_BRANDINGTEXT "Graylog Collector Sidecar v${VERSION}"
  CRCCheck On
 
  !include "${NSISDIR}\Contrib\Modern UI\System.nsh"
 
	VIProductVersion "0.${VERSION}"
	VIAddVersionKey "FileVersion" "${VERSION}"
 
;---------------------------------
;General
 
  OutFile "pkg/graylog_collector_sidecar_installer_${VERSION}_x64.exe"
  ShowInstDetails "nevershow"
  ShowUninstDetails "nevershow"
  ;SetCompressor "bzip2"
 
  ;!define MUI_ICON ""
  ;!define MUI_UNICON ""
  ;!define MUI_SPECIALBITMAP ""
 
 
;--------------------------------
;Folder selection page
 
  InstallDir "$PROGRAMFILES\graylog\collector-sidecar"
 
 
;--------------------------------
;Modern UI Configuration
 
  !define MUI_WELCOMEPAGE  
  !define MUI_LICENSEPAGE
  !define MUI_DIRECTORYPAGE
  !define MUI_ABORTWARNING
  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE
  !define MUI_FINISHPAGE  
 
 
;--------------------------------
;Language
 
  !insertmacro MUI_LANGUAGE "English"
 
 
;-------------------------------- 
;Modern UI System
 
  ;!insertmacro MUI_SYSTEM 
 
 
;--------------------------------
;Data
 
  LicenseData "../COPYING"
 
 
;-------------------------------- 
;Installer Sections     
Section "Install"
 
;Add files
  SetOutPath "$INSTDIR\generated"  
  SetOutPath "$INSTDIR"
 
  File "../build/${VERSION}/windows/amd64/graylog-collector-sidecar.exe"
  File "collectors/winlogbeat/windows/winlogbeat.exe"
  File "collectors/filebeat/windows/filebeat.exe"
  File /oname=collector_sidecar.yml "../collector_sidecar_windows.yml"
  File "../COPYING"

  WriteUninstaller "$INSTDIR\uninstall.exe"
 
SectionEnd
 
 
;--------------------------------    
;Uninstaller Section  
Section "Uninstall"
 
;Delete Files 
  RMDir /r "$INSTDIR\*.*"    
 
;Remove the installation directory
  RMDir "$INSTDIR"
  RMDir "$PROGRAMFILES\graylog"
 
SectionEnd
 
 
;--------------------------------    
;MessageBox Section
 
 
;Function that calls a messagebox when installation finished correctly
Function .onInstSuccess
  MessageBox MB_OK "You have successfully installed Graylog Collector Sidecar." /SD IDOK
FunctionEnd
 
 
Function un.onUninstSuccess
  MessageBox MB_OK "You have successfully uninstalled Graylog Collector Sidecar." /SD IDOK
FunctionEnd
