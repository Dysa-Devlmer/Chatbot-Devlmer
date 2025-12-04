@echo off
title Instalador PITHY Chatbot
cls

echo.
echo ══════════════════════════════════════════════
echo    INSTALADOR PITHY CHATBOT
echo    Devlmer Project CL
echo ══════════════════════════════════════════════
echo.
echo [Paso 1 de 3] Copiando archivos a C:\PITHY...

robocopy "%~dp0" "C:\PITHY" /E /NFL /NDL /NJH /NJS /nc /ns /np /EXCLUDE:%~dp0exclude-install.txt

echo.
echo [Paso 2 de 3] Creando iconos en el escritorio...

powershell -ExecutionPolicy Bypass -Command "$s = New-Object -ComObject WScript.Shell; $d = [Environment]::GetFolderPath('Desktop'); $l = $s.CreateShortcut($d + '\INICIAR PITHY.lnk'); $l.TargetPath = 'C:\PITHY\INICIO-SIMPLE.bat'; $l.WorkingDirectory = 'C:\PITHY'; $l.Save(); $l = $s.CreateShortcut($d + '\DETENER PITHY.lnk'); $l.TargetPath = 'C:\PITHY\DETENER-SIMPLE.bat'; $l.WorkingDirectory = 'C:\PITHY'; $l.Save(); $l = $s.CreateShortcut($d + '\PANEL ADMIN PITHY.lnk'); $l.TargetPath = 'http://localhost:3000/admin'; $l.Save(); $l = $s.CreateShortcut($d + '\CARPETA PITHY.lnk'); $l.TargetPath = 'C:\PITHY'; $l.Save();"

echo.
echo [Paso 3 de 3] Configuracion final...
cd /d C:\PITHY

echo.
echo ══════════════════════════════════════════════
echo    INSTALACION COMPLETADA!
echo ══════════════════════════════════════════════
echo.
echo PITHY instalado en: C:\PITHY
echo.
echo Iconos creados en tu escritorio:
echo   - INICIAR PITHY
echo   - DETENER PITHY
echo   - PANEL ADMIN PITHY
echo   - CARPETA PITHY
echo.
echo ══════════════════════════════════════════════
echo    IMPORTANTE - PROXIMOS PASOS:
echo ══════════════════════════════════════════════
echo.
echo 1. Abre PowerShell como Administrador
echo 2. Ejecuta: cd C:\PITHY
echo 3. Ejecuta: npm install
echo 4. Espera 10-15 minutos
echo.
echo 5. Configura tus credenciales en:
echo    C:\PITHY\.env.local
echo.
echo 6. Haz doble clic en "INICIAR PITHY"
echo.
echo ══════════════════════════════════════════════
echo.
pause
