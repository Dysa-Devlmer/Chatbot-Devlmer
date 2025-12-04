# 🏪 GUÍA COMPLETA: Instalación de PITHY en un Local

## 📋 REQUISITOS DEL LOCAL

La PC del local DEBE tener:
- ✅ Windows 10 u 11
- ✅ 8GB RAM (mínimo 4GB)
- ✅ 10GB de espacio en disco
- ✅ Conexión a Internet

---

## 🎯 PROCESO COMPLETO (3 PASOS)

```
┌─────────────────────────────────────┐
│ PASO 1: Instalar Software Base     │
│ (Solo la primera vez)               │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ PASO 2: Instalar PITHY              │
│ (Copiar e instalar el chatbot)      │
└─────────────────────────────────────┘
        ↓
┌─────────────────────────────────────┐
│ PASO 3: Configurar y Probar         │
│ (Asegurar que todo funcione)        │
└─────────────────────────────────────┘
```

---

## 📦 PASO 1: INSTALAR SOFTWARE BASE

### **1.1 - Instalar Node.js**

**¿Qué es?** Motor de JavaScript para ejecutar el chatbot

**Cómo instalar:**
1. Ve a: https://nodejs.org/
2. Descarga "LTS (Recomendado)" - versión 20.x o superior
3. Ejecuta el instalador
4. Click en "Next, Next, Next..." hasta "Install"
5. **IMPORTANTE:** Marca la opción "Automatically install necessary tools"
6. Espera que termine (5-10 minutos)
7. Reinicia la PC

**Verificar instalación:**
```powershell
# Abre PowerShell y ejecuta:
node --version
# Debe mostrar: v20.x.x o superior

npm --version
# Debe mostrar: 10.x.x o superior
```

✅ **Listo:** Node.js instalado

---

### **1.2 - Instalar Ollama**

**¿Qué es?** Motor de IA local para las respuestas del chatbot

**Cómo instalar:**
1. Ve a: https://ollama.com/download/windows
2. Descarga "Download for Windows"
3. Ejecuta el instalador OllamaSetup.exe
4. Click en "Install"
5. Espera que termine (2-3 minutos)

**Descargar modelo de IA:**
```powershell
# Abre PowerShell y ejecuta:
ollama pull qwen2.5:3b

# Espera 5-10 minutos (descarga ~2GB)
# Verás: pulling manifest, downloading...
```

**Verificar instalación:**
```powershell
ollama --version
# Debe mostrar: ollama version x.x.x

ollama list
# Debe mostrar: qwen2.5:3b
```

✅ **Listo:** Ollama instalado

---

### **1.3 - Verificar que todo esté instalado**

```powershell
# Ejecuta estos 3 comandos:
node --version    # ✅ Debe mostrar versión
npm --version     # ✅ Debe mostrar versión
ollama --version  # ✅ Debe mostrar versión
```

Si los 3 comandos funcionan: **¡Perfecto! Sigue al PASO 2**

---

## 🚀 PASO 2: INSTALAR PITHY

### **2.1 - Copiar archivos al local**

**Opción A - Con USB:**
```
1. Conecta el USB con la carpeta "prueba"
2. Copia toda la carpeta al escritorio
3. Espera que termine (puede tardar 5-10 min)
```

**Opción B - Con archivo ZIP:**
```
1. Copia el archivo PITHY.zip al local
2. Haz clic derecho > "Extraer aquí"
3. Espera que termine
```

---

### **2.2 - Ejecutar el Instalador**

```
1. Abre la carpeta copiada/extraída
2. Busca el archivo: INSTALADOR-PORTABLE.ps1
3. Haz clic derecho > "Ejecutar con PowerShell"

   Si no aparece esa opción:
   - Abre PowerShell
   - Arrastra el archivo INSTALADOR-PORTABLE.ps1 a la ventana
   - Presiona Enter

4. Sigue el asistente:
   ┌────────────────────────────────────┐
   │ ¿Dónde deseas instalar PITHY?      │
   │ 1. C:\PITHY  ← RECOMENDADO         │
   │ 2. D:\PITHY                        │
   │ 3. Escritorio                      │
   │ 4. Ruta personalizada              │
   └────────────────────────────────────┘

   Escribe: 1
   Presiona Enter

5. ¿Continuar? Escribe: S

6. Espera 2-5 minutos mientras copia todo

7. Verás:
   ✓ Archivos copiados
   ✓ Rutas actualizadas
   ✓ Accesos directos creados
```

✅ **Listo:** PITHY instalado en C:\PITHY

---

### **2.3 - Instalar dependencias de Node**

El instalador NO copia node_modules (muy pesado).
Debes instalarlos:

```powershell
# 1. Abre PowerShell

# 2. Ve a la carpeta de PITHY
cd C:\PITHY

# 3. Instala dependencias
npm install

# Espera 5-15 minutos
# Verás: Installing dependencies...
# Aparecerán muchas líneas de texto
```

**Importante:**
- No cierres la ventana mientras instala
- Puede tardar bastante la primera vez
- Es normal ver algunas advertencias (warnings)

✅ **Listo:** Dependencias instaladas

---

## ✅ PASO 3: CONFIGURAR Y PROBAR

### **3.1 - Verificar los iconos del escritorio**

