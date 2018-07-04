FROM startupcraftio/ruby:2.5

# And clean all the stuff
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    ffmpeg

ADD . /app

RUN bundle install --without development test

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
