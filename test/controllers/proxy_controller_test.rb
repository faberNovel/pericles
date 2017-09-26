require 'test_helper'

class ProxyControllerTest < ActionDispatch::IntegrationTest

  test "should proxy to example.com" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('proxy_example', match_requests_on: [:uri]) do
      get "/projects/#{project.id}/proxy/index.html"
    end
  end

  test "should proxy to example.com with query string" do
    project = create(:project, server_url: 'http://example.com/')
    VCR.use_cassette('proxy_example_querystring', match_requests_on: [:uri]) do
      get "/projects/#{project.id}/proxy/index.html?arg1=value1"
    end
  end

end