const changelog = [{ version: "0.1", description: "Initial release" }];

export async function GET() {
  return Response.json({
    currentVersion: changelog[0].version,
    changelog: changelog,
  });
}
