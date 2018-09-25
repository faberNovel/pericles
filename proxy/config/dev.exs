use Mix.Config

config :pericles_proxy, PericlesProxy.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "Pericles_GW_dev",
  hostname: "localhost"

config :rollbax, enabled: :log, enable_crash_reports: true
