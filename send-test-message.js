// Script para enviar un mensaje de prueba a tu WhatsApp
const fs = require('fs');
const path = require('path');

// Leer .env.local
function loadEnv() {
  const envPath = path.join(__dirname, '.env.local');
  const envContent = fs.readFileSync(envPath, 'utf-8');
  const env = {};

  envContent.split('\n').forEach(line => {
    if (!line || line.trim().startsWith('#')) return;
    const [key, ...valueParts] = line.split('=');
    if (key && valueParts.length > 0) {
      env[key.trim()] = valueParts.join('=').trim();
    }
  });

  return env;
}

const env = loadEnv();
const WHATSAPP_TOKEN = env.WHATSAPP_TOKEN;
const PHONE_NUMBER_ID = env.WHATSAPP_PHONE_NUMBER_ID;

async function sendTestMessage() {
  // Tu número de WhatsApp Business (el mismo que está registrado)
  const recipientNumber = '56965419765'; // Tu número sin el +
  const messageText = `🎉 ¡Hola! Este es un mensaje de prueba desde tu chatbot JARVIS!

📅 Fecha: ${new Date().toLocaleString('es-CL')}
🤖 Bot: JARVIS v1.0
✅ Estado: Funcionando correctamente

Si recibes este mensaje, tu integración con WhatsApp está funcionando perfectamente.

Responde a este mensaje y recibirás una respuesta automática del bot.`;

  console.log('================================================');
  console.log('📱 ENVIANDO MENSAJE DE PRUEBA A WHATSAPP');
  console.log('================================================\n');
  console.log('Destinatario: +' + recipientNumber);
  console.log('Token: ' + WHATSAPP_TOKEN.substring(0, 30) + '...');
  console.log('Phone Number ID: ' + PHONE_NUMBER_ID);
  console.log('\nEnviando mensaje...\n');

  try {
    const url = `https://graph.facebook.com/v18.0/${PHONE_NUMBER_ID}/messages`;

    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${WHATSAPP_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        messaging_product: 'whatsapp',
        recipient_type: 'individual',
        to: recipientNumber,
        type: 'text',
        text: {
          preview_url: false,
          body: messageText
        }
      })
    });

    const data = await response.json();

    if (response.ok) {
      console.log('✅ ¡MENSAJE ENVIADO EXITOSAMENTE!\n');
      console.log('Respuesta de la API:');
      console.log(JSON.stringify(data, null, 2));
      console.log('\n🔔 Revisa tu WhatsApp ahora. Deberías recibir el mensaje en unos segundos.');
      console.log('\n💡 TIP: Si respondes al mensaje, el bot te responderá automáticamente.');
    } else {
      console.error('❌ Error al enviar el mensaje:\n');
      console.error('Status:', response.status);
      console.error('Error:', JSON.stringify(data, null, 2));

      if (data.error?.code === 131030) {
        console.log('\n⚠️  El número destinatario no ha iniciado una conversación con tu bot.');
        console.log('   Solución: Primero envía un mensaje desde WhatsApp a tu número de bot.');
      }
    }
  } catch (error) {
    console.error('❌ Error de conexión:', error.message);
  }

  console.log('\n================================================');
  console.log('FIN DE LA PRUEBA');
  console.log('================================================');
}

sendTestMessage();