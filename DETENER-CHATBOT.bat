@echo off
:: Detener servicios del chatbot JARVIS
:: Este script solicita permisos de administrador automáticamente

net session >nul 2>&1
if %errorLevel% == 0 (
    :: Ya tiene permisos de administrador
    powershell -ExecutionPolicy Bypass -File "%~dp0detener-servicios-admin.ps1"
) else (
    :: Solicitar permisos de administrador
    powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0detener-servicios-admin.ps1\"' -Verb RunAs"
)
