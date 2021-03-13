defmodule OtelExample.Repo do
  use Ecto.Repo,
    otp_app: :otel_example,
    adapter: Ecto.Adapters.Postgres
end
