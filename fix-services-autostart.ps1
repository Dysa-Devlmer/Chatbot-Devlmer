# Script para configurar inicio automatico de servicios
Write-Host "Configurando servicios para inicio automatico..." -ForegroundColor Green
Write-Host ""

# Verificar permisos de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    exit 1
}

$nssmPath = "E:\prueba\nssm.exe"

Write-Host "Configurando JARVIS-Ollama..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Ollama Start SERVICE_AUTO_START

Write-Host "Configurando JARVIS-Server..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Server Start SERVICE_AUTO_START

Write-Host "Configurando JARVIS-Ngrok..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Ngrok Start SERVICE_AUTO_START

Write-Host ""
Write-Host "Iniciando servicios..." -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Iniciando JARVIS-Ollama..." -ForegroundColor Cyan
try {
    Start-Service JARVIS-Ollama -ErrorAction Stop
    Write-Host "   OK" -ForegroundColor Green
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
    Write-Host "   Intentando iniciar directamente con NSSM..." -ForegroundColor Yellow
    & $nssmPath start JARVIS-Ollama
}
Start-Sleep -Seconds 5

Write-Host "2. Iniciando JARVIS-Server..." -ForegroundColor Cyan
try {
    Start-Service JARVIS-Server -ErrorAction Stop
    Write-Host "   OK" -ForegroundColor Green
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
    Write-Host "   Intentando iniciar directamente con NSSM..." -ForegroundColor Yellow
    & $nssmPath start JARVIS-Server
}
Start-Sleep -Seconds 8

Write-Host "3. Iniciando JARVIS-Ngrok..." -ForegroundColor Cyan
try {
    Start-Service JARVIS-Ngrok -ErrorAction Stop
    Write-Host "   OK" -ForegroundColor Green
} catch {
    Write-Host "   Error: $_" -ForegroundColor Red
    Write-Host "   Intentando iniciar directamente con NSSM..." -ForegroundColor Yellow
    & $nssmPath start JARVIS-Ngrok
}
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "Estado actual:" -ForegroundColor Green
Get-Service JARVIS-* | Format-Table Name, Status, DisplayName -AutoSize

Write-Host ""
Write-Host "Intentando obtener URL de ngrok..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
    $publicUrl = $response.tunnels[0].public_url

    Write-Host ""
    Write-Host "====================================" -ForegroundColor Green
    Write-Host "URL DEL WEBHOOK:" -ForegroundColor Green
    Write-Host "$publicUrl/api/whatsapp/webhook" -ForegroundColor White
    Write-Host "====================================" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "No se pudo obtener la URL todavia" -ForegroundColor Yellow
    Write-Host "Espera 30 segundos y ejecuta: pwsh -File get-url.ps1" -ForegroundColor White
}

Write-Host ""
Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
