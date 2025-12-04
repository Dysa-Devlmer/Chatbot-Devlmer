import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

// GET - Obtener todas las conversaciones con información del usuario
export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const status = searchParams.get('status') || 'active';
    const botMode = searchParams.get('botMode');
    const unreadOnly = searchParams.get('unreadOnly') === 'true';

    const where: any = { status };

    if (botMode) {
      where.botMode = botMode;
    }

    if (unreadOnly) {
      where.isUnread = true;
    }

    const conversations = await prisma.conversation.findMany({
      where,
      include: {
        user: {
          select: {
            id: true,
            phoneNumber: true,
            name: true,
            profilePicUrl: true,
            isVIP: true,
          },
        },
        messages: {
          orderBy: { timestamp: 'desc' },
          take: 1, // Solo el último mensaje
        },
      },
      orderBy: [
        { isUnread: 'desc' },
        { startedAt: 'desc' },
      ],
    });

    return NextResponse.json({ conversations });
  } catch (error) {
    console.error('Error fetching conversations:', error);
    return NextResponse.json(
      { error: 'Error al obtener conversaciones' },
      { status: 500 }
    );
  }
}

// PATCH - Actualizar una conversación (cambiar modo bot, marcar como leído, etc.)
export async function PATCH(request: NextRequest) {
  try {
    const body = await request.json();
    const { conversationId, botMode, isUnread, assignedTo, status } = body;

    if (!conversationId) {
      return NextResponse.json(
        { error: 'conversationId es requerido' },
        { status: 400 }
      );
    }

    const updateData: any = {};

    if (botMode !== undefined) updateData.botMode = botMode;
    if (isUnread !== undefined) updateData.isUnread = isUnread;
    if (assignedTo !== undefined) updateData.assignedTo = assignedTo;
    if (status !== undefined) updateData.status = status;

    const conversation = await prisma.conversation.update({
      where: { id: conversationId },
      data: updateData,
      include: {
        user: true,
        messages: {
          orderBy: { timestamp: 'desc' },
          take: 1,
        },
      },
    });

    return NextResponse.json({ conversation });
  } catch (error) {
    console.error('Error updating conversation:', error);
    return NextResponse.json(
      { error: 'Error al actualizar conversación' },
      { status: 500 }
    );
  }
}
