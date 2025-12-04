# Script para iniciar los servicios de JARVIS
Write-Host "Iniciando servicios de JARVIS..." -ForegroundColor Green
Write-Host ""

# Verificar permisos de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    exit 1
}

Write-Host "1. Iniciando JARVIS-Ollama..." -ForegroundColor Cyan
Start-Service JARVIS-Ollama
Start-Sleep -Seconds 3

Write-Host "2. Iniciando JARVIS-Server..." -ForegroundColor Cyan
Start-Service JARVIS-Server
Start-Sleep -Seconds 5

Write-Host "3. Iniciando JARVIS-Ngrok..." -ForegroundColor Cyan
Start-Service JARVIS-Ngrok
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "Estado de servicios:" -ForegroundColor Green
Get-Service JARVIS-* | Format-Table Name, Status, DisplayName -AutoSize

Write-Host ""
Write-Host "Servicios iniciados correctamente!" -ForegroundColor Green
Write-Host ""
Write-Host "Obteniendo URL de ngrok..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
    $publicUrl = $response.tunnels[0].public_url

    Write-Host ""
    Write-Host "URL del webhook:" -ForegroundColor Green
    Write-Host "   $publicUrl/api/whatsapp/webhook" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "No se pudo obtener la URL de ngrok todavia" -ForegroundColor Yellow
    Write-Host "Ejecuta: pwsh -File get-url.ps1" -ForegroundColor White
}
