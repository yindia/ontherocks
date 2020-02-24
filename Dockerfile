FROM node:10.11.0-alpine
MAINTAINER evalsocket@protonmail.com

WORKDIR /usr/src/app

COPY ./src/package.json ./
COPY ./src/yarn.lock ./

RUN yarn install --pure-lockfile --production

COPY ./src .

EXPOSE 8080

CMD ["yarn", "start"]
