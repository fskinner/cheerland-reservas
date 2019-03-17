# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cheerland_reservas,
  ecto_repos: [CheerlandReservas.Repo]

# Configures the endpoint
config :cheerland_reservas, CheerlandReservasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yKeFKj9c9EK59qpZ51teMbaiu4hcHiHNe0QFDNvABfVtfsfoHxNUhnTPhgYl+owW",
  render_errors: [view: CheerlandReservasWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CheerlandReservas.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian
config :cheerland_reservas, CheerlandReservasWeb.Guardian,
  issuer: "CheerlandReservas",
  ttl: {30, :days},
  allowed_drift: 2000,
  secret_key: "WRdDC4l/sBA4TfCmLXh/An+zOHYkaMPUGAzalN7GPbyf7CLniOrr8sd6YgEoVbYv"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
