defmodule PericlesProxy.Router do
  use Plug.Router
  use Plug.ErrorHandler

  require Logger
  alias PericlesProxy.ProxyConfigurationRepo

  plug(:match)
  plug(:dispatch)

  match "/projects/:project_id/proxy/*glob" do
    proxy_configuration = try do
      project_id
      |> String.to_integer
      |> ProxyConfigurationRepo.for_project
    rescue
      ArgumentError -> nil
    end

    if proxy_configuration do
      runner = Application.get_env(:reverse_proxy, :runner, PericlesProxy.Runner)
      runner.retrieve(conn, proxy_configuration, Enum.join(glob, "/"))
    else
      send_resp(conn, 404, "Project not found")
    end
  end
  match(_, do: send_resp(conn, 404, "Oops !"))

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    conn =
      conn
      |> Plug.Conn.fetch_cookies()
      |> Plug.Conn.fetch_query_params()

    params =
      case conn.params do
        %Plug.Conn.Unfetched{aspect: :params} -> "unfetched"
        other -> other
      end

    occurrence_data = %{
      "request" => %{
        "cookies" => conn.req_cookies,
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => List.to_string(:inet.ntoa(conn.remote_ip)),
        "headers" => Enum.into(conn.req_headers, %{}),
        "method" => conn.method,
        "params" => params,
      }
    }

    Rollbax.report(kind, reason, stacktrace, _custom_data = %{}, occurrence_data)
  end
end
