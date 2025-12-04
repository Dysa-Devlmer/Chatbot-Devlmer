# Script para crear accesos directos en el escritorio
# Útil si el instalador no pudo crearlos

Write-Host "🎨 Creando accesos directos en el escritorio..." -ForegroundColor Cyan
Write-Host ""

$ubicacionPITHY = Get-Location
$desktopPath = [Environment]::GetFolderPath("Desktop")
$WshShell = New-Object -ComObject WScript.Shell

# 1. INICIAR PITHY
Write-Host "📝 Creando: 🚀 INICIAR PITHY..." -ForegroundColor Yellow
$shortcut = $WshShell.CreateShortcut("$desktopPath\🚀 INICIAR PITHY.lnk")
$shortcut.TargetPath = "$ubicacionPITHY\INICIO-SIMPLE.bat"
$shortcut.WorkingDirectory = $ubicacionPITHY
$shortcut.IconLocation = "shell32.dll,137"
$shortcut.Description = "Iniciar chatbot PITHY"
$shortcut.Save()
Write-Host "   ✓ Creado" -ForegroundColor Green

# 2. DETENER PITHY
Write-Host "📝 Creando: 🛑 DETENER PITHY..." -ForegroundColor Yellow
$shortcut = $WshShell.CreateShortcut("$desktopPath\🛑 DETENER PITHY.lnk")
$shortcut.TargetPath = "$ubicacionPITHY\DETENER-SIMPLE.bat"
$shortcut.WorkingDirectory = $ubicacionPITHY
$shortcut.IconLocation = "shell32.dll,131"
$shortcut.Description = "Detener chatbot PITHY"
$shortcut.Save()
Write-Host "   ✓ Creado" -ForegroundColor Green

# 3. PANEL ADMIN
Write-Host "📝 Creando: 🎛️ PANEL ADMIN PITHY..." -ForegroundColor Yellow
$shortcut = $WshShell.CreateShortcut("$desktopPath\🎛️ PANEL ADMIN PITHY.lnk")
$shortcut.TargetPath = "http://localhost:3000/admin"
$shortcut.IconLocation = "shell32.dll,14"
$shortcut.Description = "Abrir panel de administración PITHY"
$shortcut.Save()
Write-Host "   ✓ Creado" -ForegroundColor Green

# 4. CARPETA PITHY
Write-Host "📝 Creando: 📁 CARPETA PITHY..." -ForegroundColor Yellow
$shortcut = $WshShell.CreateShortcut("$desktopPath\📁 CARPETA PITHY.lnk")
$shortcut.TargetPath = $ubicacionPITHY
$shortcut.IconLocation = "shell32.dll,4"
$shortcut.Description = "Abrir carpeta de PITHY"
$shortcut.Save()
Write-Host "   ✓ Creado" -ForegroundColor Green

Write-Host ""
Write-Host "✅ Todos los accesos directos creados exitosamente!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 Ubicación de PITHY: $ubicacionPITHY" -ForegroundColor Cyan
Write-Host ""
Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
