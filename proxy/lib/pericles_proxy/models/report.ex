defmodule PericlesProxy.Report do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(project_id response_status_code response_headers request_headers)a
  @optional_fields ~w(request_method url request_body response_body)a

  schema "reports" do
    field(:project_id, :integer)
    field(:response_status_code, :integer)
    field(:response_headers, :map)
    field(:request_headers, :map)
    field(:request_method, :string)
    field(:url, :string, default: "/")
    field(:request_body, :string)
    field(:response_body, :string, default: "")
    field(:validated, :boolean, default: false)
    timestamps(inserted_at: :created_at)
  end

  def changeset(report, params \\ :empty) do
    report
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end

