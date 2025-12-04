# ====================================================
# INSTALADOR PORTABLE PITHY CHATBOT
# Copia todo el sistema a la ubicación deseada
# ====================================================

Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   🤖 INSTALADOR PORTABLE - PITHY CHATBOT      ║" -ForegroundColor Cyan
Write-Host "║        Devlmer Project CL                      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  NOTA: No estás ejecutando como Administrador" -ForegroundColor Yellow
    Write-Host "   El instalador funcionará, pero no podrá crear accesos directos en el escritorio" -ForegroundColor Yellow
    Write-Host ""
    $continuar = Read-Host "¿Deseas continuar de todas formas? (S/N)"
    if ($continuar -ne "S" -and $continuar -ne "s") {
        exit
    }
    Write-Host ""
}

# Obtener la ubicación actual
$origenPath = Get-Location

Write-Host "📂 Ubicación actual del proyecto:" -ForegroundColor Cyan
Write-Host "   $origenPath" -ForegroundColor White
Write-Host ""

# Preguntar dónde instalar
Write-Host "📍 ¿Dónde deseas instalar PITHY?" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Opciones recomendadas:" -ForegroundColor Gray
Write-Host "   1. C:\PITHY" -ForegroundColor White
Write-Host "   2. D:\PITHY" -ForegroundColor White
Write-Host "   3. Escritorio (C:\Users\$env:USERNAME\Desktop\PITHY)" -ForegroundColor White
Write-Host "   4. Ruta personalizada" -ForegroundColor White
Write-Host ""

$opcion = Read-Host "Selecciona una opción (1-4)"

switch ($opcion) {
    "1" { $destinoPath = "C:\PITHY" }
    "2" { $destinoPath = "D:\PITHY" }
    "3" { $destinoPath = "$env:USERPROFILE\Desktop\PITHY" }
    "4" {
        $destinoPath = Read-Host "Ingresa la ruta completa"
    }
    default {
        Write-Host "❌ Opción inválida" -ForegroundColor Red
        exit
    }
}

Write-Host ""
Write-Host "✅ Se instalará en: $destinoPath" -ForegroundColor Green
Write-Host ""

