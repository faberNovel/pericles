use Mix.Config

config :pericles_proxy, PericlesProxy.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5"),
  ssl: true

config :rollbax,
  access_token: System.get_env("ROLLBAR_ACCESS_TOKEN"),
  environment: System.get_env("ROLLBAR_ENV")
