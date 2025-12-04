# 🚀 Configuración de JARVIS con Ollama (IA Gratuita)

## ¿Por qué Ollama?

**Ollama** te permite ejecutar modelos de IA de forma **100% local y gratuita** en tu computadora. No necesitas API keys ni pagas por uso.

### Ventajas de Ollama:
- ✅ **Completamente GRATIS** - Sin límites de uso
- ✅ **Privacidad total** - Los datos no salen de tu máquina
- ✅ **Sin internet** - Funciona offline
- ✅ **Rápido** - Respuestas en segundos
- ✅ **Múltiples modelos** - Llama, Mistral, Phi, Gemma, etc.

---

## 📥 Instalación de Ollama

### Windows:
1. Descarga el instalador desde: https://ollama.com/download
2. Ejecuta `OllamaSetup.exe`
3. Ollama se ejecutará automáticamente en segundo plano

### macOS:
```bash
brew install ollama
ollama serve
```

### Linux:
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama serve
```

---

## 🤖 Descargar Modelos

Una vez instalado Ollama, descarga un modelo de IA:

### Opción 1: Llama 3.2 (Recomendado - Rápido y eficiente)
```bash
ollama pull llama3.2
```

### Opción 2: Mistral (Muy bueno para español)
```bash
ollama pull mistral
```

### Opción 3: Phi-3 (El más ligero)
```bash
ollama pull phi3
```

### Opción 4: Qwen2.5 (Excelente para español)
```bash
ollama pull qwen2.5
```

**Tamaños aproximados:**
- `llama3.2` - ~2GB
- `mistral` - ~4GB
- `phi3` - ~2.3GB
- `qwen2.5` - ~4.7GB

---

## ⚙️ Configuración de JARVIS

### 1. Instalar dependencias del proyecto
```bash
npm install
```

### 2. Inicializar la base de datos
```bash
npx prisma generate
npx prisma migrate dev
```

### 3. Configurar variables de entorno

Ya está configurado en `.env.local`:
```env
OLLAMA_HOST=http://localhost:11434
```

### 4. Inicializar datos del sistema

Ejecuta esto para crear comandos y configuración inicial:

**Opción A: Desde el navegador**
```
POST http://localhost:3000/api/admin/seed
```

**Opción B: Con curl**
```bash
curl -X POST http://localhost:3000/api/admin/seed
```

---

## 🧪 Probar la Configuración

### 1. Verificar que Ollama esté corriendo
```bash
ollama list
```

Deberías ver tus modelos instalados.

### 2. Verificar el estado desde JARVIS

Visita:
```
GET http://localhost:3000/api/admin/ollama
```

Deberías ver algo como:
```json
{
  "success": true,
  "available": true,
  "models": ["llama3.2:latest"],
  "activeModel": "llama3.2"
}
```

### 3. Iniciar el servidor de desarrollo
```bash
npm run dev
```

Visita: http://localhost:3000

---

## 📱 Probar el Chatbot

1. **Envía un mensaje de WhatsApp** a tu número de bot (+56 9 6541 9765)

2. **JARVIS responderá** usando Ollama de forma automática con:
   - Respuestas inteligentes contextuales
   - Memoria de conversación
   - Análisis de intención y sentiment
   - Soporte de comandos (`/ayuda`, `/info`, etc.)

---

## 🎛️ Cambiar el Modelo de IA

Puedes cambiar el modelo en cualquier momento:

### Desde la base de datos:
```sql
UPDATE SystemConfig
SET value = 'mistral'
WHERE key = 'ai_model';
```

### O crear un endpoint de administración:
```bash
POST /api/admin/config
{
  "key": "ai_model",
  "value": "mistral"
}
```

---

## 🔍 Modelos Recomendados por Uso

### Para Español (mejor calidad):
- `qwen2.5` - Excelente comprensión del español
- `mistral` - Muy bueno también

### Para velocidad:
- `phi3` - El más rápido
- `llama3.2` - Balance perfecto

### Para creatividad:
- `llama3.1:8b` - Muy creativo
- `mistral` - Respuestas elaboradas

---

## 🐛 Solución de Problemas

### Error: "No puedo conectarme al servidor de Ollama"

**Solución:**
```bash
# Verifica si Ollama está corriendo
ollama list

# Si no está corriendo, inícialo
ollama serve
```

### Error: "No hay modelos instalados"

**Solución:**
```bash
ollama pull llama3.2
```

### Ollama está lento

**Solución:**
1. Usa un modelo más pequeño (`phi3`)
2. Cierra otras aplicaciones pesadas
3. Considera usar GPU si la tienes disponible

---

## 📊 Comparación de Modelos

| Modelo | Tamaño | Velocidad | Calidad Español | RAM Necesaria |
|--------|--------|-----------|-----------------|---------------|
| phi3 | 2.3GB | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | 4GB |
| llama3.2 | 2GB | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 4GB |
| mistral | 4GB | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 8GB |
| qwen2.5 | 4.7GB | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 8GB |

---

## 🎉 ¡Listo!

Ahora tienes un chatbot de WhatsApp con IA completamente **GRATIS** y **LOCAL**.

### Próximos pasos:
- ✅ Personaliza los comandos en la base de datos
- ✅ Ajusta el sistema de prompts en `src/lib/ai.ts`
- ✅ Crea nuevas funcionalidades
- ✅ Despliega en producción

---

## 📚 Recursos Adicionales

- **Ollama Docs**: https://ollama.com/docs
- **Modelos disponibles**: https://ollama.com/library
- **Ejemplos de prompts**: https://github.com/ollama/ollama/tree/main/examples

---

¿Necesitas ayuda? Contacta al equipo de desarrollo.