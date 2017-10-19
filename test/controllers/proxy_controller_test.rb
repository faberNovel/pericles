require 'test_helper'

class ProxyControllerTest < ActionDispatch::IntegrationTest

  test "should proxy get example.com" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('proxy_example', match_requests_on: [:method, :uri]) do
      get "/projects/#{project.id}/proxy/index.html"
    end
  end

  test "should proxy get example.com with query string" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('proxy_example_querystring', match_requests_on: [:uri]) do
      get "/projects/#{project.id}/proxy/index.html?arg1=value1"
    end
  end

  test "should proxy post example.com" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('post_proxy_example', match_requests_on: [:method, :uri]) do
      post "/projects/#{project.id}/proxy/index.html"
    end
  end

  test "should proxy post example.com with body" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('post_proxy_example_body', match_requests_on: [:body]) do
      post "/projects/#{project.id}/proxy/index.html", params: { root_key: 'value' }
    end
  end

  test "should proxy post example.com with correct headers" do
    project = create(:project, server_url: 'http://example.com/', id: 166)
    VCR.use_cassette('post_proxy_example_headers', match_requests_on: [:headers]) do
      post "/projects/#{project.id}/proxy/index.html", params: { root_key: 'value' }, as: :json
    end
  end

  test "should receive response" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('proxy_example_response') do
      get "/projects/#{project.id}/proxy/index.html"
    end
    assert_equal 418, response.status
    assert_equal '<!doctype html><html>Hello !</html>', response.body
    assert_equal '"359670651+gzip+ident"', response.headers['Etag']
  end

  test "should not proxy Transfer-Encoding" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('proxy_example') do
      get "/projects/#{project.id}/proxy/index.html"
    end
    assert_not response.headers['Transfer-Encoding']
  end

  test "should follow redirection" do
    project = create(:project, server_url: 'https://pokeapi.co/api/v2/')
    VCR.use_cassette('proxy_example_redirection') do
      get "/projects/#{project.id}/proxy/pokemon"
    end
    assert_equal 200, response.status
    assert_match(/{"count".*/, response.body)
  end

  test "should validate correct response" do
    project = create(:full_project)

    VCR.use_cassette('correct_full_project') do
      get "/projects/#{project.id}/proxy/users/1"
    end
    assert_not response.headers['X-Pericles-Report']
  end


  test "should not validate missing header" do
    project = create(:full_project)

    VCR.use_cassette('missing_header_full_project') do
      get "/projects/#{project.id}/proxy/users/1"
    end
    assert response.headers['X-Pericles-Report']
  end


  test "should not validate wrong status" do
    project = create(:full_project)

    VCR.use_cassette('wrong_status_full_project') do
      get "/projects/#{project.id}/proxy/users/1"
    end
    assert response.headers['X-Pericles-Report']
  end


  test "should not validate wrong body" do
    project = create(:full_project)

    VCR.use_cassette('wrong_body_full_project') do
      get "/projects/#{project.id}/proxy/users/1"
    end
    assert response.headers['X-Pericles-Report']
  end

  test "save report with error" do
    project = create(:full_project)

    assert_difference 'Report.all.select(&:errors?).count' do
      VCR.use_cassette('wrong_body_full_project') do
        get "/projects/#{project.id}/proxy/users/1"
      end
    end
  end

  test "save report with no error" do
    project = create(:full_project)

    assert_difference 'Report.all.select(&:correct?).count' do
      VCR.use_cassette('correct_full_project') do
        get "/projects/#{project.id}/proxy/users/1"
      end
    end
  end
end
