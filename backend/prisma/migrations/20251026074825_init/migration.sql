/*
  Warnings:

  - You are about to drop the column `balance` on the `Budget` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `Budget` table. All the data in the column will be lost.
  - You are about to alter the column `limit` on the `Budget` table. The data in that column could be lost. The data in that column will be cast from `DoublePrecision` to `Decimal(19,2)`.
  - You are about to drop the column `color` on the `Category` table. All the data in the column will be lost.
  - You are about to drop the column `type` on the `Category` table. All the data in the column will be lost.
  - You are about to drop the column `category` on the `Transaction` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `Transaction` table. All the data in the column will be lost.
  - You are about to alter the column `amount` on the `Transaction` table. The data in that column could be lost. The data in that column will be cast from `DoublePrecision` to `Decimal(19,2)`.
  - A unique constraint covering the columns `[accountId,month,year]` on the table `Budget` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name,userId]` on the table `Category` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `Category` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `accountId` to the `Budget` table without a default value. This is not possible if the table is not empty.
  - Added the required column `hex` to the `Category` table without a default value. This is not possible if the table is not empty.
  - Added the required column `accountId` to the `Transaction` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `type` on the `Transaction` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('CREDIT', 'DEBIT');

-- DropForeignKey
ALTER TABLE "public"."Budget" DROP CONSTRAINT "Budget_userId_fkey";

-- DropForeignKey
ALTER TABLE "public"."Category" DROP CONSTRAINT "Category_userId_fkey";

-- DropForeignKey
ALTER TABLE "public"."Transaction" DROP CONSTRAINT "Transaction_userId_fkey";

-- AlterTable
ALTER TABLE "Budget" DROP COLUMN "balance",
DROP COLUMN "userId",
ADD COLUMN     "accountId" INTEGER NOT NULL,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN "limit" SET DATA TYPE DECIMAL(19,2);

-- AlterTable
ALTER TABLE "Category" DROP COLUMN "color",
DROP COLUMN "type",
ADD COLUMN     "hex" TEXT NOT NULL,
ADD COLUMN     "isSystem" BOOLEAN NOT NULL DEFAULT false,
ALTER COLUMN "userId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Transaction" DROP COLUMN "category",
DROP COLUMN "userId",
ADD COLUMN     "accountId" INTEGER NOT NULL,
ADD COLUMN     "categoryId" INTEGER,
ADD COLUMN     "runningBalance" DECIMAL(19,2),
ALTER COLUMN "amount" SET DATA TYPE DECIMAL(19,2),
ALTER COLUMN "note" DROP NOT NULL,
DROP COLUMN "type",
ADD COLUMN     "type" "TransactionType" NOT NULL;

-- CreateTable
CREATE TABLE "Account" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'INR',
    "initialAmount" DECIMAL(19,2) NOT NULL DEFAULT 0,
    "balance" DECIMAL(19,2) NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Account_userId_idx" ON "Account"("userId");

-- CreateIndex
CREATE INDEX "Account_createdAt_idx" ON "Account"("createdAt");

-- CreateIndex
CREATE INDEX "Budget_accountId_month_year_idx" ON "Budget"("accountId", "month", "year");

-- CreateIndex
CREATE UNIQUE INDEX "Budget_accountId_month_year_key" ON "Budget"("accountId", "month", "year");

-- CreateIndex
CREATE UNIQUE INDEX "Category_name_userId_key" ON "Category"("name", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "unique_system_category_name" ON "Category"("name");

-- CreateIndex
CREATE INDEX "Transaction_accountId_idx" ON "Transaction"("accountId");

-- CreateIndex
CREATE INDEX "Transaction_date_idx" ON "Transaction"("date");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Category" ADD CONSTRAINT "Category_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Budget" ADD CONSTRAINT "Budget_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES "Account"("id") ON DELETE CASCADE ON UPDATE CASCADE;
