use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :bzaar, Bzaar.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :bzaar, Bzaar.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :bzaar, Bzaar.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "220Volts",
  database: "bzaar_dev",
  hostname: "127.0.0.1",
  pool_size: 10

config :facebook,
  graph_url: "https://graph.facebook.com",
  app_id: System.get_env("FACEBOOK_APP_ID"),
  appsecret: System.get_env("FACEBOOK_APP_SECRET")

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  bucket: System.get_env("AWS_BUCKET"),
  region: "sa-east-1",
  s3: [
    scheme: "https://",
    host: "s3.amazonaws.com",
    region: "sa-east-1" ]
