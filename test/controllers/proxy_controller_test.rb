require 'test_helper'

class ProxyControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = create(:full_project)
  end

  test "should proxy get example.com" do
    @project.proxy_configuration.update(target_base_url: 'http://example.com/')
    VCR.use_cassette('proxy_example', match_requests_on: [:method, :uri]) do
      get "/projects/#{@project.id}/proxy/index.html"
    end
  end

  test "should proxy get example.com with query string" do
    @project.proxy_configuration.update(target_base_url: 'http://example.com/')
    VCR.use_cassette('proxy_example_querystring', match_requests_on: [:uri]) do
      get "/projects/#{@project.id}/proxy/index.html?arg1=value1"
    end
  end

  test "should proxy post example.com" do
    @project.proxy_configuration.update(target_base_url: 'http://example.com/')
    VCR.use_cassette('post_proxy_example', match_requests_on: [:method, :uri]) do
      post "/projects/#{@project.id}/proxy/index.html"
    end
  end

  test "should proxy post example.com with body" do
    @project.proxy_configuration.update(target_base_url: 'http://example.com/')
    VCR.use_cassette('post_proxy_example_body', match_requests_on: [:body]) do
      post "/projects/#{@project.id}/proxy/index.html", params: { root_key: 'value' }
    end
  end

  test "should proxy post example.com with correct headers" do
    @project = create(:full_project, id: 166)
    @project.proxy_configuration.update(target_base_url: 'http://example.com/')
    VCR.use_cassette('post_proxy_example_headers', match_requests_on: [:headers]) do
      post "/projects/#{@project.id}/proxy/index.html", params: { root_key: 'value' }, as: :json
    end
  end

  test "should receive response" do
    @project.proxy_configuration.update(target_base_url: 'http://example.com/')
    VCR.use_cassette('proxy_example_response') do
      get "/projects/#{@project.id}/proxy/index.html"
    end
    assert_equal 418, response.status
    assert_equal '<!doctype html><html>Hello !</html>', response.body
    assert_equal '"359670651+gzip+ident"', response.headers['Etag']
  end

  test "should not proxy Transfer-Encoding" do
    @project.proxy_configuration.update(target_base_url: 'http://example.com/')
    VCR.use_cassette('proxy_example') do
      get "/projects/#{@project.id}/proxy/index.html"
    end
    assert_not response.headers['Transfer-Encoding']
  end

  test "should follow redirection" do
    @project.proxy_configuration.update(target_base_url: 'https://pokeapi.co/api/v2/')
    VCR.use_cassette('proxy_example_redirection') do
      get "/projects/#{@project.id}/proxy/pokemon"
    end
    assert_equal 200, response.status
    assert_match('"count":811', response.body)
  end

  test "should validate correct response" do
    VCR.use_cassette('correct_full_project') do
      get "/projects/#{@project.id}/proxy/users/1"
    end
    assert_not response.headers['X-Pericles-Report']
  end

  test "should not validate missing header" do
    VCR.use_cassette('missing_header_full_project') do
      get "/projects/#{@project.id}/proxy/users/1"
    end
    assert response.headers['X-Pericles-Report']
  end

  test "should not validate wrong status" do
    VCR.use_cassette('wrong_status_full_project') do
      get "/projects/#{@project.id}/proxy/users/1"
    end
    assert response.headers['X-Pericles-Report']
  end


  test "should not validate wrong body" do
    VCR.use_cassette('wrong_body_full_project') do
      get "/projects/#{@project.id}/proxy/users/1"
    end
    assert response.headers['X-Pericles-Report']
  end

  test "save report with error" do
    assert_difference 'Report.all.select(&:errors?).count' do
      VCR.use_cassette('wrong_body_full_project') do
        get "/projects/#{@project.id}/proxy/users/1"
      end
    end
  end

  test "save report with no error" do
    assert_difference 'Report.all.select(&:correct?).count' do
      VCR.use_cassette('correct_full_project') do
        get "/projects/#{@project.id}/proxy/users/1"
      end
    end
  end

  test "should proxy special character URI" do
    VCR.use_cassette('correct_full_project_with_special_uri', match_requests_on: [:uri]) do
      get ActionDispatch::Journey::Router::Utils::escape_path("/projects/#{@project.id}/proxy/users/<135>-<01>-<30-10-2017>-<60234>-<V17>-<103>")
    end
  end

  test "should find route with special character" do
    route = @project.routes.first
    route.update(url: '/users/:uuid')
    VCR.use_cassette('correct_full_project_with_special_uri') do
      assert_difference 'Report.where(route: route).count' do
        get ActionDispatch::Journey::Router::Utils::escape_path("/projects/#{@project.id}/proxy/users/<135>-<01>-<30-10-2017>-<60234>-<V17>-<103>")
      end
    end
  end

  test "should find root route (/)" do
    route = @project.routes.first
    route.update(url: '/')
    VCR.use_cassette('correct_full_project_root_url', match_requests_on: [:uri]) do
      assert_difference 'Report.where(route: route).count' do
        get "/projects/#{@project.id}/proxy/"
      end
    end
  end

  test "should proxy gzip compression" do
    @project.proxy_configuration.update(target_base_url: 'https://pokeapi.co/api/v2/')
    route = @project.routes.first
    route.update(url: '/berry/')

    VCR.use_cassette('gzip_content_encoding') do
      get "/projects/#{@project.id}/proxy/berry/", headers: { "Accept-Encoding" => "gzip" }
    end

    report = Report.order(created_at: :desc).first
    assert_match '"count"', report.response_body
    assert_equal 'gzip', report.response_headers['Content-Encoding']
    assert_no_match '"count"', response.body
    assert_equal 'gzip', response.headers['Content-Encoding']
  end

  test "should create report only if Content-Type is application/json" do
    @project.proxy_configuration.update(target_base_url: 'https://prismic-io.s3.amazonaws.com/fabernoveltechnologies')
    route = @project.routes.first
    route.update(url: '/:path')

    VCR.use_cassette('fabernovel_img') do
      assert_no_difference 'Report.count' do
        get "/projects/#{@project.id}/proxy/07787ae5d8730f259c1f37ca2b6c601f68644ce2_logo.png"
      end
    end
  end

  test "should create report with error if no schema and body is not empty" do
    response = @project.routes.first.responses.first
    response.update(resource_representation_id: nil)
    assert_nil response.json_schema

    VCR.use_cassette('correct_full_project') do
      assert_difference 'Report.all.select(&:errors?).count' do
        get "/projects/#{@project.id}/proxy/users/1"
      end
    end
  end

  test "should not create report with error if no schema and body is empty" do
    response = @project.routes.first.responses.first
    response.update(resource_representation_id: nil)
    assert_nil response.json_schema

    VCR.use_cassette('full_project_empty_body') do
      assert_no_difference 'Report.all.select(&:errors?).count' do
        get "/projects/#{@project.id}/proxy/users/1"
      end
    end
  end
end
