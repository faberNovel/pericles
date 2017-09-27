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
end