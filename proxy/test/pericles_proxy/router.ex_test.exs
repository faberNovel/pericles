defmodule PericlesProxy.RouterTest do
  alias PericlesProxy.{Repo, Project, ProxyConfiguration, Report}

  use ExUnit.Case, async: true
  use ExVCR.Mock
  use Plug.Test

  import Ecto.Query

  setup_all do
    HTTPoison.start
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    {:ok, project} = Repo.insert(%Project{})
    {:ok, project_id: project.id}
  end

  test "non proxy path" do
    conn = conn(:get, "/unknown")
    conn = PericlesProxy.Router.call(conn, [])

    assert conn.status == 404
    assert conn.resp_body == "Oops !"
  end

  test "unexisting project id" do
    conn = conn(:get, "/projects/0/proxy/")
    conn = PericlesProxy.Router.call(conn, [])

    assert conn.status == 404
    assert conn.resp_body == "Project not found"
  end

  test "bad format project id" do
    conn = conn(:get, "/projects/<id>/proxy/")
    conn = PericlesProxy.Router.call(conn, [])

    assert conn.status == 404
    assert conn.resp_body == "Project not found"
  end

  test "get without report (non json response)", state do
    Repo.insert(%ProxyConfiguration{project_id: state[:project_id], target_base_url: "https://example.com"})

    use_cassette "non_json_get" do
      conn = conn(:get, "/projects/#{state[:project_id]}/proxy/")
      conn = PericlesProxy.Router.call(conn, [])
      assert conn.status == 200
    end

    assert Repo.aggregate(Report, :count, :id) == 0
  end

  test "post without report", state do
    Repo.insert(%ProxyConfiguration{project_id: state[:project_id], target_base_url: "https://example.com"})

    use_cassette "non_json_post" do
      conn = conn(:post, "/projects/#{state[:project_id]}/proxy/", "Example body")
      conn = PericlesProxy.Router.call(conn, [])
      assert conn.status == 200
    end

    assert Repo.aggregate(Report, :count, :id) == 0
  end

  test "get with report", state do
    Repo.insert(%ProxyConfiguration{project_id: state[:project_id], target_base_url: "https://jsonplaceholder.typicode.com"})

    use_cassette "json_get" do
      conn = conn(:get, "/projects/#{state[:project_id]}/proxy/posts/3")
      |> put_req_header("content-type", "application/json")
      conn = PericlesProxy.Router.call(conn, [])
      assert conn.status == 200
    end

    report = Repo.one(from r in Report, order_by: [desc: r.id], limit: 1)
    assert report.project_id == state[:project_id]
    assert report.request_method == "GET"
    assert report.url == "posts/3"
  end

  test "get with proxy error", state do
    Repo.insert(%ProxyConfiguration{project_id: state[:project_id], target_base_url: "https://example.com", proxy_hostname: "https://proxy.technologies.fabernovel.com", proxy_port: 3128})

    use_cassette "proxy_error" do
      conn = conn(:get, "/projects/#{state[:project_id]}/proxy/")
      conn = PericlesProxy.Router.call(conn, [])
      assert conn.status == 400
    end
  end

  test "get with error report", state do
    Repo.insert(%ProxyConfiguration{project_id: state[:project_id], target_base_url: "https://pokeapi.co/api/v2"})

    use_cassette "json_get_error" do
      assert Repo.aggregate(Report, :count, :id) == 0

      conn = conn(:get, "/projects/#{state[:project_id]}/proxy/pokemon/0")
      |> put_req_header("content-type", "application/json")
      conn = PericlesProxy.Router.call(conn, [])
      assert conn.status == 404
    end

    report = Repo.one(from r in Report, order_by: [desc: r.id], limit: 1)
    assert report
    assert report.project_id == state[:project_id]
    assert report.request_method == "GET"
    assert report.response_status_code == 404
  end

  test "get without ssl", state do
    Repo.insert(%ProxyConfiguration{project_id: state[:project_id], target_base_url: "https://expired.badssl.com/", ignore_ssl: true})

    use_cassette "get_without_ssl" do
      conn = conn(:get, "/projects/#{state[:project_id]}/proxy/")
      conn = PericlesProxy.Router.call(conn, [])
      assert conn.status == 200
    end
  end

  test "get with array in headers", state do
    Repo.insert(%ProxyConfiguration{project_id: state[:project_id], target_base_url: "https://jesuismachiniste-develop.herokuapp.com/"})

    use_cassette "get_with_array_in_headers" do
      conn = conn(:get, "/projects/#{state[:project_id]}/proxy/login")
      conn = PericlesProxy.Router.call(conn, [])
      assert conn.status == 200
    end
  end
end
