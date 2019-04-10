defmodule PericlesProxy.Runner do
  require Logger
  require IEx
  alias Plug.Conn
  alias PericlesProxy.ProxyConfiguration
  alias PericlesProxy.Reporter

  @default_options [timeout: 30_000, follow_redirects: true]

  @spec retrieve(Conn.t, ProxyConfiguration.t, String.t) :: Conn.t
  def retrieve(conn, proxy_conf, path) do
    {method, url, body, headers, options} = prepare_request(conn, proxy_conf, path)

    case HTTPotion.request(method, url, Keyword.merge(@default_options, [body: body, headers: headers, ibrowse: options])) do
      %HTTPotion.ErrorResponse{message: message} -> Conn.send_resp(conn, 400, "Proxy error: #{inspect(message)}")
      response ->
        conn
        |> Reporter.save(response, proxy_conf.project_id, body, path)
        |> process_response(response)
    end
  end

  @spec prepare_request(Conn.t, ProxyConfiguration.t, String.t) ::
                                                  {Atom.t,
                                                  String.t,
                                                  String.t,
                                                  [{String.t, String.t}],
                                                  Keyword.t}
  defp prepare_request(conn, proxy_conf, path) do
    method = conn.method |> String.downcase |> String.to_atom
    url = prepare_url(conn, proxy_conf.target_base_url, path)
    body = read_body(conn)
    headers = prepare_headers(conn)
    options = [] |> set_ssl(proxy_conf) |> set_proxy(proxy_conf)

    {method, url, body, headers, options}
  end

  @spec prepare_url(Conn.t, String.t, String.t) :: String.t
  defp prepare_url(conn, base_url, path) do
    url = prepare_base_url(base_url)
    |> URI.parse
    |> URI.merge(path)
    |> URI.to_string
    "#{url}?#{conn.query_string}"
  end

  @spec read_body(Conn.t) :: String.t
  defp read_body(conn) do
    case Conn.read_body(conn) do
      {:ok, body, _conn} ->
        body
      {:more, body, conn} ->
        {:stream,
          Stream.resource(
            fn -> {body, conn} end,
            fn
              {body, conn} ->
                {[body], conn}
              nil ->
                {:halt, nil}
              conn ->
                case Conn.read_body(conn) do
                  {:ok, body, _conn} ->
                    {[body], nil}
                  {:more, body, conn} ->
                    {[body], conn}
                end
            end,
            fn _ -> nil end
          )
        }
    end
  end

  @spec prepare_headers(Conn.t) :: [{String.t, String.t}]
  defp prepare_headers(conn) do
    conn
    |> Conn.put_req_header("x-forwarded-for", conn.remote_ip |> :inet.ntoa |> to_string)
    |> Conn.delete_req_header("host")
    |> Conn.delete_req_header("transfer-encoding")
    |> Conn.update_req_header(
      "accept-encoding",
      "",
      fn encodings ->
        if (encodings |> String.match?(~r/gzip/)) do
          "gzip"
        else
          ""
        end
      end
    )
    |> Map.get(:req_headers)
  end

  @spec prepare_base_url(String.t) :: String.t
  defp prepare_base_url(base_url) do
    if String.ends_with?(base_url, "/"), do: base_url, else: (base_url <> "/")
  end

  defp set_ssl(options, %ProxyConfiguration{ignore_ssl: nil}), do: options
  defp set_ssl(options, %ProxyConfiguration{ignore_ssl: false}), do: options
  defp set_ssl(options, _), do: Keyword.put(options, :ssl_options, [{:verify, :verify_none}, {:server_name_indication, :disable}])

  defp set_proxy(options, %ProxyConfiguration{proxy_hostname: nil}), do: options
  defp set_proxy(options, %ProxyConfiguration{proxy_hostname: ""}), do: options
  defp set_proxy(options, proxy_conf) do
    options
    |> Keyword.put(:proxy_host, proxy_conf.proxy_hostname |> String.to_charlist)
    |> Keyword.put(:proxy_port, proxy_conf.proxy_port)
    |> set_proxy_auth(proxy_conf)
  end

  defp set_proxy_auth(options, %ProxyConfiguration{proxy_username: nil}), do: options
  defp set_proxy_auth(options, %ProxyConfiguration{proxy_username: ""}), do: options
  defp set_proxy_auth(options, proxy_conf) do
    options
    |> Keyword.put(:proxy_user, proxy_conf.proxy_username |> String.to_charlist)
    |> Keyword.put(:proxy_password, proxy_conf.proxy_password |> String.to_charlist )
  end

  @spec process_response(Conn.t, Map.t) :: Conn.t
  defp process_response(conn, response) do
    conn
      |> put_resp_headers(response.headers.hdrs)
      |> Conn.delete_resp_header("transfer-encoding")
      |> Conn.send_resp(response.status_code, response.body)
  end

  @spec put_resp_headers(Conn.t, Map.t) :: Conn.t
  defp put_resp_headers(conn, headers) do
    Enum.reduce(headers, conn, fn ({k, v}, c) ->
      Conn.put_resp_header(c, k |> String.downcase, v)
    end)
  end
end

