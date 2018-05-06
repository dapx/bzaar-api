# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bzaar,
  ecto_repos: [Bzaar.Repo]

# Configures the endpoint
config :bzaar, Bzaar.Endpoint,
  url: [host: "localhost", port: 4000],
  secret_key_base: "N+o9NTFd9P6/ZarpWXPXO2fn1ieyAeaoP4u3qEzkJrJuUKabciY/FQby4fbj++1I",
  render_errors: [view: Bzaar.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bzaar.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures JWT
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Bzaar",
  ttl: { 3, :days},
  verify_issuer: true,
  secret_key: "Y8uWXtGcg3vwlQ+uCAGK67JhdtaSYAkqu/tNNkaecwuQzYLMIRDiXqk86Dg2MnbJ",
  serializer: Bzaar.GuardianSerializer

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bzaar, Bzaar.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("SMTP_SERVER"),
  hostname: "bzaar.com.br",
  port: 465,
  username: System.get_env("SMTP_USERNAME"), # or {:system, "SMTP_USERNAME"}
  password: System.get_env("SMTP_PASSWORD"), # or {:system, "SMTP_PASSWORD"}
  tls: :never, # can be `:always` or `:never`
  allowed_tls_versions: [:"tlsv1.2"], # or {":system", ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  ssl: true, # can be `true`
  retries: 1,
  no_mx_lookups: false # can be `true`

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
