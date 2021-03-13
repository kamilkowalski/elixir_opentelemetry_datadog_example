# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :otel_example,
  ecto_repos: [OtelExample.Repo]

# Configures the endpoint
config :otel_example, OtelExampleWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ogiexe/orI66OwkDVoqLLburivs/8JaSztJwCU8z0NriZwYZ4CPog55n0GrKVjiC",
  render_errors: [view: OtelExampleWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: OtelExample.PubSub,
  live_view: [signing_salt: "R1nYQNMd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :opentelemetry, :processors,
  otel_batch_processor: %{
    exporter: {:opentelemetry_exporter, %{}}
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