Deberías ver 4 iconos:
```
📍 ESCRITORIO:
├── INICIAR PITHY      (con icono de cohete)
├── DETENER PITHY      (con icono de stop)
├── PANEL ADMIN PITHY  (con icono de navegador)
└── CARPETA PITHY      (con icono de carpeta)
```

Si NO ves los iconos:
```powershell
cd C:\PITHY
.\crear-atajos-escritorio.ps1
```

---

### **3.2 - Configurar credenciales de WhatsApp**

```
1. Abre: C:\PITHY\.env.local con Notepad

2. Verifica que tenga tus credenciales:
   WHATSAPP_TOKEN=tu_token_aqui
   WHATSAPP_PHONE_NUMBER_ID=tu_phone_id
   WHATSAPP_WEBHOOK_TOKEN=tu_webhook_token

3. Si están vacías o incorrectas, cópialas desde
   tu cuenta de Meta Business
```

---

### **3.3 - Probar el sistema**

#### **Primera prueba:**
```
1. Doble click en: INICIAR PITHY
2. Verás 3 ventanas que se abren y minimizan
3. Espera 30-40 segundos
4. Doble click en: PANEL ADMIN PITHY
5. Debe abrir el navegador en: http://localhost:3000/admin
```

#### **Segunda prueba:**
```
1. Envía un mensaje de WhatsApp al número del bot
2. Refresca el panel admin
3. Debe aparecer la conversación
4. Intenta responder manualmente
5. Cambia el toggle bot/manual
```

#### **Tercera prueba:**
```
1. Doble click en: DETENER PITHY
2. Espera 5 segundos
3. Verifica que las ventanas se cierren
4. Vuelve a iniciar con INICIAR PITHY
```

---

## 🎉 ¡INSTALACIÓN COMPLETADA!

Si todo funcionó:
- ✅ El chatbot inicia correctamente
- ✅ El panel admin abre
- ✅ Los mensajes llegan
- ✅ Puedes responder manualmente

---

## 📋 RESUMEN - CHECKLIST COMPLETO

### **Software Base (Solo primera vez)**
```
☐ Instalar Node.js (https://nodejs.org/)
☐ Verificar: node --version
☐ Instalar Ollama (https://ollama.com/download)
☐ Descargar modelo: ollama pull qwen2.5:3b
☐ Verificar: ollama --version
```

### **PITHY (En cada local)**
```
☐ Copiar carpeta al local (USB/ZIP)
☐ Ejecutar INSTALADOR-PORTABLE.ps1
☐ Elegir ubicación: C:\PITHY
☐ Esperar que copie todo
☐ Ejecutar: cd C:\PITHY && npm install
☐ Esperar instalación de dependencias
☐ Verificar iconos en escritorio
☐ Configurar .env.local con credenciales
```

### **Pruebas**
```
☐ Doble click: INICIAR PITHY
☐ Esperar 30 segundos
☐ Doble click: PANEL ADMIN PITHY
☐ Enviar mensaje de prueba por WhatsApp
☐ Verificar que aparece en el panel
☐ Probar respuesta manual
☐ Probar toggle bot/manual
☐ Doble click: DETENER PITHY
```

---

## ⏱️ TIEMPO ESTIMADO

**Primera instalación completa:**
- Instalar Node.js: 10 minutos
- Instalar Ollama: 15 minutos (con modelo)
- Instalar PITHY: 5 minutos
- Instalar dependencias: 15 minutos
- Configurar y probar: 10 minutos

**Total: ~1 hora**

**Siguientes instalaciones (otros locales):**
- Ya tienes Node.js y Ollama: 0 minutos
- Instalar PITHY: 5 minutos
- Instalar dependencias: 15 minutos
- Configurar: 5 minutos

**Total: ~25 minutos**

---

## 🆘 PROBLEMAS COMUNES

### **"npm no se reconoce como comando"**
- Solución: Reinicia la PC después de instalar Node.js

### **"ollama no se reconoce como comando"**
- Solución: Reinicia la PC después de instalar Ollama

### **"Error al instalar dependencias"**
- Solución: Ejecuta como Administrador:
  ```powershell
  cd C:\PITHY
  npm install --force
  ```

### **"El panel no abre"**
- Solución: Espera 40-50 segundos después de iniciar
- Verifica: http://localhost:3000/admin

### **"No aparecen conversaciones"**
- Solución: Envía un mensaje de prueba por WhatsApp
- Verifica credenciales en .env.local

---

## 💾 MANTENER ACTUALIZADO

**Para actualizar PITHY en el futuro:**
```
1. Recibe la nueva versión en USB/ZIP
2. Detén PITHY: DETENER PITHY
3. Haz backup de:
   - C:\PITHY\.env.local (credenciales)
   - C:\PITHY\dev.db (conversaciones)
4. Ejecuta el instalador de nuevo
5. Restaura .env.local y dev.db
6. Ejecuta: npm install
7. Inicia PITHY
```

---

**¿Dudas?** Consulta:
- GUIA-PANEL-ADMIN.md - Uso del panel
- LEEME-SIMPLE.txt - Instrucciones rápidas

---

**Creado por:** Ulmer Solier
**Para:** Devlmer Project CL
**Chatbot:** PITHY
**Versión:** 1.0 Portable
