try {
    $response = Invoke-RestMethod -Uri 'http://localhost:4847/api/tunnels'
    $tunnels = $response.tunnels

    Write-Host "`n=== INFORMACIÓN DE TÚNELES NGROK ===" -ForegroundColor Cyan

    foreach ($tunnel in $tunnels) {
        Write-Host "`nTúnel: $($tunnel.name)" -ForegroundColor Yellow
        Write-Host "  Protocolo: $($tunnel.proto)" -ForegroundColor White
        Write-Host "  URL Pública: $($tunnel.public_url)" -ForegroundColor Green
        Write-Host "  Puerto Local: $($tunnel.config.addr)" -ForegroundColor Magenta
    }

    Write-Host "`n"
} catch {
    Write-Host "Error: No se pudo conectar a ngrok API en puerto 4847" -ForegroundColor Red
}
