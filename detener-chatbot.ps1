# Script para detener todos los servicios del chatbot JARVIS
Write-Host "Deteniendo JARVIS Chatbot..." -ForegroundColor Yellow
Write-Host ""

# Funcion para matar procesos por nombre
function Stop-ProcessByName {
    param($processName)

    $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "   Deteniendo $processName..." -ForegroundColor Cyan
        $processes | ForEach-Object {
            Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
        }
        Write-Host "   OK - $processName detenido" -ForegroundColor Green
    } else {
        Write-Host "   INFO - $processName no estaba ejecutandose" -ForegroundColor Gray
    }
}

Write-Host "1. Deteniendo ngrok..." -ForegroundColor Yellow
Stop-ProcessByName "ngrok"

Write-Host ""
Write-Host "2. Deteniendo Node.js (Next.js del chatbot)..." -ForegroundColor Yellow
# Solo detener el proceso de Node.js que esta ejecutando Next.js en el puerto 3000
$nodeProcesses = Get-Process -Name node -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    $stopped = $false
    foreach ($proc in $nodeProcesses) {
        try {
            # Verificar si el proceso tiene "next" o esta en el directorio E:\prueba
            $cmdLine = (Get-WmiObject Win32_Process -Filter "ProcessId = $($proc.Id)").CommandLine
            if ($cmdLine -and ($cmdLine -like "*next*" -or $cmdLine -like "*E:\prueba*")) {
                Write-Host "   Deteniendo proceso Node.js (PID: $($proc.Id))..." -ForegroundColor Cyan
                Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
                $stopped = $true
            }
        } catch {
            # Ignorar errores de procesos que no se pueden consultar
        }
    }
    if ($stopped) {
        Write-Host "   OK - Next.js detenido" -ForegroundColor Green
    } else {
        Write-Host "   INFO - No se encontro el proceso de Next.js del chatbot" -ForegroundColor Gray
    }
} else {
    Write-Host "   INFO - Node.js no estaba ejecutandose" -ForegroundColor Gray
}

Write-Host ""
Write-Host "3. Deteniendo Ollama..." -ForegroundColor Yellow
# Detener solo los procesos de Ollama (app_server y runner)
$ollamaProcesses = Get-Process -Name ollama,ollama_llama_server -ErrorAction SilentlyContinue
if ($ollamaProcesses) {
    Write-Host "   Deteniendo procesos de Ollama..." -ForegroundColor Cyan
    $ollamaProcesses | ForEach-Object {
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
    Write-Host "   OK - Ollama detenido" -ForegroundColor Green
} else {
    Write-Host "   INFO - Ollama no estaba ejecutandose" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Todos los servicios detenidos!" -ForegroundColor Green
Write-Host ""
Write-Host "NOTA: El chatbot ahora esta APAGADO." -ForegroundColor Yellow
Write-Host "Los clientes NO recibiran respuesta automatica." -ForegroundColor Yellow
Write-Host ""
Write-Host "Para volver a iniciar el chatbot:" -ForegroundColor Cyan
Write-Host "   powershell -ExecutionPolicy Bypass -File iniciar-chatbot.ps1" -ForegroundColor White
Write-Host ""

Start-Sleep -Seconds 2