# Confirmar
$confirmar = Read-Host "¿Continuar con la instalación? (S/N)"
if ($confirmar -ne "S" -and $confirmar -ne "s") {
    Write-Host "❌ Instalación cancelada" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "📦 Iniciando instalación..." -ForegroundColor Cyan
Write-Host ""

# Crear carpeta de destino
if (Test-Path $destinoPath) {
    Write-Host "⚠️  La carpeta ya existe. Se sobrescribirán los archivos." -ForegroundColor Yellow
    $sobrescribir = Read-Host "¿Continuar? (S/N)"
    if ($sobrescribir -ne "S" -and $sobrescribir -ne "s") {
        Write-Host "❌ Instalación cancelada" -ForegroundColor Red
        exit
    }
} else {
    New-Item -ItemType Directory -Path $destinoPath -Force | Out-Null
}

# Lista de archivos/carpetas a copiar
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

Write-Host "📋 Copiando archivos..." -ForegroundColor Cyan

$totalItems = 0
foreach ($item in $itemsToCopy) {
    $items = Get-ChildItem -Path $origenPath -Filter $item -ErrorAction SilentlyContinue
    foreach ($file in $items) {
        $destino = Join-Path $destinoPath $file.Name
        Copy-Item -Path $file.FullName -Destination $destino -Recurse -Force -ErrorAction SilentlyContinue
        $totalItems++
        Write-Host "   ✓ $($file.Name)" -ForegroundColor Green
    }
}

# Copiar node_modules (esto puede tardar)
Write-Host ""
Write-Host "📦 Copiando dependencias (node_modules)..." -ForegroundColor Cyan
Write-Host "   ⏳ Esto puede tardar varios minutos..." -ForegroundColor Yellow

if (Test-Path "$origenPath\node_modules") {
    Copy-Item -Path "$origenPath\node_modules" -Destination "$destinoPath\node_modules" -Recurse -Force
    Write-Host "   ✓ node_modules copiado" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ Archivos copiados exitosamente!" -ForegroundColor Green
Write-Host ""

# Actualizar rutas en los scripts
Write-Host "🔧 Actualizando rutas en scripts..." -ForegroundColor Cyan

$scriptsToUpdate = @(
    "detener-chatbot.ps1",
    "iniciar-chatbot.ps1",
    "install-service.ps1",
    "uninstall-service.ps1"
)

foreach ($script in $scriptsToUpdate) {
    $scriptPath = Join-Path $destinoPath $script
    if (Test-Path $scriptPath) {
        $content = Get-Content $scriptPath -Raw
        $content = $content -replace 'E:\\prueba', $destinoPath
        Set-Content -Path $scriptPath -Value $content
        Write-Host "   ✓ $script actualizado" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "🎨 Creando accesos directos..." -ForegroundColor Cyan

# Crear accesos directos en el escritorio
$WshShell = New-Object -ComObject WScript.Shell
$desktopPath = [Environment]::GetFolderPath("Desktop")

# 1. INICIAR PITHY
$shortcut = $WshShell.CreateShortcut("$desktopPath\INICIAR PITHY.lnk")
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$destinoPath\iniciar-chatbot.ps1`""
$shortcut.WorkingDirectory = $destinoPath
$shortcut.IconLocation = "shell32.dll,137"
$shortcut.Description = "Iniciar chatbot PITHY"
$shortcut.Save()

# 2. DETENER PITHY
$shortcut = $WshShell.CreateShortcut("$desktopPath\DETENER PITHY.lnk")
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$destinoPath\detener-chatbot.ps1`""
$shortcut.WorkingDirectory = $destinoPath
$shortcut.IconLocation = "shell32.dll,131"
$shortcut.Description = "Detener chatbot PITHY"
$shortcut.Save()

# 3. ABRIR PANEL ADMIN
$shortcut = $WshShell.CreateShortcut("$desktopPath\PANEL ADMIN PITHY.lnk")
$shortcut.TargetPath = "http://localhost:3000/admin"
$shortcut.IconLocation = "shell32.dll,14"
$shortcut.Description = "Abrir panel de administración PITHY"
$shortcut.Save()

# 4. CARPETA PITHY
$shortcut = $WshShell.CreateShortcut("$desktopPath\CARPETA PITHY.lnk")
$shortcut.TargetPath = $destinoPath
$shortcut.IconLocation = "shell32.dll,4"
$shortcut.Description = "Abrir carpeta de PITHY"
$shortcut.Save()

Write-Host "   ✓ INICIAR PITHY.lnk" -ForegroundColor Green
Write-Host "   ✓ DETENER PITHY.lnk" -ForegroundColor Green
Write-Host "   ✓ PANEL ADMIN PITHY.lnk" -ForegroundColor Green
Write-Host "   ✓ CARPETA PITHY.lnk" -ForegroundColor Green

Write-Host ""
Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║        ✅ INSTALACIÓN COMPLETADA               ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "📍 PITHY instalado en:" -ForegroundColor Cyan
Write-Host "   $destinoPath" -ForegroundColor White
Write-Host ""

Write-Host "🎮 ACCESOS DIRECTOS CREADOS EN EL ESCRITORIO:" -ForegroundColor Cyan
Write-Host "   INICIAR PITHY      - Inicia el chatbot" -ForegroundColor White
Write-Host "   DETENER PITHY      - Detiene el chatbot" -ForegroundColor White
Write-Host "   PANEL ADMIN PITHY  - Abre el panel web" -ForegroundColor White
Write-Host "   CARPETA PITHY      - Abre la carpeta" -ForegroundColor White
Write-Host ""

Write-Host "📝 CÓMO USAR:" -ForegroundColor Yellow
Write-Host "   1. Haz doble clic en 'INICIAR PITHY'" -ForegroundColor White
Write-Host "   2. Espera 30 segundos" -ForegroundColor White
Write-Host "   3. Doble clic en 'PANEL ADMIN PITHY'" -ForegroundColor White
Write-Host "   4. Cuando termines, doble clic en 'DETENER PITHY'" -ForegroundColor White
Write-Host ""

Write-Host "🔧 IMPORTANTE:" -ForegroundColor Yellow
Write-Host "   - Los archivos .env.local contienen tus credenciales" -ForegroundColor White
Write-Host "   - La base de datos (dev.db) tiene todas tus conversaciones" -ForegroundColor White
Write-Host "   - Puedes copiar la carpeta '$destinoPath' a otro PC" -ForegroundColor White
Write-Host ""

Write-Host "🎉 ¡Listo para usar!" -ForegroundColor Green
Write-Host ""

# Preguntar si desea iniciar ahora
$iniciar = Read-Host "¿Deseas iniciar PITHY ahora? (S/N)"
if ($iniciar -eq "S" -or $iniciar -eq "s") {
    Write-Host ""
    Write-Host "🚀 Iniciando PITHY..." -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$destinoPath\iniciar-chatbot.ps1`""
    Start-Sleep -Seconds 3
    Write-Host "✅ PITHY iniciado!" -ForegroundColor Green
    Write-Host "   Espera 30 segundos y abre el panel admin" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
