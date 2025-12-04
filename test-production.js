// Script de prueba para verificar el token de WhatsApp en producción
const fs = require('fs');
const path = require('path');

// Leer .env.production
function loadEnv() {
  const envPath = path.join(__dirname, '.env.production');

  if (!fs.existsSync(envPath)) {
    console.error('❌ Error: No se encontró el archivo .env.production');
    process.exit(1);
  }

  const envContent = fs.readFileSync(envPath, 'utf-8');
  const env = {};

  envContent.split('\n').forEach(line => {
    // Ignorar líneas vacías y comentarios
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
const BUSINESS_ACCOUNT_ID = env.WHATSAPP_BUSINESS_ACCOUNT_ID;

console.log('==============================================');
console.log('📱 PRUEBA DE TOKEN DE WHATSAPP (PRODUCCIÓN)');
console.log('==============================================\n');

console.log('Configuración actual (.env.production):');
console.log('Token:', WHATSAPP_TOKEN ? `${WHATSAPP_TOKEN.substring(0, 30)}...` : 'NO CONFIGURADO');
console.log('Phone Number ID:', PHONE_NUMBER_ID || 'NO CONFIGURADO');
console.log('Business Account ID:', BUSINESS_ACCOUNT_ID || 'NO CONFIGURADO');
console.log('\n');

async function testToken() {
  if (!WHATSAPP_TOKEN || !PHONE_NUMBER_ID) {
    console.error('❌ Error: Token o Phone Number ID no configurado en .env.production');
    return;
  }

  console.log('🔍 Verificando el nuevo token con la API de WhatsApp...\n');

  try {
    // Test 1: Verificar si el token es válido consultando información del número
    console.log('Test 1: Consultando información del número de teléfono...');
    const url = `https://graph.facebook.com/v18.0/${PHONE_NUMBER_ID}`;

    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${WHATSAPP_TOKEN}`,
      },
    });

    const data = await response.json();

    if (response.ok) {
      console.log('✅ Token válido!');
      console.log('📊 Información del número:');
      console.log(JSON.stringify(data, null, 2));
      console.log('\n');

      console.log('🎉 ¡ÉXITO! Tu nuevo token funciona correctamente.');
      console.log('Puedes usar este token para enviar y recibir mensajes.\n');

    } else {
      console.error('❌ Error al verificar el token:');
      console.error('Status:', response.status);
      console.error('Error:', JSON.stringify(data, null, 2));
      console.log('\n');

      if (data.error) {
        if (data.error.code === 190) {
          console.log('💡 SOLUCIÓN: El token es inválido o ha expirado.');
          console.log('   1. Ve a Meta → WhatsApp → Configuración de la API');
          console.log('   2. Haz clic en "Generar token de acceso"');
          console.log('   3. Selecciona la cuenta correcta');
          console.log('   4. Copia el nuevo token y actualiza .env.production\n');
        } else if (data.error.code === 100) {
          console.log('💡 SOLUCIÓN: El Phone Number ID no existe o no tienes permisos.');
          console.log('   1. Ve a Meta → WhatsApp → Configuración de la API');
          console.log('   2. Verifica el "Identificador de número de teléfono"');
          console.log('   3. Actualiza WHATSAPP_PHONE_NUMBER_ID en .env.production\n');
        } else if (data.error.code === 200) {
          console.log('💡 SOLUCIÓN: No tienes permisos para este número.');
          console.log('   El token pertenece a otra cuenta de WhatsApp Business.');
          console.log('   Genera un nuevo token para la cuenta correcta.\n');
        } else {
          console.log('💡 Error desconocido. Código:', data.error.code);
          console.log('   Mensaje:', data.error.message);
        }
      }

      return;
    }

    // Test 2: Verificar permisos del token
    console.log('Test 2: Verificando permisos del token...');
    const debugUrl = `https://graph.facebook.com/v18.0/debug_token?input_token=${WHATSAPP_TOKEN}&access_token=${WHATSAPP_TOKEN}`;

    const debugResponse = await fetch(debugUrl);
    const debugData = await debugResponse.json();

    if (debugResponse.ok && debugData.data) {
      console.log('✅ Información del token:');
      console.log('- App ID:', debugData.data.app_id);
      console.log('- Válido:', debugData.data.is_valid ? 'Sí ✅' : 'No ❌');

      if (debugData.data.expires_at === 0) {
        console.log('- Expira: Nunca (token permanente) ✅');
      } else {
        const expiryDate = new Date(debugData.data.expires_at * 1000);
        console.log('- Expira:', expiryDate.toLocaleString());
      }

      console.log('- Scopes:', debugData.data.scopes ? debugData.data.scopes.join(', ') : 'N/A');
      console.log('\n');

      // Verificar si tiene los permisos necesarios
      const requiredScopes = ['whatsapp_business_messaging', 'whatsapp_business_management'];
      const hasScopes = debugData.data.scopes || [];

      console.log('🔐 Verificando permisos requeridos:');
      let allPermissionsOk = true;
      requiredScopes.forEach(scope => {
        const has = hasScopes.includes(scope);
        console.log(`  ${has ? '✅' : '❌'} ${scope}`);
        if (!has) allPermissionsOk = false;
      });
      console.log('\n');

      if (!allPermissionsOk) {
        console.log('⚠️  ADVERTENCIA: Faltan permisos necesarios.');
        console.log('   Regenera el token asegurándote de marcar:');
        console.log('   - whatsapp_business_messaging');
        console.log('   - whatsapp_business_management\n');
      }
    }

  } catch (error) {
    console.error('❌ Error de conexión:');
    console.error(error.message);
    console.log('\n');
    console.log('💡 Verifica tu conexión a internet.');
  }

  console.log('==============================================');
  console.log('FIN DE LA PRUEBA');
  console.log('==============================================');
}

testToken();