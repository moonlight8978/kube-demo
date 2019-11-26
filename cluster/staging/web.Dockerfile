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

# Main rails server
FROM base AS appserver

COPY . .

EXPOSE 3000

# Image to build assets
FROM base AS assets

ARG RAILS_MASTER_KEY

COPY package.json yarn.lock ./
RUN yarn install

COPY . .
RUN RAILS_MASTER_KEY=$RAILS_MASTER_KEY RAILS_ENV=production bundle exec rails assets:precompile

# Webserver to serve assets
FROM nginx:1.17.3-alpine AS webserver

RUN mkdir -p /www/data
WORKDIR /www/data

COPY cluster/staging/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=assets /app/public/packs /app/public/assets ./

EXPOSE 80
