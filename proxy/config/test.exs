use Mix.Config

config :pericles_proxy, PericlesProxy.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "Pericles_GW_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :rollbax, enabled: false

config :logger, level: :info

config :exvcr, [
  vcr_cassette_library_dir: "test/fixture/vcr_cassettes"
]
