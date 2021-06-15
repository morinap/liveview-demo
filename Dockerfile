# This is just a stub dockerfile, it won't actually build
ARG TARGET_MIX_ENV=prod
ENV MIX_ENV=$TARGET_MIX_ENV
FROM elixir:1.11.4-alpine AS base_build

WORKDIR /app

ADD mix.exs /app
ADD mix.lock /app
RUN mix local.hex --force
RUN mix deps.get --force --only $MIX_ENV
RUN mix local.rebar --force

ADD . /app

RUN mix compile --force

# Other build tasks: assets, etc

# Release
RUN mix release

FROM alpine:3.13.5
RUN apk update && apk upgrade
RUN apk add --no-cache openssl ncurses

RUN mkdir /app
COPY --from=base_build /app/_build/$MIX_ENV/rel/demo /app/demo
