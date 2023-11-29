import { PrismaClient } from "@prisma/client";
import { NextResponse } from "next/server";
import QRCode from "qrcode";

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

    let payload = { namespace: "payero", id: user.id, amount: "2.0" };

    let qrcode = await QRCode.toDataURL(JSON.stringify(payload));

    var image = Buffer.from(qrcode.split(",")[1], "base64");
    const response = new NextResponse(image);

    response.headers.set("Content-Type", "image/png");

    return response;
  } catch (error) {
    console.log(`Could not generate qr code for user <${params.id}>`, error);

    return Response.json(
      { success: false, error: "An error occured" },
      {
        status: 500,
      }
    );
  }
}
