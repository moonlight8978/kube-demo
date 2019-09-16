FROM node:12.10.0-alpine

RUN mkdir /app
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

CMD ["yarn", "start"]
