# 🎯 INSTALADORES DISPONIBLES - ELIGE EL MEJOR PARA TI

PITHY tiene **2 tipos de instaladores**. Aquí te explico cuál usar:

---

## 🚀 **OPCIÓN 1: INSTALADOR AUTOMÁTICO TODO-EN-UNO** ⭐ RECOMENDADO

**Archivo:** `INSTALADOR-AUTOMATICO-COMPLETO.ps1`

### ✅ **Ventajas:**
- **UN SOLO DOBLE CLICK** - Como Photoshop, Chrome, etc.
- Detecta e instala Node.js automáticamente
- Detecta e instala Ollama automáticamente
- Descarga el modelo de IA automáticamente
- Instala PITHY completo
- Instala todas las dependencias
- Crea los iconos
- **Todo automático, sin intervención**

### ⏱️ **Tiempo:**
- Primera instalación: ~45-60 minutos
- (Incluye descargas de internet)

### 📡 **Requisitos:**
- ✅ Conexión a Internet
- ✅ Permisos de Administrador (para instalar Node.js/Ollama)
- ✅ 10GB de espacio libre

### 🎯 **Cuándo usarlo:**
- ✅ PC nueva sin nada instalado
- ✅ Quieres la experiencia "doble click y listo"
- ✅ Tienes Internet en el local
- ✅ No quieres complicarte

### 📝 **Cómo usarlo:**
```powershell
1. Copia la carpeta completa al local
2. Haz clic derecho en: INSTALADOR-AUTOMATICO-COMPLETO.ps1
3. "Ejecutar con PowerShell"
4. Confirma: S
5. Espera (puede tardar 45-60 minutos)
6. ¡Listo!
```

---

## 🔧 **OPCIÓN 2: INSTALADOR PORTABLE (Manual)**

**Archivo:** `INSTALADOR-PORTABLE.ps1`

### ✅ **Ventajas:**
- Más control sobre el proceso
- No necesita permisos de Administrador
- Puedes instalar Node.js/Ollama cuando quieras
- Funciona sin Internet (si ya tienes Node.js/Ollama)

### ⏱️ **Tiempo:**
- ~25 minutos (si Node.js/Ollama ya están)
- ~60 minutos (si hay que instalar todo manualmente)

### 📡 **Requisitos:**
- ❗ Node.js **ya instalado**
- ❗ Ollama **ya instalado**
- ❗ Modelo IA **ya descargado**

### 🎯 **Cuándo usarlo:**
- ✅ Ya tienes Node.js y Ollama instalados
- ✅ Quieres controlar cada paso
- ✅ No tienes Internet (todo pre-instalado)
- ✅ Instalación en múltiples PCs (instala Node.js una vez, luego usa este)

### 📝 **Cómo usarlo:**
```powershell
# Primero (solo una vez):
1. Instalar Node.js manualmente
2. Instalar Ollama manualmente
3. Descargar modelo: ollama pull qwen2.5:3b

# Luego (en cada local):
1. Copia la carpeta al local
2. Ejecuta: INSTALADOR-PORTABLE.ps1
3. Elige ubicación
4. Ejecuta: cd C:\PITHY && npm install
5. ¡Listo!
```

---

## 📊 **COMPARACIÓN RÁPIDA**

| Característica | Automático TODO-EN-UNO ⭐ | Portable Manual |
|---|---|---|
| **Doble click y listo** | ✅ SÍ | ❌ NO (varios pasos) |
| **Instala Node.js** | ✅ Automático | ❌ Manual |
| **Instala Ollama** | ✅ Automático | ❌ Manual |
| **Descarga modelo IA** | ✅ Automático | ❌ Manual |
| **Instala dependencias** | ✅ Automático | ❌ Manual (npm install) |
| **Necesita Internet** | ✅ Sí | ⚠️ Depende |
| **Necesita Admin** | ✅ Sí | ❌ No |
| **Tiempo total** | ~45-60 min | ~25-60 min |
| **Complejidad** | 🟢 Fácil | 🟡 Media |
| **Como Photoshop/Chrome** | ✅ SÍ | ❌ NO |

