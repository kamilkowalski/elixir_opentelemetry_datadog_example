# Elixir + OpenTelemetry + Datadog Example

This is an example Phoenix application that makes use of OpenTelemetry tracing and sends traces to Datadog over the OpenTelemetry Collector.

## Running it

You'll need **Elixir**, **Docker** and **PostgreSQL** to run the example app.

First, setup the app:

```bash
mix setup
```

Then export your Datadog configuration:

```bash
export DD_ENV=`whoami`-local
export DD_SERVICE=test-service
export DD_VERSION=1.0
export DD_API_KEY=<your Datadog API key>
```

In the same shell, start the collector using:

```bash
docker-compose up -d
```

Finally, run the application:

```bash
mix phx.server
```

Visit http://localhost:4000/posts a couple of times for the traces to be sent to Datadog and observe them in Datadog's APM page.

## Moving parts

Here's an outline of the important parts of this example.

### Phoenix app

Most of the source code is that of a Phoenix application with OpenTelemetry configured. In order to do that, we needed the following dependencies:

* [`opentelemetry_api`](https://hex.pm/packages/opentelemetry_api) - instruments our application,
* [`opentelemetry`](https://hex.pm/packages/opentelemetry) - collects traces within our runtime and passes them to the exporter,
* [`opentelemetry_exporter`](https://hex.pm/packages/opentelemetry_exporter) - exports traces using OpenTelemetry Protocol to the OpenTelemetry Collector.

Instrumented code can be seen in `PostController`'s `index` function.

The exporter is configured in `config/config.exs` and by default reports traces to `localhost:9090`.

### Docker Compose file

The `docker-compose.yaml` file specifies an `otel-collector` service based on the [`opentelemetry-collector-contrib`](https://github.com/open-telemetry/opentelemetry-collector-contrib) image.

The `-contrib` version of the collector is used because it includes the [Datadog exporter](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/datadogexporter).

We're passing our environment variables to the service and mounting the collector config file in a volume accessible to it.

## Collector config

OpenTelemetry Collector is configured via `otel-collector-config.yaml` according to [the Configuration guide](https://opentelemetry.io/docs/collector/configuration/).

In this simple setup, we're using:

* the [OTLP receiver](https://github.com/open-telemetry/opentelemetry-collector/tree/main/receiver/otlpreceiver) using an HTTP interface to receive traces from our application,
* the [batch processor](https://github.com/open-telemetry/opentelemetry-collector/tree/main/processor/batchprocessor) with a timeout of 10s as suggested by the Datadog exporter,
* and the [Datadog exporter](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/datadogexporter) that actually sends traces to Datadog.

All of the above are used in a single `traces` pipeline.
