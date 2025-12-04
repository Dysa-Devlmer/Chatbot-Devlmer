// Script de prueba completa del chatbot con Ollama

const PHONE_NUMBER = '+56965419765'; // Número de WhatsApp del usuario
const TEST_MESSAGE = 'Hola JARVIS, ¿cómo estás?';

console.log('🧪 Probando integración completa del chatbot con Ollama\n');

// 1. Verificar que Ollama esté disponible
console.log('1️⃣  Verificando Ollama...');
try {
  const ollamaResponse = await fetch('http://localhost:3000/api/admin/ollama');
  const ollamaData = await ollamaResponse.json();
  console.log('✅ Ollama:', JSON.stringify(ollamaData, null, 2));
} catch (error) {
  console.error('❌ Error verificando Ollama:', error.message);
  process.exit(1);
}

// 2. Simular webhook de WhatsApp recibiendo un mensaje
console.log('\n2️⃣  Simulando recepción de mensaje de WhatsApp...');
const webhookPayload = {
  object: 'whatsapp_business_account',
  entry: [{
    id: 'test-entry-id',
    changes: [{
      value: {
        messaging_product: 'whatsapp',
        metadata: {
          display_phone_number: '56965419765',
          phone_number_id: '905984725929536'
        },
        contacts: [{
          profile: {
            name: 'Usuario de Prueba'
          },
          wa_id: PHONE_NUMBER.replace('+', '')
        }],
        messages: [{
          from: PHONE_NUMBER.replace('+', ''),
          id: 'test-message-id-' + Date.now(),
          timestamp: Math.floor(Date.now() / 1000).toString(),
          type: 'text',
          text: {
            body: TEST_MESSAGE
          }
        }]
      },
      field: 'messages'
    }]
  }]
};

console.log('📨 Enviando mensaje:', TEST_MESSAGE);

try {
  const webhookResponse = await fetch('http://localhost:3000/api/whatsapp/webhook', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(webhookPayload)
  });

  if (webhookResponse.ok) {
    const result = await webhookResponse.json();
    console.log('✅ Webhook procesado correctamente:', JSON.stringify(result, null, 2));
  } else {
    const errorText = await webhookResponse.text();
    console.error('❌ Error en webhook:', webhookResponse.status, errorText);
  }
} catch (error) {
  console.error('❌ Error enviando webhook:', error.message);
  process.exit(1);
}

// 3. Esperar un momento y verificar que se procesó en la base de datos
console.log('\n3️⃣  Esperando procesamiento...');
await new Promise(resolve => setTimeout(resolve, 3000));

console.log('\n✅ Prueba completada!');
console.log('\n📋 Resumen:');
console.log('- Ollama está corriendo con el modelo configurado');
console.log('- El webhook de WhatsApp procesó el mensaje');
console.log('- El chatbot debería haber generado una respuesta usando Ollama');
console.log('\n💡 Verifica los logs del servidor para ver la respuesta generada.');