---

## 🎯 **RECOMENDACIÓN**

### **Para la mayoría de casos:**
```
✅ USA: INSTALADOR-AUTOMATICO-COMPLETO.ps1

Es como instalar Photoshop o Chrome:
- Doble click
- Esperas
- ¡Listo!
```

### **Para casos especiales:**
```
⚠️ USA: INSTALADOR-PORTABLE.ps1

Solo si:
- Ya tienes Node.js y Ollama
- No tienes permisos de Administrador
- No tienes Internet
- Quieres más control
```

---

## 📋 **GUÍA RÁPIDA: INSTALADOR TODO-EN-UNO**

### **PASO 1: Preparar**
```
1. Copia toda la carpeta E:\prueba a un USB
   o comprímela en un archivo ZIP
```

### **PASO 2: En el local**
```
1. Copia/descomprime la carpeta
2. Haz clic derecho en: INSTALADOR-AUTOMATICO-COMPLETO.ps1
3. Selecciona: "Ejecutar con PowerShell"

   Si no aparece:
   - Clic derecho > "Ejecutar como Administrador" en PowerShell
   - Arrastra el archivo a la ventana
   - Presiona Enter
```

### **PASO 3: Durante la instalación**
```
El instalador hará TODO solo:

├─ ⏳ Detectando Node.js...
│  └─ No instalado → Descargando e instalando
├─ ⏳ Detectando Ollama...
│  └─ No instalado → Descargando e instalando
├─ ⏳ Descargando modelo IA (2GB)...
├─ ⏳ Copiando archivos de PITHY...
├─ ⏳ Instalando dependencias (npm install)...
└─ ✅ Creando iconos en escritorio

Total: ~45-60 minutos
```

### **PASO 4: Al terminar**
```
✅ Verás 4 iconos en el escritorio:
   - INICIAR PITHY
   - DETENER PITHY
   - PANEL ADMIN PITHY
   - CARPETA PITHY

✅ Configura credenciales en: C:\PITHY\.env.local

✅ Doble click en INICIAR PITHY

✅ ¡Listo para usar!
```

---

## ⚠️ **IMPORTANTE**

### **Primera vez en una PC:**
```
✅ Usa: INSTALADOR-AUTOMATICO-COMPLETO.ps1
   → Instala TODO de cero
```

### **Segunda PC (ya tienes Node.js/Ollama):**
```
✅ Puedes usar cualquiera:
   → Automático: más rápido (detecta que ya está)
   → Portable: solo copia PITHY
```

### **Tercera, cuarta, quinta PC...**
```
✅ Usa: INSTALADOR-PORTABLE.ps1
   → Más rápido (25 minutos)
   → Node.js/Ollama ya están en todas
```

---

## 🎉 **RESUMEN**

**¿Quieres la experiencia Photoshop/Chrome?**
```
→ INSTALADOR-AUTOMATICO-COMPLETO.ps1
  Un doble click, esperas 45 min, listo
```

**¿Ya tienes todo instalado y solo necesitas PITHY?**
```
→ INSTALADOR-PORTABLE.ps1
  Más rápido, solo copia PITHY
```

**¿PC nueva sin nada?**
```
→ INSTALADOR-AUTOMATICO-COMPLETO.ps1
  Te ahorra todos los pasos manuales
```

---

## 📚 **DOCUMENTACIÓN ADICIONAL**

- `INSTALACION-COMPLETA-LOCAL.md` - Guía paso a paso detallada
- `CHECKLIST-INSTALACION.txt` - Lista imprimible
- `GUIA-PANEL-ADMIN.md` - Cómo usar el panel
- `LEEME-SIMPLE.txt` - Instrucciones rápidas

---

**Creado por:** Ulmer Solier
**Para:** Devlmer Project CL
**Chatbot:** PITHY
**Versión:** 1.0 - Instalador TODO-EN-UNO

---

## 🚀 **¡Ahora SÍ es como Photoshop/Chrome!**

**Un doble click y TODO se instala automáticamente** ✨
