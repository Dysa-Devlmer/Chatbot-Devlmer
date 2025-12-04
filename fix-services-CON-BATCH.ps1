# SCRIPT FINAL usando archivo BATCH para Next.js
Write-Host "====================================" -ForegroundColor Green
Write-Host "  CONFIGURACION FINAL (con BATCH)" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Verificar permisos de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    exit 1
}

$nssmPath = "E:\prueba\nssm.exe"

# Detener servicios
Write-Host "Deteniendo servicios..." -ForegroundColor Yellow
& $nssmPath stop JARVIS-Ngrok 2>$null
& $nssmPath stop JARVIS-Server 2>$null
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "Reconfigurando JARVIS-Server para usar start-nextjs.bat..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Server Application "E:\prueba\start-nextjs.bat"
& $nssmPath set JARVIS-Server AppParameters ""
& $nssmPath set JARVIS-Server AppDirectory "E:\prueba"
& $nssmPath set JARVIS-Server AppStdout "E:\prueba\logs\server-service.log"
& $nssmPath set JARVIS-Server AppStderr "E:\prueba\logs\server-error.log"
Write-Host "OK" -ForegroundColor Green

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Iniciando Servicios" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# 1. JARVIS-Ollama
Write-Host "1. JARVIS-Ollama:" -ForegroundColor Yellow
$status = & $nssmPath status JARVIS-Ollama
if ($status -like "*RUNNING*") {
    Write-Host "   Ya esta corriendo" -ForegroundColor Green
} else {
    & $nssmPath start JARVIS-Ollama
    Start-Sleep -Seconds 5
    Write-Host "   Iniciado" -ForegroundColor Green
}

# 2. JARVIS-Server
Write-Host ""
Write-Host "2. JARVIS-Server (Next.js via BATCH):" -ForegroundColor Yellow
Write-Host "   Iniciando... esto toma 15-20 segundos" -ForegroundColor Gray
& $nssmPath start JARVIS-Server
Start-Sleep -Seconds 20

$status = & $nssmPath status JARVIS-Server
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Next.js CORRIENDO" -ForegroundColor Green

    # Verificar puerto 3000
    Start-Sleep -Seconds 5
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
        Write-Host "   OK - Next.js responde en puerto 3000" -ForegroundColor Green
    } catch {
        Write-Host "   ADVERTENCIA - Next.js esta compilando, espera un momento" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ERROR - Estado: $status" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Ver logs:" -ForegroundColor Yellow
    Get-Content E:\prueba\logs\server-error.log -Tail 20 -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }

    Write-Host ""
    Write-Host "   Intentando de nuevo..." -ForegroundColor Yellow
    & $nssmPath start JARVIS-Server
    Start-Sleep -Seconds 15
}

# 3. JARVIS-Ngrok
Write-Host ""
Write-Host "3. JARVIS-Ngrok:" -ForegroundColor Yellow
& $nssmPath start JARVIS-Ngrok
Start-Sleep -Seconds 8

$status = & $nssmPath status JARVIS-Ngrok
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Ngrok CORRIENDO" -ForegroundColor Green
} else {
    Write-Host "   ERROR - Estado: $status" -ForegroundColor Red
    Write-Host ""
    Write-Host "   Ver logs:" -ForegroundColor Yellow
    Get-Content E:\prueba\logs\ngrok-error.log -Tail 20 -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  Estado Final" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

Get-Service JARVIS-* | Format-Table Name, Status, DisplayName -AutoSize

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  Obteniendo URL de Webhook" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 5

$maxRetries = 5
$retryCount = 0
$webhookUrl = $null

while ($retryCount -lt $maxRetries -and -not $webhookUrl) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -TimeoutSec 5 -ErrorAction Stop
        if ($response.tunnels -and $response.tunnels.Count -gt 0) {
            $webhookUrl = $response.tunnels[0].public_url + "/api/whatsapp/webhook"
            break
        }
    } catch {
        $retryCount++
        if ($retryCount -lt $maxRetries) {
            Write-Host "Intento $retryCount de $maxRetries... esperando" -ForegroundColor Gray
            Start-Sleep -Seconds 5
        }
    }
}

Write-Host ""
if ($webhookUrl) {
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "         INSTALACION EXITOSA!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "URL DEL WEBHOOK:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  $webhookUrl" -ForegroundColor White
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Configura esta URL en Meta Business API" -ForegroundColor Yellow
    Write-Host "https://developers.facebook.com/apps" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "El chatbot se iniciara automaticamente" -ForegroundColor Green
    Write-Host "cuando enciendas tu PC" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "No se pudo obtener la URL de ngrok" -ForegroundColor Red
    Write-Host "Ejecuta: pwsh -File get-url.ps1" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
