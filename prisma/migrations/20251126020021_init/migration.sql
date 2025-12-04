-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "phoneNumber" TEXT NOT NULL,
    "name" TEXT,
    "profilePicUrl" TEXT,
    "language" TEXT NOT NULL DEFAULT 'es',
    "timezone" TEXT NOT NULL DEFAULT 'America/Santiago',
    "isBlocked" BOOLEAN NOT NULL DEFAULT false,
    "isVIP" BOOLEAN NOT NULL DEFAULT false,
    "firstContact" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastContact" DATETIME NOT NULL,
    "totalMessages" INTEGER NOT NULL DEFAULT 0,
    "preferences" JSONB,
    "tags" TEXT
);

-- CreateTable
CREATE TABLE "Conversation" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "context" JSONB,
    "sentiment" TEXT,
    "category" TEXT,
    "startedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endedAt" DATETIME,
    CONSTRAINT "Conversation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Message" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "conversationId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "caption" TEXT,
    "whatsappId" TEXT,
    "status" TEXT NOT NULL DEFAULT 'sent',
    "direction" TEXT NOT NULL,
    "aiProcessed" BOOLEAN NOT NULL DEFAULT false,
    "aiResponse" TEXT,
    "intent" TEXT,
    "entities" JSONB,
    "mediaUrl" TEXT,
    "mediaMimeType" TEXT,
    "mediaSize" INTEGER,
    "timestamp" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Message_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "UserAnalytics" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "date" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "messagesReceived" INTEGER NOT NULL DEFAULT 0,
    "messagesSent" INTEGER NOT NULL DEFAULT 0,
    "averageResponseTime" REAL,
    "conversationDuration" REAL,
    "satisfactionScore" REAL,
    "commandsUsed" JSONB,
    "topicsDiscussed" JSONB,
    CONSTRAINT "UserAnalytics_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Command" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "trigger" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "response" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "usageCount" INTEGER NOT NULL DEFAULT 0,
    "lastUsed" DATETIME,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "MessageTemplate" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "language" TEXT NOT NULL DEFAULT 'es',
    "content" TEXT NOT NULL,
    "variables" JSONB,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "usageCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "SystemConfig" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'string',
    "description" TEXT,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "WebhookLog" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "event" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "error" TEXT,
    "processedAt" DATETIME,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "Campaign" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "targetUsers" JSONB NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "scheduledFor" DATETIME,
    "sentCount" INTEGER NOT NULL DEFAULT 0,
    "deliveredCount" INTEGER NOT NULL DEFAULT 0,
    "readCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_phoneNumber_key" ON "User"("phoneNumber");

-- CreateIndex
CREATE INDEX "User_phoneNumber_idx" ON "User"("phoneNumber");

-- CreateIndex
CREATE INDEX "User_lastContact_idx" ON "User"("lastContact");

-- CreateIndex
CREATE INDEX "Conversation_userId_idx" ON "Conversation"("userId");

-- CreateIndex
CREATE INDEX "Conversation_status_idx" ON "Conversation"("status");

-- CreateIndex
CREATE INDEX "Conversation_startedAt_idx" ON "Conversation"("startedAt");

-- CreateIndex
CREATE UNIQUE INDEX "Message_whatsappId_key" ON "Message"("whatsappId");

-- CreateIndex
CREATE INDEX "Message_conversationId_idx" ON "Message"("conversationId");

-- CreateIndex
CREATE INDEX "Message_userId_idx" ON "Message"("userId");

-- CreateIndex
CREATE INDEX "Message_timestamp_idx" ON "Message"("timestamp");

-- CreateIndex
CREATE INDEX "Message_whatsappId_idx" ON "Message"("whatsappId");

-- CreateIndex
CREATE INDEX "UserAnalytics_userId_idx" ON "UserAnalytics"("userId");

-- CreateIndex
CREATE INDEX "UserAnalytics_date_idx" ON "UserAnalytics"("date");

-- CreateIndex
CREATE UNIQUE INDEX "Command_trigger_key" ON "Command"("trigger");

-- CreateIndex
CREATE INDEX "Command_trigger_idx" ON "Command"("trigger");

-- CreateIndex
CREATE UNIQUE INDEX "MessageTemplate_name_key" ON "MessageTemplate"("name");

-- CreateIndex
CREATE INDEX "MessageTemplate_category_idx" ON "MessageTemplate"("category");

-- CreateIndex
CREATE INDEX "MessageTemplate_language_idx" ON "MessageTemplate"("language");

-- CreateIndex
CREATE UNIQUE INDEX "SystemConfig_key_key" ON "SystemConfig"("key");

-- CreateIndex
CREATE INDEX "SystemConfig_key_idx" ON "SystemConfig"("key");

-- CreateIndex
CREATE INDEX "WebhookLog_event_idx" ON "WebhookLog"("event");

-- CreateIndex
CREATE INDEX "WebhookLog_status_idx" ON "WebhookLog"("status");

-- CreateIndex
CREATE INDEX "WebhookLog_createdAt_idx" ON "WebhookLog"("createdAt");

-- CreateIndex
CREATE INDEX "Campaign_status_idx" ON "Campaign"("status");

-- CreateIndex
CREATE INDEX "Campaign_scheduledFor_idx" ON "Campaign"("scheduledFor");
