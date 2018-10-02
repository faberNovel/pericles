defmodule PericlesProxy.DelayedJob do
  use Ecto.Schema

  schema "delayed_jobs" do
    field(:handler, :string)
    field(:run_at, :naive_datetime)
    timestamps(inserted_at: :created_at)
  end
end

