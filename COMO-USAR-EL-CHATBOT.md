# 📱 Cómo usar el chatbot PITHY - Devlmer Project CL

## 🚀 Iniciar el chatbot (TODO DE UNA VEZ)

### Opción 1: Doble clic (MÁS FÁCIL)
1. Haz doble clic en: **`iniciar-chatbot.ps1`**
2. Si aparece un aviso de seguridad, dale a "Ejecutar de todos modos"
3. Espera 20 segundos
4. ¡Listo! Se abrirán 3 ventanas:
   - 🤖 Ollama AI
   - ⚡ Servidor Next.js
   - 🌐 Túnel ngrok

### Opción 2: Desde PowerShell
```powershell
cd E:\prueba
powershell -ExecutionPolicy Bypass -File iniciar-chatbot.ps1
```

### ✅ ¿Cómo sé que está funcionando?
- Verás 3 ventanas de PowerShell abiertas
- En la última ventana verás la URL del webhook
- El chatbot ya está recibiendo mensajes

---

## 🛑 Cerrar el chatbot (al final del día)

### Opción 1: Doble clic
1. Haz doble clic en: **`detener-chatbot.ps1`**
2. Espera 3 segundos
3. ¡Listo! Todas las ventanas se cerrarán automáticamente

### Opción 2: Desde PowerShell
```powershell
cd E:\prueba
powershell -ExecutionPolicy Bypass -File detener-chatbot.ps1
```

### ⚠️ ¿Qué pasa cuando cierro?
- El chatbot responderá automáticamente: **"Estamos cerrados en este momento"**
- Los mensajes quedarán guardados para cuando vuelvas a abrir
- No se perderá ningún mensaje

---

## ⏰ Configurar horarios automáticos

### Editar horarios de atención

1. Abre el archivo: **`config-horarios.json`** (con Bloc de notas)

2. Cambia los horarios según tu negocio:

```json
{
  "horarios": {
    "habilitado": true,  👈 Cambiar a true para activar
    "dias_semana": {
      "lunes": {
        "abierto": true,
        "apertura": "09:00",  👈 Hora de apertura
        "cierre": "18:00"     👈 Hora de cierre
      },
      "martes": { "abierto": true, "apertura": "09:00", "cierre": "18:00" },
      "miercoles": { "abierto": true, "apertura": "09:00", "cierre": "18:00" },
      "jueves": { "abierto": true, "apertura": "09:00", "cierre": "18:00" },
      "viernes": { "abierto": true, "apertura": "09:00", "cierre": "18:00" },
      "sabado": { "abierto": true, "apertura": "10:00", "cierre": "14:00" },
      "domingo": { "abierto": false }  👈 Cerrado los domingos
    }
  }
}
```

3. Personaliza los mensajes:

```json
{
  "mensajes": {
    "fuera_de_horario": "🕐 **Estamos cerrados**\n\nNuestro horario:\nLunes a Viernes: 9:00 AM - 6:00 PM\n\n¡Gracias!"
  }
}
```

4. **Guarda el archivo** y el chatbot usará los nuevos horarios automáticamente

---

## 📊 Ver estadísticas y mensajes

### Ver mensajes recibidos
```powershell
# Ver últimos 50 mensajes en los logs
Get-Content logs\*.log -Tail 50
```

### Ver base de datos
1. Descarga: https://sqlitebrowser.org/
2. Abre: `E:\prueba\prisma\dev.db`
3. Explora tablas: `User`, `Message`, `Conversation`

---

## 🔧 Problemas comunes

### "No responde el chatbot"
**Solución:**
```powershell
# 1. Detener todo
powershell -ExecutionPolicy Bypass -File detener-chatbot.ps1

# 2. Esperar 5 segundos

# 3. Volver a iniciar
powershell -ExecutionPolicy Bypass -File iniciar-chatbot.ps1
```

### "Cambió la URL del webhook"
**Solución:**
```powershell
# Obtener nueva URL
powershell -ExecutionPolicy Bypass -File get-url.ps1

# Luego actualizar en Meta Business Settings
```

### "Ollama no arranca"
**Solución:**
```powershell
# Verificar que Ollama esté instalado
ollama --version

# Si no está, reinstalar desde: https://ollama.com
```

### "Error de base de datos"
**Solución:**
```powershell
# Regenerar base de datos
npx prisma generate
npx prisma migrate deploy
node init-db.mjs
```

---

## 💡 Consejos

### Recomendación para uso diario:

1. **Al abrir tu local:**
   - Doble clic en `iniciar-chatbot.ps1`
   - Espera 30 segundos
   - Minimiza las ventanas (NO cerrarlas)

2. **Durante el día:**
   - Deja las ventanas minimizadas
   - El chatbot funciona automáticamente

3. **Al cerrar tu local:**
   - Doble clic en `detener-chatbot.ps1`
   - Apaga tu PC si quieres

### Para uso 24/7 automático:

Si quieres que funcione siempre sin abrir/cerrar manualmente:
```powershell
# Como Administrador, ejecuta:
powershell -ExecutionPolicy Bypass -File install-service.ps1
```

Esto instalará servicios de Windows que inician automáticamente con tu PC.

---

## 📞 Comandos disponibles para clientes

Los clientes pueden enviar estos comandos:

- `/ayuda` - Ver comandos disponibles
- `/info` - Información del bot
- `/contacto` - Información de contacto
- `/hora` - Hora actual

Puedes agregar más comandos editando la base de datos o usando el panel admin.

---

## 🎨 Personalizar respuestas de la IA

La IA usa modelos de Ollama (llama3.2, mistral, etc.). El asistente se llama **PITHY** y está configurado para:

- Nombre: **PITHY**
- Empresa: **Devlmer Project CL**
- Especialidad: Desarrollo de software y soluciones tecnológicas
- Restricción: Solo responde sobre temas relacionados con la empresa

**Archivo de configuración:** `src/lib/ai.ts`

PITHY solo responderá preguntas sobre:
- Servicios de Devlmer Project CL
- Desarrollo de software
- Chatbots con IA
- Automatización y APIs
- Consultas comerciales

Si un cliente pregunta sobre temas no relacionados, PITHY redirigirá la conversación a los servicios de la empresa.

Después de editar, reinicia con `detener-chatbot.ps1` y `iniciar-chatbot.ps1`

---

## 🔐 Seguridad

### Datos importantes a proteger:

1. **`.env.local`** - Contiene credenciales de WhatsApp
   - NO subir a GitHub
   - NO compartir el token

2. **`config-horarios.json`** - Puedes compartirlo
3. **`prisma/dev.db`** - Contiene mensajes de clientes (privado)

---

## ✅ Lista de verificación diaria

- [ ] Abrir `iniciar-chatbot.ps1` al comenzar el día
- [ ] Verificar que las 3 ventanas estén abiertas
- [ ] Probar enviando un mensaje de prueba
- [ ] Al finalizar, ejecutar `detener-chatbot.ps1`

---

¿Necesitas ayuda? Revisa los logs en `E:\prueba\logs\` o contacta soporte.
