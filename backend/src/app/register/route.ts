import { PrismaClient } from "@prisma/client";

export async function POST(request: Request) {
  const { nickname, email } = await request.json();

  try {
    let prisma = new PrismaClient();

    let user = await prisma.user.create({
      data: {
        nickname: nickname,
        email: email,
      },
    });

    return Response.json({
      success: true,
      id: user.id,
      username: user.nickname,
      email: user.email,
    });
  } catch (error) {
    console.log("Could not create user: ", error);
    return Response.json(
      { success: false, error: "Could not create user" },
      {
        status: 500,
      }
    );
  }
}
