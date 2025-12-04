# Script para reconfigurar los servicios de JARVIS
Write-Host "Reconfigurando servicios de JARVIS..." -ForegroundColor Green
Write-Host ""

# Verificar permisos de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Error: Este script debe ejecutarse como Administrador" -ForegroundColor Red
    exit 1
}

$nssmPath = "E:\prueba\nssm.exe"

# Obtener rutas completas
$ollamaPath = (Get-Command ollama).Path
$nodePath = (Get-Command node).Path
$ngrokPath = "E:\prueba\ngrok.exe"

Write-Host "Rutas detectadas:" -ForegroundColor Cyan
Write-Host "  Ollama: $ollamaPath" -ForegroundColor White
Write-Host "  Node:   $nodePath" -ForegroundColor White
Write-Host "  Ngrok:  $ngrokPath" -ForegroundColor White
Write-Host ""

# Detener todos los servicios primero
Write-Host "Deteniendo servicios existentes..." -ForegroundColor Yellow
Get-Service JARVIS-* | Stop-Service -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Reconfigurar JARVIS-Ollama
Write-Host "1. Reconfigurando JARVIS-Ollama..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Ollama Application "$ollamaPath"
& $nssmPath set JARVIS-Ollama AppParameters "serve"
& $nssmPath set JARVIS-Ollama AppDirectory "E:\prueba"
& $nssmPath set JARVIS-Ollama AppStdout "E:\prueba\logs\ollama-service.log"
& $nssmPath set JARVIS-Ollama AppStderr "E:\prueba\logs\ollama-error.log"
& $nssmPath set JARVIS-Ollama Start SERVICE_AUTO_START
Write-Host "   OK" -ForegroundColor Green

# Reconfigurar JARVIS-Server
Write-Host "2. Reconfigurando JARVIS-Server..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Server Application "$nodePath"
& $nssmPath set JARVIS-Server AppParameters "E:\prueba\node_modules\.bin\next dev"
& $nssmPath set JARVIS-Server AppDirectory "E:\prueba"
& $nssmPath set JARVIS-Server AppStdout "E:\prueba\logs\server-service.log"
& $nssmPath set JARVIS-Server AppStderr "E:\prueba\logs\server-error.log"
& $nssmPath set JARVIS-Server Start SERVICE_AUTO_START
& $nssmPath set JARVIS-Server DependOnService "JARVIS-Ollama"
Write-Host "   OK" -ForegroundColor Green

# Reconfigurar JARVIS-Ngrok
Write-Host "3. Reconfigurando JARVIS-Ngrok..." -ForegroundColor Cyan
& $nssmPath set JARVIS-Ngrok Application "$ngrokPath"
& $nssmPath set JARVIS-Ngrok AppParameters "http 3000"
& $nssmPath set JARVIS-Ngrok AppDirectory "E:\prueba"
& $nssmPath set JARVIS-Ngrok AppStdout "E:\prueba\logs\ngrok-service.log"
& $nssmPath set JARVIS-Ngrok AppStderr "E:\prueba\logs\ngrok-error.log"
& $nssmPath set JARVIS-Ngrok Start SERVICE_AUTO_START
& $nssmPath set JARVIS-Ngrok DependOnService "JARVIS-Server"
Write-Host "   OK" -ForegroundColor Green

Write-Host ""
Write-Host "Limpiando logs antiguos..." -ForegroundColor Yellow
Remove-Item E:\prueba\logs\*.log -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Iniciando servicios en orden..." -ForegroundColor Green
Write-Host ""

# Iniciar JARVIS-Ollama
Write-Host "1. Iniciando JARVIS-Ollama..." -ForegroundColor Cyan
try {
    & $nssmPath start JARVIS-Ollama
    Start-Sleep -Seconds 5

    $status = & $nssmPath status JARVIS-Ollama
    if ($status -like "*RUNNING*") {
        Write-Host "   OK - Ollama corriendo" -ForegroundColor Green
    } else {
        Write-Host "   ERROR - Ollama no inicio: $status" -ForegroundColor Red
        Write-Host "   Ver logs:" -ForegroundColor Yellow
        Get-Content E:\prueba\logs\ollama-error.log -Tail 10 | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
    }
} catch {
    Write-Host "   ERROR: $_" -ForegroundColor Red
}

# Iniciar JARVIS-Server
Write-Host ""
Write-Host "2. Iniciando JARVIS-Server..." -ForegroundColor Cyan
try {
    & $nssmPath start JARVIS-Server
    Start-Sleep -Seconds 8

    $status = & $nssmPath status JARVIS-Server
    if ($status -like "*RUNNING*") {
        Write-Host "   OK - Next.js corriendo" -ForegroundColor Green
    } else {
        Write-Host "   ERROR - Next.js no inicio: $status" -ForegroundColor Red
        Write-Host "   Ver logs:" -ForegroundColor Yellow
        Get-Content E:\prueba\logs\server-error.log -Tail 10 | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
    }
} catch {
    Write-Host "   ERROR: $_" -ForegroundColor Red
}

# Iniciar JARVIS-Ngrok
Write-Host ""
Write-Host "3. Iniciando JARVIS-Ngrok..." -ForegroundColor Cyan
try {
    & $nssmPath start JARVIS-Ngrok
    Start-Sleep -Seconds 5

    $status = & $nssmPath status JARVIS-Ngrok
    if ($status -like "*RUNNING*") {
        Write-Host "   OK - Ngrok corriendo" -ForegroundColor Green
    } else {
        Write-Host "   ERROR - Ngrok no inicio: $status" -ForegroundColor Red
        Write-Host "   Ver logs:" -ForegroundColor Yellow
        Get-Content E:\prueba\logs\ngrok-error.log -Tail 10 | ForEach-Object { Write-Host "     $_" -ForegroundColor Gray }
    }
} catch {
    Write-Host "   ERROR: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "Estado final de servicios:" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Get-Service JARVIS-* | Format-Table Name, Status, DisplayName -AutoSize

Write-Host ""
Write-Host "Intentando obtener URL de ngrok..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
    $publicUrl = $response.tunnels[0].public_url

    Write-Host ""
    Write-Host "======================================" -ForegroundColor Green
    Write-Host "URL DEL WEBHOOK:" -ForegroundColor Green
    Write-Host "$publicUrl/api/whatsapp/webhook" -ForegroundColor White
    Write-Host "======================================" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "No se pudo obtener la URL todavia" -ForegroundColor Yellow
    Write-Host "Espera 30 segundos y ejecuta: pwsh -File get-url.ps1" -ForegroundColor White
}

Write-Host ""
Write-Host "Presiona cualquier tecla para cerrar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
