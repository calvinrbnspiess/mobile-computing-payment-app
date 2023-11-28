FROM node:20-alpine

RUN apk add --no-cache bash

# create & set working directory
RUN mkdir -p /usr/src
WORKDIR /usr/src

# copy source files
COPY .. /usr/src

# install dependencies
RUN npm ci

# RUN npx prisma db pull && npx prisma generate
RUN npx prisma generate
RUN npm run build

EXPOSE 3000

# set permissions
RUN npx prisma migrate deploy

CMD npm run start