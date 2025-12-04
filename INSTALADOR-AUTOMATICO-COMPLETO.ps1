# ═══════════════════════════════════════════════════════════
# INSTALADOR AUTOMÁTICO TODO-EN-UNO - PITHY CHATBOT
# Instala TODO: Node.js, Ollama, PITHY y dependencias
# ═══════════════════════════════════════════════════════════

param(
    [switch]$Silent,
    [string]$InstallPath = "C:\PITHY"
)

$ErrorActionPreference = "Continue"

# Colores
function Write-Title { param($Text) Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan; Write-Host "║  $Text" -ForegroundColor Cyan; Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan }
function Write-Step { param($Text) Write-Host "`n► $Text" -ForegroundColor Yellow }
function Write-Success { param($Text) Write-Host "  ✓ $Text" -ForegroundColor Green }
function Write-Error { param($Text) Write-Host "  ✗ $Text" -ForegroundColor Red }
function Write-Info { param($Text) Write-Host "  ℹ $Text" -ForegroundColor Cyan }

Clear-Host

Write-Title "   🤖 INSTALADOR AUTOMÁTICO PITHY CHATBOT - TODO EN UNO       "

Write-Host ""
Write-Host "Este instalador hará TODO automáticamente:" -ForegroundColor White
Write-Host "  1. Detectar e instalar Node.js si falta" -ForegroundColor Gray
Write-Host "  2. Detectar e instalar Ollama si falta" -ForegroundColor Gray
Write-Host "  3. Descargar modelo de IA (qwen2.5:3b)" -ForegroundColor Gray
Write-Host "  4. Instalar PITHY en $InstallPath" -ForegroundColor Gray
Write-Host "  5. Instalar todas las dependencias" -ForegroundColor Gray
Write-Host "  6. Crear iconos en el escritorio" -ForegroundColor Gray
Write-Host "  7. Configurar todo para funcionar" -ForegroundColor Gray
Write-Host ""
Write-Host "⏱️  Tiempo estimado: 30-60 minutos" -ForegroundColor Yellow
Write-Host "📡 Se necesita conexión a Internet" -ForegroundColor Yellow
Write-Host ""

if (-not $Silent) {
    $continuar = Read-Host "¿Deseas continuar? (S/N)"
    if ($continuar -ne "S" -and $continuar -ne "s") {
        Write-Host "`n❌ Instalación cancelada" -ForegroundColor Red
        exit
    }
}

# ═══════════════════════════════════════════════════════════
# PASO 1: VERIFICAR/INSTALAR NODE.JS
# ═══════════════════════════════════════════════════════════

Write-Title "   PASO 1/7: NODE.JS                                         "

Write-Step "Verificando si Node.js está instalado..."

$nodeInstalled = $false
try {
    $nodeVersion = & node --version 2>$null
    if ($nodeVersion) {
        Write-Success "Node.js ya está instalado: $nodeVersion"
        $nodeInstalled = $true
    }
} catch {
    Write-Info "Node.js no está instalado"
}

