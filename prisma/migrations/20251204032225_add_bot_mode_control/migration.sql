-- AlterTable
ALTER TABLE "Message" ADD COLUMN "sentBy" TEXT;

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Conversation" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "context" JSONB,
    "sentiment" TEXT,
    "category" TEXT,
    "botMode" TEXT NOT NULL DEFAULT 'auto',
    "assignedTo" TEXT,
    "isUnread" BOOLEAN NOT NULL DEFAULT false,
    "startedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endedAt" DATETIME,
    CONSTRAINT "Conversation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_Conversation" ("category", "context", "endedAt", "id", "sentiment", "startedAt", "status", "userId") SELECT "category", "context", "endedAt", "id", "sentiment", "startedAt", "status", "userId" FROM "Conversation";
DROP TABLE "Conversation";
ALTER TABLE "new_Conversation" RENAME TO "Conversation";
CREATE INDEX "Conversation_userId_idx" ON "Conversation"("userId");
CREATE INDEX "Conversation_status_idx" ON "Conversation"("status");
CREATE INDEX "Conversation_startedAt_idx" ON "Conversation"("startedAt");
CREATE INDEX "Conversation_botMode_idx" ON "Conversation"("botMode");
CREATE INDEX "Conversation_isUnread_idx" ON "Conversation"("isUnread");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
