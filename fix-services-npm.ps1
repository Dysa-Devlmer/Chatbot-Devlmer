# Script para configurar servicios usando NPM correctamente
Write-Host "Reconfigurando servicios para usar NPM..." -ForegroundColor Green
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

# Obtener ruta de npm
$npmPath = (Get-Command npm).Path

Write-Host ""
Write-Host "Rutas:" -ForegroundColor Cyan
Write-Host "  NPM: $npmPath" -ForegroundColor White
Write-Host ""

# Reconfigurar JARVIS-Server para usar npm
Write-Host "1. Reconfigurando JARVIS-Server para usar 'npm run dev'..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Server Application "$npmPath"
& $nssmPath set JARVIS-Server AppParameters "run dev"
& $nssmPath set JARVIS-Server AppDirectory "E:\prueba"
& $nssmPath set JARVIS-Server AppEnvironmentExtra "NODE_ENV=development"
Write-Host "   OK" -ForegroundColor Green

# Reconfigurar JARVIS-Ngrok con variables de entorno
Write-Host ""
Write-Host "2. Reconfigurando JARVIS-Ngrok..." -ForegroundColor Cyan
$ngrokConfig = "C:\Users\zeNk0\AppData\Local\ngrok"
& $nssmPath set JARVIS-Ngrok Application "E:\prueba\ngrok.exe"
& $nssmPath set JARVIS-Ngrok AppParameters "http 3000 --log=stdout"
& $nssmPath set JARVIS-Ngrok AppDirectory "E:\prueba"
Write-Host "   OK" -ForegroundColor Green

Write-Host ""
Write-Host "Iniciando servicios..." -ForegroundColor Green
Write-Host ""

# 1. JARVIS-Ollama
Write-Host "1. JARVIS-Ollama:" -ForegroundColor Cyan
$status = & $nssmPath status JARVIS-Ollama
if ($status -like "*RUNNING*") {
    Write-Host "   Ya esta corriendo" -ForegroundColor Green
}

# 2. JARVIS-Server
Write-Host ""
Write-Host "2. JARVIS-Server (npm run dev):" -ForegroundColor Cyan
& $nssmPath start JARVIS-Server
Write-Host "   Esperando 15 segundos a que Next.js compile..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

$status = & $nssmPath status JARVIS-Server
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Next.js corriendo" -ForegroundColor Green

    # Verificar si el servidor responde
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -TimeoutSec 5 -UseBasicParsing -ErrorAction Stop
        Write-Host "   Next.js responde en puerto 3000" -ForegroundColor Green
    } catch {
        Write-Host "   ADVERTENCIA - Next.js esta corriendo pero no responde todavia" -ForegroundColor Yellow
        Write-Host "   Esperando 10 segundos mas..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }
} else {
    Write-Host "   ERROR - Estado: $status" -ForegroundColor Red
    Write-Host "   Ultimas lineas del log:" -ForegroundColor Yellow
    Get-Content E:\prueba\logs\server-error.log -Tail 20 -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
}

# 3. JARVIS-Ngrok
Write-Host ""
Write-Host "3. JARVIS-Ngrok:" -ForegroundColor Cyan
& $nssmPath start JARVIS-Ngrok
Start-Sleep -Seconds 8

$status = & $nssmPath status JARVIS-Ngrok
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Ngrok corriendo" -ForegroundColor Green
} else {
    Write-Host "   ERROR - Estado: $status" -ForegroundColor Red
    Write-Host "   Ultimas lineas del log:" -ForegroundColor Yellow
    Get-Content E:\prueba\logs\ngrok-error.log -Tail 20 -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "Estado final:" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Get-Service JARVIS-* | Format-Table Name, Status, DisplayName -AutoSize

Write-Host ""
Write-Host "Obteniendo URL de ngrok..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

$maxRetries = 3
$retryCount = 0
$success = $false

while ($retryCount -lt $maxRetries -and -not $success) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -TimeoutSec 5
        $publicUrl = $response.tunnels[0].public_url

        Write-Host ""
        Write-Host "======================================" -ForegroundColor Green
        Write-Host "    URL DEL WEBHOOK DE WHATSAPP" -ForegroundColor Green
        Write-Host "======================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "$publicUrl/api/whatsapp/webhook" -ForegroundColor White
        Write-Host ""
        Write-Host "======================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Configura esta URL en Meta Business:" -ForegroundColor Yellow
        Write-Host "https://developers.facebook.com/apps" -ForegroundColor Cyan
        Write-Host ""

        $success = $true
    } catch {
        $retryCount++
        if ($retryCount -lt $maxRetries) {
            Write-Host "Intento $retryCount fallido, esperando 5 segundos..." -ForegroundColor Yellow
            Start-Sleep -Seconds 5
        } else {
            Write-Host ""
            Write-Host "No se pudo obtener la URL de ngrok despues de $maxRetries intentos" -ForegroundColor Red
            Write-Host ""
            Write-Host "Verifica manualmente ejecutando:" -ForegroundColor Yellow
            Write-Host "  pwsh -File get-url.ps1" -ForegroundColor White
            Write-Host ""
        }
    }
}

if ($success) {
    Write-Host "TODO LISTO! El chatbot esta funcionando como servicio" -ForegroundColor Green
    Write-Host "Se iniciara automaticamente cuando enciendas tu PC" -ForegroundColor Green
} else {
    Write-Host "Los servicios estan configurados pero hay problemas" -ForegroundColor Yellow
    Write-Host "Revisa los logs en: E:\prueba\logs\" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
