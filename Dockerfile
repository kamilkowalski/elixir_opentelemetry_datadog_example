# ./Dockerfile

# Extend from the official Elixir image.

# See https://elixirforum.com/t/building-elixir-erlang-linux-amd64-application-image-on-apple-silicon/43913

FROM hexpm/elixir:1.13.0-rc.1-erlang-24.1.5-ubuntu-xenial-20210114

ENV MIX_HOME=/opt/mix

RUN apt-get update && \
  apt-get install -y postgresql-client

# Create app directory and copy the Elixir projects into it.
RUN mkdir /app
COPY . /app
WORKDIR /app


# Install Hex package manager.
# By using `--force`, we don’t need to type “Y” to confirm the installation.
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --force

# Compile the project.
RUN mix do compile

CMD ["/app/entrypoint.sh"]
