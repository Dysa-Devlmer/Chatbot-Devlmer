# 🤖 Cómo mantener JARVIS funcionando 24/7

Tienes 3 opciones para mantener tu chatbot activo todo el tiempo:

---

## 📌 OPCIÓN 1: Servicios de Windows (EN TU PC)

### ✅ Ventajas:
- Gratis (usa Ollama local)
- Inicia automáticamente al encender tu PC
- No necesitas ejecutar comandos manualmente

### ❌ Desventajas:
- Tu PC debe estar encendida 24/7
- Consume electricidad (~$10-20/mes dependiendo de tu PC y tarifa eléctrica)
- Si se va la luz o apagas la PC, el bot se detiene

### 📝 Instalación:

1. **Abre PowerShell como Administrador**
   - Busca "PowerShell" en el menú de inicio
   - Clic derecho > "Ejecutar como Administrador"

2. **Ejecuta el instalador:**
   ```powershell
   cd E:\prueba
   powershell -ExecutionPolicy Bypass -File install-service.ps1
   ```

3. **¡Listo!** Los servicios se instalan y configuran:
   - `JARVIS-Ollama` - Servidor de IA
   - `JARVIS-Server` - Servidor Next.js
   - `JARVIS-Ngrok` - Túnel público

4. **Obtén la URL del webhook:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File get-url.ps1
   ```

5. **Actualiza el webhook en Meta Business Settings** con la nueva URL

### 🔧 Comandos útiles:

```powershell
# Ver estado de servicios
Get-Service JARVIS-*

# Detener todos los servicios
Stop-Service JARVIS-*

# Iniciar servicios manualmente
Start-Service JARVIS-Ollama
Start-Service JARVIS-Server
Start-Service JARVIS-Ngrok

# Ver logs
Get-Content E:\prueba\logs\*.log -Tail 50

# Desinstalar servicios
powershell -ExecutionPolicy Bypass -File uninstall-service.ps1
```

---

## 📌 OPCIÓN 2: VPS con Ollama (RECOMENDADO)

### ✅ Ventajas:
- Funciona 24/7 sin importar si tu PC está apagada
- Usa Ollama (IA gratis)
- IP pública fija (no necesitas ngrok)
- Bajo consumo eléctrico

### ❌ Desventajas:
- Costo mensual: €4-6/mes
- Requiere conocimientos básicos de Linux

### 🏢 Proveedores recomendados:

1. **Hetzner** (Alemania) - €4.15/mes
   - 2 vCPU, 4 GB RAM, 40 GB SSD
   - https://www.hetzner.com/cloud

2. **Contabo** (Alemania) - €4.99/mes
   - 4 vCPU, 6 GB RAM, 200 GB SSD
   - https://contabo.com/en/vps/

3. **DigitalOcean** (USA) - $6/mes
   - 1 vCPU, 1 GB RAM, 25 GB SSD
   - https://www.digitalocean.com/

### 📝 Pasos para desplegar:

1. **Contratar un VPS** (Ubuntu 22.04 o 24.04)

2. **Conectarte por SSH:**
   ```bash
   ssh root@tu-ip-del-vps
   ```

3. **Instalar dependencias:**
   ```bash
   # Actualizar sistema
   apt update && apt upgrade -y

   # Instalar Node.js 20
   curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
   apt install -y nodejs

   # Instalar Ollama
   curl -fsSL https://ollama.com/install.sh | sh

   # Instalar Git
   apt install -y git

   # Instalar PM2 (gestor de procesos)
   npm install -g pm2
   ```

4. **Subir tu código al VPS:**
   ```bash
   # En tu PC, sube el código a GitHub primero
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/tu-usuario/tu-repo.git
   git push -u origin master

   # En el VPS, clona el repositorio
   cd /var/www
   git clone https://github.com/tu-usuario/tu-repo.git chatbot
   cd chatbot
   ```

5. **Configurar el proyecto:**
   ```bash
   # Instalar dependencias
   npm install

   # Copiar variables de entorno
   nano .env.local
   # Pega el contenido de tu .env.local local

   # Inicializar base de datos
   npx prisma generate
   npx prisma migrate deploy
   node init-db.mjs

   # Descargar modelo de Ollama
   ollama pull mistral
   ```

6. **Iniciar servicios con PM2:**
   ```bash
   # Iniciar Ollama
   pm2 start ollama --name ollama-serve -- serve

   # Compilar Next.js para producción
   npm run build

   # Iniciar servidor Next.js
   pm2 start npm --name chatbot -- start

   # Guardar configuración de PM2
   pm2 save
   pm2 startup
   ```

7. **Configurar Nginx como proxy inverso:**
   ```bash
   apt install -y nginx

   # Crear configuración
   nano /etc/nginx/sites-available/chatbot
   ```

   Pega esto:
   ```nginx
   server {
       listen 80;
       server_name tu-dominio.com;  # O tu IP

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

   Activar:
   ```bash
   ln -s /etc/nginx/sites-available/chatbot /etc/nginx/sites-enabled/
   nginx -t
   systemctl restart nginx
   ```

8. **Configurar webhook en Meta:**
   - URL: `http://tu-ip-del-vps/api/whatsapp/webhook`
   - Token: `mi_token_secreto_123`

---

## 📌 OPCIÓN 3: Servicios Cloud con API de IA

### ✅ Ventajas:
- Despliegue muy fácil
- Funciona 24/7
- Planes gratuitos disponibles

### ❌ Desventajas:
- NO puedes usar Ollama (necesitas API de pago)
- Costos por uso de IA:
  - Claude: ~$0.003 por mensaje
  - GPT-4: ~$0.006 por mensaje

### 🏢 Plataformas recomendadas:

**Railway.app** (Gratis con límites)
1. Conecta tu GitHub
2. Despliega automáticamente
3. PostgreSQL incluido
4. $5/mes si excedes límite gratuito

**Render.com** (Gratis con límites)
1. Similar a Railway
2. Suspende después de 15 min de inactividad (plan gratuito)
3. $7/mes para mantener activo

### 📝 Cambios necesarios:

Modificar `.env.local`:
```env
# Comentar Ollama
# OLLAMA_HOST=http://localhost:11434

# Agregar API de Claude o OpenAI
ANTHROPIC_API_KEY=tu-api-key-aqui
# O
OPENAI_API_KEY=tu-openai-key-aqui
```

---

## 🎯 RECOMENDACIÓN

**Para desarrollo/pruebas:**
- Usa **Opción 1** (Servicios de Windows) si tu PC puede estar encendida

**Para producción:**
- Usa **Opción 2** (VPS con Ollama) si quieres mantener IA gratis
- Usa **Opción 3** (Railway/Render) si prefieres simplicidad y no te importa pagar por IA

---

## ⚡ Consumo eléctrico estimado (Opción 1)

Si dejas tu PC encendida 24/7:

- PC de escritorio promedio: 100-200W
- 24 horas × 30 días = 720 horas/mes
- 150W × 720h = 108 kWh/mes
- Costo: ~$10-20/mes (dependiendo de tarifa eléctrica)

**¿Vale la pena?**
- Si tienes un VPS a €4/mes, es más barato que dejar tu PC encendida
- Pero si tu PC ya está encendida 24/7 por otros motivos, usa la Opción 1

---

## 📞 Soporte

Si tienes dudas sobre cuál opción elegir o cómo implementarla, avísame.