if (-not $nodeInstalled) {
    Write-Step "Descargando Node.js LTS..."

    $nodeUrl = "https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi"
    $nodeInstaller = "$env:TEMP\nodejs-installer.msi"

    try {
        Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstaller -UseBasicParsing
        Write-Success "Node.js descargado"

        Write-Step "Instalando Node.js (esto puede tardar 5-10 minutos)..."
        Write-Info "Se abrirá un instalador, sigue los pasos y espera que termine"

        Start-Process msiexec.exe -ArgumentList "/i `"$nodeInstaller`" /qn /norestart" -Wait

        Write-Success "Node.js instalado"

        # Actualizar PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    } catch {
        Write-Error "Error al instalar Node.js: $_"
        Write-Info "Descarga manualmente desde: https://nodejs.org/"
        exit 1
    }
}

# ═══════════════════════════════════════════════════════════
# PASO 2: VERIFICAR/INSTALAR OLLAMA
# ═══════════════════════════════════════════════════════════

Write-Title "   PASO 2/7: OLLAMA (IA LOCAL)                               "

Write-Step "Verificando si Ollama está instalado..."

$ollamaInstalled = $false
try {
    $ollamaVersion = & ollama --version 2>$null
    if ($ollamaVersion) {
        Write-Success "Ollama ya está instalado: $ollamaVersion"
        $ollamaInstalled = $true
    }
} catch {
    Write-Info "Ollama no está instalado"
}

if (-not $ollamaInstalled) {
    Write-Step "Descargando Ollama..."

    $ollamaUrl = "https://ollama.com/download/OllamaSetup.exe"
    $ollamaInstaller = "$env:TEMP\OllamaSetup.exe"

    try {
        Invoke-WebRequest -Uri $ollamaUrl -OutFile $ollamaInstaller -UseBasicParsing
        Write-Success "Ollama descargado"

        Write-Step "Instalando Ollama..."
        Write-Info "Espera que termine la instalación..."

        Start-Process $ollamaInstaller -ArgumentList "/SILENT" -Wait

        Write-Success "Ollama instalado"

        # Actualizar PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    } catch {
        Write-Error "Error al instalar Ollama: $_"
        Write-Info "Descarga manualmente desde: https://ollama.com/download"
        exit 1
    }
}

# ═══════════════════════════════════════════════════════════
# PASO 3: DESCARGAR MODELO DE IA
# ═══════════════════════════════════════════════════════════

Write-Title "   PASO 3/7: MODELO DE IA                                    "

Write-Step "Verificando modelo de IA..."

$modelInstalled = $false
try {
    $models = & ollama list 2>$null
    if ($models -match "qwen2.5:3b") {
        Write-Success "Modelo qwen2.5:3b ya está descargado"
        $modelInstalled = $true
    }
} catch {
    Write-Info "Modelo no encontrado"
}

if (-not $modelInstalled) {
    Write-Step "Descargando modelo de IA (qwen2.5:3b - ~2GB)..."
    Write-Info "Esto puede tardar 10-20 minutos según tu conexión"

    try {
        # Iniciar Ollama en background
        Start-Process ollama -ArgumentList "serve" -WindowStyle Hidden
        Start-Sleep -Seconds 3

        & ollama pull qwen2.5:3b

        Write-Success "Modelo de IA descargado"
    } catch {
        Write-Error "Error al descargar modelo: $_"
        Write-Info "Ejecuta manualmente: ollama pull qwen2.5:3b"
    }
}

# ═══════════════════════════════════════════════════════════
# PASO 4: INSTALAR PITHY
# ═══════════════════════════════════════════════════════════

Write-Title "   PASO 4/7: COPIAR ARCHIVOS DE PITHY                        "

Write-Step "Preparando instalación de PITHY..."

$origenPath = $PSScriptRoot
Write-Info "Origen: $origenPath"
Write-Info "Destino: $InstallPath"

if (Test-Path $InstallPath) {
    Write-Info "La carpeta de destino ya existe"
    if (-not $Silent) {
        $sobrescribir = Read-Host "¿Sobrescribir? (S/N)"
        if ($sobrescribir -ne "S" -and $sobrescribir -ne "s") {
            Write-Host "`n❌ Instalación cancelada" -ForegroundColor Red
            exit
        }
    }
}

Write-Step "Creando carpeta de destino..."
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
Write-Success "Carpeta creada"

Write-Step "Copiando archivos de PITHY..."

$itemsToCopy = @(
    "app",
    "prisma",
    "public",
    "src",
    ".env.local",
    ".gitignore",
    "next.config.ts",
    "package.json",
    "package-lock.json",
    "tsconfig.json",
    "tailwind.config.ts",
    "postcss.config.mjs",
    "prisma.config.ts",
    "ngrok.exe",
    "ngrok.yml",
    "nssm.exe",
    "dev.db",
    "config-horarios.json",
    "*.ps1",
    "*.bat",
    "*.md",
    "*.txt"
)

