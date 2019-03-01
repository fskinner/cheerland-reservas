use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cheerland_reservas, CheerlandReservasWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cheerland_reservas, CheerlandReservas.Repo,
  username: "postgres",
  password: "postgres",
  database: "cheerland_reservas_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
