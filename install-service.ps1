# Script para instalar el chatbot como servicio de Windows
# Requiere ejecutar como Administrador

Write-Host "🔧 Instalando PITHY Chatbot como servicio de Windows..." -ForegroundColor Green
Write-Host ""

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ Error: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    Write-Host "   Haz clic derecho en PowerShell > Ejecutar como Administrador" -ForegroundColor Yellow
    exit 1
}

# Instalar nssm (Non-Sucking Service Manager) si no existe
$nssmPath = "E:\prueba\nssm.exe"
if (-not (Test-Path $nssmPath)) {
    Write-Host "📥 Descargando NSSM (gestor de servicios)..." -ForegroundColor Cyan
    $nssmUrl = "https://nssm.cc/release/nssm-2.24.zip"
    $nssmZip = "E:\prueba\nssm.zip"

    Invoke-WebRequest -Uri $nssmUrl -OutFile $nssmZip
    Expand-Archive -Path $nssmZip -DestinationPath "E:\prueba\nssm_temp" -Force

    # Copiar el ejecutable correcto (64-bit)
    Copy-Item "E:\prueba\nssm_temp\nssm-2.24\win64\nssm.exe" -Destination $nssmPath

    # Limpiar
    Remove-Item $nssmZip
    Remove-Item "E:\prueba\nssm_temp" -Recurse -Force

    Write-Host "✅ NSSM descargado" -ForegroundColor Green
}

Write-Host ""
Write-Host "📋 Creando servicios..." -ForegroundColor Cyan
Write-Host ""

# 1. Servicio para Ollama
Write-Host "1️⃣  Creando servicio: PITHY-Ollama" -ForegroundColor Yellow
& $nssmPath install PITHY-Ollama "ollama" "serve"
& $nssmPath set PITHY-Ollama AppDirectory "E:\prueba"
& $nssmPath set PITHY-Ollama DisplayName "PITHY Chatbot - Ollama AI"
& $nssmPath set PITHY-Ollama Description "Servidor de IA local Ollama para el chatbot PITHY"
& $nssmPath set PITHY-Ollama Start SERVICE_AUTO_START
& $nssmPath set PITHY-Ollama AppStdout "E:\prueba\logs\ollama-service.log"
& $nssmPath set PITHY-Ollama AppStderr "E:\prueba\logs\ollama-error.log"

# 2. Servicio para Next.js
Write-Host "2️⃣  Creando servicio: PITHY-Server" -ForegroundColor Yellow
$nodePath = (Get-Command node).Path
$npmPath = (Get-Command npm).Path.Replace("npm", "npm.cmd")

& $nssmPath install PITHY-Server $nodePath
& $nssmPath set PITHY-Server AppParameters "E:\prueba\node_modules\next\dist\bin\next dev"
& $nssmPath set PITHY-Server AppDirectory "E:\prueba"
& $nssmPath set PITHY-Server DisplayName "PITHY Chatbot - Next.js Server"
& $nssmPath set PITHY-Server Description "Servidor Next.js del chatbot PITHY"
& $nssmPath set PITHY-Server Start SERVICE_AUTO_START
& $nssmPath set PITHY-Server AppStdout "E:\prueba\logs\server-service.log"
& $nssmPath set PITHY-Server AppStderr "E:\prueba\logs\server-error.log"
& $nssmPath set PITHY-Server DependOnService PITHY-Ollama

# 3. Servicio para ngrok
Write-Host "3️⃣  Creando servicio: PITHY-Ngrok" -ForegroundColor Yellow
& $nssmPath install PITHY-Ngrok "E:\prueba\ngrok.exe" "http 3000"
& $nssmPath set PITHY-Ngrok AppDirectory "E:\prueba"
& $nssmPath set PITHY-Ngrok DisplayName "PITHY Chatbot - Ngrok Tunnel"
& $nssmPath set PITHY-Ngrok Description "Tunel publico ngrok para webhooks de WhatsApp"
& $nssmPath set PITHY-Ngrok Start SERVICE_AUTO_START
& $nssmPath set PITHY-Ngrok AppStdout "E:\prueba\logs\ngrok-service.log"
& $nssmPath set PITHY-Ngrok AppStderr "E:\prueba\logs\ngrok-error.log"
& $nssmPath set PITHY-Ngrok DependOnService PITHY-Server

Write-Host ""
Write-Host "🚀 Iniciando servicios..." -ForegroundColor Cyan

# Crear carpeta de logs
New-Item -ItemType Directory -Path "E:\prueba\logs" -Force | Out-Null

# Iniciar servicios
Start-Service PITHY-Ollama
Start-Sleep -Seconds 3
Start-Service PITHY-Server
Start-Sleep -Seconds 5
Start-Service PITHY-Ngrok

Write-Host ""
Write-Host "✅ Servicios instalados e iniciados!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Estado de servicios:" -ForegroundColor Cyan
Get-Service PITHY-* | Format-Table Name, Status, DisplayName

Write-Host ""
Write-Host "🎉 Instalacion completada!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Los servicios se iniciaran automaticamente cuando enciendas tu PC" -ForegroundColor Yellow
Write-Host ""
Write-Host "🔧 Comandos utiles:" -ForegroundColor Cyan
Write-Host "   Ver servicios:    Get-Service PITHY-*" -ForegroundColor White
Write-Host "   Detener todo:     Stop-Service PITHY-*" -ForegroundColor White
Write-Host "   Iniciar todo:     Start-Service PITHY-Ollama,PITHY-Server,PITHY-Ngrok" -ForegroundColor White
Write-Host "   Ver logs:         Get-Content E:\prueba\logs\*.log -Tail 50" -ForegroundColor White
Write-Host "   Panel Admin:      http://localhost:3000/admin" -ForegroundColor White
Write-Host "   Desinstalar:      powershell -ExecutionPolicy Bypass -File uninstall-service.ps1" -ForegroundColor White
Write-Host ""

# Obtener URL de ngrok
Write-Host "⏳ Esperando a que ngrok genere la URL..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
    $publicUrl = $response.tunnels[0].public_url

    Write-Host ""
    Write-Host "🌐 URL del webhook:" -ForegroundColor Green
    Write-Host "   $publicUrl/api/whatsapp/webhook" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  IMPORTANTE: Configura esta URL en Meta Business Settings" -ForegroundColor Yellow
} catch {
    Write-Host ""
    Write-Host "⚠️  No se pudo obtener la URL de ngrok todavia" -ForegroundColor Yellow
    Write-Host "   Ejecuta: powershell -ExecutionPolicy Bypass -File get-url.ps1" -ForegroundColor White
    Write-Host "   en unos minutos para obtener la URL" -ForegroundColor White
}
