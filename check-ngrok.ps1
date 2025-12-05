# Script simple para verificar ngrok
try {
    $response = Invoke-RestMethod -Uri 'http://localhost:4040/api/tunnels' -TimeoutSec 3
    $url = ($response.tunnels | Where-Object { $_.proto -eq 'https' }).public_url
    if (-not $url) {
        $url = $response.tunnels[0].public_url
    }
    Write-Host "URL: $url/api/whatsapp/webhook"
} catch {
    Write-Host "Ngrok no esta corriendo"
}
