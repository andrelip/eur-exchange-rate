use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :eur_exchange_rate, EurExchangeRateWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :eur_exchange_rate, EurExchangeRate.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PG_USER_NAME"),
  password: System.get_env("PG_USER_PASSWORD"),
  database: "eur_exchange_rate_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
