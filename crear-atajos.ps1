# Script para crear atajos en el escritorio
Write-Host "🔗 Creando atajos en el escritorio..." -ForegroundColor Green
Write-Host ""

$desktop = [Environment]::GetFolderPath("Desktop")
$WScriptShell = New-Object -ComObject WScript.Shell

# Atajo 1: Iniciar Chatbot
$shortcut1 = $WScriptShell.CreateShortcut("$desktop\Iniciar Chatbot JARVIS.lnk")
$shortcut1.TargetPath = "powershell.exe"
$shortcut1.Arguments = "-ExecutionPolicy Bypass -File `"E:\prueba\iniciar-chatbot.ps1`""
$shortcut1.WorkingDirectory = "E:\prueba"
$shortcut1.Description = "Iniciar el chatbot JARVIS (Ollama + Next.js + ngrok)"
$shortcut1.Save()
Write-Host "Creado: Iniciar Chatbot JARVIS" -ForegroundColor Green

# Atajo 2: Detener Chatbot
$shortcut2 = $WScriptShell.CreateShortcut("$desktop\Detener Chatbot JARVIS.lnk")
$shortcut2.TargetPath = "powershell.exe"
$shortcut2.Arguments = "-ExecutionPolicy Bypass -File `"E:\prueba\detener-chatbot.ps1`""
$shortcut2.WorkingDirectory = "E:\prueba"
$shortcut2.Description = "Detener el chatbot JARVIS y cerrar todos los servicios"
$shortcut2.Save()
Write-Host "Creado: Detener Chatbot JARVIS" -ForegroundColor Green

# Atajo 3: Ver URL de ngrok
$shortcut3 = $WScriptShell.CreateShortcut("$desktop\Ver URL del Webhook.lnk")
$shortcut3.TargetPath = "powershell.exe"
$shortcut3.Arguments = "-ExecutionPolicy Bypass -File `"E:\prueba\get-url.ps1`""
$shortcut3.WorkingDirectory = "E:\prueba"
$shortcut3.Description = "Ver la URL actual del webhook de ngrok"
$shortcut3.Save()
Write-Host "Creado: Ver URL del Webhook" -ForegroundColor Green

# Atajo 4: Configuración de horarios
$shortcut4 = $WScriptShell.CreateShortcut("$desktop\Configurar Horarios.lnk")
$shortcut4.TargetPath = "notepad.exe"
$shortcut4.Arguments = "`"E:\prueba\config-horarios.json`""
$shortcut4.WorkingDirectory = "E:\prueba"
$shortcut4.Description = "Editar horarios de atencion del chatbot"
$shortcut4.Save()
Write-Host "Creado: Configurar Horarios" -ForegroundColor Green

Write-Host ""
Write-Host "🎉 Atajos creados en el escritorio!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Ahora puedes:" -ForegroundColor Cyan
Write-Host "   - Hacer doble clic en '🚀 Iniciar Chatbot' para comenzar" -ForegroundColor White
Write-Host "   - Hacer doble clic en '🛑 Detener Chatbot' para cerrar" -ForegroundColor White
Write-Host "   - Ver la URL del webhook cuando lo necesites" -ForegroundColor White
Write-Host "   - Editar horarios fácilmente" -ForegroundColor White
Write-Host ""

Start-Sleep -Seconds 3
