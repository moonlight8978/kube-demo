FROM node:12.10.0-alpine as builder

RUN mkdir /app
WORKDIR /app

COPY web/package.json web/yarn.lock ./
RUN yarn install

COPY web .
RUN yarn build

FROM nginx:1.17.3-alpine

RUN mkdir /app
WORKDIR /app

COPY --from=builder /app/build ./
COPY cluster/staging/web.conf /etc/nginx/conf.d/default.conf
