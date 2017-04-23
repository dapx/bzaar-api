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
  url: [host: "localhost"],
  secret_key_base: "N+o9NTFd9P6/ZarpWXPXO2fn1ieyAeaoP4u3qEzkJrJuUKabciY/FQby4fbj++1I",
  render_errors: [view: Bzaar.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bzaar.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
