# Rails base image
FROM ruby:2.6.5-alpine3.10 AS base

RUN mkdir /app
WORKDIR /app

RUN apk add -u --no-cache \
  build-base \
  linux-headers \
  git \
  mysql-dev \
  nodejs \
  yarn \
  tzdata \
  file \
  imagemagick

COPY Gemfile* ./
RUN bundle install --deployment --jobs=3 --retry=3 --without development test

# Image to build assets
FROM base AS assets

ARG RAILS_MASTER_KEY

ENV RAILS_ENV=production \
  NODE_ENV=production

COPY package.json yarn.lock ./
RUN yarn install

COPY . .
RUN RAILS_MASTER_KEY=$RAILS_MASTER_KEY bundle exec rails assets:precompile

# Main rails server
FROM base AS appserver

COPY . .

COPY --from=assets /app/public ./public

EXPOSE 3000

# Webserver to serve assets
FROM nginx:1.17.3-alpine AS webserver

RUN mkdir -p /www/data
WORKDIR /www/data

COPY assets.conf /etc/nginx/conf.d/default.conf

COPY --from=assets /app/public ./

EXPOSE 80
