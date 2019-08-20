FROM ruby:2.5

RUN apt-get update -qq \
  && apt-get install -y build-essential libpq-dev nodejs supervisor \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /myapp
WORKDIR /myapp

ENV RAILS_ENV development

COPY files/etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT bundle install --path vendor/bundle \
  && bundle exec rake db:migrate \
  && rm -f /myapp/tmp/pids/server.pid \
  && /usr/bin/supervisord
