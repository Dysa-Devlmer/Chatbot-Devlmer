# ═══════════════════════════════════════════════════════════
# INSTALADOR DIRECTO - PITHY CHATBOT
# Instala PITHY directamente en C:\PITHY sin preguntas
# ═══════════════════════════════════════════════════════════

$ErrorActionPreference = "Continue"
$InstallPath = "C:\PITHY"
$SourcePath = $PSScriptRoot

Clear-Host

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   INSTALADOR PITHY CHATBOT - INSTALACION A C:\PITHY      " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# PASO 1: Verificar que no exista ya
if (Test-Path $InstallPath) {
    Write-Host "► La carpeta C:\PITHY ya existe" -ForegroundColor Yellow
    Write-Host "  ¿Deseas sobrescribir? (S/N): " -NoNewline -ForegroundColor Yellow
    $respuesta = Read-Host
    if ($respuesta -ne "S" -and $respuesta -ne "s") {
        Write-Host "`n❌ Instalación cancelada" -ForegroundColor Red
        exit
    }
    Write-Host "  ✓ Eliminando carpeta existente..." -ForegroundColor Green
    Remove-Item -Path $InstallPath -Recurse -Force -ErrorAction SilentlyContinue
}

# PASO 2: Crear carpeta
Write-Host "`n► Creando carpeta C:\PITHY..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
Write-Host "  ✓ Carpeta creada" -ForegroundColor Green

# PASO 3: Copiar archivos (sin node_modules)
Write-Host "`n► Copiando archivos..." -ForegroundColor Yellow

$itemsToCopy = @(
    "package.json",
    "package-lock.json",
    "next.config.ts",
    "tsconfig.json",
    "tailwind.config.ts",
    "postcss.config.mjs",
    ".env.local",
    "prisma",
    "app",
    "src",
    "public",
    "prisma.config.ts",
    "iniciar-chatbot.ps1",
    "detener-chatbot.ps1",
    "INICIO-SIMPLE.bat",
    "DETENER-SIMPLE.bat",
    "crear-atajos.ps1",
    "ngrok.exe",
    "ngrok.yml"
)

$copiedCount = 0
foreach ($item in $itemsToCopy) {
    $source = Join-Path $SourcePath $item
    $dest = Join-Path $InstallPath $item

    if (Test-Path $source) {
        if (Test-Path $source -PathType Container) {
            Copy-Item -Path $source -Destination $dest -Recurse -Force -ErrorAction SilentlyContinue
        } else {
            Copy-Item -Path $source -Destination $dest -Force -ErrorAction SilentlyContinue
        }
        $copiedCount++
        Write-Host "  ✓ $item" -ForegroundColor Green
    }
}

Write-Host "`n  Total archivos/carpetas copiados: $copiedCount" -ForegroundColor Cyan

# PASO 4: Crear iconos en escritorio
Write-Host "`n► Creando iconos en el escritorio..." -ForegroundColor Yellow

$WshShell = New-Object -ComObject WScript.Shell
$desktopPath = [Environment]::GetFolderPath("Desktop")

# Icono 1: INICIAR PITHY
$shortcut = $WshShell.CreateShortcut("$desktopPath\INICIAR PITHY.lnk")
$shortcut.TargetPath = "$InstallPath\INICIO-SIMPLE.bat"
$shortcut.WorkingDirectory = $InstallPath
$shortcut.Description = "Iniciar PITHY Chatbot"
$shortcut.Save()
Write-Host "  ✓ INICIAR PITHY" -ForegroundColor Green

# Icono 2: DETENER PITHY
$shortcut = $WshShell.CreateShortcut("$desktopPath\DETENER PITHY.lnk")
$shortcut.TargetPath = "$InstallPath\DETENER-SIMPLE.bat"
$shortcut.WorkingDirectory = $InstallPath
$shortcut.Description = "Detener PITHY Chatbot"
$shortcut.Save()
Write-Host "  ✓ DETENER PITHY" -ForegroundColor Green

# Icono 3: PANEL ADMIN
$shortcut = $WshShell.CreateShortcut("$desktopPath\PANEL ADMIN PITHY.lnk")
$shortcut.TargetPath = "http://localhost:3000/admin"
$shortcut.Save()
Write-Host "  ✓ PANEL ADMIN PITHY" -ForegroundColor Green

# Icono 4: CARPETA PITHY
$shortcut = $WshShell.CreateShortcut("$desktopPath\CARPETA PITHY.lnk")
$shortcut.TargetPath = $InstallPath
$shortcut.Save()
Write-Host "  ✓ CARPETA PITHY" -ForegroundColor Green

# PASO 5: Resumen
Write-Host "`n═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "   ✅ INSTALACION COMPLETADA                               " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "PITHY se instaló en: $InstallPath" -ForegroundColor White
Write-Host ""
Write-Host "ICONOS EN TU ESCRITORIO:" -ForegroundColor Cyan
Write-Host "  • INICIAR PITHY - Inicia el chatbot" -ForegroundColor White
Write-Host "  • DETENER PITHY - Detiene el chatbot" -ForegroundColor White
Write-Host "  • PANEL ADMIN PITHY - Abre el panel web" -ForegroundColor White
Write-Host "  • CARPETA PITHY - Abre la carpeta" -ForegroundColor White
Write-Host ""
Write-Host "PROXIMOS PASOS:" -ForegroundColor Yellow
Write-Host "  1. Abre PowerShell en C:\PITHY" -ForegroundColor White
Write-Host "  2. Ejecuta: npm install" -ForegroundColor White
Write-Host "  3. Configura credenciales en .env.local" -ForegroundColor White
Write-Host "  4. Doble click en 'INICIAR PITHY'" -ForegroundColor White
Write-Host ""
Write-Host "Presiona ENTER para continuar..." -ForegroundColor DarkGray
Read-Host
