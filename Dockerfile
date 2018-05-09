FROM ruby:2.5.1-slim

RUN apt-get update && apt-get install wget gnupg -y

RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        postgresql-client-10 \
        git-core \
        ssh \
        libmagickcore-dev \
        libmagickwand-dev \
        imagemagick \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ADD . /app