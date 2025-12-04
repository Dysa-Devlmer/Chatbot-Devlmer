# Script de prueba del instalador
# Simula la instalación en C:\PITHY-TEST

Write-Host "🧪 PRUEBA DEL INSTALADOR PORTABLE" -ForegroundColor Cyan
Write-Host ""

$destinoPath = "C:\PITHY-TEST"
$origenPath = "E:\prueba"

Write-Host "📂 Origen: $origenPath" -ForegroundColor Yellow
Write-Host "📂 Destino: $destinoPath" -ForegroundColor Yellow
Write-Host ""

# Verificar que existe el origen
if (-not (Test-Path $origenPath)) {
    Write-Host "❌ Error: No existe $origenPath" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Origen verificado" -ForegroundColor Green
Write-Host ""

# Crear destino
Write-Host "📦 Creando carpeta de destino..." -ForegroundColor Cyan
if (Test-Path $destinoPath) {
    Write-Host "⚠️  Eliminando instalación anterior..." -ForegroundColor Yellow
    Remove-Item $destinoPath -Recurse -Force -ErrorAction SilentlyContinue
}

New-Item -ItemType Directory -Path $destinoPath -Force | Out-Null
Write-Host "✅ Carpeta creada: $destinoPath" -ForegroundColor Green
Write-Host ""

# Copiar archivos esenciales (sin node_modules para rapidez)
Write-Host "📋 Copiando archivos esenciales..." -ForegroundColor Cyan

$essentialFiles = @(
    "package.json",
    "package-lock.json",
    ".env.local",
    "next.config.ts",
    "tsconfig.json",
    "config-horarios.json",
    "ngrok.exe",
    "nssm.exe",
    "dev.db",
    "iniciar-chatbot.ps1",
    "detener-chatbot.ps1",
    "INICIO-SIMPLE.bat",
    "DETENER-SIMPLE.bat",
    "*.md"
)

$essentialFolders = @(
    "app",
    "prisma",
    "src",
    "public"
)

foreach ($file in $essentialFiles) {
    $items = Get-ChildItem -Path $origenPath -Filter $file -ErrorAction SilentlyContinue
    foreach ($item in $items) {
        Copy-Item -Path $item.FullName -Destination $destinoPath -Force -ErrorAction SilentlyContinue
        Write-Host "   ✓ $($item.Name)" -ForegroundColor Green
    }
}

foreach ($folder in $essentialFolders) {
    $folderPath = Join-Path $origenPath $folder
    if (Test-Path $folderPath) {
        Copy-Item -Path $folderPath -Destination $destinoPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "   ✓ $folder/" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "✅ Archivos copiados" -ForegroundColor Green
Write-Host ""

# Actualizar rutas en scripts
Write-Host "🔧 Actualizando rutas en scripts..." -ForegroundColor Cyan

$scriptsToUpdate = @(
    "detener-chatbot.ps1",
    "iniciar-chatbot.ps1"
)

foreach ($script in $scriptsToUpdate) {
    $scriptPath = Join-Path $destinoPath $script
    if (Test-Path $scriptPath) {
        $content = Get-Content $scriptPath -Raw
        $content = $content -replace 'E:\\prueba', $destinoPath
        Set-Content -Path $scriptPath -Value $content -Encoding UTF8
        Write-Host "   ✓ $script actualizado" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "✅ Rutas actualizadas" -ForegroundColor Green
Write-Host ""

# Crear accesos directos
Write-Host "🎨 Creando accesos directos en el escritorio..." -ForegroundColor Cyan

$WshShell = New-Object -ComObject WScript.Shell
$desktopPath = [Environment]::GetFolderPath("Desktop")

# 1. INICIAR
$shortcut = $WshShell.CreateShortcut("$desktopPath\[TEST] INICIAR PITHY.lnk")
$shortcut.TargetPath = "$destinoPath\INICIO-SIMPLE.bat"
$shortcut.WorkingDirectory = $destinoPath
$shortcut.IconLocation = "shell32.dll,137"
$shortcut.Save()
Write-Host "   ✓ [TEST] INICIAR PITHY.lnk" -ForegroundColor Green

# 2. DETENER
$shortcut = $WshShell.CreateShortcut("$desktopPath\[TEST] DETENER PITHY.lnk")
$shortcut.TargetPath = "$destinoPath\DETENER-SIMPLE.bat"
$shortcut.WorkingDirectory = $destinoPath
$shortcut.IconLocation = "shell32.dll,131"
$shortcut.Save()
Write-Host "   ✓ [TEST] DETENER PITHY.lnk" -ForegroundColor Green

# 3. PANEL
$shortcut = $WshShell.CreateShortcut("$desktopPath\[TEST] PANEL ADMIN PITHY.lnk")
$shortcut.TargetPath = "http://localhost:3000/admin"
$shortcut.IconLocation = "shell32.dll,14"
$shortcut.Save()
Write-Host "   ✓ [TEST] PANEL ADMIN PITHY.lnk" -ForegroundColor Green

# 4. CARPETA
$shortcut = $WshShell.CreateShortcut("$desktopPath\[TEST] CARPETA PITHY.lnk")
$shortcut.TargetPath = $destinoPath
$shortcut.IconLocation = "shell32.dll,4"
$shortcut.Save()
Write-Host "   ✓ [TEST] CARPETA PITHY.lnk" -ForegroundColor Green

Write-Host ""
Write-Host "╔════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║     ✅ PRUEBA DE INSTALACIÓN EXITOSA          ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "📍 Instalado en: $destinoPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎮 Accesos directos creados (prefijo [TEST]):" -ForegroundColor Cyan
Write-Host "   [TEST] INICIAR PITHY" -ForegroundColor White
Write-Host "   [TEST] DETENER PITHY" -ForegroundColor White
Write-Host "   [TEST] PANEL ADMIN PITHY" -ForegroundColor White
Write-Host "   [TEST] CARPETA PITHY" -ForegroundColor White
Write-Host ""

Write-Host "📝 NOTA IMPORTANTE:" -ForegroundColor Yellow
Write-Host "   Esta es una instalación de PRUEBA" -ForegroundColor White
Write-Host "   - No incluye node_modules (para rapidez)" -ForegroundColor White
Write-Host "   - Necesitas ejecutar 'npm install' en $destinoPath" -ForegroundColor White
Write-Host "   - Los iconos tienen prefijo [TEST]" -ForegroundColor White
Write-Host ""

Write-Host "🧹 Para limpiar la prueba:" -ForegroundColor Cyan
Write-Host "   Remove-Item '$destinoPath' -Recurse -Force" -ForegroundColor White
Write-Host "   Remove-Item '$desktopPath\[TEST]*.lnk'" -ForegroundColor White
Write-Host ""

Write-Host "✅ Prueba completada exitosamente!" -ForegroundColor Green
Write-Host ""