$copied = 0
foreach ($item in $itemsToCopy) {
    $items = Get-ChildItem -Path $origenPath -Filter $item -ErrorAction SilentlyContinue
    foreach ($file in $items) {
        try {
            $destino = Join-Path $InstallPath $file.Name
            Copy-Item -Path $file.FullName -Destination $destino -Recurse -Force -ErrorAction Stop
            $copied++
        } catch {
            Write-Error "Error copiando $($file.Name): $_"
        }
    }
}

Write-Success "Archivos copiados: $copied"

# Actualizar rutas en scripts
Write-Step "Actualizando rutas en scripts..."

$scriptsToUpdate = @(
    "detener-chatbot.ps1",
    "iniciar-chatbot.ps1",
    "install-service.ps1",
    "uninstall-service.ps1"
)

foreach ($script in $scriptsToUpdate) {
    $scriptPath = Join-Path $InstallPath $script
    if (Test-Path $scriptPath) {
        try {
            $content = Get-Content $scriptPath -Raw -Encoding UTF8
            $content = $content -replace [regex]::Escape($origenPath), $InstallPath
            $content = $content -replace 'E:\\prueba', $InstallPath
            Set-Content -Path $scriptPath -Value $content -Encoding UTF8
        } catch {
            Write-Error "Error actualizando $script"
        }
    }
}

Write-Success "Rutas actualizadas"

# ═══════════════════════════════════════════════════════════
# PASO 5: INSTALAR DEPENDENCIAS
# ═══════════════════════════════════════════════════════════

Write-Title "   PASO 5/7: INSTALAR DEPENDENCIAS (npm install)             "

Write-Step "Instalando dependencias de Node.js..."
Write-Info "Esto puede tardar 10-20 minutos..."

try {
    Set-Location $InstallPath

    $npmProcess = Start-Process npm -ArgumentList "install" -NoNewWindow -PassThru -Wait

    if ($npmProcess.ExitCode -eq 0) {
        Write-Success "Dependencias instaladas correctamente"
    } else {
        Write-Error "Error al instalar dependencias (código: $($npmProcess.ExitCode))"
        Write-Info "Intenta ejecutar manualmente: cd $InstallPath && npm install"
    }
} catch {
    Write-Error "Error: $_"
}

# ═══════════════════════════════════════════════════════════
# PASO 6: CREAR ACCESOS DIRECTOS
# ═══════════════════════════════════════════════════════════

Write-Title "   PASO 6/7: CREAR ICONOS EN ESCRITORIO                      "

Write-Step "Creando accesos directos..."

$WshShell = New-Object -ComObject WScript.Shell
$desktopPath = [Environment]::GetFolderPath("Desktop")

try {
    # INICIAR
    $shortcut = $WshShell.CreateShortcut("$desktopPath\INICIAR PITHY.lnk")
    $shortcut.TargetPath = "$InstallPath\INICIO-SIMPLE.bat"
    $shortcut.WorkingDirectory = $InstallPath
    $shortcut.IconLocation = "shell32.dll,137"
    $shortcut.Save()
    Write-Success "INICIAR PITHY.lnk"

    # DETENER
    $shortcut = $WshShell.CreateShortcut("$desktopPath\DETENER PITHY.lnk")
    $shortcut.TargetPath = "$InstallPath\DETENER-SIMPLE.bat"
    $shortcut.WorkingDirectory = $InstallPath
    $shortcut.IconLocation = "shell32.dll,131"
    $shortcut.Save()
    Write-Success "DETENER PITHY.lnk"

    # PANEL ADMIN
    $shortcut = $WshShell.CreateShortcut("$desktopPath\PANEL ADMIN PITHY.lnk")
    $shortcut.TargetPath = "http://localhost:3000/admin"
    $shortcut.IconLocation = "shell32.dll,14"
    $shortcut.Save()
    Write-Success "PANEL ADMIN PITHY.lnk"

    # CARPETA
    $shortcut = $WshShell.CreateShortcut("$desktopPath\CARPETA PITHY.lnk")
    $shortcut.TargetPath = $InstallPath
    $shortcut.IconLocation = "shell32.dll,4"
    $shortcut.Save()
    Write-Success "CARPETA PITHY.lnk"

} catch {
    Write-Error "Error creando accesos directos: $_"
}

