import { PrismaClient } from "@prisma/client";
import { NextResponse } from "next/server";

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  try {
    let prisma = new PrismaClient();

    let user = await prisma.user.findUnique({
      where: {
        id: params.id,
      },
    });

    if (!user) {
      return Response.json(
        { success: false, error: "User does not exist" },
        {
          status: 500,
        }
      );
    }

    let transactions = await prisma.transaction.findMany({
      where: {
        senderId: user.id,
      },
      orderBy: { createdAt: "desc" },
    });

    return Response.json({
      success: true,
      userId: user.id,
      transactions: transactions,
    });
  } catch (error) {
    console.log(
      `Could not fetch transaction history for user <${params.id}>`,
      error
    );

    return Response.json(
      { success: false, error: "An error occured" },
      {
        status: 500,
      }
    );
  }
}
