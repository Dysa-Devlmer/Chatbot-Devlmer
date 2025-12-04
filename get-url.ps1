$response = Invoke-RestMethod -Uri http://localhost:4040/api/tunnels
$url = $response.tunnels[0].public_url
Write-Host ""
Write-Host "======================================"
Write-Host "URL DE NGROK ACTIVA:"
Write-Host "======================================"
Write-Host $url
Write-Host ""
Write-Host "======================================"
Write-Host "CONFIGURACION WEBHOOK EN META:"
Write-Host "======================================"
Write-Host "URL de devolucion de llamada:"
Write-Host "$url/api/whatsapp/webhook"
Write-Host ""
Write-Host "Token de verificacion:"
Write-Host "mi_token_secreto_123"
Write-Host "======================================"
