; Script de Instalación PITHY Chatbot
; Creado con Inno Setup
; Autor: Ulmer Solier - Devlmer Project CL

#define MyAppName "PITHY Chatbot"
#define MyAppVersion "1.0"
#define MyAppPublisher "Devlmer Project CL"
#define MyAppURL "https://devlmer.cl"

[Setup]
; Información de la aplicación
AppId={{PITHY-CHATBOT-2024}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}

; Directorio de instalación por defecto
DefaultDirName={autopf}\PITHY
DefaultGroupName={#MyAppName}
AllowNoIcons=yes

; Licencia
LicenseFile=LICENSE.txt

; Salida
OutputDir=.
OutputBaseFilename=PITHY-Installer-v1.0
Compression=lzma
SolidCompression=yes
WizardStyle=modern

; Imágenes del instalador
SetupIconFile=img\favicon.ico
WizardImageFile=WizModernImage.bmp
WizardSmallImageFile=WizModernSmallImage.bmp

; Privilegios
PrivilegesRequired=admin

; Idioma
ShowLanguageDialog=no

[Languages]
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "Crear iconos en el {userdesktop}"; GroupDescription: "Iconos adicionales:"; Flags: checkedonce

[Files]
; Copiar todos los archivos excepto node_modules y .next
Source: "*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "node_modules\*,.next\*,.git\*,logs\*,.claude\*,.vercel\*,PITHY-Installer-v1.0.exe,*.db,*.db-journal,*.log"

[Icons]
; Icono en el escritorio - Solo Panel Admin
Name: "{userdesktop}\PANEL ADMIN PITHY"; Filename: "http://localhost:3000/admin"; Tasks: desktopicon

; Iconos en el menú Inicio
Name: "{group}\Panel de Administración PITHY"; Filename: "http://localhost:3000/admin"
Name: "{group}\Iniciar PITHY"; Filename: "{app}\INICIO-SIMPLE.bat"
Name: "{group}\Detener PITHY"; Filename: "{app}\DETENER-SIMPLE.bat"
Name: "{group}\Carpeta de PITHY"; Filename: "{app}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
; Verificar e instalar Node.js
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -Command ""$nodeInstalled = $false; try {{ $v = & node --version 2>$null; if ($v) {{ $nodeInstalled = $true }} }} catch {{ }}; if (-not $nodeInstalled) {{ Write-Host 'Descargando Node.js...'; Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi' -OutFile '$env:TEMP\nodejs.msi'; Write-Host 'Instalando Node.js...'; Start-Process msiexec.exe -ArgumentList '/i', '$env:TEMP\nodejs.msi', '/qn', '/norestart' -Wait; Remove-Item '$env:TEMP\nodejs.msi' -ErrorAction SilentlyContinue }} else {{ Write-Host 'Node.js ya instalado' }}"""; StatusMsg: "Verificando Node.js..."; Flags: runhidden waituntilterminated

; Verificar e instalar Ollama
Filename: "powershell.exe"; Parameters: "-ExecutionPolicy Bypass -Command ""$ollamaInstalled = $false; try {{ $v = & ollama --version 2>$null; if ($v) {{ $ollamaInstalled = $true }} }} catch {{ }}; if (-not $ollamaInstalled) {{ Write-Host 'Descargando Ollama...'; Invoke-WebRequest -Uri 'https://ollama.com/download/OllamaSetup.exe' -OutFile '$env:TEMP\ollama.exe'; Write-Host 'Instalando Ollama...'; Start-Process '$env:TEMP\ollama.exe' -ArgumentList '/S' -Wait; Remove-Item '$env:TEMP\ollama.exe' -ErrorAction SilentlyContinue; Start-Sleep -Seconds 5; & ollama pull qwen2.5:3b }} else {{ Write-Host 'Ollama ya instalado'; & ollama pull qwen2.5:3b }}"""; StatusMsg: "Verificando Ollama AI (esto puede tardar 15 minutos)..."; Flags: runhidden waituntilterminated

; Instalar dependencias de Node.js
Filename: "cmd.exe"; Parameters: "/c cd /d ""{app}"" && npm install"; StatusMsg: "Instalando dependencias (esto puede tardar 10-15 minutos)..."; Flags: runhidden waituntilterminated

[Code]
var
  ProgressPage: TOutputProgressWizardPage;

procedure InitializeWizard;
begin
  ProgressPage := CreateOutputProgressPage('Instalando componentes', 'Por favor espere mientras se instalan todos los componentes necesarios...');
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
  begin
    ProgressPage.SetText('Preparando instalación...', '');
    ProgressPage.SetProgress(0, 100);
  end
  else if CurStep = ssPostInstall then
  begin
    ProgressPage.SetText('Instalación completada', 'PITHY Chatbot se ha instalado correctamente');
    ProgressPage.SetProgress(100, 100);
  end;
end;

[UninstallDelete]
Type: filesandordirs; Name: "{app}\node_modules"
Type: filesandordirs; Name: "{app}\.next"
Type: filesandordirs; Name: "{app}\logs"

[Messages]
spanish.WelcomeLabel1=Bienvenido al Asistente de Instalación de [name]
spanish.WelcomeLabel2=Este programa instalará [name/ver] en su computadora.%n%nSe recomienda cerrar todas las demás aplicaciones antes de continuar.%n%nEste instalador descargará e instalará automáticamente:%n%n• Node.js (si no está instalado)%n• Ollama AI (si no está instalado)%n• Modelo de Inteligencia Artificial (2GB)%n• Dependencias de PITHY%n%nLa instalación puede tardar 30-60 minutos dependiendo de su conexión a Internet.
spanish.FinishedLabel=¡La instalación de [name] se ha completado exitosamente!%n%nPróximos pasos:%n1. Configure sus credenciales de WhatsApp en {app}\.env.local%n2. Haga doble clic en "INICIAR PITHY" en su escritorio%n3. Espere 30 segundos%n4. Abra "PANEL ADMIN PITHY" para administrar conversaciones
