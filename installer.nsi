; PITHY Chatbot - Instalador Profesional
; Creado por: Ulmer Solier - Devlmer Project CL

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"
  !include "LogicLib.nsh"

;--------------------------------
;General

  ;Name and file
  Name "PITHY Chatbot"
  OutFile "PITHY-Installer.exe"
  Unicode True

  ;Default installation folder
  InstallDir "$PROGRAMFILES64\PITHY"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\PITHY" ""

  ;Request application privileges
  RequestExecutionLevel admin

  ;Modern UI
  !define MUI_ICON "icon.ico"
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "header.bmp"
  !define MUI_WELCOMEFINISHPAGE_BITMAP "wizard.bmp"

  ;Progress bar
  !define MUI_INSTFILESPAGE_PROGRESSBAR "smooth"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "Spanish"

;--------------------------------
;Installer Sections

Section "PITHY Core" SecCore

  SetOutPath "$INSTDIR"

  ;Show details
  DetailPrint "Instalando PITHY Chatbot..."
  DetailPrint "Esto puede tardar varios minutos..."

  ;Copy all files
  File /r /x node_modules /x .next /x .git /x logs "*.*"

  ;Store installation folder
  WriteRegStr HKCU "Software\PITHY" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;Create desktop shortcuts
  DetailPrint "Creando accesos directos..."

  CreateShortCut "$DESKTOP\INICIAR PITHY.lnk" "$INSTDIR\INICIO-SIMPLE.bat" "" "" 0
  CreateShortCut "$DESKTOP\DETENER PITHY.lnk" "$INSTDIR\DETENER-SIMPLE.bat" "" "" 0
  CreateShortCut "$DESKTOP\PANEL ADMIN PITHY.lnk" "http://localhost:3000/admin" "" "" 0
  CreateShortCut "$DESKTOP\CARPETA PITHY.lnk" "$INSTDIR" "" "" 0

  ;Create Start Menu shortcuts
  CreateDirectory "$SMPROGRAMS\PITHY Chatbot"
  CreateShortCut "$SMPROGRAMS\PITHY Chatbot\PITHY Chatbot.lnk" "$INSTDIR\INICIO-SIMPLE.bat" "" "" 0
  CreateShortCut "$SMPROGRAMS\PITHY Chatbot\Panel Admin.lnk" "http://localhost:3000/admin" "" "" 0
  CreateShortCut "$SMPROGRAMS\PITHY Chatbot\Desinstalar.lnk" "$INSTDIR\Uninstall.exe" "" "" 0

SectionEnd

Section "Node.js" SecNodeJS

  DetailPrint "Verificando Node.js..."

  ;Check if Node.js is installed
  nsExec::ExecToLog 'node --version'
  Pop $0

  ${If} $0 != 0
    DetailPrint "Descargando Node.js..."
    NSISdl::download "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi" "$TEMP\nodejs.msi"
    Pop $0

    ${If} $0 == "success"
      DetailPrint "Instalando Node.js..."
      ExecWait 'msiexec /i "$TEMP\nodejs.msi" /qn /norestart'
      Delete "$TEMP\nodejs.msi"
    ${Else}
      MessageBox MB_OK "Error al descargar Node.js. Por favor, descárgalo manualmente de nodejs.org"
    ${EndIf}
  ${Else}
    DetailPrint "Node.js ya está instalado"
  ${EndIf}

SectionEnd

Section "Ollama AI" SecOllama

  DetailPrint "Verificando Ollama..."

  ;Check if Ollama is installed
  nsExec::ExecToLog 'ollama --version'
  Pop $0

  ${If} $0 != 0
    DetailPrint "Descargando Ollama..."
    NSISdl::download "https://ollama.com/download/OllamaSetup.exe" "$TEMP\ollama.exe"
    Pop $0

    ${If} $0 == "success"
      DetailPrint "Instalando Ollama..."
      ExecWait '"$TEMP\ollama.exe" /S'
      Delete "$TEMP\ollama.exe"

      DetailPrint "Descargando modelo de IA (esto puede tardar 10-15 minutos)..."
      nsExec::ExecToLog 'ollama pull qwen2.5:3b'
    ${Else}
      MessageBox MB_OK "Error al descargar Ollama. Por favor, descárgalo manualmente de ollama.com"
    ${EndIf}
  ${Else}
    DetailPrint "Ollama ya está instalado"
    DetailPrint "Verificando modelo de IA..."
    nsExec::ExecToLog 'ollama pull qwen2.5:3b'
  ${EndIf}

SectionEnd

Section "Dependencies" SecDeps

  DetailPrint "Instalando dependencias de Node.js..."
  DetailPrint "Esto puede tardar 10-15 minutos..."

  SetOutPath "$INSTDIR"
  nsExec::ExecToLog 'cmd /c npm install'

  DetailPrint "Dependencias instaladas"

SectionEnd

Section "Post-Install" SecPost

  DetailPrint "Configuración final..."

  ;Add to PATH if needed
  EnVar::SetHKCU
  EnVar::AddValue "Path" "$INSTDIR"

  ;Registry for Add/Remove Programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PITHY" "DisplayName" "PITHY Chatbot"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PITHY" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PITHY" "DisplayIcon" "$INSTDIR\INICIO-SIMPLE.bat"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PITHY" "Publisher" "Devlmer Project CL"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PITHY" "DisplayVersion" "1.0"

  MessageBox MB_OK "¡PITHY Chatbot se ha instalado correctamente!$\n$\nSiguientes pasos:$\n1. Configura tus credenciales en $INSTDIR\.env.local$\n2. Haz doble clic en 'INICIAR PITHY' en tu escritorio$\n3. Abre 'PANEL ADMIN PITHY' para administrar conversaciones"

SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  LangString DESC_SecCore ${LANG_SPANISH} "Archivos principales de PITHY Chatbot"
  LangString DESC_SecNodeJS ${LANG_SPANISH} "Node.js runtime (requerido)"
  LangString DESC_SecOllama ${LANG_SPANISH} "Ollama AI y modelo de inteligencia artificial"
  LangString DESC_SecDeps ${LANG_SPANISH} "Dependencias de Node.js (npm packages)"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} $(DESC_SecCore)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecNodeJS} $(DESC_SecNodeJS)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecOllama} $(DESC_SecOllama)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDeps} $(DESC_SecDeps)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;Remove files
  RMDir /r "$INSTDIR"

  ;Remove shortcuts
  Delete "$DESKTOP\INICIAR PITHY.lnk"
  Delete "$DESKTOP\DETENER PITHY.lnk"
  Delete "$DESKTOP\PANEL ADMIN PITHY.lnk"
  Delete "$DESKTOP\CARPETA PITHY.lnk"

  RMDir /r "$SMPROGRAMS\PITHY Chatbot"

  ;Remove registry keys
  DeleteRegKey HKCU "Software\PITHY"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\PITHY"

SectionEnd
