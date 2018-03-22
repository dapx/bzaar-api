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

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  bucket: System.get_env("AWS_BUCKET"),
  region: "sa-east-1",
  s3: [
    scheme: "https://",
    host: "s3.amazonaws.com",
    region: "sa-east-1" ]
