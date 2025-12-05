const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function cleanTestConversations() {
  try {
    console.log('🧹 Limpiando conversaciones de prueba...\n');

    // Números de teléfono de prueba que queremos eliminar
    const testPhoneNumbers = [
      '16465894168',
      'Usuario de Prueba',
    ];

    // Buscar usuarios de prueba por nombre o número
    const testUsers = await prisma.user.findMany({
      where: {
        OR: [
          { phoneNumber: { in: testPhoneNumbers } },
          { name: { in: ['Usuario de Prueba', 'Katherine 🦁🦋'] } },
        ],
      },
      include: {
        conversations: {
          include: {
            messages: true,
          },
        },
      },
    });

    console.log(`Encontrados ${testUsers.length} usuarios de prueba:\n`);

    for (const user of testUsers) {
      console.log(`- ${user.name || user.phoneNumber}`);
      console.log(`  Conversaciones: ${user.conversations.length}`);
      console.log(`  Mensajes totales: ${user.conversations.reduce((sum, conv) => sum + conv.messages.length, 0)}\n`);
    }

    // Eliminar mensajes y conversaciones de estos usuarios
    for (const user of testUsers) {
      for (const conversation of user.conversations) {
        // Eliminar mensajes
        await prisma.message.deleteMany({
          where: { conversationId: conversation.id },
        });

        // Eliminar conversación
        await prisma.conversation.delete({
          where: { id: conversation.id },
        });
      }

      // Eliminar usuario
      await prisma.user.delete({
        where: { id: user.id },
      });
    }

    console.log('✅ Conversaciones de prueba eliminadas exitosamente!\n');

    // Mostrar resumen de conversaciones restantes
    const remainingConversations = await prisma.conversation.count();
    const remainingUsers = await prisma.user.count();

    console.log(`📊 Resumen:`);
    console.log(`   Usuarios activos: ${remainingUsers}`);
    console.log(`   Conversaciones activas: ${remainingConversations}`);

  } catch (error) {
    console.error('❌ Error:', error);
  } finally {
    await prisma.$disconnect();
  }
}

cleanTestConversations();
