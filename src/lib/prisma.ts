import { PrismaClient } from '@prisma/client'

declare global {
  var prisma: PrismaClient | undefined
}

// Configuración para Prisma 7 con motor binario
export const prisma =
  global.prisma ||
  new PrismaClient({
    log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
  })

if (process.env.NODE_ENV !== 'production') global.prisma = prisma