; ----------------------------------------------------------------------------
; NetReflector - Installation Script
; Author: Tristan Marlow
; Purpose: Install application
;
; ----------------------------------------------------------------------------
; Copyright (c) 2017 Little Earth Solutions
; Copyright (c) 2017 Tristan David Marlow
; All Rights Reserved
;
; This product is protected by copyright and distributed under
; licenses restricting copying, distribution and decompilation      
;
;-----------------------------------------------------------------------------
; Application Variables
;-----------------------------------------------------------------------------
#define ConstAppVersion GetFileVersion("..\source\server\bin\Win32\Release\NetReflector.exe") ; define variable
#define ConstAppName "NetReflector"
#define ConstAppMutex "NetReflectorConfig"
#define ConstAppDescription "NetReflector"
#define ConstAppPublisher "Little Earth Solutions"
#define ConstAppCopyright "Copyright (C) 2017 Little Earth Solutions"
#define ConstAppURL "https://www.littleearthsolutions.net/"
#define ConstAppExeName "NetReflector.exe"
#define ConstAppServiceName "NetReflectorService"
;-----------------------------------------------------------------------------

[Setup]
AppId={{FD17F777-FAFD-4921-8EBC-662CE5190F8C}
AppMutex={#ConstAppMutex}
AppName={#ConstAppName}
AppVersion={#ConstAppVersion}
AppPublisher={#ConstAppPublisher}
AppPublisherURL={#ConstAppURL}
AppSupportURL={#ConstAppURL}
AppUpdatesURL={#ConstAppURL}
AppCopyright={#ConstAppCopyright}
VersionInfoCompany={#ConstAppPublisher}
VersionInfoDescription={#ConstAppName}
VersionInfoCopyright={#ConstAppCopyright}
VersionInfoVersion={#ConstAppVersion}
VersionInfoTextVersion={#ConstAppVersion}
OutputDir=output
OutputBaseFilename=NetReflector-{#ConstAppVersion}
UninstallDisplayName={#ConstAppName}
DefaultDirName={pf}\{#ConstAppPublisher}\{#ConstAppName}
MinVersion=0,5.0.2195sp3
InfoBeforeFile=..\resources\common\all\NetReflector - Release Notes.rtf
LicenseFile=..\resources\common\all\NetReflector - License.rtf
WizardImageFile=..\images\installer\WizardImageFile.bmp
WizardSmallImageFile=..\images\installer\WizardSmallImageFile.bmp
SetupIconFile=..\images\installer\les.ico
SolidCompression=True
InternalCompressLevel=ultra
Compression=lzma/ultra
DisableWelcomePage=True
RestartApplications=False
CloseApplications=False
;SignTool=LES
PrivilegesRequired=none
DefaultGroupName={#ConstAppPublisher}\{#ConstAppName}
AllowUNCPath=False
AppendDefaultDirName=False
AppendDefaultGroupName=False

[Files]
Source: "..\source\server\bin\Win32\Release\NetReflector.exe"; DestDir: "{app}\server\"; Flags: promptifolder replacesameversion; BeforeInstall: BeforeServiceFileInstall;
Source: "..\source\server\bin\Win32\Release\*"; DestDir: "{app}\server\"; Flags: recursesubdirs restartreplace; Excludes: "*.map, *.drc"; 
Source: "..\source\config\bin\Win32\Release\NetReflectorConfig.exe"; DestDir: "{app}\config\"; Flags: promptifolder replacesameversion; BeforeInstall: TaskKill('NetReflectorConfig.exe')
Source: "..\source\config\bin\Win32\Release\*"; DestDir: "{app}\config\"; Flags: recursesubdirs restartreplace; Excludes: "*.map, *.drc"; 

[Icons]
Name: "{group}\{#ConstAppName} Config"; Filename: "{app}\config\NetReflectorConfig.exe"; WorkingDir: "{app}"; IconFilename: "{app}\server\NetReflector.exe"
Name: "{group}\Uninstall {#ConstAppName}"; Filename: "{uninstallexe}"; WorkingDir: "{app}"; IconFilename: "{app}\server\NetReflector.exe"

[Run]
Filename: "{app}\config\NetReflectorConfig.exe"; WorkingDir: "{app}"; Flags: postinstall shellexec nowait runasoriginaluser; Description: "Launch {#ConstAppName} Config"
Filename: "{app}\server\NetReflector.exe"; Parameters: "/silent /install"; WorkingDir: "{app}"; StatusMsg: "Installing Service..."
Filename: "net"; Parameters: "start {#ConstAppServiceName}"; Flags: runhidden; StatusMsg: "Starting Service..."

[PreCompile]
;Name: "signing\Sign.bat";  Flags: abortonerror cmdprompt

[Code]
#include "scripts\closeapplications.iss"
#include "scripts\services.iss"

procedure BeforeServiceFileInstall;
begin
    RemoveServiceFileInstall;
    TaskKill(ExpandConstant('NetReflector.exe'))
end;
