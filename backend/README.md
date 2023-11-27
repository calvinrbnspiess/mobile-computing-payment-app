## Payero Backend

## Development

Make sure to install npm dependencies with `npm install`.
Now, you can set up the docker environment with:

```bash
    npx prisma migrate dev # generate prisma migrations and populate database
    npm run dev # starts the development server
```

## Deployment

Make sure to be in the production environment. Create an environment file called `.production.env`.

```bash
    docker compose up --detach --build
```
