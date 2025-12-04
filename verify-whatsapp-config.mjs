// Verificar configuración de WhatsApp Business API
import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });

console.log('🔍 Verificando configuración de WhatsApp Business API\n');

const token = process.env.WHATSAPP_TOKEN;
const phoneNumberId = process.env.WHATSAPP_PHONE_NUMBER_ID;
const businessAccountId = process.env.WHATSAPP_BUSINESS_ACCOUNT_ID;

console.log('📋 Variables de entorno:');
console.log('- WHATSAPP_TOKEN:', token ? `${token.substring(0, 20)}...` : '❌ No configurado');
console.log('- WHATSAPP_PHONE_NUMBER_ID:', phoneNumberId || '❌ No configurado');
console.log('- WHATSAPP_BUSINESS_ACCOUNT_ID:', businessAccountId || '❌ No configurado');
console.log('');

// 1. Verificar el token
console.log('1️⃣  Verificando token de acceso...');
try {
  const response = await fetch(`https://graph.facebook.com/v18.0/me?access_token=${token}`);
  const data = await response.json();

  if (response.ok) {
    console.log('✅ Token válido');
    console.log('   ID:', data.id);
    console.log('   Name:', data.name);
  } else {
    console.log('❌ Token inválido');
    console.log('   Error:', data.error?.message);
  }
} catch (error) {
  console.log('❌ Error verificando token:', error.message);
}

console.log('');

// 2. Verificar el Phone Number ID
console.log('2️⃣  Verificando Phone Number ID...');
try {
  const response = await fetch(
    `https://graph.facebook.com/v18.0/${phoneNumberId}?access_token=${token}`
  );
  const data = await response.json();

  if (response.ok) {
    console.log('✅ Phone Number ID válido');
    console.log('   Número:', data.display_phone_number);
    console.log('   Nombre:', data.verified_name);
    console.log('   Quality:', data.quality_rating);
  } else {
    console.log('❌ Phone Number ID inválido');
    console.log('   Error:', data.error?.message);
  }
} catch (error) {
  console.log('❌ Error verificando Phone Number ID:', error.message);
}

console.log('');

// 3. Verificar permisos del token
console.log('3️⃣  Verificando permisos del token...');
try {
  const response = await fetch(
    `https://graph.facebook.com/v18.0/debug_token?input_token=${token}&access_token=${token}`
  );
  const data = await response.json();

  if (response.ok && data.data) {
    console.log('✅ Información del token:');
    console.log('   App ID:', data.data.app_id);
    console.log('   Válido:', data.data.is_valid);
    console.log('   Expira:', data.data.expires_at ? new Date(data.data.expires_at * 1000).toLocaleString() : 'Nunca');
    console.log('   Scopes:', data.data.scopes?.join(', ') || 'N/A');
  } else {
    console.log('⚠️  No se pudo verificar permisos');
    console.log('   Esto es normal con algunos tipos de tokens');
  }
} catch (error) {
  console.log('⚠️  Error verificando permisos:', error.message);
}

console.log('');
console.log('💡 Recomendaciones:');
console.log('   - Asegúrate de que el token tenga el permiso "whatsapp_business_messaging"');
console.log('   - Verifica que el Phone Number ID sea correcto en Meta Business Suite');
console.log('   - El número debe estar verificado y activo');
console.log('   - Para enviar mensajes, el usuario debe iniciar la conversación primero (ventana de 24h)');
