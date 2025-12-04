# Prueba simple del instalador
Write-Host "Probando instalacion en C:\PITHY-TEST..." -ForegroundColor Cyan

$destino = "C:\PITHY-TEST"

# Limpiar si existe
if (Test-Path $destino) {
    Remove-Item $destino -Recurse -Force
}

# Crear carpeta
New-Item -ItemType Directory -Path $destino -Force | Out-Null
Write-Host "Carpeta creada: $destino" -ForegroundColor Green

# Copiar archivos basicos
Copy-Item "E:\prueba\package.json" -Destination $destino -Force
Copy-Item "E:\prueba\.env.local" -Destination $destino -Force -ErrorAction SilentlyContinue
Copy-Item "E:\prueba\INICIO-SIMPLE.bat" -Destination $destino -Force
Copy-Item "E:\prueba\DETENER-SIMPLE.bat" -Destination $destino -Force

Write-Host "Archivos copiados" -ForegroundColor Green

# Crear acceso directo de prueba
$WshShell = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath("Desktop")

$shortcut = $WshShell.CreateShortcut("$desktop\TEST-PITHY.lnk")
$shortcut.TargetPath = "$destino\INICIO-SIMPLE.bat"
$shortcut.WorkingDirectory = $destino
$shortcut.Save()

Write-Host "Acceso directo creado en escritorio: TEST-PITHY.lnk" -ForegroundColor Green
Write-Host ""
Write-Host "Prueba exitosa! Instalado en: $destino" -ForegroundColor Green
Write-Host "Revisa tu escritorio para el icono TEST-PITHY" -ForegroundColor Yellow
