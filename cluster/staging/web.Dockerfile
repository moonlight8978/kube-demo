FROM node:12.10.0-alpine as builder

RUN mkdir /app
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . .
RUN yarn build

FROM nginx:1.17.3-alpine

RUN mkdir /app
WORKDIR /app

COPY --from=builder /app/build ./
COPY web.conf /etc/nginx/conf.d/default.conf
