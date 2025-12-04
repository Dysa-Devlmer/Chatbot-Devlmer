# 📦 PITHY PORTABLE - Guía de Instalación

## 🎯 ¿Qué es PITHY Portable?

Es una versión **completamente portátil** del chatbot PITHY que puedes llevar a cualquier computadora y usar con **solo doble click**.

---

## 🚀 INSTALACIÓN EN EL LOCAL (Primera vez)

### **Paso 1: Preparar USB o copiar carpeta**

**Opción A - USB/Disco Externo:**
1. Copia la carpeta completa `E:\prueba` a tu USB
2. Lleva el USB al local

**Opción B - Carpeta comprimida:**
1. Comprime `E:\prueba` en un ZIP
2. Lleva el ZIP al local en USB o descárgalo

---

### **Paso 2: Ejecutar el instalador**

1. **Conecta el USB** o **descomprime el ZIP**
2. Abre la carpeta que copiaste
3. **Haz clic derecho** en `INSTALADOR-PORTABLE.ps1`
4. Selecciona "Ejecutar con PowerShell"

   > Si no aparece esa opción:
   > - Abre PowerShell
   > - Escribe: `cd "ruta\de\la\carpeta"`
   > - Escribe: `.\INSTALADOR-PORTABLE.ps1`

5. **Sigue las instrucciones** del instalador:
   - Te preguntará dónde instalar
   - Recomendado: `C:\PITHY` o `D:\PITHY`
   - El instalador copiará todo automáticamente
   - Creará iconos en el escritorio

---

### **Paso 3: ¡Listo para usar!**

El instalador creará **4 iconos** en el escritorio:

- 🚀 **INICIAR PITHY** → Inicia el chatbot
- 🛑 **DETENER PITHY** → Detiene el chatbot
- 🎛️ **PANEL ADMIN PITHY** → Abre el panel web
- 📁 **CARPETA PITHY** → Abre la carpeta de instalación

---

## 💡 USO DIARIO

### **Llegar al local por la mañana:**

1. **Doble click** en: 🚀 **INICIAR PITHY**
2. Espera **30 segundos**
3. **Doble click** en: 🎛️ **PANEL ADMIN PITHY**
4. ¡Listo! Ya puedes gestionar conversaciones

---

### **Cerrar al final del día:**

1. **Doble click** en: 🛑 **DETENER PITHY**
2. Espera que cierre
3. Apaga la computadora

---

## 🎮 FLUJO DE TRABAJO COMPLETO

```
┌─────────────────────────────────────────┐
│  MAÑANA - INICIAR                       │
└─────────────────────────────────────────┘
1. Encender PC
2. Doble click: 🚀 INICIAR PITHY
3. Esperar 30 segundos
4. Doble click: 🎛️ PANEL ADMIN PITHY
5. Trabajar normalmente

┌─────────────────────────────────────────┐
│  DURANTE EL DÍA - USAR                  │
└─────────────────────────────────────────┘
- El chatbot responde automáticamente
- Recibes notificaciones en el panel
- Puedes responder manualmente cuando quieras
- Toggle bot/manual según necesites

┌─────────────────────────────────────────┐
│  NOCHE - CERRAR                         │
└─────────────────────────────────────────┘
1. Doble click: 🛑 DETENER PITHY
2. Esperar que cierre
3. Cerrar navegador
4. Apagar PC
```

---

## 📋 REQUISITOS DEL LOCAL

Para que PITHY funcione en el local, **la PC debe tener:**

✅ **Windows 10 u 11**
✅ **Node.js instalado** (versión 18 o superior)
✅ **Ollama instalado** (para la IA)
✅ **Conexión a Internet** (para WhatsApp y ngrok)
✅ **4GB RAM mínimo** (recomendado 8GB)

---

## 🔧 INSTALACIÓN DE DEPENDENCIAS (Si no están)

Si la PC del local NO tiene Node.js u Ollama:

### **Instalar Node.js:**
1. Descarga: https://nodejs.org/
2. Ejecuta el instalador
3. Click en "Next" hasta terminar
4. Reinicia la PC

### **Instalar Ollama:**
1. Descarga: https://ollama.com/download
2. Ejecuta el instalador
3. Abre CMD y escribe: `ollama pull qwen2.5:3b`
4. Espera que descargue el modelo

---

## 💾 LLEVAR A OTRO LOCAL

Si quieres usar PITHY en **varios locales**:

### **Método 1: Reinstalar en cada PC**
1. Lleva el USB con la carpeta original
2. Ejecuta `INSTALADOR-PORTABLE.ps1` en cada PC
3. Cada PC tendrá su propia copia