# ═══════════════════════════════════════════════════════════
# PASO 7: VERIFICACIÓN FINAL
# ═══════════════════════════════════════════════════════════

Write-Title "   PASO 7/7: VERIFICACIÓN FINAL                              "

Write-Step "Verificando instalación..."

$allOk = $true

# Verificar Node.js
try {
    $nodeVer = & node --version
    Write-Success "Node.js: $nodeVer"
} catch {
    Write-Error "Node.js no funciona"
    $allOk = $false
}

# Verificar Ollama
try {
    $ollamaVer = & ollama --version
    Write-Success "Ollama: $ollamaVer"
} catch {
    Write-Error "Ollama no funciona"
    $allOk = $false
}

# Verificar PITHY
if (Test-Path "$InstallPath\package.json") {
    Write-Success "PITHY instalado en: $InstallPath"
} else {
    Write-Error "PITHY no se instaló correctamente"
    $allOk = $false
}

# Verificar iconos
$shortcuts = @("INICIAR PITHY.lnk", "DETENER PITHY.lnk", "PANEL ADMIN PITHY.lnk", "CARPETA PITHY.lnk")
$shortcutsOk = $true
foreach ($sc in $shortcuts) {
    if (-not (Test-Path "$desktopPath\$sc")) {
        $shortcutsOk = $false
    }
}

if ($shortcutsOk) {
    Write-Success "Iconos creados en el escritorio"
} else {
    Write-Error "Algunos iconos no se crearon"
}

# ═══════════════════════════════════════════════════════════
# FINALIZACIÓN
# ═══════════════════════════════════════════════════════════

Write-Host ""
Write-Host ""

if ($allOk) {
    Write-Title "   ✅ INSTALACIÓN COMPLETADA EXITOSAMENTE                     "

    Write-Host ""
    Write-Host "🎉 ¡PITHY está instalado y listo para usar!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 Ubicación: $InstallPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🎮 ICONOS EN TU ESCRITORIO:" -ForegroundColor Yellow
    Write-Host "   • INICIAR PITHY      - Inicia el chatbot" -ForegroundColor White
    Write-Host "   • DETENER PITHY      - Detiene el chatbot" -ForegroundColor White
    Write-Host "   • PANEL ADMIN PITHY  - Abre el panel web" -ForegroundColor White
    Write-Host "   • CARPETA PITHY      - Abre la carpeta" -ForegroundColor White
    Write-Host ""
    Write-Host "📝 PRÓXIMOS PASOS:" -ForegroundColor Yellow
    Write-Host "   1. Configura tus credenciales en: $InstallPath\.env.local" -ForegroundColor White
    Write-Host "   2. Haz doble click en: INICIAR PITHY" -ForegroundColor White
    Write-Host "   3. Espera 30 segundos" -ForegroundColor White
    Write-Host "   4. Haz doble click en: PANEL ADMIN PITHY" -ForegroundColor White
    Write-Host ""
    Write-Host "📚 DOCUMENTACIÓN:" -ForegroundColor Cyan
    Write-Host "   - GUIA-PANEL-ADMIN.md" -ForegroundColor White
    Write-Host "   - LEEME-SIMPLE.txt" -ForegroundColor White
    Write-Host ""

    if (-not $Silent) {
        $iniciar = Read-Host "¿Deseas iniciar PITHY ahora? (S/N)"
        if ($iniciar -eq "S" -or $iniciar -eq "s") {
            Write-Host ""
            Write-Host "🚀 Iniciando PITHY..." -ForegroundColor Cyan
            Start-Process "$InstallPath\INICIO-SIMPLE.bat"
            Write-Host "✅ PITHY iniciado! Espera 30 segundos y abre el panel admin" -ForegroundColor Green
        }
    }

} else {
    Write-Title "   ⚠️  INSTALACIÓN COMPLETADA CON ADVERTENCIAS                "

    Write-Host ""
    Write-Host "La instalación terminó pero hay algunos problemas:" -ForegroundColor Yellow
    Write-Host "Revisa los errores arriba y corrígelos manualmente" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Gray
if (-not $Silent) {
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
