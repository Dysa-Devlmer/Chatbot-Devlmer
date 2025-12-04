# Script para detener servicios del chatbot JARVIS
# Ejecutar como Administrador

Write-Host "Deteniendo servicios del chatbot JARVIS..." -ForegroundColor Yellow

try {
    # Detener servicios en orden inverso
    Write-Host "Deteniendo JARVIS-Ngrok..."
    Stop-Service -Name "JARVIS-Ngrok" -Force -ErrorAction SilentlyContinue

    Write-Host "Deteniendo JARVIS-Server..."
    Stop-Service -Name "JARVIS-Server" -Force -ErrorAction SilentlyContinue

    Write-Host "Deteniendo JARVIS-Ollama..."
    Stop-Service -Name "JARVIS-Ollama" -Force -ErrorAction SilentlyContinue

    Start-Sleep -Seconds 2

    # Verificar estado
    Write-Host "`nEstado de servicios:" -ForegroundColor Cyan
    Get-Service JARVIS-* | Format-Table Name, Status -AutoSize

    Write-Host "`n✅ Servicios detenidos correctamente!" -ForegroundColor Green

} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
}

Write-Host "`nPresiona cualquier tecla para salir..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
