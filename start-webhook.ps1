# Script para iniciar el webhook de WhatsApp con ngrok
Write-Host "🚀 Iniciando webhook para WhatsApp JARVIS..." -ForegroundColor Green
Write-Host ""

# Verificar que ngrok existe
if (-not (Test-Path ".\ngrok.exe")) {
    Write-Host "❌ Error: ngrok.exe no encontrado en el directorio actual" -ForegroundColor Red
    exit 1
}

# Iniciar ngrok
Write-Host "📡 Iniciando túnel ngrok en puerto 3000..." -ForegroundColor Cyan
Start-Process -FilePath ".\ngrok.exe" -ArgumentList "http", "3000" -NoNewWindow

# Esperar a que ngrok se inicie
Start-Sleep -Seconds 3

# Obtener la URL pública
try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
    $publicUrl = $response.tunnels[0].public_url

    Write-Host ""
    Write-Host "✅ Webhook activo!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 URL del webhook:" -ForegroundColor Yellow
    Write-Host "   $publicUrl/api/whatsapp/webhook" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 Configuración en Meta Business:" -ForegroundColor Cyan
    Write-Host "   1. Ve a: https://developers.facebook.com/apps" -ForegroundColor White
    Write-Host "   2. Selecciona tu app" -ForegroundColor White
    Write-Host "   3. WhatsApp > Configuración" -ForegroundColor White
    Write-Host "   4. URL del webhook: $publicUrl/api/whatsapp/webhook" -ForegroundColor White
    Write-Host "   5. Token de verificación: tu_token_secreto_123" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  IMPORTANTE: Deja esta ventana abierta mientras uses el chatbot" -ForegroundColor Yellow
    Write-Host "   Si cierras esta ventana, el webhook dejará de funcionar" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Presiona Ctrl+C para detener el webhook" -ForegroundColor Gray

    # Mantener el script ejecutándose
    while ($true) {
        Start-Sleep -Seconds 60
    }

} catch {
    Write-Host ""
    Write-Host "❌ Error: No se pudo conectar a ngrok" -ForegroundColor Red
    Write-Host "   Asegúrate de que npm run dev esté corriendo" -ForegroundColor Yellow
    exit 1
}
