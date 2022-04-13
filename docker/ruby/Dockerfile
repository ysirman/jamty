FROM ruby:3.1.1

RUN apt-get update -y && apt-get install -y \
  default-mysql-client

ENV BUNDLER_VERSION=2.3.11
ENV BUNDLER_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV LANG C.UTF-8

RUN gem install bundler -v $BUNDLER_VERSION
RUN gem update --system

ENV APP /jamty
RUN mkdir $APP
WORKDIR $APP
