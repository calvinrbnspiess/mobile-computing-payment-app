import { PrismaClient } from "@prisma/client";

export async function POST(
  request: Request,
  { params }: { params: { id: string } }
) {
  const {
    receiver,
    amount,
    currency = "EUR",
    message = "",
  } = await request.json();

  if (!receiver || !amount || isNaN(amount)) {
    return Response.json(
      {
        success: false,
        error: "You need to provide at least receiver and amount.",
      },
      {
        status: 400,
      }
    );
  }

  try {
    let prisma = new PrismaClient();

    let user = await prisma.user.findUnique({
      where: {
        id: params.id,
      },
    });

    if (!user) {
      return Response.json(
        { success: false, error: "Could not initiate transaction" },
        {
          status: 500,
        }
      );
    }

    let transaction = await prisma.transaction.create({
      data: {
        senderId: user.id,
        receiver: receiver,
        amount: parseFloat(amount),
        currency: currency,
        message: message,
      },
    });

    return Response.json({
      success: true,
      id: transaction.id,
      sender: transaction.senderId,
      receiver: transaction.receiver,
      amount: transaction.amount,
      currency: transaction.currency,
      message: transaction.message,
    });
  } catch (error) {
    console.log("Could not perform transaction: ", error);
    return Response.json(
      { success: false, error: "Could not perform transaction" },
      {
        status: 500,
      }
    );
  }
}
