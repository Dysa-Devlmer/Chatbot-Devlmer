@echo off
chcp 65001 >nul
cls

echo.
echo ══════════════════════════════════════════════
echo    INSTALADOR PITHY CHATBOT
echo ══════════════════════════════════════════════
echo.
echo Copiando archivos a C:\PITHY...
echo.

xcopy /E /I /Y "%~dp0" "C:\PITHY\" >nul 2>&1

echo Archivos copiados exitosamente!
echo.
echo Creando iconos en el escritorio...
echo.

powershell -ExecutionPolicy Bypass -Command "& {$shell = New-Object -ComObject WScript.Shell; $desktop = [Environment]::GetFolderPath('Desktop'); $link = $shell.CreateShortcut($desktop + '\INICIAR PITHY.lnk'); $link.TargetPath = 'C:\PITHY\INICIO-SIMPLE.bat'; $link.WorkingDirectory = 'C:\PITHY'; $link.Save(); $link = $shell.CreateShortcut($desktop + '\DETENER PITHY.lnk'); $link.TargetPath = 'C:\PITHY\DETENER-SIMPLE.bat'; $link.WorkingDirectory = 'C:\PITHY'; $link.Save(); $link = $shell.CreateShortcut($desktop + '\PANEL ADMIN PITHY.lnk'); $link.TargetPath = 'http://localhost:3000/admin'; $link.Save(); $link = $shell.CreateShortcut($desktop + '\CARPETA PITHY.lnk'); $link.TargetPath = 'C:\PITHY'; $link.Save();}"

echo Iconos creados exitosamente!
echo.
echo ══════════════════════════════════════════════
echo    INSTALACION COMPLETADA!
echo ══════════════════════════════════════════════
echo.
echo PITHY instalado en: C:\PITHY
echo.
echo Iconos en tu escritorio:
echo   - INICIAR PITHY
echo   - DETENER PITHY
echo   - PANEL ADMIN PITHY
echo   - CARPETA PITHY
echo.
echo IMPORTANTE: Debes instalar dependencias (solo primera vez)
echo   1. Abre PowerShell
echo   2. Escribe: cd C:\PITHY
echo   3. Escribe: npm install
echo   4. Espera 10-15 minutos
echo.
echo Presiona cualquier tecla para salir...
pause >nul
