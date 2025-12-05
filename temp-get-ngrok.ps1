Start-Sleep -Seconds 8
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:4040/api/tunnels'
    $url = ($response.tunnels | Where-Object { $_.proto -eq 'https' }).public_url
    if (-not $url) {
        $url = $response.tunnels[0].public_url
    }

    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host "WEBHOOK URL:" -ForegroundColor Yellow
    Write-Host "$url/api/whatsapp/webhook" -ForegroundColor White
    Write-Host "=====================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Token de verificacion: mi_token_secreto_123" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Panel Admin: http://localhost:3000/admin" -ForegroundColor Magenta
    Write-Host ""
} catch {
    Write-Host "Error: ngrok no está corriendo o aún no está listo" -ForegroundColor Red
    Write-Host "Intenta de nuevo en unos segundos" -ForegroundColor Yellow
}
