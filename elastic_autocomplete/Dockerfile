FROM elixir:1.14.3-otp-24

ENV APP_HOME /var/www/elastic_autocomplete

WORKDIR $APP_HOME

COPY . .

RUN mix local.hex --force \
    && apt-get update \
    && apt-get install -y apt-utils \
    && apt-get install -y build-essential \
    && apt-get install -y inotify-tools \
    && mix local.rebar --force

CMD mix setup && mix phx.server