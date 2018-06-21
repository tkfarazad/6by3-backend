FROM startupcraftio/ruby:2.5

ADD . /app

RUN bundle install --without development test

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
