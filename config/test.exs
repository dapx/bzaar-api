use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bzaar, Bzaar.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :bzaar, Bzaar.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "220Volts",
  database: "bzaar_test",
  hostname: "127.0.0.1",
  pool: Ecto.Adapters.SQL.Sandbox
