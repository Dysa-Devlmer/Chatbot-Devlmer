# SCRIPT FINAL DEFINITIVO para configurar servicios
Write-Host "====================================" -ForegroundColor Green
Write-Host "  CONFIGURACION FINAL DE SERVICIOS" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Verificar permisos de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    exit 1
}

$nssmPath = "E:\prueba\nssm.exe"

# Detener TODOS los servicios primero
Write-Host "Deteniendo servicios..." -ForegroundColor Yellow
& $nssmPath stop JARVIS-Ngrok 2>$null
& $nssmPath stop JARVIS-Server 2>$null
& $nssmPath stop JARVIS-Ollama 2>$null
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  PASO 1: Configurar Ngrok" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Configurar ngrok authtoken
Write-Host "Configurando authtoken de ngrok..." -ForegroundColor Yellow
cd E:\prueba
& .\ngrok.exe config add-authtoken 35wwl0aH8AloY91Q7jIkP9s0YZW_7SLMa1yUBbZQirVbw3cHX
Write-Host "OK - Authtoken configurado" -ForegroundColor Green

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  PASO 2: Reconfigurar Servicios" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# 1. JARVIS-Ollama (ya funciona)
Write-Host "1. JARVIS-Ollama - OK (sin cambios)" -ForegroundColor Green

# 2. JARVIS-Server - Usar npm.cmd
Write-Host "2. JARVIS-Server - Usando npm.cmd..." -ForegroundColor Cyan
$npmCmd = "C:\Program Files\nodejs\npm.cmd"
& $nssmPath set JARVIS-Server Application "$npmCmd"
& $nssmPath set JARVIS-Server AppParameters "run dev"
& $nssmPath set JARVIS-Server AppDirectory "E:\prueba"
Write-Host "   OK" -ForegroundColor Green

# 3. JARVIS-Ngrok - sin cambios
Write-Host "3. JARVIS-Ngrok - OK (sin cambios)" -ForegroundColor Green

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  PASO 3: Iniciar Servicios" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Limpiar logs
Remove-Item E:\prueba\logs\*.log -Force -ErrorAction SilentlyContinue

# Iniciar JARVIS-Ollama
Write-Host "1. Iniciando JARVIS-Ollama..." -ForegroundColor Yellow
& $nssmPath start JARVIS-Ollama
Start-Sleep -Seconds 5

$status = & $nssmPath status JARVIS-Ollama
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Ollama CORRIENDO" -ForegroundColor Green
} else {
    Write-Host "   ERROR - Ollama: $status" -ForegroundColor Red
    exit 1
}

# Iniciar JARVIS-Server
Write-Host ""
Write-Host "2. Iniciando JARVIS-Server (npm run dev)..." -ForegroundColor Yellow
Write-Host "   Esto tomara 15-20 segundos..." -ForegroundColor Gray
& $nssmPath start JARVIS-Server
Start-Sleep -Seconds 20

$status = & $nssmPath status JARVIS-Server
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Next.js CORRIENDO" -ForegroundColor Green

    # Verificar puerto 3000
    Write-Host "   Verificando puerto 3000..." -ForegroundColor Gray
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
        Write-Host "   OK - Next.js responde en puerto 3000" -ForegroundColor Green
    } catch {
        Write-Host "   ADVERTENCIA - Next.js esta iniciando, espera un momento" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ERROR - Next.js: $status" -ForegroundColor Red
    Write-Host ""
    Write-Host "   LOG DE ERRORES:" -ForegroundColor Red
    Get-Content E:\prueba\logs\server-error.log -Tail 30 -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
    exit 1
}

# Iniciar JARVIS-Ngrok
Write-Host ""
Write-Host "3. Iniciando JARVIS-Ngrok..." -ForegroundColor Yellow
& $nssmPath start JARVIS-Ngrok
Start-Sleep -Seconds 8

$status = & $nssmPath status JARVIS-Ngrok
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Ngrok CORRIENDO" -ForegroundColor Green
} else {
    Write-Host "   ERROR - Ngrok: $status" -ForegroundColor Red
    Write-Host ""
    Write-Host "   LOG DE ERRORES:" -ForegroundColor Red
    Get-Content E:\prueba\logs\ngrok-error.log -Tail 30 -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
    exit 1
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  PASO 4: Verificar Estado" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

Get-Service JARVIS-* | Format-Table Name, Status, DisplayName -AutoSize

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  PASO 5: Obtener URL de Webhook" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

Write-Host "Obteniendo URL de ngrok..." -ForegroundColor Yellow
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
            Write-Host "Intento $retryCount... esperando 5 segundos" -ForegroundColor Gray
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
    Write-Host "URL DEL WEBHOOK DE WHATSAPP:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  $webhookUrl" -ForegroundColor White
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "SIGUIENTE PASO:" -ForegroundColor Yellow
    Write-Host "1. Copia la URL de arriba" -ForegroundColor White
    Write-Host "2. Ve a: https://developers.facebook.com/apps" -ForegroundColor White
    Write-Host "3. Configurala en WhatsApp Business API" -ForegroundColor White
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "El chatbot se iniciara automaticamente" -ForegroundColor Green
    Write-Host "cada vez que enciendas tu PC" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "No se pudo obtener la URL de ngrok" -ForegroundColor Red
    Write-Host "Ejecuta manualmente: pwsh -File get-url.ps1" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
