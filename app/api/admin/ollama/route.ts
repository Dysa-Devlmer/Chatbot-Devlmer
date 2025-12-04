import { NextRequest, NextResponse } from 'next/server';
import { AIService } from '@/lib/ai';

export async function GET(request: NextRequest) {
  try {
    const status = await AIService.checkOllamaStatus();

    return NextResponse.json({
      success: true,
      ...status,
      activeModel: await AIService.getActiveModel(),
    });
  } catch (error) {
    return NextResponse.json({
      success: false,
      available: false,
      error: error instanceof Error ? error.message : 'Unknown error',
    }, { status: 500 });
  }
}