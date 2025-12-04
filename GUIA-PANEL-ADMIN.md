# 🎛️ Panel de Administración PITHY - Guía Completa

## 📋 ¿Qué es el Panel de Administración?

El Panel de Administración es una interfaz web donde puedes:

✅ Ver todas las conversaciones de WhatsApp en tiempo real
✅ Responder manualmente a clientes
✅ Activar/desactivar el bot automático por conversación
✅ Ver estadísticas y métricas del chatbot
✅ Gestionar mensajes y usuarios

---

## 🚀 Cómo Acceder al Panel

### **Opción 1: Con el chatbot corriendo normalmente**
1. Ejecuta: `INICIAR-CHATBOT.bat`
2. Abre tu navegador en: **http://localhost:3000/admin**

### **Opción 2: Con servicio de Windows (recomendado)**
1. Instala como servicio (ver sección más abajo)
2. El panel estará disponible siempre en: **http://localhost:3000/admin**

---

## 📊 Funcionalidades del Panel

### **1. Dashboard Principal** (`/admin`)
- Estadísticas en tiempo real
- Total de conversaciones activas
- Mensajes del día
- Conversaciones en modo automático/manual
- Accesos rápidos a secciones

### **2. Bandeja de Mensajes** (`/admin/inbox`)
- Ver todas las conversaciones activas
- Historial completo de mensajes
- Responder manualmente a clientes
- **Toggle Bot Automático/Manual** por conversación
- Notificaciones de mensajes no leídos

### **3. Modo Bot vs Manual**

#### 🤖 **Modo Automático (Bot)**
- PITHY responde automáticamente
- Usa IA para generar respuestas
- Ideal para respuestas comunes

#### 👤 **Modo Manual (Humano)**
- Bot NO responde
- Tú respondes manualmente desde el panel
- Ideal para consultas complejas o ventas

#### 🔄 **Cómo cambiar de modo:**
1. Ve a `/admin/inbox`
2. Selecciona una conversación
3. Haz clic en el botón "🤖 Modo Automático" o "👤 Modo Manual"
4. El modo se cambia instantáneamente

---

## 🎯 Flujo de Trabajo Recomendado

### **Escenario 1: Atención Mixta**
1. Deja el bot en modo automático por defecto
2. Cuando llegue una consulta importante, cambia a manual
3. Responde personalmente desde el panel
4. Cuando termines, vuelve a activar el modo automático

### **Escenario 2: Solo Notificaciones**
1. Pon todas las conversaciones en modo manual
2. Revisa el panel periódicamente
3. Responde solo cuando sea necesario
4. Los clientes verán que el mensaje fue leído

### **Escenario 3: 24/7 Automático**
1. Deja todo en modo automático
2. Revisa el panel ocasionalmente
3. Solo interviene manualmente cuando sea crítico

---

## 🪟 Instalación como Servicio de Windows

Para que PITHY corra en segundo plano sin ventanas:

### **Paso 1: Detener servicios actuales**
```powershell
powershell -ExecutionPolicy Bypass -File detener-chatbot.ps1
```

### **Paso 2: Instalar como servicio (requiere Administrador)**
```powershell
# Clic derecho en PowerShell > Ejecutar como Administrador
cd E:\prueba
powershell -ExecutionPolicy Bypass -File install-service.ps1
```

### **Paso 3: Verificar instalación**
```powershell
Get-Service PITHY-*
```

Deberías ver:
- ✅ PITHY-Ollama (Running)
- ✅ PITHY-Server (Running)
- ✅ PITHY-Ngrok (Running)

### **Beneficios del servicio:**
✅ Se inicia automáticamente al prender la PC
✅ Corre en segundo plano (sin ventanas)
✅ Reinicio automático si falla
✅ Panel admin siempre disponible

---

## 🎮 Comandos Útiles

### **Ver estado de servicios:**
```powershell
Get-Service PITHY-* | Format-Table Name, Status, DisplayName
```

### **Detener servicios:**
```powershell
Stop-Service PITHY-*
```

### **Iniciar servicios:**
```powershell
Start-Service PITHY-Ollama,PITHY-Server,PITHY-Ngrok
```

### **Ver logs:**
```powershell
Get-Content E:\prueba\logs\*.log -Tail 50 -Wait
```

### **Desinstalar servicios:**
```powershell
powershell -ExecutionPolicy Bypass -File uninstall-service.ps1
```

---

## 📱 Ejemplo de Uso Real

### **Cliente pregunta sobre un producto:**

1. **Mensaje llega a WhatsApp**
   - Cliente: "Hola, ¿tienen disponible X producto?"

2. **Bot responde automáticamente (modo auto)**
   - PITHY: "Hola! Sí, contamos con ese producto. ¿Te gustaría conocer más detalles?"

3. **Cliente hace pregunta específica**
   - Cliente: "¿Cuál es el precio y tienen stock?"

4. **Tú intervienes manualmente:**
   - Entras al panel `/admin/inbox`
   - Cambias a modo manual (click en el botón)
   - Respondes: "El precio es $X y tenemos Y unidades disponibles"

5. **Cliente agradece**
   - Cliente: "Perfecto, gracias!"

6. **Vuelves a modo automático**
   - Click en el botón para activar el bot
   - PITHY continuará respondiendo automáticamente

---

## 🔧 Solución de Problemas

### **Panel no carga:**
1. Verifica que los servicios estén corriendo:
   ```powershell
   Get-Service PITHY-*
   ```
2. Revisa los logs:
   ```powershell
   Get-Content E:\prueba\logs\server-error.log -Tail 50
   ```

### **No aparecen conversaciones:**
1. Verifica que la base de datos existe: `E:\prueba\dev.db`
2. Envía un mensaje de prueba desde WhatsApp
3. Refresca el panel

### **Mensajes no se envían:**
1. Verifica conexión de WhatsApp API
2. Revisa credenciales en variables de entorno
3. Revisa logs de errores

---

## 🎨 Capturas de Funcionalidades

### **Dashboard:**
- Tarjetas con estadísticas
- Accesos rápidos
- Actualización cada 30 segundos

### **Bandeja de Mensajes:**
- Lista de conversaciones a la izquierda
- Chat completo a la derecha
- Toggle bot/manual en la parte superior
- Input para responder en la parte inferior

---

## 🌟 Características Avanzadas

### **Tiempo Real:**
- Dashboard se actualiza cada 30 segundos
- Conversaciones se actualizan cada 10 segundos
- Mensajes se actualizan cada 5 segundos

### **Notificaciones:**
- Badge "Nuevo" en conversaciones no leídas
- Contador de mensajes no leídos en dashboard

### **Filtros:**
- Ver solo modo manual: `/admin/inbox?mode=manual`
- Ver solo no leídos: `/admin/inbox?unread=true`

---

## 📞 Contacto y Soporte

Si tienes problemas o dudas:
1. Revisa los logs en `E:\prueba\logs\`
2. Verifica el estado de servicios con `Get-Service PITHY-*`
3. Consulta la documentación de WhatsApp Business API

---

## 🎉 ¡Listo!

Ahora tienes un Panel de Administración completo para gestionar tu chatbot PITHY.

**Accede al panel:** http://localhost:3000/admin

**¡Disfruta de la gestión profesional de tus conversaciones!** 🚀
