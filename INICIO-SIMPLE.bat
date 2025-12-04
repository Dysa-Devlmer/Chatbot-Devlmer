@echo off
chcp 65001 >nul
title 🚀 Iniciando PITHY Chatbot...
color 0A

echo.
echo ╔════════════════════════════════════════════════╗
echo ║      🤖 PITHY CHATBOT - DEVLMER PROJECT       ║
echo ╚════════════════════════════════════════════════╝
echo.
echo 🚀 Iniciando servicios...
echo.

cd /d "%~dp0"

start "Ollama AI" /MIN cmd /c "echo ⚡ Ollama AI Server && ollama serve"
timeout /t 5 /nobreak >nul

start "Next.js Server" /MIN cmd /c "echo ⚡ Next.js Server && npm run dev"
timeout /t 10 /nobreak >nul

start "Ngrok Tunnel" /MIN cmd /c "echo ⚡ Ngrok Tunnel && ngrok.exe http 3000"
timeout /t 5 /nobreak >nul

echo.
echo ✅ Todos los servicios iniciados!
echo.
echo 🎛️  Panel Admin: http://localhost:3000/admin
echo.
echo 💡 Las ventanas se minimizaron automáticamente
echo.
echo ⚠️  NO CIERRES esta ventana si quieres que PITHY funcione
echo.
pause
