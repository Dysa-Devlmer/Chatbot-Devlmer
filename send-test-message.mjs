// Script para enviar un mensaje de prueba directo a WhatsApp
import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });

const PHONE_NUMBER = '56965419765'; // Sin el +
const MESSAGE = 'Hola! Este es un mensaje de prueba del chatbot JARVIS con Ollama.';

console.log('📤 Enviando mensaje de prueba a WhatsApp...\n');
console.log('Configuración:');
console.log('- Token:', process.env.WHATSAPP_TOKEN ? '✅ Configurado' : '❌ No configurado');
console.log('- Phone ID:', process.env.WHATSAPP_PHONE_NUMBER_ID);
console.log('- Número destino:', PHONE_NUMBER);
console.log('');

const url = `https://graph.facebook.com/v18.0/${process.env.WHATSAPP_PHONE_NUMBER_ID}/messages`;

const payload = {
  messaging_product: 'whatsapp',
  recipient_type: 'individual',
  to: PHONE_NUMBER,
  type: 'text',
  text: { body: MESSAGE }
};

console.log('📦 Payload:', JSON.stringify(payload, null, 2));
console.log('');

try {
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.WHATSAPP_TOKEN}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  });

  console.log('📨 Respuesta HTTP:', response.status, response.statusText);

  const data = await response.text();
  console.log('📄 Respuesta completa:');

  try {
    const json = JSON.parse(data);
    console.log(JSON.stringify(json, null, 2));

    if (response.ok) {
      console.log('\n✅ Mensaje enviado exitosamente!');
    } else {
      console.log('\n❌ Error enviando mensaje');
      if (json.error) {
        console.log('Error code:', json.error.code);
        console.log('Error message:', json.error.message);
        console.log('Error type:', json.error.type);
        console.log('Error fbtrace_id:', json.error.fbtrace_id);
      }
    }
  } catch (e) {
    console.log(data);
  }
} catch (error) {
  console.error('\n❌ Error:', error.message);
}
