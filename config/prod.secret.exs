use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).

# Configure your database
config :bzaar, Bzaar.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

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