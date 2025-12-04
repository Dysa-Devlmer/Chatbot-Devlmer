# COMPILAR INSTALADOR PROFESIONAL PITHY

## Estado Actual: LISTO PARA COMPILAR

Todos los archivos necesarios están creados y configurados:

### Archivos del Instalador:
- `setup.iss` - Script de Inno Setup (configurado)
- `LICENSE.txt` - Licencia profesional
- `WizModernImage.bmp` - Imagen lateral del wizard (164x314 px)
- `WizModernSmallImage.bmp` - Banner superior (55x58 px)
- `img\favicon.ico` - Icono del instalador (15KB)

## PASO 1: Descargar Inno Setup

Si no lo tienes instalado:

1. Ve a: https://jrsoftware.org/isdl.php
2. Descarga: **Inno Setup 6.x** (versión estable más reciente)
3. Instala: Siguiente, Siguiente, Finalizar

## PASO 2: Compilar el Instalador

### Opción A: Interfaz Gráfica (RECOMENDADO)

1. Abre **Inno Setup Compiler**
2. File > Open > Selecciona `E:\prueba\setup.iss`
3. Build > Compile (o presiona **F9**)
4. Espera 1-2 minutos
5. Mensaje: "Compile completed successfully"

### Opción B: Línea de Comandos

```cmd
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" "E:\prueba\setup.iss"
```

## PASO 3: Ubicación del Instalador

El archivo se creará en:
```
E:\prueba\PITHY-Installer-v1.0.exe
```

Tamaño aproximado: **50-80 MB**

## PASO 4: Probar el Instalador (IMPORTANTE)

Antes de distribuir, prueba en tu PC:

1. Doble clic en `PITHY-Installer-v1.0.exe`
2. Sigue el asistente:
   - Acepta licencia
   - Elige ubicación (ej: C:\Program Files\PITHY)
   - Marca "Crear iconos en el escritorio"
   - Click "Instalar"
3. Espera 30-60 minutos (descarga Node.js, Ollama, modelo IA, npm install)
4. Verifica que se crearon los iconos:
   - INICIAR PITHY
   - DETENER PITHY
   - PANEL ADMIN PITHY
   - CARPETA PITHY
5. Prueba iniciando PITHY desde el escritorio

## PASO 5: Distribuir

### Para Internet:
```
1. Sube a Google Drive / Dropbox / OneDrive
2. Comparte el link
3. El cliente descarga
4. Doble clic e instala
```

### Para USB:
```
1. Copia PITHY-Installer-v1.0.exe a USB
2. Llevas al restaurante
3. Copias al escritorio del PC
4. Doble clic e instala
```

## Contenido del Instalador

El .exe incluye:
- Todos los archivos del proyecto (excepto node_modules, .next, .git, logs)
- Scripts para descargar e instalar automáticamente:
  - Node.js v20.11.0 (si no está instalado)
  - Ollama AI (si no está instalado)
  - Modelo qwen2.5:3b (~2GB)
  - Dependencias npm
- Creación automática de iconos de escritorio
- Desinstalador profesional

## Características del Instalador

- Interfaz gráfica moderna y profesional
- Licencia en español
- Barra de progreso durante instalación
- Mensajes informativos
- Selección de ubicación de instalación
- Opción de iconos en escritorio
- Menú Inicio integrado
- Desinstalador incluido

## Proceso de Instalación para el Cliente

1. **Descargar** (5 min)
2. **Doble clic** en el .exe
3. **Acepta** términos de licencia
4. **Elige** ubicación (o deja por defecto)
5. **Click** "Instalar"
6. **Espera** 30-60 minutos mientras:
   - Descarga Node.js
   - Descarga Ollama
   - Descarga modelo IA (2GB)
   - Instala dependencias npm
7. **Configura** credenciales en .env.local
8. **Usa** PITHY desde iconos del escritorio

## Ventajas

Para TI (Desarrollador):
- Creas el .exe UNA SOLA VEZ
- Distribuyes por internet o USB
- Sin necesidad de estar presente
- Actualizaciones fáciles (crear nuevo .exe)

Para el CLIENTE:
- Instalación simple (doble clic)
- No necesita conocimientos técnicos
- Se ve profesional y confiable
- Todo automático

## Solución de Problemas

### Error: "Archivo no encontrado"
- Verifica que todos los archivos existan en E:\prueba
- Verifica que img\favicon.ico exista

### Error: "Compile aborted"
- Lee el mensaje de error específico
- Verifica sintaxis de setup.iss
- Verifica rutas de archivos

### Instalador muy grande (>200MB)
- Normal si node_modules ya está creado
- Elimina node_modules antes de compilar
- El script ya excluye node_modules

### Windows dice "Editor desconocido"
- Normal para software sin firma digital
- Click "Más información" > "Ejecutar de todas formas"
- Opcional: Comprar certificado code signing (~$100/año)

## Actualizar Versión

Para crear nueva versión:

1. Edita `setup.iss`:
   ```ini
   #define MyAppVersion "1.1"
   ```

2. Cambia nombre de salida:
   ```ini
   OutputBaseFilename=PITHY-Installer-v1.1
   ```

3. Recompila (F9)

## Personalización Adicional

### Cambiar colores del wizard:
- Edita `crear-imagenes.ps1`
- Cambia valores RGB
- Re-ejecuta el script
- Recompila instalador

### Agregar más mensajes:
- Edita sección `[Messages]` en setup.iss
- Agrega textos personalizados en español

### Cambiar URL de empresa:
- Edita `#define MyAppURL` en setup.iss

## Checklist Final

Antes de distribuir:

- [ ] Compilador sin errores
- [ ] .exe creado (50-80 MB)
- [ ] Probado en tu PC
- [ ] Iconos se crean correctamente
- [ ] PITHY inicia correctamente
- [ ] Panel admin funciona
- [ ] .env.local configurado como ejemplo
- [ ] Documentación para cliente lista

## Próximos Pasos

1. Compila el instalador (F9 en Inno Setup)
2. Prueba en tu PC
3. Sube a internet o copia a USB
4. Envía a tu primer cliente
5. Cobra por tu servicio profesional

---

**Creado por:** Ulmer Solier
**Proyecto:** Devlmer Project CL
**Versión:** 1.0 - Instalador Profesional
**Fecha:** Diciembre 2024
