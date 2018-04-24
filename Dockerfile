FROM ruby:2.5.1

WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY vendor /app/vendor

RUN bundle install --jobs=12 --quiet

COPY . /app/
