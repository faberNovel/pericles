defmodule PericlesProxy do
  @moduledoc """
  Documentation for PericlesProxy.
  """

  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {
        Plug.Adapters.Cowboy2,
        scheme: :http,
        plug: PericlesProxy.Router,
        options: [port: String.to_integer(System.get_env("PORT") || "8080")]
      },
      PericlesProxy.Repo
    ]

    Logger.info("Started application")

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
