# Script para iniciar servicios del chatbot JARVIS
# Ejecutar como Administrador

Write-Host "Iniciando servicios del chatbot JARVIS..." -ForegroundColor Yellow

try {
    # Iniciar servicios en orden correcto (con dependencias)
    Write-Host "Iniciando JARVIS-Ollama..."
    Start-Service -Name "JARVIS-Ollama" -ErrorAction Stop
    Start-Sleep -Seconds 3

    Write-Host "Iniciando JARVIS-Server..."
    Start-Service -Name "JARVIS-Server" -ErrorAction Stop
    Start-Sleep -Seconds 5

    Write-Host "Iniciando JARVIS-Ngrok..."
    Start-Service -Name "JARVIS-Ngrok" -ErrorAction Stop
    Start-Sleep -Seconds 3

    # Verificar estado
    Write-Host "`nEstado de servicios:" -ForegroundColor Cyan
    Get-Service JARVIS-* | Format-Table Name, Status -AutoSize

    # Obtener URL de ngrok
    Start-Sleep -Seconds 2
    Write-Host "`nObteniendo URL del webhook..." -ForegroundColor Cyan
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:4040/api/tunnels" -UseBasicParsing
        $tunnels = $response.Content | ConvertFrom-Json
        $publicUrl = $tunnels.tunnels | Select-Object -ExpandProperty public_url -First 1

        Write-Host "`n🌐 Webhook URL:" -ForegroundColor Green
        Write-Host "$publicUrl/api/whatsapp/webhook" -ForegroundColor White

        Write-Host "`n📋 Configurar en Meta Business:" -ForegroundColor Yellow
        Write-Host "URL: $publicUrl/api/whatsapp/webhook"
        Write-Host "Token: mi_token_secreto_123"
    } catch {
        Write-Host "`n⚠️ No se pudo obtener la URL de ngrok. Espera unos segundos y ejecuta get-url.ps1" -ForegroundColor Yellow
    }

    Write-Host "`n✅ Servicios iniciados correctamente!" -ForegroundColor Green

} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

Write-Host "`nPresiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
