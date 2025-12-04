@echo off
powershell -ExecutionPolicy Bypass -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoExit', '-ExecutionPolicy', 'Bypass', '-File', 'E:\prueba\install-service.ps1' -Wait"
