# Script final para corregir y arrancar los servicios
Write-Host "Correccion final de servicios JARVIS..." -ForegroundColor Green
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
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "1. Configurando authtoken de ngrok..." -ForegroundColor Cyan
& "E:\prueba\ngrok.exe" config add-authtoken 35wwl0aH8AloY91Q7jIkP9s0YZW_7SLMa1yUBbZQirVbw3cHX
Write-Host "   OK" -ForegroundColor Green

Write-Host ""
Write-Host "2. Corrigiendo JARVIS-Server (Next.js)..." -ForegroundColor Cyan
$nodePath = (Get-Command node).Path
# Usar npm run dev en lugar de next directamente
& $nssmPath set JARVIS-Server Application "$nodePath"
& $nssmPath set JARVIS-Server AppParameters "E:\prueba\node_modules\.bin\next dev"
& $nssmPath set JARVIS-Server AppDirectory "E:\prueba"
Write-Host "   OK" -ForegroundColor Green

Write-Host ""
Write-Host "Reiniciando servicios..." -ForegroundColor Green
Write-Host ""

# JARVIS-Ollama ya esta corriendo
Write-Host "1. JARVIS-Ollama:" -ForegroundColor Cyan
$status = & $nssmPath status JARVIS-Ollama
if ($status -like "*RUNNING*") {
    Write-Host "   Ya esta corriendo" -ForegroundColor Green
} else {
    & $nssmPath start JARVIS-Ollama
    Start-Sleep -Seconds 5
    Write-Host "   Iniciado" -ForegroundColor Green
}

# Iniciar JARVIS-Server
Write-Host ""
Write-Host "2. JARVIS-Server (Next.js):" -ForegroundColor Cyan
& $nssmPath start JARVIS-Server
Start-Sleep -Seconds 10

$status = & $nssmPath status JARVIS-Server
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Next.js corriendo" -ForegroundColor Green
} else {
    Write-Host "   ERROR - Estado: $status" -ForegroundColor Red
    Write-Host "   Logs de error:" -ForegroundColor Yellow
    Get-Content E:\prueba\logs\server-error.log -Tail 15 | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
}

# Iniciar JARVIS-Ngrok
Write-Host ""
Write-Host "3. JARVIS-Ngrok:" -ForegroundColor Cyan
& $nssmPath start JARVIS-Ngrok
Start-Sleep -Seconds 5

$status = & $nssmPath status JARVIS-Ngrok
if ($status -like "*RUNNING*") {
    Write-Host "   OK - Ngrok corriendo" -ForegroundColor Green
} else {
    Write-Host "   ERROR - Estado: $status" -ForegroundColor Red
    Write-Host "   Logs de error:" -ForegroundColor Yellow
    Get-Content E:\prueba\logs\ngrok-error.log -Tail 15 | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "Estado final de servicios:" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Get-Service JARVIS-* | Format-Table Name, Status, DisplayName -AutoSize

Write-Host ""
Write-Host "Esperando a que ngrok genere la URL..." -ForegroundColor Cyan
Start-Sleep -Seconds 8

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
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
    Write-Host "COPIA esta URL y configurala en:" -ForegroundColor Yellow
    Write-Host "https://developers.facebook.com/apps" -ForegroundColor Cyan
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "No se pudo obtener la URL de ngrok" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Verifica que ngrok este corriendo:" -ForegroundColor Yellow
    Write-Host "  pwsh -Command 'Get-Service JARVIS-Ngrok'" -ForegroundColor White
}

Write-Host ""
Write-Host "Todo listo! El chatbot esta corriendo como servicio." -ForegroundColor Green
Write-Host "Se iniciara automaticamente cuando enciendas tu PC." -ForegroundColor Green
Write-Host ""
Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
