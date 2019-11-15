FROM ruby:2.6.5-alpine3.10

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

RUN gem install rails -v 6.0.1

COPY Gemfile* ./
RUN bundle install --jobs=3 --retry=3 --without staging production

EXPOSE 3000
