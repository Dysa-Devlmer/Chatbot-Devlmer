Write-Host "Esperando a que Next.js compile..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host "`nVerificando puerto 7847..." -ForegroundColor Cyan
$result = netstat -ano | Select-String ":7847"

if ($result) {
    Write-Host "`nServidor CORRIENDO en puerto 7847" -ForegroundColor Green
    Write-Host "`nAbre tu navegador en: http://localhost:7847/admin" -ForegroundColor Cyan
} else {
    Write-Host "`nServidor NO detectado en puerto 7847" -ForegroundColor Red
    Write-Host "Revisa la ventana CMD que se abrio para ver el error" -ForegroundColor Yellow
}
