@echo off
chcp 65001 >nul
title 🛑 Deteniendo PITHY Chatbot...
color 0C

echo.
echo ╔════════════════════════════════════════════════╗
echo ║      🛑 DETENIENDO PITHY CHATBOT              ║
echo ╚════════════════════════════════════════════════╝
echo.

echo 🛑 Deteniendo Ngrok...
taskkill /F /IM ngrok.exe >nul 2>&1
echo    ✓ Ngrok detenido
timeout /t 2 /nobreak >nul

echo.
echo 🛑 Deteniendo Node.js...
taskkill /F /IM node.exe >nul 2>&1
echo    ✓ Node.js detenido
timeout /t 2 /nobreak >nul

echo.
echo 🛑 Deteniendo Ollama...
taskkill /F /IM ollama.exe >nul 2>&1
echo    ✓ Ollama detenido

echo.
echo ✅ PITHY detenido correctamente!
echo.
echo 💡 Todos los servicios se cerraron
echo.
pause
