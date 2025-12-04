# Script para desinstalar los servicios del chatbot JARVIS
# Requiere ejecutar como Administrador

Write-Host "🗑️  Desinstalando servicios de JARVIS Chatbot..." -ForegroundColor Yellow
Write-Host ""

# Verificar si se ejecuta como administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "❌ Error: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    exit 1
}

$nssmPath = "E:\prueba\nssm.exe"

if (-not (Test-Path $nssmPath)) {
    Write-Host "❌ Error: NSSM no encontrado. Los servicios pueden no estar instalados." -ForegroundColor Red
    exit 1
}

# Detener y eliminar servicios
$services = @("JARVIS-Ngrok", "JARVIS-Server", "JARVIS-Ollama")

foreach ($service in $services) {
    try {
        Write-Host "🛑 Deteniendo $service..." -ForegroundColor Cyan
        Stop-Service $service -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2

        Write-Host "🗑️  Eliminando $service..." -ForegroundColor Yellow
        & $nssmPath remove $service confirm

        Write-Host "✅ $service eliminado" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  $service no encontrado o ya eliminado" -ForegroundColor Yellow
    }
    Write-Host ""
}

Write-Host "✅ Desinstalacion completada!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Puedes seguir usando el chatbot manualmente con:" -ForegroundColor Cyan
Write-Host "   npm run dev" -ForegroundColor White
Write-Host "   .\ngrok.exe http 3000" -ForegroundColor White
