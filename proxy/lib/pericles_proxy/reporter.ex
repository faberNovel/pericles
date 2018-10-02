defmodule PericlesProxy.Reporter do
  require Logger
  alias Plug.Conn
  alias PericlesProxy.Report
  alias PericlesProxy.Repo
  alias PericlesProxy.DelayedJob

  @spec save(Conn.t, Map.t, Integer.t, String.t, String.t) :: Conn.t
  def save(conn, response, project_id, request_body, path) do
    if response |> json? do
      changeset = Report.changeset(%Report{}, %{
        project_id: project_id,
        response_status_code: response.status_code,
        response_headers: response.headers |> Map.new,
        request_headers: conn.req_headers |> Map.new,
        request_method: conn.method,
        url: path,
        request_body: request_body,
        response_body: response |> decode_body
      })

      case Repo.insert(changeset) do
        {:ok, report} ->
          Logger.info("Inserted report #{report.id}")
          Repo.insert(%DelayedJob{handler: "--- !ruby/struct:ReportValidatorJob\nreport_id: #{report.id}\n", run_at: DateTime.utc_now})
        {:error, changeset} ->
          Logger.error("Failed to insert report #{inspect(changeset)}")
      end
    end

    conn
  end

  @spec decode_body(Map.t) :: String.t
  defp decode_body(response) do
    if byte_size(response.body) > 0 && response |> has_header?("content-encoding", "gzip") do
      :zlib.gunzip(response.body)
    else
      response.body
    end
  end

  @spec json?(Map.t) :: Boolean.t
  defp json?(response) do
    response |> has_header?("content-type", ~r/^application\/json/)
  end

  @spec has_header?(Map.t, String.t, (String.t | Regex.t)) :: Boolean.t
  defp has_header?(response, key, value) when is_binary(value) do
    Enum.any?(response.headers, fn ({k, v}) ->
      key == String.downcase(k) && value == v
    end)
  end
  defp has_header?(response, key, regex) do
    Enum.any?(response.headers, fn ({k, v}) ->
      key == String.downcase(k) && Regex.match?(regex, v)
    end)
  end
end