### **Método 2: Copiar instalación existente**
1. Copia la carpeta `C:\PITHY` completa
2. Pégala en la otra PC en la misma ruta
3. Ejecuta `crear-atajos.ps1` para crear iconos
4. Listo

---

## 📊 BASE DE DATOS Y CONFIGURACIÓN

### **¿Qué pasa con las conversaciones?**

- La base de datos se guarda en: `C:\PITHY\dev.db`
- Cada PC tendrá sus propias conversaciones
- Si quieres compartir datos entre PCs, copia `dev.db`

### **¿Y las credenciales de WhatsApp?**

- Están en: `C:\PITHY\.env.local`
- Se copian automáticamente durante la instalación
- Todas las PCs usarán la misma cuenta de WhatsApp

---

## 🎯 VENTAJAS DE LA VERSIÓN PORTABLE

✅ **Plug & Play** - Doble click y funciona
✅ **Sin instalación compleja** - El instalador hace todo
✅ **Iconos en el escritorio** - Fácil de usar
✅ **Portátil** - Copia a USB y lleva a cualquier lado
✅ **Múltiples locales** - Instala en cuantas PCs quieras
✅ **Fácil de mantener** - Actualizas una vez y copias

---

## 🆘 SOLUCIÓN DE PROBLEMAS

### **"No encuentra Node.js"**
- Instala Node.js desde: https://nodejs.org/
- Reinicia la PC después de instalar

### **"No encuentra Ollama"**
- Instala Ollama desde: https://ollama.com/download
- Ejecuta: `ollama pull qwen2.5:3b`

### **"No se crean los iconos"**
- Ejecuta PowerShell como Administrador
- Vuelve a ejecutar el instalador

### **"El panel no abre"**
- Espera 30-40 segundos después de iniciar
- Verifica que los servicios estén corriendo
- Abre manualmente: http://localhost:3000/admin

---

## 📁 ESTRUCTURA DE ARCHIVOS

```
C:\PITHY\
├── 📂 app/              ← Código de la aplicación
├── 📂 prisma/           ← Base de datos
├── 📂 src/              ← Librerías
├── 📄 dev.db            ← Base de datos SQLite
├── 📄 .env.local        ← Credenciales
├── 📄 config-horarios.json ← Configuración de horarios
├── 🚀 INICIO-SIMPLE.bat ← Inicio rápido
├── 🛑 DETENER-SIMPLE.bat ← Detener rápido
└── 📄 *.ps1             ← Scripts de gestión
```

---

## 🎨 PERSONALIZACIÓN POR LOCAL

Si cada local tiene diferentes horarios o mensajes:

1. Abre: `C:\PITHY\config-horarios.json`
2. Edita los horarios de apertura/cierre
3. Edita los mensajes automáticos
4. Guarda y reinicia PITHY

---

## ✨ MEJORES PRÁCTICAS

### **Para uso profesional:**

1. **Instala en C:\PITHY** (siempre la misma ruta en todos los locales)
2. **Haz backup del .env.local** (guarda las credenciales)
3. **Haz backup del dev.db semanalmente** (guarda las conversaciones)
4. **Capacita al personal** en el uso del panel admin
5. **Deja instrucciones impresas** junto a la PC

---

## 📞 CHECKLIST DE INSTALACIÓN

Imprime esto y úsalo en cada local:

```
☐ 1. PC cumple requisitos (Windows 10/11, 4GB RAM)
☐ 2. Node.js instalado (node --version)
☐ 3. Ollama instalado (ollama --version)
☐ 4. Modelo descargado (ollama pull qwen2.5:3b)
☐ 5. Ejecutar INSTALADOR-PORTABLE.ps1
☐ 6. Verificar iconos en el escritorio
☐ 7. Probar inicio (doble click en 🚀 INICIAR PITHY)
☐ 8. Abrir panel (doble click en 🎛️ PANEL ADMIN)
☐ 9. Enviar mensaje de prueba por WhatsApp
☐ 10. Verificar que aparece en el panel
☐ 11. Probar respuesta manual
☐ 12. Probar toggle bot/manual
☐ 13. Cerrar correctamente (doble click en 🛑 DETENER)
```

---

## 🎉 ¡LISTO!

Ahora tienes un sistema completamente portable que puedes llevar a cualquier local y usar con **doble click**.

**¿Dudas?** Lee `GUIA-PANEL-ADMIN.md` para más detalles del panel de administración.

---

**Creado por:** Ulmer Solier
**Para:** Devlmer Project CL
**Chatbot:** PITHY
