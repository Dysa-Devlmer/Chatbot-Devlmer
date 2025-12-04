# 🎯 CÓMO CREAR EL INSTALADOR PROFESIONAL .EXE

## 📦 Lo que vas a crear:

Un instalador profesional `PITHY-Installer-v1.0.exe` que:
- ✅ Tiene interfaz gráfica moderna (como Photoshop, Chrome, etc.)
- ✅ Muestra barra de progreso
- ✅ Descarga e instala Node.js automáticamente
- ✅ Descarga e instala Ollama automáticamente
- ✅ Instala el modelo de IA
- ✅ Copia PITHY a la ubicación elegida
- ✅ Instala todas las dependencias (npm install)
- ✅ Crea iconos en el escritorio
- ✅ Se puede distribuir en internet o USB
- ✅ Tamaño: ~50MB (sin node_modules)

---

## 🛠️ OPCIÓN 1: Usar Inno Setup (RECOMENDADO)

### Paso 1: Descargar Inno Setup

1. Ve a: https://jrsoftware.org/isdl.php
2. Descarga **Inno Setup 6.x**
3. Instala con "Siguiente, Siguiente, Finalizar"

### Paso 2: Compilar el instalador

1. Abre **Inno Setup Compiler**
2. File > Open > Selecciona: `E:\prueba\setup.iss`
3. Build > Compile (o presiona F9)
4. Espera 1-2 minutos

¡Listo! El archivo `PITHY-Installer-v1.0.exe` se creará en `E:\prueba\`

### Paso 3: Probar el instalador

1. Doble clic en: `PITHY-Installer-v1.0.exe`
2. Sigue el asistente
3. Elige ubicación de instalación
4. Espera mientras instala todo (30-60 minutos primera vez)
5. ¡Listo!

---

## 🛠️ OPCIÓN 2: Usar NSIS (Alternativa)

### Paso 1: Descargar NSIS

1. Ve a: https://nsis.sourceforge.io/Download
2. Descarga **NSIS 3.x**
3. Instala

### Paso 2: Compilar

1. Abre **NSIS**
2. Compile NSI scripts
3. Selecciona: `E:\prueba\installer.nsi`
4. Espera

El archivo `PITHY-Installer.exe` se creará.

---

## 📤 DISTRIBUIR EL INSTALADOR

Una vez tengas el .exe, puedes:

### Opción A: USB
- Copia el .exe a un USB
- Lleva a cualquier restaurante
- Doble clic y listo

### Opción B: Internet
- Sube a Google Drive / Dropbox / tu servidor
- Envía el link al cliente
- Ellos descargan e instalan

### Opción C: Email
- Envía el .exe por email (si es <25MB)
- O comprime con WinRAR/7zip

---

## 🎨 PERSONALIZAR EL INSTALADOR

### Cambiar el icono:

1. Crea o descarga un archivo `icon.ico` (256x256)
2. Ponlo en `E:\prueba\icon.ico`
3. Recompila

### Cambiar imágenes del wizard:

1. `header.bmp` - Banner superior (164x314 px)
2. `wizard.bmp` - Imagen lateral (164x314 px)
3. Ponlos en `E:\prueba\`
4. Recompila

### Cambiar textos:

Edita `setup.iss` y busca las secciones:
- `[Messages]` - Mensajes en español
- `#define MyAppName` - Nombre de la app
- `#define MyAppVersion` - Versión

---

## 🚀 USO DEL INSTALADOR (Para el cliente)

### Cuando el cliente descarga el .exe:

1. **Doble clic** en `PITHY-Installer-v1.0.exe`

2. **Wizard de instalación** se abre:
   - Bienvenida
   - Licencia
   - Elegir ubicación (por defecto: C:\Program Files\PITHY)
   - Confirmar
   - INSTALAR

3. **Proceso automático** (30-60 minutos):
   ```
   ┌─────────────────────────────────────────┐
   │ Instalando PITHY Chatbot               │
   │                                         │
   │ ████████████████░░░░░░░░ 65%           │
   │                                         │
   │ Descargando Node.js...                 │
   │                                         │
   └─────────────────────────────────────────┘
   ```

4. **Mensaje final**:
   ```
   ✅ ¡Instalación completada!

   Próximos pasos:
   1. Configurar credenciales en .env.local
   2. Hacer doble clic en "INICIAR PITHY"
   3. Abrir "PANEL ADMIN PITHY"
   ```

5. **Iconos creados automáticamente**:
   - En el escritorio: 4 iconos
   - En el menú Inicio: Carpeta "PITHY Chatbot"

---

## 💡 VENTAJAS DE ESTE SISTEMA

### Para TI (desarrollador):
- ✅ Creas el .exe UNA SOLA VEZ
- ✅ Lo distribuyes por internet/USB
- ✅ No necesitas estar presente en la instalación
- ✅ Actualizaciones fáciles (solo cambias versión)

### Para el CLIENTE (restaurante):
- ✅ Descarga un solo archivo .exe
- ✅ Doble clic e instala TODO automáticamente
- ✅ No necesita conocimientos técnicos
- ✅ Interfaz profesional y moderna
- ✅ Se ve como software comercial real

---

## 📋 CHECKLIST FINAL

Antes de distribuir el instalador, verifica:

- [ ] El .exe se compiló correctamente
- [ ] Probaste el instalador en una PC limpia
- [ ] Node.js se instala automáticamente
- [ ] Ollama se instala automáticamente
- [ ] El modelo IA se descarga
- [ ] npm install se ejecuta
- [ ] Los iconos se crean
- [ ] PITHY inicia correctamente
- [ ] El panel admin abre
- [ ] Tamaño del .exe es razonable (<100MB)

---

## 🔧 SOLUCIÓN DE PROBLEMAS

### El compilador da error:
- Verifica que Inno Setup esté instalado
- Cierra todos los archivos de `E:\prueba`
- Reintenta compilar

### El .exe no descarga Node.js:
- Verifica conexión a Internet
- Ejecuta el .exe como Administrador
- Antivirus puede bloquearlo (agregar excepción)

### El .exe es muy grande (>200MB):
- Normal si incluye node_modules
- El script ya excluye node_modules
- Se descargan al instalar

---

## 🎉 RESULTADO FINAL

Tendrás un instalador profesional:

```
PITHY-Installer-v1.0.exe  (50-80 MB)
│
├─ Interfaz gráfica moderna
├─ Barra de progreso animada
├─ Instala Node.js automáticamente
├─ Instala Ollama automáticamente
├─ Descarga modelo IA
├─ Copia archivos a ubicación elegida
├─ Ejecuta npm install
├─ Crea iconos en escritorio
└─ Listo para usar
```

**Tiempo total de instalación:** 30-60 minutos (automático)
**Intervención del usuario:** Solo elegir ubicación y click "Instalar"

---

## 📞 PRÓXIMOS PASOS

1. **Descarga Inno Setup**: https://jrsoftware.org/isdl.php
2. **Compila el instalador**: Abre `setup.iss` y compila
3. **Prueba el .exe**: En una PC limpia o máquina virtual
4. **Distribuye**: USB, internet, email, etc.
5. **¡Listo!**: Ahora puedes instalar PITHY en cualquier restaurante de forma profesional

---

**Creado por:** Ulmer Solier
**Proyecto:** Devlmer Project CL
**Versión:** 1.0
