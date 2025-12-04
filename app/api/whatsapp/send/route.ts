import { sendWhatsAppMessage } from '@/lib/whatsapp';
import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  const { phoneNumber, message } = await request.json();

  if (!phoneNumber || !message) {
    return NextResponse.json({ error: 'Missing phoneNumber or message' }, { status: 400 });
  }

  try {
    const result = await sendWhatsAppMessage(phoneNumber, message);
    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    return NextResponse.json({ error: (error as Error).message }, { status: 500 });
  }
}
