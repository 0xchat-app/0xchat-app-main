; Inno Setup script for the 0xchat Windows desktop build.
;
; Until now the .exe attached to releases was built outside this repository, so
; the missing Start Menu entry reported in issue #54 could not be traced or
; fixed from source. This script is compiled by the Windows job in
; .github/workflows/build.yml, which makes the released installer reproducible.
;
; Everything build-specific arrives as a /D define, so the script carries no
; assumptions about the machine compiling it. The defaults below resolve
; relative to this file, so a local run from a checkout needs no arguments:
;
;   "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" windows\packaging\oxchat.iss
;
; and CI overrides them with absolute paths and the release version:
;
;   ISCC.exe /DAppVersion=1.5.5 /DBuildDir=... /DDistDir=... /DOutputName=...

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif

; Output of `flutter build windows --release`.
#ifndef BuildDir
  #define BuildDir "..\..\build\windows\x64\runner\Release"
#endif

#ifndef DistDir
  #define DistDir "..\..\dist"
#endif

#ifndef OutputName
  #define OutputName "oxchat-" + AppVersion + "-windows-x64-setup"
#endif

#define AppName "0xchat"
; BINARY_NAME in windows/CMakeLists.txt.
#define AppExeName "oxchat_app_main.exe"
#define RepoUrl "https://github.com/0xchat-app/0xchat-app-main"

[Setup]
; Never change AppId: it is how Windows recognises an existing installation, so
; a new value would turn every upgrade into a second, parallel install.
AppId={{80FF85C0-6043-4827-B024-6B57A0C07358}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppName}
AppPublisherURL={#RepoUrl}
AppSupportURL={#RepoUrl}/issues
AppUpdatesURL={#RepoUrl}/releases
AppCopyright=Copyright (C) 2023 0xchat

; The binary is named oxchat_app_main, so without these the uninstall entry
; would read that instead of the product name.
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\{#AppExeName}

DefaultDirName={autopf}\{#AppName}
; Nothing uses {group}: the shortcut goes straight into the Programs list
; rather than into a folder holding a single item, so the page asking where to
; put that folder has nothing to decide.
DisableProgramGroupPage=yes

LicenseFile=..\..\LICENSE
SetupIconFile=..\runner\resources\app_icon.ico
OutputDir={#DistDir}
OutputBaseFilename={#OutputName}
Compression=lzma2/max
SolidCompression=yes
WizardStyle=modern

; The Flutter runner is 64-bit only.
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
; Flutter supports Windows 10 1809 and later.
MinVersion=10.0.17763

; Default to a per-user install under %LOCALAPPDATA%, which needs no UAC
; prompt, while still letting the user pick an all-users install on the first
; wizard page. Either way the shortcut lands in the matching Start Menu.
; Upgrades reuse the scope of the existing install and skip the question.
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

; Ask the Restart Manager to close a running 0xchat rather than failing to
; overwrite its files mid-upgrade.
CloseApplications=yes
RestartApplications=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
; The fix for issue #54: {autoprograms} is the Start Menu of whichever scope
; the install ran in, so the app is searchable straight after installing.
Name: "{autoprograms}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Run]
; The other half of issue #54: offer to start the app when setup finishes.
; runasoriginaluser keeps 0xchat from inheriting the elevated token when the
; user chose an all-users install.
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent runasoriginaluser
