# Script para configurar correctamente el servicio de ngrok
Write-Host "Configurando servicio JARVIS-Ngrok..." -ForegroundColor Green
Write-Host ""

# Verificar permisos de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    exit 1
}

$nssmPath = "E:\prueba\nssm.exe"

# Detener ngrok
Write-Host "Deteniendo JARVIS-Ngrok..." -ForegroundColor Yellow
& $nssmPath stop JARVIS-Ngrok 2>$null
Start-Sleep -Seconds 2

# Reconfigurar para usar el archivo ngrok.yml
Write-Host "Reconfigurando JARVIS-Ngrok para usar ngrok.yml..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Ngrok Application "E:\prueba\ngrok.exe"
& $nssmPath set JARVIS-Ngrok AppParameters "http 7847 --config=E:\prueba\ngrok.yml --log=stdout"
& $nssmPath set JARVIS-Ngrok AppDirectory "E:\prueba"
& $nssmPath set JARVIS-Ngrok AppStdout "E:\prueba\logs\ngrok-service.log"
& $nssmPath set JARVIS-Ngrok AppStderr "E:\prueba\logs\ngrok-error.log"
Write-Host "OK" -ForegroundColor Green

# Limpiar logs anteriores
Write-Host ""
Write-Host "Limpiando logs antiguos..." -ForegroundColor Yellow
Remove-Item E:\prueba\logs\ngrok*.log -Force -ErrorAction SilentlyContinue

# Iniciar ngrok
Write-Host ""
Write-Host "Iniciando JARVIS-Ngrok..." -ForegroundColor Yellow
& $nssmPath start JARVIS-Ngrok
Start-Sleep -Seconds 8

$status = & $nssmPath status JARVIS-Ngrok
if ($status -like "*RUNNING*") {
    Write-Host "OK - Ngrok CORRIENDO" -ForegroundColor Green
} else {
    Write-Host "ERROR - Estado: $status" -ForegroundColor Red
    Write-Host ""
    Write-Host "Ver logs de error:" -ForegroundColor Yellow
    Get-Content E:\prueba\logs\ngrok-error.log -Tail 20 -ErrorAction SilentlyContinue | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
    exit 1
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "  Estado de Servicios" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Get-Service JARVIS-* | Format-Table Name, Status, DisplayName -AutoSize

Write-Host ""
Write-Host "Obteniendo URL de ngrok..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

$maxRetries = 5
$retryCount = 0
$webhookUrl = $null

while ($retryCount -lt $maxRetries -and -not $webhookUrl) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:4847/api/tunnels" -TimeoutSec 5 -ErrorAction Stop
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
    Write-Host "         TODO FUNCIONANDO!" -ForegroundColor Green
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
    Write-Host "Los 3 servicios se iniciaran automaticamente" -ForegroundColor Green
    Write-Host "cuando enciendas tu PC" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "No se pudo obtener la URL de ngrok" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifica manualmente:" -ForegroundColor Yellow
    Write-Host "  pwsh -Command 'Invoke-RestMethod http://localhost:4847/api/tunnels'" -ForegroundColor White
    Write-Host ""
}

Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
