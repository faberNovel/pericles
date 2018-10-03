defmodule PericlesProxy.Project do
  use Ecto.Schema

  schema "projects" do
    timestamps(inserted_at: :created_at)
  end
end
