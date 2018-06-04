FROM ruby:2.5

RUN apt-get update -qq && \
  apt-get install -y build-essential libpq-dev nodejs

RUN mkdir -p /myapp
WORKDIR /myapp

ENV RAILS_ENV development

ENTRYPOINT bundle install \
  && bundle exec rake db:migrate \
  && rm -f /myapp/tmp/pids/server.pid \
  && bundle exec rails s
